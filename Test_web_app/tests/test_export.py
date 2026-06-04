"""Tests for the export endpoints."""
from __future__ import annotations
import pytest
from tests.conftest import make_participant, make_session


async def test_export_session_csv_200(client, db, tmp_path):
    """Session with a merged_path → CSV download returns 200."""
    await make_participant(client, "40")
    session = await make_session(client, "40", test_type_id=1)
    sid = session["session_id"]

    # Write a minimal merged CSV to tmp_path
    merged_file = tmp_path / "40_merged.csv"
    merged_file.write_text("device_ms,ax,ay\n1000,0.1,0.2\n2000,0.3,0.4\n")

    # Set merged_path and status directly in DB
    await db.execute(
        "UPDATE sessions SET merged_path=?, status='merged' WHERE session_id=?",
        (str(merged_file), sid),
    )
    await db.commit()

    r = await client.get(f"/api/export/session/{sid}/csv")
    assert r.status_code == 200, r.text
    assert "text/csv" in r.headers.get("content-type", "")


async def test_export_session_csv_404_no_merged(client):
    """Session without a merged file → 404."""
    await make_participant(client, "41")
    session = await make_session(client, "41", test_type_id=1)
    sid = session["session_id"]

    r = await client.get(f"/api/export/session/{sid}/csv")
    assert r.status_code == 404


async def test_export_session_csv_404_session_not_found(client):
    r = await client.get("/api/export/session/9999/csv")
    assert r.status_code == 404


async def test_export_all_no_sessions_404(client):
    """No sessions in DB → /export/all returns 404."""
    r = await client.get("/api/export/all")
    assert r.status_code == 404


async def test_export_all_with_sessions(client):
    """With at least one session, /export/all returns a CSV stream."""
    await make_participant(client, "42")
    await make_session(client, "42", test_type_id=1)

    r = await client.get("/api/export/all")
    assert r.status_code == 200
    assert "text/csv" in r.headers.get("content-type", "")
    # Should have a header row at minimum
    assert "participant_id" in r.text
