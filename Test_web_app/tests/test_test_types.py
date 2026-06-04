"""Tests for test type feature flags and session creation validation."""
from __future__ import annotations
import pytest
from tests.conftest import make_participant


async def test_seed_data_loaded(client):
    """Three test types must be present from schema seeds."""
    r = await client.get("/api/test_types")
    assert r.status_code == 200
    types = r.json()
    assert len(types) == 3
    names = [t["name"] for t in types]
    assert any("Test 1" in n for n in names)
    assert any("Test 2" in n for n in names)
    assert any("Test 3" in n for n in names)


async def test_session_no_conditions_when_not_required(client):
    """test_type_id=1 (has_condition_1=0) — session created without condition fields."""
    await make_participant(client, "10")
    r = await client.post("/api/sessions", json={
        "participant_id": "10",
        "test_type_id": 1,
    })
    assert r.status_code == 201, r.text


async def test_session_requires_conditions_when_flagged(client):
    """test_type_id=3 (has_condition_1=1) — missing condition fields → 400."""
    await make_participant(client, "11")
    r = await client.post("/api/sessions", json={
        "participant_id": "11",
        "test_type_id": 3,
        # no condition_order, tempo_direction, weight_direction
    })
    assert r.status_code == 400
    assert "condition" in r.json()["detail"].lower()


async def test_session_snapshots_flags(client):
    """Session row carries has_condition_1 copied from the test type at creation."""
    await make_participant(client, "12")

    # Test type 1 has has_condition_1=0
    r1 = await client.post("/api/sessions", json={"participant_id": "12", "test_type_id": 1})
    assert r1.status_code == 201
    assert r1.json()["has_condition_1"] == 0

    # Test type 3 has has_condition_1=1
    r3 = await client.post("/api/sessions", json={
        "participant_id": "12",
        "test_type_id": 3,
        "condition_order": "A-first",
        "tempo_direction": "speeding_up",
        "weight_direction": "increasing",
    })
    assert r3.status_code == 201
    assert r3.json()["has_condition_1"] == 1


async def test_create_custom_test_type(client):
    """Custom test type can be created and retrieved."""
    r = await client.post("/api/test_types", json={
        "name": "My Custom Test",
        "description": "for testing",
        "has_calibration": 1,
        "has_audio_familiarisation": 0,
        "has_condition_1": 0,
        "has_condition_2": 0,
        "has_imu_dump": 0,
        "has_pressure_merge": 1,
        "has_consciousness_check": 0,
        "has_overall_ratings": 0,
    })
    assert r.status_code == 201, r.text
    tt = r.json()
    assert tt["name"] == "My Custom Test"
    assert tt["has_imu_dump"] == 0
    assert tt["has_pressure_merge"] == 1


async def test_get_test_type_404(client):
    r = await client.get("/api/test_types/9999")
    assert r.status_code == 404
