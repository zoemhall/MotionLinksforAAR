from fastapi import APIRouter, HTTPException
from db.models import ParticipantCreate
from db import queries

router = APIRouter()


@router.get("/{participant_id}")
async def get_participant(participant_id: str):
    p = await queries.get_participant(participant_id)
    if not p:
        raise HTTPException(status_code=404, detail="Participant not found")
    return p


@router.get("/{participant_id}/summary")
async def get_participant_summary(participant_id: str):
    """Return participant demographics + all their prior sessions."""
    p = await queries.get_participant(participant_id)
    if not p:
        raise HTTPException(status_code=404, detail="Participant not found")
    sessions = await queries.list_sessions_for_participant(participant_id)
    return {"participant": p, "sessions": sessions}


@router.delete("/{participant_id}")
async def delete_participant(participant_id: str):
    p = await queries.get_participant(participant_id)
    if not p:
        raise HTTPException(status_code=404, detail="Participant not found")
    await queries.delete_participant(participant_id)
    return {"ok": True, "participant_id": participant_id}


@router.post("", status_code=201)
async def create_participant(body: ParticipantCreate):
    existing = await queries.get_participant(body.participant_id)
    if existing:
        return await queries.update_participant(
            body.participant_id, body.shoe_size, body.insole_size,
            body.age, body.gender, body.injuries,
        )
    return await queries.create_participant(
        body.participant_id, body.shoe_size, body.insole_size,
        body.age, body.gender, body.injuries,
    )
