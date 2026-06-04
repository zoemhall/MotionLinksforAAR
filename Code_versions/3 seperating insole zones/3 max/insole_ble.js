const maxApi = require("max-api");
const noble = require("@abandonware/noble");

// UART Service and Characteristic UUIDs
const UART_SERVICE_UUID = "6e400001b5a3f393e0a9e50e24dcca9e";
const UART_TX_CHARACTERISTIC_UUID = "6e400003b5a3f393e0a9e50e24dcca9e";

const connectedDevices = new Set();
const deviceBuffers = {};

noble.on('stateChange', (state) => {
  if (state === 'poweredOn') {
    maxApi.post("Bluetooth Powered On. Scanning for Insoles...");
    noble.startScanning([UART_SERVICE_UUID], true); 
  } else {
    noble.stopScanning();
  }
});

noble.on('discover', (peripheral) => {
  const name = peripheral.advertisement.localName;

  // Identify our specific Left and Right insoles
  if ((name === 'Insole_L' || name === 'Insole_R') && !connectedDevices.has(peripheral.id)) {
    
    maxApi.post(`Found device: ${name}. Connecting...`);
    connectedDevices.add(peripheral.id);
    deviceBuffers[peripheral.id] = ""; 

    peripheral.connect((error) => {
      if (error) {
        maxApi.post(`Connection error for ${name}: ${error}`);
        connectedDevices.delete(peripheral.id);
        return;
      }

      peripheral.discoverSomeServicesAndCharacteristics(
        [UART_SERVICE_UUID], 
        [UART_TX_CHARACTERISTIC_UUID], 
        (error, services, characteristics) => {
          if (error || !characteristics[0]) return;
          
          const txCharacteristic = characteristics[0];
          const side = (name === 'Insole_L') ? "left" : "right";

          txCharacteristic.on('data', (data) => {
            // 1. Buffer incoming chunks
            deviceBuffers[peripheral.id] += data.toString();

            // 2. Look for the Newline (\n) sent by Arduino Serial.println
            if (deviceBuffers[peripheral.id].indexOf('\n') !== -1) {
              let lines = deviceBuffers[peripheral.id].split('\n');
              
              // 3. Keep the incomplete fragment in the buffer
              deviceBuffers[peripheral.id] = lines.pop();

              // 4. Process each complete line
              lines.forEach(line => {
                let cleanLine = line.trim();
                if (cleanLine.length > 0) {
                  // Split the string into an array of numbers
                  // This handles spaces, tabs, or multiple whitespaces
                  let numbers = cleanLine.split(/\s+/).map(Number);
                  
                  if (numbers.length >= 2) {
                    // Output to Max as: left 512 480 (a proper list)
                    maxApi.outlet(side, ...numbers); 
                  }
                }
              });
            }
          });

          txCharacteristic.subscribe();
          maxApi.post(`${name} (${side}) is now streaming.`);
        }
      );
    });

    peripheral.on('disconnect', () => {
        maxApi.post(`${name} disconnected.`);
        connectedDevices.delete(peripheral.id);
        delete deviceBuffers[peripheral.id];
    });
  }
});