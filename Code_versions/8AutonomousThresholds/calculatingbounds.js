// stepdetector.js
// Receives raw ADC pressure values (0–1023) for 4 sensor zones
// Place BEFORE signal processing in the chain
//
// Inlet 0:  list [lt, lh, rt, rh]  — raw pressure, 0–1023
//
// Outlet 0: [channel, value]        — trigger when step detected
// Outlet 1: [lo0, lo1, lo2, lo3]   — lower bounds → scale~ lo inlets
// Outlet 2: [hi0, hi1, hi2, hi3]   — upper bounds → scale~ hi inlets

inlets  = 1;
outlets = 4;
autowatch = 1;

var N = 4;

// Window sizes in messages (snapshot~ every 5ms = 200 msgs/sec)
var LO_WINDOW   = 80;   // 400ms  — baseline tracking (short: reacts to foot lifting)
var HI_WINDOW   = 600;  // 3s     — peak tracking     (long: holds step maximum)

// Step detection parameters
var ON_RATIO    = 0.70; // fire trigger above 70% of (hi - lo) range
var OFF_RATIO   = 0.35; // re-arm below 35% of range
var MIN_RANGE   = 80;   // minimum ADC range to trust — ignores sensor noise floor
var DEBOUNCE    = 60;   // min messages between triggers (60 × 5ms = 300ms)

// Per-channel state
var loHistory   = [[], [], [], []];
var hiHistory   = [[], [], [], []];
var isActive    = [false, false, false, false];
var sinceLastTrigger = [999, 999, 999, 999];

// Output arrays — reused each message to avoid GC pressure
var loOut = [0, 0, 0, 0];
var hiOut = [1023, 1023, 1023, 1023];

function list() {
    var args = arrayfromargs(arguments);
    if (args.length < N) return;

    for (var i = 0; i < N; i++) {
        sinceLastTrigger[i]++;
        var val = args[i];

        // --- rolling windows ---
        loHistory[i].push(val);
        if (loHistory[i].length > LO_WINDOW) loHistory[i].shift();

        hiHistory[i].push(val);
        if (hiHistory[i].length > HI_WINDOW) hiHistory[i].shift();

        // lower bound: minimum of short window (resting/baseline pressure)
        loOut[i] = arrayMin(loHistory[i]);

        // upper bound: maximum of long window (peak step pressure)
        hiOut[i] = arrayMax(hiHistory[i]);

        var lo    = loOut[i];
        var hi    = hiOut[i];
        var range = hi - lo;

        // --- step detection ---
        if (range > MIN_RANGE && loHistory[i].length >= 8) {
            var onThresh  = lo + range * ON_RATIO;
            var offThresh = lo + range * OFF_RATIO;

            if (!isActive[i]) {
                if (val > onThresh && sinceLastTrigger[i] > DEBOUNCE) {
                    isActive[i] = true;
                    sinceLastTrigger[i] = 0;
                    outlet(0, i, val); // channel index + raw pressure value
                }
            } else {
                if (val < offThresh) {
                    isActive[i] = false; // re-arm for next step
                }
            }
        }
    }

    // output bounds every message for downstream scale~
    outlet(3, +isActive[0], +isActive[1], +isActive[2], +isActive[3]);
    outlet(2, hiOut[0], hiOut[1], hiOut[2], hiOut[3]);
    outlet(1, loOut[0], loOut[1], loOut[2], loOut[3]);
}

// --- helpers ---
function arrayMin(arr) {
    var m = arr[0];
    for (var i = 1; i < arr.length; i++) if (arr[i] < m) m = arr[i];
    return m;
}

function arrayMax(arr) {
    var m = arr[0];
    for (var i = 1; i < arr.length; i++) if (arr[i] > m) m = arr[i];
    return m;
}

// --- runtime-adjustable via Max messages ---
function on_ratio(v)   { ON_RATIO  = clip(v, 0.4, 0.95);
                         post("on_ratio: "  + ON_RATIO  + "\n"); }
function off_ratio(v)  { OFF_RATIO = clip(v, 0.1, 0.6);
                         post("off_ratio: " + OFF_RATIO + "\n"); }
function debounce(v)   { DEBOUNCE  = Math.max(1, Math.floor(v / 5));
                         post("debounce: "  + (DEBOUNCE * 5) + "ms\n"); }
function min_range(v)  { MIN_RANGE = Math.max(10, v);
                         post("min_range: " + MIN_RANGE + "\n"); }
function lo_window(v)  { LO_WINDOW = Math.max(8, Math.floor(v / 5));
                         post("lo_window: " + (LO_WINDOW * 5) + "ms\n"); }
function hi_window(v)  { HI_WINDOW = Math.max(20, Math.floor(v / 5));
                         post("hi_window: " + (HI_WINDOW * 5) + "ms\n"); }

function reset() {
    for (var i = 0; i < N; i++) {
        loHistory[i] = []; hiHistory[i] = [];
        isActive[i]  = false;
        sinceLastTrigger[i] = 999;
        loOut[i] = 0; hiOut[i] = 1023;
    }
    post("stepdetector reset\n");
}

function clip(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }