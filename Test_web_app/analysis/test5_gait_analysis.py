"""Test 5 gait analysis — tempo entrainment and weight gait depth.

Tempo condition:
  Success = participant cadence tracks the ±8% BPM ramp.
  Measured by Pearson r between smoothed cadence and effective audio BPM over time.
  Also checks starting alignment: participant cadence within 0.85–1.15× of base_BPM.

Weight condition:
  Success = heel contact time and net acceleration change in the expected direction.
  Method: z-scores relative to calibration baseline (Tajadura-Jiménez et al. 2015).
  decreasing (lighter sound): z_heel < 0, z_accel > 0
  increasing (heavier sound): z_heel > 0, z_accel < 0

Audio BPM ramp: effective_BPM(t) = base_BPM × ratio(t)  [speeding_up]
                                  = base_BPM / ratio(t)  [slowing_down]
where ratio(t) is read from the tempo pressure file (Max/MSP embeds it per record).

Run: python analysis/test5_gait_analysis.py
"""
from __future__ import annotations

import sqlite3
import sys
from pathlib import Path

import numpy as np
import pandas as pd
from scipy import stats

# ── Project root on path ──────────────────────────────────────────────────────
ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(ROOT))

DB_PATH = ROOT / "data" / "gait_study.db"
DATA_ROOT = ROOT / "data" / "Test 5" / "Raw data"

DEDUP_MS = 300.0
ZONES = ["L_toe", "L_heel", "R_toe", "R_heel"]
RAMP_MAGNITUDE = 0.08          # ±8%
ENTRAINMENT_R_THRESHOLD = 0.6
SYNC_WINDOW = (0.85, 1.15)

# Plausible heel-contact (stance) duration range.
# At 60–130 BPM, stance is ~60% of 460–1000 ms ≈ 275–600 ms.
# Widen to 80–1200 ms to allow for slow participants while excluding
# long "stuck" contacts that arise when the heel never fully clears
# the lower pressure threshold between consecutive steps.
HEEL_CONTACT_MIN_MS = 80.0
HEEL_CONTACT_MAX_MS = 2000.0
MIN_HEEL_CONTACTS = 5     # require this many valid contacts for z-score


# ── File parsers ─────────────────────────────────────────────────────────────

def _parse_records(path: Path) -> list[list[str]]:
    """Split a Max/MSP semicolon file into per-record value lists."""
    raw = path.read_text().strip()
    out = []
    for record in raw.split(";"):
        record = record.strip()
        if not record:
            continue
        parts = record.split(",", 1)
        if len(parts) != 2:
            continue
        values = parts[1].strip().split()
        out.append(values)
    return out


def parse_calibration_file(path: Path) -> pd.DataFrame:
    """Calibration file format: wall_clock_ts, relative_ms, L_toe, L_heel, R_toe, R_heel.

    values[0] = wall-clock timestamp (unreliable — can be 0 or stuck for some participants)
    values[1] = relative recording time 0→~30000 ms (always present and correct)

    We always use values[1] as device_ms for consistent timing across participants.
    The first 1-2 records can carry a stale ~29999 ms value from the circular buffer;
    sorting by device_ms places them at the end where they are harmless.
    """
    rows = []
    for values in _parse_records(path):
        if len(values) < 6:
            continue
        try:
            rows.append({
                "device_ms": float(values[1]),   # relative time is always at index 1
                "L_toe":  float(values[2]),
                "L_heel": float(values[3]),
                "R_toe":  float(values[4]),
                "R_heel": float(values[5]),
            })
        except ValueError:
            continue
    df = pd.DataFrame(rows)
    if not df.empty:
        df = df.sort_values("device_ms").reset_index(drop=True)
    return df


def parse_condition_file(path: Path) -> tuple[pd.DataFrame, dict]:
    """Parse tempo / weight / pondering pressure file.

    All formats share: ts, L_toe, L_heel, R_toe, R_heel, 8 threshold values.
    Tempo files additionally carry: bpm (values[13]), ratio (values[14]).
    Weight files carry one extra marker at values[13] that is always 0.

    Returns (DataFrame, thresholds_dict).
    """
    rows = []
    thresholds: dict = {}

    for values in _parse_records(path):
        if len(values) < 13:
            continue
        try:
            row: dict = {
                "device_ms": float(values[0]),
                "L_toe":  float(values[1]),
                "L_heel": float(values[2]),
                "R_toe":  float(values[3]),
                "R_heel": float(values[4]),
            }

            # Per-row thresholds (these adapt over time)
            row["L_toe_lower"]  = float(values[5])
            row["L_toe_upper"]  = float(values[6])
            row["L_heel_lower"] = float(values[7])
            row["L_heel_upper"] = float(values[8])
            row["R_toe_lower"]  = float(values[9])
            row["R_toe_upper"]  = float(values[10])
            row["R_heel_lower"] = float(values[11])
            row["R_heel_upper"] = float(values[12])

            # Keep summary thresholds dict (from first record, for callers that need it)
            if not thresholds:
                thresholds = {
                    "L_toe":  {"lower": float(values[5]),  "upper": float(values[6])},
                    "L_heel": {"lower": float(values[7]),  "upper": float(values[8])},
                    "R_toe":  {"lower": float(values[9]),  "upper": float(values[10])},
                    "R_heel": {"lower": float(values[11]), "upper": float(values[12])},
                }

            # Tempo-only columns (bpm + ratio present when len >= 15)
            if len(values) >= 15:
                try:
                    bpm_val   = float(values[13])
                    ratio_val = float(values[14])
                    # Sanity: BPM should be plausible (30–250), ratio near 1
                    if 30 < bpm_val < 250 and 0.5 < ratio_val < 3.0:
                        row["bpm"]   = bpm_val
                        row["ratio"] = ratio_val
                except ValueError:
                    pass

            rows.append(row)
        except ValueError:
            continue

    return pd.DataFrame(rows), thresholds


# ── Step detection ───────────────────────────────────────────────────────────

def detect_steps(df: pd.DataFrame, thresholds: dict) -> list[float]:
    """Detect foot-contact events using per-zone hysteresis.

    Fires when any zone crosses its upper threshold; deduplicates events
    within DEDUP_MS (toe + heel on the same foot = one step).

    Returns sorted list of event timestamps (device_ms).
    """
    above = {z: False for z in ZONES}
    raw: list[float] = []

    for row in df.to_dict("records"):
        ts = float(row.get("device_ms") or 0)
        for zone in ZONES:
            t = thresholds.get(zone)
            if not t:
                continue
            val = float(row.get(zone) or 0)
            if not above[zone]:
                if val > t["upper"]:
                    above[zone] = True
                    raw.append(ts)
            else:
                if val < t["lower"]:
                    above[zone] = False

    raw.sort()
    deduped: list[float] = []
    for ts in raw:
        if not deduped or ts - deduped[-1] >= DEDUP_MS:
            deduped.append(ts)
    return deduped


def cadence_bpm(step_ts: list[float], duration_ms: float) -> float:
    """Average cadence in BPM."""
    if duration_ms <= 0 or len(step_ts) < 2:
        return 0.0
    return len(step_ts) / (duration_ms / 60_000.0)


# ── Pressure-based gait metrics ──────────────────────────────────────────────

def heel_contact_times(df: pd.DataFrame, thresholds: dict) -> list[float]:
    """Measure duration (ms) that R_heel stays above lower threshold per stance.

    Each continuous period above threshold = one stance phase.
    """
    t = thresholds.get("R_heel")
    if not t:
        return []

    contacts: list[float] = []
    in_contact = False
    t_start = 0.0

    for row in df.to_dict("records"):
        ts  = float(row.get("device_ms") or 0)
        val = float(row.get("R_heel") or 0)
        if not in_contact:
            if val >= t["lower"]:
                in_contact = True
                t_start = ts
        else:
            if val < t["lower"]:
                contacts.append(ts - t_start)
                in_contact = False

    return contacts


# ── Acceleration metrics ─────────────────────────────────────────────────────

def swing_accel_peaks(df: pd.DataFrame, heel_lower: float) -> list[float]:
    """Peak net acceleration during each swing phase (heel off ground).

    net_accel = sqrt(ax² + ay² + az²)
    Swing = rows where the right IMU 'heel' column is below heel_lower.
    """
    required = {"ax", "ay", "az", "heel"}
    if not required.issubset(df.columns):
        return []

    df = df.copy()
    df["net_accel"] = np.sqrt(df["ax"] ** 2 + df["ay"] ** 2 + df["az"] ** 2)

    peaks: list[float] = []
    in_swing = False
    window: list[float] = []

    for row in df.to_dict("records"):
        heel_val = float(row.get("heel") or 0)
        acc      = float(row.get("net_accel") or 0)
        if heel_val < heel_lower:
            in_swing = True
            window.append(acc)
        else:
            if in_swing and window:
                peaks.append(max(window))
            in_swing = False
            window = []

    return peaks


# ── Tempo analysis ───────────────────────────────────────────────────────────

def analyse_tempo(tempo_path: Path, tempo_direction: str) -> dict:
    """Entrainment analysis for the tempo condition.

    Reads the Max/MSP-embedded bpm and ratio columns from the tempo file.
    """
    df, _ = parse_condition_file(tempo_path)
    if df.empty:
        return {"error": "empty tempo file"}
    if "bpm" not in df.columns or df["bpm"].isna().all():
        return {"error": "no bpm column in tempo file"}

    # Skip leading zeros — Max/MSP returns 0 until it locks onto cadence
    valid_bpm = df[df["bpm"] > 0]["bpm"]
    if valid_bpm.empty:
        return {"error": "no valid bpm values in tempo file"}
    base_BPM = float(valid_bpm.iloc[0])
    if base_BPM <= 0:
        return {"error": "invalid base_BPM"}

    # Smooth cadence: 30-sample rolling mean on the bpm column (~1 s at 30 Hz)
    smoothed = df["bpm"].rolling(window=30, min_periods=1, center=True).mean().values
    t_s = (df["device_ms"].values - df["device_ms"].values[0]) / 1000.0

    # Effective audio BPM at each sample
    ratio_arr = df["ratio"].values
    if tempo_direction == "speeding_up":
        audio_bpm = base_BPM * ratio_arr
    else:
        audio_bpm = base_BPM / ratio_arr

    # Starting ratio: mean raw BPM in first 10 s (drop NaN from pre-lock-on zeros)
    mask_onset = t_s <= 10.0
    onset_bpm_raw = df.loc[mask_onset, "bpm"].dropna()
    onset_cadence = float(onset_bpm_raw.mean()) if not onset_bpm_raw.empty else base_BPM
    starting_ratio = onset_cadence / base_BPM
    in_sync = SYNC_WINDOW[0] <= starting_ratio <= SYNC_WINDOW[1]

    # Pearson r over the full file
    valid = np.isfinite(smoothed) & np.isfinite(audio_bpm)
    if valid.sum() >= 10:
        r, p_val = stats.pearsonr(smoothed[valid], audio_bpm[valid])
    else:
        r, p_val = float("nan"), float("nan")

    entrained = bool(in_sync and np.isfinite(r) and r > ENTRAINMENT_R_THRESHOLD)

    return {
        "base_bpm":       round(base_BPM, 2),
        "starting_ratio": round(starting_ratio, 3),
        "in_sync_window": in_sync,
        "tempo_r":        round(float(r), 3) if np.isfinite(r) else None,
        "tempo_p":        round(float(p_val), 4) if np.isfinite(p_val) else None,
        "tempo_entrained": entrained,
    }


# ── Weight analysis ───────────────────────────────────────────────────────────

def analyse_weight(
    cal_df: pd.DataFrame,
    weight_path: Path,
    thresholds: dict,
    weight_direction: str,
    imu_cal_df: pd.DataFrame | None,
    imu_weight_df: pd.DataFrame | None,
) -> dict:
    """Gait depth analysis for the weight condition (Tajadura-Jiménez method).

    Compares heel contact time and peak net acceleration between calibration
    baseline and weight condition, expressed as z-scores.
    """
    df, w_thresh = parse_condition_file(weight_path)
    if df.empty:
        return {"error": "empty weight file"}

    # Prefer weight-file thresholds (calibrated to that session's pressure range)
    eff = w_thresh if w_thresh else thresholds

    # ── Calibration baseline ─────────────────────────────────────────────────
    cal_heel_raw = heel_contact_times(cal_df, eff)
    cal_heel = [c for c in cal_heel_raw if HEEL_CONTACT_MIN_MS <= c <= HEEL_CONTACT_MAX_MS]
    cal_steps = detect_steps(cal_df, eff)
    cal_dur   = float(cal_df["device_ms"].max() - cal_df["device_ms"].min())
    cal_cadence = cadence_bpm(cal_steps, cal_dur)

    cal_pct_filtered = 100 * (1 - len(cal_heel) / max(len(cal_heel_raw), 1))
    if len(cal_heel) < MIN_HEEL_CONTACTS:
        return {
            "error": (
                f"insufficient calibration heel contacts "
                f"({len(cal_heel)} valid after duration filter, "
                f"{len(cal_heel_raw)} raw) — thresholds likely miscalibrated"
            ),
            "cal_cadence": round(cal_cadence, 2),
        }
    cal_heel_mean = float(np.mean(cal_heel))
    cal_heel_std  = float(np.std(cal_heel)) if len(cal_heel) > 1 else 1.0
    if cal_heel_std == 0:
        cal_heel_std = 1.0

    # Calibration acceleration (from IMU if available)
    cal_accel_peaks: list[float] = []
    if imu_cal_df is not None:
        heel_lower_imu = float(imu_cal_df["heel"].quantile(0.3)) if "heel" in imu_cal_df.columns else 0.0
        cal_accel_peaks = swing_accel_peaks(imu_cal_df, heel_lower_imu)
    cal_accel_mean = float(np.mean(cal_accel_peaks)) if cal_accel_peaks else float("nan")
    cal_accel_std  = float(np.std(cal_accel_peaks))  if len(cal_accel_peaks) > 1 else 1.0
    if cal_accel_std == 0:
        cal_accel_std = 1.0

    # ── Weight condition ─────────────────────────────────────────────────────
    w_steps = detect_steps(df, eff)
    w_dur   = float(df["device_ms"].max() - df["device_ms"].min())
    w_cadence = cadence_bpm(w_steps, w_dur)

    w_heel_raw = heel_contact_times(df, eff)
    w_heel = [c for c in w_heel_raw if HEEL_CONTACT_MIN_MS <= c <= HEEL_CONTACT_MAX_MS]
    w_heel_mean = float(np.mean(w_heel)) if len(w_heel) >= MIN_HEEL_CONTACTS else float("nan")
    w_pct_filtered = 100 * (1 - len(w_heel) / max(len(w_heel_raw), 1))

    # Weight condition acceleration (from IMU if available)
    w_accel_peaks: list[float] = []
    if imu_weight_df is not None:
        heel_lower_imu = float(imu_weight_df["heel"].quantile(0.3)) if "heel" in imu_weight_df.columns else 0.0
        w_accel_peaks = swing_accel_peaks(imu_weight_df, heel_lower_imu)
    w_accel_mean = float(np.mean(w_accel_peaks)) if w_accel_peaks else float("nan")

    # ── Z-scores ─────────────────────────────────────────────────────────────
    if np.isfinite(cal_heel_mean) and np.isfinite(w_heel_mean) and np.isfinite(cal_heel_std):
        z_heel = (w_heel_mean - cal_heel_mean) / cal_heel_std
    else:
        z_heel = float("nan")

    if np.isfinite(cal_accel_mean) and np.isfinite(w_accel_mean):
        z_accel = (w_accel_mean - cal_accel_mean) / cal_accel_std
    else:
        z_accel = float("nan")

    # ── Success criteria ─────────────────────────────────────────────────────
    # decreasing (lighter): z_heel < 0 (shorter contact), z_accel > 0 (larger swing)
    # increasing (heavier): z_heel > 0 (longer contact),  z_accel < 0 (smaller swing)
    lighter = weight_direction == "decreasing"
    heel_success  = (z_heel < 0) == lighter   if np.isfinite(z_heel)  else None
    accel_success = (z_accel > 0) == lighter  if np.isfinite(z_accel) else None

    if heel_success is None and accel_success is None:
        weight_success = None
    elif heel_success is None:
        weight_success = accel_success
    elif accel_success is None:
        weight_success = heel_success
    else:
        weight_success = heel_success and accel_success

    def _r(v: float, dp: int = 2) -> float | None:
        return round(v, dp) if np.isfinite(v) else None

    heel_filter_flag = (
        f"heel_filter_loss:{cal_pct_filtered:.0f}%cal/{w_pct_filtered:.0f}%w"
        if cal_pct_filtered > 50 or w_pct_filtered > 50 else None
    )

    return {
        "cal_cadence":  round(cal_cadence, 2),
        "cal_heel_ms":  _r(cal_heel_mean, 1),
        "cal_accel":    _r(cal_accel_mean, 3),
        "w_cadence":    round(w_cadence, 2),
        "cond_heel_ms": _r(w_heel_mean, 1),
        "cond_accel":   _r(w_accel_mean, 3),
        "z_heel":       _r(z_heel, 3),
        "z_accel":      _r(z_accel, 3),
        "heel_success":   heel_success,
        "accel_success":  accel_success,
        "weight_success": weight_success,
        "heel_filter_flag": heel_filter_flag,
    }


# ── Database helpers ──────────────────────────────────────────────────────────

def get_sessions() -> list[dict]:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    rows = conn.execute("""
        SELECT session_id, participant_id, condition_order,
               tempo_direction, weight_direction,
               imu_raw_path, merged_path
        FROM sessions
        WHERE test_type_id = 3
          AND deleted_at IS NULL
          AND status = 'complete'
        ORDER BY session_id
    """).fetchall()

    flagged = {
        r["session_id"]
        for r in conn.execute("""
            SELECT DISTINCT session_id FROM session_tags
            WHERE lower(tag) LIKE '%don%t use%'
        """).fetchall()
    }
    conn.close()
    return [dict(r) | {"flagged": r["session_id"] in flagged} for r in rows]


# ── Main ─────────────────────────────────────────────────────────────────────

def main() -> None:
    sessions = get_sessions()

    results = []

    for s in sessions:
        pid        = s["participant_id"]
        sid        = s["session_id"]
        flagged    = s["flagged"]
        cond_order = s["condition_order"]      # 'A-first' or 'B-first'
        tempo_dir  = s["tempo_direction"]
        weight_dir = s["weight_direction"]

        # ── Condition mapping ─────────────────────────────────────────────────
        if cond_order == "A-first":
            weight_stage = "condition_2"
        else:
            weight_stage = "condition_1"

        # ── File locations ────────────────────────────────────────────────────
        raw_dir = DATA_ROOT / pid

        cal_file    = raw_dir / f"{pid}_pressure_calibration.csv"
        tempo_file  = raw_dir / f"{pid}_pressure_tempo.csv"
        # Weight file: prefer _weight.csv, fall back to _pondering.csv
        weight_file = raw_dir / f"{pid}_pressure_weight.csv"
        if not weight_file.exists():
            weight_file = raw_dir / f"{pid}_pressure_pondering.csv"

        imu_file    = Path(s["imu_raw_path"]) if s["imu_raw_path"] else None
        merged_file = Path(s["merged_path"])  if s["merged_path"]  else None

        flags: list[str] = []
        if flagged:
            flags.append("DO_NOT_USE")

        row: dict = {
            "session_id":      sid,
            "participant_id":  pid,
            "condition_order": cond_order,
            "tempo_direction": tempo_dir,
            "weight_direction": weight_dir,
            "flagged":         flagged,
        }

        # ── Skip flagged sessions from metrics (still include row) ────────────
        if flagged:
            row["flags"] = "; ".join(flags)
            results.append(row)
            continue

        # ── Calibration data ──────────────────────────────────────────────────
        cal_df     = pd.DataFrame()
        thresholds = {}
        if cal_file.exists():
            try:
                cal_df = parse_calibration_file(cal_file)
            except Exception as e:
                flags.append(f"cal_parse_error:{e}")

        # Thresholds come from the tempo file (most reliable source)
        if tempo_file.exists():
            try:
                _, thresholds = parse_condition_file(tempo_file)
            except Exception as e:
                flags.append(f"thresh_error:{e}")
        if not thresholds and weight_file.exists():
            try:
                _, thresholds = parse_condition_file(weight_file)
            except Exception:
                pass

        # ── IMU from merged CSV (for acceleration metrics) ────────────────────
        imu_cal_df    = None
        imu_weight_df = None

        if merged_file and merged_file.exists():
            try:
                merged = pd.read_csv(merged_file, low_memory=False)
                if "stage" in merged.columns and merged["stage"].notna().any():
                    if "calibration" in merged["stage"].values:
                        imu_cal_df = merged[merged["stage"] == "calibration"].copy()
                    if weight_stage in merged["stage"].values:
                        imu_weight_df = merged[merged["stage"] == weight_stage].copy()
                    else:
                        flags.append("no_weight_stage_in_merged")
                else:
                    flags.append("merged_no_stage_annotations")
            except Exception as e:
                flags.append(f"merged_load_error:{e}")

        # ── Tempo analysis ────────────────────────────────────────────────────
        tempo_result: dict = {}
        if tempo_file.exists():
            try:
                tempo_result = analyse_tempo(tempo_file, tempo_dir)
                if "error" in tempo_result:
                    flags.append(f"tempo_error:{tempo_result['error']}")
            except Exception as e:
                flags.append(f"tempo_exception:{e}")
        else:
            flags.append("missing_tempo_file")

        # ── Weight analysis ───────────────────────────────────────────────────
        weight_result: dict = {}
        if weight_file.exists() and not cal_df.empty and thresholds:
            try:
                weight_result = analyse_weight(
                    cal_df, weight_file, thresholds, weight_dir,
                    imu_cal_df, imu_weight_df
                )
                if "error" in weight_result:
                    flags.append(f"weight_error:{weight_result['error']}")
                if weight_result.get("heel_filter_flag"):
                    flags.append(weight_result["heel_filter_flag"])
            except Exception as e:
                flags.append(f"weight_exception:{e}")
        else:
            if not weight_file.exists():
                flags.append("missing_weight_file")
            if cal_df.empty:
                flags.append("missing_cal_data")
            if not thresholds:
                flags.append("no_thresholds")

        row.update(tempo_result)
        row.update(weight_result)
        row["flags"] = "; ".join(flags) if flags else ""
        results.append(row)

    # ── Output ────────────────────────────────────────────────────────────────
    results_df = pd.DataFrame(results)

    # Column order
    col_order = [
        "session_id", "participant_id", "condition_order",
        "tempo_direction", "weight_direction",
        "base_bpm", "starting_ratio", "in_sync_window",
        "tempo_r", "tempo_p", "tempo_entrained",
        "cal_cadence", "cal_heel_ms", "cal_accel",
        "w_cadence", "cond_heel_ms", "cond_accel",
        "z_heel", "z_accel",
        "heel_success", "accel_success", "weight_success",
        "flagged", "flags",
    ]
    for col in col_order:
        if col not in results_df.columns:
            results_df[col] = None
    results_df = results_df[col_order]

    # Save CSV
    out_path = ROOT / "analysis" / "test5_results.csv"
    results_df.to_csv(out_path, index=False)
    print(f"\nResults saved to {out_path}")

    # ── Print table ───────────────────────────────────────────────────────────
    print("\n" + "=" * 110)
    print(f"{'SID':>4}  {'PID':>4}  {'Order':>8}  {'Tempo':>12}  {'Weight':>10}  "
          f"{'baseB':>6}  {'sRatio':>7}  {'sync?':>5}  {'r':>6}  "
          f"{'entrd?':>6}  {'zHeel':>7}  {'zAcc':>6}  {'wSuc?':>5}  "
          f"{'Flag?':>5}")
    print("-" * 110)

    active = results_df[~results_df["flagged"].fillna(False).astype(bool)]
    for _, r in results_df.iterrows():
        flag_marker = " *** " if r.get("flagged") else ""
        print(
            f"{int(r['session_id']):>4}  "
            f"{str(r['participant_id']):>4}  "
            f"{str(r['condition_order']):>8}  "
            f"{str(r['tempo_direction']):>12}  "
            f"{str(r['weight_direction']):>10}  "
            f"{_fmt(r.get('base_bpm'), 5):>6}  "
            f"{_fmt(r.get('starting_ratio'), 3):>7}  "
            f"{_bool(r.get('in_sync_window')):>5}  "
            f"{_fmt(r.get('tempo_r'), 3):>6}  "
            f"{_bool(r.get('tempo_entrained')):>6}  "
            f"{_fmt(r.get('z_heel'), 3):>7}  "
            f"{_fmt(r.get('z_accel'), 3):>6}  "
            f"{_bool(r.get('weight_success')):>5}  "
            f"{flag_marker}"
        )

    # ── Summary statistics (exclude flagged) ──────────────────────────────────
    print("\n" + "=" * 110)
    n_total   = len(results_df)
    n_active  = len(active)
    n_flagged = n_total - n_active

    print(f"\nSessions: {n_total} total, {n_active} analysed, {n_flagged} excluded (DO_NOT_USE tag)")

    # Tempo
    t_df = active.dropna(subset=["tempo_r"])
    if len(t_df) > 0:
        n_in_sync  = int(t_df["in_sync_window"].sum())
        n_entrained = int(t_df["tempo_entrained"].sum())
        mean_r = t_df["tempo_r"].mean()
        std_r  = t_df["tempo_r"].std()
        print(f"\nTempo ({len(t_df)} sessions with r computed):")
        print(f"  In sync window (0.85–1.15):  {n_in_sync}/{len(t_df)}  ({100*n_in_sync/len(t_df):.0f}%)")
        print(f"  Entrained (sync + r > 0.6):  {n_entrained}/{len(t_df)}  ({100*n_entrained/len(t_df):.0f}%)")
        print(f"  Pearson r:  mean={mean_r:.3f}  SD={std_r:.3f}")
        speeding = t_df[t_df["tempo_direction"] == "speeding_up"]
        slowing  = t_df[t_df["tempo_direction"] == "slowing_down"]
        if len(speeding):
            print(f"  Speeding-up:   n={len(speeding)},  entrained={int(speeding['tempo_entrained'].sum())},  r̄={speeding['tempo_r'].mean():.3f}")
        if len(slowing):
            print(f"  Slowing-down:  n={len(slowing)},   entrained={int(slowing['tempo_entrained'].sum())},  r̄={slowing['tempo_r'].mean():.3f}")

    # Weight
    w_df = active.dropna(subset=["z_heel"])
    if len(w_df) > 0:
        n_heel  = int(w_df["heel_success"].sum())
        n_accel = int(w_df["accel_success"].dropna().sum()) if w_df["accel_success"].notna().any() else 0
        n_weight = int(w_df["weight_success"].dropna().sum()) if w_df["weight_success"].notna().any() else 0
        n_w_total = len(w_df)
        n_accel_total = int(w_df["accel_success"].notna().sum())
        print(f"\nWeight ({n_w_total} sessions with heel data):")
        print(f"  Heel success:   {n_heel}/{n_w_total}  ({100*n_heel/n_w_total:.0f}%)")
        if n_accel_total:
            print(f"  Accel success:  {n_accel}/{n_accel_total}  ({100*n_accel/n_accel_total:.0f}%)")
        else:
            print(f"  Accel success:  no acceleration data available")
        if w_df["weight_success"].notna().any():
            print(f"  Weight success: {n_weight}/{n_w_total}  ({100*n_weight/n_w_total:.0f}%)")
        print(f"  z_heel:  mean={w_df['z_heel'].mean():.3f}  SD={w_df['z_heel'].std():.3f}")
        dec = w_df[w_df["weight_direction"] == "decreasing"]
        inc = w_df[w_df["weight_direction"] == "increasing"]
        if len(dec):
            print(f"  Decreasing (lighter): n={len(dec)},  heel_ok={int(dec['heel_success'].sum())},  z_heel̄={dec['z_heel'].mean():.3f}")
        if len(inc):
            print(f"  Increasing (heavier): n={len(inc)},  heel_ok={int(inc['heel_success'].sum())},  z_heel̄={inc['z_heel'].mean():.3f}")

    n_w_skipped = n_active - n_w_total if len(w_df) > 0 else n_active
    print(f"\nNote: {n_w_skipped} sessions excluded from weight analysis (insufficient heel contacts after "
          f"duration filter {HEEL_CONTACT_MIN_MS:.0f}–{HEEL_CONTACT_MAX_MS:.0f} ms — likely threshold "
          f"calibration issues where heel never fully clears lower pressure threshold between steps)")
    print()


# ── Formatting helpers ────────────────────────────────────────────────────────

def _fmt(val, dp: int = 3) -> str:
    if val is None or (isinstance(val, float) and np.isnan(val)):
        return "—"
    try:
        return f"{float(val):.{dp}f}"
    except (TypeError, ValueError):
        return str(val)


def _bool(val) -> str:
    if val is None or (isinstance(val, float) and np.isnan(val)):
        return "—"
    return "Y" if val else "N"


if __name__ == "__main__":
    main()
