// walkingsim.js
// Simulates 4-channel insole pressure data as realistic walking
// Calibrated directly from real sensor recordings (May 2026 sessions)
//
// Outlet 0: list [lt, lh, rt, rh]  — raw ADC values 0–1023
//           same format as real sensor → connect to js stepdetector.js
//
// Messages:
//   bang          toggle start / stop
//   start         begin simulation
//   stop          halt simulation
//   bpm [40-180]  steps per minute per foot (default 90)
//   noise [0-100] sensor noise amplitude in ADC units (default 22)
//   reset         restart phase to 0

inlets  = 1;
outlets = 1;
autowatch = 1;

// ─── gait parameters ────────────────────────────────────────────────────────
var stepBpm  = 90;   // steps per minute per foot → stride = 2× this period
var noiseAmp = 22;   // ± ADC units of gaussian-like noise
var UPDATE   = 5;    // ms per tick — match your snapshot~ rate

// ─── channel ADC ranges (from real calibration data) ────────────────────────
// min = swing/offloaded value   max = peak impact value
var RANGE = {
    lt: { min: 203, max: 853 },   // left toe:  wide range, nearly unloads in swing
    lh: { min: 792, max: 916 },   // left heel: stays relatively high throughout
    rt: { min: 130, max: 848 },   // right toe: widest range of all four sensors
    rh: { min: 585, max: 919 }    // right heel: unloads moderately in swing
};

// ─── gait envelopes ─────────────────────────────────────────────────────────
// Key points [phase 0-1, envelope 0-1] derived from real stride data.
// Phase 0 = right heel strike, 0.5 = left heel strike, 1.0 = next right strike.
// Envelope is then scaled to each channel's ADC min/max range.

var ENVELOPE = {
    // Right heel: impacts at 0, peaks mid-stance, swings 0.50-0.95
    rh: [[0.00, 0.94],[0.05, 0.95],[0.35, 1.00],[0.43, 0.65],
         [0.50, 0.00],[0.65, 0.59],[0.80, 0.53],[0.95, 0.83],[1.00, 0.94]],

    // Right toe: loaded throughout R stance, rapid drop at toe-off ~0.42
    rt: [[0.00, 0.99],[0.30, 1.00],[0.43, 0.19],[0.50, 0.00],
         [0.65, 0.54],[0.80, 0.67],[0.95, 0.93],[1.00, 0.99]],

    // Left heel: in late stance at 0, swings 0.10-0.50, re-strikes at 0.50
    lh: [[0.00, 0.96],[0.10, 0.71],[0.25, 0.30],[0.45, 0.40],
         [0.50, 0.65],[0.65, 0.91],[0.85, 0.94],[1.00, 1.00]],

    // Left toe: toe-off at 0, minimum in swing 0.05, loads as heel descends
    lt: [[0.00, 0.12],[0.05, 0.00],[0.10, 0.40],[0.25, 0.71],
         [0.45, 0.91],[0.66, 0.96],[0.90, 0.97],[0.95, 0.56],[1.00, 0.12]]
};

// ─── state ──────────────────────────────────────────────────────────────────
var phase   = 0.55;      // current gait phase [0-1]
var simTask = null;

// ─── main tick ──────────────────────────────────────────────────────────────
function tick() {
    var strideMs  = (60000 / stepBpm) * 2;   // full stride = 2 × step period
    phase = (phase + UPDATE / strideMs) % 1.0;

    var lt = adcValue(ENVELOPE.lh, RANGE.lh, phase);
    var lh = adcValue(ENVELOPE.lt, RANGE.lt, phase);
    var rt = adcValue(ENVELOPE.rh, RANGE.rh, phase);
    var rh = adcValue(ENVELOPE.rt, RANGE.rt, phase);

    outlet(0, lt, lh, rt, rh);
}

function msg_int(v)   { if (v) start(); else stop(); }
function msg_float(v) { if (v) start(); else stop(); }

// ─── envelope interpolation + ADC scaling ───────────────────────────────────
function adcValue(keypoints, range, ph) {
    var env = interpolate(keypoints, ph);
    var noise = (Math.random() + Math.random() - 1.0) * noiseAmp; // roughly normal
    var raw = range.min + (range.max - range.min) * env + noise;
    return Math.max(0, Math.min(1023, Math.round(raw)));
}

function interpolate(kp, ph) {
    // find surrounding key points and linearly interpolate
    for (var i = 0; i < kp.length - 1; i++) {
        if (ph >= kp[i][0] && ph <= kp[i+1][0]) {
            var t = (ph - kp[i][0]) / (kp[i+1][0] - kp[i][0]);
            t = t * t * (3 - 2 * t); // smoothstep — removes sharp corners
            return kp[i][1] + (kp[i+1][1] - kp[i][1]) * t;
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
