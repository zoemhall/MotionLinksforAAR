from __future__ import annotations
import pandas as pd
from pathlib import Path


def parse_max_pressure_file(
    pressure_path: Path,
) -> tuple[pd.DataFrame, list[dict], int]:
    """Parse the Max/MSP pressure CSV format.

    Max outputs all records on a single line, semicolon-separated.
    Each record: "index, timestamp L_toe L_heel R_toe R_heel
                   L_toe_lower L_toe_upper L_heel_lower L_heel_upper
                   R_toe_lower R_toe_upper R_heel_lower R_heel_upper"
    Values are space-separated.

    Returns (dataframe, calibration_thresholds, skipped_count).
    Raises ValueError if more than 10% of records fail to parse, indicating
    the file is corrupted or in an unexpected format.
    """
    raw = pressure_path.read_text().strip()

    records = [r.strip() for r in raw.split(";") if r.strip()]
    total_records = len(records)

    # Column order after timestamp
    PRESSURE_COLS = ["L_toe", "L_heel", "R_toe", "R_heel"]
    CALIBRATION_ZONES = [
        {"zone": "L_toe",  "label": "Left Toe"},
        {"zone": "L_heel", "label": "Left Heel"},
        {"zone": "R_toe",  "label": "Right Toe"},
        {"zone": "R_heel", "label": "Right Heel"},
    ]

    rows = []
    calibration: list[dict] = []
    skipped_count = 0

    for record in records:
        parts = record.split(",", 1)
        if len(parts) != 2:
            skipped_count += 1
            continue

        values = parts[1].strip().split()
        if len(values) < 5:
            skipped_count += 1
            continue

        try:
            timestamp = float(values[0])
            row = {"device_ms": timestamp}

            for i, col in enumerate(PRESSURE_COLS):
                row[col] = float(values[1 + i])

            rows.append(row)

            # Extract calibration bounds from the first valid record only
            if not calibration and len(values) >= 13:
                for i, zone_info in enumerate(CALIBRATION_ZONES):
                    lower = float(values[5 + i * 2])
                    upper = float(values[5 + i * 2 + 1])
                    calibration.append({
                        "zone": zone_info["zone"],
                        "label": zone_info["label"],
                        "lower": lower,
                        "upper": upper,
                    })
        except (ValueError, IndexError):
            skipped_count += 1
            continue

    if not rows:
        raise ValueError(
            f"No valid records found in pressure file ({skipped_count} of {total_records} records failed to parse)"
        )

    # Reject the file if more than 10% of records were unparseable
    if total_records > 10 and skipped_count > 0.1 * total_records:
        raise ValueError(
            f"{skipped_count} of {total_records} records failed to parse "
            f"({100 * skipped_count / total_records:.0f}%). File may be corrupted or in unexpected format."
        )

    return pd.DataFrame(rows), calibration, skipped_count


def _is_max_format(pressure_path: Path) -> bool:
    """Detect whether a file is in Max/MSP's semicolon-delimited format.

    A Max file starts with `<digit>,` (an index) and contains semicolons within
    the first 1KB. This rejects standard CSV files even if they happen to
    contain semicolons in note fields.
    """
    raw = pressure_path.read_text(errors="replace")[:2000]
    stripped = raw.lstrip()
    if not stripped:
        return False
    if "device_ms" in raw.lower():
        return False
    # First non-whitespace must be a digit followed by `,` (the index pattern)
    head = stripped[:32]
    if not (head and head[0].isdigit() and "," in head[:8]):
        return False
    return ";" in raw[:1000]


def validate_pressure_csv(pressure_path: Path) -> tuple[bool, str]:
    """Validate the pressure file (supports both Max format and standard CSV)."""
    try:
        if _is_max_format(pressure_path):
            df, _, skipped = parse_max_pressure_file(pressure_path)
            required = {"device_ms", "L_toe", "L_heel", "R_toe", "R_heel"}
            if skipped:
                # Non-fatal — surface as a warning suffix on success
                pass
        else:
            df = pd.read_csv(pressure_path, nrows=5)
            required = {"device_ms"}

        missing = required - set(df.columns)
        if missing:
            return False, f"Missing required columns: {', '.join(sorted(missing))}"
        if len(df) == 0:
            return False, "File contains no data rows"
        return True, ""
    except Exception as e:
        return False, f"Cannot read pressure file: {e}"


def load_pressure(pressure_path: Path) -> tuple[pd.DataFrame, list[dict], int]:
    """Load pressure data, auto-detecting Max or standard CSV format.

    Returns (dataframe, calibration_thresholds, skipped_count).
    skipped_count is 0 for standard CSV files.
    """
    if _is_max_format(pressure_path):
        return parse_max_pressure_file(pressure_path)
    return pd.read_csv(pressure_path), [], 0


def _compute_sync_alignment(imu_df: pd.DataFrame, pressure_df: pd.DataFrame) -> dict:
    """Find the first IMU sync pulse (phase=9) and the closest pressure timestamp.

    Returns a dict with keys: found, imu_ms, pressure_ms, delta_ms.
    delta_ms = pressure_ms - imu_ms (positive means pressure log is later).
    """
    if "phase" not in imu_df.columns:
        return {"found": False, "imu_ms": None, "pressure_ms": None, "delta_ms": None}
    sync_rows = imu_df[imu_df["phase"] == 9]
    if sync_rows.empty:
        return {"found": False, "imu_ms": None, "pressure_ms": None, "delta_ms": None}

    imu_ms = float(sync_rows["device_ms"].iloc[0])
    if pressure_df.empty or "device_ms" not in pressure_df.columns:
        return {"found": False, "imu_ms": imu_ms, "pressure_ms": None, "delta_ms": None}

    nearest_idx = (pressure_df["device_ms"] - imu_ms).abs().idxmin()
    pressure_ms = float(pressure_df.loc[nearest_idx, "device_ms"])
    return {
        "found": True,
        "imu_ms": imu_ms,
        "pressure_ms": pressure_ms,
        "delta_ms": pressure_ms - imu_ms,
    }


def _resolve_stage_device_ms(
    stage_events: list[dict],
    imu_df: pd.DataFrame,
) -> list[dict]:
    """Resolve each stage event's wall-clock time to a device_ms value.

    Uses the calibration sync pulse as the anchor:
      - Find the first IMU row with phase=9 → device_ms_sync (real anchor on the firmware clock).
      - Find the stage event with stage_id='sync_pulse' (or the calibration event's started_at if missing) → wall_clock_sync.
      - Compute offset = device_ms_sync - wall_clock_sync_ms.
      - For every stage event without an explicit device_ms, set
        device_ms = (started_at_ms + offset).

    If no sync pulse can be found, falls back to keeping the originally-set
    device_ms values (which may all be None) and stage segmentation will be
    skipped silently.
    """
    from datetime import datetime as _dt

    if not stage_events or imu_df.empty or "phase" not in imu_df.columns:
        return [dict(e) for e in stage_events]

    # Anchor: first phase=9 in IMU
    sync_rows = imu_df[imu_df["phase"] == 9]
    if sync_rows.empty:
        return [dict(e) for e in stage_events]
    device_ms_anchor = float(sync_rows["device_ms"].iloc[0])

    # Anchor on the host side: the sync_pulse event if one was logged, else the
    # first calibration event (which is when the researcher would have stamped).
    anchor_evt = next((e for e in stage_events if e.get("stage_id") == "sync_pulse"), None)
    if anchor_evt is None:
        anchor_evt = next((e for e in stage_events if e.get("stage_id") == "calibration"), None)
    if anchor_evt is None:
        return [dict(e) for e in stage_events]

    try:
        wall_anchor_ms = _dt.fromisoformat(anchor_evt["started_at"]).timestamp() * 1000.0
    except (ValueError, KeyError):
        return [dict(e) for e in stage_events]

    offset = device_ms_anchor - wall_anchor_ms
    out = []
    for e in stage_events:
        d = dict(e)
        if d.get("device_ms") is None:
            try:
                wall_ms = _dt.fromisoformat(d["started_at"]).timestamp() * 1000.0
                d["device_ms"] = wall_ms + offset
            except (ValueError, KeyError):
                pass
        out.append(d)
    return out


def _annotate_stages(
    merged: pd.DataFrame, resolved_events: list[dict],
) -> pd.DataFrame:
    """Add a 'stage' column to merged using resolved stage event boundaries."""
    transitions = sorted(
        [e for e in resolved_events if e.get("device_ms") is not None and e.get("stage_id") != "sync_pulse"],
        key=lambda e: e["device_ms"],
    )
    if not transitions:
        return merged

    # Build (start_ms, stage_id) intervals: each stage runs from its own
    # start until the next transition's start.
    starts = [e["device_ms"] for e in transitions]
    stage_ids = [e["stage_id"] for e in transitions]

    def label(ms: float) -> str | None:
        for i in range(len(transitions) - 1, -1, -1):
            if ms >= starts[i]:
                return stage_ids[i]
        return None  # before any stage started

    merged = merged.copy()
    merged["stage"] = merged["device_ms"].apply(label)
    return merged


def _write_per_stage_csvs(
    merged: pd.DataFrame, output_path: Path,
) -> list[str]:
    """Write one CSV per stage to data/processed/. Returns list of paths."""
    if "stage" not in merged.columns:
        return []
    paths: list[str] = []
    base = output_path.with_suffix("")  # strip .csv
    for stage_id, grp in merged.groupby("stage", dropna=True):
        if not stage_id:
            continue
        out = Path(f"{base}_{stage_id}.csv")
        grp.to_csv(out, index=False)
        paths.append(str(out))
    return paths


def merge_session(
    imu_path: Path, pressure_path: Path, output_path: Path,
    stage_events: list[dict] | None = None,
) -> tuple[list[dict], list[str], int, list[dict], dict, list[str]]:
    """Merge IMU + pressure on device_ms.

    Returns (preview_rows, warnings, total_row_count, calibration_thresholds,
              sync_alignment, per_stage_paths).
    """
    imu = pd.read_csv(imu_path)
    pressure, calibration, skipped_count = load_pressure(pressure_path)
    warnings: list[str] = []
    stage_events = stage_events or []

    if skipped_count > 0:
        warnings.append(
            f"{skipped_count} record(s) skipped during pressure file parsing — check Max output format"
        )

    # Compute sync alignment from raw inputs (before column renames)
    sync_alignment = _compute_sync_alignment(imu, pressure)

    # Cast both device_ms columns to float so merge_asof can match them
    # (Max writes float ms, the XIAO firmware typically writes int ms)
    pressure["device_ms"] = pd.to_numeric(pressure["device_ms"], errors="coerce").astype(float)
    imu["device_ms"] = pd.to_numeric(imu["device_ms"], errors="coerce").astype(float)

    # Check timestamp overlap
    imu_min, imu_max = imu["device_ms"].min(), imu["device_ms"].max()
    p_min, p_max = pressure["device_ms"].min(), pressure["device_ms"].max()
    overlap_start = max(imu_min, p_min)
    overlap_end = min(imu_max, p_max)
    if overlap_start >= overlap_end:
        warnings.append(
            f"No timestamp overlap: IMU [{imu_min:.0f}-{imu_max:.0f}], "
            f"Pressure [{p_min:.0f}-{p_max:.0f}]"
        )

    # Handle overlapping column names before merge
    pressure_cols = set(pressure.columns) - {"device_ms"}
    imu_cols = set(imu.columns) - {"device_ms"}
    overlap_cols = pressure_cols & imu_cols

    if "phase" in overlap_cols:
        pressure = pressure.rename(columns={"phase": "phase_pressure"})
        imu = imu.rename(columns={"phase": "phase_imu"})
        overlap_cols.discard("phase")

    # Drop any remaining overlapping columns from IMU (pressure is authoritative)
    for col in overlap_cols:
        imu = imu.drop(columns=[col])

    # Merge on nearest device_ms (timestamps may not match exactly)
    imu_sorted = imu.sort_values("device_ms").reset_index(drop=True)
    pressure_sorted = pressure.sort_values("device_ms").reset_index(drop=True)

    merged = pd.merge_asof(
        imu_sorted,
        pressure_sorted,
        on="device_ms",
        direction="nearest",
        tolerance=50,  # 50ms tolerance for matching
    )

    merged.sort_values("device_ms", inplace=True)
    merged.reset_index(drop=True, inplace=True)

    # Reconcile phase columns if both existed
    if "phase_imu" in merged.columns and "phase_pressure" in merged.columns:
        merged["phase"] = merged["phase_imu"].combine_first(merged["phase_pressure"])
        merged.drop(columns=["phase_imu", "phase_pressure"], inplace=True)
    elif "phase_imu" in merged.columns:
        merged.rename(columns={"phase_imu": "phase"}, inplace=True)

    # Forward-fill phase
    if "phase" in merged.columns:
        merged["phase"] = merged["phase"].ffill()

    # Check for sync pulse
    if "phase" in merged.columns and 9 not in merged["phase"].values:
        warnings.append("No sync pulse (phase=9) found in merged data")

    # Stage segmentation: align stage events to firmware clock and add a
    # `stage` column. Splits per-stage CSVs alongside the merged file.
    per_stage_paths: list[str] = []
    if stage_events:
        resolved = _resolve_stage_device_ms(stage_events, imu_sorted)
        if any(e.get("device_ms") is not None for e in resolved):
            merged = _annotate_stages(merged, resolved)
        else:
            warnings.append(
                "Stage events present but couldn't be aligned to device_ms — "
                "no sync pulse (phase=9) found in IMU data."
            )

    merged.to_csv(output_path, index=False)

    if stage_events and "stage" in merged.columns:
        per_stage_paths = _write_per_stage_csvs(merged, output_path)

    # Build preview (first 20 rows). Cast to object dtype first so NaN/NA
    # values become Python None rather than staying as float NaN (which
    # FastAPI's JSON encoder rejects with a 500).
    preview_df = merged.head(20).astype(object)
    preview_rows = preview_df.where(preview_df.notna(), None).to_dict("records")

    return (
        preview_rows, warnings, len(merged),
        calibration, sync_alignment, per_stage_paths,
    )
