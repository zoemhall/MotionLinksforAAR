// Adding in an input pressure line at input 1, previously just at input 0
// just using microcontroller L, keeping that name to help later on!

#include <Arduino.h>
#include <bluefruit.h>

// BLE Service
BLEUart bleuart;

// Pin Definitions
const int TOE_PIN = A0;   // Original sensor
const int HEEL_PIN = A1;  // New sensor line

unsigned long lastSendTime = 0;
const int sendInterval = 20; // 50Hz sampling rate

void startAdvertising(void) {
  Bluefruit.Advertising.addFlags(BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE);
  Bluefruit.Advertising.addTxPower();
  Bluefruit.Advertising.addService(bleuart);
  Bluefruit.ScanResponse.addName();
  
  Bluefruit.Advertising.restartOnDisconnect(true);
  Bluefruit.Advertising.setInterval(32, 244);
  Bluefruit.Advertising.start(0);
}

void setup() {
  Serial.begin(115200);

  Bluefruit.begin();
  Bluefruit.setTxPower(4); 
  Bluefruit.setName("Insole_R");

  bleuart.begin();
  startAdvertising();

  Serial.println("BLE UART Dual-Zone Insole is advertising...");
}

void loop() {
  if (millis() - lastSendTime >= sendInterval) {
    
    // 1. Read both analog values
    int toeValue = analogRead(TOE_PIN);
    int heelValue = analogRead(HEEL_PIN);

    // 2. Only send if connected
    if (Bluefruit.connected()) {
      // 3. Construct a string: "ToeValue HeelValue"
      // Using .print for the first value and space, .println for the last
      bleuart.print(toeValue);
      bleuart.print(" ");      // Space separator
      bleuart.println(heelValue); // Newline ends the packet
    }

    lastSendTime = millis();
  }
}