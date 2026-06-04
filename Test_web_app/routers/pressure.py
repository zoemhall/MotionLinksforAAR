from __future__ import annotations
import asyncio
import shutil
from datetime import datetime
from pathlib import Path

from fastapi import APIRouter, HTTPException, UploadFile, File

from config import DATA_DIR
from db import queries
from merge.merger import validate_pressure_csv, merge_session

router = APIRouter()

# Per-stage pressure slots — order matters (files are concatenated in this order).
STAGE_SLOTS = [
    ("calibration", "Calibration"),
    ("pondering",   "Pondering"),
    ("weight",      "Weight"),
    ("tempo",       "Tempo"),
]


def _stage_pressure_paths(session: dict) -> dict:
    """Return {stage_key: Path} for each per-stage pressure file."""
    from db.paths import session_raw_folder
    folder = session_raw_folder(session)
    pid = session["participant_id"]
    return {key: folder / f"{pid}_pressure_{key}.csv" for key, _ in STAGE_SLOTS}


@router.post("/{session_id}/upload")
async def upload_pressure(session_id: int, file: UploadFile = File(...)):
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    if session.get("has_imu_dump") and not session.get("imu_raw_path"):
        raise HTTPException(status_code=400, detail="No IMU data recorded for this session yet")

    # Save uploaded file under data/<TestType>/Raw data/<ParticipantID>/
    from db.paths import session_raw_folder
    pressure_path = session_raw_folder(session) / f"{session['participant_id']}_pressure.csv"

    content = await file.read()
    pressure_path.write_bytes(content)

    # Validate
    valid, error = validate_pressure_csv(pressure_path)
    if not valid:
        pressure_path.unlink(missing_ok=True)
        raise HTTPException(status_code=422, detail=error)

    # Save path in DB
    await queries.update_session_status(
        session_id, session["status"], pressure_raw_path=str(pressure_path)
    )

    return {"ok": True, "pressure_path": str(pressure_path)}


@router.post("/{session_id}/upload-stage")
async def upload_stage_pressure(session_id: int, stage: str, file: UploadFile = File(...)):
    """Upload a single-stage pressure CSV (calibration / pondering / weight / tempo)."""
    valid_stages = {k for k, _ in STAGE_SLOTS}
    if stage not in valid_stages:
        raise HTTPException(
            status_code=400,
            detail=f"Unknown stage '{stage}'. Valid stages: {sorted(valid_stages)}",
        )
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    from db.paths import session_raw_folder
    folder = session_raw_folder(session)
    folder.mkdir(parents=True, exist_ok=True)
    dest = folder / f"{session['participant_id']}_pressure_{stage}.csv"

    content = await file.read()
    dest.write_bytes(content)

    valid, error = validate_pressure_csv(dest)
    if not valid:
        dest.unlink(missing_ok=True)
        raise HTTPException(status_code=422, detail=error)

    # Return which stage files are now present so the UI can sync
    stage_paths = _stage_pressure_paths(session)
    uploaded_stages = {k: p.exists() for k, p in stage_paths.items()}
    return {"ok": True, "stage": stage, "uploaded_stages": uploaded_stages}


@router.post("/{session_id}/combine-stages")
async def combine_stage_pressures(session_id: int):
    """Concatenate per-stage pressure CSVs into one combined file and set pressure_raw_path."""
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    stage_paths = _stage_pressure_paths(session)
    missing = [k for k, p in stage_paths.items() if not p.exists()]
    if missing:
        raise HTTPException(
            status_code=400,
            detail=f"Missing stage files: {', '.join(missing)}. Upload all stages first.",
        )

    # Concatenate in canonical order — keep header from first file only
    combined_lines: list[str] = []
    for i, (key, _) in enumerate(STAGE_SLOTS):
        lines = stage_paths[key].read_text().splitlines()
        if i == 0:
            combined_lines.extend(lines)
        else:
            combined_lines.extend(lines[1:])  # skip duplicate header

    from db.paths import session_raw_folder
    combined_path = session_raw_folder(session) / f"{session['participant_id']}_pressure.csv"
    combined_path.write_text("\n".join(combined_lines) + "\n")

    valid, error = validate_pressure_csv(combined_path)
    if not valid:
        combined_path.unlink(missing_ok=True)
        raise HTTPException(status_code=422, detail=f"Combined file invalid: {error}")

    await queries.update_session_status(
        session_id, session["status"], pressure_raw_path=str(combined_path)
    )
    return {"ok": True, "pressure_path": str(combined_path)}


@router.get("/{session_id}/stage-status")
async def get_stage_status(session_id: int):
    """Return which per-stage pressure files have been uploaded."""
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    stage_paths = _stage_pressure_paths(session)
    return {k: p.exists() for k, p in stage_paths.items()}


@router.post("/{session_id}/merge")
async def merge_pressure(session_id: int):
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    imu_path = session.get("imu_raw_path")
    pressure_path = session.get("pressure_raw_path")

    if session.get("has_imu_dump") and (not imu_path or not Path(imu_path).exists()):
        raise HTTPException(status_code=400, detail="IMU raw file not found")
    if not pressure_path or not Path(pressure_path).exists():
        raise HTTPException(status_code=400, detail="Pressure file not uploaded yet")

    if not session.get("has_imu_dump"):
        await queries.update_session_status(
            session_id, "merged", merged_path=pressure_path
        )
        return {
            "preview": [],
            "warnings": ["IMU not required for this test type — pressure file saved as merged output."],
            "calibration": [],
            "sync_alignment": None,
            "total_rows": 0,
            "merged_path": pressure_path,
            "per_stage_paths": [],
        }

    from db.paths import session_raw_folder
    merged_name = f"{session['participant_id']}_merged.csv"
    merged_path = session_raw_folder(session) / merged_name

    # Backup previous merged file before running — if the merge fails we can
    # restore it so the session doesn't end up with no merged output at all.
    backup_path: Path | None = None
    if merged_path.exists():
        archive_dir = DATA_DIR / "Archive"
        archive_dir.mkdir(parents=True, exist_ok=True)
        ts = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_path = archive_dir / f"{merged_name}.{ts}"
        shutil.copy2(str(merged_path), str(backup_path))  # copy, not move

    # Pull stage events recorded during the live view so the merger can add
    # a `stage` column and write per-stage CSVs.
    stage_events = await queries.list_stage_events_for_session(session_id)

    # Run merge in thread (pandas is CPU-bound).
    # If the merge fails, restore the previous merged file from the backup so
    # the session remains in a usable state.
    try:
        (
            preview_rows, warnings, total_rows, calibration,
            sync_alignment, per_stage_paths,
        ) = await asyncio.to_thread(
            merge_session,
            Path(imu_path), Path(pressure_path), merged_path, stage_events,
        )
    except Exception:
        if backup_path and backup_path.exists() and not merged_path.exists():
            shutil.copy2(str(backup_path), str(merged_path))
        raise

    return {
        "preview": preview_rows,
        "warnings": warnings,
        "calibration": calibration,
        "sync_alignment": sync_alignment,
        "total_rows": total_rows,
        "merged_path": str(merged_path),
        "per_stage_paths": per_stage_paths,
    }


@router.post("/{session_id}/confirm")
async def confirm_merge(session_id: int):
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    from db.paths import session_raw_folder
    merged_name = f"{session['participant_id']}_merged.csv"
    merged_path = session_raw_folder(session) / merged_name

    if not merged_path.exists():
        raise HTTPException(status_code=400, detail="No merged file found. Run merge first.")

    await queries.update_session_status(
        session_id, "merged", merged_path=str(merged_path)
    )

    return {"ok": True, "status": "merged"}
