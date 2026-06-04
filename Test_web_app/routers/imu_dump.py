"""IMU dump router — pulls flash-logged IMU+pressure data off an insole over USB CDC.

The firmware (firmware/main.cpp) exposes a simple text protocol on the
USB serial port:

    INFO\n   → status info
    DUMP\n   → CSV header line, then sample lines, then "EOF"
    CLEAR\n  → wipes the flash log, replies "CLEARED"

This router opens the serial port via pyserial in a worker thread so the
event loop stays responsive during the (~30-60s) dump.
"""
from __future__ import annotations
import asyncio
from pathlib import Path
from typing import Optional

import serial
import serial.tools.list_ports
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field

from config import DATA_DIR
from db import queries

router = APIRouter()

DEFAULT_BAUD = 921600
SERIAL_TIMEOUT_S = 2.0       # per-line read timeout
DUMP_TOTAL_TIMEOUT_S = 180.0  # whole-dump wall-clock budget


class DumpRequest(BaseModel):
    port: str = Field(min_length=1, description="Serial port path, e.g. /dev/cu.usbmodem1101")
    side: str = Field(pattern=r"^[LR]$", description="Which insole this is — L or R")
    baud: int = DEFAULT_BAUD


class ClearRequest(BaseModel):
    port: str = Field(min_length=1)
    baud: int = DEFAULT_BAUD


@router.get("/ports")
async def list_ports():
    """Return all available USB serial ports.

    The firmware advertises as a CDC device whose name typically contains
    'usbmodem' on macOS or 'COM' on Windows. We don't filter — just return
    everything and let the user pick.
    """
    ports = []
    for p in serial.tools.list_ports.comports():
        ports.append({
            "device": p.device,
            "description": p.description,
            "manufacturer": p.manufacturer or "",
            "serial_number": p.serial_number or "",
        })
    return ports


def _annotate_zones(csv_text: str, side: str, stage_events: list[dict]) -> str:
    """Add 'side' and 'stage' columns to IMU CSV using stage event device_ms timestamps.

    Special stage_ids 'session_start' and 'session_end' act as hard boundaries:
      - data before session_start  → pre_session
      - data after  session_end    → post_session
    Duplicate stage_ids (retries) are labelled stage_id, stage_id_redo_1, etc.
    """
    import csv as _csv
    from collections import defaultdict
    import io

    # Only use events that have a device_ms anchor, sorted by device_ms
    timed = sorted(
        [e for e in stage_events if e.get("device_ms") is not None],
        key=lambda e: e["device_ms"],
    )

    # Extract boundary events
    session_start_ms = next(
        (e["device_ms"] for e in timed if e["stage_id"] == "session_start"), None
    )
    session_end_ms = next(
        (e["device_ms"] for e in timed if e["stage_id"] == "session_end"), None
    )

    # Build ordered (device_ms, label) checkpoints for non-boundary events,
    # numbering duplicate stage_ids as redo_1, redo_2, …
    attempt_count: dict = defaultdict(int)
    checkpoints: list[tuple[float, str]] = []
    for e in timed:
        sid = e["stage_id"]
        if sid in ("session_start", "session_end"):
            continue
        attempt_count[sid] += 1
        n = attempt_count[sid]
        label = sid if n == 1 else f"{sid}_redo_{n - 1}"
        checkpoints.append((float(e["device_ms"]), label))

    reader = _csv.DictReader(csv_text.splitlines())
    rows = list(reader)
    if not rows:
        return csv_text

    base_fields = reader.fieldnames or []
    out_fields = ["side", "stage"] + [f for f in base_fields if f not in ("side", "stage")]

    buf = io.StringIO()
    writer = _csv.DictWriter(buf, fieldnames=out_fields, extrasaction="ignore")
    writer.writeheader()

    for row in rows:
        row["side"] = side
        ms = float(row.get("device_ms") or 0)

        if session_start_ms is not None and ms < session_start_ms:
            row["stage"] = "pre_session"
        elif session_end_ms is not None and ms >= session_end_ms:
            row["stage"] = "post_session"
        elif checkpoints:
            # Walk checkpoints — last one whose device_ms <= row ms wins
            label = "pre_stage"
            for cp_ms, cp_label in checkpoints:
                if ms >= cp_ms:
                    label = cp_label
                else:
                    break
            row["stage"] = label
        else:
            row["stage"] = ""

        writer.writerow(row)

    return buf.getvalue()


def _drain_until_quiet(ser: serial.Serial, quiet_s: float = 1.0, max_s: float = 300.0) -> None:
    """Read and discard any stale firmware output (e.g. a previous interrupted dump).

    Stops as soon as 'EOF' is detected in the incoming stream — meaning the
    firmware has cleanly finished whatever it was doing — or after quiet_s
    seconds of silence.  Raises TimeoutError if data is still arriving after
    max_s seconds (insole stuck; user should unplug/replug USB).
    """
    import time
    deadline = time.monotonic() + max_s
    last_data_at = time.monotonic()

    while True:
        if time.monotonic() > deadline:
            raise TimeoutError(
                f"Port still sending data after {max_s:.0f}s — unplug and replug "
                "the insole USB cable to reset it, then try again."
            )
        n = ser.in_waiting
        if n > 0:
            chunk = ser.read(min(n, 4096))
            last_data_at = time.monotonic()
            if b"EOF" in chunk:
                # Previous operation finished cleanly; flush any trailing bytes
                time.sleep(0.05)
                ser.reset_input_buffer()
                return
        else:
            if time.monotonic() - last_data_at >= quiet_s:
                return  # quiet_s of silence — port is clear
            time.sleep(0.05)


def _read_dump_sync(port: str, baud: int, timeout_total: float) -> tuple[str, int | str]:
    """Open the serial port, send DUMP, read until EOF.

    Returns (csv_body, sample_count). Raises on protocol error or timeout.
    Run in a worker thread.
    """
    import time
    deadline = time.monotonic() + timeout_total

    with serial.Serial(port, baud, timeout=SERIAL_TIMEOUT_S, write_timeout=5.0) as ser:
        # Give TinyUSB a moment to finish SET_LINE_CODING negotiation, then
        # drain any stale output left over from a previous interrupted dump.
        time.sleep(0.1)
        _drain_until_quiet(ser)

        ser.write(b"DUMP\n")
        ser.flush()

        lines: list[str] = []
        sample_count = 0

        while True:
            if time.monotonic() > deadline:
                raise TimeoutError(
                    f"Dump timed out after {timeout_total:.0f}s — check that the insole "
                    "is powered and the USB cable is data-capable."
                )

            raw = ser.readline()
            if not raw:
                # readline timed out — loop back and check wall-clock deadline
                continue

            line = raw.decode("ascii", errors="replace").rstrip("\r\n")
            if line == "EOF":
                break
            if not line:
                continue
            # Firmware sends "NO_DATA: ..." when flash is genuinely empty.
            # Pass the firmware message through so we can show it verbatim.
            if line.startswith("NO_DATA"):
                return "", line  # type: ignore[return-value]  — string sentinel
            lines.append(line)

            # First line is the CSV header; everything after is a sample
            if len(lines) > 1:
                sample_count += 1

        return "\n".join(lines) + "\n", sample_count


def _clear_sync(port: str, baud: int) -> str:
    """Send CLEAR command, wait for CLEARED reply. Run in a worker thread.

    Flash erase takes 15–30s. The firmware sends dots (no newlines) during
    erasure, so readline() times out repeatedly — we loop for up to 90s and
    check for "CLEARED" as a substring (firmware reply is
    "CLEARED. Flash ready for new session." not just "CLEARED").
    """
    import time
    deadline = time.monotonic() + 90.0
    with serial.Serial(port, baud, timeout=SERIAL_TIMEOUT_S, write_timeout=5.0) as ser:
        time.sleep(0.1)
        _drain_until_quiet(ser)
        ser.write(b"CLEAR\n")
        ser.flush()

        while time.monotonic() < deadline:
            raw = ser.readline()
            if not raw:
                continue   # readline timed out on dot stream — keep looping
            line = raw.decode("ascii", errors="replace").rstrip("\r\n")
            if "CLEARED" in line:
                return line
        raise TimeoutError(
            "Did not receive CLEARED reply within 90s — unplug and replug the insole USB cable."
        )


@router.post("/sessions/{session_id}/dump")
async def dump_session_imu(session_id: int, body: DumpRequest):
    """Read the flash log from one insole over USB and save it as a CSV under data/raw/."""
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    try:
        csv_body, sample_count = await asyncio.to_thread(
            _read_dump_sync, body.port, body.baud, DUMP_TOTAL_TIMEOUT_S,
        )
    except (serial.SerialException, OSError) as e:
        raise HTTPException(status_code=503, detail=f"Could not open serial port {body.port}: {e}")
    except TimeoutError as e:
        raise HTTPException(status_code=504, detail=str(e))

    if isinstance(sample_count, str):
        # sample_count holds the firmware NO_DATA message
        no_data_msg = sample_count
        if "does not exist" in no_data_msg:
            detail = (
                "No data file found on the insole — the flash was cleared but nothing was "
                "recorded afterwards. Check that Max/MSP's BLE connection to this insole was "
                "active during the session. The insole only logs to flash while BLE is connected."
            )
        elif "empty" in no_data_msg or "0 bytes" in no_data_msg:
            detail = (
                "The data file exists on the insole but contains 0 bytes — the insole was not "
                "recording during the session. Make sure Max/MSP had an active BLE connection to "
                "this insole for the full duration of the session."
            )
        else:
            detail = f"Insole reported no data: {no_data_msg}. Ensure BLE was connected during the session."
        raise HTTPException(status_code=422, detail=detail)
    if sample_count == 0:
        raise HTTPException(
            status_code=422,
            detail=(
                "Dump completed but contained no samples. The insole may not have been "
                "recording — verify that Max/MSP held an active BLE connection to this insole "
                "throughout the session."
            ),
        )

    # Annotate with side + stage zones before saving
    stage_events = await queries.list_stage_events_for_session(session_id)
    annotated = _annotate_zones(csv_body, body.side, stage_events)

    # Persist to data/<TestType>/Raw data/<ParticipantID>/<pid>_imu_<side>.csv
    from db.paths import session_raw_folder
    csv_path = session_raw_folder(session) / f"{session['participant_id']}_imu_{body.side}.csv"
    csv_path.write_text(annotated)

    if body.side == "R":
        await queries.update_session_status(
            session_id, "imu-saved", imu_raw_path=str(csv_path),
        )

    return {
        "ok": True,
        "side": body.side,
        "csv_path": str(csv_path),
        "sample_count": sample_count,
        "size_bytes": len(annotated),
    }


@router.post("/clear")
async def clear_imu_log(body: ClearRequest):
    """Wipe the flash log on the insole connected at the given serial port."""
    try:
        reply = await asyncio.to_thread(_clear_sync, body.port, body.baud)
    except (serial.SerialException, OSError) as e:
        raise HTTPException(status_code=503, detail=f"Could not open serial port {body.port}: {e}")
    except TimeoutError as e:
        raise HTTPException(status_code=504, detail=str(e))
    return {"ok": True, "reply": reply}


@router.post("/info")
async def info(body: ClearRequest):
    """Read the firmware's INFO output for a quick sanity check (uses ClearRequest schema)."""
    def _info_sync():
        import time
        with serial.Serial(body.port, body.baud, timeout=SERIAL_TIMEOUT_S, write_timeout=5.0) as ser:
            time.sleep(0.1)
            _drain_until_quiet(ser)
            ser.write(b"INFO\n")
            ser.flush()
            # Read until two consecutive timeouts (silence), up to 20 lines.
            # Firmware now outputs 11 fields — the old hard limit of 8 missed the last 3.
            lines, empties = [], 0
            while empties < 2 and len(lines) < 20:
                raw = ser.readline()
                if not raw:
                    empties += 1
                    continue
                empties = 0
                line = raw.decode("ascii", errors="replace").rstrip("\r\n")
                if line:
                    lines.append(line)
            return lines

    try:
        lines = await asyncio.to_thread(_info_sync)
    except (serial.SerialException, OSError) as e:
        raise HTTPException(status_code=503, detail=f"Could not open serial port {body.port}: {e}")
    return {"lines": lines}
