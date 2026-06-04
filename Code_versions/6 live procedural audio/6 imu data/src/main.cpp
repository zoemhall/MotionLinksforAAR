// ─────────────────────────────────────────────────────────────────────────────
// main.cpp — Pressure Insole Firmware
// Target: Seeed XIAO nRF52840 Sense Plus
//
// Changes from previous version:
//   1. SAMPLE_INTERVAL_MS reduced 20 → 10ms (50Hz → 100Hz)
//   2. Connection interval requested from peripheral side in onConnect()
//      (peripheral-initiated requests are accepted by macOS; central-side
//       requests via noble were being silently rejected, causing the ~237ms
//       fallback interval you measured)
//   3. BLE payload switched from ASCII ("12345,646,653\r\n" ~17 bytes) to a
//      packed 9-byte binary struct — fits in a single BLE packet, eliminating
//      fragmentation across multiple connection events
//   4. MCU timestamp retained in BLE packet so Node.js can reconstruct accurate
//      per-sample timing even when macOS batches 2–3 samples per connection event
//   5. Rolling sequence counter added to BLE packet — lets ble_bridge.js detect
//      dropped packets without adding overhead to the hot path
//   6. (void)conn_handle removed from onConnect — conn_handle is now used
// ─────────────────────────────────────────────────────────────────────────────

#include <Arduino.h>
#include <bluefruit.h>
#include <Adafruit_LittleFS.h>
#include <InternalFileSystem.h>
#include <LSM6DS3.h>
#include <Wire.h>
#include <math.h>

// ── CHANGE THIS PER INSOLE ───────────────────────────────────────────────────
#define DEVICE_NAME "Insole_L"    // "Insole_L" on the other XIAO
// ────────────────────────────────────────────────────────────────────────────

#define LOG_FILENAME  "/imu.bin"
#define IMU_I2C_ADDR  0x6A        // LSM6DS3TR-C default

// ── Sampling ─────────────────────────────────────────────────────────────────
const int      SAMPLE_INTERVAL_MS = 10;   // 100 Hz — 10ms window gives 4 samples
                                           // across the ~40ms heel-to-toe gap at
                                           // 95 BPM, enough to distinguish events

const int      TOE_PIN            = A0;
const int      HEEL_PIN           = A1;

// ── Sync-pulse auto-detect (foot stomp) ──────────────────────────────────────
const float    SYNC_ACCEL_G_THRESHOLD = 4.0f;
const uint32_t SYNC_DEBOUNCE_MS       = 1500;

// ── Flash write buffer ────────────────────────────────────────────────────────
// Buffer ~1 second of IMU data in RAM before flushing to flash.
// Keeps flash writes off the hot sample path and reduces wear.
// At 100Hz with 22-byte records: ~2200 bytes/sec → flush ~every 1024 bytes.
const size_t   FLUSH_EVERY_BYTES  = 1024;  // ~46 samples (~460ms at 100Hz)

// ── Binary IMU record — written to flash only (not sent over BLE) ────────────
// 22 bytes, packed. Dumped via USB serial on DUMP command after each session.
struct __attribute__((packed)) Sample {
  uint32_t device_ms;       // millis() at sample time
  int16_t  ax, ay, az;      // accel × 1000 (stored as milli-g integers)
  int16_t  gx, gy, gz;      // gyro  × 10   (stored as deci-dps integers)
  uint16_t toe, heel;       // raw ADC 0–1023
  uint8_t  phase;           // 0 = normal, 9 = sync pulse
  uint8_t  _pad;            // alignment padding
};
static_assert(sizeof(Sample) == 22, "Sample must be exactly 22 bytes");

// ── Binary BLE packet — sent over BLE only (not written to flash) ─────────────
// 9 bytes, packed. Replaces the old ASCII "timestamp,toe,heel\r\n" string.
//
// Why binary?
//   ASCII "12345,646,653\r\n" = ~17 bytes → often fragments across 2 BLE packets
//   Binary struct             =   9 bytes → always fits in a single BLE packet
//
// Byte layout:
//   [0–3]  device_ms  uint32 big-endian   MCU timestamp (millis)
//   [4–5]  toe        uint16 big-endian   raw ADC 0–1023
//   [6–7]  heel       uint16 big-endian   raw ADC 0–1023
//   [8]    seq        uint8               rolling counter 0–255, wraps
//                                         — lets ble_bridge.js detect drops
struct __attribute__((packed)) BLEPacket {
  uint8_t ts3, ts2, ts1, ts0;   // device_ms big-endian bytes
  uint8_t toe_hi,  toe_lo;
  uint8_t heel_hi, heel_lo;
  uint8_t seq;
};
static_assert(sizeof(BLEPacket) == 9, "BLEPacket must be exactly 9 bytes");

// ── Globals ───────────────────────────────────────────────────────────────────
LSM6DS3                                 imu(I2C_MODE, IMU_I2C_ADDR);
BLEUart                                 bleuart;
Adafruit_LittleFS_Namespace::File       logFile(InternalFS);

uint32_t  lastSampleTime    = 0;
uint32_t  lastSyncTime      = 0;
bool      logging           = false;
uint32_t  samplesWritten    = 0;   // doubles as BLE sequence counter (low byte used)

uint8_t   ramBuffer[FLUSH_EVERY_BYTES];
size_t    ramBufferUsed     = 0;

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

// ── Flash helpers ─────────────────────────────────────────────────────────────
void flushRamBuffer() {
  if (ramBufferUsed == 0 || !logFile) return;
  logFile.write(ramBuffer, ramBufferUsed);
  ramBufferUsed = 0;
}

// ── BLE connection callbacks ──────────────────────────────────────────────────
void onConnect(uint16_t conn_handle) {
  // Request a short connection interval from the peripheral side.
  //
  // Why from the peripheral?
  //   The central side (noble in ble_bridge.js) was requesting 7.5–15ms but
  //   macOS CoreBluetooth was silently rejecting it and falling back to a
  //   power-saving default (~250ms), which is what caused your ~237ms readings.
  //   Peripheral-initiated requests go through a different negotiation path and
  //   macOS accepts them, clamping to its enforced minimum of ~15ms.
  //
  // Units: multiples of 1.25ms
  //   6  × 1.25ms = 7.5ms  (BLE spec minimum — macOS will clamp to 15ms)
  //   12 × 1.25ms = 15ms   (macOS CoreBluetooth enforced minimum)
  BLEConnection* conn = Bluefruit.Connection(conn_handle);
  conn->requestConnectionParameter(
    6,    // min interval: 7.5ms (macOS clamps to 15ms in practice)
    12,   // max interval: 15ms
    0   // slave latency: no skipping allowed at this sample rate
  );

  // Wipe previous session log — fresh log for each new connection.
  flushRamBuffer();
  if (logFile) logFile.close();
  if (InternalFS.exists(LOG_FILENAME)) InternalFS.remove(LOG_FILENAME);
  logFile.open(LOG_FILENAME, Adafruit_LittleFS_Namespace::FILE_O_WRITE);
  logging        = logFile.operator bool();
  samplesWritten = 0;
  digitalWrite(LED_BUILTIN, logging ? HIGH : LOW);
}

void onDisconnect(uint16_t conn_handle, uint8_t reason) {
  (void)conn_handle;
  (void)reason;
  flushRamBuffer();
  if (logFile) logFile.close();
  logging = false;
  digitalWrite(LED_BUILTIN, LOW);
}

// ── USB CDC commands ──────────────────────────────────────────────────────────
void streamDump() {
  Serial.println("device_ms,ax,ay,az,gx,gy,gz,toe,heel,phase");

  if (!InternalFS.exists(LOG_FILENAME)) {
    Serial.println("EOF");
    return;
  }

  flushRamBuffer();  // include any buffered samples not yet written to flash

  Adafruit_LittleFS_Namespace::File reader(InternalFS);
  if (!reader.open(LOG_FILENAME, Adafruit_LittleFS_Namespace::FILE_O_READ)) {
    Serial.println("EOF");
    return;
  }

  Sample s;
  char line[120];
  while (reader.read((uint8_t*)&s, sizeof(s)) == sizeof(s)) {
    snprintf(line, sizeof(line),
             "%lu,%.3f,%.3f,%.3f,%.1f,%.1f,%.1f,%u,%u,%u",
             (unsigned long)s.device_ms,
             s.ax / 1000.0f, s.ay / 1000.0f, s.az / 1000.0f,
             s.gx / 10.0f,   s.gy / 10.0f,   s.gz / 10.0f,
             s.toe, s.heel, s.phase);
    Serial.println(line);
  }
  reader.close();
  Serial.println("EOF");
}

void handleSerialCommand() {
  if (!Serial.available()) return;
  String cmd = Serial.readStringUntil('\n');
  cmd.trim();

  if (cmd == "INFO") {
    Serial.print("device_name="); Serial.println(DEVICE_NAME);
    Serial.print("sample_hz=");   Serial.println(1000 / SAMPLE_INTERVAL_MS);
    Serial.print("logging=");     Serial.println(logging ? "yes" : "no");
    Serial.print("samples=");     Serial.println(samplesWritten);
    Serial.print("connected=");   Serial.println(Bluefruit.connected() ? "yes" : "no");
  }
  else if (cmd == "DUMP") {
    streamDump();
  }
  else if (cmd == "CLEAR") {
    flushRamBuffer();
    if (logFile) logFile.close();
    if (InternalFS.exists(LOG_FILENAME)) InternalFS.remove(LOG_FILENAME);
    samplesWritten = 0;
    if (Bluefruit.connected()) {
      logFile.open(LOG_FILENAME, Adafruit_LittleFS_Namespace::FILE_O_WRITE);
      logging = logFile.operator bool();
    } else {
      logging = false;
    }
    Serial.println("CLEARED");
  }
}

// ── Setup ─────────────────────────────────────────────────────────────────────
void setup() {
  Serial.begin(921600);
  // Don't block on serial — insole must run without USB connected.
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);

  imu.begin();
  InternalFS.begin();

  Bluefruit.begin();
  Bluefruit.setTxPower(4);
  Bluefruit.setName(DEVICE_NAME);
  Bluefruit.Periph.setConnectCallback(onConnect);
  Bluefruit.Periph.setDisconnectCallback(onDisconnect);

  bleuart.begin();
  startAdvertising();
}

// ── Main loop ─────────────────────────────────────────────────────────────────
void loop() {
  handleSerialCommand();

  uint32_t now = millis();
  if (now - lastSampleTime < (uint32_t)SAMPLE_INTERVAL_MS) return;
  lastSampleTime = now;

  // ── Read sensors ─────────────────────────────────────────────────────────
  float fax = imu.readFloatAccelX();
  float fay = imu.readFloatAccelY();
  float faz = imu.readFloatAccelZ();
  float fgx = imu.readFloatGyroX();
  float fgy = imu.readFloatGyroY();
  float fgz = imu.readFloatGyroZ();
  uint16_t toe  = analogRead(TOE_PIN);
  uint16_t heel = analogRead(HEEL_PIN);

  // ── Sync pulse auto-detect (high-magnitude foot stomp) ───────────────────
  uint8_t phase = 0;
  float mag = sqrtf(fax*fax + fay*fay + faz*faz);
  if (mag > SYNC_ACCEL_G_THRESHOLD && (now - lastSyncTime) > SYNC_DEBOUNCE_MS) {
    phase        = 9;
    lastSyncTime = now;
  }

  // ── Send binary pressure packet over BLE ─────────────────────────────────
  // 9 bytes: [timestamp 4B][toe 2B][heel 2B][seq 1B]
  // Always fits in a single BLE packet — no fragmentation.
  // MCU timestamp is included so ble_bridge.js can recover accurate per-sample
  // timing even when macOS batches multiple samples into one connection event.
  if (Bluefruit.connected()) {
    BLEPacket pkt;
    pkt.ts3     = (now >> 24) & 0xFF;
    pkt.ts2     = (now >> 16) & 0xFF;
    pkt.ts1     = (now >>  8) & 0xFF;
    pkt.ts0     =  now        & 0xFF;
    pkt.toe_hi  = (toe  >> 8) & 0xFF;
    pkt.toe_lo  =  toe        & 0xFF;
    pkt.heel_hi = (heel >> 8) & 0xFF;
    pkt.heel_lo =  heel       & 0xFF;
    pkt.seq     = (uint8_t)(samplesWritten & 0xFF);
    bleuart.write((uint8_t*)&pkt, sizeof(pkt));
  }

  // ── Append binary IMU sample to RAM buffer; flush to flash periodically ──
  // IMU data is NOT sent over BLE — it stays local and is dumped via USB
  // serial after each session using the DUMP command. This keeps IMU off the
  // BLE bandwidth budget entirely.
  if (logging) {
    Sample s;
    s.device_ms = now;
    s.ax        = (int16_t)constrain(fax * 1000.0f, -32768.0f, 32767.0f);
    s.ay        = (int16_t)constrain(fay * 1000.0f, -32768.0f, 32767.0f);
    s.az        = (int16_t)constrain(faz * 1000.0f, -32768.0f, 32767.0f);
    s.gx        = (int16_t)constrain(fgx * 10.0f,   -32768.0f, 32767.0f);
    s.gy        = (int16_t)constrain(fgy * 10.0f,   -32768.0f, 32767.0f);
    s.gz        = (int16_t)constrain(fgz * 10.0f,   -32768.0f, 32767.0f);
    s.toe       = toe;
    s.heel      = heel;
    s.phase     = phase;
    s._pad      = 0;

    if (ramBufferUsed + sizeof(s) > FLUSH_EVERY_BYTES) {
      flushRamBuffer();
    }
    memcpy(ramBuffer + ramBufferUsed, &s, sizeof(s));
    ramBufferUsed += sizeof(s);
    samplesWritten++;
  }
}