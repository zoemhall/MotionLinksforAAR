"""Calibration file reliability scoring.

Analyses a Max/MSP pressure calibration CSV (typically 10 s, recorded while
the participant walks at 95 BPM) and returns a 0–100 reliability score
comparing detected step cadence against the expected 95 BPM.

Both over-detection and under-detection are penalised equally (symmetric
deviation). A score < 60 triggers the `uncalibrated` flag, which means the
threshold bounds embedded in the file are likely wrong.
"""
from __future__ import annotations
from pathlib import Path

from merge.merger import parse_max_pressure_file, _is_max_format

EXPECTED_CADENCE_BPM: float = 95.0

# Events within this window are merged into a single step.
# At 95 BPM the step interval is ~631 ms; toe + heel on the same foot fire
# within ~50–150 ms of each other, so 300 ms safely collapses them.
DEDUP_MS: float = 300.0

# Scores below this are flagged as uncalibrated.
UNCALIBRATED_THRESHOLD: float = 60.0

_ZONES = ("L_toe", "L_heel", "R_toe", "R_heel")


def _error_result(message: str) -> dict:
    return {
        "score": 0.0,
        "detected_cadence": 0.0,
        "expected_cadence": EXPECTED_CADENCE_BPM,
        "detected_steps": 0,
        "expected_steps": 0.0,
        "duration_s": 0.0,
        "thresholds": [],
        "uncalibrated": True,
        "error": message,
    }


def analyse_calibration_file(file_path: str | Path) -> dict:
    """Analyse a single calibration pressure file.

    Returns a dict with keys:
        score            float  0–100 (100 = perfect match to 95 BPM)
        detected_cadence float  BPM actually detected
        expected_cadence float  Always 95.0
        detected_steps   int
        expected_steps   float
        duration_s       float
        thresholds       list[{zone, label, lower, upper}]
        uncalibrated     bool   True if score < 60 or thresholds invalid
        error            str|None
    """
    path = Path(file_path)

    if not path.exists():
        return _error_result("File not found")

    try:
        if not _is_max_format(path):
            return _error_result("Not a Max/MSP format file — no threshold data to analyse")
        df, thresholds, _ = parse_max_pressure_file(path)
    except Exception as exc:
        return _error_result(str(exc))

    # Validate thresholds: need all 4 zones with lower < upper and lower > 0
    if len(thresholds) < 4 or any(
        t["lower"] <= 0 or t["upper"] <= t["lower"] for t in thresholds
    ):
        return {
            "score": 0.0,
            "detected_cadence": 0.0,
            "expected_cadence": EXPECTED_CADENCE_BPM,
            "detected_steps": 0,
            "expected_steps": 0.0,
            "duration_s": 0.0,
            "thresholds": thresholds,
            "uncalibrated": True,
            "error": "Invalid or zero threshold values — file may not be calibrated yet",
        }

    thresh = {t["zone"]: t for t in thresholds}

    # Duration
    ms_values = df["device_ms"].dropna()
    if ms_values.empty:
        return _error_result("No valid timestamps in file")

    duration_ms = float(ms_values.max() - ms_values.min())
    if duration_ms <= 0:
        return _error_result("File has zero duration")

    duration_s = duration_ms / 1000.0
    duration_min = duration_ms / 60_000.0
    expected_steps = EXPECTED_CADENCE_BPM * duration_min

    # ── Step detection ────────────────────────────────────────────────────────
    # Track per-zone hysteresis state. For latency estimation we also record,
    # for each zone, the timestamp when pressure first crossed the LOWER bound
    # (foot starting to load) so we can compare it to when the UPPER bound is
    # crossed (detection fires).
    rows = df.to_dict("records")
    above: dict[str, bool] = {z: False for z in _ZONES}
    lower_cross_ms: dict[str, float | None] = {z: None for z in _ZONES}

    # raw_events: list of (detection_ms, detection_lag_ms)
    # detection_lag = time from lower-crossing to upper-crossing for the
    # zone that fired first in this step — approximates threshold-induced
    # detection delay (how long the pressure must build before the system reacts).
    raw_events: list[tuple[float, float | None]] = []

    for row in rows:
        ms = float(row.get("device_ms", 0))
        for zone in _ZONES:
            t = thresh.get(zone)
            if t is None:
                continue
            val = float(row.get(zone, 0) or 0)

            if not above[zone]:
                # Track when pressure first starts loading (crosses lower)
                if lower_cross_ms[zone] is None and val >= t["lower"]:
                    lower_cross_ms[zone] = ms
                # Detection fires when pressure crosses upper
                if val > t["upper"]:
                    above[zone] = True
                    lag = (ms - lower_cross_ms[zone]) if lower_cross_ms[zone] is not None else None
                    raw_events.append((ms, lag))
            else:
                # Reset when foot lifts off (drops below lower)
                if val < t["lower"]:
                    above[zone] = False
                    lower_cross_ms[zone] = None

    # Deduplicate: merge events within DEDUP_MS into one step, keeping the
    # smallest lag value (the zone that fired first carries the best lag estimate)
    raw_events.sort(key=lambda e: e[0])
    deduped_ms: list[float] = []
    deduped_lags: list[float] = []

    for ts, lag in raw_events:
        if not deduped_ms or ts - deduped_ms[-1] >= DEDUP_MS:
            deduped_ms.append(ts)
            if lag is not None:
                deduped_lags.append(lag)
        else:
            # Same step — keep the minimum lag (first zone to complete)
            if lag is not None and (not deduped_lags or lag < deduped_lags[-1]):
                if deduped_lags:
                    deduped_lags[-1] = lag
                else:
                    deduped_lags.append(lag)

    detected_steps = len(deduped_ms)
    detected_cadence = detected_steps / duration_min if duration_min > 0 else 0.0

    # ── Score ─────────────────────────────────────────────────────────────────
    if expected_steps > 0:
        deviation = abs(detected_steps - expected_steps) / expected_steps
        score = max(0.0, round(100.0 * (1.0 - min(1.0, deviation)), 1))
    else:
        score = 0.0

    # ── Latency estimates ─────────────────────────────────────────────────────
    # 1. Detection lag: lower→upper crossing time per step (threshold-induced
    #    delay — how long after first foot-loading the detection fires).
    # 2. Cadence jitter: std deviation of inter-step intervals. At a perfect
    #    95 BPM the interval is ~631 ms; jitter reflects timing inconsistency
    #    in the sensor/pipeline.
    latency: dict | None = None
    if detected_steps >= 3:
        lag_mean = round(sum(deduped_lags) / len(deduped_lags), 1) if deduped_lags else None

        intervals = [deduped_ms[i + 1] - deduped_ms[i] for i in range(len(deduped_ms) - 1)]
        expected_interval_ms = 60_000.0 / EXPECTED_CADENCE_BPM
        mean_interval = sum(intervals) / len(intervals)
        variance = sum((x - mean_interval) ** 2 for x in intervals) / len(intervals)
        jitter_ms = round(variance ** 0.5, 1)
        mean_interval_ms = round(mean_interval, 1)
        timing_offset_ms = round(mean_interval - expected_interval_ms, 1)

        latency = {
            # How long pressure must build before the threshold triggers (ms).
            # Lower = threshold set closer to initial contact → faster response.
            "detection_lag_ms": lag_mean,
            # Std deviation of inter-step intervals. Ideal = 0; high = jittery.
            "cadence_jitter_ms": jitter_ms,
            # Mean observed step interval vs the 631 ms expected at 95 BPM.
            "mean_interval_ms": mean_interval_ms,
            "expected_interval_ms": round(expected_interval_ms, 1),
            # Positive = steps detected later than expected (sluggish detection).
            # Negative = steps detected earlier (thresholds may be too sensitive).
            "timing_offset_ms": timing_offset_ms,
        }

    return {
        "score": score,
        "detected_cadence": round(detected_cadence, 1),
        "expected_cadence": EXPECTED_CADENCE_BPM,
        "detected_steps": detected_steps,
        "expected_steps": round(expected_steps, 1),
        "duration_s": round(duration_s, 1),
        "thresholds": thresholds,
        "latency": latency,
        "uncalibrated": score < UNCALIBRATED_THRESHOLD,
        "error": None,
    }
