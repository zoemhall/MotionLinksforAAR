# MotionLinksforAAR

Submission content to support an MEng Master's project investigating whether audio biofeedback can influence walking gait and create a sense of agency. All data is anonymised using consistent Participant IDs. Health or observational notes have been excluded.

---

## Folder Overview

### `Code_versions/`
Iterative development of the Max/MSP audio patch and microcontroller firmware, numbered in order of development (1–8). Each folder represents a stage in building the live biofeedback system. The final version used in the study is **`7FinalTestCode1`**.

To open a patch, launch [Max/MSP](https://cycling74.com/downloads) and open the `.maxpat` file inside the relevant folder.

---

### `Data_analysis/`
Jupyter notebooks for the full data analysis pipeline. Covers pressure sensor processing, gait metrics, agency scores, and demographic analysis. The final study analysis is in **`t6_finaldataset/`**; earlier folders (t1–t5) show the iterative development phases.

**Requirements:** Python 3.9+

```bash
pip install numpy pandas scipy matplotlib ipywidgets openpyxl jupyterlab
jupyterlab
```

Run the notebooks in this order (from `t6_finaldataset/`):
1. `01_pressure_analysis.ipynb`
2. `02_behavioral_analysis.ipynb`
3. `03_weight_analysis.ipynb`
4. `04_agency_analysis.ipynb`
5. `05_demographic_analysis.ipynb`

---

### `Test_web_app/`
A locally-hosted web app used to manage the live test sessions — connecting to the wearable insole over Bluetooth, recording IMU and pressure data, and administering post-condition questionnaires. Runs entirely on the researcher's machine; nothing is sent to the internet.

**Requirements:** Python 3.10+

```bash
cd Test_web_app
pip install -r requirements.txt
python app.py
```

Then open `http://127.0.0.1:8000` in a browser.

> Note: Bluetooth functionality requires the physical Seeed XIAO nRF52840 Sense hardware. The session management and questionnaire features work without it.

