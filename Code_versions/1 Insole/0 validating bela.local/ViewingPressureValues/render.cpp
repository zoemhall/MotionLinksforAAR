#include <Bela.h>
#include <cmath>
#include <string>
#include <vector>

// SETUP: Define which pin you are using
const int kSensorPin = 0; 

// SETUP: How often to print to the console (in number of analog frames)
// Bela default analog sample rate is 22050Hz. 
// 2205 samples = approx 100ms (10 times a second)
int gPrintInterval = 2205; 
int gPrintCounter = 0;

bool setup(BelaContext *context, void *userData)
{
    return true;
}

void render(BelaContext *context, void *userData)
{
    // Loop through the analog frames (usually half the number of audio frames)
    for(unsigned int n = 0; n < context->analogFrames; n++) {
        
        // 1. Read the sensor value (Returns 0.0 to 1.0)
        float sensorValue = analogRead(context, n, kSensorPin);
        
        // 2. Increment counter to handle printing speed
        gPrintCounter++;
        
        // 3. If enough time has passed, print the data
        if(gPrintCounter >= gPrintInterval) {
            
            // Create a simple visual bar for the console
            // We map the 0.0-1.0 value to a scale of 0-20 characters
            int barLength = (int)(sensorValue * 20.0f);
            
            // Print the raw value and the visual bar
            // %.3f prints the float with 3 decimal places
            rt_printf("Val: %.3f | ", sensorValue);
            
            for(int i = 0; i < 20; i++) {
                if(i < barLength) rt_printf("#");
                else rt_printf(".");
            }
            rt_printf("\n");
            
            // Reset the counter
            gPrintCounter = 0;
        }
    }
}

void cleanup(BelaContext *context, void *userData)
{
    // Nothing to clean up
}