from __future__ import annotations
import aiosqlite
from pathlib import Path
from config import DB_PATH

_db: aiosqlite.Connection | None = None


async def init_db() -> None:
    global _db
    _db = await aiosqlite.connect(DB_PATH)
    _db.row_factory = aiosqlite.Row
    await _db.execute("PRAGMA journal_mode=WAL")
    await _db.execute("PRAGMA foreign_keys=ON")
    schema_path = Path(__file__).parent / "schema.sql"
    await _db.executescript(schema_path.read_text())
    await _db.commit()

    # session_reviews table — created here so it exists before any queries touch it
    await _db.executescript("""
CREATE TABLE IF NOT EXISTS session_reviews (
    review_id               INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id              INTEGER UNIQUE NOT NULL REFERENCES sessions(session_id),
    is_excluded             INTEGER DEFAULT 0,
    excl_equipment          INTEGER DEFAULT 0,
    excl_other              TEXT    DEFAULT '',
    auto_low_steps          INTEGER DEFAULT 0,
    auto_noticed            INTEGER DEFAULT 0,
    tempo_outcome           TEXT    DEFAULT 'unreviewed',
    tempo_effect_pct        REAL,
    tempo_onset             TEXT,
    weight_outcome          TEXT    DEFAULT 'unreviewed',
    weight_effect_pct_stance REAL,
    weight_effect_pct_imu   REAL,
    weight_onset            TEXT,
    tempo_overridden        INTEGER DEFAULT 0,
    weight_overridden       INTEGER DEFAULT 0,
    review_notes            TEXT    DEFAULT '',
    reviewed_at             TEXT
);
""")
    await _db.commit()

    # Migrations — safe to re-run; exceptions mean the column already exists.
    for migration in [
        "ALTER TABLE sessions ADD COLUMN deleted_at TEXT DEFAULT NULL",
        "ALTER TABLE sessions ADD COLUMN cal_file_1_path TEXT",
        "ALTER TABLE sessions ADD COLUMN cal_file_2_path TEXT",
        "ALTER TABLE sessions ADD COLUMN cal_file_3_path TEXT",
        "ALTER TABLE test_types ADD COLUMN target_participants INTEGER NOT NULL DEFAULT 0",
        "ALTER TABLE test_types ADD COLUMN has_calibration_files INTEGER NOT NULL DEFAULT 0",
        "ALTER TABLE sessions ADD COLUMN has_calibration_files INTEGER NOT NULL DEFAULT 0",
        # Only Test 1 (test_type_id=1) actually collects 10s calibration CSV files.
        # All other test types use has_calibration only for the live-session stage gate.
        "UPDATE test_types SET has_calibration_files = 1 WHERE test_type_id = 1",
        "UPDATE sessions SET has_calibration_files = 1 WHERE test_type_id = 1",
        # Coupling metrics — added in review enhancement
        "ALTER TABLE session_reviews ADD COLUMN tempo_audio_change_pct REAL",
        "ALTER TABLE session_reviews ADD COLUMN tempo_coupling_ratio REAL",
        "ALTER TABLE session_reviews ADD COLUMN tempo_entrainment_r REAL",
        "ALTER TABLE session_reviews ADD COLUMN weight_effect_pct_peak REAL",
    ]:
        try:
            await _db.execute(migration)
            await _db.commit()
        except Exception:
            pass

    # Remove the restrictive CHECK constraint on session_stage_events.stage_id so that
    # session_start, session_end, and other dynamic stage IDs can be stored.
    # SQLite can't ALTER a CHECK — we recreate the table if the constraint is still present.
    try:
        async with _db.execute(
            "SELECT sql FROM sqlite_master WHERE type='table' AND name='session_stage_events'"
        ) as cur:
            row = await cur.fetchone()
        if row and "CHECK" in (row[0] or "").upper():
            await _db.executescript("""
CREATE TABLE IF NOT EXISTS session_stage_events_new (
    event_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id INTEGER NOT NULL REFERENCES sessions(session_id),
    stage_id   TEXT NOT NULL,
    started_at TEXT NOT NULL,
    device_ms  REAL,
    created_at TEXT DEFAULT (datetime('now'))
);
INSERT OR IGNORE INTO session_stage_events_new
    SELECT event_id, session_id, stage_id, started_at, device_ms, created_at
    FROM session_stage_events;
DROP TABLE session_stage_events;
ALTER TABLE session_stage_events_new RENAME TO session_stage_events;
CREATE INDEX IF NOT EXISTS idx_stage_events_session ON session_stage_events(session_id);
""")
    except Exception:
        pass


async def get_db() -> aiosqlite.Connection:
    assert _db is not None, "Database not initialized"
    return _db


async def close_db() -> None:
    global _db
    if _db:
        await _db.close()
        _db = None
