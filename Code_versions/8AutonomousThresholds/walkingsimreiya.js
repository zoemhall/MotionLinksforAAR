// walkingsim.js
// Simulates 4-channel insole pressure data as realistic walking.
// Recalibrated from real sensor session: pondering-18-5-2026--10-50-43.csv
//
// Analysis method:
//   - 2014 rows total; rows 0-737 are stationary (values clustered at sensor ceiling)
//   - Active walking section: rows 738-2013 (~6.4 seconds of walking)
//   - Channel mapping confirmed by swing-time analysis and cross-correlation:
//       c7 → lt  (left toe,  58% swing time, std=197)
//       c2 → lh  (left heel, 8%  swing time, std=153)
//       c11 → rt (right toe, 64% swing time, std=179)
//       c4 → rh  (right heel,11% swing time, std=158)
//   - Envelopes averaged across 8 clean mid-session strides
//   - ADC ranges taken from active walking section only (excludes resting floor)
//
// NOTE: The previous walkingsim.js applied lh envelope/range to the `lt` variable
// and vice versa (and same swap on the right). This version corrects that:
// each variable now uses its own correctly-labelled envelope and range.
// If your stepdetector expects the old swapped order, swap the outlets back.
//
// Outlet 0: list [lt, lh, rt, rh]  — raw ADC values 0–1023
//           same format as real sensor → connect to js stepdetector.js
//
// Messages:
//   bang          toggle start / stop
//   start         begin simulation
//   stop          halt simulation
//   bpm [40-180]  steps per minute per foot (default 100)
//   noise [0-100] sensor noise amplitude in ADC units (default 20)
//   reset         restart phase to 0

inlets  = 1;
outlets = 1;
autowatch = 1;

// ─── gait parameters ────────────────────────────────────────────────────────
var stepBpm  = 100;  // steps per minute per foot — observed ~100-110 in session
var noiseAmp = 20;   // ± ADC units of gaussian-like noise
var UPDATE   = 5;    // ms per tick — match your snapshot~ rate

// ─── channel ADC ranges ─────────────────────────────────────────────────────
// Derived from active walking section of pondering-18-5-2026--10-50-43.csv.
// Previous calibration (May 2026) had wider ranges — these are tighter
// because they exclude the resting ceiling period at the start.
// lt and rt have meaningfully lower maxima than the heel sensors,
// consistent with toes not fully loading during normal walking pace.
var RANGE = {
    lt: { min: 249, max: 624 },   // left toe:  narrower range — toe never fully loads
    lh: { min: 249, max: 813 },   // left heel: wide range, clear swing unloading
    rt: { min: 304, max: 776 },   // right toe: similar to lt, slightly higher floor
    rh: { min: 304, max: 824 }    // right heel: widest range, clearest heel strikes
};

// ─── gait envelopes ─────────────────────────────────────────────────────────
// Keypoints [phase 0-1, envelope 0-1] averaged across 8 mid-session strides.
// Phase 0 = right heel strike. Phase ~0.5 = left heel strike.
// Smoothstep interpolation is applied between keypoints in adcValue().
//
// Reading the envelopes:
//   rh — loads rapidly after phase 0 (heel strike), stays loaded to ~0.50,
//        unloads at toe-off (~0.55), swings low from 0.65-0.95
//   rt — delayed loading after rh strike (toe makes contact later),
//        peaks at ~0.55 (late stance), drops at toe-off, swings 0.65-0.95
//   lh — in late stance at phase 0 (dropping from previous cycle),
//        fully in swing 0.08-0.45, strikes ~0.50, fully loaded 0.65-0.95
//   lt — loaded at phase 0 (lh late stance), swings 0.08-0.80,
//        reloads through 0.85-1.0 as lh moves into late stance

var ENVELOPE = {
    rh: [
        [0.00, 0.38],   // phase start — rh just beginning to load from swing
        [0.08, 0.95],   // rapid heel loading — heel strike impact
        [0.17, 0.99],   // peak impact
        [0.25, 1.00],   // full weight bearing — midstance
        [0.35, 1.00],   // weight still through heel
        [0.45, 0.94],   // beginning to shift forward to toe
        [0.55, 0.36],   // toe-off approaching — heel unloading
        [0.65, 0.02],   // minimum — rh in swing
        [0.75, 0.21],   // still in swing
        [0.85, 0.31],   // still in swing, slight passive loading
        [0.95, 0.29],   // approaching next heel strike
        [1.00, 0.38]    // wraps to phase 0
    ],

    rt: [
        [0.00, 0.09],   // rh just struck — rt toe still off-ground (heel leads)
        [0.08, 0.09],   // rt still not in contact
        [0.17, 0.09],   // beginning of outstep roll
        [0.25, 0.11],   // loading gradually through outstep
        [0.35, 0.31],   // toe starts loading in late stance
        [0.45, 0.63],   // significant toe loading — propulsive phase
        [0.55, 1.00],   // peak toe pressure just before toe-off
        [0.65, 0.07],   // toe-off — rapid unloading
        [0.75, 0.00],   // rt in swing
        [0.85, 0.00],   // rt in swing
        [0.95, 0.00],   // rt in swing
        [1.00, 0.09]    // wraps to phase 0
    ],

    lh: [
        [0.00, 0.65],   // lh in late stance from previous cycle
        [0.08, 0.07],   // lh toe-off — drops sharply into swing
        [0.17, 0.11],   // lh in swing — near minimum
        [0.25, 0.28],   // lh mid-swing
        [0.35, 0.45],   // lh approaching heel strike
        [0.45, 0.47],   // lh heel contact beginning
        [0.55, 0.82],   // lh loading rapidly after strike
        [0.65, 0.99],   // lh in full stance
        [0.75, 1.00],   // midstance — maximum loading
        [0.85, 1.00],   // lh still fully loaded
        [0.95, 0.94],   // beginning to shift weight forward to lt
        [1.00, 0.85]    // wraps to phase 0 — lh in late stance
    ],

    lt: [
        [0.00, 0.88],   // lt loaded — lh in late stance, lt propelling
        [0.08, 0.41],   // lh toe-off — lt rapidly unloading into swing
        [0.17, 0.05],   // lt in swing — near minimum
        [0.25, 0.00],   // lt fully in swing
        [0.35, 0.00],   // lt fully in swing
        [0.45, 0.00],   // lt fully in swing
        [0.55, 0.00],   // lh just struck — lt toe still off-ground
        [0.65, 0.00],   // lt still not in contact (heel leads)
        [0.75, 0.00],   // lt beginning outstep roll
        [0.85, 0.09],   // lt starts loading in lh late stance
        [0.95, 0.55],   // lt significant loading — propulsive phase
        [1.00, 0.84]    // lt near peak — wraps to phase 0
    ]
};

// ─── state ──────────────────────────────────────────────────────────────────
var phase   = 0.0;
var simTask = null;

// ─── main tick ──────────────────────────────────────────────────────────────
function tick() {
    var strideMs = (60000 / stepBpm) * 2;  // full stride = 2 × step period
    phase = (phase + UPDATE / strideMs) % 1.0;

    var lt = adcValue(ENVELOPE.lt, RANGE.lt, phase);
    var lh = adcValue(ENVELOPE.lh, RANGE.lh, phase);
    var rt = adcValue(ENVELOPE.rt, RANGE.rt, phase);
    var rh = adcValue(ENVELOPE.rh, RANGE.rh, phase);

    outlet(0, lt, lh, rt, rh);
}

function msg_int(v)   { if (v) start(); else stop(); }
function msg_float(v) { if (v) start(); else stop(); }

// ─── envelope interpolation + ADC scaling ───────────────────────────────────
function adcValue(keypoints, range, ph) {
    var env   = interpolate(keypoints, ph);
    var noise = (Math.random() + Math.random() - 1.0) * noiseAmp; // roughly normal
    var raw   = range.min + (range.max - range.min) * env + noise;
    return Math.max(0, Math.min(1023, Math.round(raw)));
}

function interpolate(kp, ph) {
    // Wrap-safe: check last segment back to first keypoint
    for (var i = 0; i < kp.length - 1; i++) {
        if (ph >= kp[i][0] && ph <= kp[i + 1][0]) {
            var t = (ph - kp[i][0]) / (kp[i + 1][0] - kp[i][0]);
            t = t * t * (3 - 2 * t); // smoothstep — removes sharp corners
            return kp[i][1] + (kp[i + 1][1] - kp[i][1]) * t;
        }
    }
    return kp[kp.length - 1][1];
}

// ─── control messages ────────────────────────────────────────────────────────
function start() {
    if (simTask) simTask.cancel();
    simTask = new Task(tick, this);
    simTask.interval = UPDATE;
    simTask.repeat();
    post("walkingsim: started at " + stepBpm + " BPM\n");
}

function stop() {
    if (simTask) { simTask.cancel(); simTask = null; }
    post("walkingsim: stopped\n");
}

function bang() { if (simTask) stop(); else start(); }

function reset() {
    phase = 0;
    post("walkingsim: phase reset\n");
}

function bpm(v) {
    stepBpm = Math.max(40, Math.min(180, v));
    post("walkingsim: BPM = " + stepBpm + "\n");
}

function noise(v) {
    noiseAmp = Math.max(0, v);
    post("walkingsim: noise = " + noiseAmp + "\n");
}
