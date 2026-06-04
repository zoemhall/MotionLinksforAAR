"""Align Test 5 IMU data to pressure timeline and produce per-participant combined CSVs.

Clock relationship
-----------------
Pressure condition files (pondering/tempo/weight) use Max/MSP's internal clock
(milliseconds since Max was opened for the session).

IMU files (imu_L.csv, imu_R.csv) use the insole's firmware uptime clock
(milliseconds since the insole was last powered on / reset). These clocks are
completely independent and may differ by millions of ms if the insole was not
cleared between sessions.

Calibration files use a SEPARATE relative clock (0 → ~30000 ms within that
recording), unrelated to either of the above.

Alignment approach
------------------
At the moment the researcher dumps the IMU firmware, both clocks represent
"right now." So:

    O = imu_max_device_ms - pressure_last_condition_max_device_ms

After applying O:

    imu_device_ms_aligned = imu_device_ms - O

The aligned values sit on the same axis as the pressure condition-file device_ms.

Session window (pressure clock)
    start : first row of the pondering file  (audio_only stage)
    end   : last row of the last condition file

Calibration data uses relative time and is placed at
    cal_abs_device_ms = pondering_start_device_ms
                        - cal_to_pondering_wall_ms
                        + cal_relative_device_ms
so that all data forms a continuous session_ms axis.

Flags
-----
IMU_{side}_NOT_CLEARED       large offset (> 60 s) but session data present
IMU_{side}_DATA_LOST         no overlap between aligned IMU and pressure session
IMU_{side}_PARTIAL_LOSS_START first ~N ms of session missing from IMU
IMU_{side}_PARTIAL_LOSS_END  last ~N ms of session missing from IMU
IMU_L_R_CLOCK_SKEW           L and R offsets differ by > 60 s

Run: python analysis/align_test5_imu_pressure.py
"""
from __future__ import annotations

import sqlite3
import sys
from datetime import datetime
from pathlib import Path

import numpy as np
import pandas as pd

ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(ROOT))

from analysis.test5_gait_analysis import (
    parse_calibration_file,
    parse_condition_file,
)

DB_PATH = ROOT / "data" / "gait_study.db"
OUT_DIR  = ROOT / "analysis" / "test5_aligned"

# Flag thresholds
NOT_CLEARED_THRESHOLD_MS   = 60_000   # > 60 s offset → insole not cleared
PARTIAL_LOSS_THRESHOLD_MS  = 5_000    # > 5 s of missing data at start/end
CLOCK_SKEW_THRESHOLD_MS    = 60_000   # L vs R offset > 60 s

# Participants whose test was split across two DB sessions (first-half, second-half).
# The two sessions are merged into one combined CSV using the calibration/audio_only
# timing from the first session and condition timing from the second session.
# Value: (first_half_session_id, second_half_session_id)
SPLIT_SESSIONS: dict[str, tuple[int, int]] = {
    "31": (69, 70),
}


# ── DB helpers ────────────────────────────────────────────────────────────────

def load_sessions() -> pd.DataFrame:
    con = sqlite3.connect(DB_PATH)
    df = pd.read_sql("""
        SELECT session_id, participant_id, condition_order, test_type_id,
               tempo_direction, weight_direction, session_date
        FROM sessions
        WHERE test_type_id IN (3, 4, 5)
        ORDER BY participant_id, session_id
    """, con)
    con.close()
    return df


def load_stage_events(session_id: int) -> pd.DataFrame:
    con = sqlite3.connect(DB_PATH)
    df = pd.read_sql("""
        SELECT stage_id, started_at
        FROM session_stage_events
        WHERE session_id = ?
        ORDER BY started_at
    """, con, params=(session_id,))
    con.close()
    df["started_at"] = pd.to_datetime(df["started_at"])
    return df


# ── Data directory lookup ─────────────────────────────────────────────────────

def participant_dir(pid: str) -> Path | None:
    for test in ("Test 5", "Test 4"):
        p = ROOT / "data" / test / "Raw data" / pid
        if p.exists():
            return p
    return None


# ── Frozen-clock repair ───────────────────────────────────────────────────────

def repair_frozen_clock(
    df: pd.DataFrame,
    interval_ms: float = 30.77,
) -> tuple[pd.DataFrame, bool]:
    """Detect and repair a frozen Max/MSP device_ms clock.

    When the clock freezes at the very first sample, every row in the file
    carries the same device_ms value (the moment recording started). We
    reconstruct elapsed time from the row index and the known sampling interval.

    Returns (repaired_df, was_frozen).
    """
    if df.empty or "device_ms" not in df.columns:
        return df, False

    if df["device_ms"].nunique() > max(5, int(len(df) * 0.01)):
        return df, False  # not frozen

    frozen_start = float(df["device_ms"].iloc[0])
    df = df.copy()
    df["device_ms"] = frozen_start + np.arange(len(df)) * interval_ms
    return df, True


def calibration_interval_ms(cal_df: pd.DataFrame) -> float:
    """Derive per-row sampling interval from calibration file (relative clock)."""
    if len(cal_df) < 2:
        return 30.77
    span = float(cal_df["device_ms"].max() - cal_df["device_ms"].min())
    return span / (len(cal_df) - 1)


# ── IMU sanitation ────────────────────────────────────────────────────────────

UINT32_MAX = 4_294_967_295  # 2^32 - 1


def clean_imu(imu_df: pd.DataFrame) -> pd.DataFrame:
    """Remove corrupt / overflow device_ms rows.

    The XIAO firmware uses a 32-bit millisecond counter. Values near or above
    2^32 are wraparound artefacts. Values that form isolated spikes far above
    the main cluster are residual data from much earlier sessions still sitting
    in the circular buffer.

    Strategy:
      1. Drop obvious 32-bit overflows (device_ms > 2^32 - 100 000).
      2. Drop values more than 5 × session-span above the 95th percentile
         (removes isolated old-session outliers without touching normal data).
    """
    df = imu_df[imu_df["device_ms"] < UINT32_MAX - 100_000].copy()
    if df.empty:
        return df
    p95 = df["device_ms"].quantile(0.95)
    p05 = df["device_ms"].quantile(0.05)
    span = max(p95 - p05, 1.0)
    df = df[df["device_ms"] <= p95 + 5 * span]
    return df.sort_values("device_ms").reset_index(drop=True)


# ── Clock offset ─────────────────────────────────────────────────────────────

def compute_imu_offset(imu_df: pd.DataFrame, pressure_last_max: float) -> float:
    """O = imu_session_end - pressure_last_max.

    The circular buffer's last row (highest device_ms after cleaning) represents
    the most recent firmware sample — which should be close to when the session
    data ended and the researcher dumped the firmware.

    Subtract O from imu device_ms to align to the pressure (Max) clock.
    """
    return float(imu_df["device_ms"].max()) - pressure_last_max


# ── Coverage check ────────────────────────────────────────────────────────────

def coverage_flags(
    imu_df: pd.DataFrame,
    offset: float,
    pressure_start: float,
    pressure_end: float,
    side: str,
) -> list[str]:
    flags = []
    aligned_min = float(imu_df["device_ms"].min()) - offset
    aligned_max = float(imu_df["device_ms"].max()) - offset

    if aligned_max < pressure_start or aligned_min > pressure_end:
        flags.append(f"IMU_{side}_DATA_LOST")
        return flags

    if abs(offset) > NOT_CLEARED_THRESHOLD_MS:
        flags.append(f"IMU_{side}_NOT_CLEARED")

    if aligned_min > pressure_start + PARTIAL_LOSS_THRESHOLD_MS:
        loss_ms = int(aligned_min - pressure_start)
        flags.append(f"IMU_{side}_PARTIAL_LOSS_START({loss_ms}ms)")

    if aligned_max < pressure_end - PARTIAL_LOSS_THRESHOLD_MS:
        loss_ms = int(pressure_end - aligned_max)
        flags.append(f"IMU_{side}_PARTIAL_LOSS_END({loss_ms}ms)")

    return flags


# ── Cross-correlation offset refinement ───────────────────────────────────────

def refine_offset_xcorr(
    imu_df: pd.DataFrame,
    pressure_df: pd.DataFrame,
    initial_offset: float,
    imu_col: str = "heel",
    pres_col: str = "R_heel",
    resample_hz: float = 10.0,
    search_window_ms: float = 30_000.0,
) -> float:
    """Refine offset using cross-correlation of heel signals.

    Searches ±search_window_ms around initial_offset.
    Returns the refined offset (ms). Falls back to initial_offset on failure.
    """
    try:
        # Build aligned candidate IMU series
        imu_aligned = imu_df.copy()
        imu_aligned["device_ms_aligned"] = imu_aligned["device_ms"] - initial_offset

        # Restrict to overlapping region
        pres_start = float(pressure_df["device_ms"].min())
        pres_end   = float(pressure_df["device_ms"].max())
        imu_win = imu_aligned[
            (imu_aligned["device_ms_aligned"] >= pres_start) &
            (imu_aligned["device_ms_aligned"] <= pres_end)
        ].copy()
        if len(imu_win) < 50 or imu_col not in imu_win.columns:
            return initial_offset

        step_ms = 1000.0 / resample_hz

        # Build common time axis
        t_start = max(pres_start, imu_win["device_ms_aligned"].min())
        t_end   = min(pres_end,   imu_win["device_ms_aligned"].max())
        t_common = np.arange(t_start, t_end, step_ms)
        if len(t_common) < 50:
            return initial_offset

        # Resample pressure
        pres_interp = np.interp(
            t_common,
            pressure_df["device_ms"].values,
            pressure_df[pres_col].values,
        )

        # Resample IMU
        imu_interp = np.interp(
            t_common,
            imu_win["device_ms_aligned"].values,
            imu_win[imu_col].values,
        )

        # Normalise
        def norm(x):
            s = x.std()
            return (x - x.mean()) / s if s > 1e-6 else x - x.mean()

        pres_n = norm(pres_interp)
        imu_n  = norm(imu_interp)

        # Cross-correlate within ±search_window samples
        max_lag_samples = int(search_window_ms / step_ms)
        xcorr = np.correlate(pres_n, imu_n, mode="full")
        mid = len(xcorr) // 2
        lo  = max(0, mid - max_lag_samples)
        hi  = min(len(xcorr), mid + max_lag_samples + 1)
        best_idx  = lo + int(np.argmax(xcorr[lo:hi]))
        lag_samples = best_idx - mid
        lag_ms = lag_samples * step_ms

        # lag_ms is how much to shift IMU relative to pressure.
        # A positive lag means IMU leads → subtract lag from aligned timestamps
        # (i.e., increase offset by lag_ms)
        refined = initial_offset + lag_ms
        return refined

    except Exception:  # noqa: BLE001
        return initial_offset


# ── Session-relative time ─────────────────────────────────────────────────────

def compute_session_ms(
    device_ms: pd.Series,
    pondering_start_device_ms: float,
    cal_to_pon_ms: float,
) -> pd.Series:
    """Convert pressure device_ms to session_ms (ms since calibration started).

    session_ms = 0 at calibration start.
    Pondering starts at session_ms = cal_to_pon_ms.
    """
    return (device_ms - pondering_start_device_ms) + cal_to_pon_ms


# ── Per-participant processing ────────────────────────────────────────────────

def process_participant(
    session_row: pd.Series,
    all_stage_events: pd.DataFrame,
) -> tuple[pd.DataFrame | None, dict]:
    pid     = session_row["participant_id"]
    sid     = int(session_row["session_id"])
    c_order = session_row["condition_order"]
    report  = {
        "participant_id": pid,
        "session_id": sid,
        "condition_order": c_order,
        "flags": [],
        "imu_l_offset_ms": None,
        "imu_r_offset_ms": None,
        "imu_l_coverage_pct": None,
        "imu_r_coverage_pct": None,
        "notes": "",
    }

    base = participant_dir(pid)
    if base is None:
        report["flags"].append("DATA_DIR_NOT_FOUND")
        return None, report

    # ── Stage event wall-clock times ──────────────────────────────────────────
    # For split sessions, merge events from both halves: calibration/audio_only
    # come from the first-half session; conditions come from the second-half.
    split = SPLIT_SESSIONS.get(pid)
    if split is not None:
        first_sid, second_sid = split
        evts_first  = all_stage_events[all_stage_events["session_id"] == first_sid].copy()
        evts_second = all_stage_events[all_stage_events["session_id"] == second_sid].copy()
        # Use first-half for cal/pon, second-half for conditions/end
        evts_merged = pd.concat([
            evts_first[evts_first["stage_id"].isin(["session_start", "calibration", "audio_only"])],
            evts_second[~evts_second["stage_id"].isin(["session_start", "calibration", "audio_only"])],
        ])
        evts_merged = evts_merged.sort_values("started_at").drop_duplicates("stage_id", keep="first")
        evts = evts_merged.set_index("stage_id")["started_at"]
        report["flags"].append(f"SPLIT_SESSIONS_MERGED({first_sid}+{second_sid})")
    else:
        evts = all_stage_events[all_stage_events["session_id"] == sid].copy()
        evts = evts.sort_values("started_at").drop_duplicates("stage_id", keep="first")
        evts = evts.set_index("stage_id")["started_at"]

    cal_start_wc  = evts.get("calibration",  evts.get("session_start"))
    pon_start_wc  = evts.get("audio_only")
    sess_end_wc   = evts.get("session_end")
    cond1_start_wc = evts.get("condition_1")
    cond2_start_wc = evts.get("condition_2")

    if cal_start_wc is None or pon_start_wc is None or sess_end_wc is None:
        report["flags"].append("INCOMPLETE_STAGE_EVENTS")
        report["notes"] = "Missing calibration/audio_only/session_end stage events"

    cal_to_pon_ms = (
        float((pon_start_wc - cal_start_wc).total_seconds()) * 1000
        if (cal_start_wc is not None and pon_start_wc is not None)
        else 83_000.0  # fallback: ~typical 83 s
    )

    # ── Load pressure files ───────────────────────────────────────────────────
    cal_path  = base / f"{pid}_pressure_calibration.csv"
    pon_path  = base / f"{pid}_pressure_pondering.csv"
    tempo_path  = base / f"{pid}_pressure_tempo.csv"
    weight_path = base / f"{pid}_pressure_weight.csv"

    for p in (cal_path, pon_path):
        if not p.exists():
            report["flags"].append(f"MISSING_{p.stem.upper()}")

    cal_df = parse_calibration_file(cal_path) if cal_path.exists() else pd.DataFrame()
    pon_df, pon_thresh = (
        parse_condition_file(pon_path) if pon_path.exists() else (pd.DataFrame(), {})
    )
    tempo_df, _  = (
        parse_condition_file(tempo_path)  if tempo_path.exists()  else (pd.DataFrame(), {})
    )
    weight_df, _ = (
        parse_condition_file(weight_path) if weight_path.exists() else (pd.DataFrame(), {})
    )

    # Repair frozen-clock timestamps (Max/MSP clock froze at first sample)
    row_interval_ms = calibration_interval_ms(cal_df) if not cal_df.empty else 30.77
    for name, df_ref in [("pondering", pon_df), ("tempo", tempo_df), ("weight", weight_df)]:
        repaired, was_frozen = repair_frozen_clock(df_ref, row_interval_ms)
        if was_frozen:
            report["flags"].append(f"FROZEN_CLOCK_REPAIRED_{name.upper()}")
            if name == "pondering":
                pon_df = repaired
            elif name == "tempo":
                tempo_df = repaired
            else:
                weight_df = repaired

    # Identify condition_1 / condition_2 based on condition_order
    # A-first: tempo = condition_1, weight = condition_2
    # B-first: weight = condition_1, tempo = condition_2
    # When condition_order is unknown, infer from which file starts first
    effective_order = c_order
    if effective_order not in ("A-first", "B-first") and not tempo_df.empty and not weight_df.empty:
        effective_order = "A-first" if tempo_df["device_ms"].min() < weight_df["device_ms"].min() else "B-first"
        report["flags"].append(f"CONDITION_ORDER_INFERRED({effective_order})")

    if effective_order == "A-first":
        cond1_df, cond1_name = tempo_df,  "tempo"
        cond2_df, cond2_name = weight_df, "weight"
    else:
        cond1_df, cond1_name = weight_df, "weight"
        cond2_df, cond2_name = tempo_df,  "tempo"

    # Sequential reconstruction: when pondering and conditions are frozen at the
    # same device_ms value (typically 0), the standard trim would delete all
    # pondering rows. Lay out phases using wall-clock stage event gaps when
    # available (preserves real inter-phase gaps); otherwise chain end-to-end.
    if (not pon_df.empty and not cond1_df.empty
            and abs(pon_df["device_ms"].iloc[0] - cond1_df["device_ms"].iloc[0]) < 1.0):
        base_ms = max(1.0, pon_df["device_ms"].iloc[0])
        pon_df = pon_df.copy()
        pon_df["device_ms"] = base_ms + np.arange(len(pon_df)) * row_interval_ms

        # Use wall-clock gap from stage events if we have pon_start and cond1_start
        if pon_start_wc is not None and cond1_start_wc is not None:
            pon_to_c1_ms = float((cond1_start_wc - pon_start_wc).total_seconds()) * 1000
            c1_start = base_ms + pon_to_c1_ms
        else:
            c1_start = pon_df["device_ms"].iloc[-1] + row_interval_ms
        cond1_df = cond1_df.copy()
        cond1_df["device_ms"] = c1_start + np.arange(len(cond1_df)) * row_interval_ms

        if not cond2_df.empty:
            if pon_start_wc is not None and cond2_start_wc is not None:
                pon_to_c2_ms = float((cond2_start_wc - pon_start_wc).total_seconds()) * 1000
                c2_start = base_ms + pon_to_c2_ms
            else:
                c2_start = cond1_df["device_ms"].iloc[-1] + row_interval_ms
            cond2_df = cond2_df.copy()
            cond2_df["device_ms"] = c2_start + np.arange(len(cond2_df)) * row_interval_ms

        report["flags"].append("FROZEN_CLOCK_SEQUENTIAL_RECONSTRUCTION")

    # Determine pressure session reference: pondering start and last condition end
    if pon_df.empty:
        report["flags"].append("PONDERING_FILE_EMPTY")
        return None, report

    pondering_start_device_ms = float(pon_df["device_ms"].min())

    all_cond_maxes = [
        df["device_ms"].max()
        for df in (pon_df, cond1_df, cond2_df)
        if not df.empty
    ]
    if not all_cond_maxes:
        report["flags"].append("NO_CONDITION_DATA")
        return None, report
    pressure_last_max = float(max(all_cond_maxes))
    pressure_session_end = pressure_last_max

    # Trim pondering to audio_only stage only (before the first condition starts)
    first_cond_starts = [df["device_ms"].min() for df in (cond1_df, cond2_df) if not df.empty]
    if first_cond_starts:
        first_cond_start_ms = float(min(first_cond_starts))
        pon_df = pon_df[pon_df["device_ms"] < first_cond_start_ms].copy()

    # Trim cond1 to rows before cond2 starts (handles reconstructed-clock overlaps)
    if not cond1_df.empty and not cond2_df.empty:
        cond2_start = float(cond2_df["device_ms"].min())
        cond1_df = cond1_df[cond1_df["device_ms"] < cond2_start].copy()

    # Add condition / stage labels
    cal_df  = cal_df.copy();  cal_df["condition"]  = "calibration";  cal_df["stage"] = "calibration"
    pon_df  = pon_df.copy();  pon_df["condition"]  = "pondering";    pon_df["stage"] = "audio_only"
    if not cond1_df.empty:
        cond1_df = cond1_df.copy(); cond1_df["condition"] = cond1_name; cond1_df["stage"] = "condition_1"
    if not cond2_df.empty:
        cond2_df = cond2_df.copy(); cond2_df["condition"] = cond2_name; cond2_df["stage"] = "condition_2"

    # ── Build calibration with absolute device_ms ────────────────────────────
    # cal_relative_device_ms + pondering_start - cal_to_pon_ms
    if not cal_df.empty:
        cal_df["device_ms"] = (
            cal_df["device_ms"]
            + pondering_start_device_ms
            - cal_to_pon_ms
        )

    # ── Concatenate pressure timeline ─────────────────────────────────────────
    frames = [df for df in (cal_df, pon_df, cond1_df, cond2_df) if not df.empty]
    pressure = (
        pd.concat(frames, ignore_index=True)
        .sort_values("device_ms")
        .reset_index(drop=True)
    )
    # session_ms = ms since calibration started
    pressure["session_ms"] = compute_session_ms(
        pressure["device_ms"], pondering_start_device_ms, cal_to_pon_ms
    )

    # ── Load IMU files ────────────────────────────────────────────────────────
    imu_cols_rename = {
        "toe":  "imu_toe",
        "heel": "imu_heel",
        "phase": "imu_phase",
    }
    imu_parts: dict[str, pd.DataFrame] = {}

    for side in ("L", "R"):
        imu_path = base / f"{pid}_imu_{side}.csv"
        if not imu_path.exists():
            report["flags"].append(f"IMU_{side}_FILE_MISSING")
            continue

        imu = pd.read_csv(imu_path)
        if imu.empty or "device_ms" not in imu.columns:
            report["flags"].append(f"IMU_{side}_EMPTY_OR_BAD")
            continue

        # Remove corrupt / overflow rows before computing anything
        n_raw = len(imu)
        imu = clean_imu(imu)
        n_removed = n_raw - len(imu)
        if n_removed > 0:
            report["flags"].append(f"IMU_{side}_CORRUPT_ROWS_REMOVED({n_removed})")
        if imu.empty:
            report["flags"].append(f"IMU_{side}_ALL_CORRUPT")
            continue

        # Compute alignment offset
        offset = compute_imu_offset(imu, pressure_last_max)

        # Attempt cross-correlation refinement using pondering + R/L heel signal
        pres_ref = pon_df if not pon_df.empty else pressure[pressure["stage"] == "condition_1"]
        pres_col = "R_heel" if side == "R" else "L_heel"
        if not pres_ref.empty and pres_col in pres_ref.columns:
            offset = refine_offset_xcorr(
                imu, pres_ref, offset, imu_col="heel", pres_col=pres_col
            )

        flags = coverage_flags(
            imu, offset, pondering_start_device_ms, pressure_session_end, side
        )
        report["flags"].extend(flags)
        report[f"imu_{side.lower()}_offset_ms"] = round(offset, 1)

        # Compute coverage %
        al_min = imu["device_ms"].min() - offset
        al_max = imu["device_ms"].max() - offset
        sess_span = pressure_session_end - pondering_start_device_ms
        if sess_span > 0:
            covered = min(al_max, pressure_session_end) - max(al_min, pondering_start_device_ms)
            pct = max(0.0, covered / sess_span * 100)
            report[f"imu_{side.lower()}_coverage_pct"] = round(pct, 1)

        # Only proceed with alignment if there's actual session overlap
        if f"IMU_{side}_DATA_LOST" not in flags:
            imu = imu.copy()
            imu["device_ms"] = imu["device_ms"] - offset  # align to pressure clock

            # Trim to session window (include some pre-session calibration margin)
            margin_ms = cal_to_pon_ms + 5000  # a bit before calibration
            imu = imu[
                (imu["device_ms"] >= pondering_start_device_ms - margin_ms) &
                (imu["device_ms"] <= pressure_session_end + 5000)
            ].copy()

            # Rename ambiguous columns
            imu = imu.rename(columns={
                c: f"{side.lower()}_{imu_cols_rename.get(c, c)}"
                for c in ("toe", "heel", "phase")
                if c in imu.columns
            })
            # Prefix all IMU sensor columns with side
            sensor_cols = [c for c in ("ax","ay","az","gx","gy","gz") if c in imu.columns]
            imu = imu.rename(columns={c: f"{side.lower()}_{c}" for c in sensor_cols})
            imu = imu.drop(columns=["side","stage"], errors="ignore")
            imu_parts[side] = imu

    # ── Merge pressure + IMU ──────────────────────────────────────────────────
    combined = pressure.sort_values("device_ms").reset_index(drop=True)

    for side, imu in imu_parts.items():
        imu_sorted = imu.sort_values("device_ms").reset_index(drop=True)
        combined = pd.merge_asof(
            combined,
            imu_sorted,
            on="device_ms",
            direction="nearest",
            tolerance=200.0,  # 200 ms tolerance
            suffixes=("", f"_{side.lower()}_dup"),
        )
        # Drop any duplicate columns introduced by merge
        dup_cols = [c for c in combined.columns if c.endswith(f"_{side.lower()}_dup")]
        combined = combined.drop(columns=dup_cols, errors="ignore")

    # ── Consistency check: IMU heel vs pressure heel correlation ─────────────
    notes = []
    for side_lc, pres_col in (("l", "L_heel"), ("r", "R_heel")):
        imu_col = f"{side_lc}_imu_heel"
        if imu_col in combined.columns and pres_col in combined.columns:
            mask = combined[imu_col].notna() & combined[pres_col].notna()
            if mask.sum() > 30:
                r = float(np.corrcoef(
                    combined.loc[mask, imu_col],
                    combined.loc[mask, pres_col],
                )[0, 1])
                notes.append(f"{side_lc.upper()} heel corr={r:.3f}")
                if r < 0.2:
                    report["flags"].append(f"IMU_{side_lc.upper()}_LOW_HEEL_CORRELATION")

    # Clock skew check
    o_L = report.get("imu_l_offset_ms")
    o_R = report.get("imu_r_offset_ms")
    if o_L is not None and o_R is not None:
        if abs(o_L - o_R) > CLOCK_SKEW_THRESHOLD_MS:
            report["flags"].append(f"IMU_L_R_CLOCK_SKEW({abs(o_L-o_R):.0f}ms)")

    report["notes"] = "; ".join(notes)
    return combined, report


# ── Main ─────────────────────────────────────────────────────────────────────

def main() -> None:
    OUT_DIR.mkdir(exist_ok=True)

    sessions = load_sessions()

    # For participants with multiple sessions, keep the most complete one
    # (latest session_id that has both conditions)
    con = sqlite3.connect(DB_PATH)
    all_stage_events = pd.read_sql("""
        SELECT sse.session_id, sse.stage_id, sse.started_at
        FROM session_stage_events sse
        JOIN sessions s ON s.session_id = sse.session_id
        WHERE s.test_type_id IN (3, 4, 5)
    """, con)
    con.close()
    all_stage_events["started_at"] = pd.to_datetime(all_stage_events["started_at"])

    # Pick the most complete session per participant:
    # prefer sessions that have both condition_1 and condition_2 events
    def session_completeness(sid):
        evts = all_stage_events[all_stage_events["session_id"] == sid]["stage_id"].tolist()
        score = sum([
            "calibration"  in evts,
            "audio_only"   in evts,
            "condition_1"  in evts,
            "condition_2"  in evts,
            "session_end"  in evts,
        ])
        return score

    sessions["completeness"] = sessions["session_id"].apply(session_completeness)
    # Keep best session per participant (highest completeness, then highest session_id)
    sessions = (
        sessions.sort_values(["participant_id", "completeness", "session_id"], ascending=[True, False, False])
        .drop_duplicates("participant_id", keep="first")
        .reset_index(drop=True)
    )

    report_rows = []

    for _, row in sessions.iterrows():
        pid = row["participant_id"]
        sid = int(row["session_id"])
        print(f"\n── Participant {pid}  session {sid}  ({row['condition_order']}) ──")

        combined, report = process_participant(row, all_stage_events)

        flags_str = " | ".join(report["flags"]) if report["flags"] else "OK"
        print(f"   Flags   : {flags_str}")
        print(f"   Notes   : {report['notes'] or '(none)'}")
        if report["imu_l_offset_ms"] is not None:
            print(f"   L offset: {report['imu_l_offset_ms']:,.0f} ms   coverage {report['imu_l_coverage_pct']}%")
        if report["imu_r_offset_ms"] is not None:
            print(f"   R offset: {report['imu_r_offset_ms']:,.0f} ms   coverage {report['imu_r_coverage_pct']}%")

        if combined is not None:
            out_path = OUT_DIR / f"{pid}_combined.csv"
            combined.to_csv(out_path, index=False)
            print(f"   Saved   : {out_path.relative_to(ROOT)}  ({len(combined)} rows)")

        report_rows.append({
            "participant_id":       report["participant_id"],
            "session_id":           report["session_id"],
            "condition_order":      report["condition_order"],
            "flags":                " | ".join(report["flags"]),
            "imu_l_offset_ms":      report["imu_l_offset_ms"],
            "imu_r_offset_ms":      report["imu_r_offset_ms"],
            "imu_l_coverage_pct":   report["imu_l_coverage_pct"],
            "imu_r_coverage_pct":   report["imu_r_coverage_pct"],
            "notes":                report["notes"],
        })

    report_df = pd.DataFrame(report_rows)
    report_path = ROOT / "analysis" / "test5_alignment_report.csv"
    report_df.to_csv(report_path, index=False)
    print(f"\n── Summary report: {report_path.relative_to(ROOT)} ──")
    print(report_df.to_string(index=False))


if __name__ == "__main__":
    main()
