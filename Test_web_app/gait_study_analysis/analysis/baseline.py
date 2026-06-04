"""Baseline walking cadence (BPM) detection from neutral-condition pressure data.

Three sources, in order of preference:

  1. Tempo CSV  — the embedded BPM column value when ratio (col 14) ≈ 1.0
                  (ratio = 1.0 means no tempo manipulation; the BPM column holds
                  the calibrated walking cadence Max/MSP detected during setup)
  2. Weight CSV — same approach with the effect column (col 14 ≈ 1.0)
  3. Pondering  — step detection from pressure zones, using synthesised
                  timestamps derived from the sample rate of the tempo/weight file
                  (all device_ms values in pondering are 0 — BLE was not yet
                  connected during this stage).  Only included if the detected
                  cadence is within ±5 BPM of the BPM-column estimate.
"""
from __future__ import annotations

from pathlib import Path

import pandas as pd

from merge.merger import parse_max_pressure_file, _is_max_format

# ── Constants ─────────────────────────────────────────────────────────────────
DEDUP_MS: float = 300.0           # merge step events within this window
NEUTRAL_TOLERANCE: float = 0.001  # |effect - 1.0| < this → neutral
PONDERING_TAIL_S: float = 15.0    # last N seconds of pondering to analyse
MAX_POND_OFFSET_BPM: float = 5.0  # max delta vs BPM-column estimate for inclusion
CONSISTENCY_THRESH: float = 0.20  # inter-step std dev < 20 % of mean interval

_ZONES = ("L_toe", "L_heel", "R_toe", "R_heel")


# ── Low-level helpers ─────────────────────────────────────────────────────────

def _parse_with_effect(path: Path) -> tuple[pd.DataFrame, list[dict]]:
    """Parse Max/MSP pressure CSV, including optional BPM (col 13) and effect (col 14).

    The returned df may have 'bpm' and 'effect' columns when present.
    """
    df_base, thresholds, _ = parse_max_pressure_file(path)

    raw = path.read_text().strip()
    extras: list[dict] = []
    for record in [r.strip() for r in raw.split(";") if r.strip()]:
        parts = record.split(",", 1)
        if len(parts) != 2:
            continue
        values = parts[1].strip().split()
        bpm    = float(values[13]) if len(values) > 13 else None
        effect = float(values[14]) if len(values) > 14 else None
        extras.append({"bpm": bpm, "effect": effect})

    if len(extras) == len(df_base):
        df_base = pd.concat(
            [df_base.reset_index(drop=True), pd.DataFrame(extras)],
            axis=1,
        )
    return df_base, thresholds


def _sample_rate_hz(path: Path) -> float | None:
    """Estimate sensor sample rate (Hz) from a pressure file with valid timestamps."""
    try:
        df, _, _ = parse_max_pressure_file(path)
        df = df[df["device_ms"] > 0]
        if len(df) < 10:
            return None
        duration_ms = float(df["device_ms"].max() - df["device_ms"].min())
        if duration_ms <= 0:
            return None
        return len(df) / (duration_ms / 1000.0)
    except Exception:
        return None


def _bpm_from_column(df: pd.DataFrame) -> float | None:
    """Return mean BPM from the embedded 'bpm' column for neutral-effect rows."""
    if "effect" not in df.columns or "bpm" not in df.columns:
        return None
    neutral = df[abs(df["effect"] - 1.0) < NEUTRAL_TOLERANCE]["bpm"].dropna()
    if neutral.empty:
        return None
    return round(float(neutral.mean()), 2)


def _detect_cadence(
    df: pd.DataFrame,
    thresholds: list[dict],
) -> tuple[float | None, list[float]]:
    """Hysteresis step detection → (cadence_bpm, step_ms_list).

    Uses the same algorithm as analysis/calibration.py.
    Returns (None, []) when fewer than 3 steps are detected.
    """
    thresh = {t["zone"]: t for t in thresholds}

    # Allow synthesised timestamps (device_ms may be row-based), but exclude literal 0
    df = df[df["device_ms"] > 0].copy()
    if df.empty:
        return None, []

    duration_ms = float(df["device_ms"].max() - df["device_ms"].min())
    if duration_ms <= 0:
        return None, []

    rows = df.to_dict("records")
    above: dict[str, bool] = {z: False for z in _ZONES}
    raw_events: list[float] = []

    for row in rows:
        ms = float(row.get("device_ms", 0))
        for zone in _ZONES:
            t = thresh.get(zone)
            if t is None:
                continue
            val = float(row.get(zone, 0) or 0)
            if not above[zone]:
                if val > t["upper"]:
                    above[zone] = True
                    raw_events.append(ms)
            else:
                if val < t["lower"]:
                    above[zone] = False

    # Deduplicate events within DEDUP_MS
    raw_events.sort()
    deduped: list[float] = []
    for ts in raw_events:
        if not deduped or ts - deduped[-1] >= DEDUP_MS:
            deduped.append(ts)

    if len(deduped) < 3:
        return None, deduped

    duration_min = duration_ms / 60_000.0
    return round(len(deduped) / duration_min, 2), deduped


def _is_consistent(step_ms: list[float]) -> bool:
    """True when inter-step std dev < CONSISTENCY_THRESH × mean interval."""
    if len(step_ms) < 4:
        return False
    intervals = [step_ms[i + 1] - step_ms[i] for i in range(len(step_ms) - 1)]
    mean_iv = sum(intervals) / len(intervals)
    if mean_iv <= 0:
        return False
    variance = sum((x - mean_iv) ** 2 for x in intervals) / len(intervals)
    return (variance ** 0.5) / mean_iv < CONSISTENCY_THRESH


# ── Main analysis function ─────────────────────────────────────────────────────

def analyse_baseline_bpm(
    session_folder: Path,
    pid: str,
    condition_order: str | None = None,
) -> dict:
    """Compute baseline walking BPM from neutral pressure rows in a session folder.

    Returns dict:
        baseline_bpm : float | None
        sources      : list[{source, bpm, n_rows, included, reason?}]
        error        : str | None
    """
    sources: list[dict] = []
    bpm_values: list[float] = []
    reference_bpm: float | None = None   # BPM-column estimate used to validate pondering

    def _src(name: str, bpm: float | None, n: int,
             included: bool, reason: str = "") -> dict:
        e: dict = {"source": name, "bpm": bpm, "n_rows": n, "included": included}
        if reason:
            e["reason"] = reason
        return e

    # ── 1. Tempo neutral rows ─────────────────────────────────────────────────
    tempo_path = session_folder / f"{pid}_pressure_tempo.csv"
    tempo_thresh: list[dict] = []
    tempo_rate: float | None = None

    if tempo_path.exists() and _is_max_format(tempo_path):
        try:
            df_t, tempo_thresh = _parse_with_effect(tempo_path)
            df_t_valid = df_t[df_t["device_ms"] > 0]
            if not df_t_valid.empty:
                n_rows = len(df_t_valid)
                duration_ms = float(df_t_valid["device_ms"].max()
                                    - df_t_valid["device_ms"].min())
                tempo_rate = n_rows / (duration_ms / 1000.0) if duration_ms > 0 else None

            # Primary: read BPM column at ratio ≈ 1.0
            col_bpm = _bpm_from_column(df_t)
            neutral_t = (df_t[abs(df_t.get("effect", pd.Series(dtype=float)) - 1.0)
                              < NEUTRAL_TOLERANCE]
                         if "effect" in df_t.columns else pd.DataFrame())

            if col_bpm is not None:
                sources.append(_src("tempo_neutral", col_bpm, len(neutral_t), True))
                bpm_values.append(col_bpm)
                reference_bpm = col_bpm
            else:
                # Fallback: step detection on neutral-effect rows
                neutral_valid = (neutral_t[neutral_t["device_ms"] > 0]
                                 if "effect" in df_t.columns else pd.DataFrame())
                cadence, _ = _detect_cadence(neutral_valid, tempo_thresh)
                if cadence is not None:
                    sources.append(_src("tempo_neutral", cadence, len(neutral_valid), True))
                    bpm_values.append(cadence)
                    reference_bpm = cadence
                else:
                    sources.append(_src("tempo_neutral", None,
                                        len(neutral_valid) if not neutral_valid.empty else 0,
                                        False, "no BPM column and too few neutral steps"))
        except Exception as exc:
            sources.append(_src("tempo_neutral", None, 0, False, str(exc)))

    # ── 2. Weight neutral rows ────────────────────────────────────────────────
    weight_path = session_folder / f"{pid}_pressure_weight.csv"

    if weight_path.exists() and _is_max_format(weight_path):
        try:
            df_w, weight_thresh = _parse_with_effect(weight_path)
            col_bpm_w = _bpm_from_column(df_w)
            neutral_w = (df_w[abs(df_w.get("effect", pd.Series(dtype=float)) - 1.0)
                              < NEUTRAL_TOLERANCE]
                         if "effect" in df_w.columns else pd.DataFrame())

            if col_bpm_w is not None:
                # Only add weight source if it's meaningfully different from tempo
                # (some participants have identical files — avoid double-counting)
                if reference_bpm is None or abs(col_bpm_w - reference_bpm) > 0.1:
                    sources.append(_src("weight_neutral", col_bpm_w, len(neutral_w), True))
                    bpm_values.append(col_bpm_w)
                    if reference_bpm is None:
                        reference_bpm = col_bpm_w
                else:
                    sources.append(_src("weight_neutral", col_bpm_w, len(neutral_w),
                                        False, "same recording as tempo — not double-counted"))
            else:
                neutral_valid_w = (neutral_w[neutral_w["device_ms"] > 0]
                                   if "effect" in df_w.columns else pd.DataFrame())
                cadence_w, _ = _detect_cadence(neutral_valid_w, weight_thresh)
                if cadence_w is not None:
                    sources.append(_src("weight_neutral", cadence_w,
                                        len(neutral_valid_w), True))
                    bpm_values.append(cadence_w)
                else:
                    sources.append(_src("weight_neutral", None, len(neutral_valid_w),
                                        False, "no BPM column and too few neutral steps"))
        except Exception as exc:
            sources.append(_src("weight_neutral", None, 0, False, str(exc)))

    # ── 3. Pondering (synthesised timestamps) ─────────────────────────────────
    pond_path = session_folder / f"{pid}_pressure_pondering.csv"

    if pond_path.exists() and _is_max_format(pond_path):
        try:
            df_p, pond_thresh = _parse_with_effect(pond_path)
            n_pond = len(df_p)

            # Infer sample rate from tempo/weight file (pondering has no valid timestamps)
            rate = tempo_rate
            if rate is None:
                rate = _sample_rate_hz(weight_path) if weight_path.exists() else None
            if rate is None:
                sources.append(_src("pondering_end", None, n_pond, False,
                                    "cannot estimate sample rate — no valid tempo/weight timestamps"))
            else:
                # Synthesise timestamps from row index + sample rate
                df_p = df_p.copy()
                df_p["device_ms"] = (df_p.index / rate) * 1000.0

                # Take last PONDERING_TAIL_S seconds
                tail_start_ms = df_p["device_ms"].max() - PONDERING_TAIL_S * 1000.0
                tail = df_p[df_p["device_ms"] >= tail_start_ms]

                cadence_p, steps_p = _detect_cadence(tail, pond_thresh or tempo_thresh)
                consistent = _is_consistent(steps_p)

                if cadence_p is None:
                    sources.append(_src("pondering_end", None, len(tail), False,
                                        "too few steps detected in last 15 s"))
                elif not consistent:
                    sources.append(_src("pondering_end", cadence_p, len(tail), False,
                                        "inconsistent step rhythm — possible non-walking"))
                elif reference_bpm is not None and abs(cadence_p - reference_bpm) > MAX_POND_OFFSET_BPM:
                    sources.append(_src("pondering_end", cadence_p, len(tail), False,
                                        f"cadence {cadence_p:.1f} BPM differs from "
                                        f"condition baseline {reference_bpm:.1f} BPM "
                                        f"(>{MAX_POND_OFFSET_BPM} BPM gap)"))
                else:
                    sources.append(_src("pondering_end", cadence_p, len(tail), True))
                    bpm_values.append(cadence_p)
        except Exception as exc:
            sources.append(_src("pondering_end", None, 0, False, str(exc)))

    if not bpm_values:
        return {
            "baseline_bpm": None,
            "sources": sources,
            "error": "No valid baseline sources found",
        }

    return {
        "baseline_bpm": round(sum(bpm_values) / len(bpm_values), 1),
        "sources": sources,
        "error": None,
    }
