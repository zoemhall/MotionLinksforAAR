#!/usr/bin/env python3
"""One-shot migration: move all Test 5 sessions to Test 4.

Run from the project root:
    python migrate_test5_to_test4.py

What it does:
  1. Backs up data/gait_study.db
  2. Moves participant folders from  data/Test 5/Raw data/  →  data/Test 4/Raw data/
  3. Updates sessions table: test_type_id, test_type_name, and all file path columns
  4. Verifies no Test 5 sessions remain
"""
from __future__ import annotations
import datetime
import shutil
import sqlite3
from pathlib import Path


DB_PATH   = Path("data/gait_study.db")
SRC_ROOT  = Path("data/Test 5/Raw data")
DST_ROOT  = Path("data/Test 4/Raw data")
OLD_FRAG  = "/Test 5/"
NEW_FRAG  = "/Test 4/"
OLD_TT_ID = 3   # Test 5: Full study
NEW_TT_ID = 4   # Test 4: Mock final test


def main() -> None:
    # ── Step 1: Backup the database ──────────────────────────────────────────
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    backup = DB_PATH.with_name(f"gait_study.db.backup_{ts}")
    shutil.copy2(DB_PATH, backup)
    print(f"✓ DB backed up → {backup}")

    # ── Step 2: Move participant folders ──────────────────────────────────────
    DST_ROOT.mkdir(parents=True, exist_ok=True)

    if SRC_ROOT.exists():
        moved = 0
        for pid_dir in sorted(SRC_ROOT.iterdir()):
            if not pid_dir.is_dir():
                continue
            dst = DST_ROOT / pid_dir.name
            if dst.exists():
                # Destination participant folder already exists — merge files
                for f in sorted(pid_dir.iterdir()):
                    dest_file = dst / f.name
                    if dest_file.exists():
                        print(f"  SKIP (exists): {dest_file}")
                    else:
                        shutil.move(str(f), str(dest_file))
                        print(f"  Moved file: {f.name} → {dst}/")
                # Remove now-empty source dir
                try:
                    pid_dir.rmdir()
                except OSError:
                    print(f"  WARN: could not remove {pid_dir} (not empty?)")
            else:
                shutil.move(str(pid_dir), str(dst))
                print(f"  Moved dir:  {pid_dir} → {dst}")
            moved += 1
        print(f"✓ Moved {moved} participant folder(s) from {SRC_ROOT} → {DST_ROOT}")
    else:
        print(f"  No files to move — {SRC_ROOT} does not exist")

    # ── Step 3: Update the database ──────────────────────────────────────────
    con = sqlite3.connect(str(DB_PATH))
    con.execute("PRAGMA foreign_keys=OFF")

    # Confirm target test type exists and get its name
    row = con.execute(
        "SELECT test_type_id, name FROM test_types WHERE test_type_id = ?", (NEW_TT_ID,)
    ).fetchone()
    if not row:
        print(f"ERROR: test_type_id={NEW_TT_ID} not found in DB. Aborting.")
        con.close()
        return
    new_name = row[1]
    print(f"  Target test type: [{NEW_TT_ID}] {new_name!r}")

    con.execute(
        """
        UPDATE sessions SET
            test_type_id      = ?,
            test_type_name    = ?,
            imu_raw_path      = REPLACE(imu_raw_path,      ?, ?),
            pressure_raw_path = REPLACE(pressure_raw_path, ?, ?),
            merged_path       = REPLACE(merged_path,       ?, ?),
            cal_file_1_path   = REPLACE(cal_file_1_path,   ?, ?),
            cal_file_2_path   = REPLACE(cal_file_2_path,   ?, ?),
            cal_file_3_path   = REPLACE(cal_file_3_path,   ?, ?)
        WHERE test_type_id = ?
        """,
        (
            NEW_TT_ID, new_name,
            OLD_FRAG, NEW_FRAG,
            OLD_FRAG, NEW_FRAG,
            OLD_FRAG, NEW_FRAG,
            OLD_FRAG, NEW_FRAG,
            OLD_FRAG, NEW_FRAG,
            OLD_FRAG, NEW_FRAG,
            OLD_TT_ID,
        ),
    )
    updated = con.execute("SELECT changes()").fetchone()[0]
    con.commit()
    con.close()
    print(f"✓ Updated {updated} session row(s) in DB")

    # ── Step 4: Verify ────────────────────────────────────────────────────────
    con = sqlite3.connect(str(DB_PATH))
    remaining = con.execute(
        "SELECT COUNT(*) FROM sessions WHERE test_type_id = ?", (OLD_TT_ID,)
    ).fetchone()[0]
    migrated = con.execute(
        "SELECT COUNT(*) FROM sessions WHERE test_type_id = ?", (NEW_TT_ID,)
    ).fetchone()[0]
    print(f"\nPost-migration counts:")
    rows = con.execute(
        "SELECT t.test_type_id, t.name, COUNT(s.session_id) "
        "FROM test_types t LEFT JOIN sessions s ON s.test_type_id = t.test_type_id "
        "GROUP BY t.test_type_id ORDER BY t.test_type_id"
    ).fetchall()
    for r in rows:
        print(f"  [{r[0]}] {r[1]!r}: {r[2]} session(s)")
    con.close()

    if remaining == 0:
        print(f"\n✓ Migration complete — {migrated} session(s) now under Test 4.")
    else:
        print(f"\n✗ WARNING: {remaining} session(s) still under Test 5 (test_type_id={OLD_TT_ID})")


if __name__ == "__main__":
    main()
