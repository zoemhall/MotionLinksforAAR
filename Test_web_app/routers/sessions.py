from __future__ import annotations
import shutil
from datetime import datetime
from pathlib import Path

from fastapi import APIRouter, File, HTTPException, UploadFile

from config import DATA_DIR
from db.models import SessionCreate, SessionUpdate, NotesUpdate, TagCreate, StageEventCreate
from db import queries
from ble.manager import ble_manager
from recording.session_recorder import (
    SessionRecorder,
    get_active_recorder,
    set_active_recorder,
)

router = APIRouter()


@router.get("")
async def list_sessions():
    return await queries.list_sessions()


@router.get("/trash")
async def list_trash():
    return await queries.list_deleted_sessions()


@router.get("/{session_id}")
async def get_session(session_id: int):
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    return session


@router.patch("/{session_id}")
async def update_session(session_id: int, body: SessionUpdate):
    """Update editable session fields (date, condition directions, notes, file paths)."""
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    await queries.update_session_details(session_id, **body.model_dump())
    return await queries.get_session(session_id)


@router.post("/{session_id}/upload-file")
async def upload_session_file(
    session_id: int,
    file_type: str,
    file: UploadFile = File(...),
):
    """Upload a data file for an existing session.

    file_type: "pressure" | "cal_1" | "cal_2" | "cal_3"
    The file is saved with a canonical name (e.g. {pid}_pressure.csv) and the
    corresponding DB column is updated.  The original filename is ignored.
    """
    from db.paths import session_raw_folder
    from merge.merger import validate_pressure_csv

    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    pid = session["participant_id"]

    TYPE_MAP = {
        "pressure": (f"{pid}_pressure.csv", "pressure_raw_path"),
        "cal_1":    (f"{pid}_cal_1.csv",    "cal_file_1_path"),
        "cal_2":    (f"{pid}_cal_2.csv",    "cal_file_2_path"),
        "cal_3":    (f"{pid}_cal_3.csv",    "cal_file_3_path"),
    }
    if file_type not in TYPE_MAP:
        raise HTTPException(status_code=400, detail=f"Invalid file_type '{file_type}'. Must be one of: {', '.join(TYPE_MAP)}")

    filename, db_col = TYPE_MAP[file_type]
    folder = session_raw_folder(session)
    folder.mkdir(parents=True, exist_ok=True)
    dest = folder / filename
    dest.write_bytes(await file.read())

    if file_type == "pressure":
        valid, err = validate_pressure_csv(dest)
        if not valid:
            dest.unlink(missing_ok=True)
            raise HTTPException(status_code=422, detail=err or "Invalid pressure CSV format")

    await queries.update_session_details(session_id, **{db_col: str(dest)})
    return await queries.get_session(session_id)


@router.post("", status_code=201)
async def create_session(body: SessionCreate):
    participant = await queries.get_participant(body.participant_id)
    if not participant:
        raise HTTPException(
            status_code=400,
            detail=f"Participant {body.participant_id} does not exist. Create them first.",
        )

    test_type = await queries.get_test_type(body.test_type_id)
    if not test_type:
        raise HTTPException(
            status_code=400,
            detail=f"Unknown test_type_id {body.test_type_id}",
        )

    # Condition assignments are only required if the test type runs the
    # condition stages. Default-fill any missing values to keep the row
    # valid, but the live view will skip the disabled stages.
    condition_order = body.condition_order
    tempo_direction = body.tempo_direction
    weight_direction = body.weight_direction
    runs_conditions = bool(test_type["has_condition_1"]) or bool(test_type["has_condition_2"])
    if runs_conditions:
        if not condition_order or not tempo_direction or not weight_direction:
            raise HTTPException(
                status_code=400,
                detail="condition_order, tempo_direction, and weight_direction are required for test types that include condition stages.",
            )

    try:
        session = await queries.create_session(
            participant_id=body.participant_id,
            test_type_id=body.test_type_id,
            condition_order=condition_order,
            tempo_direction=tempo_direction,
            weight_direction=weight_direction,
            notes_setup=body.notes_setup,
            notes_use=body.notes_use,
            notes_data=body.notes_data,
            notes=body.notes,
        )
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    return session


@router.post("/{session_id}/start")
async def start_recording(session_id: int):
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    if get_active_recorder() is not None:
        raise HTTPException(status_code=409, detail="Another recording is already active")

    # Connect BLE if not already connected
    if not ble_manager.is_connected:
        try:
            await ble_manager.connect()
        except ConnectionError as e:
            raise HTTPException(status_code=503, detail=str(e))

    # Build CSV path under data/<TestType>/Raw data/<ParticipantID>/
    from db.paths import session_raw_folder
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    csv_path = session_raw_folder(session) / f"{session['participant_id']}_raw_{ts}.csv"

    recorder = SessionRecorder(csv_path)
    await recorder.start()
    set_active_recorder(recorder)

    await queries.update_session_status(
        session_id, "in-progress", imu_raw_path=str(csv_path)
    )

    return {
        "status": "recording",
        "csv_path": str(csv_path),
        "ble_status": ble_manager.status,
    }


@router.post("/{session_id}/pause")
async def pause_recording(session_id: int):
    recorder = get_active_recorder()
    if recorder is None:
        raise HTTPException(status_code=400, detail="No active recording")
    recorder.pause()
    return {"status": "paused", "row_count": recorder.row_count}


@router.post("/{session_id}/resume")
async def resume_recording(session_id: int):
    recorder = get_active_recorder()
    if recorder is None:
        raise HTTPException(status_code=400, detail="No active recording")
    recorder.resume()
    return {"status": "recording", "row_count": recorder.row_count}


@router.post("/{session_id}/stop")
async def stop_recording(session_id: int):
    recorder = get_active_recorder()
    if recorder is None:
        raise HTTPException(status_code=400, detail="No active recording")

    row_count, file_path = await recorder.stop()
    set_active_recorder(None)

    await ble_manager.disconnect()

    await queries.update_session_status(
        session_id, "imu-saved", imu_raw_path=str(file_path)
    )

    return {
        "status": "imu-saved",
        "row_count": row_count,
        "file_path": str(file_path),
    }


@router.delete("/{session_id}")
async def delete_session(session_id: int):
    """Soft-delete: moves session to trash. Files are not touched."""
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    recorder = get_active_recorder()
    if recorder is not None and session["status"] == "in-progress":
        raise HTTPException(status_code=409, detail="Cannot delete while recording is active. Stop first.")

    await queries.soft_delete_session(session_id)
    return {"ok": True, "session_id": session_id}


@router.post("/{session_id}/restore")
async def restore_session(session_id: int):
    """Restore a session from trash."""
    await queries.restore_session(session_id)
    return {"ok": True, "session_id": session_id}


@router.delete("/{session_id}/permanent")
async def permanently_delete_session(session_id: int):
    """Hard-delete: archives data files and removes the session from the database."""
    db_session = await queries.get_session(session_id)
    # Also check deleted sessions
    if not db_session:
        from db.connection import get_db
        db = await get_db()
        cursor = await db.execute(
            "SELECT * FROM sessions WHERE session_id = ?", (session_id,)
        )
        row = await cursor.fetchone()
        db_session = dict(row) if row else None
    if not db_session:
        raise HTTPException(status_code=404, detail="Session not found")

    archive_dir = DATA_DIR / "Trash" / "Deleted"
    archive_dir.mkdir(parents=True, exist_ok=True)
    for path_key in ("imu_raw_path", "pressure_raw_path", "merged_path"):
        fpath = db_session.get(path_key)
        if fpath and Path(fpath).exists():
            shutil.move(str(fpath), str(archive_dir / Path(fpath).name))

    await queries.delete_session(session_id)
    return {"ok": True, "session_id": session_id}


@router.patch("/{session_id}/notes")
async def update_notes(session_id: int, body: NotesUpdate):
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    await queries.update_session_notes(
        session_id,
        notes_setup=body.notes_setup,
        notes_use=body.notes_use,
        notes_data=body.notes_data,
        notes=body.notes,
    )
    return {"ok": True}


# --- Session tags ---

@router.get("/{session_id}/tags")
async def list_tags(session_id: int):
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    return await queries.list_session_tags(session_id)


@router.post("/{session_id}/tags", status_code=201)
async def add_tag(session_id: int, body: TagCreate):
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    return await queries.add_session_tag(
        session_id=session_id,
        tag=body.tag,
        stage=body.stage,
        note=body.note,
        device_ms=body.device_ms,
    )


@router.delete("/{session_id}/tags/{tag_id}")
async def delete_tag(session_id: int, tag_id: int):
    deleted = await queries.delete_session_tag(tag_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Tag not found")
    return {"ok": True, "tag_id": tag_id}


# --- Stage events (live-view stage transitions) ---

@router.get("/{session_id}/stage_events")
async def list_stage_events(session_id: int):
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    return await queries.list_stage_events_for_session(session_id)


@router.post("/{session_id}/stage_events", status_code=201)
async def add_stage_event(session_id: int, body: StageEventCreate):
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    return await queries.add_stage_event(
        session_id=session_id, stage_id=body.stage_id, device_ms=body.device_ms,
    )


@router.get("/{session_id}/baseline-bpm")
async def get_baseline_bpm(session_id: int):
    """Compute baseline walking BPM from neutral-condition pressure rows."""
    import asyncio
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    from db.paths import session_raw_folder
    from analysis.baseline import analyse_baseline_bpm

    folder = session_raw_folder(session)
    pid    = session["participant_id"]
    order  = session.get("condition_order")

    try:
        result = await asyncio.to_thread(analyse_baseline_bpm, folder, pid, order)
    except Exception as e:
        return {"baseline_bpm": None, "sources": [], "error": str(e)}
    return result


@router.get("/{session_id}/ts-check")
async def check_timestamp_alignment(session_id: int):
    """Compare device_ms timestamp ranges between IMU and pressure CSV files."""
    import asyncio
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    imu_path = session.get("imu_raw_path")
    pressure_path = session.get("pressure_raw_path")
    if not imu_path or not pressure_path:
        return {"available": False, "issues": []}

    imu_p, pres_p = Path(imu_path), Path(pressure_path)
    missing = [n for n, p in [("IMU", imu_p), ("pressure", pres_p)] if not p.exists()]
    if missing:
        return {"available": False, "issues": [{"level": "warn", "msg": f"{' and '.join(missing)} file(s) missing from disk"}]}

    def _read_ranges():
        import pandas as pd
        from merge.merger import load_pressure

        imu_df = pd.read_csv(str(imu_p), usecols=["device_ms"])
        imu_min = float(imu_df["device_ms"].min())
        imu_max = float(imu_df["device_ms"].max())

        # load_pressure handles Max/MSP semicolon format + standard CSV
        try:
            pres_df = load_pressure(str(pres_p))
        except Exception:
            pres_df = pd.read_csv(str(pres_p))

        # Find timestamp column: prefer "device_ms" by name, else second column
        pres_ts = pres_df["device_ms"] if "device_ms" in pres_df.columns else pres_df.iloc[:, 1]
        pres_min = float(pres_ts.min())
        pres_max = float(pres_ts.max())

        return imu_min, imu_max, pres_min, pres_max

    try:
        imu_min, imu_max, pres_min, pres_max = await asyncio.to_thread(_read_ranges)
    except Exception as e:
        return {"available": False, "issues": [{"level": "error", "msg": f"Could not read files: {e}"}]}

    overlap_start = max(imu_min, pres_min)
    overlap_end   = min(imu_max, pres_max)
    overlap_ms    = max(0.0, overlap_end - overlap_start)
    imu_dur       = imu_max - imu_min
    pres_dur      = pres_max - pres_min
    shorter_dur   = min(imu_dur, pres_dur)
    overlap_pct   = (overlap_ms / shorter_dur * 100) if shorter_dur > 0 else 0.0
    start_off_ms  = abs(imu_min - pres_min)

    issues: list[dict] = []
    if overlap_ms <= 0:
        issues.append({"level": "error", "msg":
            f"No timestamp overlap — IMU [{imu_min/1000:.1f}–{imu_max/1000:.1f}s], "
            f"pressure [{pres_min/1000:.1f}–{pres_max/1000:.1f}s]. Files may be from different BLE sessions."})
    else:
        if start_off_ms > 60_000:
            issues.append({"level": "error", "msg":
                f"Recordings start {start_off_ms/1000:.0f}s apart — likely from different BLE connections."})
        elif start_off_ms > 10_000:
            issues.append({"level": "warn", "msg":
                f"IMU and pressure start {start_off_ms/1000:.1f}s apart — possible BLE reconnect mid-session."})
        if overlap_pct < 50:
            issues.append({"level": "warn", "msg":
                f"Only {overlap_pct:.0f}% timestamp overlap — large portion of "
                f"{'IMU' if imu_dur < pres_dur else 'pressure'} data has no counterpart."})
        elif overlap_pct < 80:
            issues.append({"level": "warn", "msg":
                f"Timestamp overlap is {overlap_pct:.0f}% — some data may not align."})

    return {
        "available": True,
        "ok": len(issues) == 0,
        "issues": issues,
        "imu_range_s":      [round(imu_min / 1000, 1), round(imu_max / 1000, 1)],
        "pressure_range_s": [round(pres_min / 1000, 1), round(pres_max / 1000, 1)],
        "overlap_pct":      round(overlap_pct, 1),
        "start_offset_s":   round(start_off_ms / 1000, 1),
    }


@router.get("/{session_id}/folder-files")
async def list_folder_files(session_id: int):
    """List all CSV files physically present in the session's raw folder,
    cross-referenced against what the DB tracks."""
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    from db.paths import session_raw_folder
    folder = session_raw_folder(session)

    # Build filename → db column map for tracked paths
    db_files: dict[str, str] = {}
    for col, p in {
        "pressure_raw_path": session.get("pressure_raw_path"),
        "imu_raw_path":      session.get("imu_raw_path"),
        "merged_path":       session.get("merged_path"),
        "cal_file_1_path":   session.get("cal_file_1_path"),
        "cal_file_2_path":   session.get("cal_file_2_path"),
        "cal_file_3_path":   session.get("cal_file_3_path"),
    }.items():
        if p:
            db_files[Path(p).name] = col

    files: list[dict] = []
    if folder.exists():
        for f in sorted(folder.iterdir()):
            if f.suffix.lower() != ".csv":
                continue
            files.append({
                "filename":   f.name,
                "size_bytes": f.stat().st_size,
                "db_column":  db_files.get(f.name),
                "missing":    False,
            })

    # Append DB-tracked entries whose files are missing on disk
    seen = {f["filename"] for f in files}
    for col, p in {
        "pressure_raw_path": session.get("pressure_raw_path"),
        "imu_raw_path":      session.get("imu_raw_path"),
        "merged_path":       session.get("merged_path"),
        "cal_file_1_path":   session.get("cal_file_1_path"),
        "cal_file_2_path":   session.get("cal_file_2_path"),
        "cal_file_3_path":   session.get("cal_file_3_path"),
    }.items():
        if not p:
            continue
        fname = Path(p).name
        if fname not in seen:
            files.append({
                "filename":   fname,
                "size_bytes": None,
                "db_column":  col,
                "missing":    True,
            })

    return {"folder": str(folder), "folder_exists": folder.exists(), "files": files}


@router.get("/{session_id}/calibration")
async def get_calibration_analysis(session_id: int):
    """Return per-file calibration reliability scores for a session.

    Returns a list of file entries in display order:
      - main pressure file (pressure_raw_path) labelled as '30s pressure'
      - up to 3 calibration files (cal_file_1/2/3_path) labelled as '10s cal 1/2/3'

    Cal file slots are always included when has_calibration=1, even if not yet
    uploaded, so the UI can show what's missing rather than silently omitting them.
    """
    from analysis.calibration import analyse_calibration_file
    session = await queries.get_session(session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    has_cal = bool(session.get("has_calibration_files"))

    file_specs = [
        ("pressure_raw_path", "30s pressure", False),
        ("cal_file_1_path",   "10s cal 1",    True),
        ("cal_file_2_path",   "10s cal 2",    True),
        ("cal_file_3_path",   "10s cal 3",    True),
    ]

    entries = []
    for key, label, is_cal in file_specs:
        path = session.get(key)
        if not path:
            # Cal file slots are always shown when has_calibration — so the
            # researcher can see which files are still missing.
            if is_cal and has_cal:
                entries.append({
                    "key":      key,
                    "label":    label,
                    "filename": None,
                    "exists":   False,
                    "uploaded": False,
                    "analysis": None,
                })
            continue
        p = Path(path)
        analysis = analyse_calibration_file(p) if p.exists() else None
        entries.append({
            "key":      key,
            "label":    label,
            "filename": p.name,
            "exists":   p.exists(),
            "uploaded": True,
            "analysis": analysis,
        })
    return entries
