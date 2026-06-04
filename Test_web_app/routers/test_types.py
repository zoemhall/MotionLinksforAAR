"""Test type templates: configurable presets that determine which stages
and questionnaires are part of a session."""
from fastapi import APIRouter, HTTPException

from db.models import TestTypeCreate, TestTypeUpdate
from db import queries

router = APIRouter()


@router.get("")
async def list_test_types(include_archived: bool = False):
    return await queries.list_test_types(include_archived=include_archived)


@router.get("/{test_type_id}")
async def get_test_type(test_type_id: int):
    t = await queries.get_test_type(test_type_id)
    if not t:
        raise HTTPException(status_code=404, detail="Test type not found")
    return t


@router.post("", status_code=201)
async def create_test_type(body: TestTypeCreate):
    return await queries.create_test_type(
        name=body.name,
        description=body.description,
        target_participants=body.target_participants,
        has_calibration=body.has_calibration,
        has_audio_familiarisation=body.has_audio_familiarisation,
        has_condition_1=body.has_condition_1,
        has_condition_2=body.has_condition_2,
        has_imu_dump=body.has_imu_dump,
        has_pressure_merge=body.has_pressure_merge,
        has_consciousness_check=body.has_consciousness_check,
        has_overall_ratings=body.has_overall_ratings,
    )


@router.put("/{test_type_id}")
async def update_test_type(test_type_id: int, body: TestTypeUpdate):
    existing = await queries.get_test_type(test_type_id)
    if not existing:
        raise HTTPException(status_code=404, detail="Test type not found")
    return await queries.update_test_type(
        test_type_id,
        name=body.name,
        description=body.description,
        target_participants=body.target_participants,
        has_calibration=body.has_calibration,
        has_audio_familiarisation=body.has_audio_familiarisation,
        has_condition_1=body.has_condition_1,
        has_condition_2=body.has_condition_2,
        has_imu_dump=body.has_imu_dump,
        has_pressure_merge=body.has_pressure_merge,
        has_consciousness_check=body.has_consciousness_check,
        has_overall_ratings=body.has_overall_ratings,
    )


@router.delete("/{test_type_id}")
async def archive_test_type(test_type_id: int):
    existing = await queries.get_test_type(test_type_id)
    if not existing:
        raise HTTPException(status_code=404, detail="Test type not found")
    await queries.archive_test_type(test_type_id)
    return {"ok": True, "archived": True}
