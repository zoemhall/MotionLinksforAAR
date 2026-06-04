"""
Test 4: Reported agency vs. pressure signal quality
Descriptive baseline — n is too small for inferential statistics.
"""
import re
import sqlite3
from pathlib import Path
import pandas as pd
from scipy import stats

DB_PATH = "data/gait_study.db"
ALIGNMENT_CSV = "analysis/test5_alignment_report.csv"
TEST4_RAW = Path("data/Test 4/Raw data")


def parse_heel_corr(notes: str) -> tuple:
    """Extract L and R heel correlation values from the notes field."""
    if not isinstance(notes, str):
        return None, None
    l = re.search(r"L heel corr=([-\d.]+)", notes)
    r = re.search(r"R heel corr=([-\d.]+)", notes)
    return (float(l.group(1)) if l else None), (float(r.group(1)) if r else None)


def flag_count(flags: str) -> int:
    if not isinstance(flags, str) or not flags.strip():
        return 0
    return len([f for f in flags.split("|") if f.strip()])


def main():
    # --- Load agency data from DB ---
    con = sqlite3.connect(DB_PATH)
    agency_df = pd.read_sql_query(
        """
        SELECT s.session_id, s.participant_id, s.notes AS session_notes,
               sr.agency_q1, sr.agency_q2, sr.agency_q3, sr.agency_aggregate
        FROM sessions s
        JOIN session_ratings sr ON sr.session_id = s.session_id
        WHERE s.test_type_id = 4
        ORDER BY s.session_id
        """,
        con,
    )
    con.close()

    # --- Load alignment report ---
    align_df = pd.read_csv(ALIGNMENT_CSV)
    align_df["session_id"] = align_df["session_id"].astype(int)

    # Merge
    df = agency_df.merge(align_df[["session_id", "flags", "imu_l_coverage_pct",
                                    "imu_r_coverage_pct", "notes"]],
                         on="session_id", how="left")

    # Derived quality metrics
    df[["heel_corr_l", "heel_corr_r"]] = df["notes"].apply(
        lambda n: pd.Series(parse_heel_corr(n))
    )
    df["avg_coverage"] = df[["imu_l_coverage_pct", "imu_r_coverage_pct"]].mean(axis=1)
    df["avg_abs_heel_corr"] = df[["heel_corr_l", "heel_corr_r"]].abs().mean(axis=1)
    df["flag_count"] = df["flags"].apply(flag_count)

    # A participant has pressure data if ANY file with "pressure" in the name exists
    # in their test 4 raw data folder — not just the split phase files.
    def has_no_pressure(pid: str) -> int:
        folder = TEST4_RAW / str(pid).zfill(2)
        if not folder.exists():
            return 1
        return 0 if any(folder.glob("*pressure*")) else 1

    df["pressure_missing"] = df["participant_id"].apply(has_no_pressure)

    # Display table
    display_cols = [
        "session_id", "participant_id",
        "agency_q1", "agency_q2", "agency_q3", "agency_aggregate",
        "avg_coverage", "avg_abs_heel_corr", "flag_count", "pressure_missing",
        "session_notes",
    ]
    print("\n=== Test 4: Agency vs. Pressure Signal Quality ===\n")
    print(df[display_cols].sort_values("agency_aggregate").to_string(index=False))

    # Spearman correlations (full set including pressure_missing rows)
    print("\n=== Spearman correlations with agency_aggregate ===")
    print(f"  (n={len(df)} total sessions with agency data)\n")
    metrics = {
        "avg_coverage": "IMU coverage % (higher = better)",
        "avg_abs_heel_corr": "Abs heel correlation (higher = better alignment)",
        "flag_count": "Flag count (higher = more issues)",
        "pressure_missing": "Pressure missing (1 = missing)",
    }
    for col, label in metrics.items():
        subset = df.dropna(subset=[col, "agency_aggregate"])
        if len(subset) < 3:
            print(f"  {label}: insufficient data (n={len(subset)})")
            continue
        r, p = stats.spearmanr(subset[col], subset["agency_aggregate"])
        print(f"  {label}:")
        print(f"    r = {r:+.3f},  p = {p:.3f}  (n={len(subset)})")

    # Separate view: sessions with pressure data vs. missing
    print("\n=== Agency by pressure availability ===")
    present = df[df["pressure_missing"] == 0]["agency_aggregate"]
    missing = df[df["pressure_missing"] == 1]["agency_aggregate"]
    no_align = df[df["flags"].isna()]["agency_aggregate"]
    print(f"  Pressure present  (n={len(present)}): "
          f"mean={present.mean():.2f}, range={present.min():.1f}–{present.max():.1f}")
    if len(missing):
        print(f"  Pressure missing  (n={len(missing)}): "
              f"mean={missing.mean():.2f}, range={missing.min():.1f}–{missing.max():.1f}")
    if len(no_align):
        print(f"  No alignment data (n={len(no_align)}): "
              f"mean={no_align.mean():.2f}, range={no_align.min():.1f}–{no_align.max():.1f}")

    print("\nNote: n=6 for coverage/heel-corr metrics. Need r > 0.81 for p < 0.05 — descriptive only.\n")


if __name__ == "__main__":
    main()
