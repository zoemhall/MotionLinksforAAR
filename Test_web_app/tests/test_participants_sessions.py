"""Tests for participant and session CRUD, trash/restore, notes, and stage events."""
from __future__ import annotations
import pytest
from tests.conftest import make_participant, make_session


async def test_create_participant_and_session(client):
    await make_participant(client, "01")
    session = await make_session(client, "01")
    assert session["participant_id"] == "01"
    assert session["session_id"] is not None

    r = await client.get("/api/sessions")
    assert r.status_code == 200
    ids = [s["session_id"] for s in r.json()]
    assert session["session_id"] in ids

    r2 = await client.get(f"/api/sessions/{session['session_id']}")
    assert r2.status_code == 200
    assert r2.json()["session_id"] == session["session_id"]


async def test_create_session_invalid_participant(client):
    r = await client.post("/api/sessions", json={
        "participant_id": "99",
        "test_type_id": 1,
    })
    assert r.status_code == 400
    assert "does not exist" in r.json()["detail"].lower() or "99" in r.json()["detail"]


async def test_trash_route_not_cast_as_int(client):
    """Regression: GET /sessions/trash must return 200 list, not 422 (was route ordering bug)."""
    r = await client.get("/api/sessions/trash")
    assert r.status_code == 200
    assert isinstance(r.json(), list)


async def test_delete_moves_to_trash(client):
    await make_participant(client, "02")
    session = await make_session(client, "02")
    sid = session["session_id"]

    r = await client.delete(f"/api/sessions/{sid}")
    assert r.status_code == 200
    assert r.json()["ok"] is True

    # Not in main list
    r = await client.get("/api/sessions")
    ids = [s["session_id"] for s in r.json()]
    assert sid not in ids

    # In trash
    r = await client.get("/api/sessions/trash")
    trash_ids = [s["session_id"] for s in r.json()]
    assert sid in trash_ids


async def test_restore_from_trash(client):
    await make_participant(client, "03")
    session = await make_session(client, "03")
    sid = session["session_id"]

    await client.delete(f"/api/sessions/{sid}")

    r = await client.post(f"/api/sessions/{sid}/restore")
    assert r.status_code == 200

    # Back in main list
    r = await client.get("/api/sessions")
    ids = [s["session_id"] for s in r.json()]
    assert sid in ids

    # Not in trash
    r = await client.get("/api/sessions/trash")
    trash_ids = [s["session_id"] for s in r.json()]
    assert sid not in trash_ids


async def test_session_notes_patch(client):
    await make_participant(client, "04")
    session = await make_session(client, "04")
    sid = session["session_id"]

    r = await client.patch(f"/api/sessions/{sid}/notes", json={
        "notes_setup": "size 8 insole",
        "notes_use": "participant was fidgety",
        "notes_data": "good signal",
        "notes": "general note",
    })
    assert r.status_code == 200
    assert r.json()["ok"] is True

    r2 = await client.get(f"/api/sessions/{sid}")
    data = r2.json()
    assert data["notes_setup"] == "size 8 insole"
    assert data["notes_use"] == "participant was fidgety"


async def test_stage_event_session_start_allowed(client):
    """Regression: session_start stage_id must be accepted after schema fix."""
    await make_participant(client, "05")
    session = await make_session(client, "05")
    sid = session["session_id"]

    r = await client.post(f"/api/sessions/{sid}/stage_events", json={
        "stage_id": "session_start",
        "device_ms": 12345.0,
    })
    assert r.status_code == 201, f"session_start rejected: {r.text}"


async def test_stage_event_session_end_allowed(client):
    """Regression: session_end stage_id must be accepted after schema fix."""
    await make_participant(client, "06")
    session = await make_session(client, "06")
    sid = session["session_id"]

    r = await client.post(f"/api/sessions/{sid}/stage_events", json={
        "stage_id": "session_end",
        "device_ms": 99999.0,
    })
    assert r.status_code == 201, f"session_end rejected: {r.text}"


async def test_stage_event_standard_ids_allowed(client):
    """Standard stage IDs (calibration, condition_1, etc.) still work."""
    await make_participant(client, "07")
    session = await make_session(client, "07")
    sid = session["session_id"]

    for stage_id in ("calibration", "condition_1", "condition_2", "audio_only"):
        r = await client.post(f"/api/sessions/{sid}/stage_events", json={
            "stage_id": stage_id,
            "device_ms": 1000.0,
        })
        assert r.status_code == 201, f"stage_id '{stage_id}' rejected: {r.text}"


async def test_list_stage_events(client):
    await make_participant(client, "08")
    session = await make_session(client, "08")
    sid = session["session_id"]

    await client.post(f"/api/sessions/{sid}/stage_events", json={"stage_id": "session_start", "device_ms": 1000.0})
    await client.post(f"/api/sessions/{sid}/stage_events", json={"stage_id": "calibration", "device_ms": 2000.0})

    r = await client.get(f"/api/sessions/{sid}/stage_events")
    assert r.status_code == 200
    events = r.json()
    assert len(events) == 2
    stage_ids = [e["stage_id"] for e in events]
    assert "session_start" in stage_ids
    assert "calibration" in stage_ids
