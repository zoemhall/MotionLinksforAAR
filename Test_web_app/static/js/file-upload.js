// Drag-and-drop file upload handler for pressure CSV.
// Supports two modes:
//   • Single-file mode (most test types) — one combined pressure CSV
//   • Per-stage mode   (Test 5 / full-study) — separate files for
//     calibration / pondering / weight / tempo, then combined server-side.

function fileUploadData() {
  return {
    // ── Single-file mode ────────────────────────────────────────────
    hovering: false,
    file: null,
    uploading: false,
    uploaded: false,
    error: null,

    // ── Per-stage mode ───────────────────────────────────────────────
    // keyed by stage slug: { uploading, done, error, name }
    stageUploads: {},
    combining: false,
    combined: false,

    get stageSlots() {
      return [
        { key: 'calibration', label: 'Calibration' },
        { key: 'pondering',   label: 'Pondering'   },
        { key: 'weight',      label: 'Weight'       },
        { key: 'tempo',       label: 'Tempo'        },
      ];
    },

    // Use per-stage mode when the session has both experimental conditions
    get isStageMode() {
      const s = Alpine.store('session').currentSession;
      return !!(s?.has_condition_1 && s?.has_condition_2);
    },

    get allStagesDone() {
      return this.stageSlots.every(s => this.stageUploads[s.key]?.done);
    },

    // Called once when the component initialises — sync server state for
    // any stage files that were uploaded in a previous visit.
    async init() {
      if (!this.isStageMode) return;
      try {
        const sessionId = Alpine.store('session').currentSessionId;
        const status = await api.get(`/api/pressure/${sessionId}/stage-status`);
        const uploads = {};
        for (const [k, exists] of Object.entries(status)) {
          if (exists) uploads[k] = { uploading: false, done: true, error: null, name: null };
        }
        this.stageUploads = uploads;
        if (this.allStagesDone && Alpine.store('session').currentSession?.pressure_raw_path) {
          this.combined = true;
        }
      } catch (_) { /* non-fatal */ }
    },

    // ── Single-file handlers ─────────────────────────────────────────
    handleDrop(event) {
      this.hovering = false;
      const file = event.dataTransfer.files[0];
      if (file && file.name.endsWith('.csv')) {
        this.processFile(file);
      } else {
        this.error = 'Please drop a .csv file';
      }
    },

    handlePick(event) {
      const file = event.target.files[0];
      if (file) this.processFile(file);
    },

    async processFile(file) {
      this.file = file;
      this.uploading = true;
      this.error = null;
      this.uploaded = false;
      try {
        const sessionId = Alpine.store('session').currentSessionId;
        await api.uploadFile(`/api/pressure/${sessionId}/upload`, file);
        this.uploaded = true;
      } catch (e) {
        this.error = e.message;
      } finally {
        this.uploading = false;
      }
    },

    // ── Per-stage handlers ────────────────────────────────────────────
    async uploadStage(stage, file) {
      if (!file) return;
      this.stageUploads = {
        ...this.stageUploads,
        [stage]: { uploading: true, done: false, error: null, name: file.name },
      };
      try {
        const sessionId = Alpine.store('session').currentSessionId;
        const fd = new FormData();
        fd.append('file', file);
        const resp = await fetch(
          `/api/pressure/${sessionId}/upload-stage?stage=${stage}`,
          { method: 'POST', body: fd },
        );
        if (!resp.ok) {
          const err = await resp.json().catch(() => ({}));
          throw new Error(err.detail || resp.statusText);
        }
        const data = await resp.json();
        // Sync all stage statuses from server response
        const updated = { ...this.stageUploads };
        for (const [k, exists] of Object.entries(data.uploaded_stages)) {
          if (exists) updated[k] = { ...updated[k], uploading: false, done: true, error: null };
        }
        this.stageUploads = updated;
      } catch (e) {
        this.stageUploads = {
          ...this.stageUploads,
          [stage]: { uploading: false, done: false, error: e.message, name: file.name },
        };
      }
    },

    async combineStages() {
      this.combining = true;
      this.error = null;
      try {
        const sessionId = Alpine.store('session').currentSessionId;
        await api.post(`/api/pressure/${sessionId}/combine-stages`, {});
        this.combined = true;
      } catch (e) {
        this.error = `Combine failed: ${e.message}`;
      } finally {
        this.combining = false;
      }
    },
  };
}
