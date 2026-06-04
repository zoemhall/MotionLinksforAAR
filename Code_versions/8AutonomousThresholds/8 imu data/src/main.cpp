// ─────────────────────────────────────────────────────────────────────────────
// main.cpp — Pressure Insole Firmware
// Target: Seeed XIAO nRF52840 Sense Plus
//
// Storage: raw QSPI flash — no filesystem layer (no FAT, no LittleFS)
//   Writing directly to flash addresses eliminates all filesystem overhead and
//   the FAT32 "card too small" / LittleFS mount failures that blocked logging.
//
//   Layout: samples written sequentially from address 0.
//   Capacity: 2,097,152 bytes ÷ 22 bytes/sample = 95,325 samples
//             = 953 s ≈ 15.9 min at 100Hz
//
//   On startup, findWritePosition() scans forward in 22-byte steps to find
//   the first all-0xFF record (erased flash) — this is the append point.
//   Survives power cycles: plug back in, BLE reconnects, logging resumes
//   from exactly where it left off.
//
//   CLEAR command erases the whole chip (~15-30s). Must be run between
//   sessions once flash is full, or whenever you want to start fresh.
//
// platformio.ini lib_deps needed:
//   seeed-studio/Seeed Arduino LSM6DS3
//   adafruit/Adafruit SPIFlash
//   (SdFat - Adafruit Fork no longer needed)
// ─────────────────────────────────────────────────────────────────────────────

#include <Adafruit_SPIFlash.h>
#include <Arduino.h>
#include <LSM6DS3.h>
#include <Wire.h>
#include <bluefruit.h>
#include <math.h>

// ── CHANGE THIS PER INSOLE ───────────────────────────────────────────────────
#define DEVICE_NAME "Insole_L"
// ────────────────────────────────────────────────────────────────────────────

#define IMU_I2C_ADDR 0x6A

// ── Sampling ─────────────────────────────────────────────────────────────────
const int SAMPLE_INTERVAL_MS = 10; // 100 Hz

const int TOE_PIN  = A0;
const int HEEL_PIN = A1;

// ── Sync-pulse auto-detect ────────────────────────────────────────────────────
const float    SYNC_ACCEL_G_THRESHOLD = 4.0f;
const uint32_t SYNC_DEBOUNCE_MS       = 1500;

// ── Write buffer ──────────────────────────────────────────────────────────────
// One flash page (256 bytes) is drained per loop cycle from a 2200-byte RAM
// buffer. This keeps every individual flash.writeBuffer() call to a single
// page-program operation (~0.4–3 ms on P25Q16H), which fits inside the 10 ms
// sample window with no dropped samples.
//
// Previous design flushed 1024 bytes every 100 samples — that blocked the loop
// for ~60 ms each time and dropped ~5 samples per flush (~84% loss rate).
//
// Two-page linear buffer: fill appends 22-byte samples, drain writes one
// 256-byte page per loop cycle. After each drain, memmove shifts the
// remainder to offset 0 — at most ~22 bytes, takes ~1 µs on nRF52840.
const size_t RAM_BUFFER_BYTES = 512;  // 2 flash pages — always sufficient
const size_t FLASH_PAGE_BYTES = 256;    // one page program per drain call

// ── Binary IMU record — written to flash ─────────────────────────────────────
// 22 bytes packed. Erased flash = 0xFF throughout, so an all-0xFF record
// means "no data here" and is used as the end-of-data sentinel by DUMP and
// findWritePosition().
struct __attribute__((packed)) Sample {
  uint32_t device_ms;      // millis() — 0xFFFFFFFF means erased, never written
  int16_t  ax, ay, az;     // accel × 1000 (milli-g)
  int16_t  gx, gy, gz;     // gyro  × 10   (deci-dps)
  uint16_t toe, heel;      // raw ADC 0–1023
  uint8_t  phase;          // 0 = normal, 9 = sync pulse
  uint8_t  _pad;
};
static_assert(sizeof(Sample) == 22, "Sample must be exactly 22 bytes");

// ── Binary BLE packet — sent over BLE only ───────────────────────────────────
// 9 bytes packed.
// [0–3] device_ms  uint32 big-endian
// [4–5] toe        uint16 big-endian
// [6–7] heel       uint16 big-endian
// [8]   seq        uint8  rolling 0–255
struct __attribute__((packed)) BLEPacket {
  uint8_t ts3, ts2, ts1, ts0;
  uint8_t toe_hi,  toe_lo;
  uint8_t heel_hi, heel_lo;
  uint8_t seq;
};
static_assert(sizeof(BLEPacket) == 9, "BLEPacket must be exactly 9 bytes");

// ── QSPI flash chip descriptor ────────────────────────────────────────────────
// The XIAO nRF52840 Sense Plus uses a Puya P25Q16H (2MB) which is not in
// Adafruit's default flash_devices.h list — flash.begin() returns false and
// flashCapacity stays 0 without this. Passing the descriptor explicitly lets
// the library match on JEDEC ID (0x85/0x60/0x15) and set correct parameters.
static const SPIFlash_Device_t P25Q16H_DESC[] = {{
  .total_size              = (1UL << 21), // 2 MiB
  .start_up_time_us        = 5000,
  .manufacturer_id         = 0x85,        // Puya Semiconductor
  .memory_type             = 0x60,
  .capacity                = 0x15,
  .max_clock_speed_mhz     = 32,          // conservative; chip supports 104MHz
  .quad_enable_bit_mask    = 0x02,        // bit 1 of status register 2
  .has_sector_protection   = false,
  .supports_fast_read      = true,
  .supports_qspi           = true,
  .supports_qspi_writes    = true,
  .write_status_register_split = false,
  .single_status_byte      = false,
  .is_fram                 = false,
}};

// ── Globals ───────────────────────────────────────────────────────────────────
LSM6DS3 imu(I2C_MODE, IMU_I2C_ADDR);
BLEUart bleuart;

Adafruit_FlashTransport_QSPI flashTransport;
Adafruit_SPIFlash              flash(&flashTransport);

bool     flashReady     = false;
uint32_t flashCapacity  = 0;   // flash.size() — set in setup()
uint32_t flashWriteAddr = 0;   // next byte address to write to

uint32_t lastSampleTime = 0;
uint32_t lastSyncTime   = 0;
bool     logging        = false;
uint32_t samplesWritten = 0;   // session counter; low byte = BLE seq

// Linear RAM buffer — ramUsed tracks bytes currently in buffer.
// After each page drain, memmove shifts remainder to offset 0,
// keeping all arithmetic simple and eliminating modulo wrapping bugs.
uint8_t  ramBuffer[RAM_BUFFER_BYTES];
uint16_t ramUsed = 0; // bytes currently occupied (always ≤ RAM_BUFFER_BYTES)


// ── Find where to resume writing after a power cycle ─────────────────────────
// Scans forward in 22-byte steps. The first record whose device_ms == 0xFFFFFFFF
// is erased flash — that's the append point. Runs once at startup.
// Worst case (full chip): reads 2MB in ~0.5 s over QSPI.
uint32_t findWritePosition() {
  uint32_t addr = 0;
  uint8_t  buf[sizeof(Sample)];
  while (addr + sizeof(Sample) <= flashCapacity) {
    flash.readBuffer(addr, buf, sizeof(Sample));
    // device_ms is the first 4 bytes; 0xFFFFFFFF = erased
    uint32_t ms;
    memcpy(&ms, buf, sizeof(ms));
    if (ms == 0xFFFFFFFF) break;
    addr += sizeof(Sample);
  }
  return addr;
}

// ── BLE advertising ───────────────────────────────────────────────────────────
void startAdvertising() {
  Bluefruit.Advertising.addFlags(BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE);
  Bluefruit.Advertising.addTxPower();
  Bluefruit.Advertising.addService(bleuart);
  Bluefruit.ScanResponse.addName();
  Bluefruit.Advertising.restartOnDisconnect(true);
  Bluefruit.Advertising.setInterval(32, 244);
  Bluefruit.Advertising.start(0);
}

// ── Flash write helpers ───────────────────────────────────────────────────────

// drainOnePage() — called every loop iteration.
// Writes one 256-byte page when enough data has accumulated, then
// memmoves the remainder to offset 0. Measured write time: ≤1954 µs.
void drainOnePage() {
  if (!flashReady || ramUsed < FLASH_PAGE_BYTES) return;

  if (flashWriteAddr + FLASH_PAGE_BYTES > flashCapacity) {
    logging = false;
    Serial.println("WARN: flash full — logging stopped. Run CLEAR.");
    return;
  }

  flash.writeBuffer(flashWriteAddr, ramBuffer, FLASH_PAGE_BYTES);
  flashWriteAddr += FLASH_PAGE_BYTES;
  ramUsed        -= FLASH_PAGE_BYTES;
  if (ramUsed > 0) memmove(ramBuffer, ramBuffer + FLASH_PAGE_BYTES, ramUsed);
}


// flushRemainder() — called on disconnect or before DUMP.
// Writes any bytes that have not yet filled a full page.
void flushRemainder() {
  if (!flashReady || ramUsed == 0) return;

  if (flashWriteAddr + ramUsed > flashCapacity) {
    logging = false;
    return;
  }

  flash.writeBuffer(flashWriteAddr, ramBuffer, ramUsed);
  flashWriteAddr += ramUsed;
  ramUsed         = 0;
}








// ── BLE callbacks ─────────────────────────────────────────────────────────────
void onConnect(uint16_t conn_handle) {
  BLEConnection *conn = Bluefruit.Connection(conn_handle);
  conn->requestConnectionParameter(6, 12, 0); // 7.5–15ms, macOS clamps to 15ms

  if (!flashReady) {
    Serial.println("WARN: flash not ready — logging disabled.");
    return;
  }

  if (flashWriteAddr >= flashCapacity) {
    Serial.println("WARN: flash full — run CLEAR before next session.");
    return;
  }

  // samplesWritten intentionally NOT reset — BLE seq counter rolls continuously.
  ramUsed = 0;
  logging = true;

  logging = true;
  digitalWrite(LED_BUILTIN, HIGH);
  Serial.print("Logging started at flash addr ");
  Serial.println(flashWriteAddr);
}

void onDisconnect(uint16_t conn_handle, uint8_t reason) {
  (void)conn_handle;
  (void)reason;
  flushRemainder(); // write any bytes not yet page-flushed
  logging = false;
  digitalWrite(LED_BUILTIN, LOW);
  Serial.print("Logging stopped. Flash addr ");
  Serial.print(flashWriteAddr);
  Serial.print(" / ");
  Serial.println(flashCapacity);
}

// ── USB CDC commands ──────────────────────────────────────────────────────────
void streamDump() {
  Serial.println("device_ms,ax,ay,az,gx,gy,gz,toe,heel,phase");

  if (!flashReady) {
    Serial.println("ERR: flash not ready");
    Serial.println("EOF");
    return;
  }

  flushRemainder(); // commit any un-paged bytes before reading back

  if (flashWriteAddr == 0) {
    Serial.println("NO_DATA: flash is empty (run CLEAR then record a session)");
    Serial.println("EOF");
    return;
  }

  uint8_t  buf[sizeof(Sample)];
  Sample   s;
  char     line[120];
  uint32_t addr = 0;

  while (addr + sizeof(Sample) <= flashWriteAddr) {
    flash.readBuffer(addr, buf, sizeof(Sample));
    memcpy(&s, buf, sizeof(s));
    if (s.device_ms == 0xFFFFFFFF) break; // hit erased region — stop
    snprintf(line, sizeof(line),
             "%lu,%.3f,%.3f,%.3f,%.1f,%.1f,%.1f,%u,%u,%u",
             (unsigned long)s.device_ms,
             s.ax / 1000.0f, s.ay / 1000.0f, s.az / 1000.0f,
             s.gx /   10.0f, s.gy /   10.0f, s.gz /   10.0f,
             s.toe, s.heel, s.phase);
    Serial.println(line);
    addr += sizeof(Sample);
  }
  Serial.println("EOF");
}

void handleSerialCommand() {
  if (!Serial.available()) return;
  String cmd = Serial.readStringUntil('\n');
  cmd.trim();

  if (cmd == "INFO") {
    uint32_t storedSamples = flashWriteAddr / sizeof(Sample);
    uint32_t maxSamples    = flashCapacity  / sizeof(Sample);
    Serial.print("device_name=");     Serial.println(DEVICE_NAME);
    Serial.print("sample_hz=");       Serial.println(1000 / SAMPLE_INTERVAL_MS);
    Serial.print("flash_ready=");     Serial.println(flashReady ? "yes" : "no");
    Serial.print("logging=");         Serial.println(logging    ? "yes" : "no");
    Serial.print("connected=");       Serial.println(Bluefruit.connected() ? "yes" : "no");
    Serial.print("samples_stored=");  Serial.println(storedSamples);
    Serial.print("flash_used_bytes=");Serial.println(flashWriteAddr);
    Serial.print("flash_capacity=");  Serial.println(flashCapacity);
    Serial.print("capacity_pct=");    Serial.println(flashCapacity ? (flashWriteAddr * 100 / flashCapacity) : 0);
    Serial.print("max_samples=");     Serial.println(maxSamples);
    Serial.print("max_session_s=");   Serial.println(maxSamples / (1000 / SAMPLE_INTERVAL_MS));

  } else if (cmd == "DUMP") {
    streamDump();

  } else if (cmd == "TIMING") {
    // Measure how long a single 256-byte flash.writeBuffer() actually takes.
    // drainOnePage() runs this every loop cycle — it must complete in <10ms
    // or samples will be dropped. Run this before a real session to confirm.
    //
    // Writes 256 bytes of 0x00 to the first page of flash.
    // WARNING: run CLEAR after TIMING to erase the test data before recording.
    if (!flashReady) { Serial.println("ERR: flash not ready"); return; }

    uint8_t testPage[256];
    memset(testPage, 0x00, sizeof(testPage));

    // Warm up: one dummy read so SPI bus is initialised
    flash.readBuffer(0, testPage, sizeof(testPage));

    // Time 10 consecutive page writes and report each
    Serial.println("Writing 10 pages of 256 bytes, measuring each...");
    uint32_t worst = 0;
    for (int i = 0; i < 10; i++) {
      uint32_t t0 = micros();
      flash.writeBuffer(i * 256, testPage, 256);
      uint32_t elapsed = micros() - t0;
      if (elapsed > worst) worst = elapsed;
      Serial.print("  page ");
      Serial.print(i);
      Serial.print(": ");
      Serial.print(elapsed);
      Serial.println(" us");
    }
    Serial.print("Worst: "); Serial.print(worst); Serial.println(" us");
    Serial.print("Sample window: 10000 us  =>  ");
    Serial.println(worst < 10000 ? "PASS — fits inside 10ms window"
                                 : "FAIL — exceeds 10ms, samples will drop");
    Serial.println("Run CLEAR to erase test data before recording.");

  } else if (cmd == "CLEAR") {
    flushRemainder();
    logging = false;
    samplesWritten = 0;
    ramUsed = 0;
    Serial.println("Erasing flash chip — wait ~30s...");

    flash.eraseChip();
    uint32_t t = millis();
    while (flash.isBusy()) {
      delay(500);
      Serial.write('.');
      if (millis() - t > 60000) { Serial.println("\nERR: erase timeout"); return; }
    }
    flashWriteAddr = 0;
    Serial.println("\nCLEARED. Flash ready for new session.");
  }
}

// ── Setup ─────────────────────────────────────────────────────────────────────
void setup() {
  Serial.begin(921600);
  // Wait up to 8s for the serial monitor to connect after USB CDC enumerates.
  // The disconnect/reconnect cycle on nRF52840 takes ~3-5s, so a fixed 2s
  // delay was not enough — boot messages printed before the monitor was ready.
  // If running standalone (no USB), this times out and continues normally.
  uint32_t _t = millis();
  while (!Serial && millis() - _t < 8000) { delay(10); }

  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);

  imu.begin();

  // Try explicit P25Q16H descriptor first; fall back to auto-detect.
  // The XIAO's Puya P25Q16H isn't in Adafruit's default chip list, so
  // flash.begin() with no args returns false and flashCapacity stays 0.
  bool flashFound = flash.begin(P25Q16H_DESC, 1);
  if (!flashFound) {
    Serial.println("WARN: P25Q16H descriptor failed, trying auto-detect...");
    flashFound = flash.begin();
  }
  if (!flashFound || flash.size() == 0) {
    Serial.println("ERR: QSPI flash chip not found. Check solder joints / board variant.");
  } else {
    flashCapacity = flash.size();
    Serial.print("Flash found. Capacity: ");
    Serial.print(flashCapacity);
    Serial.println(" bytes. Scanning for write position...");

    flashWriteAddr = findWritePosition();
    flashReady     = true;

    Serial.print("Write position: ");
    Serial.print(flashWriteAddr);
    Serial.print(" (");
    Serial.print(flashWriteAddr / sizeof(Sample));
    Serial.println(" samples already stored)");
    Serial.println("Run CLEAR to erase before a new session.");
  }

  Bluefruit.begin();
  Bluefruit.setTxPower(4);
  Bluefruit.setName(DEVICE_NAME);
  Bluefruit.Periph.setConnectCallback(onConnect);
  Bluefruit.Periph.setDisconnectCallback(onDisconnect);

  bleuart.begin();
  startAdvertising();

  Serial.println("Ready. Waiting for BLE connection.");
}

// ── Main loop ─────────────────────────────────────────────────────────────────
void loop() {
  handleSerialCommand();
  drainOnePage(); // write one flash page if ready — runs every loop cycle

  uint32_t now = millis();
  if (now - lastSampleTime < (uint32_t)SAMPLE_INTERVAL_MS)
    return;
  lastSampleTime = now;

  // Read all 6 IMU axes in ONE burst I2C transaction (12 bytes from 0x22).
  // Previously 6 separate readFloat*() calls — each a full I2C transaction.
  // The BLE SoftDevice fires every 15ms and can stall a mid-flight I2C call
  // while it services the radio. 6 interruptions × ~10ms each = ~60ms per
  // sample cycle = the consistent 17Hz effective rate seen in DUMP output.
  // One burst read has only one exposure window, restoring near-100Hz rate.
  //
  // Register map (LSM6DS3, contiguous from 0x22):
  // Burst read all 6 axes in one I2C transaction (12 bytes from register 0x22).
  // Scale factors must match the full-scale range configured by the LSM6DS3
  // library at init time. Seeed's library defaults:
  //   Accel: ±4g  → sensitivity = 0.000122 g/LSB   (NOT ±2g / 0.000061)
  //   Gyro:  ±245dps → sensitivity = 0.00875 dps/LSB
  // Using 0.000061 (±2g) when the chip is in ±4g mode causes all accel
  // readings to be half the correct value (~0.1g instead of ~1g for gravity).
  //
  // Register map (contiguous from 0x22):
  //   0x22-23 gx,  0x24-25 gy,  0x26-27 gz
  //   0x28-29 ax,  0x2A-2B ay,  0x2C-2D az
  uint8_t imuBuf[12];
  imu.readRegisterRegion(imuBuf, 0x22, 12);
  float fgx = (int16_t)(imuBuf[1]  << 8 | imuBuf[0])  * 0.00875f;
  float fgy = (int16_t)(imuBuf[3]  << 8 | imuBuf[2])  * 0.00875f;
  float fgz = (int16_t)(imuBuf[5]  << 8 | imuBuf[4])  * 0.00875f;
  float fax = (int16_t)(imuBuf[7]  << 8 | imuBuf[6])  * 0.000488f;  // ±16g
  float fay = (int16_t)(imuBuf[9]  << 8 | imuBuf[8])  * 0.000488f;
  float faz = (int16_t)(imuBuf[11] << 8 | imuBuf[10]) * 0.000488f;
  uint16_t toe  = analogRead(TOE_PIN);
  uint16_t heel = analogRead(HEEL_PIN);

  // ── Sync pulse ──────────────────────────────────────────────────────────
  uint8_t phase = 0;
  float   mag   = sqrtf(fax * fax + fay * fay + faz * faz);
  if (mag > SYNC_ACCEL_G_THRESHOLD && (now - lastSyncTime) > SYNC_DEBOUNCE_MS) {
    phase        = 9;
    lastSyncTime = now;
  }

  // ── BLE pressure packet ─────────────────────────────────────────────────
  // Gate only on connection. availableForWrite() and notifyEnabled() both
  // return 0/false when the central hasn't subscribed to notifications,
  // silently dropping every packet. bleuart.write() is non-blocking —
  // it returns false immediately if notifications aren't enabled or the
  // FIFO is full, so no extra guard is needed.
  if (Bluefruit.connected()) {
    BLEPacket pkt;
    pkt.ts3     = (now  >> 24) & 0xFF;
    pkt.ts2     = (now  >> 16) & 0xFF;
    pkt.ts1     = (now  >>  8) & 0xFF;
    pkt.ts0     =  now         & 0xFF;
    pkt.toe_hi  = (toe  >>  8) & 0xFF;
    pkt.toe_lo  =  toe         & 0xFF;
    pkt.heel_hi = (heel >>  8) & 0xFF;
    pkt.heel_lo =  heel        & 0xFF;
    pkt.seq     = (uint8_t)(samplesWritten & 0xFF);
    bleuart.write((uint8_t *)&pkt, sizeof(pkt));
  }

  // ── IMU sample → RAM buffer → flash ────────────────────────────────────
  if (logging) {
    Sample s;
    s.device_ms = now;
    s.ax  = (int16_t)constrain(fax * 1000.0f, -32768.0f, 32767.0f);
    s.ay  = (int16_t)constrain(fay * 1000.0f, -32768.0f, 32767.0f);
    s.az  = (int16_t)constrain(faz * 1000.0f, -32768.0f, 32767.0f);
    s.gx  = (int16_t)constrain(fgx *   10.0f, -32768.0f, 32767.0f);
    s.gy  = (int16_t)constrain(fgy *   10.0f, -32768.0f, 32767.0f);
    s.gz  = (int16_t)constrain(fgz *   10.0f, -32768.0f, 32767.0f);
    s.toe  = toe;
    s.heel = heel;
    s.phase = phase;
    s._pad  = 0;

    // Overflow guard — should never trigger given drain >> fill rate.
    if (ramUsed + sizeof(s) > RAM_BUFFER_BYTES) {
      logging = false;
      Serial.println("WARN: RAM buffer overflow — logging stopped.");
    } else {
      memcpy(ramBuffer + ramUsed, &s, sizeof(s));
      ramUsed += sizeof(s);
      samplesWritten++;
    }
  }
}