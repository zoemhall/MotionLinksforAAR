from __future__ import annotations
import asyncio
import json

from fastapi import APIRouter, WebSocket, WebSocketDisconnect

from ble.manager import ble_manager
from config import WS_DOWNSAMPLE_EVERY

router = APIRouter()


@router.websocket("/ws/imu")
async def imu_stream(websocket: WebSocket):
    await websocket.accept()
    q = ble_manager.subscribe()
    counter = 0
    batch: list[dict] = []

    try:
        while True:
            row = await q.get()
            counter += 1
            batch.append(row)

            # Send a batch every WS_DOWNSAMPLE_EVERY samples
            if counter % WS_DOWNSAMPLE_EVERY == 0:
                await websocket.send_text(json.dumps({
                    "type": "imu_batch",
                    "samples": batch,
                    "ble_status": ble_manager.status,
                    "dropped_packets": ble_manager.dropped_packets,
                    "latency": ble_manager.latency_stats,
                }))
                batch = []
    except WebSocketDisconnect:
        pass
    except asyncio.CancelledError:
        pass
    finally:
        ble_manager.unsubscribe(q)
