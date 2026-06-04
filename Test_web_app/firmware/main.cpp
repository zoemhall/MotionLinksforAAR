// XIAO nRF52840 Sense Plus — Insole firmware (flash-buffer + post-session dump)
//
// Flash one of these onto each insole microcontroller. Change DEVICE_NAME
// below to "Insole_L" for the left one and "Insole_R" for the right one.
//
// Behaviour:
//   - Advertises as DEVICE_NAME, accepts one BLE central connection
//     (Max/MSP connects for real-time pressure → audio, unchanged).
//   - Streams "toe heel\n" pressure values over BLE UART at 50 Hz to whoever
//     is connected (Max).
//   - Independently logs IMU + pressure to internal flash (binary format)
//     while BLE is connected. Each connect wipes the previous log.
//   - Detects sync-pulse stamps automatically from accelerometer magnitude
//     (>4g threshold) and tags those samples with phase=9.
//   - LED on while logging, off otherwise.
//   - USB CDC serial command interface (port: /dev/cu.usbmodem*, 921600 baud):
//        INFO\n   → prints firmware status
//        DUMP\n   → streams all logged samples as 10-field CSV (decoded)
//                   followed by a final "EOF" line
//        CLEAR\n  → wipes the flash log and replies "CLEARED"
//
// Storage:
//   - Binary, 22 bytes per sample. Internal flash (~1 MB on nRF52840) holds
//     ~45,000 samples ≈ 15 minutes at 50 Hz. Session is 12 minutes, so there
//     is headroom.
//
// Dependencies (PlatformIO platformio.ini):
//   lib_deps =
//     adafruit/Adafruit nRF52 Bluefruit Library
//     adafruit/Adafruit LittleFS
//     seeed-studio/Seeed Arduino LSM6DS3
//
// Pin map:
//   A0 = toe FSR
//   A1 = heel FSR
//   LED = built-in (status indicator)

#include <Arduino.h>
#include <bluefruit.h>
#include <Adafruit_LittleFS.h>
#include <InternalFileSystem.h>
#include <LSM6DS3.h>
#include <Wire.h>
#include <math.h>

// ── CHANGE THIS PER INSOLE ──────────────────────────────────────────────────
#define DEVICE_NAME "Insole_R"   // "Insole_L" on the other XIAO
// ────────────────────────────────────────────────────────────────────────────

#define LOG_FILENAME "/imu.bin"
#define IMU_I2C_ADDR 0x6A         // LSM6DS3TR-C default

// Sampling
const int      SAMPLE_INTERVAL_MS = 20;   // 50 Hz
const int      TOE_PIN            = A0;
const int      HEEL_PIN           = A1;

// Sync-pulse auto-detect (foot stomp)
const float    SYNC_ACCEL_G_THRESHOLD = 4.0f;
const uint32_t SYNC_DEBOUNCE_MS       = 1500;  // suppress repeats

// Buffer 1 second of data in RAM before flushing to flash, to reduce wear
// and avoid blocking the sample loop on flash writes.
const size_t   FLUSH_EVERY_BYTES  = 1024;       // ~46 samples (~920ms)

// Binary record layout (22 bytes, packed)
struct __attribute__((packed)) Sample {
  uint32_t device_ms;       // millis() at time of sample
  int16_t  ax, ay, az;      // accel × 1000 (mg)
  int16_t  gx, gy, gz;      // gyro  × 10   (deci-dps)
  uint16_t toe, heel;       // raw ADC 0–1023
  uint8_t  phase;           // 0 = normal, 9 = sync pulse
  uint8_t  _pad;
};

static_assert(sizeof(Sample) == 22, "Sample must be exactly 22 bytes");

// Globals
LSM6DS3                                 imu(I2C_MODE, IMU_I2C_ADDR);
BLEUart                                 bleuart;
Adafruit_LittleFS_Namespace::File       logFile(InternalFS);

uint32_t  lastSampleTime    = 0;
uint32_t  lastSyncTime      = 0;
bool      logging           = false;
uint32_t  samplesWritten    = 0;

uint8_t   ramBuffer[FLUSH_EVERY_BYTES];
size_t    ramBufferUsed     = 0;

// ── BLE setup ───────────────────────────────────────────────────────────────

void startAdvertising() {
  Bluefruit.Advertising.addFlags(BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE);
  Bluefruit.Advertising.addTxPower();
  Bluefruit.Advertising.addService(bleuart);
  Bluefruit.ScanResponse.addName();
  Bluefruit.Advertising.restartOnDisconnect(true);
  Bluefruit.Advertising.setInterval(32, 244);
  Bluefruit.Advertising.start(0);
}

void flushRamBuffer() {
  if (ramBufferUsed == 0 || !logFile) return;
  logFile.write(ramBuffer, ramBufferUsed);
  ramBufferUsed = 0;
}

void onConnect(uint16_t conn_handle) {
  (void)conn_handle;
  // Wipe previous log on each new connection — assumes a fresh session is starting.
  flushRamBuffer();
  if (logFile) logFile.close();
  if (InternalFS.exists(LOG_FILENAME)) InternalFS.remove(LOG_FILENAME);
  logFile.open(LOG_FILENAME, Adafruit_LittleFS_Namespace::FILE_O_WRITE);
  logging        = logFile.operator bool();
  samplesWritten = 0;
  digitalWrite(LED_BUILTIN, logging ? HIGH : LOW);
}

void onDisconnect(uint16_t conn_handle, uint8_t reason) {
  (void)conn_handle; (void)reason;
  flushRamBuffer();
  if (logFile) logFile.close();
  logging = false;
  digitalWrite(LED_BUILTIN, LOW);
}

// ── USB CDC commands ────────────────────────────────────────────────────────

void streamDump() {
  // Header line so the host parser knows the format.
  Serial.println("device_ms,ax,ay,az,gx,gy,gz,toe,heel,phase");

  if (!InternalFS.exists(LOG_FILENAME)) {
    Serial.println("EOF");
    return;
  }

  // If still logging, flush RAM buffer first so the dump includes all samples.
  flushRamBuffer();

  Adafruit_LittleFS_Namespace::File reader(InternalFS);
  if (!reader.open(LOG_FILENAME, Adafruit_LittleFS_Namespace::FILE_O_READ)) {
    Serial.println("EOF");
    return;
  }

  Sample s;
  char line[120];
  while (reader.read((uint8_t*)&s, sizeof(s)) == sizeof(s)) {
    // Convert back to float-friendly units in CSV (g and dps).
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
    Serial.print("logging=");      Serial.println(logging ? "yes" : "no");
    Serial.print("samples=");      Serial.println(samplesWritten);
    Serial.print("connected=");    Serial.println(Bluefruit.connected() ? "yes" : "no");
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

// ── Setup + loop ────────────────────────────────────────────────────────────

void setup() {
  Serial.begin(921600);
  // Don't block waiting for serial — the insole runs without USB connected.
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

void loop() {
  handleSerialCommand();

  uint32_t now = millis();
  if (now - lastSampleTime < (uint32_t)SAMPLE_INTERVAL_MS) return;
  lastSampleTime = now;

  // ── Read sensors ──
  float fax = imu.readFloatAccelX();
  float fay = imu.readFloatAccelY();
  float faz = imu.readFloatAccelZ();
  float fgx = imu.readFloatGyroX();
  float fgy = imu.readFloatGyroY();
  float fgz = imu.readFloatGyroZ();
  uint16_t toe  = analogRead(TOE_PIN);
  uint16_t heel = analogRead(HEEL_PIN);

  // ── Sync pulse auto-detect (high-magnitude foot stomp) ──
  uint8_t phase = 0;
  float mag = sqrtf(fax*fax + fay*fay + faz*faz);
  if (mag > SYNC_ACCEL_G_THRESHOLD && (now - lastSyncTime) > SYNC_DEBOUNCE_MS) {
    phase        = 9;
    lastSyncTime = now;
  }

  // ── Send pressure to whoever is BLE-connected (Max owns this stream) ──
  if (Bluefruit.connected()) {
    bleuart.print(toe);
    bleuart.print(" ");
    bleuart.println(heel);
  }

  // ── Append binary sample to RAM buffer; flush to flash periodically ──
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
