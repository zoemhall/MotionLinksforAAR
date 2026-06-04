#include <Bela.h>
#include <cmath>
#include <algorithm>

// --- SETTINGS ---
const int kSensorPin = 0;
float gThresholdHigh = 0.827; // Pressure must go ABOVE this to trigger
float gThresholdLow = 0.825;  // Pressure must drop BELOW this to reset
float gFrequency = 440.0;   // Pitch of the "ping" (Hz)
float gDecay = 0.9995;      // How fast the sound fades (0.9 to 0.9999)

// --- GLOBAL VARIABLES ---
float gPhase = 0.0;
float gInverseSampleRate;
float gEnvelope = 0.0;      // Current volume of the sound
bool gSensorState = false;  // false = foot up, true = foot down

bool setup(BelaContext *context, void *userData)
{
    gInverseSampleRate = 1.0 / context->audioSampleRate;
    return true;
}

void render(BelaContext *context, void *userData)
{
    // 1. ANALOG LOOP: Read sensors and handle triggering logic
    // We assume analogFrames are half of audioFrames (standard Bela setting)
    for(unsigned int n = 0; n < context->analogFrames; n++) {
        
        float sensorValue = analogRead(context, n, kSensorPin);
        
        // LOGIC: State Machine for Triggering
        if(!gSensorState) {
            // State: Foot is UP. Waiting for step.
            if(sensorValue > gThresholdHigh) {
                // TRIGGER HAPPENS HERE
                gSensorState = true; 
                gEnvelope = 0.6; // Set volume to loud immediately
                rt_printf("Step Detected! Value: %.3f\n", sensorValue);
            }
        } 
        else {
            // State: Foot is DOWN. Waiting for release.
            if(sensorValue < gThresholdLow) {
                gSensorState = false; // Reset state so we can step again
            }
        }
    }

    // 2. AUDIO LOOP: Generate sound
    for(unsigned int n = 0; n < context->audioFrames; n++) {
        
        float out = 0.0;
        
        // Only calculate sine wave if volume is audible (saves CPU)
        if(gEnvelope > 0.001) {
            // Simple Sine Wave Formula
            out = 0.8f * sinf(gPhase) * gEnvelope;
            
            // Advance phase
            gPhase += 2.0f * (float)M_PI * gFrequency * gInverseSampleRate;
            if(gPhase > 2.0f * (float)M_PI) gPhase -= 2.0f * (float)M_PI;
            
            // Apply Decay (make the sound fade out)
            gEnvelope *= gDecay;
        } else {
            gEnvelope = 0.0; // clamp to absolute silence
        }

        // Write to audio outputs (Left and Right)
        for(unsigned int ch = 0; ch < context->audioOutChannels; ch++){
            audioWrite(context, n, ch, out);
        }
    }
}

void cleanup(BelaContext *context, void *userData)
{
}