const maxApi = require("max-api");
const noble = require("@abandonware/noble");

const UART_SERVICE_UUID = "6e400001b5a3f393e0a9e50e24dcca9e";
const UART_TX_CHARACTERISTIC_UUID = "6e400003b5a3f393e0a9e50e24dcca9e";

// Keep track of connected devices to avoid double-connecting
const connectedDevices = new Set();

noble.on('stateChange', (state) => {
  if (state === 'poweredOn') {
    maxApi.post("Bluetooth Powered On. Scanning for Insoles...");
    // We keep scanning so we can find the second device after the first
    noble.startScanning([UART_SERVICE_UUID], true); 
  }
});

noble.on('discover', (peripheral) => {
  const name = peripheral.advertisement.localName;

  // Check if the device is one of our two insoles and not already connected
  if ((name === 'Insole_L' || name === 'Insole_R') && !connectedDevices.has(peripheral.id)) {
    
    maxApi.post(`Found device: ${name}. Connecting...`);
    connectedDevices.add(peripheral.id);

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
          const txCharacteristic = characteristics[0];

          txCharacteristic.on('data', (data) => {
            const val = data.toString().trim();
            
            // Map the name to a label for Max
            const side = (name === 'Insole_L') ? "left" : "right";
            
            // Output as "left [value]" or "right [value]"
            maxApi.outlet(side, val); 
          });

          txCharacteristic.subscribe();
          maxApi.post(`${name} is now connected and streaming.`);
        }
      );
    });

    // We do NOT call noble.stopScanning() here so we can find the other foot!
  }
});