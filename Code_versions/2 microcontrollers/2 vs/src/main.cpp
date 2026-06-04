// After initial proof of concept with bela, switching to seeed xiao 
// Note this version is still with one insole only, not looking at two yet. 

// Works with max file: 1 insole seed
#include <Arduino.h>
#include <bluefruit.h>

// BLE Service
BLEUart bleuart;

// Everything under here can change, but above must stay
// Process summary: read analog from sensor, stream via BLE UART (if connected) to Max MSP


const int SENSOR_PIN = A0; 
unsigned long lastSendTime = 0;
const int sendInterval = 20; // 20ms = 50Hz sampling rate :)

void startAdvertising(void) {
  // Advertising packet setup
  Bluefruit.Advertising.addFlags(BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE);
  Bluefruit.Advertising.addTxPower();

  // MUST include the UART service UUID so Max can find it
  Bluefruit.Advertising.addService(bleuart);

  // Add name to scan response so it shows up in the BLE list
  Bluefruit.ScanResponse.addName();
  
  Bluefruit.Advertising.restartOnDisconnect(true);
  Bluefruit.Advertising.setInterval(32, 244); // Fast advertising
  Bluefruit.Advertising.start(0);             // 0 = continuous advertising
}

void setup() {
  Serial.begin(115200);

  // Initialize Bluefruit with max connections (1 for this project)
  Bluefruit.begin();
  Bluefruit.setTxPower(4); 
  // Change depending R or L: Insole_R or Insole_L
  Bluefruit.setName("Insole_L");

  // Start the UART service
  bleuart.begin();

  // Start broadcasting
  startAdvertising();

  Serial.println("BLE UART Insole is advertising...");
}

void loop() {
  // Use a non-blocking timer for consistent data flow
  if (millis() - lastSendTime >= sendInterval) {
    
    // 1. Read the analog value (0 - 1023)
    int sensorValue = analogRead(SENSOR_PIN);

    // 2. Only send if Max MSP (the Central) is connected
    if (Bluefruit.connected()) {
      // 3. Send the value as a string + newline character
      // Max will receive this as ASCII characters
      bleuart.println(sensorValue); 
    }

    lastSendTime = millis();
  }
}