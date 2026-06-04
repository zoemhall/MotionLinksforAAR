function importData() {
  return {
    scannedFiles: [],
    loadingFiles: false,
    scanError: null,
    testTypes: [],

    // Form
    participantId: '',
    gender: '',
    shoeSize: '',
    insoleSize: null,
    age: null,
    injuries: '',
    testTypeId: null,
    mainFile: '',
    calFile1: '',
    calFile2: '',
    calFile3: '',
    sessionDate: '',
    notesSetup: '',
    notesData: '',
    notes: '',
    autoComplete: true,

    submitting: false,
    submitAttempted: false,
    submitError: null,
    recentImports: [],

    get availableFiles() {
      return this.scannedFiles.filter(f => !f.already_used);
    },

    get selectedTestType() {
      return this.testTypes.find(t => t.test_type_id == this.testTypeId) || null;
    },

    get showCalFiles() {
      const tt = this.selectedTestType;
      if (!tt) return false;
      return !tt.has_condition_1 && !tt.has_condition_2;
    },

    get canImport() {
      return (
        /^\d{2}$/.test(this.participantId) &&
        this.gender.trim().length > 0 &&
        this.testTypeId &&
        this.mainFile &&
        this.sessionDate &&
        !this.submitting
      );
    },

    async init() {
      try {
        this.testTypes = await api.get('/api/test_types');
        if (this.testTypes.length) this.testTypeId = this.testTypes[0].test_type_id;
      } catch (e) {
        console.error('Failed to load test types', e);
      }
      this.$watch('participantId', async (val) => {
        if (/^\d{2}$/.test(val)) {
          try {
            const summary = await api.get(`/api/participants/${val}/summary`);
            const p = summary.participant;
            this.gender     = p.gender      || this.gender;
            this.shoeSize   = p.shoe_size   || this.shoeSize;
            this.insoleSize = p.insole_size || this.insoleSize;
            this.age        = p.age         ?? this.age;
            this.injuries   = p.injuries    || this.injuries;
          } catch {
            // participant doesn't exist yet — leave fields as-is
          }
        }
      });
    },

    async scan() {
      this.loadingFiles = true;
      this.scanError = null;
      try {
        this.scannedFiles = await api.get('/api/import/files');
        if (!this.scannedFiles.length) {
          this.scanError = 'No CSV files found in data/import/. Drop files there and try again.';
        }
      } catch (e) {
        this.scanError = 'Failed to scan import folder.';
      } finally {
        this.loadingFiles = false;
      }
    },

    async importSession() {
      this.submitAttempted = true;
      if (!this.canImport) return;
      this.submitting = true;
      this.submitError = null;
      try {
        const payload = {
          participant_id: this.participantId,
          gender: this.gender,
          shoe_size: this.shoeSize,
          insole_size: this.insoleSize || null,
          age: this.age ? parseInt(this.age) : null,
          injuries: this.injuries,
          test_type_id: parseInt(this.testTypeId),
          main_file: this.mainFile,
          cal_file_1: this.showCalFiles && this.calFile1 ? this.calFile1 : null,
          cal_file_2: this.showCalFiles && this.calFile2 ? this.calFile2 : null,
          cal_file_3: this.showCalFiles && this.calFile3 ? this.calFile3 : null,
          notes_setup: this.notesSetup,
          notes_data: this.notesData,
          notes: this.notes,
          session_date: this.sessionDate || null,
          auto_complete: this.autoComplete,
        };
        const session = await api.post('/api/import/session', payload);
        this.recentImports.unshift(session);
        // Reset per-participant/per-session fields; keep test type and date/time
        this.submitAttempted = false;
        this.participantId = '';
        this.gender = '';
        this.shoeSize = '';
        this.insoleSize = null;
        this.age = null;
        this.injuries = '';
        this.mainFile = '';
        this.calFile1 = '';
        this.calFile2 = '';
        this.calFile3 = '';
        this.notesSetup = '';
        this.notesData = '';
        this.notes = '';
        // testTypeId and sessionDate intentionally preserved
        // Re-scan — moved files will no longer appear
        await this.scan();
      } catch (e) {
        this.submitError = e.message || 'Import failed.';
      } finally {
        this.submitting = false;
      }
    },

    formatDate(dt) {
      if (!dt) return '';
      return new Date(dt).toLocaleString();
    },
  };
}
