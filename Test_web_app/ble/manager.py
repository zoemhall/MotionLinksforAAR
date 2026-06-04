from __future__ import annotations
import asyncio
import logging
import time

from bleak import BleakClient, BleakScanner
from bleak.backends.characteristic import BleakGATTCharacteristic

from config import (
    UART_RX_CHAR_UUID,
    UART_TX_CHAR_UUID,
    BLE_DEVICE_NAME,
    BLE_CONNECT_TIMEOUT,
    PACKET_GAP_THRESHOLD_MS,
)
from ble.parser import parse_packet

logger = logging.getLogger(__name__)


class BLEManager:
    def __init__(self) -> None:
        self._client: BleakClient | None = None
        self._subscribers: list[asyncio.Queue] = []
        self.status: str = "disconnected"
        self.dropped_packets: int = 0
        self._last_device_ms: int | None = None
        self._t0_host: float | None = None
        self._t0_device: int | None = None
        self._latency_window: list[float] = []
        self.latency_stats: dict = {}

    async def connect(self) -> None:
        self.status = "scanning"
        self.dropped_packets = 0
        self._last_device_ms = None
        self._t0_host = None
        self._t0_device = None
        self._latency_window = []
        self.latency_stats = {}

        device = await BleakScanner.find_device_by_name(
            BLE_DEVICE_NAME, timeout=BLE_CONNECT_TIMEOUT
        )
        if device is None:
            self.status = "error"
            raise ConnectionError(
                f"Device '{BLE_DEVICE_NAME}' not found within {BLE_CONNECT_TIMEOUT}s"
            )

        self._client = BleakClient(device, disconnected_callback=self._on_disconnect)
        await self._client.connect()
        await self._client.start_notify(UART_TX_CHAR_UUID, self._on_data)
        self.status = "connected"
        logger.info("BLE connected to %s", device.name)

    def _on_disconnect(self, client: BleakClient) -> None:
        self.status = "disconnected"
        self._client = None
        logger.warning("BLE device disconnected")

    def _on_data(
        self, characteristic: BleakGATTCharacteristic, data: bytearray
    ) -> None:
        row = parse_packet(data)
        if row is None:
            return

        # Dropped packet detection
        if self._last_device_ms is not None:
            gap = row["device_ms"] - self._last_device_ms
            if gap > PACKET_GAP_THRESHOLD_MS:
                self.dropped_packets += 1
        self._last_device_ms = row["device_ms"]

        # Latency tracking
        host_ms = time.monotonic() * 1000
        if self._t0_host is None:
            self._t0_host = host_ms
            self._t0_device = row["device_ms"]
        else:
            lag = (host_ms - self._t0_host) - (row["device_ms"] - self._t0_device)
            self._latency_window.append(lag)
            if len(self._latency_window) > 200:
                self._latency_window.pop(0)
            w = self._latency_window
            self.latency_stats = {
                "current_ms": round(lag, 1),
                "avg_ms":     round(sum(w) / len(w), 1),
                "min_ms":     round(min(w), 1),
                "max_ms":     round(max(w), 1),
            }

        # Fan-out to all subscribers
        for q in self._subscribers:
            try:
                q.put_nowait(row)
            except asyncio.QueueFull:
                pass  # subscriber is slow; drop for that subscriber

    async def send_phase(self, phase: int) -> None:
        if self._client is None or not self._client.is_connected:
            raise ConnectionError("Not connected to BLE device")
        await self._client.write_gatt_char(
            UART_RX_CHAR_UUID, str(phase).encode("ascii"), response=False
        )
        logger.info("Sent phase command: %d", phase)

    def subscribe(self) -> asyncio.Queue:
        q: asyncio.Queue = asyncio.Queue(maxsize=4096)
        self._subscribers.append(q)
        return q

    def unsubscribe(self, q: asyncio.Queue) -> None:
        if q in self._subscribers:
            self._subscribers.remove(q)

    async def disconnect(self) -> None:
        if self._client and self._client.is_connected:
            try:
                await self._client.stop_notify(UART_TX_CHAR_UUID)
            except Exception:
                pass
            await self._client.disconnect()
        self._client = None
        self.status = "disconnected"

    @property
    def is_connected(self) -> bool:
        return self._client is not None and self._client.is_connected


# Module-level singleton
ble_manager = BLEManager()
