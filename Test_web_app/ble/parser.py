from __future__ import annotations


def parse_packet(data: bytearray) -> dict | None:
    """Parse a 9-byte binary BLE packet from the XIAO firmware.

    Layout (big-endian):
      [0–3]  device_ms  uint32
      [4–5]  toe        uint16
      [6–7]  heel       uint16
      [8]    seq        uint8  (rolling 0–255)

    Returns dict or None if the packet is too short or malformed.
    """
    if len(data) < 9:
        return None
    try:
        device_ms = (data[0] << 24) | (data[1] << 16) | (data[2] << 8) | data[3]
        toe  = (data[4] << 8) | data[5]
        heel = (data[6] << 8) | data[7]
        seq  = data[8]
        return {"device_ms": device_ms, "toe": toe, "heel": heel, "seq": seq}
    except Exception:
        return None
