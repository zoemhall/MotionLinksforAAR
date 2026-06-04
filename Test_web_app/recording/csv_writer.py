from __future__ import annotations
import aiofiles
from pathlib import Path
from config import CSV_FLUSH_EVERY

CSV_HEADER = "device_ms,toe,heel\n"
CSV_FIELDS = ("device_ms", "toe", "heel")


class CSVWriter:
    def __init__(self, path: Path) -> None:
        self.path = path
        self._file = None
        self._rows_since_flush = 0
        self.row_count = 0

    async def open(self) -> None:
        self._file = await aiofiles.open(self.path, mode="w", newline="")
        await self._file.write(CSV_HEADER)
        await self._file.flush()

    async def write_row(self, row: dict) -> None:
        line = ",".join(str(row[k]) for k in CSV_FIELDS)
        await self._file.write(line + "\n")
        self.row_count += 1
        self._rows_since_flush += 1
        if self._rows_since_flush >= CSV_FLUSH_EVERY:
            await self._file.flush()
            self._rows_since_flush = 0

    async def close(self) -> None:
        if self._file:
            await self._file.flush()
            await self._file.close()
            self._file = None
