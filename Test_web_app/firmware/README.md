# Insole Firmware

XIAO nRF52840 Sense Plus firmware for the gait study. Replaces the
pressure-only sketch with one that also reads the LSM6DS3 IMU and logs
everything to internal flash for post-session retrieval.

## What it does

- Advertises as `Insole_L` or `Insole_R` (set in `main.cpp` per device).
- Streams `"toe heel\n"` to whoever is BLE-connected (Max/MSP) at 50 Hz —
  identical to the previous firmware, so the existing Max bridge keeps
  working unchanged.
- Independently samples the IMU + pressure at 50 Hz and writes a binary log
  (22 bytes per sample) to internal flash whenever a BLE connection is open.
- Each new BLE connect wipes the previous log (one log per session).
- Auto-tags samples with `phase = 9` when a high-g foot stomp is detected
  (>4 g, with a 1.5 s debounce) — the sync pulse for IMU↔pressure alignment.

## Flash + USB dump protocol

Plug the insole into the laptop via USB-C; it appears as a CDC serial port
(`/dev/cu.usbmodem*` on macOS) at 921600 baud. Send these single-line
commands followed by `\n`:

| Command | Reply |
|---|---|
| `INFO` | `device_name=...`, `logging=...`, `samples=...`, `connected=...` |
| `DUMP` | CSV header line, then one line per sample, then `EOF` |
| `CLEAR` | wipes the log, replies `CLEARED` |

The dump format is the standard 10-field CSV that this app's parser already
understands:

```
device_ms,ax,ay,az,gx,gy,gz,toe,heel,phase
```

## Build + flash (PlatformIO)

```bash
cd firmware
pio run                  # build
pio run -t upload        # build + flash via the bootloader
pio device monitor -b 921600   # open serial monitor for debugging
```

Edit `DEVICE_NAME` in `main.cpp` between flashes — set it to `"Insole_L"`
for the left XIAO and `"Insole_R"` for the right XIAO.

## LED status

- **Solid on** while logging (BLE connected, sampling actively).
- **Off** when no BLE connection (firmware idle).

A glance at the LED tells you whether each insole is currently recording.

## Capacity

- 50 Hz × 22 bytes = 1.1 KB/s
- Internal flash holds ~1 MB of LittleFS data → ~15 minutes per session
- A 12-min session uses ~800 KB, leaving headroom.

If sessions ever run longer than ~14 minutes, switch the file system over to
the 2 MB external QSPI flash on the Sense Plus.
