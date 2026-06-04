from __future__ import annotations
import shutil
from pathlib import Path

from fastapi import APIRouter, HTTPException

from config import DATA_DIR
from db import queries
from db.models import ImportSessionCreate
from db.paths import session_raw_folder
from analysis.calibration import analyse_calibration_file

router = APIRouter()

IMPORT_DIR = DATA_DIR / "import"


def _import_dir() -> Path:
    d = DATA_DIR / "import"
    d.mkdir(parents=True, exist_ok=True)
    return d


async def _used_paths() -> set[str]:
    """Collect all import-related file paths already stored on session rows."""
    db = await queries.get_db()
    cursor = await db.execute(
        "SELECT pressure_raw_path, cal_file_1_path, cal_file_2_path, cal_file_3_path "
        "FROM sessions WHERE deleted_at IS NULL"
    )
    rows = await cursor.fetchall()
    paths: set[str] = set()
    for r in rows:
        for val in r:
            if val:
                paths.add(str(val))
    return paths


@router.get("/files")
async def list_import_files():
    """Scan data/import/ for CSV files, returning metadata for each."""
    import_dir = _import_dir()
    used = await _used_paths()

    files = []
    for f in sorted(import_dir.glob("*.csv")):
        try:
            row_count = sum(1 for _ in f.open()) - 1  # subtract header
        except Exception:
            row_count = 0
        files.append({
            "filename": f.name,
            "size_bytes": f.stat().st_size,
            "row_count": max(0, row_count),
            "already_used": str(f) in used,
            "calibration_analysis": analyse_calibration_file(f),
        })
    return files


@router.post("/session", status_code=201)
async def import_session(body: ImportSessionCreate):
    import_dir = _import_dir()

    # Validate file paths
    main_path = import_dir / body.main_file
    if not main_path.exists():
        raise HTTPException(status_code=400, detail=f"Main file not found: {body.main_file}")

    cal_paths: list[Path | None] = []
    for fname in (body.cal_file_1, body.cal_file_2, body.cal_file_3):
        if fname:
            p = import_dir / fname
            if not p.exists():
                raise HTTPException(status_code=400, detail=f"Calibration file not found: {fname}")
            cal_paths.append(p)
        else:
            cal_paths.append(None)

    # Upsert participant
    participant = await queries.get_participant(body.participant_id)
    if participant is None:
        await queries.create_participant(
            body.participant_id,
            shoe_size=body.shoe_size,
            insole_size=body.insole_size,
            age=body.age,
            gender=body.gender,
            injuries=body.injuries,
        )
    else:
        await queries.update_participant(
            body.participant_id,
            shoe_size=body.shoe_size or participant.get("shoe_size", ""),
            insole_size=body.insole_size or participant.get("insole_size"),
            age=body.age if body.age is not None else participant.get("age"),
            gender=body.gender or participant.get("gender", ""),
            injuries=body.injuries or participant.get("injuries", ""),
        )

    # Create session (snapshots test-type flags)
    session = await queries.create_session(
        participant_id=body.participant_id,
        test_type_id=body.test_type_id,
        notes_setup=body.notes_setup,
        notes_data=body.notes_data,
        notes=body.notes,
    )
    session_id = session["session_id"]

    # Override session_date if the user supplied one
    if body.session_date:
        db = await queries.get_db()
        await db.execute(
            "UPDATE sessions SET session_date = ? WHERE session_id = ?",
            (body.session_date, session_id),
        )
        await db.commit()

    # Copy files to session folder with canonical names
    pid = body.participant_id
    dest_folder = session_raw_folder(session)

    dest_main = dest_folder / f"{pid}_pressure.csv"
    shutil.move(str(main_path), dest_main)

    dest_cals: list[str | None] = []
    cal_names = ("cal_1", "cal_2", "cal_3")
    for src, name in zip(cal_paths, cal_names):
        if src is not None:
            dest = dest_folder / f"{pid}_{name}.csv"
            shutil.move(str(src), dest)
            dest_cals.append(str(dest))
        else:
            dest_cals.append(None)

    # Update session with paths; forces has_imu_dump=0
    await queries.update_import_paths(
        session_id,
        pressure_raw_path=str(dest_main),
        cal_file_1=dest_cals[0],
        cal_file_2=dest_cals[1],
        cal_file_3=dest_cals[2],
    )

    # Auto-complete: if test type requires no consciousness check and no
    # overall ratings, mark merged+complete immediately.
    if body.auto_complete:
        test_type = await queries.get_test_type(body.test_type_id)
        needs_q = (
            (test_type or {}).get("has_consciousness_check", 0) or
            (test_type or {}).get("has_overall_ratings", 0)
        )
        new_status = "complete" if not needs_q else "merged"
        await queries.update_session_status(
            session_id, new_status, merged_path=str(dest_main)
        )

    return await queries.get_session(session_id)
