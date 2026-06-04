"""Pure unit tests for _annotate_zones() in routers/imu_dump.py.

No HTTP, no DB — just the zone-annotation logic in isolation.
"""
from __future__ import annotations
import csv
import io
import pytest
from routers.imu_dump import _annotate_zones

MINIMAL_CSV = "device_ms,ax,ay\n100.0,1,2\n200.0,3,4\n300.0,5,6\n"


def _parse(csv_text: str) -> list[dict]:
    reader = csv.DictReader(csv_text.splitlines())
    return list(reader)


def test_no_events_adds_side_column():
    result = _annotate_zones(MINIMAL_CSV, "R", [])
    rows = _parse(result)

    assert len(rows) == 3
    assert all(r["side"] == "R" for r in rows), "side column must be populated"
    assert all(r["stage"] == "" for r in rows), "stage must be empty with no events"


def test_no_events_left_insole():
    result = _annotate_zones(MINIMAL_CSV, "L", [])
    rows = _parse(result)
    assert all(r["side"] == "L" for r in rows)


def test_session_boundaries():
    """session_start=150, session_end=250 → row@100=pre_session, row@300=post_session."""
    events = [
        {"stage_id": "session_start", "device_ms": 150.0},
        {"stage_id": "session_end",   "device_ms": 250.0},
    ]
    result = _annotate_zones(MINIMAL_CSV, "R", events)
    rows = _parse(result)

    assert rows[0]["stage"] == "pre_session"   # 100ms < 150ms
    assert rows[2]["stage"] == "post_session"  # 300ms >= 250ms


def test_session_boundary_middle_row():
    """Row between session_start and session_end with no checkpoints → pre_stage."""
    events = [
        {"stage_id": "session_start", "device_ms": 50.0},
        {"stage_id": "session_end",   "device_ms": 350.0},
    ]
    result = _annotate_zones(MINIMAL_CSV, "R", events)
    rows = _parse(result)
    # All rows between boundaries with no checkpoints → "pre_stage"
    for r in rows:
        assert r["stage"] not in ("pre_session", "post_session"), \
            f"unexpected boundary label at {r['device_ms']}ms"


def test_duplicate_stage_ids_redo():
    """Two calibration events → first=calibration, second=calibration_redo_1."""
    csv_data = "device_ms,ax\n50.0,1\n150.0,2\n250.0,3\n"
    events = [
        {"stage_id": "calibration", "device_ms": 100.0},
        {"stage_id": "calibration", "device_ms": 200.0},
    ]
    result = _annotate_zones(csv_data, "R", events)
    rows = _parse(result)

    # 50ms → before first checkpoint
    assert rows[0]["stage"] == "pre_stage"
    # 150ms → first calibration
    assert rows[1]["stage"] == "calibration"
    # 250ms → second calibration = redo_1
    assert rows[2]["stage"] == "calibration_redo_1"


def test_triple_redo():
    """Three occurrences of same stage_id → redo_1, redo_2."""
    csv_data = "device_ms,ax\n" + "".join(f"{i*100}.0,1\n" for i in range(5))
    events = [
        {"stage_id": "condition_1", "device_ms": 50.0},
        {"stage_id": "condition_1", "device_ms": 150.0},
        {"stage_id": "condition_1", "device_ms": 350.0},
    ]
    result = _annotate_zones(csv_data, "R", events)
    rows = _parse(result)
    stages = [r["stage"] for r in rows]
    assert "condition_1" in stages
    assert "condition_1_redo_1" in stages
    assert "condition_1_redo_2" in stages


def test_events_without_device_ms_ignored():
    """Events with device_ms=None must not crash — they are silently skipped."""
    events = [
        {"stage_id": "calibration", "device_ms": None},
        {"stage_id": "session_start", "device_ms": None},
    ]
    result = _annotate_zones(MINIMAL_CSV, "R", events)
    rows = _parse(result)
    # Should produce valid output with empty stages
    assert len(rows) == 3
    assert all(r["stage"] == "" for r in rows)


def test_empty_csv_returns_unchanged():
    """Empty CSV (header only) is returned as-is."""
    empty = "device_ms,ax\n"
    result = _annotate_zones(empty, "R", [])
    assert "device_ms" in result


def test_side_column_before_stage():
    """Output CSV must have 'side' and 'stage' as first two columns."""
    result = _annotate_zones(MINIMAL_CSV, "R", [])
    header = result.splitlines()[0].split(",")
    assert header[0] == "side"
    assert header[1] == "stage"
