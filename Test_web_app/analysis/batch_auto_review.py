#!/usr/bin/env python
"""Batch auto-review — Test 5.

Runs the auto-influence analysis against every aligned CSV and prints a
results table. No Streamlit, no plotly required.

Usage:
    python analysis/batch_auto_review.py           # print results only
    python analysis/batch_auto_review.py --save    # also persist to DB
"""
from __future__ import annotations

import argparse
import sqlite3
import sys
from pathlib import Path

import numpy as np
import pandas as pd
from scipy.signal import find_peaks

ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(ROOT))

DB_PATH     = ROOT / "data" / "gait_study.db"
ALIGNED_DIR = ROOT / "analysis" / "test5_aligned"

STANCE_MIN_MS  = 80.0
STANCE_MAX_MS  = 2000.0
_SIG_THRESHOLD = 1.0   # std-units for "significant" effect

# ─────────────────────────────────────────────────────────────────────────────
# Core gait functions (copied from viewer.py to avoid Streamlit/plotly import)
# ─────────────────────────────────────────────────────────────────────────────

def _detect_steps_dynamic(pressure_df: pd.DataFrame) -> np.ndarray:
    if "stage" in pressure_df.columns:
        pres = pressure_df[pressure_df["stage"] != "calibration"].copy()
    else:
        pres = pressure_df.copy()
    if len(pres) < 20:
        pres = pressure_df.copy()

    pres = pres.sort_values("session_ms").reset_index(drop=True)
    t_ms = pres["session_ms"].values
    diffs = np.diff(t_ms)
    intra = diffs[diffs < 5_000]
    dt_ms = float(np.median(intra)) if len(intra) > 0 else 20.0
    dt_ms = max(dt_ms, 1.0)
    min_dist = max(1, int(350 / dt_ms))

    def _peaks(sig: np.ndarray) -> np.ndarray:
        p1, p99 = np.percentile(sig, 1), np.percentile(sig, 99)
        if p99 - p1 < 1.0:
            return np.array([], dtype=int)
        sig_n = np.clip((sig - p1) / (p99 - p1), 0.0, 1.0)
        peaks_prom, _ = find_peaks(sig_n, height=0.15, prominence=0.10, distance=min_dist)
        peaks_h65,  _ = find_peaks(sig_n, height=float(np.percentile(sig_n, 65)), distance=min_dist)
        return peaks_prom if len(peaks_prom) >= len(peaks_h65) else peaks_h65

    all_peaks_ms: list[float] = []
    for _, toe_col, heel_col in [("L", "L_toe", "L_heel"), ("R", "R_toe", "R_heel")]:
        primary = np.array([], dtype=int)
        if toe_col in pres.columns:
            primary = _peaks(pres[toe_col].values.astype(float))
        if len(primary) < 20 and heel_col in pres.columns:
            heel_p = _peaks(pres[heel_col].values.astype(float))
            if len(heel_p) > len(primary):
                primary = heel_p
        all_peaks_ms.extend(t_ms[primary].tolist())

    all_peaks_ms.sort()
    # Widen merge window to 350 ms — L→R spacing at 90-120 BPM is ~250-315 ms,
    # so the old 200 ms window missed most pairs and inflated baseline CV by ~6×.
    # 350 ms stays below the minimum same-foot interval enforced by min_dist.
    deduped: list[float] = []
    for ts in all_peaks_ms:
        if not deduped or ts - deduped[-1] >= 350:
            deduped.append(ts)
    return np.array(deduped)


def _detect_foot_contacts(pressure_df: pd.DataFrame) -> pd.DataFrame:
    """Hysteresis stance detection using per-row threshold columns."""
    if "session_ms" not in pressure_df.columns:
        return pd.DataFrame(columns=["session_ms", "foot", "stance_ms"])
    pres = pressure_df.sort_values("session_ms").reset_index(drop=True)
    rows_out = []
    for foot, heel_zone in (("L", "L_heel"), ("R", "R_heel")):
        if heel_zone not in pres.columns:
            continue
        lower_col = f"{heel_zone}_lower"
        upper_col = f"{heel_zone}_upper"
        has_dynamic = lower_col in pres.columns and upper_col in pres.columns
        if not has_dynamic:
            continue  # skip if no per-row thresholds

        in_contact = False
        t_start = 0.0
        contact_peak = 0.0
        last_start: float | None = None
        for i in range(len(pres)):
            row = pres.iloc[i]
            sess_ms = float(row["session_ms"])
            val    = float(row.get(heel_zone) or 0)
            lower  = float(row.get(lower_col) or 0)
            upper  = float(row.get(upper_col) or 0)
            if upper <= 0:
                continue
            if not in_contact:
                if val >= upper * 0.6:
                    in_contact = True
                    t_start = sess_ms
                    contact_peak = val
            else:
                if val > contact_peak:
                    contact_peak = val
                if val <= lower:   # <= catches signal equal to lower threshold (common at swing)
                    stance_ms = sess_ms - t_start
                    if STANCE_MIN_MS <= stance_ms <= STANCE_MAX_MS:
                        rows_out.append({"session_ms": t_start, "foot": foot,
                                         "stance_ms": stance_ms, "heel_peak": contact_peak})
                        last_start = t_start
                    in_contact = False
    return pd.DataFrame(rows_out) if rows_out else pd.DataFrame(
        columns=["session_ms", "foot", "stance_ms"])


def _compute_baseline(pres_df: pd.DataFrame) -> dict:
    result = {"cadence_mean": np.nan, "cadence_std": np.nan,
              "stance_mean": np.nan,  "stance_std": np.nan,
              "imu_mean": np.nan,     "imu_std": np.nan,
              "heel_peak_mean": np.nan, "heel_peak_std": np.nan}
    if "stage" not in pres_df.columns:
        return result

    ao = pres_df[pres_df["stage"] == "audio_only"].sort_values("session_ms").reset_index(drop=True)
    if ao.empty:
        return result

    dur_ms    = float(ao["session_ms"].max() - ao["session_ms"].min())
    end_ms    = float(ao["session_ms"].max())

    if dur_ms >= 45_000:
        baseline = ao[ao["session_ms"] >= end_ms - 30_000].copy()
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
            # Apply the same 5-point rolling mean that condition analysis uses,
            # so baseline_std reflects real walking-pace variability rather than
            # detector noise (spurious short/long intervals from missed peaks).
            w = min(5, len(bpm_vals))
            bpm_smooth = pd.Series(bpm_vals).rolling(w, center=True, min_periods=1).mean().values
            result["cadence_std"] = float(np.std(bpm_smooth, ddof=1)) if len(bpm_smooth) > 1 else 0.0

    # Stance + heel peak
    contacts = _detect_foot_contacts(baseline)
    if not contacts.empty and "stance_ms" in contacts.columns:
        sv = contacts["stance_ms"].values
        if len(sv) >= 3:
            result["stance_mean"] = float(np.mean(sv))
            # Smooth before std for consistency with condition rolling-mean analysis
            sw = min(5, len(sv))
            sv_sm = pd.Series(sv).rolling(sw, center=True, min_periods=1).mean().values
            result["stance_std"] = float(np.std(sv_sm, ddof=1)) if len(sv_sm) > 1 else 0.0
        if "heel_peak" in contacts.columns:
            pv = contacts["heel_peak"].dropna().values
            if len(pv) >= 3:
                result["heel_peak_mean"] = float(np.mean(pv))
                pw = min(5, len(pv))
                pv_sm = pd.Series(pv).rolling(pw, center=True, min_periods=1).mean().values
                result["heel_peak_std"] = float(np.std(pv_sm, ddof=1)) if len(pv_sm) > 1 else 0.0

    # IMU heel
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


def _compute_thirds_outcome(
    values: np.ndarray, t_s: np.ndarray,
    baseline_mean: float, baseline_std: float, expected: str,
    drift_out_start_s: float | None = None,  # Trim thirds to active phase only (excludes drift-out)
) -> tuple[str, float | None, str]:
    """Thirds + rolling-window peak analysis.

    # SYNC: This function is duplicated in analysis/viewer.py (_compute_thirds_outcome).
    # Keep in sync manually. Planned: extract to analysis/gait_metrics.py

    outcome ∈ {"influenced_intended", "influenced_transient", "influenced_opposite",
               "no_effect", "unclear"}
    """
    if len(values) < 6 or baseline_std <= 0 or abs(baseline_mean) < 1e-6:
        return "unclear", None, "none"

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
        return "unclear", None, "none"

    t_max = float(t_s_a[-1])
    th1, th2 = t_max / 3.0, 2.0 * t_max / 3.0
    m1 = float(np.nanmean(values_a[t_s_a <= th1]))                        if np.any(t_s_a <= th1)              else np.nan
    m2 = float(np.nanmean(values_a[(t_s_a > th1) & (t_s_a <= th2)]))     if np.any((t_s_a > th1) & (t_s_a <= th2)) else np.nan
    m3 = float(np.nanmean(values_a[t_s_a > th2]))                         if np.any(t_s_a > th2)               else np.nan

    if np.isnan(m3):
        return "unclear", None, "none"

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

    # Transient peak: 8 s rolling window; lower threshold than sustained effects.
    _TRANSIENT_THRESHOLD = 0.7
    signed_dev = (values - baseline_mean) / baseline_std
    dt_mean = float(np.median(np.diff(t_s))) if len(t_s) > 1 else 1.0
    win = max(3, int(8.0 / max(dt_mean, 0.1)))
    rolling_sd = pd.Series(signed_dev).rolling(win, center=True, min_periods=3).mean().values
    if expected == "up":
        peak_signed = float(np.nanmax(rolling_sd))
    else:
        peak_signed = float(np.nanmin(rolling_sd))
    # Guard: nanmax/nanmin returns -inf/+inf when all values are NaN
    if not np.isfinite(peak_signed):
        peak_signed = 0.0
    peak_e = abs(peak_signed)

    # Outcome classification
    if e3 >= _SIG_THRESHOLD:
        if (expected == "up" and m3 > baseline_mean) or \
           (expected == "down" and m3 < baseline_mean):
            outcome = "influenced_intended"
        else:
            outcome = "influenced_opposite"
    elif peak_e >= _TRANSIENT_THRESHOLD:
        if (expected == "up" and peak_signed > 0) or \
           (expected == "down" and peak_signed < 0):
            outcome = "influenced_transient"
            # For transient, effect_pct reflects the peak, not the decayed final third
            effect_pct = (peak_signed * baseline_std / abs(baseline_mean)) * 100.0
        else:
            outcome = "no_effect"
    else:
        outcome = "no_effect"

    return outcome, round(effect_pct, 2), onset


def _analyse_participant(pid: str, pres_df: pd.DataFrame, sess: dict) -> dict:
    result: dict = {
        "pid": pid, "sid": sess["session_id"],
        "tempo_dir": sess["tempo_direction"],
        "weight_dir": sess["weight_direction"],
        "tempo_outcome": "unreviewed", "tempo_effect_pct": None,
        "tempo_audio_change_pct": None, "tempo_coupling_ratio": None,
        "tempo_entrainment_r": None, "tempo_onset": None,
        "weight_outcome": "unreviewed", "weight_effect_pct_stance": None,
        "weight_effect_pct_imu": None, "weight_effect_pct_peak": None, "weight_onset": None,
        "imu_foot_count": 2,  # assume bilateral until proven otherwise
        "low_steps": 0,
    }

    if "condition" not in pres_df.columns or "stage" not in pres_df.columns:
        return result

    cmap = (
        pres_df[pres_df["stage"].isin(["condition_1", "condition_2"])][["stage", "condition"]]
        .drop_duplicates()
    )
    cond_to_stage = {r["condition"]: r["stage"] for _, r in cmap.iterrows()}
    tempo_stage  = cond_to_stage.get("tempo")
    weight_stage = cond_to_stage.get("weight")

    baseline = _compute_baseline(pres_df)
    result["imu_foot_count"] = baseline.get("imu_foot_count", 2)

    # Phase drift-out times (from session_stage_events via get_sessions_map)
    drift_out_map = sess.get("drift_out_by_stage", {})
    tempo_drift_out_s  = drift_out_map.get(tempo_stage,  None)
    weight_drift_out_s = drift_out_map.get(weight_stage, None)

    # Minimum step count check
    min_steps = 9999
    for stg in [s for s in [tempo_stage, weight_stage] if s]:
        sub = pres_df[pres_df["stage"] == stg]
        if not sub.empty:
            steps = _detect_steps_dynamic(sub)
            min_steps = min(min_steps, len(steps))
    result["low_steps"] = int(min_steps < 30)

    # ── Tempo ─────────────────────────────────────────────────────────────────
    if tempo_stage and sess["tempo_direction"] and not np.isnan(baseline["cadence_mean"]):
        cond = pres_df[pres_df["stage"] == tempo_stage].sort_values("session_ms").reset_index(drop=True)
        if not cond.empty:
            stage_start_ms = float(cond["session_ms"].min())
            step_arr = _detect_steps_dynamic(cond)
            if len(step_arr) >= 3:
                intervals_ms = np.diff(step_arr)
                bpm_inst     = 60_000.0 / intervals_ms
                midpoint_ms  = (step_arr[:-1] + step_arr[1:]) / 2.0
                valid = (bpm_inst >= 30) & (bpm_inst <= 200)
                bpm_inst    = bpm_inst[valid]
                midpoint_ms = midpoint_ms[valid]
                if len(bpm_inst) >= 6:
                    window     = min(10, len(bpm_inst))
                    bpm_smooth = pd.Series(bpm_inst).rolling(window, center=True, min_periods=1).mean().values
                    t_s        = (midpoint_ms - stage_start_ms) / 1000.0
                    exp = "up" if sess["tempo_direction"] == "speeding_up" else "down"
                    out, eff, onset = _compute_thirds_outcome(
                        bpm_smooth, t_s, baseline["cadence_mean"],
                        max(baseline["cadence_std"], 0.1), exp,
                        drift_out_start_s=tempo_drift_out_s,
                    )
                    result["tempo_outcome"]    = out
                    result["tempo_effect_pct"] = eff
                    result["tempo_onset"]      = onset

                    # Audio BPM change from ratio column — active phase only (exclude drift-out)
                    # ratio > 1 always; speeding_up → BPM × ratio (+); slowing_down → BPM ÷ ratio (−)
                    if "ratio" in cond.columns:
                        t_min_ms = float(cond["session_ms"].min())
                        t_max_ms = float(cond["session_ms"].max())
                        dur_ms   = t_max_ms - t_min_ms
                        active_dur_ms = (
                            min(dur_ms, tempo_drift_out_s * 1000.0)
                            if tempo_drift_out_s is not None and dur_ms > tempo_drift_out_s * 1000.0
                            else dur_ms
                        )
                        if dur_ms > 0:
                            last_third = cond[
                                (cond["session_ms"] >= t_min_ms + 2 * active_dur_ms / 3) &
                                (cond["session_ms"] <= t_min_ms + active_dur_ms)
                            ]["ratio"].dropna()
                            if len(last_third) >= 3:
                                raw_pct  = (float(last_third.mean()) - 1.0) * 100.0
                                sign     = 1.0 if sess["tempo_direction"] == "speeding_up" else -1.0
                                audio_pct = sign * raw_pct
                                result["tempo_audio_change_pct"] = round(audio_pct, 2)
                                if abs(audio_pct) > 0.5 and eff is not None:
                                    result["tempo_coupling_ratio"] = round(eff / audio_pct, 3)

                    # Pearson r: smoothed cadence vs reconstructed audio BPM on 1 s grid
                    try:
                        from scipy.stats import pearsonr as _pearsonr
                        if "bpm" in cond.columns and len(bpm_smooth) >= 4:
                            tc_ms  = midpoint_ms[valid]
                            t_min_ms_cad = float(tc_ms.min())
                            t_max_ms_cad = float(tc_ms.max())
                            t_grid = np.arange(0.0, (t_max_ms_cad - t_min_ms_cad) / 1000.0, 1.0)
                            if len(t_grid) >= 6:
                                tc_t = (tc_ms - t_min_ms_cad) / 1000.0
                                cad_interp = np.interp(t_grid, tc_t, bpm_smooth)
                                base_bpm_col = cond["bpm"].dropna()
                                if len(base_bpm_col) > 0 and "ratio" in cond.columns:
                                    base_bpm_v = float(base_bpm_col.iloc[0])
                                    ratio_arr  = cond["ratio"].values.astype(float)
                                    ratio_t    = (cond["session_ms"].values.astype(float) - t_min_ms_cad) / 1000.0
                                    if sess["tempo_direction"] == "speeding_up":
                                        audio_bpm_col = base_bpm_v * ratio_arr
                                    else:
                                        audio_bpm_col = base_bpm_v / ratio_arr
                                    audio_interp = np.interp(t_grid, ratio_t, audio_bpm_col)
                                    mask = np.isfinite(cad_interp) & np.isfinite(audio_interp)
                                    if mask.sum() >= 6:
                                        r_val, _ = _pearsonr(cad_interp[mask], audio_interp[mask])
                                        result["tempo_entrainment_r"] = round(float(r_val), 3)
                    except Exception:
                        pass
                else:
                    result["tempo_outcome"] = "unclear"
            else:
                result["tempo_outcome"] = "unclear"

    # ── Weight ────────────────────────────────────────────────────────────────
    if weight_stage and sess["weight_direction"] and not np.isnan(baseline["stance_mean"]):
        cond = pres_df[pres_df["stage"] == weight_stage].sort_values("session_ms").reset_index(drop=True)
        if not cond.empty:
            stage_start_ms = float(cond["session_ms"].min())
            contacts = _detect_foot_contacts(cond)
            if not contacts.empty and "stance_ms" in contacts.columns:
                contacts = contacts.sort_values("session_ms").reset_index(drop=True)
                contacts["t_s"] = (contacts["session_ms"] - stage_start_ms) / 1000.0
                contacts["stance_smt"] = contacts["stance_ms"].rolling(5, center=True, min_periods=1).mean()
                sw = contacts.dropna(subset=["stance_smt"])
                if len(sw) >= 6:
                    exp = "up" if sess["weight_direction"] == "increasing" else "down"
                    out, eff_s, onset = _compute_thirds_outcome(
                        sw["stance_smt"].values, sw["t_s"].values,
                        baseline["stance_mean"], max(baseline["stance_std"], 1.0), exp,
                        drift_out_start_s=weight_drift_out_s,
                    )
                    result["weight_outcome"]          = out
                    result["weight_effect_pct_stance"] = eff_s
                    result["weight_onset"]            = onset

                    # IMU heel
                    if not np.isnan(baseline["imu_mean"]):
                        imu_cols = [c for c in ("l_imu_heel", "r_imu_heel") if c in cond.columns]
                        if imu_cols:
                            cond["_t_s"]   = (cond["session_ms"] - stage_start_ms) / 1000.0
                            cond["_imu"]   = cond[imu_cols].mean(axis=1)
                            cond["_bin"]   = (cond["_t_s"] / 5.0).astype(int)
                            binned = cond.groupby("_bin").agg(
                                t_s=("_t_s", "mean"), imu_heel=("_imu", "mean")
                            ).reset_index(drop=True).dropna(subset=["imu_heel"])
                            if len(binned) >= 4:
                                t_max_s = float(binned["t_s"].max())
                                last_imu = float(binned[binned["t_s"] > 2 * t_max_s / 3]["imu_heel"].mean())
                                if not np.isnan(last_imu) and baseline["imu_mean"] != 0:
                                    result["weight_effect_pct_imu"] = round(
                                        (last_imu - baseline["imu_mean"]) / abs(baseline["imu_mean"]) * 100, 2
                                    )

                    # Heel peak amplitude
                    if not np.isnan(baseline.get("heel_peak_mean", np.nan)) and "heel_peak" in contacts.columns:
                        sw_peak = contacts.dropna(subset=["heel_peak"])
                        if len(sw_peak) >= 4:
                            t_max_p = float(sw_peak["t_s"].max())
                            last_pk = float(sw_peak[sw_peak["t_s"] > 2 * t_max_p / 3]["heel_peak"].mean())
                            bm_pk   = baseline["heel_peak_mean"]
                            if not np.isnan(last_pk) and bm_pk != 0:
                                result["weight_effect_pct_peak"] = round(
                                    (last_pk - bm_pk) / abs(bm_pk) * 100, 2
                                )
                else:
                    result["weight_outcome"] = "unclear"
            else:
                result["weight_outcome"] = "unclear"

    return result


# ─────────────────────────────────────────────────────────────────────────────

def get_sessions_map() -> dict[str, list[dict]]:
    """Return {pid: [session_info, ...]} for all Test 5 sessions (excludes is_excluded=1 rows)."""
    con = sqlite3.connect(DB_PATH)
    rows = con.execute(
        """SELECT s.session_id, s.participant_id, s.tempo_direction, s.weight_direction,
                  s.condition_order
           FROM sessions s
           LEFT JOIN session_reviews sr ON s.session_id = sr.session_id
           WHERE s.test_type_id = 5
             AND (sr.is_excluded IS NULL OR sr.is_excluded = 0)
           ORDER BY s.participant_id, s.session_id"""
    ).fetchall()

    # Fetch drift-out start times from stage events (used to exclude drift-out from thirds analysis)
    evts: dict[int, dict[str, str]] = {}
    try:
        evt_rows = con.execute(
            """SELECT session_id, stage_id, started_at
               FROM session_stage_events
               WHERE stage_id IN ('condition_1_onset', 'condition_1_offset',
                                  'condition_2_onset', 'condition_2_offset')"""
        ).fetchall()
        for sid, stage_id, started_at in evt_rows:
            evts.setdefault(sid, {})[stage_id] = started_at
    except Exception:
        pass
    con.close()

    out: dict[str, list[dict]] = {}
    for r in rows:
        sid = r[0]
        pid = r[1]
        # Compute drift_out_start in seconds from condition onset for each condition
        drift_out: dict[str, float | None] = {}
        se = evts.get(sid, {})
        for cond_n in ("condition_1", "condition_2"):
            onset_key  = f"{cond_n}_onset"
            offset_key = f"{cond_n}_offset"
            if onset_key in se and offset_key in se:
                t0  = pd.to_datetime(se[onset_key])
                tdo = pd.to_datetime(se[offset_key])
                drift_out[cond_n] = (tdo - t0).total_seconds()
            else:
                drift_out[cond_n] = None  # fallback — use full condition

        out.setdefault(pid, []).append({
            "session_id": sid, "tempo_direction": r[2],
            "weight_direction": r[3], "condition_order": r[4],
            "drift_out_by_stage": drift_out,
        })
    return out


def save_results_to_db(results: list[dict], force: bool = False) -> None:
    con = sqlite3.connect(DB_PATH)
    # Ensure columns exist
    for m in [
        "ALTER TABLE session_reviews ADD COLUMN tempo_audio_change_pct REAL",
        "ALTER TABLE session_reviews ADD COLUMN tempo_coupling_ratio REAL",
        "ALTER TABLE session_reviews ADD COLUMN tempo_entrainment_r REAL",
        "ALTER TABLE session_reviews ADD COLUMN weight_effect_pct_peak REAL",
    ]:
        try:
            con.execute(m); con.commit()
        except Exception:
            pass

    skipped = 0
    for r in results:
        if "error" in r:
            continue

        if not force:
            # Don't overwrite sessions that have had outcomes manually set in the viewer
            existing = con.execute(
                "SELECT tempo_overridden, weight_overridden FROM session_reviews WHERE session_id=?",
                (r["sid"],)
            ).fetchone()
            if existing and (existing[0] or existing[1]):
                skipped += 1
                continue  # Preserve manual review; use --force to override

        con.execute("""
INSERT INTO session_reviews
    (session_id, auto_low_steps,
     tempo_outcome, tempo_effect_pct, tempo_onset,
     tempo_audio_change_pct, tempo_coupling_ratio, tempo_entrainment_r,
     weight_outcome, weight_effect_pct_stance, weight_effect_pct_imu, weight_effect_pct_peak,
     weight_onset,
     reviewed_at)
VALUES
    (:sid, :low_steps,
     :tempo_outcome, :tempo_effect_pct, :tempo_onset,
     :tempo_audio_change_pct, :tempo_coupling_ratio, :tempo_entrainment_r,
     :weight_outcome, :weight_effect_pct_stance, :weight_effect_pct_imu, :weight_effect_pct_peak,
     :weight_onset,
     datetime('now'))
ON CONFLICT(session_id) DO UPDATE SET
    auto_low_steps           = excluded.auto_low_steps,
    tempo_outcome            = excluded.tempo_outcome,
    tempo_effect_pct         = excluded.tempo_effect_pct,
    tempo_onset              = excluded.tempo_onset,
    tempo_audio_change_pct   = excluded.tempo_audio_change_pct,
    tempo_coupling_ratio     = excluded.tempo_coupling_ratio,
    tempo_entrainment_r      = excluded.tempo_entrainment_r,
    weight_outcome           = excluded.weight_outcome,
    weight_effect_pct_stance = excluded.weight_effect_pct_stance,
    weight_effect_pct_imu    = excluded.weight_effect_pct_imu,
    weight_effect_pct_peak   = excluded.weight_effect_pct_peak,
    weight_onset             = excluded.weight_onset,
    reviewed_at              = excluded.reviewed_at
""", r)
    con.commit()
    con.close()
    return skipped


def run(save: bool = False, force: bool = False) -> None:
    csv_files   = sorted(ALIGNED_DIR.glob("*_combined.csv"))
    pids_csv    = [f.stem.replace("_combined", "") for f in csv_files]
    sessions_map = get_sessions_map()

    results: list[dict] = []
    for pid in pids_csv:
        path = ALIGNED_DIR / f"{pid}_combined.csv"
        try:
            df = pd.read_csv(path, low_memory=False)
        except Exception as e:
            results.append({"pid": pid, "error": f"CSV read error: {e}"})
            continue

        sessions = sessions_map.get(pid)
        if not sessions:
            results.append({"pid": pid, "error": "no DB session"})
            continue

        sess = sessions[-1]   # use latest session for this pid

        try:
            r = _analyse_participant(pid, df, sess)
        except Exception as e:
            results.append({"pid": pid, "error": str(e)})
            continue

        results.append(r)

    if save:
        skipped = save_results_to_db(results, force=force)

    # ── Print ─────────────────────────────────────────────────────────────────
    ok   = [r for r in results if "error" not in r]
    errs = [r for r in results if "error" in r]

    # Aggregate counts
    t_counts: dict[str, int] = {}
    w_counts: dict[str, int] = {}
    for r in ok:
        t_counts[r["tempo_outcome"]] = t_counts.get(r["tempo_outcome"], 0) + 1
        w_counts[r["weight_outcome"]] = w_counts.get(r["weight_outcome"], 0) + 1

    LABELS = {
        "influenced_intended":  "✅ intended",
        "influenced_transient": "〜  transient",
        "influenced_opposite":  "↩  opposite",
        "no_effect":            "—  no effect",
        "unclear":              "?  unclear",
        "unreviewed":           "·  unreviewed",
    }

    W = 100
    print(f"\n{'─'*W}")
    print(f"  Batch auto-review — Test 5   ({len(ok)}/{len(pids_csv)} participants)")
    print(f"{'─'*W}")

    print(f"\n  TEMPO — {sum(t_counts.values())} participants")
    for k in ["influenced_intended", "influenced_transient", "influenced_opposite", "no_effect", "unclear", "unreviewed"]:
        if k in t_counts:
            pct = t_counts[k] / len(ok) * 100
            bar = "█" * t_counts[k]
            print(f"    {LABELS[k]:<20}  {t_counts[k]:>2}  ({pct:5.1f}%)  {bar}")

    print(f"\n  WEIGHT — {sum(w_counts.values())} participants")
    for k in ["influenced_intended", "influenced_transient", "influenced_opposite", "no_effect", "unclear", "unreviewed"]:
        if k in w_counts:
            pct = w_counts[k] / len(ok) * 100
            bar = "█" * w_counts[k]
            print(f"    {LABELS[k]:<20}  {w_counts[k]:>2}  ({pct:5.1f}%)  {bar}")

    # Per-participant detail table
    W = 120
    print(f"\n{'─'*W}")
    print(f"  {'PID':<5}  {'T-dir':<12}  {'T-stat outcome':<18}  {'Cad Δ%':>7}  {'Audio Δ%':>8}  {'Coup':>6}  {'Entr.r':>6}  {'Dir?':>5}  "
          f"{'W-dir':<12}  {'W-stat outcome':<18}  {'St Δ%':>6}  {'Pk Δ%':>6}  {'IMU Δ%':>7}  {'Dir?':>5}")
    print(f"{'─'*W}")

    for r in sorted(ok, key=lambda x: x["pid"]):
        t_lbl = LABELS.get(r["tempo_outcome"], r["tempo_outcome"])
        w_lbl = LABELS.get(r["weight_outcome"], r["weight_outcome"])

        t_eff  = f"{r['tempo_effect_pct']:+6.1f}" if r["tempo_effect_pct"]  is not None else "     —"
        audio  = f"{r['tempo_audio_change_pct']:+7.1f}" if r["tempo_audio_change_pct"] is not None else "      —"
        coup   = f"{r['tempo_coupling_ratio']:+5.2f}" if r["tempo_coupling_ratio"] is not None else "    —"
        entr_r = f"{r['tempo_entrainment_r']:+5.2f}" if r["tempo_entrainment_r"] is not None else "    —"
        w_st   = f"{r['weight_effect_pct_stance']:+5.1f}" if r["weight_effect_pct_stance"] is not None else "    —"
        w_pk   = f"{r['weight_effect_pct_peak']:+5.1f}" if r.get("weight_effect_pct_peak") is not None else "    —"
        w_imu_val = f"{r['weight_effect_pct_imu']:+6.1f}" if r["weight_effect_pct_imu"] is not None else "     —"
        w_imu = w_imu_val + ("*" if r.get("imu_foot_count", 2) == 1 else " ")

        # Direction match (intended / opposite / —) regardless of significance
        t_dir_match = "—"
        if r["tempo_effect_pct"] is not None:
            expected_up = r["tempo_dir"] == "speeding_up"
            went_up     = r["tempo_effect_pct"] > 0
            t_dir_match = "✓" if (expected_up == went_up) else "✗"
        w_dir_match = "—"
        if r["weight_effect_pct_stance"] is not None:
            expected_up = r["weight_dir"] == "increasing"
            went_up     = r["weight_effect_pct_stance"] > 0
            w_dir_match = "✓" if (expected_up == went_up) else "✗"

        flag = " ⚠" if r["low_steps"] else ""
        print(f"  {r['pid']:<5}  {r['tempo_dir']:<12}  {t_lbl:<18}  {t_eff}%  {audio}%  {coup}  {entr_r}  {t_dir_match:>5}  "
              f"{r['weight_dir']:<12}  {w_lbl:<18}  {w_st}%  {w_pk}%  {w_imu}%  {w_dir_match:>5}{flag}")

    # Footnotes
    if any(r.get("imu_foot_count", 2) == 1 for r in ok):
        print(f"  * IMU Δ% computed from one foot only (other foot all-NaN)")

    # Direction summary (regardless of SD significance)
    t_intended = sum(1 for r in ok if r["tempo_effect_pct"] is not None
                     and (r["tempo_dir"] == "speeding_up") == (r["tempo_effect_pct"] > 0))
    t_known    = sum(1 for r in ok if r["tempo_effect_pct"] is not None)
    w_intended = sum(1 for r in ok if r["weight_effect_pct_stance"] is not None
                     and (r["weight_dir"] == "increasing") == (r["weight_effect_pct_stance"] > 0))
    w_known    = sum(1 for r in ok if r["weight_effect_pct_stance"] is not None)

    print(f"\n  Direction match (any magnitude — ignores SD threshold):")
    if t_known:
        print(f"    Tempo : {t_intended}/{t_known} in intended direction ({t_intended/t_known*100:.0f}%)")
    if w_known:
        print(f"    Weight: {w_intended}/{w_known} in intended direction ({w_intended/w_known*100:.0f}%)")

    if errs:
        print(f"\n  Errors ({len(errs)}):")
        for r in errs:
            print(f"    P{r['pid']}: {r['error']}")

    if save:
        n_saved = len(ok) - skipped
        print(f"\n  ✅ Saved to session_reviews for {n_saved} participants.", end="")
        if skipped:
            print(f"  ({skipped} skipped — manually overridden; use --force to overwrite)", end="")
        print()
    else:
        print(f"\n  (Run with --save to persist to database)")
    print(f"{'─'*W}\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--save", action="store_true",
                        help="Write auto-computed results to session_reviews table")
    parser.add_argument("--force", action="store_true",
                        help="Overwrite manually reviewed sessions (use with --save)")
    args = parser.parse_args()
    run(save=args.save, force=args.force)
