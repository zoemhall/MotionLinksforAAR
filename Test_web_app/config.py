from pathlib import Path

BASE_DIR = Path(__file__).parent
DATA_DIR = BASE_DIR / "data"
DB_PATH = DATA_DIR / "gait_study.db"

# BLE Nordic UART Service UUIDs
UART_SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
UART_RX_CHAR_UUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"  # write TO device
UART_TX_CHAR_UUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"  # read FROM device

BLE_DEVICE_NAME = "Insole_R"
BLE_CONNECT_TIMEOUT = 15.0  # seconds
IMU_SAMPLE_RATE = 208  # Hz

# Send every Nth sample to browser (~41 FPS at 208 Hz)
WS_DOWNSAMPLE_EVERY = 5

# Gap threshold for dropped-packet detection
PACKET_GAP_THRESHOLD_MS = 20

# CSV flush interval
CSV_FLUSH_EVERY = 100  # rows

# Phase labels (PRD defaults — researcher will adjust)
PHASE_LABELS = {
    0: "Idle",
    1: "Calibration",
    2: "A-Pre",
    3: "A-Drift",
    4: "B-Light",
    5: "B-Heavy",
    6: "Phase 6",
    7: "Phase 7",
    8: "Phase 8",
    9: "Sync Pulse",
}
