// Required installing Seeed Arduino LSM6DS3@2.0.5
#include "LSM6DS3.h"
#include "Wire.h"

// Create the sensor object (I2C address is 0x6A)
LSM6DS3 myIMU(I2C_MODE, 0x6A);

void setup() {
    Serial.begin(115200);
    while (!Serial); // Wait for USB connection

    if (myIMU.begin() != 0) {
        Serial.println("Device error");
    } else {
        Serial.println("Device OK!");
    }
}

void loop() {
    // Read the Accelerometer (Motion)
    // We only print one axis (X) to make the graph easy to see
    Serial.print("Tilt_X:");
    Serial.println(myIMU.readFloatAccelX());
    
    // Fast loop to test speed
    delay(10); 
}