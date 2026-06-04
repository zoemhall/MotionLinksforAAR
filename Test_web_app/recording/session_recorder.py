from __future__ import annotations
import asyncio
from pathlib import Path

from ble.manager import ble_manager
from recording.csv_writer import CSVWriter


class SessionRecorder:
    def __init__(self, csv_path: Path) -> None:
        self._writer = CSVWriter(csv_path)
        self._queue: asyncio.Queue | None = None
        self._task: asyncio.Task | None = None
        self.is_recording = False
        self.is_paused = False

    async def start(self) -> None:
        await self._writer.open()
        self._queue = ble_manager.subscribe()
        self._task = asyncio.create_task(self._consume())
        self.is_recording = True
        self.is_paused = False

    async def _consume(self) -> None:
        while True:
            row = await self._queue.get()
            if not self.is_paused:
                await self._writer.write_row(row)

    def pause(self) -> None:
        self.is_paused = True

    def resume(self) -> None:
        self.is_paused = False

    async def stop(self) -> tuple[int, Path]:
        """Stop recording. Returns (row_count, file_path)."""
        self.is_recording = False
        self.is_paused = False
        if self._task:
            self._task.cancel()
            try:
                await self._task
            except asyncio.CancelledError:
                pass
        if self._queue:
            ble_manager.unsubscribe(self._queue)
        await self._writer.close()
        return self._writer.row_count, self._writer.path

    @property
    def row_count(self) -> int:
        return self._writer.row_count


# Module-level active recorder (only one at a time)
_active_recorder: SessionRecorder | None = None


def get_active_recorder() -> SessionRecorder | None:
    return _active_recorder


def set_active_recorder(recorder: SessionRecorder | None) -> None:
    global _active_recorder
    _active_recorder = recorder
