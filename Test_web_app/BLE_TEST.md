# BLE Dual-Connection Test Guide

Your study setup requires both Max/MSP and this Python application to communicate
with the XIAO nRF52840 Sense over BLE. Most BLE peripherals only accept **one**
central connection at a time. Use this guide to determine whether dual connections
work on your hardware.

## Quick Test

1. **Start Max/MSP** and connect to the XIAO as you normally do.

2. **Open a terminal** and activate the project venv:
   ```
   cd /path/to/masteringmaster
   source .venv/bin/activate
   ```

3. **Run the scan test**:
   ```python
   python -c "
   import asyncio
   from bleak import BleakScanner

   async def scan():
       print('Scanning for Insole_R...')
       device = await BleakScanner.find_device_by_name('Insole_R', timeout=10)
       if device:
           print(f'Found: {device.name} ({device.address})')
       else:
           print('NOT FOUND - device may already be exclusively connected to Max')

   asyncio.run(scan())
   "
   ```

4. **If found**, try connecting:
   ```python
   python -c "
   import asyncio
   from bleak import BleakClient, BleakScanner

   UART_TX = '6E400003-B5A3-F393-E0A9-E50E24DCCA9E'

   async def test():
       device = await BleakScanner.find_device_by_name('Insole_R', timeout=10)
       if not device:
           print('Device not found')
           return

       async with BleakClient(device) as client:
           print(f'Connected: {client.is_connected}')

           def on_data(char, data):
               print(f'Received: {data.decode(\"ascii\", errors=\"replace\").strip()}')

           await client.start_notify(UART_TX, on_data)
           await asyncio.sleep(3)  # Listen for 3 seconds
           await client.stop_notify(UART_TX)
           print('Test complete - dual connection works!')

   asyncio.run(test())
   "
   ```

## Interpreting Results

| Scan result | Connect result | Meaning |
|---|---|---|
| Found | Connected + data received | Dual connection works. No changes needed. |
| Found | Connection refused / timeout | XIAO allows discovery but not two connections. |
| Not found | — | Max holds an exclusive connection. XIAO not visible. |

## If Dual Connection Fails

You have three options:

### Option A: Python as sole BLE receiver (Recommended)
- Disconnect Max from BLE
- Let this app handle all BLE communication
- Max continues to do audio processing but gets pressure data from its own sensors
- Pressure CSVs are still imported into this app after the session

### Option B: Two BLE adapters
- Use a USB BLE dongle for the Python app
- Your laptop's built-in BLE stays with Max
- Requires configuring bleak to use a specific adapter

### Option C: Modify firmware
- Change the XIAO firmware to **broadcast** data via BLE advertising packets
  instead of using a connected GATT service
- Both Max and Python can passively scan for advertising data
- Requires firmware changes and has a lower data throughput limit

## macOS Bluetooth Permission

On first run, macOS will ask for Bluetooth permission for your terminal app
(Terminal.app or iTerm2). Grant it in:

**System Settings > Privacy & Security > Bluetooth**

If you deny it accidentally, the app will fail to scan. Fix by toggling the
permission in System Settings.
