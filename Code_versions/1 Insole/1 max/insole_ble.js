const maxApi = require("max-api");
const noble = require("@abandonware/noble");

const UART_SERVICE_UUID = "6e400001b5a3f393e0a9e50e24dcca9e";
const UART_TX_CHARACTERISTIC_UUID = "6e400003b5a3f393e0a9e50e24dcca9e";

noble.on('stateChange', (state) => {
  if (state === 'poweredOn') noble.startScanning([UART_SERVICE_UUID], false);
});

noble.on('discover', (peripheral) => {
  if (peripheral.advertisement.localName === 'Insole_R') {
    noble.stopScanning();
    peripheral.connect((error) => {
      peripheral.discoverSomeServicesAndCharacteristics([UART_SERVICE_UUID], [UART_TX_CHARACTERISTIC_UUID], (error, services, characteristics) => {
        const txCharacteristic = characteristics[0];
        txCharacteristic.on('data', (data) => {
          // Send the raw string data to Max
          maxApi.outlet(data.toString().trim());
        });
        txCharacteristic.subscribe();
      });
    });
  }
});