/**
 * Custom Canvas 2D real-time plotter using a ring buffer.
 * Handles 208 Hz data rendered at display refresh rate.
 */
class LiveChart {
  constructor(canvas) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.bufferSize = 2080; // 10 seconds at 208 Hz

    // Ring buffers for each channel
    this.ax = new Float64Array(this.bufferSize);
    this.ay = new Float64Array(this.bufferSize);
    this.az = new Float64Array(this.bufferSize);
    this.gx = new Float64Array(this.bufferSize);
    this.gy = new Float64Array(this.bufferSize);
    this.gz = new Float64Array(this.bufferSize);
    this.phases = new Uint8Array(this.bufferSize);
    this.timestamps = new Float64Array(this.bufferSize);

    this.writePos = 0;
    this.sampleCount = 0;
    this.running = false;
    this.showGyro = false;
    this._rafId = null;

    // Colors
    this.colors = {
      ax: '#EF4444', ay: '#10B981', az: '#3B82F6',
      gx: '#F59E0B', gy: '#8B5CF6', gz: '#EC4899',
    };

    this.phaseColors = {
      0: '#6B7280', 1: '#3B82F6', 2: '#10B981', 3: '#F59E0B',
      4: '#8B5CF6', 5: '#F43F5E', 6: '#06B6D4', 7: '#EC4899',
      8: '#84CC16', 9: '#FFFFFF',
    };

    this._resize();
    this._resizeObserver = new ResizeObserver(() => this._resize());
    this._resizeObserver.observe(canvas.parentElement);
  }

  _resize() {
    const parent = this.canvas.parentElement;
    const dpr = window.devicePixelRatio || 1;
    this.canvas.width = parent.clientWidth * dpr;
    this.canvas.height = parent.clientHeight * dpr;
    this.canvas.style.width = parent.clientWidth + 'px';
    this.canvas.style.height = parent.clientHeight + 'px';
    this.ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    this.w = parent.clientWidth;
    this.h = parent.clientHeight;
  }

  pushBatch(samples) {
    for (const s of samples) {
      const i = this.writePos % this.bufferSize;
      this.ax[i] = s.ax;
      this.ay[i] = s.ay;
      this.az[i] = s.az;
      this.gx[i] = s.gx;
      this.gy[i] = s.gy;
      this.gz[i] = s.gz;
      this.phases[i] = s.phase;
      this.timestamps[i] = s.device_ms;
      this.writePos++;
      this.sampleCount++;
    }
  }

  start() {
    this.running = true;
    this._render();
  }

  stop() {
    this.running = false;
    if (this._rafId) cancelAnimationFrame(this._rafId);
  }

  _render() {
    if (!this.running) return;
    this._draw();
    this._rafId = requestAnimationFrame(() => this._render());
  }

  _draw() {
    const ctx = this.ctx;
    const w = this.w;
    const h = this.h;
    const n = Math.min(this.sampleCount, this.bufferSize);
    if (n < 2) {
      ctx.fillStyle = '#1F2937';
      ctx.fillRect(0, 0, w, h);
      ctx.fillStyle = '#9CA3AF';
      ctx.font = '14px -apple-system, sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText('Waiting for data...', w / 2, h / 2);
      return;
    }

    const margin = { top: 10, right: 10, bottom: 25, left: 50 };
    const plotW = w - margin.left - margin.right;
    const plotH = h - margin.top - margin.bottom;

    // Clear
    ctx.fillStyle = '#1F2937';
    ctx.fillRect(0, 0, w, h);

    // Determine visible range
    const startIdx = this.writePos - n;

    // Auto-range for accel
    let aMin = Infinity, aMax = -Infinity;
    for (let j = 0; j < n; j++) {
      const i = (startIdx + j + this.bufferSize) % this.bufferSize;
      const vals = [this.ax[i], this.ay[i], this.az[i]];
      for (const v of vals) {
        if (v < aMin) aMin = v;
        if (v > aMax) aMax = v;
      }
    }
    const aPad = (aMax - aMin) * 0.1 || 1;
    aMin -= aPad;
    aMax += aPad;

    // Draw phase bands
    let prevPhase = -1;
    let bandStartX = 0;
    for (let j = 0; j < n; j++) {
      const i = (startIdx + j + this.bufferSize) % this.bufferSize;
      const phase = this.phases[i];
      const x = margin.left + (j / (n - 1)) * plotW;

      if (phase !== prevPhase) {
        if (prevPhase >= 0) {
          ctx.fillStyle = this.phaseColors[prevPhase] + '15';
          ctx.fillRect(bandStartX, margin.top, x - bandStartX, plotH);
        }
        bandStartX = x;
        prevPhase = phase;

        // Sync pulse line
        if (phase === 9) {
          ctx.strokeStyle = '#FFFFFF';
          ctx.lineWidth = 2;
          ctx.setLineDash([4, 4]);
          ctx.beginPath();
          ctx.moveTo(x, margin.top);
          ctx.lineTo(x, margin.top + plotH);
          ctx.stroke();
          ctx.setLineDash([]);
        }
      }
    }
    // Final band
    if (prevPhase >= 0) {
      ctx.fillStyle = this.phaseColors[prevPhase] + '15';
      ctx.fillRect(bandStartX, margin.top, margin.left + plotW - bandStartX, plotH);
    }

    // Helper: map value to y
    const yMap = (val) => margin.top + plotH - ((val - aMin) / (aMax - aMin)) * plotH;

    // Draw channels
    const channels = this.showGyro
      ? [['ax', this.ax], ['ay', this.ay], ['az', this.az], ['gx', this.gx], ['gy', this.gy], ['gz', this.gz]]
      : [['ax', this.ax], ['ay', this.ay], ['az', this.az]];

    for (const [name, buf] of channels) {
      ctx.strokeStyle = this.colors[name];
      ctx.lineWidth = 1.2;
      ctx.beginPath();
      for (let j = 0; j < n; j++) {
        const i = (startIdx + j + this.bufferSize) % this.bufferSize;
        const x = margin.left + (j / (n - 1)) * plotW;
        const y = yMap(buf[i]);
        if (j === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
      }
      ctx.stroke();
    }

    // Y-axis labels
    ctx.fillStyle = '#9CA3AF';
    ctx.font = '10px monospace';
    ctx.textAlign = 'right';
    const ySteps = 5;
    for (let s = 0; s <= ySteps; s++) {
      const val = aMin + (aMax - aMin) * (s / ySteps);
      const y = yMap(val);
      ctx.fillText(val.toFixed(1), margin.left - 5, y + 3);
      // Grid line
      ctx.strokeStyle = '#374151';
      ctx.lineWidth = 0.5;
      ctx.beginPath();
      ctx.moveTo(margin.left, y);
      ctx.lineTo(margin.left + plotW, y);
      ctx.stroke();
    }

    // Legend
    ctx.font = '11px -apple-system, sans-serif';
    ctx.textAlign = 'left';
    let lx = margin.left + 10;
    for (const [name] of channels) {
      ctx.fillStyle = this.colors[name];
      ctx.fillRect(lx, margin.top + 5, 14, 3);
      ctx.fillText(name, lx + 18, margin.top + 11);
      lx += 55;
    }
  }

  destroy() {
    this.stop();
    this._resizeObserver.disconnect();
  }
}
