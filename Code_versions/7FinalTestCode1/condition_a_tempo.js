// condition_a_tempo.js — Max/MSP js object
// Outputs a playback rate multiplier on every real heel strike.
// The sensor ALWAYS triggers audio — this js only modulates HOW it sounds.
// The rate ramps gradually from 1.0 toward faster or slower over the condition.
//
// Wire the sensor heel strike bang to send "step" here AND to synthengine as normal.
// Wire outlet 0 to whatever parameter controls perceived speed in synthengine
// (e.g. envelope time multiplier, filter cutoff, or groove~ rate).
//
// Messages (inlet 0):
//   step              — call on every real heel strike (pacing + condition A)
//   capture <1|-1>    — call when advancing from pacing to condition A
//                       locks in baseline cadence, starts rate ramp
//   deactivate        — call when condition A ends, resets to rate 1.0
//   set_magnitude <f> — drift fraction, default 0.15 (15% faster or slower)
//   set_duration <f>  — ramp duration ms, default 240000 (4 min)
//   tick              — send from [metro 1000] for elapsed display
//
// Outlets:
//   0 — rate multiplier (float) → e.g. groove~ rate, envelope time scaler
//        1.0 = baseline, >1.0 = faster, <1.0 = slower
//   1 — live SPM (float) → experimenter display
//   2 — elapsed seconds in condition → experimenter display
//   3 — log string for CSV

inlets  = 1;
outlets = 4;

var active        = false;
var direction     = 1;       // 1 = faster, -1 = slower
var magnitude     = 0.15;    // 15% drift from baseline rate
var durationMs    = 240000;  // 4 minutes
var startTime     = 0;
var currentRate   = 1.0;
var targetRate    = 1.0;

// Rolling cadence tracker
var stepHistory  = [];
var lastStepTime = -1;
var HISTORY_SIZE = 6;

// ── step — called on every real heel strike ───────────────────────────────────

function step() {
    var now = Date.now();

    // Always track cadence for SPM display
    if (lastStepTime > 0) {
        var interval = now - lastStepTime;
        if (interval > 200 && interval < 2000) {
            stepHistory.push(interval);
            if (stepHistory.length > HISTORY_SIZE) stepHistory.shift();
        }
    }
    lastStepTime = now;

    // Live SPM display
    if (stepHistory.length >= 2) {
        var avg = stepHistory.reduce(function(a, b) { return a + b; }) / stepHistory.length;
        outlet(1, 60000 / avg);
    }

    // During condition A: compute and output current rate
    if (active) {
        var elapsed = now - startTime;
        var phase   = Math.min(elapsed / durationMs, 1.0);
        currentRate = 1.0 + phase * (targetRate - 1.0);  // ramp from 1.0 to target
        outlet(0, currentRate);
        outlet(3, "A_RATE," + now + "," + currentRate.toFixed(4) + "," + phase.toFixed(4));
    }
}

// ── capture — call when advancing from pacing to condition A ──────────────────

function capture(dir) {
    direction   = (dir >= 0) ? 1 : -1;
    targetRate  = 1.0 + direction * magnitude;  // e.g. 1.15 faster, 0.85 slower
    startTime   = Date.now();
    currentRate = 1.0;
    active      = true;

    // Reset cadence history — keep SPM tracking fresh for condition
    stepHistory  = [];
    lastStepTime = -1;

    post("Condition A active — " + (direction === 1 ? "faster" : "slower") + "\n");
    post("  Target rate: " + targetRate.toFixed(2) + "x over " + (durationMs/60000).toFixed(0) + " min\n");
}

// ── deactivate — call when condition A ends ───────────────────────────────────

function deactivate() {
    active      = false;
    currentRate = 1.0;
    outlet(0, 1.0);  // return to baseline rate
    post("Condition A deactivated — rate reset to 1.0\n");
}

// ── tick — send from metro 1000 for elapsed display ──────────────────────────

function tick() {
    if (active) {
        outlet(2, Math.floor((Date.now() - startTime) / 1000));
    }
}

// ── config ────────────────────────────────────────────────────────────────────

function set_magnitude(val) { magnitude  = Math.max(0.05, Math.min(0.30, val)); }
function set_duration(val)  { durationMs = val; }
