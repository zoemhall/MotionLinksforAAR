// IMU dump panel — reads flash-logged IMU samples from each insole over USB CDC.

function imuDumpData() {
  return {
    ports: [],
    selectedPort: '',
    loadingPorts: false,
    busy: false,           // false | 'L' | 'R' | 'CLEAR' | 'INFO'
    pendingSide: null,     // 'L' | 'R' | null — which insole is currently plugged in
    error: null,
    clearSuccess: false,    // shows confirmation after a successful CLEAR
    clearElapsedSecs: 0,    // elapsed time display during CLEAR (can take ~30s)
    _clearTimer: null,
    results: { L: null, R: null },
    infoLines: [],
    infoAttempted: false,   // true once INFO has been clicked at least once
    dumpElapsedSecs: 0,
    _dumpTimer: null,

    get bothDone() {
      return !!(this.results.L && this.results.R);
    },

    get connectionStatus() {
      if (this.loadingPorts) return 'checking';
      if (this.ports.length === 0) return 'none';
      if (this.selectedPort) return 'connected';
      return 'available';
    },

    async init() {
      await this.loadPorts();
    },

    async loadPorts() {
      this.loadingPorts = true;
      this.error = null;
      try {
        this.ports = await api.get('/api/imu/ports');
        if (!this.selectedPort) {
          const candidate = this.ports.find(p =>
            (p.device || '').toLowerCase().includes('usbmodem') ||
            (p.device || '').toLowerCase().includes('com'));
          if (candidate) this.selectedPort = candidate.device;
        }
      } catch (e) {
        this.error = `Could not list serial ports: ${e.message}`;
      } finally {
        this.loadingPorts = false;
      }
    },

    _startDumpTimer() {
      this.dumpElapsedSecs = 0;
      this._dumpTimer = setInterval(() => { this.dumpElapsedSecs++; }, 1000);
    },
    _stopDumpTimer() {
      clearInterval(this._dumpTimer);
      this._dumpTimer = null;
    },
    _startClearTimer() {
      this.clearElapsedSecs = 0;
      this._clearTimer = setInterval(() => { this.clearElapsedSecs++; }, 1000);
    },
    _stopClearTimer() {
      clearInterval(this._clearTimer);
      this._clearTimer = null;
    },

    async dump(side) {
      if (!this.selectedPort) {
        this.error = 'No port selected — plug in the insole via USB and click Refresh.';
        return;
      }
      const sessionId = Alpine.store('session').currentSessionId;
      if (!sessionId) {
        this.error = 'No active session found. Navigate to the session first.';
        return;
      }
      const label = side === 'L' ? 'Left' : 'Right';
      if (!confirm(`Dump the ${label} insole connected at ${this.selectedPort}?\nThis may take 2–3 minutes for a full session.`)) return;

      this.pendingSide = side;
      this.busy = side;
      this.error = null;
      this._startDumpTimer();
      try {
        const resp = await api.post(
          `/api/imu/sessions/${sessionId}/dump`,
          { port: this.selectedPort, side, baud: 921600 },
        );
        this.results[side] = resp;
        this.pendingSide = null;
        // Keep selectedPort so the second insole can be dumped immediately
        await this.loadPorts();
      } catch (e) {
        this.error = `Dump (${label}) failed: ${e.message}`;
      } finally {
        this._stopDumpTimer();
        this.busy = false;
      }
    },

    async dumpPending() {
      await this.dump(this.pendingSide);
    },

    async info() {
      if (!this.selectedPort) return;
      this.busy = 'INFO';
      this.error = null;
      try {
        const resp = await api.post('/api/imu/info', { port: this.selectedPort });
        this.infoLines = resp.lines || [];
      } catch (e) {
        this.error = `INFO failed: ${e.message}`;
      } finally {
        this.busy = false;
        this.infoAttempted = true;
      }
    },

    resetResults() {
      this.results = { L: null, R: null };
      this.error = null;
    },

    async clearLog() {
      if (!this.selectedPort) return;
      if (!confirm(`Wipe the flash log on the insole at ${this.selectedPort}?\n\nOnly do this BEFORE starting a new session. Make sure you have already dumped any data you wanted to keep.`)) return;
      this.busy = 'CLEAR';
      this.error = null;
      this.clearSuccess = false;
      this._startClearTimer();
      try {
        await api.post('/api/imu/clear', { port: this.selectedPort, baud: 921600 });
        this.clearSuccess = true;
        setTimeout(() => { this.clearSuccess = false; }, 8000);
      } catch (e) {
        this.error = `CLEAR failed: ${e.message}`;
      } finally {
        this._stopClearTimer();
        this.busy = false;
      }
    },
  };
}
