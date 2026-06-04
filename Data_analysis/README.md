# Gait Manipulation via Audio Feedback — Masters Thesis Data Analysis

This repository contains the full data analysis pipeline for a study investigating how audio feedback (tempo and weight sound manipulation) influences human gait patterns. Participants walked on a treadmill while audio cues attempted to shift their step cadence and weight distribution. The study measures both the degree of gait adaptation and its relationship to participants' subjective sense of agency.

---

## Study Overview

Two audio manipulation conditions were tested across 23 participants:

| Condition | Mechanism | Target |
|---|---|---|
| **Tempo** | Sigmoid cadence ramp via metronome-like beats | Shift step frequency up or down |
| **Weight** | Heel/toe emphasis via asymmetric audio cues | Shift foot strike pattern |

Gait was recorded using a 12-sensor pressure insole and 6-DOF IMU sensors in both shoes. Participants also completed a questionnaire capturing their sense of agency (perceived control) and immersion.

---

## Repository Structure

```
.
├── README.md                        # This file
├── repair_pressure_files.py         # Data repair script (run before analysis)
├── repair_log.txt                   # Log of all repairs applied to raw data
│
├── t1_different_activities/         # Phase 1: baseline activity recognition
├── t2_timetocalibrate/              # Phase 2: calibration duration study
├── t3_calibrationphase/             # Phase 3: device calibration
├── t4_updatedlatency/               # Phase 4: system latency measurements
├── t5_mocktrial/                    # Phase 5: full pilot run
│
└── t6_finaldataset/                 # FINAL STUDY — main analysis (see below)
    ├── README.md                    # Notebook guide for assessors
    ├── 01_pressure_analysis.ipynb
    ├── 02_behavioral_analysis.ipynb
    ├── 03_weight_analysis.ipynb
    ├── 04_agency_analysis.ipynb
    ├── 05_demographic_analysis.ipynb
    ├── Test 6_summary.xlsx          # Demographics and questionnaire data
    ├── 01/, 03/, 05/ … 40/          # Per-participant sensor data (23 folders)
    └── exports/                     # Generated figures, tables, and CSVs
```

### Development phases (T1–T5)

Each folder contains raw sensor CSVs and a `pressure_timeseries.ipynb` notebook used to visualise and validate the data at that stage. They are included to show the iterative development of the study design. The final analysis is entirely within `t6_finaldataset/`.

---

## Data Format

Each participant folder in `t6_finaldataset/` contains:

| File pattern | Contents |
|---|---|
| `{PID}_pressure.csv` | Combined 12-sensor pressure insole data |
| `{PID}_pressure_tempo.csv` | Pressure during tempo condition |
| `{PID}_pressure_weight.csv` | Pressure during weight condition |
| `{PID}_imu_L.csv` / `_R.csv` | Left/right shoe IMU (6-DOF: accel + gyro) |
| `{PID}_questionnaire.csv` | Post-session questionnaire responses |

Pressure CSVs are semicolon-delimited with columns: `timestamp_ms`, `sensor_1` … `sensor_12`.  
IMU CSVs include: `timestamp_ms`, `ax`, `ay`, `az`, `gx`, `gy`, `gz`.

---

## How to Run

**Requirements:** Python 3.9+

```bash
pip install numpy pandas scipy matplotlib ipywidgets openpyxl jupyterlab
```

**Execution order for T6:**

1. `01_pressure_analysis.ipynb` — loads and processes all sensor data, extracts cadence, exports results
2. `02_behavioral_analysis.ipynb` — pressure asymmetry and temporal gait patterns (depends on step 1)
3. `03_weight_analysis.ipynb` — weight manipulation influence scores (independent)
4. `04_agency_analysis.ipynb` — agency vs. gait adaptation correlations (depends on steps 1 and 3)
5. `05_demographic_analysis.ipynb` — gender, age, shoe size effects (depends on step 1)

The `repair_pressure_files.py` script was used to fix corrupted raw data before analysis. It does not need to be re-run; all files in the participant folders are already in their repaired state.

---

## Key Outputs

All results are written to `t6_finaldataset/exports/`:

| File | Description |
|---|---|
| `tempo_influence_table.csv` | Per-participant tempo influence scores and agency ratings |
| `weight_influence_table.csv` | Per-participant weight influence scores and categories |
| `figure5/influence_table.csv` | Combined influence metrics for both conditions |
| `figures/` | Analysis figures (PNG) |
| `demographic_analysis/` | Demographic correlation tables and plots |
