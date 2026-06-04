import logging
import uvicorn
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse

from pathlib import Path

from config import DATA_DIR
from db.connection import init_db, close_db, get_db
from db.queries import recover_in_progress_sessions
from ble.manager import ble_manager

logger = logging.getLogger(__name__)


async def _heal_cal_paths() -> None:
    """Back-fill cal_file_N_path in the DB for sessions whose canonical cal
    CSV files exist on disk but whose DB columns are still NULL.

    This happens when a session was imported before cal-path tracking was
    added.  The canonical names are <pid>_cal_1/2/3.csv inside the standard
    session folder.
    """
    import re

    def _safe(s: str) -> str:
        return re.sub(r"[^A-Za-z0-9 _-]", "_", s).strip() or "Untitled"

    def _tt_folder(name) -> str:  # Optional[str], py3.9-compatible
        if not name:
            return "Untitled"
        short = name.split(":", 1)[0].strip()
        return _safe(short or name)

    db = await get_db()
    cursor = await db.execute(
        """
        SELECT s.session_id, s.participant_id, t.name AS test_type_name,
               s.cal_file_1_path, s.cal_file_2_path, s.cal_file_3_path
        FROM sessions s
        JOIN test_types t ON s.test_type_id = t.test_type_id
        WHERE t.has_calibration = 1
          AND (s.cal_file_1_path IS NULL OR s.cal_file_2_path IS NULL OR s.cal_file_3_path IS NULL)
          AND s.deleted_at IS NULL
        """
    )
    rows = await cursor.fetchall()
    healed = 0
    for row in rows:
        pid = row["participant_id"]
        folder = (
            DATA_DIR
            / _tt_folder(row["test_type_name"])
            / "Raw data"
            / _safe(pid)
        )
        updates: dict[str, str] = {}
        for n in (1, 2, 3):
            col = f"cal_file_{n}_path"
            if row[col] is None:
                candidate = folder / f"{pid}_cal_{n}.csv"
                if candidate.exists():
                    updates[col] = str(candidate)
        if updates:
            set_clause = ", ".join(f"{k} = ?" for k in updates)
            await db.execute(
                f"UPDATE sessions SET {set_clause} WHERE session_id = ?",
                [*updates.values(), row["session_id"]],
            )
            logger.info(
                "Auto-healed cal paths for session %d (%s): %s",
                row["session_id"], pid, list(updates.keys()),
            )
            healed += 1
    if healed:
        await db.commit()


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    (DATA_DIR / "import").mkdir(parents=True, exist_ok=True)
    # Per-session subdirectories (data/<TestType>/Raw data/<ParticipantID>/)
    # are created on demand by db.paths.session_raw_folder().
    await init_db()

    # Auto-heal: if a session has has_calibration=1 and a null cal_file_N_path
    # but the canonical file already exists on disk, fill in the DB path.
    # This covers sessions imported before cal-path tracking was added.
    await _heal_cal_paths()

    # Recover any sessions left in-progress from a previous run
    recovered = await recover_in_progress_sessions()
    if recovered:
        logger.warning(
            "Recovered %d in-progress session(s) from previous run: %s",
            len(recovered), recovered,
        )

    yield
    # Shutdown
    await ble_manager.disconnect()
    await close_db()


app = FastAPI(title="Gait Study", lifespan=lifespan)

# Mount routers
from routers import sessions, participants, questionnaires, pressure, ble_control, export, ws, tags, diagnostics, imu_dump, test_types, import_data  # noqa: E402

app.include_router(sessions.router, prefix="/api/sessions", tags=["sessions"])
app.include_router(participants.router, prefix="/api/participants", tags=["participants"])
app.include_router(questionnaires.router, prefix="/api/questionnaires", tags=["questionnaires"])
app.include_router(pressure.router, prefix="/api/pressure", tags=["pressure"])
app.include_router(ble_control.router, prefix="/api/ble", tags=["ble"])
app.include_router(export.router, prefix="/api/export", tags=["export"])
app.include_router(tags.router, prefix="/api/tags", tags=["tags"])
app.include_router(diagnostics.router, prefix="/api/diagnostics", tags=["diagnostics"])
app.include_router(imu_dump.router, prefix="/api/imu", tags=["imu"])
app.include_router(test_types.router, prefix="/api/test_types", tags=["test_types"])
app.include_router(import_data.router, prefix="/api/import", tags=["import"])
app.include_router(ws.router, tags=["websocket"])

# Serve static assets
app.mount("/static", StaticFiles(directory="static"), name="static")


@app.get("/")
async def index():
    return FileResponse("templates/index.html")


if __name__ == "__main__":
    uvicorn.run("app:app", host="127.0.0.1", port=8000, log_level="info")
