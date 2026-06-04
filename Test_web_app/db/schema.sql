-- Test type templates. Each session picks a test type and snapshots its
-- feature flags (so changing the template later doesn't break old sessions).
CREATE TABLE IF NOT EXISTS test_types (
    test_type_id              INTEGER PRIMARY KEY AUTOINCREMENT,
    name                      TEXT NOT NULL UNIQUE,
    description               TEXT DEFAULT '',
    has_calibration           INTEGER NOT NULL DEFAULT 1 CHECK(has_calibration IN (0,1)),
    has_calibration_files     INTEGER NOT NULL DEFAULT 0 CHECK(has_calibration_files IN (0,1)),
    has_audio_familiarisation INTEGER NOT NULL DEFAULT 1 CHECK(has_audio_familiarisation IN (0,1)),
    has_condition_1           INTEGER NOT NULL DEFAULT 1 CHECK(has_condition_1 IN (0,1)),
    has_condition_2           INTEGER NOT NULL DEFAULT 1 CHECK(has_condition_2 IN (0,1)),
    has_imu_dump              INTEGER NOT NULL DEFAULT 1 CHECK(has_imu_dump IN (0,1)),
    has_pressure_merge        INTEGER NOT NULL DEFAULT 1 CHECK(has_pressure_merge IN (0,1)),
    has_consciousness_check   INTEGER NOT NULL DEFAULT 1 CHECK(has_consciousness_check IN (0,1)),
    has_overall_ratings       INTEGER NOT NULL DEFAULT 1 CHECK(has_overall_ratings IN (0,1)),
    archived                  INTEGER NOT NULL DEFAULT 0 CHECK(archived IN (0,1)),
    target_participants       INTEGER NOT NULL DEFAULT 0,
    created_at                TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS participants (
    participant_id TEXT PRIMARY KEY CHECK(participant_id GLOB '[0-9][0-9]'),
    shoe_size      TEXT,
    insole_size    TEXT CHECK(insole_size IS NULL OR insole_size IN ('S', 'M', 'L')),
    age            INTEGER,
    gender         TEXT,
    injuries       TEXT DEFAULT '',          -- e.g. "right leg shorter than left by 1cm" or "none"
    created_at     TEXT DEFAULT (datetime('now'))
);

-- Sessions can repeat per participant (different test types, or retests).
-- Test-type flags are snapshotted at creation so retroactive template changes
-- don't break analysis.
CREATE TABLE IF NOT EXISTS sessions (
    session_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    participant_id    TEXT NOT NULL REFERENCES participants(participant_id),
    test_type_id      INTEGER REFERENCES test_types(test_type_id),
    test_type_name    TEXT,                  -- snapshot for stable display
    condition_order   TEXT CHECK(condition_order IN ('A-first', 'B-first')),
    tempo_direction   TEXT CHECK(tempo_direction IN ('speeding_up', 'slowing_down')),
    weight_direction  TEXT CHECK(weight_direction IN ('increasing', 'decreasing')),
    -- Snapshot of the test type's flags at the moment this session was created.
    has_calibration           INTEGER NOT NULL DEFAULT 1 CHECK(has_calibration IN (0,1)),
    has_calibration_files     INTEGER NOT NULL DEFAULT 0 CHECK(has_calibration_files IN (0,1)),
    has_audio_familiarisation INTEGER NOT NULL DEFAULT 1 CHECK(has_audio_familiarisation IN (0,1)),
    has_condition_1           INTEGER NOT NULL DEFAULT 1 CHECK(has_condition_1 IN (0,1)),
    has_condition_2           INTEGER NOT NULL DEFAULT 1 CHECK(has_condition_2 IN (0,1)),
    has_imu_dump              INTEGER NOT NULL DEFAULT 1 CHECK(has_imu_dump IN (0,1)),
    has_pressure_merge        INTEGER NOT NULL DEFAULT 1 CHECK(has_pressure_merge IN (0,1)),
    has_consciousness_check   INTEGER NOT NULL DEFAULT 1 CHECK(has_consciousness_check IN (0,1)),
    has_overall_ratings       INTEGER NOT NULL DEFAULT 1 CHECK(has_overall_ratings IN (0,1)),
    -- File paths (set as the session progresses)
    imu_raw_path      TEXT,
    pressure_raw_path TEXT,
    merged_path       TEXT,
    cal_file_1_path   TEXT,
    cal_file_2_path   TEXT,
    cal_file_3_path   TEXT,
    -- Researcher notes split into three categories matching the user's
    -- existing Summary.xlsx columns.
    notes_setup       TEXT DEFAULT '',
    notes_use         TEXT DEFAULT '',
    notes_data        TEXT DEFAULT '',
    -- Generic free-text notes (legacy / catch-all).
    notes             TEXT DEFAULT '',
    status            TEXT DEFAULT 'in-progress'
                      CHECK(status IN ('in-progress', 'imu-saved', 'merged', 'complete')),
    session_date      TEXT DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_sessions_participant ON sessions(participant_id);
CREATE INDEX IF NOT EXISTS idx_sessions_test_type ON sessions(test_type_id);

CREATE TABLE IF NOT EXISTS session_tags (
    tag_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id INTEGER NOT NULL REFERENCES sessions(session_id),
    tag        TEXT NOT NULL,
    stage      TEXT,
    note       TEXT DEFAULT '',
    device_ms  REAL,
    created_at TEXT DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_session_tags_session ON session_tags(session_id);
CREATE INDEX IF NOT EXISTS idx_session_tags_tag ON session_tags(tag);

CREATE TABLE IF NOT EXISTS consciousness_responses (
    response_id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id  INTEGER NOT NULL UNIQUE REFERENCES sessions(session_id),
    post_calibration_noticed INTEGER CHECK(post_calibration_noticed IN (0, 1)),
    post_calibration_text    TEXT DEFAULT '',
    cond1_noticed INTEGER CHECK(cond1_noticed IN (0, 1)),
    cond1_guess   TEXT,
    cond1_text    TEXT DEFAULT '',
    cond2_noticed INTEGER CHECK(cond2_noticed IN (0, 1)),
    cond2_guess   TEXT,
    cond2_text    TEXT DEFAULT '',
    post_session_noticed       INTEGER CHECK(post_session_noticed IN (0, 1)),
    post_session_text          TEXT DEFAULT '',
    post_session_tempo_guess   TEXT,
    post_session_weight_guess  TEXT,
    submitted_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS session_stage_events (
    event_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id INTEGER NOT NULL REFERENCES sessions(session_id),
    stage_id   TEXT NOT NULL,
    started_at TEXT NOT NULL,
    device_ms  REAL,
    created_at TEXT DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_stage_events_session ON session_stage_events(session_id);

CREATE TABLE IF NOT EXISTS session_ratings (
    rating_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id       INTEGER NOT NULL UNIQUE REFERENCES sessions(session_id),
    agency_q1        INTEGER CHECK(agency_q1 BETWEEN 0 AND 10),
    agency_q2        INTEGER CHECK(agency_q2 BETWEEN 0 AND 10),
    agency_q3        INTEGER CHECK(agency_q3 BETWEEN 0 AND 10),
    agency_aggregate REAL,
    ueqs_pragmatic   REAL,
    ari_immersion    REAL,
    raw_item_json    TEXT,
    submitted_at     TEXT DEFAULT (datetime('now'))
);

-- Seed three default test types. New sessions can pick any of these,
-- or the researcher can add new ones via the Test Types admin page.
INSERT OR IGNORE INTO test_types
  (name, description,
   has_calibration, has_calibration_files, has_audio_familiarisation, has_condition_1, has_condition_2,
   has_imu_dump, has_pressure_merge, has_consciousness_check, has_overall_ratings)
VALUES
  ('Test 1: Pressure data gathering',
   'Pilot — collect raw pressure data only, no audio conditions or questionnaire.',
   1, 1, 0, 0, 0, 0, 1, 0, 0),
  ('Test 2: Baseline perceived agency',
   'Audio-only baseline. Records pressure data; no consciousness check or full ratings.',
   1, 0, 1, 0, 0, 1, 1, 0, 0),
  ('Test 3: Full study',
   'Complete protocol: calibration → audio familiarisation → both conditions → consciousness check + overall ratings.',
   1, 0, 1, 1, 1, 1, 1, 1, 1);
