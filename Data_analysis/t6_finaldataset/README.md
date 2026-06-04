# T6 Final Dataset — Notebook Guide

This folder contains the complete analysis for the final study (23 participants). Run the notebooks in the numbered order below; each one reads from the `exports/` folder populated by earlier notebooks.

---

## Notebooks

| Notebook | Purpose | Dependencies |
|---|---|---|
| `01_pressure_analysis.ipynb` | Loads all sensor data, extracts step cadence, generates per-participant cadence trajectories, and exports the main results tables used by later notebooks | None — run this first |
| `02_behavioral_analysis.ipynb` | Analyses left/right pressure asymmetry and temporal gait patterns across participants | Requires `01` exports |
| `03_weight_analysis.ipynb` | Calculates weight manipulation influence scores (0–1 scale) and classifies each participant's response profile | Independent — can run in any order |
| `04_agency_analysis.ipynb` | Correlates participants' sense of agency (questionnaire) with their gait adaptation scores for both weight and tempo conditions | Requires `01` and `03` exports |
| `05_demographic_analysis.ipynb` | Tests whether gender, age, or shoe size predict cadence response or influence score | Requires `01` exports |

---

## Data

- **Participant folders** (`01/`, `03/`, `05/`–`40/`): raw sensor CSVs for each participant
- **`Test 6_summary.xlsx`**: demographics and questionnaire scores (read by `04` and `05`)
- **`exports/`**: all generated figures and CSVs — populated when notebooks are run

### Participant IDs

IDs with gaps in the sequence (02, 04, 08, 12, 14, 15, 17, 20–29) were excluded from the final dataset. The `exclusion dataset/` folder contains data for excluded participants.

### Influence categories (weight condition)

| Category | Meaning |
|---|---|
| Consistent influence | Clear, sustained gait adaptation towards the audio target |
| Subconscious correction | Participant's gait moved opposite to target — resisting the cue |
| Impact only from drift phases | Response only visible during sensor drift periods, not reliable |
| No clear effect | No consistent gait change detected |

---

## Key variables

| Variable | Description |
|---|---|
| `influence_score` | 0–1 normalised gait coupling strength |
| `pct_change` | % cadence change from baseline to trial end |
| `correct_direction` | Whether cadence moved towards the target (binary) |
| `agency_aggregate` | Mean of three agency Likert items (1–10 scale) |
| `ueqs_pragmatic` | UEQ-S pragmatic quality subscale |
| `ari_immersion` | ARI immersion score |
