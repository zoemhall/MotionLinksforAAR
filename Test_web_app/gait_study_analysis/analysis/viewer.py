"""Gait Study — Pressure + IMU Time Series Viewer

Interactive analysis tool for exploring and comparing pressure insole data
alongside IMU (accelerometer/gyroscope) data across participants and sessions.

Launch:
    streamlit run analysis/viewer.py
"""
from __future__ import annotations

import sqlite3
import sys
from pathlib import Path

import numpy as np
import pandas as pd
import plotly.graph_objects as go
import streamlit as st
from plotly.subplots import make_subplots

ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(ROOT))

DB_PATH = ROOT / "data" / "gait_study.db"
ALIGNED_DIR = ROOT / "analysis" / "test5_aligned"
ALIGNMENT_REPORT = ROOT / "analysis" / "test5_alignment_report.csv"
LEGACY_DATA_DIR = ROOT / "data"  # parent of "Test 3/Raw data/{pid}/" etc.

PRESSURE_ZONES = ["L_toe", "L_heel", "R_toe", "R_heel"]
IMU_ACCEL_COLS = {"L": ["l_ax", "l_ay", "l_az"], "R": ["r_ax", "r_ay", "r_az"]}
IMU_GYRO_COLS  = {"L": ["l_gx", "l_gy", "l_gz"], "R": ["r_gx", "r_gy", "r_gz"]}
IMU_FORCE_COLS = {"L": ["l_imu_heel"], "R": ["r_imu_heel"]}

PARTICIPANT_COLORS = ["#1f77b4", "#d62728", "#2ca02c", "#ff7f0e"]

# Fixed per-zone accent colors for IMU force overlaid on raw pressure rows (heel only — ankle IMU)
FORCE_OVERLAY_ZONES = [
    ("L heel", "l_imu_heel", "#e67e22"),  # orange
    ("R heel", "r_imu_heel", "#1abc9c"),  # teal
]

STAGE_COLORS = {
    "calibration": "rgba(180,180,180,0.15)",
    "audio_only":  "rgba(100,160,255,0.12)",
    "condition_1": "rgba(255,200,100,0.15)",
    "condition_2": "rgba(100,220,160,0.15)",
}
GAP_COLOR = "rgba(60,60,60,0.18)"

MAX_PLOT_POINTS = 8000
STANCE_MIN_MS   = 80.0
STANCE_MAX_MS   = 2000.0


# ── DB helpers ────────────────────────────────────────────────────────────────

@st.cache_data(ttl=60)
def get_test_types() -> list[dict]:
    con = sqlite3.connect(DB_PATH)
    rows = con.execute("SELECT test_type_id, name FROM test_types ORDER BY test_type_id").fetchall()
    con.close()
    return [{"id": r[0], "name": r[1]} for r in rows]


@st.cache_data(ttl=60)
def get_sessions(test_type_id: int) -> pd.DataFrame:
    con = sqlite3.connect(DB_PATH)
    df = pd.read_sql(
        """SELECT s.session_id, s.participant_id, s.condition_order,
                  s.tempo_direction, s.weight_direction, s.status,
                  s.imu_raw_path, s.pressure_raw_path, s.merged_path,
                  t.has_imu_dump, t.has_pressure_merge
           FROM sessions s
           JOIN test_types t ON t.test_type_id = s.test_type_id
           WHERE s.test_type_id = ?
           ORDER BY s.participant_id, s.session_id""",
        con, params=(test_type_id,),
    )
    con.close()
    return df


@st.cache_data(ttl=300)
def load_alignment_report() -> pd.DataFrame | None:
    if not ALIGNMENT_REPORT.exists():
        return None
    return pd.read_csv(ALIGNMENT_REPORT)


def load_session_notes(session_id: int) -> str:
    """Load notes_data for a session — not cached so it stays fresh after saves."""
    con = sqlite3.connect(DB_PATH)
    row = con.execute(
        "SELECT notes_data FROM sessions WHERE session_id=?", (session_id,)
    ).fetchone()
    con.close()
    return (row[0] or "") if row else ""


def save_session_notes(session_id: int, text: str) -> None:
    con = sqlite3.connect(DB_PATH)
    con.execute("UPDATE sessions SET notes_data=? WHERE session_id=?", (text, session_id))
    con.commit()
    con.close()


def load_session_tags(session_id: int) -> list[dict]:
    con = sqlite3.connect(DB_PATH)
    rows = con.execute(
        "SELECT tag_id, tag, stage, note, device_ms, created_at "
        "FROM session_tags WHERE session_id=? ORDER BY created_at",
        (session_id,),
    ).fetchall()
    con.close()
    return [{"tag_id": r[0], "tag": r[1], "stage": r[2], "note": r[3],
             "device_ms": r[4], "created_at": r[5]} for r in rows]


def add_session_tag(session_id: int, tag: str, note: str = "") -> None:
    con = sqlite3.connect(DB_PATH)
    con.execute(
        "INSERT INTO session_tags (session_id, tag, note) VALUES (?, ?, ?)",
        (session_id, tag.strip(), note.strip()),
    )
    con.commit()
    con.close()


def delete_session_tag(tag_id: int) -> None:
    con = sqlite3.connect(DB_PATH)
    con.execute("DELETE FROM session_tags WHERE tag_id=?", (tag_id,))
    con.commit()
    con.close()


@st.cache_data(ttl=120)
def load_frequent_tags(limit: int = 10) -> list[str]:
    con = sqlite3.connect(DB_PATH)
    rows = con.execute(
        "SELECT tag FROM session_tags GROUP BY tag ORDER BY COUNT(*) DESC LIMIT ?",
        (limit,),
    ).fetchall()
    con.close()
    return [r[0] for r in rows]


def _ensure_imu_offset_col() -> None:
    con = sqlite3.connect(DB_PATH)
    try:
        con.execute("ALTER TABLE sessions ADD COLUMN imu_viewer_offset_s REAL DEFAULT 0.0")
        con.commit()
    except sqlite3.OperationalError:
        pass
    con.close()


@st.cache_data(ttl=None)
def load_imu_offset(session_id: int) -> float:
    con = sqlite3.connect(DB_PATH)
    try:
        row = con.execute(
            "SELECT imu_viewer_offset_s FROM sessions WHERE session_id=?", (session_id,)
        ).fetchone()
    except sqlite3.OperationalError:
        row = None
    con.close()
    return float(row[0] or 0.0) if row else 0.0


def save_imu_offset(session_id: int, offset_s: float) -> None:
    con = sqlite3.connect(DB_PATH)
    con.execute(
        "UPDATE sessions SET imu_viewer_offset_s=? WHERE session_id=?", (offset_s, session_id)
    )
    con.commit()
    con.close()
    load_imu_offset.clear()  # bust cache so next read picks up the new value


# ── Data loading ──────────────────────────────────────────────────────────────

def find_merged_csv(pid: str, test_type_id: int | None = None) -> Path | None:
    if test_type_id is not None and test_type_id != 5:
        return None  # aligned CSVs only exist for Test 5
    p = ALIGNED_DIR / f"{pid}_combined.csv"
    return p if p.exists() else None


def find_legacy_merged_csv(pid: str, test_type_id: int) -> Path | None:
    """Find a merged CSV for Tests 3–4 (right-foot-only, no stage labels)."""
    p = LEGACY_DATA_DIR / f"Test {test_type_id}" / "Raw data" / pid / f"{pid}_merged.csv"
    return p if p.exists() else None


@st.cache_data(show_spinner=False)
def load_from_legacy_merged(pid: str, test_type_id: int) -> dict | None:
    """Load Tests 3–4 merged CSV, normalising columns to match the viewer's expected format.

    These files contain right-foot-only IMU data (ax/ay/az/gx/gy/gz) and pressure
    (toe/heel) with no stage labels and no left-foot data.  The viewer's condition
    effects and review panels are silently skipped (stages=[]).  Raw pressure and IMU
    traces, and basic cadence detection, are available.
    """
    path = find_legacy_merged_csv(pid, test_type_id)
    if path is None:
        return None
    try:
        df = pd.read_csv(path, low_memory=False)
    except Exception:
        return None
    if df.empty:
        return None

    # Synthesise session_ms from device_ms (offset from first sample)
    if "device_ms" in df.columns:
        df["session_ms"] = (df["device_ms"] - df["device_ms"].iloc[0]).clip(lower=0)
    else:
        df["session_ms"] = np.arange(len(df)) * 5.0   # ~200 Hz fallback

    # Map generic toe/heel → R_toe/R_heel (right foot only in these files).
    # The merged format already has R_toe/R_heel columns but they are all NaN;
    # always overwrite from the populated toe/heel columns.
    if "toe" in df.columns:
        df["R_toe"] = df["toe"]
    if "heel" in df.columns:
        df["R_heel"] = df["heel"]

    # Map unlabelled IMU axes → right-foot named columns expected by the viewer
    rename = {"ax": "r_ax", "ay": "r_ay", "az": "r_az",
              "gx": "r_gx", "gy": "r_gy", "gz": "r_gz"}
    for old, new in rename.items():
        if old in df.columns and new not in df.columns:
            df[new] = df[old]

    # Ensure stage column exists (empty — no stage events for legacy tests)
    if "stage" not in df.columns:
        df["stage"] = ""

    stages = []   # no stage events → condition effects/review panels skipped gracefully
    pressure_df, imu_df = _split_pressure_imu(df)
    return {
        "source": "legacy",
        "pressure_df": pressure_df,
        "imu_df": imu_df,
        "stages": stages,
        "offset_ms": None,
        "flags": ["LEGACY_FORMAT — right foot only, no stage labels, no condition analysis"],
        "legacy_test_type": test_type_id,
    }


_TEST_TYPE_DIRS = {1: "Test 1", 2: "Test 2", 3: "Test 3", 4: "Test 4", 5: "Test 5"}


def participant_raw_dir(pid: str, test_type_id: int | None = None) -> Path | None:
    search = ([_TEST_TYPE_DIRS[test_type_id]] if test_type_id in _TEST_TYPE_DIRS
              else list(_TEST_TYPE_DIRS.values()))
    for test in search:
        p = ROOT / "data" / test / "Raw data" / pid
        if p.exists():
            return p
    return None


@st.cache_data(ttl=300)
def load_thresholds(pid: str) -> dict | None:
    from analysis.test5_gait_analysis import parse_condition_file
    base = participant_raw_dir(pid)
    if base is None:
        return None
    for stem in ("tempo", "weight", "pondering"):
        path = base / f"{pid}_pressure_{stem}.csv"
        if path.exists():
            try:
                _, thresholds = parse_condition_file(path)
                if thresholds:
                    return thresholds
            except Exception:
                continue
    return None


@st.cache_data(ttl=300)
def load_threshold_timeseries(pid: str) -> pd.DataFrame | None:
    """Return per-row threshold columns from raw condition files, keyed by device_ms."""
    from analysis.test5_gait_analysis import parse_condition_file
    base = participant_raw_dir(pid)
    if base is None:
        return None
    thresh_cols = [f"{z}_{b}" for z in ("L_toe", "L_heel", "R_toe", "R_heel") for b in ("lower", "upper")]
    frames = []
    for stem in ("pondering", "tempo", "weight"):
        path = base / f"{pid}_pressure_{stem}.csv"
        if path.exists():
            try:
                df, _ = parse_condition_file(path)
                if "device_ms" in df.columns and all(c in df.columns for c in thresh_cols):
                    frames.append(df[["device_ms"] + thresh_cols])
            except Exception:
                continue
    if not frames:
        return None
    combined = pd.concat(frames, ignore_index=True).sort_values("device_ms").drop_duplicates("device_ms")
    return combined


def _stages_from_df(df: pd.DataFrame) -> list[dict]:
    if "stage" not in df.columns or "session_ms" not in df.columns:
        return []
    stages = []
    for stage_name, grp in df.groupby("stage", sort=False):
        stages.append({
            "name": stage_name,
            "start_s": float(grp["session_ms"].min()) / 1000.0,
            "end_s":   float(grp["session_ms"].max()) / 1000.0,
        })
    return sorted(stages, key=lambda x: x["start_s"])


def _split_pressure_imu(df: pd.DataFrame) -> tuple[pd.DataFrame, pd.DataFrame]:
    imu_candidate_cols = (
        [c for side in IMU_ACCEL_COLS.values() for c in side]
        + [c for side in IMU_GYRO_COLS.values() for c in side]
        + [c for side in IMU_FORCE_COLS.values() for c in side]
    )
    imu_present = [c for c in imu_candidate_cols if c in df.columns]

    pres_cols = ["session_ms"]
    for extra in ("device_ms", "bpm", "ratio", "condition"):
        if extra in df.columns:
            pres_cols.append(extra)
    pres_cols += [z for z in PRESSURE_ZONES if z in df.columns]
    if "stage" in df.columns:
        pres_cols.append("stage")
    # Include per-row threshold columns and IMU heel force (needed for condition effects analysis)
    for extra in ("L_toe_lower", "L_toe_upper", "L_heel_lower", "L_heel_upper",
                  "R_toe_lower", "R_toe_upper", "R_heel_lower", "R_heel_upper",
                  "l_imu_heel", "r_imu_heel"):
        if extra in df.columns and extra not in pres_cols:
            pres_cols.append(extra)
    pressure_df = df[pres_cols].copy()

    if imu_present:
        imu_mask = df[imu_present].notna().any(axis=1)
        imu_extra = ["stage"] if "stage" in df.columns else []
        imu_df = df.loc[imu_mask, ["session_ms"] + imu_extra + imu_present].copy()
    else:
        imu_df = pd.DataFrame(columns=["session_ms"])

    return pressure_df, imu_df


@st.cache_data(show_spinner=False)
def load_from_merged_csv(pid: str, test_type_id: int | None = None) -> dict | None:
    path = find_merged_csv(pid, test_type_id)
    if path is None:
        return None
    df = pd.read_csv(path)
    if df.empty or "session_ms" not in df.columns:
        return None
    stages = _stages_from_df(df)
    pressure_df, imu_df = _split_pressure_imu(df)
    return {"source": "merged", "pressure_df": pressure_df, "imu_df": imu_df,
            "stages": stages, "offset_ms": None, "flags": []}


@st.cache_data(show_spinner=False)
def load_from_raw(session_id: int, pid: str) -> dict | None:
    from analysis.align_test5_imu_pressure import process_participant
    con = sqlite3.connect(DB_PATH)
    session_row = pd.read_sql(
        "SELECT * FROM sessions WHERE session_id=?", con, params=(session_id,)
    ).iloc[0]
    all_stage_events = pd.read_sql(
        "SELECT sse.session_id, sse.stage_id, sse.started_at "
        "FROM session_stage_events sse WHERE sse.session_id=?",
        con, params=(session_id,),
    )
    con.close()
    all_stage_events["started_at"] = pd.to_datetime(all_stage_events["started_at"])
    combined, report = process_participant(session_row, all_stage_events)
    if combined is None or combined.empty:
        return None
    stages = _stages_from_df(combined)
    pressure_df, imu_df = _split_pressure_imu(combined)
    return {"source": "raw", "pressure_df": pressure_df, "imu_df": imu_df,
            "stages": stages, "offset_ms": report.get("imu_l_offset_ms"),
            "flags": report.get("flags", [])}


def load_session_data(session_id: int, pid: str) -> dict | None:
    con = sqlite3.connect(DB_PATH)
    row = con.execute(
        "SELECT test_type_id, tempo_direction, weight_direction FROM sessions WHERE session_id=?",
        (session_id,),
    ).fetchone()
    con.close()
    test_type_id  = int(row[0]) if row else None
    tempo_dir     = row[1] if row else None
    weight_dir    = row[2] if row else None

    data = load_from_merged_csv(pid, test_type_id)
    if data is None and test_type_id == 5:
        data = load_from_raw(session_id, pid)
    if data is None and test_type_id in (3, 4):
        data = load_from_legacy_merged(pid, test_type_id)
    if data is not None:
        data["thresholds"]       = load_thresholds(pid)
        data["tempo_direction"]  = tempo_dir
        data["weight_direction"] = weight_dir

        # Load condition phase timings from stage events
        phase_bounds: dict[str, dict] = {}
        try:
            with sqlite3.connect(DB_PATH) as _con:
                evts = pd.read_sql(
                    "SELECT stage_id, started_at FROM session_stage_events WHERE session_id=?",
                    _con, params=(session_id,),
                )
            for cond_n in ("condition_1", "condition_2"):
                onset_row  = evts[evts["stage_id"] == f"{cond_n}_onset"]
                main_row   = evts[evts["stage_id"] == cond_n]
                offset_row = evts[evts["stage_id"] == f"{cond_n}_offset"]
                if not onset_row.empty and not main_row.empty:
                    t0 = pd.to_datetime(onset_row["started_at"].iloc[0])
                    drift_in_end = (pd.to_datetime(main_row["started_at"].iloc[0]) - t0).total_seconds()
                else:
                    drift_in_end = 15.0
                if not onset_row.empty and not offset_row.empty:
                    t0 = pd.to_datetime(onset_row["started_at"].iloc[0])
                    drift_out_start = (pd.to_datetime(offset_row["started_at"].iloc[0]) - t0).total_seconds()
                else:
                    drift_out_start = 75.0
                phase_bounds[cond_n] = {
                    "drift_in_end":    drift_in_end,
                    "drift_out_start": drift_out_start,
                    "nominal_end":     drift_out_start + 15.0,
                }
        except Exception:
            pass  # fall back to hardcoded defaults in renderer
        data["phase_bounds"] = phase_bounds

    return data


# ── Gait metrics ──────────────────────────────────────────────────────────────

def _detect_steps_dynamic(pressure_df: pd.DataFrame) -> np.ndarray:
    """Detect step events via scipy find_peaks on toe (+ heel fallback) zones.

    Improvements over the naive 65th-percentile approach:
    - Calibration phase (standing still) is excluded before computing thresholds
      so the still-standing baseline doesn't push the threshold above walking peaks.
    - dt_ms ignores large inter-phase gaps (e.g. split sessions) when estimating
      the sampling interval.
    - Each zone's signal is normalised 0-1 before detection so amplitude variation
      across participants doesn't matter.
    - Prominence-based detection (robust to slow baseline drift) is tried first;
      falls back to height-only if it finds fewer peaks than that approach.
    - Heel signals are used as a secondary source whenever a foot's toe signal
      yields fewer than 20 peaks.
    """
    from scipy.signal import find_peaks

    # Exclude calibration: participant stands still → biases thresholds upward
    if "stage" in pressure_df.columns:
        pres = pressure_df[pressure_df["stage"] != "calibration"].copy()
    else:
        pres = pressure_df.copy()
    if len(pres) < 20:
        pres = pressure_df.copy()   # fall back to full data if nothing left

    pres = pres.sort_values("session_ms").reset_index(drop=True)
    t_ms = pres["session_ms"].values

    # Estimate dt_ms ignoring large inter-phase gaps (> 5 s)
    diffs = np.diff(t_ms)
    intra_diffs = diffs[diffs < 5_000]
    dt_ms = float(np.median(intra_diffs)) if len(intra_diffs) > 0 else 20.0
    dt_ms = max(dt_ms, 1.0)
    min_dist = max(1, int(350 / dt_ms))   # 350 ms → ~170 BPM max per foot

    def _peaks_for_signal(sig: np.ndarray) -> np.ndarray:
        """Return peak indices using prominence-based detection on a normalised signal."""
        p1, p99 = np.percentile(sig, 1), np.percentile(sig, 99)
        if p99 - p1 < 1.0:
            return np.array([], dtype=int)
        sig_n = np.clip((sig - p1) / (p99 - p1), 0.0, 1.0)

        # Prominence-based: robust to slow drift
        peaks_prom, _ = find_peaks(sig_n, height=0.15, prominence=0.10, distance=min_dist)
        # Height-only (65th-percentile on normalised ≈ 0.35 above floor)
        peaks_h65,  _ = find_peaks(sig_n, height=float(np.percentile(sig_n, 65)), distance=min_dist)
        # Return whichever found more peaks
        return peaks_prom if len(peaks_prom) >= len(peaks_h65) else peaks_h65

    all_peaks_ms: list[float] = []
    for foot, toe_col, heel_col in [("L", "L_toe", "L_heel"), ("R", "R_toe", "R_heel")]:
        primary_peaks: np.ndarray = np.array([], dtype=int)
        if toe_col in pres.columns:
            primary_peaks = _peaks_for_signal(pres[toe_col].values.astype(float))

        # Use heel as fallback / supplement when toe gives very few peaks
        if len(primary_peaks) < 20 and heel_col in pres.columns:
            heel_peaks = _peaks_for_signal(pres[heel_col].values.astype(float))
            if len(heel_peaks) > len(primary_peaks):
                primary_peaks = heel_peaks

        all_peaks_ms.extend(t_ms[primary_peaks].tolist())

    all_peaks_ms.sort()
    # Widen merge window to 350 ms — L→R spacing at 90-120 BPM is ~250-315 ms,
    # so the old 200 ms window missed most pairs and inflated baseline CV by ~6×.
    # 350 ms stays below the minimum same-foot interval enforced by min_dist.
    deduped: list[float] = []
    for ts in all_peaks_ms:
        if not deduped or ts - deduped[-1] >= 350:
            deduped.append(ts)
    return np.array(deduped)


def compute_cadence(pressure_df: pd.DataFrame, thresholds: dict) -> pd.DataFrame:
    if "session_ms" not in pressure_df.columns:
        return pd.DataFrame(columns=["session_ms", "cadence_bpm", "bpm_raw", "audio_bpm"])

    step_arr = _detect_steps_dynamic(pressure_df)
    if len(step_arr) < 2:
        return pd.DataFrame(columns=["session_ms", "cadence_bpm", "bpm_raw", "audio_bpm"])

    intervals_ms = np.diff(step_arr)
    bpm_inst = 60_000.0 / intervals_ms
    midpoint_ms = (step_arr[:-1] + step_arr[1:]) / 2.0

    valid = (bpm_inst >= 30) & (bpm_inst <= 200)
    bpm_inst = bpm_inst[valid]
    midpoint_ms = midpoint_ms[valid]
    if len(bpm_inst) == 0:
        return pd.DataFrame(columns=["session_ms", "cadence_bpm", "bpm_raw", "audio_bpm"])

    window = min(5, len(bpm_inst))
    bpm_smooth = pd.Series(bpm_inst).rolling(window, center=True, min_periods=1).mean().values
    cadence_df = pd.DataFrame({"session_ms": midpoint_ms, "cadence_bpm": bpm_smooth, "bpm_raw": bpm_inst})

    audio_df = pd.DataFrame(columns=["session_ms", "audio_bpm"])
    if "bpm" in pressure_df.columns and "ratio" in pressure_df.columns:
        audio_mask = pressure_df["bpm"].notna() & pressure_df["ratio"].notna()
        if audio_mask.any():
            ab = pressure_df.loc[audio_mask, ["session_ms", "bpm", "ratio"]].copy()
            ab["audio_bpm"] = ab["bpm"] * ab["ratio"]
            audio_df = ab[["session_ms", "audio_bpm"]]

    if not audio_df.empty:
        result = pd.merge_asof(
            cadence_df.sort_values("session_ms"),
            audio_df.sort_values("session_ms"),
            on="session_ms", direction="nearest", tolerance=2000.0,
        )
    else:
        result = cadence_df.assign(audio_bpm=np.nan)
    return result


def detect_foot_contacts(pressure_df: pd.DataFrame, thresholds: dict) -> pd.DataFrame:
    if "session_ms" not in pressure_df.columns:
        return pd.DataFrame(columns=["session_ms", "foot", "stance_ms", "interval_ms"])

    pres = pressure_df.sort_values("session_ms").reset_index(drop=True)
    rows_out = []
    for foot, heel_zone in (("L", "L_heel"), ("R", "R_heel")):
        if heel_zone not in pres.columns:
            continue
        has_dynamic = f"{heel_zone}_lower" in pres.columns and f"{heel_zone}_upper" in pres.columns

        in_contact = False
        t_start = 0.0
        contact_peak = 0.0   # track peak signal during contact (for amplitude metric)
        last_start: float | None = None
        for i in range(len(pres)):
            row = pres.iloc[i]
            sess_ms = float(row["session_ms"])
            val = float(row.get(heel_zone) or 0)
            if has_dynamic:
                lower = float(row.get(f"{heel_zone}_lower") or 0)
                upper = float(row.get(f"{heel_zone}_upper") or 0)
            else:
                t = thresholds.get(heel_zone) or {}
                lower = t.get("lower", 0)
                upper = t.get("upper", 0)
            if upper <= 0:
                continue
            if not in_contact:
                if val >= upper * 0.6:  # 60% of upper threshold to enter contact
                    in_contact = True
                    t_start = sess_ms
                    contact_peak = val
            else:
                if val > contact_peak:
                    contact_peak = val
                if val <= lower:  # <= catches signal equal to calibrated floor (common at swing)
                    stance_ms = sess_ms - t_start
                    if STANCE_MIN_MS <= stance_ms <= STANCE_MAX_MS:
                        interval_ms = (t_start - last_start) if last_start is not None else np.nan
                        rows_out.append({"session_ms": t_start, "foot": foot,
                                         "stance_ms": stance_ms, "interval_ms": interval_ms,
                                         "heel_peak": contact_peak})
                        last_start = t_start
                    in_contact = False

    return pd.DataFrame(rows_out) if rows_out else pd.DataFrame(
        columns=["session_ms", "foot", "stance_ms", "interval_ms", "heel_peak"])


# ── Downsampling ──────────────────────────────────────────────────────────────

def downsample(df: pd.DataFrame, max_pts: int = MAX_PLOT_POINTS) -> pd.DataFrame:
    if len(df) <= max_pts:
        return df
    step = max(1, len(df) // max_pts)
    return df.iloc[::step].copy()


# ── Plot helpers ──────────────────────────────────────────────────────────────

def _smooth_band(s: pd.Series, window: int) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Centered rolling mean ± 1 std. Returns (mean, lower, upper)."""
    r = s.rolling(window, center=True, min_periods=1)
    mean = r.mean().values
    std  = r.std(ddof=1).fillna(0).values
    return mean, mean - std, mean + std


def _cv_annotation(fig: go.Figure, values: np.ndarray, row_n: int) -> None:
    """Add a CV% annotation in the top-left corner of a subplot."""
    m = np.nanmean(values)
    if m and m != 0:
        cv = float(np.nanstd(values) / abs(m) * 100)
        fig.add_annotation(
            x=0.01, y=0.97, xref="x domain", yref="y domain",
            text=f"CV {cv:.1f}%", showarrow=False,
            font={"size": 9, "color": "#888"}, yanchor="top",
            row=row_n, col=1,
        )


def _add_band_traces(
    fig: go.Figure,
    t_s: np.ndarray,
    values: pd.Series,
    window: int,
    color_hex: str,
    name: str,
    legendgroup: str,
    row_n: int,
    showlegend: bool = True,
    hovertemplate: str = "",
) -> None:
    """Add raw markers + rolling mean line + ±1 std shaded band to a subplot."""
    mean, lower, upper = _smooth_band(values, window)

    # Parse hex color to rgba for fill
    h = color_hex.lstrip("#")
    r, g, b = int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)
    fill_color = f"rgba({r},{g},{b},0.18)"
    line_color  = f"rgba({r},{g},{b},0.0)"

    # Raw dots underneath
    fig.add_trace(
        go.Scattergl(
            x=t_s, y=values.values, mode="markers",
            name=f"{name} (raw)", marker={"size": 3, "color": color_hex, "opacity": 0.3},
            legendgroup=legendgroup, showlegend=False,
            hovertemplate=hovertemplate,
        ),
        row=row_n, col=1,
    )
    # Upper bound (invisible line to anchor fill)
    fig.add_trace(
        go.Scattergl(
            x=t_s, y=upper, mode="lines",
            line={"color": line_color, "width": 0},
            legendgroup=legendgroup, showlegend=False, hoverinfo="skip",
        ),
        row=row_n, col=1,
    )
    # Lower bound fills to upper
    fig.add_trace(
        go.Scattergl(
            x=t_s, y=lower, mode="lines", fill="tonexty",
            fillcolor=fill_color, line={"color": line_color, "width": 0},
            legendgroup=legendgroup, showlegend=False, hoverinfo="skip",
        ),
        row=row_n, col=1,
    )
    # Mean line on top
    fig.add_trace(
        go.Scattergl(
            x=t_s, y=mean, mode="lines",
            name=name, line={"color": color_hex, "width": 2},
            legendgroup=legendgroup, showlegend=showlegend,
            hovertemplate=hovertemplate,
        ),
        row=row_n, col=1,
    )


def _accel_mag(imu_df: pd.DataFrame, side: str) -> pd.Series | None:
    cols = [c for c in IMU_ACCEL_COLS[side] if c in imu_df.columns]
    if not cols:
        return None
    return np.sqrt(sum(imu_df[c] ** 2 for c in cols))


def _gyro_mag(imu_df: pd.DataFrame, side: str) -> pd.Series | None:
    cols = [c for c in IMU_GYRO_COLS[side] if c in imu_df.columns]
    if not cols:
        return None
    return np.sqrt(sum(imu_df[c] ** 2 for c in cols))


def _cal_baseline(df: pd.DataFrame, col: str) -> tuple[float, float]:
    if "stage" not in df.columns:
        return float(df[col].mean()), max(float(df[col].std()), 1e-6)
    cal = df[df["stage"] == "calibration"][col].dropna()
    if len(cal) < 5:
        return float(df[col].mean()), max(float(df[col].std()), 1e-6)
    return float(cal.mean()), max(float(cal.std()), 1e-6)


def _add_stage_bands(
    fig: go.Figure,
    stages: list[dict],
    n_rows: int,
    data_start_s: float | None = None,
    data_end_s: float | None = None,
) -> None:
    """Draw stage coloured bands and grey gaps between them."""
    if not stages:
        return

    # Grey gaps between consecutive stages
    gap_regions: list[tuple[float, float]] = []
    for i in range(len(stages) - 1):
        gap_start = stages[i]["end_s"]
        gap_end   = stages[i + 1]["start_s"]
        if gap_end - gap_start > 0.5:
            gap_regions.append((gap_start, gap_end))

    # Grey gap before first stage (if data starts earlier)
    if data_start_s is not None and stages[0]["start_s"] - data_start_s > 0.5:
        gap_regions.append((data_start_s, stages[0]["start_s"]))

    # Grey gap after last stage (if data extends further)
    if data_end_s is not None and data_end_s - stages[-1]["end_s"] > 0.5:
        gap_regions.append((stages[-1]["end_s"], data_end_s))

    for g0, g1 in gap_regions:
        for row_n in range(1, n_rows + 1):
            fig.add_vrect(x0=g0, x1=g1, fillcolor=GAP_COLOR, line_width=0, row=row_n, col=1)

    # Stage coloured bands
    for stage_info in stages:
        color = STAGE_COLORS.get(stage_info["name"], "rgba(200,200,200,0.1)")
        for row_n in range(1, n_rows + 1):
            fig.add_vrect(
                x0=stage_info["start_s"], x1=stage_info["end_s"],
                fillcolor=color, line_width=0, row=row_n, col=1,
            )
        # Label at top of figure (no subplot_titles means y=1.02 is free)
        mid_s = (stage_info["start_s"] + stage_info["end_s"]) / 2.0
        fig.add_annotation(
            x=mid_s, y=1.02,
            xref="x", yref="paper",
            text=stage_info["name"].replace("_", " "),
            showarrow=False,
            font={"size": 9, "color": "#555"},
            yanchor="bottom",
        )


# ── Condition effects helpers ─────────────────────────────────────────────────

def compute_baseline_metrics(pres_df: pd.DataFrame, thresholds: dict | None) -> dict:
    """Compute cadence, stance, IMU, and heel-peak baseline from the last 30 s of audio_only."""
    result = {
        "cadence_mean": np.nan, "cadence_std": np.nan,
        "stance_mean":  np.nan, "stance_std":  np.nan,
        "imu_mean":     np.nan, "imu_std":     np.nan,
        "heel_peak_mean": np.nan, "heel_peak_std": np.nan,
    }
    if "stage" not in pres_df.columns:
        return result

    ao = pres_df[pres_df["stage"] == "audio_only"].copy().sort_values("session_ms").reset_index(drop=True)

    # Fallback: if audio_only is absent (e.g. split session where pondering came from
    # a different DB record), use the pre-ramp rows from any condition stage where the
    # manipulation has not yet started (ratio ≈ 1.0, first 20 s of earliest condition).
    if ao.empty or len(ao) < 10:
        cond_stages = [s for s in ["condition_1", "condition_2"]
                       if s in pres_df.get("stage", pd.Series(dtype=str)).values]
        for stg in sorted(cond_stages):
            sub = pres_df[pres_df["stage"] == stg].sort_values("session_ms").reset_index(drop=True)
            if "ratio" in sub.columns:
                pre = sub[abs(sub["ratio"].fillna(1.0) - 1.0) < 0.005]
            else:
                pre = sub.head(int(20_000 / max(1, float(np.median(np.diff(sub["session_ms"].values[:50]))) if len(sub) > 1 else 30)))
            if len(pre) >= 10:
                ao = pre.copy()
                break

    if ao.empty or len(ao) < 10:
        return result

    stage_duration_ms = float(ao["session_ms"].max() - ao["session_ms"].min())
    stage_end_ms      = float(ao["session_ms"].max())

    # Last 30 s; fallback to last 50 % of rows when the stage is shorter than 45 s
    if stage_duration_ms >= 45_000:
        baseline = ao[ao["session_ms"] >= stage_end_ms - 30_000].copy()
    else:
        n = len(ao)
        baseline = ao.iloc[n // 2:].copy()

    if len(baseline) < 10:
        return result

    # Cadence
    step_arr = _detect_steps_dynamic(baseline)
    if len(step_arr) >= 3:
        intervals_ms = np.diff(step_arr)
        bpm_vals = 60_000.0 / intervals_ms
        valid = (bpm_vals >= 30) & (bpm_vals <= 200)
        bpm_vals = bpm_vals[valid]
        if len(bpm_vals) >= 2:
            result["cadence_mean"] = float(np.mean(bpm_vals))
            # Apply 5-point rolling mean before computing std: this removes
            # detector noise (spurious short/long intervals from missed peaks)
            # so baseline_std reflects real walking-pace variability rather
            # than measurement error, consistent with smoothed condition data.
            w = min(5, len(bpm_vals))
            bpm_sm = pd.Series(bpm_vals).rolling(w, center=True, min_periods=1).mean().values
            result["cadence_std"] = float(np.std(bpm_sm, ddof=1)) if len(bpm_sm) > 1 else 0.0

    # Stance + heel peak amplitude
    contacts = detect_foot_contacts(baseline, thresholds or {})
    if not contacts.empty and "stance_ms" in contacts.columns:
        sv = contacts["stance_ms"].values
        if len(sv) >= 3:
            result["stance_mean"] = float(np.mean(sv))
            # Smooth before std for consistency with condition rolling-mean analysis
            sw_win = min(5, len(sv))
            sv_sm = pd.Series(sv).rolling(sw_win, center=True, min_periods=1).mean().values
            result["stance_std"] = float(np.std(sv_sm, ddof=1)) if len(sv_sm) > 1 else 0.0
        if "heel_peak" in contacts.columns:
            pv = contacts["heel_peak"].dropna().values
            if len(pv) >= 3:
                result["heel_peak_mean"] = float(np.mean(pv))
                pw = min(5, len(pv))
                pv_sm = pd.Series(pv).rolling(pw, center=True, min_periods=1).mean().values
                result["heel_peak_std"] = float(np.std(pv_sm, ddof=1)) if len(pv_sm) > 1 else 0.0

    # IMU heel force
    imu_cols = [c for c in ("l_imu_heel", "r_imu_heel") if c in baseline.columns]
    if imu_cols:
        imu_vals = baseline[imu_cols].mean(axis=1).dropna()
        if len(imu_vals) >= 5:
            result["imu_mean"] = float(imu_vals.mean())
            result["imu_std"]  = float(imu_vals.std(ddof=1))
        # Track how many feet contributed usable IMU data (0, 1, or 2)
        result["imu_foot_count"] = sum(
            1 for c in imu_cols if int(baseline[c].notna().sum()) > 0
        )

    return result


def compute_condition_cadence(pres_df: pd.DataFrame, stage: str) -> pd.DataFrame:
    """Rolling cadence (BPM) for a condition stage, with an is_baseline flag."""
    empty = pd.DataFrame(columns=["t_s", "cadence_bpm", "is_baseline"])
    if "stage" not in pres_df.columns:
        return empty

    cond = pres_df[pres_df["stage"] == stage].copy().sort_values("session_ms").reset_index(drop=True)
    if cond.empty:
        return empty

    stage_start_ms = float(cond["session_ms"].min())
    step_arr = _detect_steps_dynamic(cond)
    if len(step_arr) < 3:
        return empty

    intervals_ms = np.diff(step_arr)
    bpm_inst     = 60_000.0 / intervals_ms
    midpoint_ms  = (step_arr[:-1] + step_arr[1:]) / 2.0

    valid = (bpm_inst >= 30) & (bpm_inst <= 200)
    bpm_inst    = bpm_inst[valid]
    midpoint_ms = midpoint_ms[valid]
    if len(bpm_inst) == 0:
        return empty

    window     = min(10, len(bpm_inst))
    bpm_smooth = pd.Series(bpm_inst).rolling(window, center=True, min_periods=1).mean().values
    t_s        = (midpoint_ms - stage_start_ms) / 1000.0

    # is_baseline: before the tempo ramp meaningfully starts (ratio within ±0.5 %)
    is_baseline = np.zeros(len(t_s), dtype=bool)
    if "ratio" in cond.columns:
        t_arr = cond["session_ms"].values
        r_arr = cond["ratio"].values
        for idx, ms in enumerate(midpoint_ms):
            nearest = int(np.argmin(np.abs(t_arr - ms)))
            r = r_arr[nearest]
            if np.isfinite(r) and abs(float(r) - 1.0) < 0.005:
                is_baseline[idx] = True

    return pd.DataFrame({"t_s": t_s, "cadence_bpm": bpm_smooth, "is_baseline": is_baseline})


def compute_condition_stance_imu(
    pres_df: pd.DataFrame, thresholds: dict | None, stage: str
) -> pd.DataFrame:
    """Rolling heel-stance duration and binned IMU heel force for a condition stage."""
    empty = pd.DataFrame(columns=["t_s", "stance_ms", "imu_heel"])
    if "stage" not in pres_df.columns:
        return empty

    cond = pres_df[pres_df["stage"] == stage].copy().sort_values("session_ms").reset_index(drop=True)
    if cond.empty:
        return empty

    stage_start_ms = float(cond["session_ms"].min())

    # Stance + heel peak amplitude via foot-contact detection
    contacts = detect_foot_contacts(cond, thresholds or {})
    stance_out = pd.DataFrame(columns=["t_s", "stance_ms", "heel_peak"])
    if not contacts.empty and "stance_ms" in contacts.columns:
        contacts = contacts.sort_values("session_ms").reset_index(drop=True)
        contacts["t_s"]           = (contacts["session_ms"] - stage_start_ms) / 1000.0
        contacts["stance_ms_smt"] = contacts["stance_ms"].rolling(5, center=True, min_periods=1).mean()
        cols_keep = ["t_s", "stance_ms_smt"]
        if "heel_peak" in contacts.columns:
            cols_keep.append("heel_peak")
        stance_out = contacts[cols_keep].rename(columns={"stance_ms_smt": "stance_ms"})

    # IMU heel in 5-second bins
    imu_cols = [c for c in ("l_imu_heel", "r_imu_heel") if c in cond.columns]
    imu_out = pd.DataFrame(columns=["t_s", "imu_heel"])
    if imu_cols:
        cond["_t_s"]      = (cond["session_ms"] - stage_start_ms) / 1000.0
        cond["_imu_mean"] = cond[imu_cols].mean(axis=1)
        cond["_bin"]      = (cond["_t_s"] / 5.0).astype(int)
        binned = (
            cond.groupby("_bin")
            .agg(t_s=("_t_s", "mean"), imu_heel=("_imu_mean", "mean"))
            .reset_index(drop=True)
        )
        imu_out = binned.dropna(subset=["imu_heel"])

    if stance_out.empty and imu_out.empty:
        return empty
    if stance_out.empty:
        return imu_out.assign(stance_ms=np.nan)
    if imu_out.empty:
        return stance_out.assign(imu_heel=np.nan)

    return pd.merge_asof(
        stance_out.sort_values("t_s"),
        imu_out.sort_values("t_s"),
        on="t_s", direction="nearest", tolerance=10.0,
    )


def _render_condition_effects(entries: list[dict], smooth_window: int) -> None:
    """Render the Tempo and Weight condition-effects panels side-by-side."""

    # Tempo: rows = [cadence, audio BPM %change]
    tempo_fig = make_subplots(
        rows=2, cols=1, shared_xaxes=True,
        vertical_spacing=0.10, row_heights=[2.5, 1.0],
    )
    # Weight: rows = [stance, IMU heel, analytical weight value]
    weight_fig = make_subplots(
        rows=3, cols=1, shared_xaxes=True,
        vertical_spacing=0.08, row_heights=[1.5, 1.5, 0.8],
    )

    warnings_out: list[str] = []
    first_tempo_baseline_drawn  = False
    first_weight_baseline_drawn = False

    for entry in entries:
        pid       = entry["pid"]
        color     = entry["color"]
        data      = entry["data"]
        pres_df   = data["pressure_df"]
        thresholds = data.get("thresholds")
        tempo_dir  = data.get("tempo_direction")
        weight_dir = data.get("weight_direction")

        if "condition" not in pres_df.columns or "stage" not in pres_df.columns:
            continue

        # Map stage → condition type
        cmap = (
            pres_df[pres_df["stage"].isin(["condition_1", "condition_2"])][["stage", "condition"]]
            .drop_duplicates()
        )
        if cmap.empty:
            continue
        cond_to_stage = {row["condition"]: row["stage"] for _, row in cmap.iterrows()}
        tempo_stage  = cond_to_stage.get("tempo")
        weight_stage = cond_to_stage.get("weight")

        baseline = compute_baseline_metrics(pres_df, thresholds)

        # Helper: parse hex color
        h = color.lstrip("#")
        rc, gc, bc = int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)

        # ── Tempo panel ───────────────────────────────────────────────────────
        if tempo_stage is not None:
            cad_df = compute_condition_cadence(pres_df, tempo_stage)

            # Phase zone bounds (from stage events or hardcoded fallback)
            _pb       = data.get("phase_bounds", {}).get(tempo_stage, {})
            _din_end  = _pb.get("drift_in_end",    15.0)
            _dout_st  = _pb.get("drift_out_start", 75.0)
            _nom_end  = _pb.get("nominal_end",     90.0)

            # Draw baseline band + phase zones once (first participant)
            if not first_tempo_baseline_drawn:
                # Baseline band (only if we have a valid baseline mean)
                if not np.isnan(baseline["cadence_mean"]):
                    bm = baseline["cadence_mean"]
                    bs = max(baseline["cadence_std"], 0.5)
                    tempo_fig.add_hrect(
                        y0=bm - bs, y1=bm + bs,
                        fillcolor="rgba(180,180,180,0.22)", line_width=0, row=1, col=1,
                    )
                    tempo_fig.add_hline(
                        y=bm,
                        line=dict(color="rgba(100,100,100,0.55)", width=1.5, dash="dash"),
                        row=1, col=1,
                    )
                    cv = float(bs / abs(bm) * 100) if bm != 0 else 0.0
                    tempo_fig.add_annotation(
                        x=0.01, y=0.97, xref="x domain", yref="y domain",
                        text=f"Baseline CV {cv:.1f}%",
                        showarrow=False, font={"size": 9, "color": "#888"}, yanchor="top",
                    )

                # Phase zone shading (drift-in / active manipulation / drift-out)
                for row_n in (1, 2):
                    # drift-in
                    tempo_fig.add_vrect(
                        x0=0, x1=_din_end,
                        fillcolor="rgba(200,200,200,0.15)", line_width=0,
                        row=row_n, col=1,
                    )
                    # active manipulation
                    tempo_fig.add_vrect(
                        x0=_din_end, x1=_dout_st,
                        fillcolor="rgba(80,180,120,0.10)", line_width=0,
                        row=row_n, col=1,
                    )
                    # drift-out
                    tempo_fig.add_vrect(
                        x0=_dout_st, x1=_nom_end,
                        fillcolor="rgba(200,200,200,0.15)", line_width=0,
                        row=row_n, col=1,
                    )
                # Phase boundary dotted lines (spans both rows automatically)
                for _xv in (_din_end, _dout_st):
                    tempo_fig.add_vline(
                        x=_xv,
                        line=dict(color="rgba(150,150,150,0.5)", width=1, dash="dot"),
                    )
                # Phase labels (paper-space y — above the top subplot)
                tempo_fig.add_annotation(
                    x=_din_end / 2, y=1.03, xref="x", yref="paper",
                    text="drift in", showarrow=False,
                    font={"size": 8, "color": "#aaa"}, yanchor="bottom",
                )
                tempo_fig.add_annotation(
                    x=(_din_end + _dout_st) / 2, y=1.03, xref="x", yref="paper",
                    text="active manipulation", showarrow=False,
                    font={"size": 8, "color": "#5a9"}, yanchor="bottom",
                )
                tempo_fig.add_annotation(
                    x=(_dout_st + _nom_end) / 2, y=1.03, xref="x", yref="paper",
                    text="drift out", showarrow=False,
                    font={"size": 8, "color": "#aaa"}, yanchor="bottom",
                )
                first_tempo_baseline_drawn = True

            if not cad_df.empty:
                t_s  = cad_df["t_s"].values
                bpm  = cad_df["cadence_bpm"].values

                # Smoothed cadence line
                bpm_s = (
                    pd.Series(bpm)
                    .rolling(min(smooth_window, len(bpm)), center=True, min_periods=1)
                    .mean().values
                )
                tempo_fig.add_trace(
                    go.Scatter(
                        x=t_s, y=bpm_s, mode="lines",
                        name=f"{pid} cadence",
                        line={"color": color, "width": 2},
                        legendgroup=f"tempo_{pid}", showlegend=True,
                        hovertemplate=f"<b>{pid}</b><br>t=%{{x:.1f}}s  %{{y:.1f}} BPM<extra></extra>",
                    ),
                    row=1, col=1,
                )

                # Baseline-mismatch check
                pre_ramp = cad_df[cad_df["is_baseline"]]["cadence_bpm"]
                if len(pre_ramp) >= 3 and not np.isnan(baseline["cadence_mean"]):
                    bm = baseline["cadence_mean"]
                    bs = max(baseline["cadence_std"], 0.1)
                    if abs(pre_ramp.mean() - bm) > 1.5 * bs:
                        warnings_out.append(
                            f"⚠️ {pid}: baseline mismatch — condition-start cadence "
                            f"{pre_ramp.mean():.1f} BPM vs audio_only {bm:.1f}±{bs:.1f} BPM"
                        )

                # Expected direction and success badges
                expected_up = (tempo_dir == "speeding_up")
                dir_arrow   = "↑" if expected_up else "↓"
                t_max       = float(t_s[-1]) if len(t_s) > 0 else 0

                # Note when recording extends well past the nominal drift-out end
                if t_max > _nom_end + 5:
                    tempo_fig.add_annotation(
                        x=_nom_end + 1, y=0.98, xref="x", yref="paper",
                        text=f"⚠ recording continues to {t_max:.0f}s (drift-out ended ~{_nom_end:.0f}s)",
                        showarrow=False, font={"size": 8, "color": "#c77"},
                        xanchor="left", yanchor="top",
                    )

                first30 = cad_df[cad_df["t_s"] <= 30]["cadence_bpm"]
                last30  = cad_df[cad_df["t_s"] >= max(0, t_max - 30)]["cadence_bpm"]
                bm      = baseline["cadence_mean"]
                cm      = float(np.mean(bpm))

                badge1 = (
                    ("✓" if last30.mean() > first30.mean() else "✗") if expected_up
                    else ("✓" if last30.mean() < first30.mean() else "✗")
                ) if (len(first30) >= 2 and len(last30) >= 2) else "?"

                badge2 = (
                    ("✓" if cm > bm else "✗") if expected_up
                    else ("✓" if cm < bm else "✗")
                ) if not np.isnan(bm) else "?"

                annot_y = float(bpm_s[-1]) if len(bpm_s) > 0 else 0
                tempo_fig.add_annotation(
                    x=float(t_s[-1]), y=annot_y,
                    text=f"<b>{pid}</b> {dir_arrow} {badge1}{badge2}",
                    font={"size": 10, "color": color},
                    showarrow=False, xanchor="right", yanchor="bottom",
                    row=1, col=1,
                )

            # Row 2: audio BPM % change (dashed, from ratio) + cadence % change from baseline (solid)
            cond_pres = pres_df[pres_df["stage"] == tempo_stage].sort_values("session_ms")
            if not cond_pres.empty and "ratio" in cond_pres.columns:
                mask_r = cond_pres["ratio"].notna()
                if mask_r.any():
                    ar = cond_pres.loc[mask_r].copy()
                    sstart = float(cond_pres["session_ms"].min())
                    ar["t_s"]       = (ar["session_ms"] - sstart) / 1000.0
                    ar["audio_pct"] = (ar["ratio"] - 1.0) * 100.0
                    ar_ds = downsample(ar, 2000)
                    tempo_fig.add_trace(
                        go.Scatter(
                            x=ar_ds["t_s"], y=ar_ds["audio_pct"],
                            mode="lines", name=f"{pid} audio BPM %",
                            line={"color": color, "dash": "dash", "width": 1.5},
                            opacity=0.6, legendgroup=f"tempo_{pid}", showlegend=False,
                            hovertemplate=f"<b>{pid}</b> audio<br>t=%{{x:.1f}}s  %{{y:+.1f}}%<extra></extra>",
                        ),
                        row=2, col=1,
                    )

            # Cadence % change from baseline on row 2
            if not cad_df.empty and not np.isnan(baseline["cadence_mean"]):
                bm_cad = baseline["cadence_mean"]
                if bm_cad != 0:
                    cad_pct_row2 = (cad_df["cadence_bpm"].values - bm_cad) / abs(bm_cad) * 100.0
                    tempo_fig.add_trace(
                        go.Scatter(
                            x=cad_df["t_s"].values, y=cad_pct_row2,
                            mode="lines", name=f"{pid} cadence %",
                            line={"color": color, "width": 2},
                            opacity=1.0, legendgroup=f"tempo_{pid}", showlegend=False,
                            hovertemplate=f"<b>{pid}</b> cad %<br>t=%{{x:.1f}}s  %{{y:+.1f}}%<extra></extra>",
                        ),
                        row=2, col=1,
                    )

        # ── Weight panel ──────────────────────────────────────────────────────
        if weight_stage is not None:
            sw_df = compute_condition_stance_imu(pres_df, thresholds, weight_stage)
            cond_pres = pres_df[pres_df["stage"] == weight_stage].sort_values("session_ms")
            sstart_w  = float(cond_pres["session_ms"].min()) if not cond_pres.empty else 0.0
            send_w    = float(cond_pres["session_ms"].max()) if not cond_pres.empty else 0.0
            cond_dur_s = (send_w - sstart_w) / 1000.0

            # Baseline bands (first participant only)
            if not first_weight_baseline_drawn:
                if not np.isnan(baseline["stance_mean"]):
                    sm, ss = baseline["stance_mean"], max(baseline["stance_std"], 1.0)
                    weight_fig.add_hrect(
                        y0=sm - ss, y1=sm + ss,
                        fillcolor="rgba(180,180,180,0.22)", line_width=0, row=1, col=1,
                    )
                    weight_fig.add_hline(
                        y=sm,
                        line=dict(color="rgba(100,100,100,0.55)", width=1.5, dash="dash"),
                        row=1, col=1,
                    )
                    cv = float(ss / abs(sm) * 100) if sm != 0 else 0.0
                    weight_fig.add_annotation(
                        x=0.01, y=0.97, xref="x domain", yref="y domain",
                        text=f"Baseline CV {cv:.1f}%",
                        showarrow=False, font={"size": 9, "color": "#888"}, yanchor="top",
                    )
                if not np.isnan(baseline["imu_mean"]):
                    im, ist = baseline["imu_mean"], max(baseline["imu_std"], 0.1)
                    weight_fig.add_hrect(
                        y0=im - ist, y1=im + ist,
                        fillcolor="rgba(180,180,180,0.22)", line_width=0, row=2, col=1,
                    )
                    weight_fig.add_hline(
                        y=im,
                        line=dict(color="rgba(100,100,100,0.55)", width=1.5, dash="dash"),
                        row=2, col=1,
                    )
                first_weight_baseline_drawn = True

            if not sw_df.empty:
                t_s = sw_df["t_s"].values
                expected_up_w = (weight_dir == "increasing")
                dir_arrow_w   = "↑" if expected_up_w else "↓"
                t_max_w       = float(t_s[-1]) if len(t_s) > 0 else 0.0
                t_third       = t_max_w / 3.0

                # Stance row
                sw_stance = sw_df.dropna(subset=["stance_ms"]) if "stance_ms" in sw_df.columns else pd.DataFrame()
                if not sw_stance.empty:
                    weight_fig.add_trace(
                        go.Scatter(
                            x=sw_stance["t_s"], y=sw_stance["stance_ms"],
                            mode="lines", name=f"{pid} stance",
                            line={"color": color, "width": 2},
                            legendgroup=f"weight_{pid}", showlegend=True,
                            hovertemplate=f"<b>{pid}</b> stance<br>t=%{{x:.1f}}s  %{{y:.0f}}ms<extra></extra>",
                        ),
                        row=1, col=1,
                    )
                    sm = baseline["stance_mean"]
                    first3 = sw_stance[sw_stance["t_s"] <= t_third]["stance_ms"]
                    last3  = sw_stance[sw_stance["t_s"] >= 2 * t_third]["stance_ms"]
                    cm_s   = float(sw_stance["stance_ms"].mean())

                    badge1_w = (
                        ("✓" if last3.mean() > first3.mean() else "✗") if expected_up_w
                        else ("✓" if last3.mean() < first3.mean() else "✗")
                    ) if (len(first3) >= 2 and len(last3) >= 2) else "?"

                    badge2_w = (
                        ("✓" if cm_s > sm else "✗") if expected_up_w
                        else ("✓" if cm_s < sm else "✗")
                    ) if not np.isnan(sm) else "?"

                    annot_y_w = float(sw_stance["stance_ms"].iloc[-1])
                    weight_fig.add_annotation(
                        x=float(sw_stance["t_s"].iloc[-1]), y=annot_y_w,
                        text=f"<b>{pid}</b> {dir_arrow_w} {badge1_w}{badge2_w}",
                        font={"size": 10, "color": color},
                        showarrow=False, xanchor="right", yanchor="bottom",
                        row=1, col=1,
                    )

                # IMU heel row
                sw_imu = sw_df.dropna(subset=["imu_heel"]) if "imu_heel" in sw_df.columns else pd.DataFrame()
                if not sw_imu.empty:
                    weight_fig.add_trace(
                        go.Scatter(
                            x=sw_imu["t_s"], y=sw_imu["imu_heel"],
                            mode="lines", name=f"{pid} IMU heel",
                            line={"color": color, "width": 2, "dash": "dash"},
                            legendgroup=f"weight_{pid}", showlegend=True,
                            hovertemplate=f"<b>{pid}</b> IMU heel<br>t=%{{x:.1f}}s  %{{y:.1f}}<extra></extra>",
                        ),
                        row=2, col=1,
                    )

                # Row 3: normalised overlay — weight ramp %, stance %, IMU %
                bm_st = baseline["stance_mean"]
                bm_im = baseline["imu_mean"]

                if not sw_stance.empty and not np.isnan(bm_st) and bm_st != 0:
                    st_pct = (sw_stance["stance_ms"].values - bm_st) / abs(bm_st) * 100.0
                    weight_fig.add_trace(
                        go.Scatter(
                            x=sw_stance["t_s"].values, y=st_pct,
                            mode="lines", name=f"{pid} stance %",
                            line={"color": color, "width": 2},
                            opacity=1.0, legendgroup=f"weight_{pid}", showlegend=False,
                            hovertemplate=f"<b>{pid}</b> stance %<br>t=%{{x:.1f}}s  %{{y:+.1f}}%<extra></extra>",
                        ),
                        row=3, col=1,
                    )

                if not sw_imu.empty and not np.isnan(bm_im) and bm_im != 0:
                    imu_pct_row3 = (sw_imu["imu_heel"].values - bm_im) / abs(bm_im) * 100.0
                    weight_fig.add_trace(
                        go.Scatter(
                            x=sw_imu["t_s"].values, y=imu_pct_row3,
                            mode="lines", name=f"{pid} IMU %",
                            line={"color": color, "width": 2, "dash": "dash"},
                            opacity=0.8, legendgroup=f"weight_{pid}", showlegend=False,
                            hovertemplate=f"<b>{pid}</b> IMU %<br>t=%{{x:.1f}}s  %{{y:+.1f}}%<extra></extra>",
                        ),
                        row=3, col=1,
                    )

            # Normalised weight ramp (0 → ±100 %) on row 3
            if cond_dur_s > 0:
                direction_sign = 1.0 if weight_dir == "increasing" else -1.0
                t_pts = np.linspace(0, cond_dur_s, 300)
                w_pct = direction_sign * (t_pts / cond_dur_s) * 100.0
                weight_fig.add_trace(
                    go.Scatter(
                        x=t_pts, y=w_pct, mode="lines",
                        name=f"{pid} weight ramp",
                        line={"color": "rgba(120,120,120,0.5)", "dash": "dot", "width": 1.5},
                        opacity=0.75, legendgroup=f"weight_{pid}", showlegend=False,
                        hovertemplate=f"<b>{pid}</b> weight ramp<br>t=%{{x:.1f}}s  %{{y:+.0f}}%<extra></extra>",
                    ),
                    row=3, col=1,
                )

    # ── Layout ────────────────────────────────────────────────────────────────
    _fig_layout = dict(
        margin={"t": 40, "b": 30, "l": 65, "r": 20},
        legend={"x": 1.01, "y": 1.0},
        hovermode="x unified",
        plot_bgcolor="white",
        paper_bgcolor="white",
    )

    tempo_fig.update_layout(height=420, title_text="Tempo condition", **_fig_layout)
    tempo_fig.update_yaxes(title_text="Cadence (BPM)",           row=1, col=1, fixedrange=True)
    tempo_fig.update_yaxes(title_text="% change from neutral",   row=2, col=1, fixedrange=True)
    tempo_fig.update_xaxes(title_text="Time from condition start (s)", row=2, col=1)
    tempo_fig.update_xaxes(showgrid=True, gridcolor="#eee")
    tempo_fig.update_yaxes(showgrid=True, gridcolor="#eee")
    tempo_fig.add_hline(
        y=0, line=dict(color="rgba(100,100,100,0.35)", width=1, dash="dot"), row=2, col=1,
    )

    weight_fig.update_layout(height=500, title_text="Weight condition", **_fig_layout)
    weight_fig.update_yaxes(title_text="Stance (ms)",            row=1, col=1, fixedrange=True)
    weight_fig.update_yaxes(title_text="IMU heel (counts)",      row=2, col=1, fixedrange=True)
    weight_fig.update_yaxes(title_text="% of manipulation",      row=3, col=1, fixedrange=True)
    weight_fig.update_xaxes(title_text="Time from condition start (s)", row=3, col=1)
    weight_fig.update_xaxes(showgrid=True, gridcolor="#eee")
    weight_fig.update_yaxes(showgrid=True, gridcolor="#eee")
    weight_fig.add_hline(
        y=0, line=dict(color="rgba(100,100,100,0.35)", width=1, dash="dot"), row=3, col=1,
    )

    col_left, col_right = st.columns(2)
    with col_left:
        st.plotly_chart(tempo_fig, use_container_width=True, config={"scrollZoom": True})
    with col_right:
        st.plotly_chart(weight_fig, use_container_width=True, config={"scrollZoom": True})

    st.caption(
        "Tempo and weight conditions are analysed independently. "
        "Both use the same cadence/stance/IMU baseline: last 30 s of the audio-only stage."
    )

    for w in warnings_out:
        st.warning(w)


# ── Review system ─────────────────────────────────────────────────────────────

_REVIEW_OUTCOMES = ["unreviewed", "influenced_intended", "influenced_transient",
                    "influenced_opposite", "no_effect", "unclear"]
_OUTCOME_LABELS  = {
    "unreviewed":            "Unreviewed",
    "influenced_intended":   "Influenced (intended)",
    "influenced_transient":  "Influenced (transient)",
    "influenced_opposite":   "Influenced (opposite)",
    "no_effect":             "No effect",
    "unclear":               "Unclear",
}
_SIG_THRESHOLD = 1.0   # std units for "significant" change


def _ensure_review_table() -> None:
    """Create session_reviews table and run any pending column migrations (idempotent)."""
    con = sqlite3.connect(DB_PATH)
    con.executescript("""
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
    tempo_audio_change_pct  REAL,
    tempo_coupling_ratio    REAL,
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
    con.commit()
    # Migrations for existing databases — safe to re-run; exceptions mean column already exists
    for migration in [
        "ALTER TABLE session_reviews ADD COLUMN tempo_audio_change_pct REAL",
        "ALTER TABLE session_reviews ADD COLUMN tempo_coupling_ratio REAL",
        "ALTER TABLE session_reviews ADD COLUMN tempo_entrainment_r REAL",
        "ALTER TABLE session_reviews ADD COLUMN weight_effect_pct_peak REAL",
    ]:
        try:
            con.execute(migration)
            con.commit()
        except Exception:
            pass
    con.close()


def load_session_review(session_id: int) -> dict:
    """Return the review row for a session, or defaults if none saved yet."""
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    row = con.execute(
        "SELECT * FROM session_reviews WHERE session_id=?", (session_id,)
    ).fetchone()
    con.close()
    if row:
        return dict(row)
    return {
        "session_id": session_id,
        "is_excluded": 0, "excl_equipment": 0, "excl_other": "",
        "auto_low_steps": 0, "auto_noticed": 0,
        "tempo_outcome": "unreviewed", "tempo_effect_pct": None, "tempo_onset": None,
        "tempo_audio_change_pct": None, "tempo_coupling_ratio": None, "tempo_entrainment_r": None,
        "weight_outcome": "unreviewed", "weight_effect_pct_stance": None,
        "weight_effect_pct_imu": None, "weight_effect_pct_peak": None, "weight_onset": None,
        "tempo_overridden": 0, "weight_overridden": 0,
        "review_notes": "", "reviewed_at": None,
    }


def save_session_review(session_id: int, review: dict) -> None:
    """UPSERT a review row into session_reviews."""
    import datetime
    review["reviewed_at"] = datetime.datetime.utcnow().isoformat(timespec="seconds")
    con = sqlite3.connect(DB_PATH)
    con.execute("""
INSERT INTO session_reviews
    (session_id, is_excluded, excl_equipment, excl_other,
     auto_low_steps, auto_noticed,
     tempo_outcome, tempo_effect_pct, tempo_onset,
     tempo_audio_change_pct, tempo_coupling_ratio, tempo_entrainment_r,
     weight_outcome, weight_effect_pct_stance, weight_effect_pct_imu, weight_effect_pct_peak,
     weight_onset, tempo_overridden, weight_overridden, review_notes, reviewed_at)
VALUES
    (:session_id, :is_excluded, :excl_equipment, :excl_other,
     :auto_low_steps, :auto_noticed,
     :tempo_outcome, :tempo_effect_pct, :tempo_onset,
     :tempo_audio_change_pct, :tempo_coupling_ratio, :tempo_entrainment_r,
     :weight_outcome, :weight_effect_pct_stance, :weight_effect_pct_imu, :weight_effect_pct_peak,
     :weight_onset, :tempo_overridden, :weight_overridden, :review_notes, :reviewed_at)
ON CONFLICT(session_id) DO UPDATE SET
    is_excluded=excluded.is_excluded, excl_equipment=excluded.excl_equipment,
    excl_other=excluded.excl_other, auto_low_steps=excluded.auto_low_steps,
    auto_noticed=excluded.auto_noticed,
    tempo_outcome=excluded.tempo_outcome, tempo_effect_pct=excluded.tempo_effect_pct,
    tempo_onset=excluded.tempo_onset,
    tempo_audio_change_pct=excluded.tempo_audio_change_pct,
    tempo_coupling_ratio=excluded.tempo_coupling_ratio,
    tempo_entrainment_r=excluded.tempo_entrainment_r,
    weight_outcome=excluded.weight_outcome,
    weight_effect_pct_stance=excluded.weight_effect_pct_stance,
    weight_effect_pct_imu=excluded.weight_effect_pct_imu,
    weight_effect_pct_peak=excluded.weight_effect_pct_peak,
    weight_onset=excluded.weight_onset,
    tempo_overridden=excluded.tempo_overridden, weight_overridden=excluded.weight_overridden,
    review_notes=excluded.review_notes, reviewed_at=excluded.reviewed_at
""", review)
    con.commit()
    con.close()


def _compute_thirds_outcome(
    values: np.ndarray, t_s: np.ndarray, baseline_mean: float, baseline_std: float,
    expected_direction: str,  # "up" or "down"
    drift_out_start_s: float | None = None,  # Trim thirds to active phase only (excludes drift-out)
) -> tuple[str, float, str]:
    """Compute outcome, effect_pct, and onset from thirds + rolling-window peak analysis.

    # SYNC: This function is duplicated in analysis/batch_auto_review.py (_compute_thirds_outcome).
    # Keep in sync manually. Planned: extract to analysis/gait_metrics.py

    Returns (outcome, effect_pct, onset) where:
    - outcome ∈ {"influenced_intended", "influenced_transient", "influenced_opposite",
                  "no_effect", "unclear"}
    - effect_pct = (last_third_mean - baseline_mean) / baseline_mean * 100
    - onset ∈ {"early", "gradual", "late", "none"}

    "influenced_transient" is used when the rolling-window peak exceeds the threshold
    in the intended direction but the final third has decayed back below it.

    drift_out_start_s: if provided, the thirds classification uses only data up to this
    point (the start of drift-out), preventing the return-to-neutral phase from causing
    false "influenced_opposite" outcomes. The rolling-window peak detection still uses
    the full recording.
    """
    if len(values) < 6 or baseline_std <= 0 or abs(baseline_mean) < 1e-6:
        return "unclear", 0.0, "none"

    # Trim to active phase only for thirds classification (exclude drift-out).
    # Rolling-window peak detection below still uses the full values/t_s arrays.
    if drift_out_start_s is not None and float(t_s[-1]) > drift_out_start_s:
        active_mask = t_s < drift_out_start_s
        values_a = values[active_mask]
        t_s_a    = t_s[active_mask]
    else:
        values_a = values
        t_s_a    = t_s

    if len(values_a) < 6:
        return "unclear", 0.0, "none"

    t_max = float(t_s_a[-1])
    th1, th2 = t_max / 3.0, 2.0 * t_max / 3.0
    m1 = float(np.nanmean(values_a[t_s_a <= th1]))                      if np.any(t_s_a <= th1)              else np.nan
    m2 = float(np.nanmean(values_a[(t_s_a > th1) & (t_s_a <= th2)]))   if np.any((t_s_a > th1) & (t_s_a <= th2)) else np.nan
    m3 = float(np.nanmean(values_a[t_s_a > th2]))                       if np.any(t_s_a > th2)               else np.nan

    if np.isnan(m3):
        return "unclear", 0.0, "none"

    e1 = abs(m1 - baseline_mean) / baseline_std if not np.isnan(m1) else 0.0
    e2 = abs(m2 - baseline_mean) / baseline_std if not np.isnan(m2) else 0.0
    e3 = abs(m3 - baseline_mean) / baseline_std

    # Onset classification (thirds-based, unchanged)
    if e3 < _SIG_THRESHOLD:
        onset = "none"
    elif e1 >= _SIG_THRESHOLD:
        onset = "early"
    elif e2 >= _SIG_THRESHOLD:
        onset = "gradual"
    else:
        onset = "late"

    effect_pct = (m3 - baseline_mean) / abs(baseline_mean) * 100.0

    # Transient peak: 8 s rolling window on the direction-signed deviation.
    # Uses a lower threshold (_TRANSIENT_THRESHOLD) than sustained effects because
    # transient responses decay before the final third and are expected to be weaker.
    _TRANSIENT_THRESHOLD = 0.7  # SD units (vs _SIG_THRESHOLD = 1.0 for sustained)
    signed_dev = (values - baseline_mean) / baseline_std
    dt_mean = float(np.median(np.diff(t_s))) if len(t_s) > 1 else 1.0
    win = max(3, int(8.0 / max(dt_mean, 0.1)))
    rolling_sd = pd.Series(signed_dev).rolling(win, center=True, min_periods=3).mean().values
    if expected_direction == "up":
        peak_signed = float(np.nanmax(rolling_sd))
    else:
        peak_signed = float(np.nanmin(rolling_sd))
    # Guard: nanmax/nanmin returns -inf/+inf when all values are NaN
    if not np.isfinite(peak_signed):
        peak_signed = 0.0
    peak_e = abs(peak_signed)

    # Outcome classification
    if e3 >= _SIG_THRESHOLD:
        # Sustained through to the final third
        if (expected_direction == "up" and m3 > baseline_mean) or \
           (expected_direction == "down" and m3 < baseline_mean):
            outcome = "influenced_intended"
        else:
            outcome = "influenced_opposite"
    elif peak_e >= _TRANSIENT_THRESHOLD:
        # Rolling-window peak crossed the (lower) transient threshold but decayed by final third
        if (expected_direction == "up" and peak_signed > 0) or \
           (expected_direction == "down" and peak_signed < 0):
            outcome = "influenced_transient"
            # For transient, effect_pct reflects the peak direction/magnitude,
            # not the decayed final third (which would show near-zero and wrong direction)
            effect_pct = (peak_signed * baseline_std / abs(baseline_mean)) * 100.0
        else:
            outcome = "no_effect"   # transient but wrong direction — not entrainment
    else:
        outcome = "no_effect"

    return outcome, round(effect_pct, 2), onset


def auto_compute_influence(entry: dict) -> dict:
    """Compute auto influence verdict for one participant entry.

    Returns a partial review dict (does not include exclusion fields or notes).
    """
    data      = entry["data"]
    pres_df   = data["pressure_df"]
    thresholds = data.get("thresholds")
    tempo_dir  = data.get("tempo_direction")
    weight_dir = data.get("weight_direction")
    sid        = entry["session_id"]

    result: dict = {
        "tempo_outcome": "unreviewed", "tempo_effect_pct": None, "tempo_onset": None,
        "tempo_audio_change_pct": None, "tempo_coupling_ratio": None, "tempo_entrainment_r": None,
        "weight_outcome": "unreviewed", "weight_effect_pct_stance": None,
        "weight_effect_pct_imu": None, "weight_effect_pct_peak": None, "weight_onset": None,
        "auto_low_steps": 0, "auto_noticed": 0,
    }

    if "condition" not in pres_df.columns or "stage" not in pres_df.columns:
        return result

    # Map condition type → stage
    cmap = (
        pres_df[pres_df["stage"].isin(["condition_1", "condition_2"])][["stage", "condition"]]
        .drop_duplicates()
    )
    cond_to_stage = {row["condition"]: row["stage"] for _, row in cmap.iterrows()}
    tempo_stage  = cond_to_stage.get("tempo")
    weight_stage = cond_to_stage.get("weight")

    # Phase bounds for drift-out exclusion (loaded from session_stage_events in load_session_data)
    pb = data.get("phase_bounds", {})
    tempo_drift_out_s  = pb.get(tempo_stage,  {}).get("drift_out_start", None)
    weight_drift_out_s = pb.get(weight_stage, {}).get("drift_out_start", None)

    baseline = compute_baseline_metrics(pres_df, thresholds)

    # ── Step count flag ───────────────────────────────────────────────────────
    min_steps = 9999
    for stage in [s for s in [tempo_stage, weight_stage] if s]:
        sub = pres_df[pres_df["stage"] == stage]
        if not sub.empty:
            steps = _detect_steps_dynamic(sub)
            min_steps = min(min_steps, len(steps))
    result["auto_low_steps"] = int(min_steps < 30)

    # ── Noticed flag (from consciousness_responses) ───────────────────────────
    try:
        con = sqlite3.connect(DB_PATH)
        row = con.execute(
            "SELECT cond1_noticed, cond2_noticed FROM consciousness_responses WHERE session_id=?",
            (sid,),
        ).fetchone()
        con.close()
        if row:
            result["auto_noticed"] = int(bool(row[0]) or bool(row[1]))
    except Exception:
        pass

    # ── Tempo ─────────────────────────────────────────────────────────────────
    if tempo_stage and tempo_dir and not np.isnan(baseline["cadence_mean"]):
        cad_df = compute_condition_cadence(pres_df, tempo_stage)
        if not cad_df.empty and len(cad_df) >= 6:
            exp = "up" if tempo_dir == "speeding_up" else "down"
            out, eff, onset = _compute_thirds_outcome(
                cad_df["cadence_bpm"].values, cad_df["t_s"].values,
                baseline["cadence_mean"], max(baseline["cadence_std"], 0.1), exp,
                drift_out_start_s=tempo_drift_out_s,
            )
            result.update(tempo_outcome=out, tempo_effect_pct=eff, tempo_onset=onset)

            # Compute audio BPM % change from last-third ratio mean (active phase only)
            tempo_cond = pres_df[pres_df["stage"] == tempo_stage]
            if "ratio" in tempo_cond.columns and "bpm" in tempo_cond.columns:
                t_min_ms = float(tempo_cond["session_ms"].min())
                t_max_ms = float(tempo_cond["session_ms"].max())
                dur_ms = t_max_ms - t_min_ms
                # Use active phase duration (exclude drift-out) for last-third slice
                active_dur_ms = (
                    min(dur_ms, tempo_drift_out_s * 1000.0)
                    if tempo_drift_out_s is not None and dur_ms > tempo_drift_out_s * 1000.0
                    else dur_ms
                )
                if dur_ms > 0:
                    last_third_ratio = tempo_cond[
                        (tempo_cond["session_ms"] >= t_min_ms + 2 * active_dur_ms / 3) &
                        (tempo_cond["session_ms"] <= t_min_ms + active_dur_ms)
                    ]["ratio"].dropna()
                    if len(last_third_ratio) >= 3:
                        # ratio is always ≥ 1; sign depends on direction:
                        # speeding_up → BPM × ratio (+Δ); slowing_down → BPM ÷ ratio (−Δ)
                        raw_pct = (float(last_third_ratio.mean()) - 1.0) * 100.0
                        direction_sign = 1.0 if tempo_dir == "speeding_up" else -1.0
                        audio_change_pct = direction_sign * raw_pct
                        result["tempo_audio_change_pct"] = round(audio_change_pct, 2)
                        if abs(audio_change_pct) > 0.5 and eff is not None:
                            result["tempo_coupling_ratio"] = round(eff / audio_change_pct, 3)

                    # Pearson r: smoothed cadence vs reconstructed audio BPM on shared 1 s grid
                    try:
                        from scipy.stats import pearsonr as _pearsonr
                        # Build 1 Hz time grid over the condition
                        t_grid = np.arange(0.0, dur_ms / 1000.0, 1.0)
                        # Audio BPM on grid: base_bpm × ratio (speeding_up) or ÷ ratio (slowing_down)
                        tc_ms = tempo_cond["session_ms"].values.astype(float)
                        tc_t  = (tc_ms - t_min_ms) / 1000.0
                        base_bpm_col = tempo_cond["bpm"].dropna()
                        if len(base_bpm_col) > 0:
                            base_bpm = float(base_bpm_col.iloc[0])
                            ratio_col = tempo_cond["ratio"].values.astype(float)
                            if tempo_dir == "speeding_up":
                                audio_bpm_col = base_bpm * ratio_col
                            else:
                                audio_bpm_col = base_bpm / ratio_col
                            audio_bpm_interp = np.interp(t_grid, tc_t, audio_bpm_col)
                            # Cadence on grid: interpolate from cad_df
                            if not cad_df.empty and len(cad_df) >= 4:
                                cad_interp = np.interp(t_grid, cad_df["t_s"].values,
                                                       cad_df["cadence_bpm"].values)
                                # Only use rows where both signals are finite
                                mask = np.isfinite(audio_bpm_interp) & np.isfinite(cad_interp)
                                if mask.sum() >= 6:
                                    r_val, _ = _pearsonr(cad_interp[mask], audio_bpm_interp[mask])
                                    result["tempo_entrainment_r"] = round(float(r_val), 3)
                    except Exception:
                        pass
        else:
            result["tempo_outcome"] = "unclear"

    # ── Weight ────────────────────────────────────────────────────────────────
    if weight_stage and weight_dir and not np.isnan(baseline["stance_mean"]):
        sw_df = compute_condition_stance_imu(pres_df, thresholds, weight_stage)
        if not sw_df.empty and "stance_ms" in sw_df.columns:
            sw_stance = sw_df.dropna(subset=["stance_ms"])
            if len(sw_stance) >= 6:
                exp = "up" if weight_dir == "increasing" else "down"
                out, eff_s, onset = _compute_thirds_outcome(
                    sw_stance["stance_ms"].values, sw_stance["t_s"].values,
                    baseline["stance_mean"], max(baseline["stance_std"], 1.0), exp,
                    drift_out_start_s=weight_drift_out_s,
                )
                result.update(weight_outcome=out, weight_effect_pct_stance=eff_s, weight_onset=onset)
                # IMU effect pct (informational only)
                if not np.isnan(baseline["imu_mean"]) and "imu_heel" in sw_df.columns:
                    sw_imu = sw_df.dropna(subset=["imu_heel"])
                    if len(sw_imu) >= 4:
                        t_max = float(sw_imu["t_s"].max())
                        last_third_imu = float(sw_imu[sw_imu["t_s"] > 2 * t_max / 3]["imu_heel"].mean())
                        result["weight_effect_pct_imu"] = round(
                            (last_third_imu - baseline["imu_mean"]) / abs(baseline["imu_mean"]) * 100, 2
                        ) if not np.isnan(last_third_imu) and baseline["imu_mean"] != 0 else None
                # Heel peak amplitude effect (harder/lighter heel strikes)
                if not np.isnan(baseline.get("heel_peak_mean", np.nan)) and "heel_peak" in sw_df.columns:
                    sw_peak = sw_df.dropna(subset=["heel_peak"])
                    if len(sw_peak) >= 4:
                        t_max_p = float(sw_peak["t_s"].max())
                        last_third_peak = float(sw_peak[sw_peak["t_s"] > 2 * t_max_p / 3]["heel_peak"].mean())
                        bm_pk = baseline["heel_peak_mean"]
                        if not np.isnan(last_third_peak) and bm_pk != 0:
                            result["weight_effect_pct_peak"] = round(
                                (last_third_peak - bm_pk) / abs(bm_pk) * 100, 2
                            )
            else:
                result["weight_outcome"] = "unclear"

    return result


def _render_review_panel(entries: list[dict]) -> None:
    """Render per-session review panels (one column per loaded participant)."""
    _ensure_review_table()

    cols = st.columns(len(entries))
    for col, entry in zip(cols, entries):
        pid  = entry["pid"]
        sid  = entry["session_id"]
        data = entry["data"]
        color = entry["color"]

        with col:
            st.markdown(
                f"<div style='border-left:4px solid {color};padding-left:8px'>"
                f"<b>Review — {pid}</b></div>",
                unsafe_allow_html=True,
            )

            # Auto-compute influence (run fresh each render)
            auto = auto_compute_influence(entry)

            # Load saved review (to pre-fill fields)
            saved = load_session_review(sid)

            # ── Auto-flags ────────────────────────────────────────────────────
            flag_bits = []
            if auto["auto_low_steps"]:
                flag_bits.append("⚠️ Low step count")
            if auto["auto_noticed"]:
                flag_bits.append("👂 Noticed manipulation")
            if data.get("flags"):
                frozen = any("FROZEN" in f for f in data["flags"])
                if frozen:
                    flag_bits.append("🔧 Frozen clock repaired")
            if flag_bits:
                st.caption("  ·  ".join(flag_bits))

            # ── Exclusion ─────────────────────────────────────────────────────
            st.markdown("**Exclusion**")
            excl_equip = st.checkbox(
                "Equipment issue / session interrupted",
                value=bool(saved["excl_equipment"]),
                key=f"excl_eq_{pid}_{sid}",
            )
            excl_other_text = st.text_input(
                "Other exclusion reason",
                value=saved.get("excl_other") or "",
                key=f"excl_oth_{pid}_{sid}",
                placeholder="Describe…",
                label_visibility="collapsed",
            )
            is_excluded = excl_equip or bool(excl_other_text.strip())

            if is_excluded or saved["is_excluded"]:
                excl_label = "Excluded" if is_excluded else "Currently excluded"
                st.error(f"🚫 {excl_label}", icon=None)

            st.divider()

            # ── Tempo verdict ─────────────────────────────────────────────────
            tempo_dir  = data.get("tempo_direction", "")
            cmap_df = data["pressure_df"] if "condition" in data["pressure_df"].columns else pd.DataFrame()
            if not cmap_df.empty:
                cmap = cmap_df[cmap_df["stage"].isin(["condition_1","condition_2"])][["stage","condition"]].drop_duplicates()
                cond_to_stage = {r["condition"]: r["stage"] for _, r in cmap.iterrows()}
                tempo_stage  = cond_to_stage.get("tempo", "—")
                weight_stage = cond_to_stage.get("weight", "—")
            else:
                tempo_stage = weight_stage = "—"

            st.markdown(f"**Tempo** ({tempo_dir}, {tempo_stage})")
            eff_t      = auto["tempo_effect_pct"]
            ons_t      = auto.get("tempo_onset") or "—"
            audio_pct  = auto.get("tempo_audio_change_pct")
            coupling   = auto.get("tempo_coupling_ratio")
            entr_r     = auto.get("tempo_entrainment_r")
            st.caption(
                f"Auto: **{_OUTCOME_LABELS.get(auto['tempo_outcome'], auto['tempo_outcome'])}**"
                f"  ·  onset: {ons_t}"
                + (f"  ·  r={entr_r:+.2f}" if entr_r is not None else "")
            )
            _mc = st.columns(4)
            _mc[0].metric("Audio BPM Δ", f"{audio_pct:+.1f}%" if audio_pct is not None else "—")
            _mc[1].metric("Cadence Δ",   f"{eff_t:+.1f}%"    if eff_t    is not None else "—")
            _mc[2].metric(
                "Coupling",
                f"{coupling:.2f}×" if coupling is not None else "—",
                delta=f"{coupling * 100:.0f}% of audio" if coupling is not None else None,
            )
            _mc[3].metric(
                "Entrainment r",
                f"{entr_r:+.2f}" if entr_r is not None else "—",
                delta="✓ tracked" if (entr_r is not None and entr_r > 0.60) else None,
            )

            # Use saved verdict if available (and not overridden to something else), else use auto
            default_t = saved.get("tempo_outcome") or auto["tempo_outcome"]
            if default_t not in _REVIEW_OUTCOMES:
                default_t = auto["tempo_outcome"]
            tempo_verdict = st.selectbox(
                "Tempo verdict",
                options=_REVIEW_OUTCOMES,
                index=_REVIEW_OUTCOMES.index(default_t),
                format_func=lambda v: _OUTCOME_LABELS[v],
                key=f"t_verdict_{pid}_{sid}",
                label_visibility="collapsed",
            )

            st.divider()

            # ── Weight verdict ────────────────────────────────────────────────
            weight_dir = data.get("weight_direction", "")
            st.markdown(f"**Weight** ({weight_dir}, {weight_stage})")
            eff_ws    = auto["weight_effect_pct_stance"]
            eff_wi    = auto["weight_effect_pct_imu"]
            ons_w     = auto.get("weight_onset") or "—"
            stance_pu = (eff_ws / 12.0) if eff_ws is not None else None
            imu_pu    = (eff_wi / 12.0) if eff_wi is not None else None
            st.caption(
                f"Auto: **{_OUTCOME_LABELS.get(auto['weight_outcome'], auto['weight_outcome'])}**"
                f"  ·  onset: {ons_w}"
            )
            eff_wp = auto.get("weight_effect_pct_peak")
            _wc = st.columns(3)
            _wc[0].metric(
                "Stance Δ",
                f"{eff_ws:+.1f}%" if eff_ws is not None else "—",
                delta=f"{stance_pu:+.2f}% / unit" if stance_pu is not None else None,
            )
            _wc[1].metric(
                "Heel Peak Δ",
                f"{eff_wp:+.1f}%" if eff_wp is not None else "—",
                delta="harder strike" if (eff_wp is not None and eff_wp > 0) else (
                    "lighter strike" if (eff_wp is not None and eff_wp < 0) else None),
            )
            _wc[2].metric(
                "IMU Δ",
                f"{eff_wi:+.1f}%" if eff_wi is not None else "—",
                delta=f"{imu_pu:+.2f}% / unit" if imu_pu is not None else None,
            )
            if auto.get("imu_foot_count") == 1:
                st.caption("⚠ IMU: one foot only")

            default_w = saved.get("weight_outcome") or auto["weight_outcome"]
            if default_w not in _REVIEW_OUTCOMES:
                default_w = auto["weight_outcome"]
            weight_verdict = st.selectbox(
                "Weight verdict",
                options=_REVIEW_OUTCOMES,
                index=_REVIEW_OUTCOMES.index(default_w),
                format_func=lambda v: _OUTCOME_LABELS[v],
                key=f"w_verdict_{pid}_{sid}",
                label_visibility="collapsed",
            )

            st.divider()

            # ── Review notes ──────────────────────────────────────────────────
            review_notes = st.text_area(
                "Review notes",
                value=saved.get("review_notes") or "",
                height=70,
                key=f"rev_notes_{pid}_{sid}",
                placeholder="Any additional observations…",
            )

            if st.button("Save review", key=f"save_rev_{pid}_{sid}", type="primary"):
                save_session_review(sid, {
                    "session_id":    sid,
                    "is_excluded":   int(is_excluded),
                    "excl_equipment": int(excl_equip),
                    "excl_other":    excl_other_text.strip(),
                    "auto_low_steps": int(auto["auto_low_steps"]),
                    "auto_noticed":   int(auto["auto_noticed"]),
                    "tempo_outcome":  tempo_verdict,
                    "tempo_effect_pct": auto["tempo_effect_pct"],
                    "tempo_onset":    auto["tempo_onset"],
                    "tempo_audio_change_pct": auto.get("tempo_audio_change_pct"),
                    "tempo_coupling_ratio":   auto.get("tempo_coupling_ratio"),
                    "tempo_entrainment_r":    auto.get("tempo_entrainment_r"),
                    "weight_outcome":  weight_verdict,
                    "weight_effect_pct_stance": auto["weight_effect_pct_stance"],
                    "weight_effect_pct_imu":    auto["weight_effect_pct_imu"],
                    "weight_effect_pct_peak":   auto.get("weight_effect_pct_peak"),
                    "weight_onset":   auto["weight_onset"],
                    "tempo_overridden":  int(tempo_verdict != auto["tempo_outcome"]),
                    "weight_overridden": int(weight_verdict != auto["weight_outcome"]),
                    "review_notes":  review_notes,
                })
                st.success("Review saved")
                st.rerun()


def _render_questionnaire_overview(test_type_id: int) -> None:
    """Cross-participant questionnaire scores + influence outcomes + correlation."""
    from scipy import stats as scipy_stats

    con = sqlite3.connect(DB_PATH)
    df = pd.read_sql("""
        SELECT
            s.participant_id       AS pid,
            s.session_id,
            s.tempo_direction,
            s.weight_direction,
            COALESCE(sr.is_excluded, 0)              AS excluded,
            sr.tempo_outcome,
            ROUND(sr.tempo_effect_pct, 1)            AS cadence_pct,
            ROUND(sr.tempo_audio_change_pct, 1)      AS audio_pct,
            ROUND(sr.tempo_coupling_ratio, 2)         AS coupling,
            ROUND(sr.tempo_entrainment_r, 2)          AS entr_r,
            sr.tempo_onset,
            sr.weight_outcome,
            ROUND(sr.weight_effect_pct_stance, 1) AS stance_pct,
            ROUND(sr.weight_effect_pct_peak, 1)   AS peak_pct,
            ROUND(sr.weight_effect_pct_imu, 1)    AS imu_pct,
            sr.weight_onset,
            sr.auto_noticed                  AS noticed,
            r.agency_q1, r.agency_q2, r.agency_q3,
            ROUND(r.agency_aggregate, 2)     AS agency,
            ROUND(r.ueqs_pragmatic, 2)       AS ueqs,
            ROUND(r.ari_immersion, 2)        AS ari,
            c.cond1_noticed, c.cond2_noticed,
            c.post_session_tempo_guess, c.post_session_weight_guess
        FROM sessions s
        LEFT JOIN session_reviews     sr ON sr.session_id = s.session_id
        LEFT JOIN session_ratings     r  ON r.session_id  = s.session_id
        LEFT JOIN consciousness_responses c ON c.session_id = s.session_id
        WHERE s.test_type_id = ? AND s.deleted_at IS NULL
        ORDER BY r.agency_aggregate DESC NULLS LAST, s.participant_id
    """, con, params=(test_type_id,))
    con.close()

    if df.empty:
        st.info("No participant data for this test type yet.")
        return

    # ── Summary badges ────────────────────────────────────────────────────────
    n_total     = len(df)
    n_excluded  = int(df["excluded"].sum())
    n_reviewed  = int((df["tempo_outcome"].notna() & (df["tempo_outcome"] != "unreviewed")).sum())
    n_infl_t    = int((df["tempo_outcome"] == "influenced_intended").sum())
    n_trans_t   = int((df["tempo_outcome"] == "influenced_transient").sum())
    n_infl_w    = int((df["weight_outcome"] == "influenced_intended").sum())
    n_trans_w   = int((df["weight_outcome"] == "influenced_transient").sum())

    bc = st.columns(5)
    bc[0].metric("Total", n_total)
    bc[1].metric("Excluded", n_excluded)
    bc[2].metric("Reviewed", n_reviewed)
    bc[3].metric("Tempo influenced", n_infl_t, delta=f"+{n_trans_t} transient" if n_trans_t else None)
    bc[4].metric("Weight influenced", n_infl_w, delta=f"+{n_trans_w} transient" if n_trans_w else None)

    # ── Data table ────────────────────────────────────────────────────────────
    display_df = df[[
        "pid", "excluded", "agency", "agency_q1", "agency_q2", "agency_q3",
        "ueqs", "ari", "noticed",
        "tempo_outcome", "cadence_pct", "audio_pct", "coupling", "entr_r", "tempo_onset",
        "weight_outcome", "stance_pct", "peak_pct", "imu_pct",
    ]].copy()

    display_df.rename(columns={
        "pid": "PID", "excluded": "Excl?", "agency": "Agency",
        "agency_q1": "Q1", "agency_q2": "Q2", "agency_q3": "Q3",
        "ueqs": "UEQS", "ari": "ARI", "noticed": "Noticed",
        "tempo_outcome": "Tempo", "cadence_pct": "Cad Δ%",
        "audio_pct": "Audio Δ%", "coupling": "Coupling", "entr_r": "Entr. r",
        "tempo_onset": "T.onset",
        "weight_outcome": "Weight", "stance_pct": "Stance Δ%",
        "peak_pct": "Peak Δ%", "imu_pct": "IMU Δ%",
    }, inplace=True)

    # Colour-code outcome columns
    def _style_outcome(val: str) -> str:
        colours = {
            "influenced_intended": "color:#10B981; font-weight:600",
            "influenced_opposite": "color:#EF4444; font-weight:600",
            "no_effect":           "color:#6B7280",
            "unclear":             "color:#F59E0B",
        }
        return colours.get(val, "")

    st.dataframe(
        display_df,
        use_container_width=True,
        hide_index=True,
        column_config={
            "Excl?":      st.column_config.CheckboxColumn("Excl?", width="small"),
            "Noticed":    st.column_config.CheckboxColumn("Noticed", width="small"),
            "Cad Δ%":    st.column_config.NumberColumn(format="%.1f%%"),
            "Audio Δ%":  st.column_config.NumberColumn(format="%.1f%%"),
            "Coupling":  st.column_config.NumberColumn(format="%.2f×"),
            "Entr. r":   st.column_config.NumberColumn(format="%.2f"),
            "Stance Δ%": st.column_config.NumberColumn(format="%.1f%%"),
            "Peak Δ%":   st.column_config.NumberColumn(format="%.1f%%"),
            "IMU Δ%":    st.column_config.NumberColumn(format="%.1f%%"),
        },
    )

    # ── Correlation scatter ───────────────────────────────────────────────────
    scatter_df = df[
        df["excluded"] == 0
        & df["tempo_outcome"].notna()
        & (df["tempo_outcome"] != "unreviewed")
        & df["agency"].notna()
    ].copy()

    if len(scatter_df) < 3:
        st.caption("Not enough reviewed, non-excluded participants yet to show correlation.")
        return

    st.markdown("**Agency vs influence magnitude**")
    scatter_cols = st.columns(2)

    outcome_colors = {
        "influenced_intended":  "#10B981",
        "influenced_transient": "#F97316",   # amber-orange: real effect, but transient
        "influenced_opposite":  "#EF4444",
        "no_effect":            "#9CA3AF",
        "unclear":              "#F59E0B",
        "unreviewed":           "#D1D5DB",
    }

    for col_idx, (metric_col, outcome_col, label) in enumerate([
        ("cadence_pct",  "tempo_outcome",  "Cadence Δ% (tempo)"),
        ("stance_pct",   "weight_outcome", "Stance Δ% (weight)"),
    ]):
        plot_df = scatter_df.dropna(subset=["agency", metric_col])
        if len(plot_df) < 3:
            continue

        with scatter_cols[col_idx]:
            # Spearman r
            r_val, p_val = scipy_stats.spearmanr(plot_df["agency"], plot_df[metric_col])
            p_str = f"{p_val:.3f}" if p_val >= 0.001 else "<0.001"

            fig_s = go.Figure()
            for outcome, grp in plot_df.groupby(outcome_col):
                fig_s.add_trace(go.Scatter(
                    x=grp["agency"], y=grp[metric_col],
                    mode="markers+text",
                    text=grp["pid"], textposition="top center",
                    marker={"size": 9, "color": outcome_colors.get(outcome, "#999"), "line": {"width": 1, "color": "#fff"}},
                    name=_OUTCOME_LABELS.get(outcome, outcome),
                    hovertemplate="%{text}<br>Agency %{x:.1f}  ·  " + label.split("(")[0].strip() + " %{y:.1f}%<extra></extra>",
                ))

            # Trend line
            if len(plot_df) >= 4:
                m, b = np.polyfit(plot_df["agency"], plot_df[metric_col], 1)
                x_range = np.linspace(plot_df["agency"].min(), plot_df["agency"].max(), 50)
                fig_s.add_trace(go.Scatter(
                    x=x_range, y=m * x_range + b,
                    mode="lines", name="trend",
                    line={"color": "#aaa", "dash": "dot", "width": 1.5},
                    showlegend=False,
                ))

            fig_s.add_annotation(
                x=0.98, y=0.02, xref="paper", yref="paper",
                text=f"Spearman r = {r_val:.2f}  (p = {p_str})",
                showarrow=False, font={"size": 10, "color": "#555"},
                xanchor="right", yanchor="bottom",
            )
            fig_s.update_layout(
                height=320, title_text=label,
                margin={"t": 35, "b": 40, "l": 55, "r": 15},
                plot_bgcolor="white", paper_bgcolor="white",
                legend={"x": 1.0, "y": 1.0, "font": {"size": 9}},
                xaxis_title="Agency (aggregate)", yaxis_title=label,
            )
            fig_s.update_xaxes(showgrid=True, gridcolor="#eee")
            fig_s.update_yaxes(showgrid=True, gridcolor="#eee", zeroline=True, zerolinecolor="#ddd")
            st.plotly_chart(fig_s, use_container_width=True, config={"scrollZoom": False})


# ── Main plot ─────────────────────────────────────────────────────────────────

def build_figure(
    entries: list[dict],
    pressure_view: str,
    show_pressure: bool,
    show_accel: bool,
    show_gyro: bool,
    show_force: bool,
    accel_axes: str,
    normalize: bool,
    time_filter: str,
    imu_offsets: dict,
    smooth_metrics: bool = True,
    smooth_window: int = 10,
    show_audio_bpm: bool = False,
) -> go.Figure:
    active = [e for e in entries if e.get("data") is not None]
    if not active:
        fig = go.Figure()
        fig.update_layout(title="No data loaded", height=300)
        return fig

    # When raw pressure + force are both on, overlay force on pressure rows (secondary y)
    overlay_force = show_force and show_pressure and pressure_view == "raw"

    # Build row list — no subplot_titles; rows labeled via y-axis titles
    row_specs: list[tuple[str, float]] = []  # (label, height)
    if show_pressure:
        if pressure_view == "raw":
            row_specs += [("L toe", 1.2), ("L heel", 1.2), ("R toe", 1.2), ("R heel", 1.2)]
        elif pressure_view == "bpm":
            row_specs += [("Cadence", 2.0)]
        elif pressure_view == "stride":
            row_specs += [("Stance (ms)", 1.2), ("Interval (ms)", 1.2)]
    if show_accel:
        row_specs.append(("Accel", 1.0))
    if show_gyro:
        row_specs.append(("Gyro", 1.0))
    if show_force and not overlay_force:
        row_specs.append(("Force", 1.0))

    if not row_specs:
        fig = go.Figure()
        fig.update_layout(title="Select at least one channel", height=200)
        return fig

    row_labels  = [r[0] for r in row_specs]
    row_heights = [r[1] for r in row_specs]
    n_rows = len(row_specs)
    row_idx = {label: i + 1 for i, label in enumerate(row_labels)}

    subplot_specs = [[{"secondary_y": True}]] * n_rows if (overlay_force or show_audio_bpm) else [[{}]] * n_rows
    fig = make_subplots(
        rows=n_rows, cols=1,
        shared_xaxes=True,
        row_heights=row_heights,
        vertical_spacing=0.06,
        specs=subplot_specs,
    )

    # Stage bands from first participant
    first_data = active[0]["data"]
    stages = first_data.get("stages", [])
    pres0 = first_data["pressure_df"]
    data_start_s = float(pres0["session_ms"].min()) / 1000.0 if not pres0.empty else None
    data_end_s   = float(pres0["session_ms"].max()) / 1000.0 if not pres0.empty else None
    _add_stage_bands(fig, stages, n_rows, data_start_s, data_end_s)

    for entry in active:
        pid   = entry["pid"]
        data  = entry["data"]
        color = entry["color"]
        thresholds = data.get("thresholds")
        extra_offset_s = imu_offsets.get(pid, 0.0)

        pres_df = data["pressure_df"].copy()
        imu_df  = data["imu_df"].copy() if not data["imu_df"].empty else pd.DataFrame()

        # Time filter
        stage_filter: list[str] | None = None
        if time_filter == "conditions":
            stage_filter = ["condition_1", "condition_2"]
        elif time_filter != "full":
            stage_filter = [time_filter]

        if stage_filter and "stage" in pres_df.columns:
            pres_df = pres_df[pres_df["stage"].isin(stage_filter)].copy()
        if stage_filter and not imu_df.empty:
            if "stage" in imu_df.columns:
                imu_df = imu_df[imu_df["stage"].isin(stage_filter)].copy()
            elif not pres_df.empty:
                # No stage col in IMU — crop to same time window as filtered pressure
                t_min = pres_df["session_ms"].min()
                t_max = pres_df["session_ms"].max()
                imu_df = imu_df[
                    (imu_df["session_ms"] >= t_min) & (imu_df["session_ms"] <= t_max)
                ].copy()

        pres_df["t_s"] = pres_df["session_ms"] / 1000.0
        if not imu_df.empty:
            imu_df["t_s"] = imu_df["session_ms"] / 1000.0 + extra_offset_s

        pres_ds = downsample(pres_df)
        imu_ds  = downsample(imu_df) if not imu_df.empty else imu_df

        # ── Pressure views ────────────────────────────────────────────────────
        if show_pressure:

            if pressure_view == "raw":
                zone_rows = [
                    ("L toe",  "L_toe",  "solid"),
                    ("L heel", "L_heel", "dash"),
                    ("R toe",  "R_toe",  "dot"),
                    ("R heel", "R_heel", "dashdot"),
                ]
                for row_label, col_name, dash in zone_rows:
                    if row_label not in row_idx or col_name not in pres_ds.columns:
                        continue
                    y = pres_ds[col_name]
                    if normalize:
                        mu, sigma = _cal_baseline(pres_df, col_name)
                        y = (y - mu) / sigma
                    fig.add_trace(
                        go.Scattergl(
                            x=pres_ds["t_s"], y=y, mode="lines",
                            name=f"{pid} {col_name}",
                            line={"color": color, "dash": dash, "width": 1},
                            legendgroup=pid, showlegend=True,
                            hovertemplate=f"<b>{pid}</b> {col_name}<br>t=%{{x:.1f}}s  v=%{{y:.1f}}<extra></extra>",
                        ),
                        row=row_idx[row_label], col=1,
                    )

            elif pressure_view == "bpm" and "Cadence" in row_idx:
                if True:
                    cadence_df = compute_cadence(pres_df, thresholds)
                    if not cadence_df.empty:
                        cadence_df["t_s"] = cadence_df["session_ms"] / 1000.0
                        row_n = row_idx["Cadence"]
                        ht = f"<b>{pid}</b><br>t=%{{x:.1f}}s  %{{y:.1f}} BPM<extra></extra>"
                        if smooth_metrics:
                            _add_band_traces(
                                fig, cadence_df["t_s"].values,
                                cadence_df["bpm_raw"], smooth_window,
                                color, f"{pid} cadence", pid, row_n,
                                showlegend=True, hovertemplate=ht,
                            )
                            _cv_annotation(fig, cadence_df["bpm_raw"].values, row_n)
                        else:
                            fig.add_trace(
                                go.Scattergl(
                                    x=cadence_df["t_s"], y=cadence_df["bpm_raw"],
                                    mode="markers", name=f"{pid} cadence",
                                    marker={"color": color, "size": 5},
                                    legendgroup=pid, showlegend=True,
                                    hovertemplate=ht,
                                ),
                                row=row_n, col=1,
                            )
                        audio_mask = cadence_df["audio_bpm"].notna()
                        if audio_mask.any():
                            aud_ds = downsample(cadence_df.loc[audio_mask], max_pts=2000)
                            fig.add_trace(
                                go.Scattergl(
                                    x=aud_ds["t_s"], y=aud_ds["audio_bpm"],
                                    mode="lines", name=f"{pid} audio BPM",
                                    line={"color": color, "dash": "dash", "width": 1.5},
                                    opacity=0.5, legendgroup=pid, showlegend=True,
                                    hovertemplate=f"<b>{pid}</b> audio<br>t=%{{x:.1f}}s  %{{y:.1f}} BPM<extra></extra>",
                                ),
                                row=row_n, col=1,
                            )

            elif pressure_view == "stride":
                # Stride view needs thresholds only when the combined CSV lacks
                # per-row threshold columns (L_heel_lower etc). Check for that first.
                has_dynamic_thresh = "L_heel_lower" in pres_df.columns and "L_heel_upper" in pres_df.columns
                if thresholds is None and not has_dynamic_thresh:
                    st.warning(f"{pid}: no threshold data — stride view unavailable")
                else:
                    contacts = detect_foot_contacts(pres_df, thresholds or {})
                    if not contacts.empty:
                        contacts["t_s"] = contacts["session_ms"] / 1000.0
                        for foot, dash in (("L", "solid"), ("R", "dash")):
                            fd = contacts[contacts["foot"] == foot]
                            if fd.empty:
                                continue
                            if "Stance (ms)" in row_idx:
                                row_n = row_idx["Stance (ms)"]
                                ht = f"<b>{pid}</b> stance {foot}<br>t=%{{x:.1f}}s  %{{y:.0f}}ms<extra></extra>"
                                if smooth_metrics:
                                    _add_band_traces(
                                        fig, fd["t_s"].values, fd["stance_ms"],
                                        smooth_window, color,
                                        f"{pid} stance {foot}", pid, row_n,
                                        showlegend=(foot == "L"), hovertemplate=ht,
                                    )
                                    if foot == "L":
                                        _cv_annotation(fig, fd["stance_ms"].values, row_n)
                                else:
                                    fig.add_trace(
                                        go.Scatter(
                                            x=fd["t_s"], y=fd["stance_ms"],
                                            mode="markers+lines", name=f"{pid} stance {foot}",
                                            line={"color": color, "dash": dash, "width": 1},
                                            marker={"size": 5}, legendgroup=pid,
                                            showlegend=(foot == "L"),
                                            hovertemplate=ht,
                                        ),
                                        row=row_n, col=1,
                                    )
                            if "Interval (ms)" in row_idx:
                                iv = fd[fd["interval_ms"].notna()]
                                if not iv.empty:
                                    row_n = row_idx["Interval (ms)"]
                                    ht = f"<b>{pid}</b> interval {foot}<br>t=%{{x:.1f}}s  %{{y:.0f}}ms<extra></extra>"
                                    if smooth_metrics:
                                        _add_band_traces(
                                            fig, iv["t_s"].values, iv["interval_ms"],
                                            smooth_window, color,
                                            f"{pid} interval {foot}", pid, row_n,
                                            showlegend=False, hovertemplate=ht,
                                        )
                                        if foot == "L":
                                            _cv_annotation(fig, iv["interval_ms"].values, row_n)
                                    else:
                                        fig.add_trace(
                                            go.Scatter(
                                                x=iv["t_s"], y=iv["interval_ms"],
                                                mode="markers+lines", name=f"{pid} interval {foot}",
                                                line={"color": color, "dash": dash, "width": 1},
                                                marker={"size": 5}, legendgroup=pid,
                                                showlegend=False, hovertemplate=ht,
                                            ),
                                            row=row_n, col=1,
                                        )

        # ── IMU Acceleration ──────────────────────────────────────────────────
        if show_accel and "Accel" in row_idx and not imu_ds.empty:
            for side, side_dash in (("L", "solid"), ("R", "dash")):
                if accel_axes == "magnitude":
                    mag = _accel_mag(imu_ds, side)
                    if mag is not None:
                        y = (mag - mag.mean()) / max(mag.std(), 1e-6) if normalize else mag
                        fig.add_trace(
                            go.Scattergl(
                                x=imu_ds["t_s"], y=y, mode="lines",
                                name=f"{pid} accel {side}",
                                line={"color": color, "dash": side_dash, "width": 1},
                                legendgroup=pid, showlegend=False,
                                hovertemplate=f"<b>{pid}</b> accel-{side}<br>t=%{{x:.1f}}s  v=%{{y:.2f}}<extra></extra>",
                            ),
                            row=row_idx["Accel"], col=1,
                        )
                else:
                    for col_name in IMU_ACCEL_COLS[side]:
                        if col_name not in imu_ds.columns:
                            continue
                        y = imu_ds[col_name]
                        if normalize:
                            y = (y - y.mean()) / max(y.std(), 1e-6)
                        fig.add_trace(
                            go.Scattergl(
                                x=imu_ds["t_s"], y=y, mode="lines",
                                name=f"{pid} {col_name}",
                                line={"color": color, "dash": side_dash, "width": 1},
                                legendgroup=pid, showlegend=False,
                                hovertemplate=f"<b>{pid}</b> {col_name}<br>t=%{{x:.1f}}s  v=%{{y:.3f}}<extra></extra>",
                            ),
                            row=row_idx["Accel"], col=1,
                        )

        # ── IMU Gyro ──────────────────────────────────────────────────────────
        if show_gyro and "Gyro" in row_idx and not imu_ds.empty:
            for side, dash in (("L", "solid"), ("R", "dash")):
                mag = _gyro_mag(imu_ds, side)
                if mag is not None:
                    y = (mag - mag.mean()) / max(mag.std(), 1e-6) if normalize else mag
                    fig.add_trace(
                        go.Scattergl(
                            x=imu_ds["t_s"], y=y, mode="lines",
                            name=f"{pid} gyro {side}",
                            line={"color": color, "dash": dash, "width": 1},
                            legendgroup=pid, showlegend=False,
                            hovertemplate=f"<b>{pid}</b> gyro-{side}<br>t=%{{x:.1f}}s  v=%{{y:.2f}}<extra></extra>",
                        ),
                        row=row_idx["Gyro"], col=1,
                    )

        # ── IMU Force ─────────────────────────────────────────────────────────
        if show_force and not imu_ds.empty:
            if overlay_force:
                # Overlay each IMU force zone onto its matching pressure row (secondary y)
                for row_label, col_name, accent in FORCE_OVERLAY_ZONES:
                    if row_label not in row_idx or col_name not in imu_ds.columns:
                        continue
                    y = imu_ds[col_name]
                    if normalize:
                        y = (y - y.mean()) / max(y.std(), 1e-6)
                    fig.add_trace(
                        go.Scattergl(
                            x=imu_ds["t_s"], y=y, mode="lines",
                            name=f"{pid} {col_name}",
                            line={"color": accent, "width": 1, "dash": "dot"},
                            opacity=0.8,
                            legendgroup=pid, showlegend=True,
                            hovertemplate=f"<b>{pid}</b> {col_name}<br>t=%{{x:.1f}}s  v=%{{y:.1f}}<extra></extra>",
                        ),
                        row=row_idx[row_label], col=1, secondary_y=True,
                    )
            elif "Force" in row_idx:
                for side, dash in (("L", "solid"), ("R", "dash")):
                    for col_name in IMU_FORCE_COLS[side]:
                        if col_name not in imu_ds.columns:
                            continue
                        y = imu_ds[col_name]
                        if normalize:
                            y = (y - y.mean()) / max(y.std(), 1e-6)
                        fig.add_trace(
                            go.Scattergl(
                                x=imu_ds["t_s"], y=y, mode="lines",
                                name=f"{pid} {col_name}",
                                line={"color": color, "dash": dash, "width": 1},
                                legendgroup=pid, showlegend=False,
                                hovertemplate=f"<b>{pid}</b> {col_name}<br>t=%{{x:.1f}}s  v=%{{y:.1f}}<extra></extra>",
                            ),
                            row=row_idx["Force"], col=1,
                        )

    # ── Y-axis labels (combine row name + unit) ───────────────────────────────
    unit = "z-score" if normalize else "mV / counts"
    yaxis_labels = {
        "L toe":  f"L toe\n({unit})",
        "L heel": f"L heel\n({unit})",
        "R toe":  f"R toe\n({unit})",
        "R heel": f"R heel\n({unit})",
        "Cadence":     "BPM",
        "Stance (ms)": "Stance (ms)",
        "Interval (ms)": "Interval (ms)",
        "Accel":  "z-score" if normalize else ("m/s²" if accel_axes == "magnitude" else "Accel"),
        "Gyro":   "z-score" if normalize else "Gyro (rad/s)",
        "Force":  "z-score" if normalize else "Force (counts)",
    }
    for label, row_n in row_idx.items():
        if label in yaxis_labels:
            fig.update_yaxes(title_text=yaxis_labels[label], row=row_n, col=1, secondary_y=False)

    if overlay_force:
        force_unit = "z-score" if normalize else "counts"
        for row_label, _col, _accent in FORCE_OVERLAY_ZONES:
            if row_label in row_idx:
                fig.update_yaxes(
                    title_text=f"IMU force\n({force_unit})",
                    secondary_y=True, row=row_idx[row_label], col=1,
                    fixedrange=True, showgrid=False,
                )

    # ── Audio BPM overlay ─────────────────────────────────────────────────────
    if show_audio_bpm:
        shown_legend = False
        for entry in active:
            pid  = entry["pid"]
            pres_df = entry["data"]["pressure_df"]
            if "bpm" not in pres_df.columns or "ratio" not in pres_df.columns:
                continue
            mask = pres_df["bpm"].notna() & pres_df["ratio"].notna()
            if not mask.any():
                continue
            ab = pres_df.loc[mask].copy()
            ab["audio_bpm"] = ab["bpm"] * ab["ratio"]
            t_s = ab["session_ms"].values / 1000.0
            y   = ab["audio_bpm"].values
            for row_n in range(1, n_rows + 1):
                fig.add_trace(
                    go.Scattergl(
                        x=t_s, y=y, mode="lines",
                        name=f"{pid} audio BPM",
                        line={"color": "#f39c12", "width": 1.5, "dash": "dot"},
                        opacity=0.7,
                        legendgroup=f"{pid}_audiobpm",
                        showlegend=(not shown_legend),
                        hovertemplate=f"<b>{pid}</b> audio BPM<br>t=%{{x:.1f}}s  %{{y:.1f}} BPM<extra></extra>",
                    ),
                    row=row_n, col=1, secondary_y=True,
                )
                shown_legend = True
        if show_audio_bpm:
            for row_n in range(1, n_rows + 1):
                fig.update_yaxes(
                    title_text="BPM", secondary_y=True,
                    row=row_n, col=1, fixedrange=True, showgrid=False,
                    range=[60, 120],
                )

    fig.update_xaxes(title_text="Time (s)", row=n_rows, col=1)

    total_height = 180 + sum(h * 160 for h in row_heights)
    fig.update_layout(
        height=int(total_height),
        margin={"t": 45, "b": 40, "l": 80, "r": 20},
        legend={"orientation": "v", "x": 1.01, "y": 1.0},
        hovermode="x unified",
        dragmode="pan",
        plot_bgcolor="white",
        paper_bgcolor="white",
    )
    fig.update_xaxes(showgrid=True, gridcolor="#eee")
    fig.update_yaxes(showgrid=True, gridcolor="#eee", fixedrange=True)
    return fig


# ── Streamlit UI ──────────────────────────────────────────────────────────────

def main() -> None:
    st.set_page_config(page_title="Gait Study Viewer", layout="wide", initial_sidebar_state="expanded")
    st.title("Gait Study — Pressure & IMU Viewer")

    with st.sidebar:
        st.header("Session selection")

        test_types = get_test_types()
        tt_options = {f"{t['id']}: {t['name']}": t["id"] for t in test_types}
        selected_tt_label = st.selectbox("Test type", list(tt_options.keys()))
        test_type_id = tt_options[selected_tt_label]

        sessions_df = get_sessions(test_type_id)
        if sessions_df.empty:
            st.warning("No sessions found for this test type.")
            return

        def session_label(row: pd.Series) -> str:
            cond = f" [{row['condition_order']}]" if pd.notna(row.get("condition_order")) and row["condition_order"] else ""
            status = row.get("status", "")
            icon = "✓" if status == "complete" else ("~" if status in ("merged", "imu-saved") else "…")
            return f"{row['participant_id']}{cond}  {icon}"

        sessions_df["_label"] = sessions_df.apply(session_label, axis=1)

        unique_pids = sessions_df["participant_id"].unique().tolist()
        selected_pids = st.multiselect(
            "Participants (up to 4)",
            options=unique_pids,
            max_selections=4,
            format_func=lambda p: str(p),
        )

        selected_session_ids: dict[str, int] = {}
        for pid in selected_pids:
            pid_sessions = sessions_df[sessions_df["participant_id"] == pid]
            if len(pid_sessions) == 1:
                selected_session_ids[pid] = int(pid_sessions.iloc[0]["session_id"])
            else:
                opts = {row["_label"]: int(row["session_id"]) for _, row in pid_sessions.iterrows()}
                chosen = st.selectbox(f"Session for {pid}", list(opts.keys()), key=f"sess_{pid}")
                selected_session_ids[pid] = opts[chosen]

        st.divider()
        st.header("Channels")
        show_pressure = st.checkbox("Pressure", value=True)
        if show_pressure:
            pressure_view = st.radio(
                "Pressure view",
                options=["raw", "bpm", "stride"],
                format_func=lambda v: {"raw": "Raw values (L / R)", "bpm": "Cadence (BPM)", "stride": "Stride metrics"}[v],
                key="pressure_view",
            )
        else:
            pressure_view = "raw"

        smooth_metrics = False
        smooth_window  = 10
        if show_pressure and pressure_view in ("bpm", "stride"):
            smooth_metrics = st.checkbox("Moving average", value=True, key="smooth_metrics")
            if smooth_metrics:
                smooth_window = st.slider("Window (steps)", 3, 30, 10, key="smooth_window")

        show_accel  = st.checkbox("IMU Acceleration", value=True)
        show_gyro   = st.checkbox("IMU Gyroscope", value=False)
        show_force  = st.checkbox("IMU Force (toe/heel)", value=False)
        accel_mode  = st.radio("Accel display", ["magnitude", "individual"], horizontal=True)
        show_audio_bpm = st.checkbox("Audio BPM overlay", value=False,
                                     help="Overlay the live metronome BPM (bpm × ratio) on every subplot as a secondary axis. Only available in the tempo condition.")
        show_condition_effects = st.checkbox(
            "Condition effects", value=False, key="cond_effects",
            help="Show a separate analysis panel comparing cadence and stride metrics against the audio_only baseline.",
        )
        show_review = st.checkbox(
            "Review panel", value=False, key="show_review",
            help="Formal review: exclusion criteria, auto-computed influence verdicts with researcher override.",
        )

        st.divider()
        st.header("Options")
        normalize = st.checkbox(
            "Z-score (calibration baseline)", value=False,
            help="Normalise each channel to calibration mean/std. Not applied to BPM or stride views.",
        )

        st.divider()
        st.header("Time range")
        time_filter = st.selectbox(
            "Show",
            ["full", "calibration", "audio_only", "condition_1", "condition_2", "conditions"],
            format_func=lambda s: {
                "full": "Full session",
                "calibration": "Calibration",
                "audio_only": "Audio only (pondering)",
                "condition_1": "Condition 1",
                "condition_2": "Condition 2",
                "conditions": "Conditions 1 + 2",
            }[s],
        )

    if not selected_pids:
        st.info("Select one or more participants from the sidebar to begin.")
        return

    alignment_report = load_alignment_report()
    entries: list[dict] = []
    load_errors: list[str] = []

    with st.spinner("Loading session data…"):
        for i, pid in enumerate(selected_pids):
            sid  = selected_session_ids[pid]
            data = load_session_data(sid, pid)
            entries.append({
                "pid": pid, "session_id": sid,
                "color": PARTICIPANT_COLORS[i % len(PARTICIPANT_COLORS)],
                "data": data,
            })
            if data is None:
                load_errors.append(f"{pid}: could not load data (check raw files or run alignment pipeline first)")

    for err in load_errors:
        st.error(err)

    loaded_entries = [e for e in entries if e["data"] is not None]

    if pressure_view == "stride":
        # Stride view only needs thresholds when per-row columns are absent from the CSV
        missing = [
            e["pid"] for e in loaded_entries
            if not e["data"].get("thresholds")
            and "L_heel_lower" not in (e["data"].get("pressure") or pd.DataFrame()).columns
        ]
        if missing:
            st.warning(f"No threshold data for {', '.join(str(p) for p in missing)} — stride view may be incomplete.")

    # ── DB migrations (idempotent) ────────────────────────────────────────────
    _ensure_imu_offset_col()
    _ensure_review_table()

    # ── IMU alignment fine-tune ───────────────────────────────────────────────
    # Dynamic slider range = full session duration so any offset is reachable
    slider_range = 120.0
    if loaded_entries:
        pres0 = loaded_entries[0]["data"]["pressure_df"]
        if not pres0.empty:
            slider_range = max(120.0, float(pres0["session_ms"].max()) / 1000.0)

    imu_offsets: dict[str, float] = {}
    if loaded_entries and (show_accel or show_gyro or show_force):
        # Show 🔒 in expander label if any session has a saved non-zero offset
        any_locked = any(load_imu_offset(e["session_id"]) != 0.0 for e in loaded_entries)
        expander_label = "IMU alignment fine-tune 🔒" if any_locked else "IMU alignment fine-tune"
        with st.expander(expander_label, expanded=False):
            st.caption("Changes apply instantly — the plot updates as you drag. Click **Lock** to save the offset for this session.")
            for entry in loaded_entries:
                pid  = entry["pid"]
                sid  = entry["session_id"]
                data = entry["data"]
                computed_s = data["offset_ms"] / 1000.0 if data.get("offset_ms") is not None else 0.0
                saved_s = load_imu_offset(sid)
                canon_key = f"imu_offset_val_{pid}"
                slider_key = f"offset_slider_{pid}"
                num_key    = f"offset_num_{pid}"
                # Always re-sync session_state to DB value on fresh page load
                if canon_key not in st.session_state:
                    st.session_state[canon_key] = saved_s

                def _sync_from_slider(sk=slider_key, ck=canon_key, nk=num_key):
                    v = st.session_state[sk]
                    st.session_state[ck] = v
                    st.session_state[nk] = v

                def _sync_from_num(nk=num_key, ck=canon_key, sk=slider_key):
                    v = float(np.clip(st.session_state[nk], -slider_range, slider_range))
                    st.session_state[ck] = v
                    st.session_state[sk] = float(round(v))

                sl_col, num_col, lock_col = st.columns([4, 1.4, 0.8])
                with sl_col:
                    st.slider(
                        f"{pid} offset (s)",
                        min_value=-slider_range, max_value=slider_range,
                        value=float(round(st.session_state[canon_key])),
                        step=1.0, key=slider_key,
                        on_change=_sync_from_slider,
                        help=f"Computed alignment offset: {computed_s:+.1f}s  |  Source: {data['source']}",
                    )
                with num_col:
                    st.number_input(
                        "exact (s)",
                        value=st.session_state[canon_key],
                        step=0.1, format="%.1f",
                        key=num_key,
                        on_change=_sync_from_num,
                    )
                extra = float(st.session_state[canon_key])
                with lock_col:
                    st.write("")
                    if st.button("Lock", key=f"lock_{pid}"):
                        save_imu_offset(sid, extra)
                        st.session_state[canon_key] = extra
                        saved_s = extra  # update local so status line reflects immediately
                # Persistent lock status — reads DB value, survives page navigation
                if saved_s != 0.0:
                    st.caption(f"🔒 **{pid}** locked at **{saved_s:+.1f} s**")
                imu_offsets[pid] = extra

    # ── Info panel + notes ────────────────────────────────────────────────────
    if loaded_entries:
        cols = st.columns(len(loaded_entries))
        for col, entry in zip(cols, loaded_entries):
            pid  = entry["pid"]
            sid  = entry["session_id"]
            data = entry["data"]
            with col:
                color = entry["color"]
                st.markdown(
                    f"<div style='border-left:4px solid {color};padding-left:8px'>"
                    f"<b>{pid}</b></div>",
                    unsafe_allow_html=True,
                )
                st.caption(f"Source: **{data['source']}**")
                thresh_ok = bool(data.get("thresholds"))
                st.caption(f"Thresholds: {'✓' if thresh_ok else '✗'}")
                if data.get("offset_ms") is not None:
                    st.caption(f"IMU offset: `{data['offset_ms']:,.0f} ms`")
                if data.get("flags"):
                    for flag in data["flags"][:3]:
                        level = "⚠️" if any(w in flag for w in ("LOST", "SKEW")) else "ℹ️"
                        st.caption(f"{level} `{flag}`")
                    if len(data["flags"]) > 3:
                        st.caption(f"…and {len(data['flags']) - 3} more")
                if alignment_report is not None and "participant_id" in alignment_report.columns:
                    ar_row = alignment_report[alignment_report["participant_id"] == pid]
                    if not ar_row.empty:
                        ar = ar_row.iloc[0]
                        l_cov, r_cov = ar.get("imu_l_coverage_pct"), ar.get("imu_r_coverage_pct")
                        if pd.notna(l_cov) and pd.notna(r_cov):
                            st.caption(f"Coverage: L={l_cov:.0f}%  R={r_cov:.0f}%")

                # Notes field — writes to sessions.notes_data (same as web app)
                current_notes = load_session_notes(sid)
                notes_text = st.text_area(
                    "Notes on data",
                    value=current_notes,
                    height=90,
                    key=f"notes_{pid}_{sid}",
                    placeholder="Add notes about this session's data…",
                )
                if st.button("Save notes", key=f"save_notes_{pid}_{sid}"):
                    save_session_notes(sid, notes_text)
                    st.success("Saved")

                # Tags — shared with web app (session_tags table)
                st.markdown("**Tags**")
                existing_tags = load_session_tags(sid)
                if existing_tags:
                    tag_cols = st.columns(min(len(existing_tags), 4))
                    for i, t in enumerate(existing_tags):
                        with tag_cols[i % 4]:
                            label = t["tag"]
                            if t.get("note"):
                                label += f" · {t['note']}"
                            if st.button(f"× {label}", key=f"del_tag_{t['tag_id']}",
                                         help=f"Stage: {t['stage'] or '—'}  |  Click to remove",
                                         use_container_width=True):
                                delete_session_tag(t["tag_id"])
                                st.rerun()

                # Quick-add from frequent tags
                freq = [f for f in load_frequent_tags()
                        if f not in {t["tag"] for t in existing_tags}]
                if freq:
                    st.caption("Frequent tags:")
                    freq_cols = st.columns(min(len(freq), 5))
                    for i, f in enumerate(freq):
                        with freq_cols[i % 5]:
                            if st.button(f"+ {f}", key=f"quick_tag_{pid}_{sid}_{f}",
                                         use_container_width=True):
                                add_session_tag(sid, f)
                                load_frequent_tags.clear()
                                st.rerun()

                # Free-text add
                tag_in_col, note_col, add_col = st.columns([2, 2, 1])
                with tag_in_col:
                    new_tag = st.text_input("New tag", key=f"new_tag_{pid}_{sid}",
                                            placeholder="e.g. artefact", label_visibility="collapsed")
                with note_col:
                    new_note = st.text_input("Note (optional)", key=f"new_note_{pid}_{sid}",
                                             placeholder="note (optional)", label_visibility="collapsed")
                with add_col:
                    if st.button("Add tag", key=f"add_tag_{pid}_{sid}") and new_tag.strip():
                        add_session_tag(sid, new_tag, new_note)
                        load_frequent_tags.clear()
                        st.rerun()

        st.divider()

    # ── Plot ──────────────────────────────────────────────────────────────────
    fig = build_figure(
        entries=entries,
        pressure_view=pressure_view,
        show_pressure=show_pressure,
        show_accel=show_accel,
        show_gyro=show_gyro,
        show_force=show_force,
        accel_axes=accel_mode,
        normalize=normalize,
        time_filter=time_filter,
        imu_offsets=imu_offsets,
        smooth_metrics=smooth_metrics,
        smooth_window=smooth_window,
        show_audio_bpm=show_audio_bpm,
    )
    st.plotly_chart(fig, use_container_width=True, config={"scrollZoom": True})

    if show_condition_effects and loaded_entries:
        st.subheader("Condition effects")
        _render_condition_effects(loaded_entries, smooth_window)

    if show_review and loaded_entries:
        st.subheader("Review")
        _render_review_panel(loaded_entries)

    with st.expander("All participants — questionnaire & outcomes", expanded=False):
        _render_questionnaire_overview(test_type_id)

    with st.expander("Raw data preview", expanded=False):
        for entry in loaded_entries:
            pid  = entry["pid"]
            data = entry["data"]
            st.markdown(f"**{pid}** — pressure ({len(data['pressure_df'])} rows)")
            st.dataframe(data["pressure_df"].head(20), use_container_width=True)
            if not data["imu_df"].empty:
                st.markdown(f"**{pid}** — IMU ({len(data['imu_df'])} rows)")
                st.dataframe(data["imu_df"].head(20), use_container_width=True)


if __name__ == "__main__":
    main()
