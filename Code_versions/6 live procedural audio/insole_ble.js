/**
 * ble_bridge.js — Low-latency BLE UART bridge for Max/MSP
 *
 * Receives 9-byte binary packets from the pressure insole firmware
 * and forwards pressure readings to Max via maxApi.outlet().
 *
 * Packet layout (9 bytes, big-endian):
 *   [0–3]  device_ms   uint32   MCU timestamp in milliseconds
 *   [4–5]  toe         uint16   raw ADC value 0–1023
 *   [6–7]  heel        uint16   raw ADC value 0–1023
 *   [8]    seq         uint8    rolling counter 0–255, wraps around
 *                               — used to detect dropped packets
 *
 * Max outlet format (unchanged from previous version):
 *   outlet(side, "toe heel")
 *   e.g. outlet("left", "646 653")
 *
 * Connection interval:
 *   Requested from BOTH sides for best chance of acceptance.
 *   macOS CoreBluetooth enforces a ~15ms minimum regardless — 7.5ms
 *   is the BLE spec floor but Apple clamps it. 15ms is your real ceiling
 *   on Mac, giving ~67Hz per insole (vs your previous ~4Hz).
 */

"use strict";

const maxApi = require("max-api");
const noble  = require("@abandonware/noble");

// ── BLE UUIDs ─────────────────────────────────────────────────────────────────
const UART_SERVICE_UUID = "6e400001b5a3f393e0a9e50e24dcca9e";
const UART_TX_UUID      = "6e400003b5a3f393e0a9e50e24dcca9e";

// ── Connection interval ───────────────────────────────────────────────────────
// Units are multiples of 1.25ms.
// The firmware also requests this from the peripheral side — both requesting
// gives the best chance macOS will honour it.
const CONN_INTERVAL_MIN   = 6;    // 6  × 1.25ms = 7.5ms (macOS clamps to 15ms)
const CONN_INTERVAL_MAX   = 12;   // 12 × 1.25ms = 15ms
const CONN_LATENCY        = 0;    // deliver every interval — no skipping
const SUPERVISION_TIMEOUT = 200;  // 200 × 10ms = 2s

// ── Binary packet ─────────────────────────────────────────────────────────────
const PACKET_SIZE = 9;  // 4 bytes timestamp + 2 toe + 2 heel + 1 seq

// ── State ─────────────────────────────────────────────────────────────────────
const TARGET_DEVICES = new Set(["Insole_L", "Insole_R"]);
const connectedNames = new Set();
const connectedIds   = new Set();
const deviceBuffers  = {};   // peripheral.id → Buffer  (accumulates partial packets)
const deviceSeq      = {};   // peripheral.id → last seen seq number

// ── BLE scanning ──────────────────────────────────────────────────────────────
noble.on("stateChange", (state) => {
  if (state === "poweredOn") {
    maxApi.post("Bluetooth powered on. Scanning for insoles...");
    noble.startScanning([UART_SERVICE_UUID], true);
  }
});

noble.on("discover", (peripheral) => {
  const name = peripheral.advertisement.localName;

  if (!TARGET_DEVICES.has(name) || connectedIds.has(peripheral.id)) return;

  connectedIds.add(peripheral.id);
  if (connectedIds.size >= TARGET_DEVICES.size) {
    noble.stopScanning();
    maxApi.post("Both insoles found — scanning stopped.");
  }

  maxApi.post(`Found ${name}. Connecting...`);
  deviceBuffers[peripheral.id] = Buffer.alloc(0);
  deviceSeq[peripheral.id]     = -1;  // -1 = not yet seen, skip first drop check

  peripheral.connect((err) => {
    if (err) {
      maxApi.post(`Connection error for ${name}: ${err}`);
      connectedIds.delete(peripheral.id);
      return;
    }

    // ── Request short connection interval from central side ───────────────────
    // The firmware also requests this from the peripheral side in onConnect().
    // Requesting from both sides gives the best chance of acceptance on macOS.
    if (typeof peripheral.updateConnectionParameters === "function") {
      peripheral.updateConnectionParameters(
        CONN_INTERVAL_MIN,
        CONN_INTERVAL_MAX,
        CONN_LATENCY,
        SUPERVISION_TIMEOUT,
        (updateErr) => {
          if (updateErr) {
            maxApi.post(`${name}: interval update failed (${updateErr}) — latency may be higher`);
          } else {
            maxApi.post(`${name}: connection interval set to ${CONN_INTERVAL_MIN * 1.25}–${CONN_INTERVAL_MAX * 1.25}ms`);
          }
        }
      );
    } else {
      maxApi.post(`${name}: updateConnectionParameters unavailable on this platform`);
    }

    peripheral.discoverSomeServicesAndCharacteristics(
      [UART_SERVICE_UUID],
      [UART_TX_UUID],
      (discErr, _services, characteristics) => {
        if (discErr || !characteristics || !characteristics[0]) {
          maxApi.post(`${name}: service discovery failed`);
          return;
        }

        const txChar = characteristics[0];
        const side   = name === "Insole_L" ? "left" : "right";

        // ── Hot path: binary packet handler ──────────────────────────────────
        //
        // Each BLE notification may contain:
        //   a) exactly one 9-byte packet     (ideal case)
        //   b) a partial packet              (BLE fragmentation — rare at 9 bytes)
        //   c) multiple packets back-to-back (macOS batched connection events)
        //
        // The buffer accumulates incoming bytes and emits one reading per
        // complete 9-byte boundary. No string conversion, no delimiter search.
        txChar.on("data", (data) => {
          // Append incoming bytes to any leftover partial packet
          const prev     = deviceBuffers[peripheral.id];
          const combined = prev.length === 0
            ? data
            : Buffer.concat([prev, data], prev.length + data.length);

          let offset = 0;

          while (offset + PACKET_SIZE <= combined.length) {

            // ── Parse packet ────────────────────────────────────────────────
            const ts   = combined.readUInt32BE(offset);      // MCU millis()
            const toe  = combined.readUInt16BE(offset + 4);  // ADC 0–1023
            const heel = combined.readUInt16BE(offset + 6);  // ADC 0–1023
            const seq  = combined[offset + 8];               // 0–255 rolling

            // ── Dropped packet detection ────────────────────────────────────
            const lastSeq = deviceSeq[peripheral.id];
            if (lastSeq !== -1) {
              const gap = (seq - lastSeq) & 0xFF;  // handles wrap-around
              if (gap > 1) {
                maxApi.post(`${name}: warning — ${gap - 1} packet(s) dropped before seq ${seq}`);
              }
            }
            deviceSeq[peripheral.id] = seq;

            // ── Forward to Max ───────────────────────────────────────────────
            // Format unchanged from previous version — Max patch needs no edits.
            // ts is available if your patch ever needs MCU-side timing.
            maxApi.outlet(side, `${toe} ${heel}`);

            offset += PACKET_SIZE;
          }

          // Keep any incomplete trailing bytes for the next notification
          deviceBuffers[peripheral.id] = offset < combined.length
            ? combined.slice(offset)
            : Buffer.alloc(0);
        });

        // ── Subscribe with confirmation ───────────────────────────────────────
        txChar.subscribe((subErr) => {
          if (subErr) {
            maxApi.post(`${name}: subscription failed — ${subErr}`);
            return;
          }
          connectedNames.add(name);
          maxApi.post(`${name} connected and streaming. (${connectedNames.size}/${TARGET_DEVICES.size} insoles active)`);
        });

        // ── Handle disconnection ──────────────────────────────────────────────
        peripheral.once("disconnect", () => {
          maxApi.post(`${name} disconnected. Restarting scan...`);
          connectedIds.delete(peripheral.id);
          connectedNames.delete(name);
          delete deviceBuffers[peripheral.id];
          delete deviceSeq[peripheral.id];
          noble.startScanning([UART_SERVICE_UUID], true);
        });
      }
    );
  });
});