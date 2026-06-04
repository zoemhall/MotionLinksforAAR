"""Shared fixtures for all gait-study API tests.

DB strategy: patch db.connection._db with a fresh in-memory aiosqlite connection.
The lifespan's init_db() is replaced with a no-op — the DB is already ready.

Hardware: ble_manager.disconnect and routers.sessions.get_active_recorder are
patched globally so hardware-free tests never fail on missing BLE/serial.
"""
from __future__ import annotations
import pytest
import aiosqlite
from pathlib import Path
from unittest.mock import AsyncMock, patch

import db.connection as db_conn

SCHEMA_PATH = Path(__file__).parent.parent / "db" / "schema.sql"


async def _make_test_db() -> aiosqlite.Connection:
    conn = await aiosqlite.connect(":memory:")
    conn.row_factory = aiosqlite.Row
    await conn.execute("PRAGMA foreign_keys=ON")
    await conn.executescript(SCHEMA_PATH.read_text())
    try:
        await conn.execute("ALTER TABLE sessions ADD COLUMN deleted_at TEXT DEFAULT NULL")
    except Exception:
        pass
    await conn.commit()
    return conn


@pytest.fixture
async def db():
    """Isolated in-memory SQLite DB, reset per test."""
    conn = await _make_test_db()
    original = db_conn._db
    db_conn._db = conn
    yield conn
    db_conn._db = original
    await conn.close()


@pytest.fixture
async def client(db, tmp_path):
    """AsyncClient against the FastAPI app with:
      - in-memory DB (via db fixture)
      - init_db / close_db replaced with no-ops
      - ble_manager.disconnect mocked
      - get_active_recorder returning None (no live recording)
      - DATA_DIR redirected to tmp_path for all file I/O
    """
    from httpx import AsyncClient, ASGITransport
    from app import app

    async def _noop(): pass

    with (
        patch("db.connection.init_db", side_effect=_noop),
        patch("db.connection.close_db", side_effect=_noop),
        patch("ble.manager.ble_manager.disconnect", new_callable=AsyncMock),
        patch("routers.sessions.get_active_recorder", return_value=None),
        patch("db.paths.DATA_DIR", tmp_path),
        patch("routers.pressure.DATA_DIR", tmp_path),
        patch("routers.sessions.DATA_DIR", tmp_path),
        patch("routers.export.DATA_DIR", tmp_path),
    ):
        async with AsyncClient(
            transport=ASGITransport(app=app), base_url="http://test"
        ) as ac:
            yield ac


# ── Shared helpers ────────────────────────────────────────────────────────────

async def make_participant(client, pid="01"):
    r = await client.post("/api/participants", json={
        "participant_id": pid,
        "shoe_size": "8",
        "gender": "Female",
        "injuries": "none",
    })
    assert r.status_code == 201, r.text
    return r.json()


async def make_session(client, pid="01", test_type_id=3, **extra):
    """Default to Test 3 (full study, has_condition_1=1).
    Pass test_type_id=1 or 2 for simpler sessions."""
    payload = {
        "participant_id": pid,
        "test_type_id": test_type_id,
        "condition_order": "A-first",
        "tempo_direction": "speeding_up",
        "weight_direction": "increasing",
        **extra,
    }
    r = await client.post("/api/sessions", json=payload)
    assert r.status_code == 201, r.text
    return r.json()


async def make_pressure_only_test_type(client):
    """Create a test type with has_imu_dump=0 for pressure-only merge tests."""
    r = await client.post("/api/test_types", json={
        "name": "Test Pressure Only",
        "description": "No IMU, pressure only",
        "has_calibration": 0,
        "has_audio_familiarisation": 0,
        "has_condition_1": 0,
        "has_condition_2": 0,
        "has_imu_dump": 0,
        "has_pressure_merge": 1,
        "has_consciousness_check": 0,
        "has_overall_ratings": 0,
    })
    assert r.status_code == 201, r.text
    return r.json()
