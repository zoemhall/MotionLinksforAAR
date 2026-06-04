"""Tests for consciousness check and ratings questionnaire endpoints."""
from __future__ import annotations
import pytest
from tests.conftest import make_participant, make_session

CONSCIOUSNESS = {
    "post_calibration_noticed": 0,
    "post_calibration_text": "",
    "cond1_noticed": 1,
    "cond1_guess": "speeding_up",
    "cond1_text": "it felt faster",
    "cond2_noticed": 0,
    "cond2_guess": None,
    "cond2_text": "",
    "post_session_noticed": 1,
    "post_session_text": "",
    "post_session_tempo_guess": "speeding_up",
    "post_session_weight_guess": "heavier",
}

RATINGS = {
    "agency_q1": 7,
    "agency_q2": 8,
    "agency_q3": 6,
    "ueqs_items": [5, 6, 4, 5],
    "ari_items": [3, 4, 5],
}


async def _setup(client, pid):
    await make_participant(client, pid)
    return await make_session(client, pid, test_type_id=3)


async def test_submit_consciousness_201(client):
    session = await _setup(client, "30")
    sid = session["session_id"]

    r = await client.post(f"/api/questionnaires/{sid}/consciousness", json=CONSCIOUSNESS)
    assert r.status_code == 201, r.text

    r2 = await client.get(f"/api/questionnaires/{sid}")
    assert r2.status_code == 200
    body = r2.json()
    assert body.get("consciousness") is not None


async def test_submit_consciousness_twice_409(client):
    session = await _setup(client, "31")
    sid = session["session_id"]

    r1 = await client.post(f"/api/questionnaires/{sid}/consciousness", json=CONSCIOUSNESS)
    assert r1.status_code == 201

    r2 = await client.post(f"/api/questionnaires/{sid}/consciousness", json=CONSCIOUSNESS)
    assert r2.status_code == 409, "Second consciousness submission should be rejected"


async def test_submit_ratings_201(client):
    session = await _setup(client, "32")
    sid = session["session_id"]

    r = await client.post(f"/api/questionnaires/{sid}/ratings", json=RATINGS)
    assert r.status_code == 201, r.text

    body = r.json()
    expected_avg = round((7 + 8 + 6) / 3, 4)
    assert abs(body["agency_aggregate"] - expected_avg) < 0.01


async def test_submit_ratings_twice_409(client):
    session = await _setup(client, "33")
    sid = session["session_id"]

    r1 = await client.post(f"/api/questionnaires/{sid}/ratings", json=RATINGS)
    assert r1.status_code == 201

    r2 = await client.post(f"/api/questionnaires/{sid}/ratings", json=RATINGS)
    assert r2.status_code == 409, "Second ratings submission should be rejected"


async def test_session_complete_after_both(client):
    """Session status becomes 'complete' after both questionnaire parts are submitted."""
    session = await _setup(client, "34")
    sid = session["session_id"]

    await client.post(f"/api/questionnaires/{sid}/consciousness", json=CONSCIOUSNESS)
    await client.post(f"/api/questionnaires/{sid}/ratings", json=RATINGS)

    r = await client.get(f"/api/sessions/{sid}")
    assert r.status_code == 200
    assert r.json()["status"] == "complete", \
        f"Expected 'complete', got '{r.json()['status']}'"


async def test_questionnaire_session_not_found(client):
    r = await client.post("/api/questionnaires/9999/consciousness", json=CONSCIOUSNESS)
    assert r.status_code == 404


async def test_get_questionnaire_summary(client):
    """GET /questionnaires/{id} returns combined summary even when empty."""
    session = await _setup(client, "35")
    sid = session["session_id"]

    r = await client.get(f"/api/questionnaires/{sid}")
    assert r.status_code == 200
