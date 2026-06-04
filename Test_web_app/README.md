# Gait Study — Session Management UI

A locally-hosted, browser-based research companion for live IMU streaming, post-session pressure data import, digitised questionnaires, and historical session review. Built to run alongside Max/MSP during a wearable gait study using the Seeed XIAO nRF52840 Sense.

This application is the central data hub for a master's research project investigating whether music can function as biofeedback to influence gait. All data collected across the study — IMU streams, pressure readings, and questionnaire responses — flows through and is stored within this repository's `data/` directory. Nothing leaves the local machine.

---

## Research Context

### What the Study Is Investigating

The study asks whether participants can develop a **sense of agency** over music through their own movement — specifically their walking gait. Participants walk while wearing a pressure-sensing insole on the right foot. Their footsteps trigger and modulate a Max/MSP audio patch in real time. The core question is whether they notice they are controlling the audio, and whether this perceived control creates a sense of agency and immersion.

Two conditions are tested per participant (counterbalanced order):

- **Condition A — Tempo:** The audio BPM speeds up or slows down based on gait (randomised direction per participant).
- **Condition B — Weight:** The audio gain/weight increases or decreases based on gait (randomised direction per participant).

The `tempo_direction` (`speeding_up` / `slowing_down`) and `weight_direction` (`increasing` / `decreasing`) are set per session at creation and logged in the database. These randomised assignments are critical for analysis — they determine whether the biofeedback direction modulates the sense of agency effect.

### Why These Questionnaires

After each condition, three questionnaires are administered in sequence:

1. **Consciousness Check** — Three-stage sequential reveal (post-calibration, post-condition, post-session), designed to detect when participants first become consciously aware that their movement is affecting the audio. The sequential reveal prevents earlier stages from contaminating later responses. This is the primary dependent variable for awareness onset.

2. **Agency Scale** (Kantan et al., 2024) — 3 items on 0–10 sliders, measuring felt sense of control and authorship. Produces an aggregate score.

3. **UEQ-S** (Schrepp et al., 2017) — 8 bipolar items on a 7-point scale, split into pragmatic (usability) and hedonic (appeal) subscales. Used to assess the quality of the interaction experience.

4. **ARI Total Immersion** (Georgiou & Kyza, 2017) — 7 items on a 5-point Likert scale, measuring immersive experience. Produces a single immersion score.

The questionnaires are administered after **each condition**, so each session produces two full questionnaire sets (one per condition). The app enforces this: once a questionnaire is submitted for a condition it cannot be edited, and the session can only advance to `complete` status once both are done.

### Participant Pool

Up to 35 participants (`P01`–`P35`). Each participant completes one session (one right-insole recording, two conditions, two questionnaire sets). The database enforces a unique constraint on `participant_id` in the sessions table to prevent duplicate sessions.

---

## Hardware Setup

### Physical Components

| Component | Role | Connection to This App |
|-----------|------|------------------------|
| Seeed XIAO nRF52840 Sense | IMU (LSM6DS3TR-C, 6-axis at 208 Hz) + pressure sensing via FSR sensors on A0/A1 | BLE UART — `bleak` connects via Nordic UART Service |
| E-textile insole (right foot) | Force-sensitive resistors: A0 = toe, A1 = heel | Wired directly to XIAO analogue pins |
| MacBook (researcher's laptop) | Runs this app + Max/MSP simultaneously | Both on same machine |
| Max/MSP patch | Audio generation + its own pressure CSV logging | Runs as a separate process; no direct code link to this app |

### XIAO BLE UART Packet Format

The XIAO firmware sends ASCII CSV lines over BLE UART at 208 Hz. Each packet has exactly 10 comma-separated fields:

```
device_ms,ax,ay,az,gx,gy,gz,toe,heel,phase
```

| Field | Unit / Range | Notes |
|-------|-------------|-------|
| `device_ms` | milliseconds (firmware clock) | Used for aligning IMU with pressure data |
| `ax,ay,az` | accelerometer (LSM6DS3TR-C) | Raw or scaled — confirm with firmware |
| `gx,gy,gz` | gyroscope | Raw or scaled — confirm with firmware |
| `toe` | raw ADC (right insole A0) | Renamed to `R_toe` in the CSV writer |
| `heel` | raw ADC (right insole A1) | Renamed to `R_heel` in the CSV writer |
| `phase` | integer 0–9 | Set by phase commands sent from this app |

Any packet that does not parse cleanly to exactly 10 fields is silently discarded by `ble/parser.py`. Packets where the `device_ms` gap exceeds 20ms are counted as dropped (visible in BLE status).

### Phase Commands

This app writes single ASCII digits to the XIAO's BLE UART RX characteristic to set the firmware's current phase. The phase value is echoed back in every subsequent packet's `phase` field, so it appears in the raw IMU CSV.

| Phase | Label | When Sent |
|-------|-------|-----------|
| 0 | Idle | — |
| 1 | Calibration | Start of calibration stage |
| 2 | A-Pre | Audio familiarisation |
| 3 | A-Drift | Condition A start |
| 4 | B-Light | Condition B start |
| 5 | B-Heavy | (currently unused — available for extension) |
| 9 | Sync Pulse | Manual trigger via keyboard shortcut S |

Phase labels are defined in `config.py` (`PHASE_LABELS`). The stage-to-phase mapping is in `templates/index.html` in the `liveSessionData()` function. Both should be kept in sync.

The **sync pulse (phase 9)** is the primary alignment marker. During the calibration stage, pressing S sends phase 9, which appears as a phase change in the IMU data. Max/MSP simultaneously logs this moment in its pressure CSV. The sync pulse row is used during the merge step to verify that the two data streams are temporally aligned.

---

## Max/MSP Integration

### What Max Does

Max/MSP runs independently on the same laptop. It:

1. Connects to the XIAO via BLE (potentially the same connection — see BLE dual-connection issue below)
2. Reads foot pressure from the insole to drive audio in real time
3. Generates and modulates audio based on pressure readings according to the condition (tempo or weight)
4. Logs all pressure readings to its own CSV file during the session

Max's pressure CSV is the **only source of left-foot data** (Max logs both feet: `L_toe`, `L_heel`, `R_toe`, `R_heel`). This app's BLE connection captures right-foot data only (`R_toe`, `R_heel` from XIAO A0/A1).

### Max Pressure CSV Format

Max outputs all records for a session as a **single line**, semicolon-separated. There are no column headers. Each record follows this structure:

```
index, timestamp L_toe L_heel R_toe R_heel L_toe_lower L_toe_upper L_heel_lower L_heel_upper R_toe_lower R_toe_upper R_heel_lower R_heel_upper
```

- Fields within a record are **space-separated**
- Records are **semicolon-separated** (no trailing newline is guaranteed)
- The index is a sequential integer followed by a comma and space
- The timestamp is in milliseconds (same epoch as `device_ms` in the XIAO firmware — these must share a clock reference for alignment to work)
- The 4 pressure values are raw ADC readings (0–1023 range typical)
- The 8 calibration bounds (lower/upper per zone) are floats representing threshold fractions — typically 0.1 or 0.22 based on the sensitivity setting used during calibration

**Known quirk from initial testing:** The right toe and right heel threshold values (`R_toe_lower`, `R_toe_upper`, `R_heel_lower`, `R_heel_upper`) can appear inverted in the data — i.e., the lower bound is numerically greater than the upper bound. This is a quirk of how Max's calibration formula saves the values, not a sensor or parsing error. The app currently displays calibration thresholds for verification after upload but does not validate or correct the inversion. Document this for future analysis.

### Sensitivity Setting

During initial hardware testing, pressure threshold sensitivity was tested at 0.1 (low), 0.5 (medium), and 0.9 (high) across 12 walking activities. A sensitivity of 0.9 (high threshold to trigger audio) was found to detect all footsteps reliably across activities ranging from slow walking to running. The final study uses sensitivity values embedded in the Max patch calibration routine — the lower/upper bounds stored in Max's CSV reflect whichever sensitivity was set at the time of calibration. These bounds are saved per-session in the database as part of the merge preview (via `calibration_thresholds`).

### BLE Dual-Connection Problem

Both Max and this Python app need data from the XIAO over BLE UART. Most BLE peripherals only accept one central connection at a time. This has not yet been confirmed on the final hardware configuration. See [BLE_TEST.md](BLE_TEST.md) for the test procedure.

**Three fallback strategies if dual connection fails:**

- **Option A (Recommended):** Disconnect Max from BLE. Let this app be the sole BLE receiver. Max continues audio processing using its own sensors independently (e.g., a separate pressure source or a pre-calibrated lookup). Pressure CSVs are still imported into this app after the session.
- **Option B:** Use a USB BLE dongle for this Python app. The laptop's built-in BLE stays with Max. Requires configuring bleak to target a specific adapter.
- **Option C:** Modify XIAO firmware to broadcast via advertising packets (passive scan mode). Both Max and Python can then receive without an exclusive connection, at lower throughput.

---

## Data Flow

### During a Session

```
XIAO nRF52840 Sense
        │
        │ BLE UART (208 Hz ASCII CSV)
        ▼
   ble/manager.py  ──── fan-out ────┬──▶  recording/session_recorder.py
        │                           │         └──▶ data/raw/P01_A-first_raw_*.csv
        │                           │
        │                           └──▶  routers/ws.py (WebSocket)
        │                                     └──▶ Browser live chart (downsampled ÷5)
        │
        └── phase commands ──▶ XIAO firmware (ASCII digit 0–9)

Max/MSP (separate process)
        │
        │ Reads insole pressure directly
        ▼
  data/raw/P01_pressure.csv  (saved by Max, dragged into app after session)
```

### Post-Session Merge

```
data/raw/P01_*_raw_*.csv   (IMU, from BLE)
data/raw/P01_pressure.csv  (from Max, uploaded via drag-and-drop)
        │
        ▼
   merge/merger.py
        │  pandas.merge_asof(tolerance=50ms) on device_ms
        │  sync pulse (phase=9) checked for alignment
        ▼
data/processed/P01_merged.csv
```

The merge uses `pandas.merge_asof` with a 50ms tolerance to align rows on `device_ms`. Both files must share a common clock — the XIAO firmware's `device_ms` and Max's timestamp must use the same reference. If they diverge (e.g., different start times), the sync pulse row provides the alignment check. A warning is emitted if no phase 9 row is found in the merged output.

### Session Lifecycle (Status Machine)

```
in-progress  →  imu-saved  →  merged  →  complete
```

| Status | Meaning |
|--------|---------|
| `in-progress` | BLE connected, actively recording IMU data |
| `imu-saved` | Recording stopped, raw IMU CSV written to disk |
| `merged` | Pressure CSV uploaded and merge confirmed |
| `complete` | Both questionnaires submitted (implied — enforced in UI) |

Deleted sessions move all associated data files to `data/archive/` rather than permanently deleting them. The SQLite database record is removed, but files are never lost.

---

## Quick Start

```bash
# 1. Create virtual environment and install dependencies
uv venv && source .venv/bin/activate
uv pip install -r requirements.txt

# 2. Run the application
python app.py

# 3. Open in browser
# http://127.0.0.1:8000
```

The app creates a `data/` directory on first run containing the SQLite database and all CSV subdirectories. No external services or network access required.

---

## Architecture: Flash-Buffer + Post-Session Dump

**Audio latency is the priority**, so Python is deliberately kept out of the
audio data path. Max/MSP keeps its direct BLE connection to the insoles for
real-time pressure → audio. This app receives IMU + pressure via a different
mechanism: each insole logs samples to its own internal flash during the
session, and after the session this app pulls the log over USB-C.

```
Insole (XIAO) ── BLE UART (50 Hz "toe heel") ──→ Max/MSP ──→ Audio
                                                        ╲
Insole flash ←── 50 Hz IMU + pressure (always-on while BLE connected)
                                                        │
                              [End of session]          │
                              Plug in USB-C, send DUMP  ▼
                                                  This app's
                                                  IMU dump panel
```

The firmware ([firmware/main.cpp](firmware/main.cpp)) does both jobs: it sends
the existing pressure stream over BLE for Max, and independently writes a
22-byte binary record per sample to internal flash. Foot stomps are auto-tagged
as `phase = 9` for IMU↔pressure alignment during merge.

See [firmware/README.md](firmware/README.md) for build + flash instructions.

## Session Workflow (Researcher Steps)

### Before the Session

1. Charge each insole. Power on; the LED stays off until BLE connects.
2. Start Max/MSP and load the audio patch. The bridge auto-connects to both insoles — the LED on each goes **solid on** (= flash logging started, fresh log).
3. Verify pressure → audio responds in Max (poke the sensors).
4. Start this app (`python app.py`) and open `http://127.0.0.1:8000`.
5. Run **Diagnostics → Database Health** and **Data Directories** as a sanity check.
   (Skip BLE Scan — Max holds the connections, so the insoles aren't advertising.)
6. Create a new session: participant ID (P01–P35), condition order (A-first / B-first), randomised tempo + weight directions.
7. Lay out two USB-C cables labelled L and R for the post-session dump.

### During the Session

Each session covers four sequential stages. The researcher advances stages manually.

| Stage | Guide Timer | Description |
|-------|-------------|-------------|
| Calibration | 2 min | Have the participant do a firm foot stomp — the firmware auto-detects this as a sync pulse (phase=9) for later alignment with Max's pressure CSV. |
| Audio Familiarisation | 2 min | Participant walks and hears audio. |
| Condition 1 | 4 min | First condition (A or B, based on randomised order). |
| Condition 2 | 4 min | Second condition. |

Timers count down during each stage. When the guide time is exceeded, the timer switches to amber and counts upward — the researcher decides when to advance.

**Important:** in flash-buffer mode the live IMU chart is replaced with a status panel. Recording is happening inside the insole, not in this app. The app's role during the live view is the staged timer + tag capture for issues to revisit.

**Pause / Resume** — pause/resume only stops the visual stage timer. The insole flash log keeps writing regardless (it's tied to BLE connection state, not app state).

**Tags** — flag Max glitches or anything else worth noting. Tags capture the current stage automatically and surface as a `⚑ N` flag on the Dashboard/History.

**Keyboard shortcuts (live session view only):** keys 1–9 update the local stage display only. The firmware doesn't accept phase commands — sync pulse detection is autonomous (foot stomp).

### After the Session

1. **End Session Timer** — navigates to the post-session screen. The insole flash logs are still intact (they only get wiped on the *next* BLE connect).
2. **Step 1: Dump IMU from Insoles**
   - Plug each insole into the laptop with USB-C (one at a time or both if you have two cables).
   - Click **Refresh** in the Port dropdown if a new device appears.
   - Click **Dump Insole_R → CSV** (or L). The firmware streams the binary log decoded as 10-field CSV at 921600 baud. Takes ~30-60s for a 12-min session.
   - Repeat for the other insole.
   - The R-side dump also marks the session as `imu-saved` in the database.
3. **Step 2: Upload pressure CSV from Max** — drag the file Max saved into the upload zone. The parser auto-detects Max's semicolon format and warns about any malformed records.
4. **Step 3: Run merge** — aligns IMU + pressure on `device_ms`. Review:
   - The **Sync alignment card** (green ≤ 50 ms, amber otherwise, red if no sync pulse).
   - The **calibration thresholds table** — verify Max's bounds.
   - Any warnings.
5. **Confirm merge** — writes the merged CSV to `data/processed/`. Status advances to `merged`.
6. **Administer questionnaires** — Condition A then Condition B. Auto-selects whichever is unsubmitted. Both required for `complete` status. Immutable after submission.
7. **Retro-tag** anything you only noticed afterwards.

---

## Project Structure

```
masteringmaster/
├── app.py                  # Entry point — python app.py
├── config.py               # BLE UUIDs, paths, constants, phase labels
├── requirements.txt
│
├── db/                     # Database layer
│   ├── schema.sql          # SQLite schema (3 tables: participants, sessions, questionnaire_responses)
│   ├── connection.py       # aiosqlite connection pool + WAL mode
│   ├── models.py           # Pydantic request/response schemas
│   └── queries.py          # All SQL operations
│
├── ble/                    # Bluetooth Low Energy
│   ├── manager.py          # BLEManager singleton — bleak, fan-out pub/sub
│   └── parser.py           # UART packet parser (10-field ASCII CSV → dict)
│
├── recording/              # Session recording engine
│   ├── csv_writer.py       # Async incremental CSV writer (flush every 100 rows)
│   └── session_recorder.py # Subscribes to BLEManager, writes BLE rows to CSV
│
├── merge/                  # Pressure data import
│   └── merger.py           # Max CSV parser + pandas merge_asof (50ms tolerance)
│
├── routers/                # FastAPI endpoints
│   ├── sessions.py         # CRUD + start/pause/resume/stop/delete + tags
│   ├── participants.py     # Demographics + summary + delete
│   ├── questionnaires.py   # Submit per condition (immutable after submit) + retrieve
│   ├── pressure.py         # Upload + merge preview (with sync alignment) + confirm
│   ├── ble_control.py      # BLE status + phase commands
│   ├── export.py           # Download merged CSV or flat export of all sessions
│   ├── tags.py             # /api/tags/frequent — frequently-used tag aggregation
│   ├── diagnostics.py      # Extensible test registry (BLE scan, DB health, etc.)
│   └── ws.py               # WebSocket /ws/imu — live IMU stream (downsampled ÷5)
│
├── static/                 # Frontend (no build tools — plain HTML/CSS/JS)
│   ├── css/main.css
│   ├── js/
│   │   ├── app.js          # Alpine.js stores + hash router ($store.nav, $store.session)
│   │   ├── api.js          # REST API fetch wrapper
│   │   ├── ws-client.js    # WebSocket client for live IMU chart
│   │   ├── live-chart.js   # Canvas 2D real-time plotter (6-axis IMU + pressure)
│   │   ├── questionnaire.js # Per-condition flow (A then B) with auto-selection
│   │   ├── tags.js         # Reusable tag panel (live + detail views)
│   │   ├── file-upload.js  # Drag-and-drop pressure CSV upload
│   │   └── keyboard.js     # Keyboard shortcuts (1–9, S) for phase commands
│   └── vendor/             # Vendored libraries — no CDN dependency
│       ├── alpine.min.js
│       └── chart.min.js
│
├── templates/
│   └── index.html          # Single-page app shell — Alpine.js SPA, hash-based routing
│
├── data/                   # Created at runtime — all study data lives here
│   ├── raw/                # Raw IMU CSVs + uploaded Max pressure CSVs
│   ├── processed/          # Merged CSVs (IMU + pressure aligned)
│   ├── archive/            # Superseded or soft-deleted files (never permanently removed)
│   └── gait_study.db       # SQLite database (WAL mode)
│
├── firmware/               # XIAO nRF52840 Sense Plus sketch
│   ├── main.cpp            # Bluefruit + LSM6DS3 + flash logging + USB CDC dump
│   ├── platformio.ini      # PlatformIO build config
│   └── README.md           # Build/flash instructions + protocol reference
│
└── BLE_TEST.md             # Step-by-step dual BLE connection test + fallback strategies
```

---

## Database Schema

Four tables. SQLite with WAL mode for crash safety.

**`participants`** — one row per participant:
- `participant_id` TEXT PRIMARY KEY — format `P01`–`P35` (enforced by CHECK constraint)
- `shoe_size`, `age`, `gender` — demographics collected at session setup
- `created_at` — ISO datetime

**`sessions`** — one row per session (unique per participant — one session per person):
- `session_id` INTEGER AUTOINCREMENT
- `participant_id` → FK to participants
- `condition_order` — `'A-first'` or `'B-first'` (counterbalancing)
- `tempo_direction` — `'speeding_up'` or `'slowing_down'` (randomised)
- `weight_direction` — `'increasing'` or `'decreasing'` (randomised)
- `imu_raw_path`, `pressure_raw_path`, `merged_path` — file paths on disk
- `status` — `'in-progress'` | `'imu-saved'` | `'merged'` | `'complete'`
- `notes` — free text researcher notes (also used by the auto-recovery system to
  append `[Auto-recovered: ...]` markers when the app restarts mid-session)

**`questionnaire_responses`** — one row per condition per session (max 2 per session):
- `session_id` → FK to sessions
- `condition` — `'A'` or `'B'`
- `agency_q1/q2/q3` — 0–10 slider values; `agency_aggregate` — computed mean
- `consciousness_post_calibration_noticed/text` — awareness at calibration stage
- `consciousness_post_condition_noticed/text` — awareness after condition
- `consciousness_post_session_noticed/text` — awareness at session end
- `ueqs_pragmatic`, `ueqs_hedonic` — computed from 8 UEQ-S item responses
- `ari_immersion` — computed from 7 ARI item responses
- `raw_item_json` — all individual item responses stored as JSON
- UNIQUE constraint on `(session_id, condition)` — prevents duplicate submissions

**`session_tags`** — flags for data-quality issues, Max bugs, processing caveats. Multiple per session:
- `tag_id` INTEGER AUTOINCREMENT
- `session_id` → FK to sessions
- `tag` — short text label (e.g. `max-glitch`, `redo-condition`, `phase-misfire`)
- `stage` — which stage was active when the tag was added (`calibration` | `audio_only`
  | `condition_1` | `condition_2`), nullable for after-the-fact retro-tagging
- `note` — free-text annotation
- `device_ms` — IMU firmware timestamp at the moment the tag was created
  (captured automatically from the live WebSocket stream during recording)
- `created_at` — wall clock time

Tag deletions cascade when sessions or participants are deleted. Tag counts
appear in the session list and history table as a `⚑ N` flag, so caveats are
visible at a glance.

---

## Configuration

All configurable values are in `config.py`:

| Setting | Default | Description |
|---------|---------|-------------|
| `BLE_DEVICE_NAME` | `"Insole_R"` | BLE advertising name of the XIAO |
| `BLE_CONNECT_TIMEOUT` | `15.0` | Seconds before BLE scan times out |
| `IMU_SAMPLE_RATE` | `208` | Expected sample rate (Hz) — LSM6DS3TR-C default |
| `WS_DOWNSAMPLE_EVERY` | `5` | Send every Nth sample to browser (~41 FPS for live chart) |
| `PACKET_GAP_THRESHOLD_MS` | `20` | Gaps wider than this increment the dropped-packet counter |
| `CSV_FLUSH_EVERY` | `100` | Rows between disk flushes — balances safety vs I/O |
| `PHASE_LABELS` | dict | Human-readable labels for phases 0–9 |

Stage durations (calibration 2 min, audio familiarisation 2 min, conditions 4 min each) are set in `templates/index.html` inside the `liveSessionData()` function.

---

## API Reference

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/sessions` | List all sessions |
| `POST` | `/api/sessions` | Create new session |
| `GET` | `/api/sessions/{id}` | Get session detail |
| `POST` | `/api/sessions/{id}/start` | Connect BLE + start recording |
| `POST` | `/api/sessions/{id}/pause` | Pause recording (BLE stays connected) |
| `POST` | `/api/sessions/{id}/resume` | Resume recording |
| `POST` | `/api/sessions/{id}/stop` | Stop recording + disconnect BLE |
| `DELETE` | `/api/sessions/{id}` | Soft-delete session (archives data files) |
| `PATCH` | `/api/sessions/{id}/notes` | Update researcher notes |
| `GET` | `/api/participants/{id}` | Get participant demographics |
| `GET` | `/api/participants/{id}/summary` | Demographics + prior sessions list |
| `POST` | `/api/participants` | Create or update participant |
| `DELETE` | `/api/participants/{id}` | Delete participant and all their sessions |
| `GET` | `/api/questionnaires/{session_id}` | Get all questionnaires for session (returns a list) |
| `POST` | `/api/questionnaires/{session_id}` | Submit questionnaire for one condition (body must include `condition: 'A' \| 'B'`) |
| `POST` | `/api/pressure/{id}/upload` | Upload Max pressure CSV |
| `POST` | `/api/pressure/{id}/merge` | Run merge, returns preview + calibration thresholds + sync alignment |
| `POST` | `/api/pressure/{id}/confirm` | Confirm merge, advance status to `merged` |
| `GET` | `/api/sessions/{id}/tags` | List all tags on a session |
| `POST` | `/api/sessions/{id}/tags` | Add a tag (body: `{tag, stage?, note?, device_ms?}`) |
| `DELETE` | `/api/sessions/{id}/tags/{tag_id}` | Delete one tag |
| `GET` | `/api/tags/frequent?limit=N` | Most-used tags across all sessions, with counts |
| `GET` | `/api/diagnostics/tests` | List registered diagnostic tests |
| `POST` | `/api/diagnostics/run/{test_id}` | Run a diagnostic test, returns structured result |
| `GET` | `/api/ble/status` | BLE connection status + dropped packet count |
| `POST` | `/api/ble/phase` | Send phase command (0–9) to XIAO |
| `GET` | `/api/export/session/{id}/csv` | Download merged CSV for one session |
| `GET` | `/api/export/all` | Export all sessions as a flat CSV (aggregate scores) |
| `GET` | `/api/imu/ports` | List USB serial ports (for picking the connected insole) |
| `POST` | `/api/imu/info` | Read firmware status (`INFO` command over serial) |
| `POST` | `/api/imu/sessions/{id}/dump` | Pull flash log from one insole over USB, save as CSV |
| `POST` | `/api/imu/clear` | Wipe the flash log on the connected insole |
| `WS` | `/ws/imu` | (Legacy, unused in flash-buffer mode) Live IMU WebSocket stream |

---

## Data File Naming Conventions

| File | Path | Format |
|------|------|--------|
| Raw IMU | `data/raw/P01_A-first_raw_20260426_143000.csv` | Standard CSV with headers: `device_ms, ax, ay, az, gx, gy, gz, R_toe, R_heel, phase` |
| Max pressure | `data/raw/P01_A-first_pressure.csv` | Max semicolon-delimited single-line format |
| Merged | `data/processed/P01_A-first_merged.csv` | Standard CSV: all IMU columns + `L_toe, L_heel, R_toe, R_heel, phase` |
| Database | `data/gait_study.db` | SQLite (WAL mode) |
| Archived | `data/archive/` | Any superseded or soft-deleted file |

The `condition` field in the session row (derived from `condition_order`) is embedded in filenames at the time of recording. This ties each file back to the session and participant without opening it.

---

## Tags

The Diagnostics view aside, **tags are the main mechanism for flagging
data-quality issues during data collection**. Max/MSP misbehaves often enough
that you'll want a way to mark "this session has a caveat" without losing the
underlying data.

**During recording**, the live view has a tag panel below the recording
controls with:
- Frequently-used tag chips (one-click add) — populated from cross-session
  usage, so common issues like `max-glitch` or `phase-misfire` rise to the top.
- A custom tag input — type a new tag name to start tracking a new category.
- An optional note field for free-text annotation.

Each tag captures the **current stage** (calibration, audio_only, condition_1,
condition_2) and the **latest IMU `device_ms`** seen on the WebSocket stream,
so during analysis you can correlate flagged moments with the actual data.

**After recording**, the same panel is available on the session detail view
for retro-tagging — if you only realise the issue post-hoc, you can add the
tag with a note explaining what to consider.

**Visibility**: any session with one or more tags gets a `⚑ N` flag next to
its status in the Dashboard and History tables, so caveats are visible at a
glance without opening each session.

---

## Diagnostics

The Diagnostics view (header nav → Diagnostics) provides a runner for hardware
and system checks. Tests run on the backend and return a structured result
(pass / warn / fail + message + details + duration).

**Built-in tests:**

| Test | What it does | When to use |
|------|--------------|-------------|
| BLE Scan | Scan for `Insole_R` for 10s; if not found, list other visible BLE devices for context | Run with Max/MSP connected to test whether the XIAO is exclusively held |
| BLE Connect & Stream | Connect to the XIAO, listen 3s, count packets, report parse rate | Verifies the XIAO is alive and the firmware's UART format matches the parser |
| Database Health | Confirm WAL mode is on and all four tables exist; report row counts | First-line check after any schema or storage concern |
| Data Directories | Confirm `data/raw`, `data/processed`, `data/archive` exist and are writable | First-line check for permissions or disk issues |

**Adding a new test:** drop a function into `routers/diagnostics.py` decorated
with `@register_test("id", "Name", "description")`. It must return
`{status, message, details}` (status defaults to `pass` if the function
returns successfully). The runner adds `duration_ms` and exception handling.
The new test auto-appears in the UI — no frontend changes needed.

```python
@register_test("my_check", "My Check", "What this test does")
async def test_my_check() -> dict:
    # ... do things ...
    return {
        "status": "pass",
        "message": "short summary",
        "details": ["log line 1", "log line 2"],
    }
```

---

## Auto-Recovery on App Restart

If the app crashes or is killed mid-recording, the SQLite row stays at
`status='in-progress'` and the in-memory recorder state is lost — but the
raw IMU CSV is already on disk (writes are flushed every 100 rows).

On the next startup, `app.py:lifespan()` calls
`recover_in_progress_sessions()` which:

1. Finds all sessions with `status='in-progress'`
2. For each one with an `imu_raw_path` pointing to a real file, updates the
   status to `'imu-saved'` and appends `[Auto-recovered: marked imu-saved on
   app restart at YYYY-MM-DD HH:MM:SS]` to the notes field
3. Sessions with no `imu_raw_path` (created but never started) are left as
   `in-progress` for manual cleanup

The recovery is logged at WARNING level so you can see it in the terminal.

---

## Future Development

### High Priority

**OSC bridge to Max/MSP.**
The likely outcome of the BLE dual-connection test (see [BLE_TEST.md](BLE_TEST.md))
is that this app must be the sole BLE central. To keep Max working, add an OSC
forwarder that re-publishes pressure readings to `localhost:7400` so Max can
receive them with `[udpreceive]` instead of its own BLE connection. This is the
recommended permanent solution for the dual-connection problem.

**Pre-session firmware/Max readiness check (diagnostics).**
Add a diagnostic test that verifies the Max patch is reachable on its expected
OSC port (once the OSC bridge exists), and that the XIAO's firmware version
matches the expected packet format.

### Medium Priority

**Merged data visualisation.**
After confirming the merge, show a Chart.js plot of all channels
(L_toe, L_heel, R_toe, R_heel, ax, ay, az) over the full session duration with
vertical bands indicating each phase. This gives the researcher a visual check
of the full session before export.

**Per-participant within-session comparison.**
On the session detail page, display agency, UEQ-S, and ARI scores for
Condition A and Condition B side by side. This is the primary per-participant
analysis view.

**Configurable stage durations.**
Move the stage timers (2/2/4/4 min) from hardcoded `liveSessionData()` in
`index.html` to `config.py` or a settings panel. Required if pilot testing
suggests stage lengths need adjustment.

**Item-level export.**
The flat export (`/api/export/all`) includes aggregate scores and a single
`tag` summary column. Add an option to export raw item-level questionnaire
responses and per-tag detail (with stages and timestamps) for statistical
analysis in R or SPSS.

**Database backup on startup.**
Copy `gait_study.db` to `data/archive/gait_study_YYYYMMDD_HHMMSS.db` on each
app start. Provides a dated backup without any external tooling.

**Session resume (vs. mark-incomplete) on restart.**
Currently auto-recovery flips an in-progress session to `imu-saved` so the
researcher can run the post-session flow. A more advanced behaviour would be
to actually resume the recording — reconnect BLE, append to the existing CSV.
Higher complexity; deferred until the simpler behaviour proves insufficient.

### Lower Priority

**Left insole (Insole_L) BLE support.**
Currently only the right insole (`Insole_R`) is connected via BLE. A second
XIAO for the left foot would require a second `BLEManager` instance. Max's
pressure CSV already logs all four channels (L_toe, L_heel, R_toe, R_heel),
so left-foot data is available post-session even without this.

**Session filtering and search.**
Filter the history view by date range, completion status, participant ID,
condition order, or tag. Useful once data collection is underway.

**PDF questionnaire export.**
Generate a formatted PDF of questionnaire responses per session for archival.

### Recently Completed

These items appeared on prior versions of this list and have been implemented:

- Per-condition questionnaire flow — the form now accepts and requires a
  `condition` field and auto-selects whichever of A/B is unsubmitted
- Sync pulse alignment offset in merge preview — colour-coded card showing
  IMU↔pressure delta_ms (green ≤50ms, amber >50, red if no sync pulse)
- Session auto-recovery on app restart (mark-incomplete behaviour)
- Pressure CSV parser hardening — tracks skipped records, raises on >10%
  failure rate, stricter format detection
- Tags feature for flagging Max bugs / processing caveats / stages to revisit
- Diagnostics view with extensible test registry

---

## Integration with Existing Research Pipeline

### Initial Hardware Testing (Pre-Study)

Before this UI was built, pressure data was collected across 12 walking activities at two sensitivity levels (0.1 and 0.9) and visualised in R. Key findings from that work:

- Sensitivity 0.9 (high threshold) reliably detects footsteps across all tested activities.
- Right toe and right heel calibration threshold values appear inverted in Max's CSV output (lower bound numerically greater than upper bound). This is a quirk of Max's calibration formula, not a sensor or parsing error. The values are still usable — treat `R_toe_lower` and `R_toe_upper` as the two bounding values regardless of which is numerically greater.
- Hardware glitch records where a single sensor value exceeds 5000 (physically impossible) should be filtered in post-processing.

A sensitivity analysis at 0.1, 0.5, and 0.9 produced 27 plots (9 activities × 3 sensitivities). These inform the threshold choice for the study.

### R Analysis (Post-Study)

After all sessions are collected, the merged CSVs in `data/processed/` and the flat export from `/api/export/all` form the primary inputs for R analysis. The merged CSVs contain the full time-series data. The flat export contains one row per session with all aggregate questionnaire scores, demographics, and condition assignments — the input for statistical modelling of agency and immersion.

---

## Troubleshooting

**Always start with the Diagnostics view** (header nav → Diagnostics) before
deeper investigation. The four built-in tests will isolate most issues to the
specific subsystem (BLE, database, filesystem) within seconds.

**App won't start / module not found:**
Make sure the virtual environment is activated: `source .venv/bin/activate`

**BLE connection fails:**
- Run the **BLE Scan** diagnostic test first. If `Insole_R` isn't visible, the
  test will list other BLE devices that ARE visible — useful for confirming
  the laptop's Bluetooth is working at all.
- Confirm the XIAO is powered and advertising as `Insole_R`.
- On macOS, grant Bluetooth permission to Terminal (or iTerm2) in
  **System Settings > Privacy & Security > Bluetooth**.
- If Max is already connected and the scan fails, the XIAO is likely held
  exclusively by Max. See [BLE_TEST.md](BLE_TEST.md) for the dual-connection
  test procedure and fallback strategies.

**Pressure CSV import fails:**
- The parser expects Max's semicolon-delimited single-line format, or a standard
  CSV with `device_ms`, `L_toe`, `L_heel`, `R_toe`, `R_heel` columns.
- If more than 10% of records fail to parse, the parser rejects the file with
  a clear error. A small skip count (≤10%) is reported as a warning during
  merge but does not block the import.
- If the file is empty or Max did not save correctly, check Max's file output
  object and its folder path.

**Merge produces no-overlap warning or large sync delta:**
- This usually means the `device_ms` clocks in the IMU and pressure files do
  not share the same reference epoch.
- Check the **Sync alignment card** in the merge preview — if the delta is
  >50ms (amber) something is off; if it shows "no sync pulse found" (red),
  the participant likely didn't perform the calibration stamp during the
  Calibration stage.
- Confirm that both the XIAO firmware and Max are reading the same firmware
  clock for their `device_ms` values.

**Session stuck at "in-progress" but recording is over:**
This shouldn't happen normally — but if it does (e.g. browser closed and stop
button never clicked), restart the app. The auto-recovery on startup will
flip in-progress sessions with an existing CSV to `imu-saved` and append a
recovery marker to the notes field.

**Data appears to be lost:**
- Raw CSVs are written incrementally and flushed every 100 rows. Even if the
  browser tab closes, the backend keeps recording until the app process exits.
- Deleted sessions move files to `data/archive/`, never permanently remove them.
- The SQLite database uses WAL mode to survive unclean shutdowns.

**Questionnaire already submitted — cannot edit:**
By design. Questionnaire responses are immutable after submission to prevent
post-hoc modification of study data. If a response was submitted in error, it
must be handled manually in the database or by deleting and recreating the
session.

**Questionnaire submission returns 422:**
This was a bug in earlier versions where the frontend didn't send the
`condition` field. Fixed — but if you see it, confirm you're running the
latest static JS (hard-refresh the browser to clear cached
`questionnaire.js`).
