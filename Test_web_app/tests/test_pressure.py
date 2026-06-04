"""Tests for pressure CSV upload, merge, and confirm endpoints."""
from __future__ import annotations
import csv
import io
import json
import pytest
from tests.conftest import make_participant, make_session, make_pressure_only_test_type

# A minimal valid Max-format pressure file (semicolon-separated records)
VALID_MAX_CSV = ";".join(
    f"{i}, {1630 + i * 115}. 0 0 0 {300 + i}"
    for i in range(20)
) + ";"

# A minimal standard CSV pressure file (for sessions that don't use Max format)
VALID_STD_CSV = "device_ms,L_toe,L_heel,R_toe,R_heel\n1000,100,200,150,180\n2000,110,210,160,190\n"


def _imu_csv(rows: list[dict]) -> str:
    if not rows:
        return "device_ms,ax,ay,az,gx,gy,gz,toe,heel,phase\n"
    buf = io.StringIO()
    w = csv.DictWriter(buf, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)
    return buf.getvalue()


def _pressure_csv(device_ms_values: list[float]) -> str:
    rows = [{"device_ms": ms, "L_toe": 10, "L_heel": 20, "R_toe": 15, "R_heel": 18}
            for ms in device_ms_values]
    buf = io.StringIO()
    w = csv.DictWriter(buf, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)
    return buf.getvalue()


async def test_upload_valid_max_csv(client, tmp_path):
    """Upload a Max-format pressure CSV → 200."""
    tt = await make_pressure_only_test_type(client)
    await make_participant(client, "20")
    session = await make_session(client, "20", test_type_id=tt["test_type_id"])
    sid = session["session_id"]

    r = await client.post(
        f"/api/pressure/{sid}/upload",
        files={"file": ("pressure.csv", VALID_MAX_CSV.encode(), "text/csv")},
    )
    assert r.status_code == 200, r.text
    assert r.json()["ok"] is True


async def test_upload_invalid_csv(client, tmp_path):
    """Upload garbage → 422."""
    tt = await make_pressure_only_test_type(client)
    await make_participant(client, "21")
    session = await make_session(client, "21", test_type_id=tt["test_type_id"])
    sid = session["session_id"]

    r = await client.post(
        f"/api/pressure/{sid}/upload",
        files={"file": ("pressure.csv", b"not,a,valid,pressure,file\nwith,wrong,columns\n", "text/csv")},
    )
    assert r.status_code == 422, r.text


async def test_merge_no_imu_required(client, db, tmp_path):
    """Session with has_imu_dump=0: merge returns 200 with IMU-not-required warning."""
    tt = await make_pressure_only_test_type(client)
    await make_participant(client, "22")
    session = await make_session(client, "22", test_type_id=tt["test_type_id"])
    sid = session["session_id"]

    # Upload the pressure file first so pressure_raw_path is set
    r = await client.post(
        f"/api/pressure/{sid}/upload",
        files={"file": ("pressure.csv", VALID_MAX_CSV.encode(), "text/csv")},
    )
    assert r.status_code == 200, r.text

    # Merge should succeed without IMU
    r = await client.post(f"/api/pressure/{sid}/merge")
    assert r.status_code == 200, r.text
    body = r.json()
    assert any("imu not required" in w.lower() for w in body.get("warnings", []))


async def test_merge_non_overlapping_no_500(client, db, tmp_path):
    """Non-overlapping IMU + pressure timestamps → 200 with overlap warning, NOT a 500."""
    await make_participant(client, "23")
    session = await make_session(client, "23", test_type_id=1)
    sid = session["session_id"]

    # Write non-overlapping CSVs directly to tmp_path
    session_data = (await client.get(f"/api/sessions/{sid}")).json()
    from db.paths import session_raw_folder
    from unittest.mock import patch
    import db.paths as paths_module

    folder = tmp_path / "Test 1" / "Raw data" / "23"
    folder.mkdir(parents=True, exist_ok=True)

    imu_path = folder / "23_imu_R.csv"
    imu_rows = [{"device_ms": ms, "ax": 0.1, "ay": 0.2, "az": 0.3,
                 "gx": 0.1, "gy": 0.1, "gz": 0.1, "toe": 0, "heel": 100, "phase": 0}
                for ms in range(30000, 40000, 20)]
    imu_path.write_text(_imu_csv(imu_rows))

    pressure_path = folder / "23_pressure.csv"
    pressure_path.write_text(_pressure_csv(list(range(1000, 5000, 50))))

    # Set paths directly in DB
    await db.execute(
        "UPDATE sessions SET imu_raw_path=?, pressure_raw_path=? WHERE session_id=?",
        (str(imu_path), str(pressure_path), sid),
    )
    await db.commit()

    r = await client.post(f"/api/pressure/{sid}/merge")
    assert r.status_code == 200, f"Expected 200, got {r.status_code}: {r.text}"

    body = r.json()
    assert any("overlap" in w.lower() for w in body.get("warnings", []))


async def test_merge_response_no_nan(client, db, tmp_path):
    """NaN regression: all preview values must be JSON-safe (None or scalar), not float('nan')."""
    await make_participant(client, "24")
    session = await make_session(client, "24", test_type_id=1)
    sid = session["session_id"]

    folder = tmp_path / "Test 1" / "Raw data" / "24"
    folder.mkdir(parents=True, exist_ok=True)

    # Non-overlapping so merged pressure columns will be NaN in raw pandas output
    imu_path = folder / "24_imu_R.csv"
    imu_rows = [{"device_ms": ms, "ax": 0.1, "ay": 0.2, "az": 0.3,
                 "gx": 0.0, "gy": 0.0, "gz": 0.0, "toe": 0, "heel": 50, "phase": 0}
                for ms in range(50000, 55000, 20)]
    imu_path.write_text(_imu_csv(imu_rows))

    pressure_path = folder / "24_pressure.csv"
    pressure_path.write_text(_pressure_csv(list(range(1000, 3000, 50))))

    await db.execute(
        "UPDATE sessions SET imu_raw_path=?, pressure_raw_path=? WHERE session_id=?",
        (str(imu_path), str(pressure_path), sid),
    )
    await db.commit()

    r = await client.post(f"/api/pressure/{sid}/merge")
    assert r.status_code == 200, f"Expected 200, got {r.status_code}: {r.text}"

    # Response body must be valid strict JSON (no NaN literals)
    body_text = r.text
    parsed = json.loads(body_text)  # would raise if NaN values exist

    for row in parsed.get("preview", []):
        for key, val in row.items():
            assert not (isinstance(val, float) and val != val), \
                f"NaN in preview row key={key!r}"


async def test_confirm_merge(client, db, tmp_path):
    """Confirm merge → session status becomes 'merged'."""
    await make_participant(client, "25")
    session = await make_session(client, "25", test_type_id=1)
    sid = session["session_id"]

    folder = tmp_path / "Test 1" / "Raw data" / "25"
    folder.mkdir(parents=True, exist_ok=True)

    # Write overlapping CSVs so the merge succeeds cleanly
    imu_path = folder / "25_imu_R.csv"
    imu_rows = [{"device_ms": ms, "ax": 0.1, "ay": 0.2, "az": 0.3,
                 "gx": 0.0, "gy": 0.0, "gz": 0.0, "toe": 0, "heel": 50, "phase": 0}
                for ms in range(1000, 5000, 20)]
    imu_path.write_text(_imu_csv(imu_rows))

    pressure_path = folder / "25_pressure.csv"
    pressure_path.write_text(_pressure_csv(list(range(1000, 5000, 50))))

    await db.execute(
        "UPDATE sessions SET imu_raw_path=?, pressure_raw_path=? WHERE session_id=?",
        (str(imu_path), str(pressure_path), sid),
    )
    await db.commit()

    r = await client.post(f"/api/pressure/{sid}/merge")
    assert r.status_code == 200, r.text

    r = await client.post(f"/api/pressure/{sid}/confirm")
    assert r.status_code == 200, r.text
    assert r.json()["status"] == "merged"

    r = await client.get(f"/api/sessions/{sid}")
    assert r.json()["status"] == "merged"
