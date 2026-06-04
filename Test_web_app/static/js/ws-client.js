class SessionWebSocket {
  constructor(handlers) {
    this.handlers = handlers; // { onBatch, onBleStatus }
    this.ws = null;
    this._reconnectAttempts = 0;
    this._maxReconnects = 5;
    this._closed = false;
  }

  connect() {
    this._closed = false;
    const protocol = location.protocol === 'https:' ? 'wss:' : 'ws:';
    const url = `${protocol}//${location.host}/ws/imu`;
    this.ws = new WebSocket(url);

    this.ws.onopen = () => {
      this._reconnectAttempts = 0;
    };

    this.ws.onmessage = (event) => {
      try {
        const msg = JSON.parse(event.data);
        if (msg.type === 'imu_batch' && this.handlers.onBatch) {
          this.handlers.onBatch(msg.samples);
        }
        if (msg.ble_status && this.handlers.onBleStatus) {
          this.handlers.onBleStatus(msg.ble_status, msg.dropped_packets, msg.latency);
        }
      } catch (e) {
        console.error('WS parse error:', e);
      }
    };

    this.ws.onclose = () => {
      if (this._closed) return;
      if (this._reconnectAttempts < this._maxReconnects) {
        const delay = 1000 * Math.pow(2, this._reconnectAttempts);
        this._reconnectAttempts++;
        setTimeout(() => this.connect(), delay);
      }
    };

    this.ws.onerror = (e) => {
      console.error('WS error:', e);
    };
  }

  close() {
    this._closed = true;
    if (this.ws) {
      this.ws.close();
      this.ws = null;
    }
  }
}
