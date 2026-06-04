from __future__ import annotations
import csv
import io
import json

from fastapi import APIRouter, HTTPException, Response

from db.models import ConsciousnessSubmit, RatingsSubmit
from db import queries
from db.paths import session_raw_folder

router = APIRouter()


def _is_correct(guess, actual):
    """Return 1 if guess matches actual direction, 0 if not, None if no guess."""
    if guess is None or actual is None:
        return None
    guess = (guess or "").lower().replace(" ", "_")
    actual = (actual or "").lower().replace(" ", "_")
    # Tempo: speeding_up matches speeding_up; weight: increasing matches heavier
    weight_map = {"increasing": "heavier", "decreasing": "lighter"}
    actual_norm = weight_map.get(actual, actual)
    return 1 if guess == actual_norm or guess == actual else 0


async def _write_questionnaire_csv(session_id: int, session: dict):
    """Write / overwrite <pid>_questionnaire.csv with all individual item scores."""
    consciousness = await queries.get_consciousness(session_id)
    ratings = await queries.get_ratings(session_id)

    pid = session.get("participant_id", "unknown")
    folder = session_raw_folder(session)
    out_path = folder / f"{pid}_questionnaire.csv"

    # Derive condition actuals from session
    order = session.get("condition_order")
    cond1_actual = session.get("tempo_direction") if order == "A-first" else session.get("weight_direction")
    cond2_actual = session.get("weight_direction") if order == "A-first" else session.get("tempo_direction")

    # Expand raw_item_json from ratings
    ueqs_items = []
    ari_items = []
    if ratings and ratings.get("raw_item_json"):
        raw = json.loads(ratings["raw_item_json"])
        ueqs_items = raw.get("ueqs_items", [])
        ari_items = raw.get("ari_items", [])

    row = {
        "session_id":         session_id,
        "participant_id":     pid,
        "session_date":       session.get("session_date"),
        "test_type":          session.get("test_type_name"),
        "condition_order":    session.get("condition_order"),
        "tempo_direction":    session.get("tempo_direction"),
        "weight_direction":   session.get("weight_direction"),
        # Consciousness
        "post_calibration_noticed":   consciousness.get("post_calibration_noticed") if consciousness else None,
        "post_calibration_text":      consciousness.get("post_calibration_text")    if consciousness else None,
        "cond1_actual":               cond1_actual,
        "cond1_noticed":              consciousness.get("cond1_noticed")             if consciousness else None,
        "cond1_guess":                consciousness.get("cond1_guess")               if consciousness else None,
        "cond1_correct":              _is_correct(consciousness.get("cond1_guess") if consciousness else None, cond1_actual),
        "cond1_text":                 consciousness.get("cond1_text")                if consciousness else None,
        "cond2_actual":               cond2_actual,
        "cond2_noticed":              consciousness.get("cond2_noticed")             if consciousness else None,
        "cond2_guess":                consciousness.get("cond2_guess")               if consciousness else None,
        "cond2_correct":              _is_correct(consciousness.get("cond2_guess") if consciousness else None, cond2_actual),
        "cond2_text":                 consciousness.get("cond2_text")                if consciousness else None,
        "post_session_noticed":       consciousness.get("post_session_noticed")      if consciousness else None,
        "post_session_text":          consciousness.get("post_session_text")         if consciousness else None,
        "post_session_tempo_guess":   consciousness.get("post_session_tempo_guess")  if consciousness else None,
        "post_session_tempo_correct": _is_correct(consciousness.get("post_session_tempo_guess") if consciousness else None, session.get("tempo_direction")),
        "post_session_weight_guess":  consciousness.get("post_session_weight_guess") if consciousness else None,
        "post_session_weight_correct":_is_correct(consciousness.get("post_session_weight_guess") if consciousness else None, session.get("weight_direction")),
        # Ratings — individual items
        "agency_q1":        ratings.get("agency_q1")        if ratings else None,
        "agency_q2":        ratings.get("agency_q2")        if ratings else None,
        "agency_q3":        ratings.get("agency_q3")        if ratings else None,
        "agency_aggregate": ratings.get("agency_aggregate") if ratings else None,
    }
    for i, v in enumerate(ueqs_items, start=1):
        row[f"ueqs_item_{i}"] = v
    row["ueqs_pragmatic"] = ratings.get("ueqs_pragmatic") if ratings else None
    for i, v in enumerate(ari_items, start=1):
        row[f"ari_item_{i}"] = v
    row["ari_immersion"] = ratings.get("ari_immersion") if ratings else None

    buf = io.StringIO()
    writer = csv.DictWriter(buf, fieldnames=list(row.keys()))
    writer.writeheader()
    writer.writerow(row)
    out_path.write_text(buf.getvalue())


@router.get("/{session_id}")
async def get_questionnaire(session_id: int, response: Response):
    """Combined view: consciousness (with computed correctness) + ratings."""
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    # Defeat any caching so deleted/recreated sessions never see stale data.
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate"
    return await queries.get_questionnaire_summary(session_id)


@router.post("/{session_id}/consciousness", status_code=201)
async def submit_consciousness(session_id: int, body: ConsciousnessSubmit):
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    result = await queries.save_consciousness(
        session_id=session_id,
        post_calibration_noticed=body.post_calibration_noticed,
        post_calibration_text=body.post_calibration_text,
        cond1_noticed=body.cond1_noticed,
        cond1_guess=body.cond1_guess,
        cond1_text=body.cond1_text,
        cond2_noticed=body.cond2_noticed,
        cond2_guess=body.cond2_guess,
        cond2_text=body.cond2_text,
        post_session_noticed=body.post_session_noticed,
        post_session_text=body.post_session_text,
        post_session_tempo_guess=body.post_session_tempo_guess,
        post_session_weight_guess=body.post_session_weight_guess,
    )
    await _write_questionnaire_csv(session_id, session)
    return result


@router.post("/{session_id}/ratings", status_code=201)
async def submit_ratings(session_id: int, body: RatingsSubmit):
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    existing = await queries.get_ratings(session_id)
    if existing:
        raise HTTPException(
            status_code=409,
            detail="Overall ratings already submitted for this session. Responses cannot be edited.",
        )

    result = await queries.save_ratings(
        session_id=session_id,
        agency_q1=body.agency_q1,
        agency_q2=body.agency_q2,
        agency_q3=body.agency_q3,
        ueqs_items=body.ueqs_items,
        ari_items=body.ari_items,
    )
    await _write_questionnaire_csv(session_id, session)
    return result
