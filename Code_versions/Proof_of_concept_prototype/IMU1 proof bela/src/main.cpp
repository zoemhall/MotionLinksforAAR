// Initial code for a bela mini microprocessor, next stage is to switch to a seeed xiao nrf52840 sense microprocessor. 

#include <Arduino.h>
#include <LSM6DS3.h>
#include <Wire.h>

LSM6DS3 myIMU(I2C_MODE, 0x6A);    
int heartbeat = 0;

void setup() {
    Serial.begin(115200);
    while (!Serial); // Wait for serial to open

    if (myIMU.begin() != 0) {
        Serial.println(">Status:Sensor_Error");
    } else {
        Serial.println(">Status:Sensor_OK");
    }
}

void loop() {
    float z_val = myIMU.readFloatAccelZ();

    // 1. Send the actual sensor data
    Serial.print(">AccelZ:");
    Serial.println(z_val);

    // Heartbeat code to check the signal is working
    // Serial.print(">Heartbeat:");
    // Serial.println(heartbeat);

    // heartbeat++;
    // if(heartbeat > 100) heartbeat = 0; // Reset every 100 steps

    delay(20); 
}