// condition_b_weight.js — Max/MSP js object
// Maps heel pressure at each strike to EQ gain targets for weight perception.
// Pipe outlets 0 and 1 through [line 500] before filtercoeff~ — do not skip this.
//
// Inlets:
//   0 — messages: activate <dir>, deactivate, set_max_gain <float>
//       "left"  — left heel strike trigger (snapshots current left heel pressure)
//       "right" — right heel strike trigger (snapshots current right heel pressure)
//   1 — continuous pressure values as a list: left_toe left_heel right_toe right_heel
//
// Outlets:
//   0 — low_gain_dB  → [line 500] → [filtercoeff~ lowshelf 150 0.707]  → [biquad~]
//   1 — high_gain_dB → [line 500] → [filtercoeff~ highshelf 2500 0.707] → [biquad~]
//   2 — log string

inlets = 2;
outlets = 3;

var active    = false;
var direction = 1;
var maxGain   = 12.0;

// Stores latest continuous pressure values per zone
var leftToe   = 0;
var leftHeel  = 0;
var rightToe  = 0;
var rightHeel = 0;

// ── Inlet 1 — continuous pressure list ───────────────────────────────────────
// Send a list into inlet 1: left_toe left_heel right_toe right_heel

function list() {
    if (inlet === 1) {
        leftToe   = arguments[0] || 0;
        leftHeel  = arguments[1] || 0;
        rightToe  = arguments[2] || 0;
        rightHeel = arguments[3] || 0;
    }
}

// ── Inlet 0 — trigger messages and control ────────────────────────────────────

function left() {
    if (!active) return;
    computeEQ(leftHeel);
}

function right() {
    if (!active) return;
    computeEQ(rightHeel);
}

function activate(dir) {
    active    = true;
    direction = (dir >= 0) ? 1 : -1;
    post("Condition B active — direction: " + (direction === 1 ? "heavier" : "lighter") + "\n");
}

function deactivate() {
    active = false;
    outlet(0, 0.0);
    outlet(1, 0.0);
    post("Condition B deactivated — EQ returning to flat\n");
}

function set_max_gain(val) {
    maxGain = Math.max(6, Math.min(24, val));
    post("Max gain set to ±" + maxGain + " dB\n");
}

// ── EQ computation ────────────────────────────────────────────────────────────

function computeEQ(heelPressure) {
    var norm     = Math.max(0, Math.min(1, heelPressure));
    var lowGain  = direction * (norm * 2 - 1) * maxGain;
    var highGain = -lowGain;
    outlet(0, lowGain);
    outlet(1, highGain);
    outlet(2, "B_EQ," + Date.now() + "," + norm.toFixed(3) + "," + lowGain.toFixed(1));
}
