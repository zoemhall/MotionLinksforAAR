from __future__ import annotations
import json
from db.connection import get_db


# --- Participants ---

async def create_participant(participant_id: str, shoe_size: str = "",
                             insole_size: str | None = None,
                             age: int | None = None, gender: str = "",
                             injuries: str = "") -> dict:
    db = await get_db()
    await db.execute(
        "INSERT INTO participants (participant_id, shoe_size, insole_size, age, gender, injuries) "
        "VALUES (?, ?, ?, ?, ?, ?)",
        (participant_id, shoe_size, insole_size, age, gender, injuries),
    )
    await db.commit()
    return await get_participant(participant_id)


async def get_participant(participant_id: str) -> dict | None:
    db = await get_db()
    cursor = await db.execute(
        "SELECT * FROM participants WHERE participant_id = ?",
        (participant_id,),
    )
    row = await cursor.fetchone()
    return dict(row) if row else None


async def update_participant(participant_id: str, shoe_size: str,
                             insole_size: str | None, age: int | None,
                             gender: str, injuries: str = "") -> dict:
    db = await get_db()
    await db.execute(
        "UPDATE participants SET shoe_size = ?, insole_size = ?, age = ?, "
        "gender = ?, injuries = ? WHERE participant_id = ?",
        (shoe_size, insole_size, age, gender, injuries, participant_id),
    )
    await db.commit()
    return await get_participant(participant_id)


# --- Test types ---

TEST_TYPE_FLAG_COLS = (
    "has_calibration", "has_calibration_files", "has_audio_familiarisation",
    "has_condition_1", "has_condition_2",
    "has_imu_dump", "has_pressure_merge",
    "has_consciousness_check", "has_overall_ratings",
)


async def list_test_types(include_archived: bool = False) -> list[dict]:
    db = await get_db()
    where = "" if include_archived else "WHERE archived = 0"
    cursor = await db.execute(
        f"SELECT * FROM test_types {where} ORDER BY test_type_id",
    )
    rows = await cursor.fetchall()
    return [dict(r) for r in rows]


async def get_test_type(test_type_id: int) -> dict | None:
    db = await get_db()
    cursor = await db.execute(
        "SELECT * FROM test_types WHERE test_type_id = ?", (test_type_id,),
    )
    row = await cursor.fetchone()
    return dict(row) if row else None


async def create_test_type(name: str, description: str = "", target_participants: int = 0, **flags) -> dict:
    cols = ["name", "description", "target_participants", *TEST_TYPE_FLAG_COLS]
    vals = [name, description, target_participants, *(flags.get(c, 1) for c in TEST_TYPE_FLAG_COLS)]
    placeholders = ", ".join("?" for _ in cols)
    db = await get_db()
    cursor = await db.execute(
        f"INSERT INTO test_types ({', '.join(cols)}) VALUES ({placeholders})",
        vals,
    )
    await db.commit()
    return await get_test_type(cursor.lastrowid)  # type: ignore[arg-type]


async def update_test_type(test_type_id: int, name: str, description: str, target_participants: int = 0, **flags) -> dict:
    set_clause = ", ".join(["name = ?", "description = ?", "target_participants = ?"] + [f"{c} = ?" for c in TEST_TYPE_FLAG_COLS])
    vals = [name, description, target_participants, *(flags.get(c, 1) for c in TEST_TYPE_FLAG_COLS), test_type_id]
    db = await get_db()
    await db.execute(
        f"UPDATE test_types SET {set_clause} WHERE test_type_id = ?", vals,
    )
    await db.commit()
    return await get_test_type(test_type_id)  # type: ignore[return-value]


async def archive_test_type(test_type_id: int) -> None:
    db = await get_db()
    await db.execute(
        "UPDATE test_types SET archived = 1 WHERE test_type_id = ?",
        (test_type_id,),
    )
    await db.commit()


# --- Sessions ---

async def create_session(
    participant_id: str,
    test_type_id: int,
    condition_order: str | None = None,
    tempo_direction: str | None = None,
    weight_direction: str | None = None,
    notes_setup: str = "",
    notes_use: str = "",
    notes_data: str = "",
    notes: str = "",
) -> dict:
    """Create a session, snapshotting the test-type's feature flags onto the row."""
    from datetime import datetime as _dt
    test_type = await get_test_type(test_type_id)
    if test_type is None:
        raise ValueError(f"Unknown test_type_id: {test_type_id}")

    db = await get_db()
    cursor = await db.execute(
        "INSERT INTO sessions ("
        "  participant_id, test_type_id, test_type_name, "
        "  session_date, "
        "  condition_order, tempo_direction, weight_direction, "
        "  has_calibration, has_calibration_files, has_audio_familiarisation, "
        "  has_condition_1, has_condition_2, "
        "  has_imu_dump, has_pressure_merge, "
        "  has_consciousness_check, has_overall_ratings, "
        "  notes_setup, notes_use, notes_data, notes"
        ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        (
            participant_id, test_type_id, test_type["name"],
            _dt.now().strftime("%Y-%m-%dT%H:%M:%S"),
            condition_order, tempo_direction, weight_direction,
            test_type["has_calibration"],
            test_type.get("has_calibration_files", 0),
            test_type["has_audio_familiarisation"],
            test_type["has_condition_1"],
            test_type["has_condition_2"],
            test_type["has_imu_dump"],
            test_type["has_pressure_merge"],
            test_type["has_consciousness_check"],
            test_type["has_overall_ratings"],
            notes_setup, notes_use, notes_data, notes,
        ),
    )
    await db.commit()
    return await get_session(cursor.lastrowid)  # type: ignore[arg-type]


async def get_session(session_id: int) -> dict | None:
    db = await get_db()
    cursor = await db.execute(
        "SELECT s.*, "
        "  (SELECT COUNT(*) FROM sessions s2 "
        "   WHERE s2.session_id <= s.session_id AND s2.deleted_at IS NULL) AS session_number "
        "FROM sessions s WHERE s.session_id = ?", (session_id,),
    )
    row = await cursor.fetchone()
    return dict(row) if row else None


async def list_sessions_for_participant(participant_id: str) -> list[dict]:
    db = await get_db()
    cursor = await db.execute(
        "SELECT s.*, "
        "  (SELECT COUNT(*) FROM sessions s2 "
        "   WHERE s2.session_id <= s.session_id AND s2.deleted_at IS NULL) AS session_number, "
        "  (SELECT 1 FROM session_ratings r WHERE r.session_id = s.session_id) AS has_ratings, "
        "  (SELECT COUNT(*) FROM consciousness_responses c WHERE c.session_id = s.session_id) AS consciousness_count, "
        "  (SELECT COUNT(*) FROM session_tags t WHERE t.session_id = s.session_id) AS tag_count "
        "FROM sessions s WHERE s.participant_id = ? AND s.deleted_at IS NULL ORDER BY session_date DESC",
        (participant_id,),
    )
    rows = await cursor.fetchall()
    return [dict(r) for r in rows]


async def list_sessions() -> list[dict]:
    db = await get_db()
    cursor = await db.execute(
        "SELECT s.*, "
        "  (SELECT COUNT(*) FROM sessions s2 "
        "   WHERE s2.session_id <= s.session_id AND s2.deleted_at IS NULL) AS session_number, "
        "  (SELECT 1 FROM session_ratings r WHERE r.session_id = s.session_id) AS has_ratings, "
        "  (SELECT COUNT(*) FROM consciousness_responses c WHERE c.session_id = s.session_id) AS consciousness_count, "
        "  (SELECT COUNT(*) FROM session_tags t WHERE t.session_id = s.session_id) AS tag_count, "
        "  COALESCE(sr.is_excluded, 0) AS is_excluded, "
        "  sr.tempo_outcome  AS tempo_outcome, "
        "  sr.weight_outcome AS weight_outcome "
        "FROM sessions s "
        "LEFT JOIN session_reviews sr ON sr.session_id = s.session_id "
        "WHERE s.deleted_at IS NULL ORDER BY session_date DESC",
    )
    rows = await cursor.fetchall()
    return [dict(r) for r in rows]


async def list_deleted_sessions() -> list[dict]:
    db = await get_db()
    cursor = await db.execute(
        "SELECT s.*, p.shoe_size, p.insole_size, p.age, p.gender "
        "FROM sessions s "
        "LEFT JOIN participants p ON s.participant_id = p.participant_id "
        "WHERE s.deleted_at IS NOT NULL ORDER BY s.deleted_at DESC",
    )
    rows = await cursor.fetchall()
    return [dict(r) for r in rows]


async def soft_delete_session(session_id: int) -> None:
    db = await get_db()
    await db.execute(
        "UPDATE sessions SET deleted_at = datetime('now') WHERE session_id = ?",
        (session_id,),
    )
    await db.commit()


async def restore_session(session_id: int) -> None:
    db = await get_db()
    await db.execute(
        "UPDATE sessions SET deleted_at = NULL WHERE session_id = ?",
        (session_id,),
    )
    await db.commit()


async def check_duplicate_session(participant_id: str, test_type_id: int) -> bool:
    """A participant can have multiple sessions across different test types,
    or even repeat the same test type — but warn before creating an exact
    duplicate (same participant + same test type) so accidental re-creates
    surface to the researcher."""
    db = await get_db()
    cursor = await db.execute(
        "SELECT 1 FROM sessions WHERE participant_id = ? AND test_type_id = ?",
        (participant_id, test_type_id),
    )
    return await cursor.fetchone() is not None


async def recover_in_progress_sessions() -> list[int]:
    """On startup, find sessions stuck in 'in-progress' from a previous crash/kill
    and move them to 'imu-saved' if their raw IMU CSV exists on disk.

    Sessions with no imu_raw_path were created but never started — leave them
    untouched so the researcher can manually delete them.

    Returns the list of session IDs that were recovered.
    """
    from datetime import datetime
    from pathlib import Path

    db = await get_db()
    cursor = await db.execute(
        "SELECT session_id, imu_raw_path, notes FROM sessions WHERE status = 'in-progress'"
    )
    rows = await cursor.fetchall()
    recovered: list[int] = []
    stamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    for row in rows:
        imu_path = row["imu_raw_path"]
        if not imu_path or not Path(imu_path).exists():
            continue
        existing_notes = row["notes"] or ""
        marker = f"[Auto-recovered: marked imu-saved on app restart at {stamp}]"
        new_notes = (existing_notes + "\n" + marker).strip() if existing_notes else marker
        await db.execute(
            "UPDATE sessions SET status = 'imu-saved', notes = ? WHERE session_id = ?",
            (new_notes, row["session_id"]),
        )
        recovered.append(row["session_id"])

    if recovered:
        await db.commit()
    return recovered


async def update_session_status(session_id: int, status: str, **kwargs) -> None:
    db = await get_db()
    sets = ["status = ?"]
    vals: list = [status]
    for key in ("imu_raw_path", "pressure_raw_path", "merged_path"):
        if key in kwargs:
            sets.append(f"{key} = ?")
            vals.append(kwargs[key])
    vals.append(session_id)
    await db.execute(
        f"UPDATE sessions SET {', '.join(sets)} WHERE session_id = ?", vals,
    )
    await db.commit()


async def update_import_paths(
    session_id: int,
    pressure_raw_path: str,
    cal_file_1: str | None = None,
    cal_file_2: str | None = None,
    cal_file_3: str | None = None,
) -> None:
    db = await get_db()
    await db.execute(
        "UPDATE sessions SET pressure_raw_path=?, cal_file_1_path=?, "
        "cal_file_2_path=?, cal_file_3_path=?, has_imu_dump=0 "
        "WHERE session_id=?",
        (pressure_raw_path, cal_file_1, cal_file_2, cal_file_3, session_id),
    )
    await db.commit()


async def update_session_details(
    session_id: int,
    session_date: str | None = None,
    condition_order: str | None = None,
    tempo_direction: str | None = None,
    weight_direction: str | None = None,
    notes_setup: str = "",
    notes_use: str = "",
    notes_data: str = "",
    notes: str = "",
    pressure_raw_path: str | None = None,
    cal_file_1_path: str | None = None,
    cal_file_2_path: str | None = None,
    cal_file_3_path: str | None = None,
) -> None:
    db = await get_db()
    await db.execute(
        "UPDATE sessions SET "
        "session_date=?, condition_order=?, tempo_direction=?, weight_direction=?, "
        "notes_setup=?, notes_use=?, notes_data=?, notes=?, "
        "pressure_raw_path=?, cal_file_1_path=?, cal_file_2_path=?, cal_file_3_path=? "
        "WHERE session_id=?",
        (
            session_date, condition_order, tempo_direction, weight_direction,
            notes_setup, notes_use, notes_data, notes,
            pressure_raw_path, cal_file_1_path, cal_file_2_path, cal_file_3_path,
            session_id,
        ),
    )
    await db.commit()


async def update_session_notes(
    session_id: int,
    notes_setup: str = "",
    notes_use: str = "",
    notes_data: str = "",
    notes: str = "",
) -> None:
    db = await get_db()
    await db.execute(
        "UPDATE sessions SET notes_setup=?, notes_use=?, notes_data=?, notes=? WHERE session_id=?",
        (notes_setup, notes_use, notes_data, notes, session_id),
    )
    await db.commit()


async def delete_session(session_id: int) -> None:
    db = await get_db()
    await db.execute("DELETE FROM session_tags WHERE session_id = ?", (session_id,))
    await db.execute("DELETE FROM session_stage_events WHERE session_id = ?", (session_id,))
    await db.execute("DELETE FROM consciousness_responses WHERE session_id = ?", (session_id,))
    await db.execute("DELETE FROM session_ratings WHERE session_id = ?", (session_id,))
    await db.execute("DELETE FROM sessions WHERE session_id = ?", (session_id,))
    await db.commit()


async def delete_participant(participant_id: str) -> None:
    db = await get_db()
    sessions_subq = (
        "session_id IN (SELECT session_id FROM sessions WHERE participant_id = ?)"
    )
    await db.execute(f"DELETE FROM session_tags WHERE {sessions_subq}", (participant_id,))
    await db.execute(f"DELETE FROM session_stage_events WHERE {sessions_subq}", (participant_id,))
    await db.execute(f"DELETE FROM consciousness_responses WHERE {sessions_subq}", (participant_id,))
    await db.execute(f"DELETE FROM session_ratings WHERE {sessions_subq}", (participant_id,))
    await db.execute(
        "DELETE FROM sessions WHERE participant_id = ?",
        (participant_id,),
    )
    await db.execute(
        "DELETE FROM participants WHERE participant_id = ?",
        (participant_id,),
    )
    await db.commit()


# --- Session tags ---

async def add_session_tag(
    session_id: int,
    tag: str,
    stage: str | None = None,
    note: str = "",
    device_ms: float | None = None,
) -> dict:
    db = await get_db()
    cursor = await db.execute(
        "INSERT INTO session_tags (session_id, tag, stage, note, device_ms) "
        "VALUES (?, ?, ?, ?, ?)",
        (session_id, tag.strip(), stage, note, device_ms),
    )
    await db.commit()
    return await get_session_tag(cursor.lastrowid)


async def get_session_tag(tag_id: int) -> dict | None:
    db = await get_db()
    cursor = await db.execute(
        "SELECT * FROM session_tags WHERE tag_id = ?", (tag_id,),
    )
    row = await cursor.fetchone()
    return dict(row) if row else None


async def list_session_tags(session_id: int) -> list[dict]:
    db = await get_db()
    cursor = await db.execute(
        "SELECT * FROM session_tags WHERE session_id = ? ORDER BY created_at",
        (session_id,),
    )
    rows = await cursor.fetchall()
    return [dict(r) for r in rows]


async def delete_session_tag(tag_id: int) -> bool:
    db = await get_db()
    cursor = await db.execute("DELETE FROM session_tags WHERE tag_id = ?", (tag_id,))
    await db.commit()
    return cursor.rowcount > 0


async def frequent_tags(limit: int = 10) -> list[dict]:
    """Return the most-used tags across all sessions, with usage counts."""
    db = await get_db()
    cursor = await db.execute(
        "SELECT tag, COUNT(*) AS count FROM session_tags "
        "GROUP BY tag ORDER BY count DESC, tag ASC LIMIT ?",
        (limit,),
    )
    rows = await cursor.fetchall()
    return [dict(r) for r in rows]


# --- Questionnaires ---
# Split into:
#   - consciousness_responses (ONE row per session, walks all 4 stages)
#   - session_ratings (ONE row per session)
# Session is marked complete when both rows exist.


async def _maybe_mark_complete(session_id: int) -> None:
    """Mark session complete iff every ENABLED data source has its row."""
    session = await get_session(session_id)
    if not session:
        return
    db = await get_db()
    needs_consciousness = bool(session.get("has_consciousness_check"))
    needs_ratings = bool(session.get("has_overall_ratings"))

    if needs_consciousness:
        cursor = await db.execute(
            "SELECT 1 FROM consciousness_responses WHERE session_id = ?", (session_id,),
        )
        if await cursor.fetchone() is None:
            return
    if needs_ratings:
        cursor = await db.execute(
            "SELECT 1 FROM session_ratings WHERE session_id = ?", (session_id,),
        )
        if await cursor.fetchone() is None:
            return
    await update_session_status(session_id, "complete")


async def save_consciousness(
    session_id: int,
    post_calibration_noticed: int, post_calibration_text: str,
    cond1_noticed: int, cond1_guess: str | None, cond1_text: str,
    cond2_noticed: int, cond2_guess: str | None, cond2_text: str,
    post_session_noticed: int, post_session_text: str,
    post_session_tempo_guess: str | None, post_session_weight_guess: str | None,
) -> dict:
    db = await get_db()
    await db.execute(
        "INSERT OR REPLACE INTO consciousness_responses "
        "(session_id, "
        " post_calibration_noticed, post_calibration_text, "
        " cond1_noticed, cond1_guess, cond1_text, "
        " cond2_noticed, cond2_guess, cond2_text, "
        " post_session_noticed, post_session_text, "
        " post_session_tempo_guess, post_session_weight_guess) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        (session_id,
         post_calibration_noticed, post_calibration_text,
         cond1_noticed, cond1_guess, cond1_text,
         cond2_noticed, cond2_guess, cond2_text,
         post_session_noticed, post_session_text,
         post_session_tempo_guess, post_session_weight_guess),
    )
    await db.commit()
    await _maybe_mark_complete(session_id)
    row = await get_consciousness(session_id)
    return row  # type: ignore[return-value]


async def save_ratings(
    session_id: int,
    agency_q1: int, agency_q2: int, agency_q3: int,
    ueqs_items: list[int],
    ari_items: list[int],
) -> dict:
    agency_aggregate = (agency_q1 + agency_q2 + agency_q3) / 3.0
    ueqs_pragmatic = sum(ueqs_items[i] - 4 for i in range(4)) / 4.0
    ari_immersion = sum(ari_items) / len(ari_items) if ari_items else 0.0
    raw_json = json.dumps({"ueqs_items": ueqs_items, "ari_items": ari_items})

    db = await get_db()
    await db.execute(
        "INSERT INTO session_ratings "
        "(session_id, agency_q1, agency_q2, agency_q3, agency_aggregate, "
        " ueqs_pragmatic, ari_immersion, raw_item_json) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        (session_id, agency_q1, agency_q2, agency_q3, agency_aggregate,
         ueqs_pragmatic, ari_immersion, raw_json),
    )
    await db.commit()
    await _maybe_mark_complete(session_id)
    row = await get_ratings(session_id)
    return row  # type: ignore[return-value]


async def get_consciousness(session_id: int) -> dict | None:
    db = await get_db()
    cursor = await db.execute(
        "SELECT * FROM consciousness_responses WHERE session_id = ?", (session_id,),
    )
    row = await cursor.fetchone()
    return dict(row) if row else None


async def get_ratings(session_id: int) -> dict | None:
    db = await get_db()
    cursor = await db.execute(
        "SELECT * FROM session_ratings WHERE session_id = ?", (session_id,),
    )
    row = await cursor.fetchone()
    return dict(row) if row else None


# Map a guess (vocabulary used in the UI) to the equivalent direction
# (vocabulary stored on the session row). Tempo guesses already match
# tempo_direction values verbatim; weight needs translation
# (heavier → increasing, lighter → decreasing).
_GUESS_TO_DIRECTION = {
    "speeding_up": "speeding_up",
    "slowing_down": "slowing_down",
    "heavier": "increasing",
    "lighter": "decreasing",
    # 'no_change' has no truthy direction equivalent; correctness is False
    # whenever the actual direction is not no_change (which it never is).
    "no_change": "no_change",
}


def _is_correct_guess(guess: str | None, actual: str | None) -> bool | None:
    """Return True/False/None — correctness of a participant's guess against the
    actual direction stored on the session. None when no guess was recorded."""
    if guess is None or actual is None:
        return None
    return _GUESS_TO_DIRECTION.get(guess) == actual


def _first_condition_actual_direction(session: dict) -> str:
    """First condition's actual direction value (vocabulary of session row)."""
    if session["condition_order"] == "A-first":
        return session["tempo_direction"]
    return session["weight_direction"]


def _second_condition_actual_direction(session: dict) -> str:
    if session["condition_order"] == "A-first":
        return session["weight_direction"]
    return session["tempo_direction"]


def _annotate_correctness(consciousness: dict | None, session: dict | None) -> dict | None:
    """Add computed actual-direction + correctness fields to a consciousness row."""
    if not consciousness or not session:
        return consciousness
    out = dict(consciousness)
    cond1_actual = _first_condition_actual_direction(session)
    cond2_actual = _second_condition_actual_direction(session)
    out["cond1_actual"] = cond1_actual
    out["cond2_actual"] = cond2_actual
    out["cond1_correct"] = _is_correct_guess(consciousness.get("cond1_guess"), cond1_actual)
    out["cond2_correct"] = _is_correct_guess(consciousness.get("cond2_guess"), cond2_actual)
    out["post_session_tempo_correct"] = _is_correct_guess(
        consciousness.get("post_session_tempo_guess"), session["tempo_direction"]
    )
    out["post_session_weight_correct"] = _is_correct_guess(
        consciousness.get("post_session_weight_guess"), session["weight_direction"]
    )
    return out


async def get_questionnaire_summary(session_id: int) -> dict:
    """Combined view: consciousness (with computed correctness) + ratings."""
    consciousness = await get_consciousness(session_id)
    session = await get_session(session_id)
    return {
        "consciousness": _annotate_correctness(consciousness, session),
        "ratings": await get_ratings(session_id),
    }


# --- Stage events ---

async def add_stage_event(
    session_id: int, stage_id: str, device_ms: float | None = None,
) -> dict:
    from datetime import datetime
    started_at = datetime.now().isoformat(timespec="seconds")
    db = await get_db()
    cursor = await db.execute(
        "INSERT INTO session_stage_events (session_id, stage_id, started_at, device_ms) "
        "VALUES (?, ?, ?, ?)",
        (session_id, stage_id, started_at, device_ms),
    )
    await db.commit()
    cursor = await db.execute(
        "SELECT * FROM session_stage_events WHERE event_id = ?", (cursor.lastrowid,),
    )
    row = await cursor.fetchone()
    return dict(row) if row else {}


async def list_stage_events_for_session(session_id: int) -> list[dict]:
    db = await get_db()
    cursor = await db.execute(
        "SELECT * FROM session_stage_events WHERE session_id = ? ORDER BY event_id",
        (session_id,),
    )
    rows = await cursor.fetchall()
    return [dict(r) for r in rows]


# --- Export ---

async def export_all_sessions() -> list[dict]:
    """Flat per-session export modelled on the user's Summary.xlsx columns:

    Order (session_id) | New? | Participant | Date | Test type |
    Injuries | Gender | Age | UK shoe | Insole size |
    Notes (setup / use / data / general) |
    Condition + direction info |
    Consciousness fields + computed correctness |
    Ratings scores |
    Counts (tags, stage events, etc.)
    """
    db = await get_db()
    cursor = await db.execute(
        "SELECT s.*, "
        "  p.shoe_size, p.insole_size, p.age, p.gender, p.injuries, "
        "  r.agency_q1, r.agency_q2, r.agency_q3, "
        "  r.agency_aggregate, r.ueqs_pragmatic, r.ari_immersion, "
        "  c.post_calibration_noticed, c.post_calibration_text, "
        "  c.cond1_noticed, c.cond1_guess, c.cond1_text, "
        "  c.cond2_noticed, c.cond2_guess, c.cond2_text, "
        "  c.post_session_noticed, c.post_session_text, "
        "  c.post_session_tempo_guess, c.post_session_weight_guess, "
        "  (SELECT COUNT(*) FROM session_tags t WHERE t.session_id = s.session_id) AS tag_count "
        "FROM sessions s "
        "LEFT JOIN participants p ON s.participant_id = p.participant_id "
        "LEFT JOIN session_ratings r ON s.session_id = r.session_id "
        "LEFT JOIN consciousness_responses c ON s.session_id = c.session_id "
        "WHERE s.deleted_at IS NULL ORDER BY s.session_id ASC",
    )
    rows = [dict(r) for r in await cursor.fetchall()]

    # Pre-compute "new?" flag — N if this participant has any session with
    # an earlier session_id, Y otherwise.
    seen_participants: set[str] = set()
    out: list[dict] = []
    for r in rows:
        pid = r["participant_id"]
        is_new = pid not in seen_participants
        seen_participants.add(pid)

        first_actual = (
            r["tempo_direction"] if r.get("condition_order") == "A-first" else r.get("weight_direction")
        )
        second_actual = (
            r["weight_direction"] if r.get("condition_order") == "A-first" else r.get("tempo_direction")
        )

        def _bool_int(v):
            return None if v is None else int(v)

        # Reorder fields into a stable summary-friendly column order.
        flat = {
            "order": r["session_id"],
            "is_new_participant": "Y" if is_new else "N",
            "participant_id": pid,
            "session_date": r["session_date"],
            "test_type": r["test_type_name"],
            "injuries": r.get("injuries", "") or "",
            "gender": r.get("gender", "") or "",
            "age": r.get("age"),
            "shoe_size": r.get("shoe_size", "") or "",
            "insole_size": r.get("insole_size", "") or "",
            "status": r["status"],
            "tag_count": r["tag_count"],
            "notes_setup": r.get("notes_setup", "") or "",
            "notes_use": r.get("notes_use", "") or "",
            "notes_data": r.get("notes_data", "") or "",
            "notes": r.get("notes", "") or "",
            # Condition assignment
            "condition_order": r.get("condition_order"),
            "tempo_direction": r.get("tempo_direction"),
            "weight_direction": r.get("weight_direction"),
            # Consciousness check
            "post_calibration_noticed": r.get("post_calibration_noticed"),
            "post_calibration_text": r.get("post_calibration_text"),
            "cond1_actual": first_actual,
            "cond1_noticed": r.get("cond1_noticed"),
            "cond1_guess": r.get("cond1_guess"),
            "cond1_correct": _bool_int(_is_correct_guess(r.get("cond1_guess"), first_actual)),
            "cond1_text": r.get("cond1_text"),
            "cond2_actual": second_actual,
            "cond2_noticed": r.get("cond2_noticed"),
            "cond2_guess": r.get("cond2_guess"),
            "cond2_correct": _bool_int(_is_correct_guess(r.get("cond2_guess"), second_actual)),
            "cond2_text": r.get("cond2_text"),
            "post_session_noticed": r.get("post_session_noticed"),
            "post_session_text": r.get("post_session_text"),
            "post_session_tempo_guess": r.get("post_session_tempo_guess"),
            "post_session_tempo_correct": _bool_int(
                _is_correct_guess(r.get("post_session_tempo_guess"), r.get("tempo_direction"))
            ),
            "post_session_weight_guess": r.get("post_session_weight_guess"),
            "post_session_weight_correct": _bool_int(
                _is_correct_guess(r.get("post_session_weight_guess"), r.get("weight_direction"))
            ),
            # Overall ratings
            "agency_q1": r.get("agency_q1"),
            "agency_q2": r.get("agency_q2"),
            "agency_q3": r.get("agency_q3"),
            "agency_aggregate": r.get("agency_aggregate"),
            "ueqs_pragmatic": r.get("ueqs_pragmatic"),
            "ari_immersion": r.get("ari_immersion"),
            # File paths
            "imu_raw_path": r.get("imu_raw_path"),
            "pressure_raw_path": r.get("pressure_raw_path"),
            "merged_path": r.get("merged_path"),
            "cal_file_1_path": r.get("cal_file_1_path"),
            "cal_file_2_path": r.get("cal_file_2_path"),
            "cal_file_3_path": r.get("cal_file_3_path"),
        }
        out.append(flat)
    return out
