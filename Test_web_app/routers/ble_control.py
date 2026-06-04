from fastapi import APIRouter, HTTPException
from db.models import PhaseCommand
from ble.manager import ble_manager

router = APIRouter()


@router.get("/status")
async def ble_status():
    return {
        "status": ble_manager.status,
        "dropped_packets": ble_manager.dropped_packets,
    }


@router.post("/phase")
async def send_phase(cmd: PhaseCommand):
    try:
        await ble_manager.send_phase(cmd.phase)
    except ConnectionError as e:
        raise HTTPException(status_code=503, detail=str(e))
    return {"ok": True, "phase": cmd.phase}
