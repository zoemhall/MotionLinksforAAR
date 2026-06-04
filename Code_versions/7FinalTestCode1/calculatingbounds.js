// Javascript code to be added within Max MSP sub patch
// Computes trigger bounds for 4 foot sensor zones from calibration data.
//
// Key changes from previous version:
//   1. Zero values are filtered before computing bounds, zero readings are
//      sensor disconnections or noise, not real pressure data. The original
//      code included them, causing bounds of [0, 0] for intermittently
//      disconnected sensors (e.g. a sensor outputting zeros 88% of the time).
//   2. Bounds are now anchored to the UPPER distribution (actual step peaks)
//      rather than symmetric around the median. At 95 BPM the steps are in
//      the top fraction of readings. The lower bound is placed to guarantee
//      at least the expected number of steps can trigger.
//   3. Actual data duration is measured from timestamps rather than assumed.
//   4. Post() messages report warnings and errors to the Max console so sensor
//      issues are visible during calibration.
//   5. No need for a sensitivity input value anymore! it's still in the code if there are any issues.

inlets = 1;
outlets = 1;

var l_toe  = [];
var l_heel = [];
var r_toe  = [];
var r_heel = [];
var sensitivity = 0.5;

// Timestamps used to compute actual recording duration
var firstTimestamp = -1;
var lastTimestamp  = -1;

// Walking parameters
var TARGET_BPM = 95;

// Each step spans roughly this many data rows above the lower bound.
// Derived from: ~228 rows / 30s / (95bpm/60) * 2feet ≈ 5 rows/step,
// but conservatively set lower to capture the full stance phase, not just peak.
var ROWS_PER_STEP_FACTOR = 4.0;

// Sensors with range below this after zero-removal are flagged as errors.
var MIN_RANGE = 20;

// ─────────────────────────────────────────────────────────────────────────────
// Public interface
// ─────────────────────────────────────────────────────────────────────────────

function msg_float(v) {
    sensitivity = Math.max(0.1, Math.min(0.9, v));
    bang();
}

function clear() {
    l_toe  = [];
    l_heel = [];
    r_toe  = [];
    r_heel = [];
    firstTimestamp = -1;
    lastTimestamp  = -1;
}

function list() {
    var a = arrayfromargs(arguments);
    if (a.length < 5) return;

    // Track actual recording duration from timestamps
    var ts = Number(a[0]);
    if (firstTimestamp < 0) firstTimestamp = ts;
    lastTimestamp = ts;

    // Clean and store each sensor zone value
    var lt = cleanValue(a[1]);
    var lh = cleanValue(a[2]);
    var rt = cleanValue(a[3]);
    var rh = cleanValue(a[4]);

    // -1 means the value was unreadable (bad glitch) — discard
    if (lt >= 0) l_toe.push(lt);
    if (lh >= 0) l_heel.push(lh);
    if (rt >= 0) r_toe.push(rt);
    if (rh >= 0) r_heel.push(rh);
}

function bang() {
    if (l_toe.length === 0) {
        post("No data loaded. Dump coll contents first.\n");
        return;
    }

    // Compute actual duration from timestamps in the data
    var durationS = (lastTimestamp - firstTimestamp) / 1000;
    if (durationS <= 0) durationS = 30; // fallback if timestamps missing

    // Expected steps per foot given walking rate and recording length
    var expectedSteps = Math.round((TARGET_BPM / 60) * durationS / 2);

    post("─────────────────────────────────────\n");
    post("Calibration | " + Math.round(durationS) + "s | " + TARGET_BPM +
         " BPM | ~" + expectedSteps + " steps/foot expected\n");

    var b_lt = computeBounds(l_toe,  "L-Toe",  expectedSteps, durationS);
    var b_lh = computeBounds(l_heel, "L-Heel", expectedSteps, durationS);
    var b_rt = computeBounds(r_toe,  "R-Toe",  expectedSteps, durationS);
    var b_rh = computeBounds(r_heel, "R-Heel", expectedSteps, durationS);

    post("─────────────────────────────────────\n");

    outlet(0, [b_lt[0], b_lt[1],
               b_lh[0], b_lh[1],
               b_rt[0], b_rt[1],
               b_rh[0], b_rh[1]]);
}

// ─────────────────────────────────────────────────────────────────────────────
// Core bounds computation
// ─────────────────────────────────────────────────────────────────────────────

// Helper function to count simulated step triggers given a lower bound threshold.
function countSteps(data, lowerBound, minGap) {
    var steps = 0;
    var inStep = false;
    var lastStepIdx = -minGap - 1;
    for (var i = 0; i < data.length; i++) {
        if (data[i] >= lowerBound) {
            if (!inStep) {
                if (i - lastStepIdx >= minGap) {
                    steps++;
                    lastStepIdx = i;
                }
                inStep = true;
            }
        } else {
            inStep = false;
        }
    }
    return steps;
}

// Returns [lowerBound, upperBound].
// Always returns two valid numbers. Errors are reported via post() to the Max console.
function computeBounds(rawData, name, expectedSteps, durationS) {

    var sampleRate = rawData.length / durationS;
    var minGapSamples = Math.max(1, Math.floor(sampleRate * 0.6)); // 0.6 seconds minimum between steps

    // ── Step 1: filter zeros ─────────────────────────────────────────────────
    // Zero readings are sensor disconnections or noise, not real pressure data.
    var active = [];
    for (var i = 0; i < rawData.length; i++) {
        if (rawData[i] > 0) active.push(rawData[i]);
    }

    // Scale expected steps based on the proportion of time the sensor was actually connected.
    // E.g., if it was disconnected 50% of the time (zeros), we should only look for 50% of the steps.
    var activeRatio = active.length / rawData.length;
    var sensorExpectedSteps = Math.max(1, Math.round(expectedSteps * activeRatio));

    var zeroCount = rawData.length - active.length;
    if (zeroCount > rawData.length * 0.3) {
        post("NOTE " + name + ": " + zeroCount + "/" + rawData.length +
             " zero readings filtered (sensor intermittent). Expecting ~" + sensorExpectedSteps + " steps.\n");
    }

    // ── Step 2: error checks ─────────────────────────────────────────────────
    if (active.length < sensorExpectedSteps) {
        post("ERROR " + name + ": only " + active.length + " non-zero readings, " +
             "fewer than " + sensorExpectedSteps + " expected steps. " +
             "Check sensor connection. Outputting no-trigger bounds.\n");
        return [1022, 1023];
    }

    // Sort for percentile calculations
    var sortedAll = active.slice().sort(function(a, b) { return a - b; });

    var m      = sortedAll.length;
    var minVal = sortedAll[0];
    var maxVal = sortedAll[m - 1];
    var range  = maxVal - minVal;

    if (range < MIN_RANGE) {
        post("ERROR " + name + ": flat signal after zero removal (range=" +
             Math.round(range) + "). Sensor may be stuck or faulty. " +
             "Outputting no-trigger bounds.\n");
        return [1022, 1023];
    }

    if (range < 60) {
        post("WARNING " + name + ": narrow range (" + Math.round(range) + " ADC units). " +
             "Step detection may be sensitive to noise. Consider repositioning sensor.\n");
    }

    // ── Step 3: upper bound ──────────────────────────────────────────────────
    // 93rd percentile of active data: near the typical peak pressure
    var upper = sortedAll[Math.floor(0.93 * (m - 1))];

    // ── Step 4: dynamic lower bound via chronological simulation ─────────────
    // To accurately detect exactly the expected number of footsteps, we simulate
    // chronological step triggering and scan for the best threshold. This minimizes
    // over/under corrections and eliminates assumptions about sampling rate or stance time.
    var candidateLBs = [];
    var stepSize = Math.max(1, (upper - minVal) / 100);
    for (var v = minVal; v <= upper; v += stepSize) {
        candidateLBs.push(v);
    }
    if (candidateLBs[candidateLBs.length - 1] !== upper) {
        candidateLBs.push(upper);
    }

    var minError = 999999;
    var validLBs = [];

    for (var k = 0; k < candidateLBs.length; k++) {
        var testLB = candidateLBs[k];
        var steps = countSteps(rawData, testLB, minGapSamples);
        var error = Math.abs(steps - sensorExpectedSteps);

        if (error < minError) {
            minError = error;
            validLBs = [testLB];
        } else if (error === minError) {
            validLBs.push(testLB);
        }
    }

    // validLBs contains all thresholds that yielded the minimal error.
    // We pick the threshold based on the sensitivity parameter.
    // sensitivity=0.5 -> middle of the valid range
    // sensitivity=1.0 -> lowest valid threshold (triggers more easily)
    // sensitivity=0.1 -> highest valid threshold (triggers less easily)
    var targetIdx;
    if (name.indexOf("Toe") !== -1) {
        // For Toe (which is Toe + Heel), we want to isolate the peaks as much as possible
        // without double counting. The highest valid lower bound achieves this.
        targetIdx = validLBs.length - 1; 
    } else {
        targetIdx = Math.floor((1.0 - sensitivity) * (validLBs.length - 1));
    }
    targetIdx = Math.max(0, Math.min(validLBs.length - 1, targetIdx));
    var lower = validLBs[targetIdx];

    // ── Step 5: enforce minimum gap ──────────────────────────────────────────
    var minGap = Math.max(15, range * 0.05);
    if (lower >= upper - minGap) {
        if (lower + minGap <= maxVal) {
            upper = lower + minGap;
        } else {
            upper = maxVal;
            lower = upper - minGap;
        }
    }
    
    lower = Math.max(minVal, lower);

    // ── Report ───────────────────────────────────────────────────────────────
    var actualStepsTrig = countSteps(rawData, lower, minGapSamples);
    if (actualStepsTrig !== sensorExpectedSteps) {
        post("WARNING " + name + ": Unable to find threshold for exactly " + sensorExpectedSteps +
             " steps. Optimal yielded " + actualStepsTrig + " steps (error: " + Math.abs(actualStepsTrig - sensorExpectedSteps) + ").\n");
    }

    post(name + ": lower=" + Math.round(lower) + " upper=" + Math.round(upper) +
         " | range=" + Math.round(range) +
         " | active=" + m + "/" + rawData.length + " rows\n");

    return [Math.round(lower), Math.round(upper)];
}

// ─────────────────────────────────────────────────────────────────────────────
// Glitch cleaner
// ─────────────────────────────────────────────────────────────────────────────

// Two ADC readings occasionally concatenate in transmission (e.g. "948950").
// For 6-digit integers, the first 3 digits are the real value.
// Returns -1 for unreadable values (caller discards them).
function cleanValue(val) {
    var str = String(val);

    // 6-digit concatenated glitch: "948950" → 948, "771783" → 771
    if (str.length === 6 && str.indexOf('.') === -1) {
        return Number(str.substring(0, 3));
    }

    var v = Number(val);

    // ADC is 10-bit (0–1023); reject anything outside this range
    if (isNaN(v) || v < 0 || v > 1023) {
        return -1;
    }

    return v;
}