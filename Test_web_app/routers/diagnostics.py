"""Diagnostics router — extensible test runner for hardware/system checks.

Add a new test by writing an async function and decorating it with @register_test.
Each test returns a dict {status, message, details, duration_ms} (status set
automatically by the runner from any exception).
"""
from __future__ import annotations
import asyncio
import os
import time
from pathlib import Path
from typing import Awaitable, Callable

from fastapi import APIRouter, HTTPException

router = APIRouter()

TestFn = Callable[[], Awaitable[dict]]
_tests: dict[str, dict] = {}


def register_test(test_id: str, name: str, description: str):
    """Decorator that registers a test function under a stable ID."""
    def decorator(fn: TestFn) -> TestFn:
        _tests[test_id] = {"id": test_id, "name": name, "description": description, "fn": fn}
        return fn
    return decorator


@router.get("/tests")
async def list_tests():
    """Return the registered test catalogue (without the function references)."""
    return [
        {"id": t["id"], "name": t["name"], "description": t["description"]}
        for t in _tests.values()
    ]


@router.post("/run/{test_id}")
async def run_test(test_id: str):
    test = _tests.get(test_id)
    if not test:
        raise HTTPException(status_code=404, detail=f"Unknown test: {test_id}")

    start = time.perf_counter()
    try:
        result = await test["fn"]()
        result.setdefault("status", "pass")
    except Exception as e:
        result = {
            "status": "fail",
            "message": f"Test crashed: {type(e).__name__}: {e}",
            "details": [],
        }

    result["test_id"] = test_id
    result["name"] = test["name"]
    result["duration_ms"] = round((time.perf_counter() - start) * 1000, 1)
    result.setdefault("details", [])
    return result


# =====================================================================
# Tests
# =====================================================================

@register_test(
    "ble_scan",
    "BLE Scan",
    "Scan for the XIAO peripheral. Run this with Max/MSP connected to test "
    "whether the XIAO is exclusively held by another central (it won't appear).",
)
async def test_ble_scan() -> dict:
    from bleak import BleakScanner
    from config import BLE_DEVICE_NAME

    details = [f"Scanning for '{BLE_DEVICE_NAME}' (10s timeout)..."]
    device = await BleakScanner.find_device_by_name(BLE_DEVICE_NAME, timeout=10.0)

    if device is None:
        # Also do a broad scan so we can list other devices that ARE visible
        details.append("Device not found by name. Broad scan for context:")
        all_devices = await BleakScanner.discover(timeout=3.0)
        for d in all_devices[:10]:
            details.append(f"  • {d.name or '<unnamed>'} ({d.address})")
        return {
            "status": "fail",
            "message": (
                f"'{BLE_DEVICE_NAME}' not visible. Either it's powered off, "
                "out of range, or another central (e.g. Max/MSP) holds an "
                "exclusive connection."
            ),
            "details": details,
        }

    details.append(f"Found: {device.name} @ {device.address}")
    return {
        "status": "pass",
        "message": f"XIAO advertising and visible (address {device.address}).",
        "details": details,
    }


@register_test(
    "ble_connect_stream",
    "BLE Connect & Stream",
    "Connect to the XIAO, subscribe to UART notifications, listen 3 seconds, "
    "report packet count and parse rate.",
)
async def test_ble_connect_stream() -> dict:
    from bleak import BleakClient, BleakScanner
    from config import BLE_DEVICE_NAME, UART_TX_CHAR_UUID
    from ble.parser import parse_packet
    from ble.manager import ble_manager
    from recording.session_recorder import get_active_recorder

    if get_active_recorder() is not None:
        return {
            "status": "fail",
            "message": "A session is currently recording — stop it before running this test.",
            "details": [],
        }
    if ble_manager.is_connected:
        return {
            "status": "fail",
            "message": "App is already connected to the XIAO. Disconnect first.",
            "details": [],
        }

    details = []
    device = await BleakScanner.find_device_by_name(BLE_DEVICE_NAME, timeout=10.0)
    if device is None:
        return {
            "status": "fail",
            "message": f"'{BLE_DEVICE_NAME}' not found in scan.",
            "details": details,
        }
    details.append(f"Found device: {device.name} @ {device.address}")

    received = 0
    parsed = 0

    def on_data(_char, data):
        nonlocal received, parsed
        received += 1
        if parse_packet(data) is not None:
            parsed += 1

    async with BleakClient(device) as client:
        details.append("Connected. Starting notifications...")
        await client.start_notify(UART_TX_CHAR_UUID, on_data)
        await asyncio.sleep(3.0)
        await client.stop_notify(UART_TX_CHAR_UUID)

    details.append(f"Received {received} packets in 3s ({received / 3:.0f} Hz)")
    details.append(f"Parsed cleanly: {parsed} ({(100 * parsed / received) if received else 0:.0f}%)")

    if received == 0:
        return {
            "status": "fail",
            "message": "Connected but received no packets. Check firmware is sending UART data.",
            "details": details,
        }
    if parsed < received * 0.9:
        return {
            "status": "warn",
            "message": (
                f"Connected but only {parsed}/{received} packets parsed cleanly. "
                "Check UART format matches the parser's expected 10-field ASCII CSV."
            ),
            "details": details,
        }
    return {
        "status": "pass",
        "message": f"Stream healthy: {received} packets in 3s, all parsed.",
        "details": details,
    }


@register_test(
    "ble_latency",
    "BLE Latency",
    "Connect to the XIAO and measure BLE transmission latency over 3 seconds.",
)
async def test_ble_latency() -> dict:
    from bleak import BleakClient, BleakScanner
    from config import BLE_DEVICE_NAME, UART_TX_CHAR_UUID
    from ble.parser import parse_packet
    from ble.manager import ble_manager
    from recording.session_recorder import get_active_recorder

    if get_active_recorder() is not None or ble_manager.is_connected:
        return {
            "status": "fail",
            "message": "Stop active recording/connection first.",
            "details": [],
        }

    device = await BleakScanner.find_device_by_name(BLE_DEVICE_NAME, timeout=10.0)
    if device is None:
        return {"status": "fail", "message": f"'{BLE_DEVICE_NAME}' not found.", "details": []}

    lags: list[float] = []
    t0_host = t0_device = None

    def on_data(_char, data):
        nonlocal t0_host, t0_device
        row = parse_packet(data)
        if row is None:
            return
        h = time.monotonic() * 1000
        if t0_host is None:
            t0_host = h
            t0_device = row["device_ms"]
        else:
            lags.append((h - t0_host) - (row["device_ms"] - t0_device))

    async with BleakClient(device) as client:
        await client.start_notify(UART_TX_CHAR_UUID, on_data)
        await asyncio.sleep(3.0)
        await client.stop_notify(UART_TX_CHAR_UUID)

    if not lags:
        return {"status": "fail", "message": "No packets received.", "details": []}

    avg = sum(lags) / len(lags)
    details = [
        f"Samples: {len(lags)}",
        f"Last: {lags[-1]:.1f} ms",
        f"Average: {avg:.1f} ms",
        f"Min: {min(lags):.1f} ms",
        f"Max: {max(lags):.1f} ms",
    ]
    status = "pass" if avg < 50 else "warn"
    msg = f"Avg BLE latency {avg:.1f} ms over {len(lags)} packets."
    if avg >= 50:
        msg += " High latency — check for BLE interference or system load."
    return {"status": status, "message": msg, "details": details}


@register_test(
    "db_health",
    "Database Health",
    "Verify the SQLite database has WAL mode enabled and all expected tables exist.",
)
async def test_db_health() -> dict:
    from db.connection import get_db
    db = await get_db()

    details = []
    cursor = await db.execute("PRAGMA journal_mode")
    journal_mode = (await cursor.fetchone())[0]
    details.append(f"journal_mode = {journal_mode}")

    cursor = await db.execute("PRAGMA foreign_keys")
    fk = (await cursor.fetchone())[0]
    details.append(f"foreign_keys = {fk}")

    expected = {"participants", "sessions", "questionnaire_responses", "session_tags"}
    cursor = await db.execute("SELECT name FROM sqlite_master WHERE type='table'")
    tables = {r[0] for r in await cursor.fetchall()}
    missing = expected - tables
    details.append(f"tables = {sorted(tables)}")

    if missing:
        return {
            "status": "fail",
            "message": f"Missing tables: {sorted(missing)}",
            "details": details,
        }
    if journal_mode.lower() != "wal":
        return {
            "status": "warn",
            "message": f"journal_mode is '{journal_mode}', expected 'wal'.",
            "details": details,
        }

    # Row counts
    for tbl in sorted(expected):
        cursor = await db.execute(f"SELECT COUNT(*) FROM {tbl}")
        n = (await cursor.fetchone())[0]
        details.append(f"  {tbl}: {n} row(s)")

    return {
        "status": "pass",
        "message": "Database OK — WAL mode active, all tables present.",
        "details": details,
    }


@register_test(
    "data_paths",
    "Data Directories",
    "Verify all data subdirectories exist and are writable.",
)
async def test_data_paths() -> dict:
    from config import DATA_DIR
    details = [f"DATA_DIR = {DATA_DIR}"]
    failures = []

    # Per-session folders (data/<TestType>/Raw data/<Participant>/) are
    # created on demand. Just verify the top-level data folder is writable.
    if not DATA_DIR.exists():
        failures.append(f"{DATA_DIR} does not exist")
        details.append(f"  ✗ {DATA_DIR}")
    elif not os.access(DATA_DIR, os.W_OK):
        failures.append(f"{DATA_DIR} is not writable")
        details.append(f"  ✗ {DATA_DIR} (not writable)")
    else:
        probe = DATA_DIR / ".write_probe"
        try:
            probe.write_text("ok")
            probe.unlink()
            details.append(f"  ✓ {DATA_DIR}")
        except Exception as e:
            failures.append(f"{DATA_DIR} write probe failed: {e}")
            details.append(f"  ✗ {DATA_DIR} (write probe failed)")

    if failures:
        return {
            "status": "fail",
            "message": "; ".join(failures),
            "details": details,
        }
    return {
        "status": "pass",
        "message": "All data directories exist and are writable.",
        "details": details,
    }
