const maxApi = require("max-api");
const noble = require("@abandonware/noble");

const UART_SERVICE_UUID = "6e400001b5a3f393e0a9e50e24dcca9e";
const UART_TX_CHARACTERISTIC_UUID = "6e400003b5a3f393e0a9e50e24dcca9e";

const connectedDevices = new Set();
// We need a separate buffer for each device to avoid mixing L and R data
const deviceBuffers = {};

noble.on('stateChange', (state) => {
  if (state === 'poweredOn') {
    maxApi.post("Bluetooth Powered On. Scanning for Insoles...");
    noble.startScanning([UART_SERVICE_UUID], true); 
  }
});

noble.on('discover', (peripheral) => {
  const name = peripheral.advertisement.localName;

  if ((name === 'Insole_L' || name === 'Insole_R') && !connectedDevices.has(peripheral.id)) {
    
    maxApi.post(`Found device: ${name}. Connecting...`);
    connectedDevices.add(peripheral.id);
    deviceBuffers[peripheral.id] = ""; // Initialize empty buffer for this specific device

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
            // 1. Add incoming chunk to the buffer for this device
            deviceBuffers[peripheral.id] += data.toString();

            // 2. Check if the buffer contains a newline character (\n)
            if (deviceBuffers[peripheral.id].indexOf('\n') !== -1) {
              // 3. Split the buffer into lines
              let lines = deviceBuffers[peripheral.id].split('\n');
              
              // 4. The last element in 'lines' might be an incomplete fragment, 
              // so we put it back in the buffer for next time.
              deviceBuffers[peripheral.id] = lines.pop();

              // 5. Send each complete line out to Max
              lines.forEach(line => {
                let cleanLine = line.trim();
                if (cleanLine.length > 0) {
                  // This now outputs "left 512 480" as one single message
                  maxApi.outlet(side, cleanLine); 
                }
              });
            }
          });

          txCharacteristic.subscribe();
          maxApi.post(`${name} is now connected and streaming.`);
        }
      );
    });
  }
});