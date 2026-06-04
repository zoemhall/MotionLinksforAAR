"""Pure unit tests for merge_session() in merge/merger.py.

No HTTP, no DB. Uses tmp_path for temporary CSV files.
"""
from __future__ import annotations
import csv
import io
import json
import math
import pytest
from pathlib import Path
from merge.merger import merge_session


# ── Helpers ───────────────────────────────────────────────────────────────────

def _write_imu(path: Path, device_ms_values: list[int], phases: list[int] | None = None) -> None:
    rows = [
        {
            "device_ms": ms,
            "ax": 0.1, "ay": 0.2, "az": 0.9,
            "gx": 0.1, "gy": 0.0, "gz": 0.0,
            "toe": 0, "heel": 100,
            "phase": (phases[i] if phases else 0),
        }
        for i, ms in enumerate(device_ms_values)
    ]
    buf = io.StringIO()
    w = csv.DictWriter(buf, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)
    path.write_text(buf.getvalue())


def _write_pressure(path: Path, device_ms_values: list[float]) -> None:
    rows = [
        {"device_ms": ms, "L_toe": 100, "L_heel": 200, "R_toe": 150, "R_heel": 180}
        for ms in device_ms_values
    ]
    buf = io.StringIO()
    w = csv.DictWriter(buf, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)
    path.write_text(buf.getvalue())


def _no_nan(preview: list[dict]) -> bool:
    """Return True only if no NaN values exist in the preview."""
    for row in preview:
        for val in row.values():
            if isinstance(val, float) and math.isnan(val):
                return False
    return True


# ── Tests ─────────────────────────────────────────────────────────────────────

def test_overlapping_timestamps(tmp_path):
    """Matching IMU + pressure timestamps → rows merged, total_rows > 0."""
    imu = tmp_path / "imu.csv"
    pressure = tmp_path / "pressure.csv"
    output = tmp_path / "merged.csv"

    ms = list(range(1000, 5000, 20))
    _write_imu(imu, ms)
    _write_pressure(pressure, [float(m + 1) for m in ms])  # +1ms offset

    preview, warnings, total_rows, calibration, sync_alignment, per_stage = merge_session(
        imu, pressure, output
    )

    assert total_rows > 0
    assert output.exists()
    # Preview must be JSON-serialisable
    json.dumps(preview)


def test_non_overlapping_no_exception(tmp_path):
    """Non-overlapping timestamps must NOT raise — just produce an overlap warning."""
    imu = tmp_path / "imu.csv"
    pressure = tmp_path / "pressure.csv"
    output = tmp_path / "merged.csv"

    _write_imu(imu, list(range(30000, 40000, 20)))      # 30–40 s
    _write_pressure(pressure, list(range(1000, 5000, 50)))  # 1–5 s

    # Must not raise
    preview, warnings, total_rows, *_ = merge_session(imu, pressure, output)

    overlap_warnings = [w for w in warnings if "overlap" in w.lower()]
    assert len(overlap_warnings) > 0, "Expected an overlap warning"


def test_preview_no_nan_values(tmp_path):
    """NaN regression: preview rows must contain None, not float('nan').

    Non-overlapping data forces merge_asof to produce NaN in pressure columns
    for every IMU row. The fixed code converts those to None before serialising.
    """
    imu = tmp_path / "imu.csv"
    pressure = tmp_path / "pressure.csv"
    output = tmp_path / "merged.csv"

    _write_imu(imu, list(range(50000, 53000, 10)))
    _write_pressure(pressure, list(range(1000, 4000, 10)))

    preview, warnings, *_ = merge_session(imu, pressure, output)

    for row in preview:
        for key, val in row.items():
            assert not (isinstance(val, float) and math.isnan(val)), \
                f"NaN found in preview row (key={key!r}). The NaN→None fix may be broken."

    # Also confirm JSON serialisation works with allow_nan=False
    json.dumps(preview, allow_nan=False)


def test_preview_json_serialisable_overlapping(tmp_path):
    """Even with overlapping data, preview must be JSON-safe."""
    imu = tmp_path / "imu.csv"
    pressure = tmp_path / "pressure.csv"
    output = tmp_path / "merged.csv"

    ms = list(range(1000, 3000, 20))
    _write_imu(imu, ms)
    _write_pressure(pressure, [float(m) for m in ms])

    preview, *_ = merge_session(imu, pressure, output)

    json.dumps(preview, allow_nan=False)  # must not raise


def test_stage_annotation_with_session_boundaries(tmp_path):
    """Stage events with session_start/session_end → stage column populated."""
    imu = tmp_path / "imu.csv"
    pressure = tmp_path / "pressure.csv"
    output = tmp_path / "merged.csv"

    ms = list(range(1000, 5000, 20))
    _write_imu(imu, ms)
    _write_pressure(pressure, [float(m) for m in ms])

    stage_events = [
        {"stage_id": "session_start", "device_ms": 1500.0, "started_at": "2026-01-01T10:00:00"},
        {"stage_id": "calibration",   "device_ms": 2000.0, "started_at": "2026-01-01T10:00:05"},
        {"stage_id": "session_end",   "device_ms": 4500.0, "started_at": "2026-01-01T10:00:30"},
    ]

    preview, warnings, total_rows, calibration_data, sync_alignment, per_stage = merge_session(
        imu, pressure, output, stage_events
    )

    assert output.exists()
    import pandas as pd
    merged_df = pd.read_csv(output)
    assert "stage" in merged_df.columns


def test_output_file_written(tmp_path):
    """Merged CSV is written to the output path."""
    imu = tmp_path / "imu.csv"
    pressure = tmp_path / "pressure.csv"
    output = tmp_path / "merged.csv"

    _write_imu(imu, list(range(1000, 2000, 20)))
    _write_pressure(pressure, list(range(1000, 2000, 20)))

    merge_session(imu, pressure, output)
    assert output.exists()
    assert output.stat().st_size > 0
