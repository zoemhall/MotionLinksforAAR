// Questionnaire Alpine.js component
//
// TWO submissions per session (down from three):
//   1. Consciousness check — ONE submission walking through 4 stages:
//        Stage 1: post-calibration ("did they notice anything?")
//        Stage 2: after first condition (with the condition's actual direction
//                  shown as researcher context); records the participant's guess.
//        Stage 3: after second condition (same shape).
//        Stage 4: post-session debrief — did they describe noticing? + tempo
//                 guess + weight guess.
//   2. Overall ratings — agency, UEQ-S pragmatic, ARI immersion (once).
//
// Session is marked complete only when both rows exist.

function questionnaireData() {
  return {
    submitting: false,
    error: null,
    lastSubmitted: null,
    sessionMeta: null,

    // Submission flags (loaded from server on init)
    consciousnessSubmitted: false,
    editingConsciousness: false,
    ratingsSubmitted: false,

    // Session notes (editable at end of questionnaire)
    notesSetup: '',
    notesUse: '',
    notesData: '',
    notes: '',
    notesSaving: false,
    notesSaved: false,

    // ── Consciousness state (single form) ──────────────────────────────
    consciousnessStage: 0, // 0..3, sequential reveal
    postCalibration: { noticed: null, text: '' },
    cond1: { noticed: null, guess: null, text: '' },
    cond2: { noticed: null, guess: null, text: '' },
    postSession: {
      noticed: null,
      text: '',
      tempoGuess: null,
      weightGuess: null,
    },

    // ── Overall ratings state ──────────────────────────────────────────
    agency: { q1: 5, q2: 5, q3: 5 },
    agencyItems: [
      'The sound responded to my movement.',
      'I felt in control of the audio I heard.',
      'The audio felt like a natural extension of how I was moving.',
    ],
    ueqs: [4, 4, 4, 4],
    ueqsItems: [
      ['obstructive', 'supportive'],
      ['complicated', 'easy'],
      ['inefficient', 'efficient'],
      ['confusing', 'clear'],
    ],
    ari: [3, 3, 3, 3, 3, 3, 3],
    ariItems: [
      'I felt like I was part of the environment',
      'I was fully absorbed in the experience',
      'The experience felt real to me',
      'I lost track of time during the experience',
      'I was unaware of my surroundings',
      'I felt completely immersed',
      'The experience held my attention completely',
    ],

    // Honor session flags: a "done" check can pass for a disabled feature.
    get _consciousnessRequired() {
      return this.sessionMeta ? this.sessionMeta.has_consciousness_check !== 0 : true;
    },
    get _ratingsRequired() {
      return this.sessionMeta ? this.sessionMeta.has_overall_ratings !== 0 : true;
    },
    get allDone() {
      const consciousnessOk = !this._consciousnessRequired || this.consciousnessSubmitted;
      const ratingsOk = !this._ratingsRequired || this.ratingsSubmitted;
      return consciousnessOk && ratingsOk;
    },

    // ── Condition context helpers ──────────────────────────────────────
    // For condition 1 (whichever was first): show the actual direction from
    // tempo_direction or weight_direction, and the option-set for guesses.
    get firstConditionInfo() {
      if (!this.sessionMeta) return null;
      const order = this.sessionMeta.condition_order;
      if (order === 'A-first') {
        return {
          letter: 'A',
          label: 'Tempo',
          direction: (this.sessionMeta.tempo_direction || '').replace('_', ' '),
          guessOptions: [
            { value: 'speeding_up',  label: 'speeding up' },
            { value: 'slowing_down', label: 'slowing down' },
            { value: 'no_change',    label: 'no change' },
          ],
        };
      }
      return {
        letter: 'B',
        label: 'Weight',
        direction: this.sessionMeta.weight_direction,
        guessOptions: [
          { value: 'lighter',   label: 'lighter' },
          { value: 'heavier',   label: 'heavier' },
          { value: 'no_change', label: 'no change' },
        ],
      };
    },
    get secondConditionInfo() {
      if (!this.sessionMeta) return null;
      const order = this.sessionMeta.condition_order;
      if (order === 'A-first') {
        return {
          letter: 'B',
          label: 'Weight',
          direction: this.sessionMeta.weight_direction,
          guessOptions: [
            { value: 'lighter',   label: 'lighter' },
            { value: 'heavier',   label: 'heavier' },
            { value: 'no_change', label: 'no change' },
          ],
        };
      }
      return {
        letter: 'A',
        label: 'Tempo',
        direction: (this.sessionMeta.tempo_direction || '').replace('_', ' '),
        guessOptions: [
          { value: 'speeding_up',  label: 'speeding up' },
          { value: 'slowing_down', label: 'slowing down' },
          { value: 'no_change',    label: 'no change' },
        ],
      };
    },

    // ── Sequential reveal logic ────────────────────────────────────────
    advanceConsciousness() {
      if (this.consciousnessStage < 3) this.consciousnessStage++;
    },
    canAdvanceFrom(stage) {
      if (stage === 0) return this.postCalibration.noticed !== null;
      if (stage === 1) return this.cond1.noticed !== null
        && (this.cond1.noticed === 0 || this.cond1.guess !== null);
      if (stage === 2) return this.cond2.noticed !== null
        && (this.cond2.noticed === 0 || this.cond2.guess !== null);
      return true;
    },

    get canSubmitConsciousness() {
      if (this.consciousnessSubmitted || this.submitting) return false;
      if (this.postCalibration.noticed === null) return false;
      if (this.cond1.noticed === null) return false;
      if (this.cond1.noticed === 1 && !this.cond1.guess) return false;
      if (this.cond2.noticed === null) return false;
      if (this.cond2.noticed === 1 && !this.cond2.guess) return false;
      if (this.postSession.noticed === null) return false;
      // post-session tempo/weight guess are optional (researcher leaves null
      // if participant didn't comment on that aspect).
      return this.consciousnessStage >= 3;
    },

    get canSubmitRatings() {
      return !this.ratingsSubmitted && !this.submitting;
    },

    // ── Init ───────────────────────────────────────────────────────────
    async init() {
      const sessionId = Alpine.store('session').currentSessionId;
      if (!sessionId) return;

      // Always reset local state first (defensive against Alpine retaining
      // state across navigation, e.g. after a delete + recreate cycle).
      this._resetForm();

      this.$watch('postCalibration.noticed', val => {
        if (val !== null && this.consciousnessStage === 0) this.consciousnessStage++;
      });
      this.$watch('cond1', () => {
        if (this.consciousnessStage === 1 && this.canAdvanceFrom(1)) this.consciousnessStage++;
      });
      this.$watch('cond2', () => {
        if (this.consciousnessStage === 2 && this.canAdvanceFrom(2)) this.consciousnessStage++;
      });

      try {
        this.sessionMeta = await api.get(`/api/sessions/${sessionId}`);
        this.notesSetup = this.sessionMeta.notes_setup || '';
        this.notesUse   = this.sessionMeta.notes_use   || '';
        this.notesData  = this.sessionMeta.notes_data  || '';
        this.notes      = this.sessionMeta.notes       || '';
      } catch (e) {
        console.warn('Could not load session meta:', e);
      }

      try {
        const summary = await api.get(`/api/questionnaires/${sessionId}`);
        this.consciousnessSubmitted = !!summary.consciousness;
        this.ratingsSubmitted = !!summary.ratings;
      } catch (e) {
        this.consciousnessSubmitted = false;
        this.ratingsSubmitted = false;
      }

      // If the user clicked "Edit responses" from the detail view, auto-open the edit form.
      if (Alpine.store('nav').pendingConsciousnessEdit) {
        Alpine.store('nav').pendingConsciousnessEdit = false;
        await this.startEditConsciousness();
      }

      // Also watch for the flag being set after init (e.g. user is already on this tab
      // or navigates here while the component stays mounted).
      this.$watch('$store.nav.pendingConsciousnessEdit', async (val) => {
        if (val) {
          Alpine.store('nav').pendingConsciousnessEdit = false;
          await this.startEditConsciousness();
        }
      });
    },

    _resetForm() {
      this.consciousnessStage = 0;
      this.postCalibration = { noticed: null, text: '' };
      this.cond1 = { noticed: null, guess: null, text: '' };
      this.cond2 = { noticed: null, guess: null, text: '' };
      this.postSession = { noticed: null, text: '', tempoGuess: null, weightGuess: null };
      this.agency = { q1: 5, q2: 5, q3: 5 };
      this.ueqs = [4, 4, 4, 4];
      this.ari = [3, 3, 3, 3, 3, 3, 3];
      this.error = null;
      this.lastSubmitted = null;
    },

    // ── Edit existing consciousness response ───────────────────────────
    async startEditConsciousness() {
      // Load existing answers from the server so the form re-opens pre-filled
      try {
        const sessionId = Alpine.store('session').currentSessionId;
        const summary = await api.get(`/api/questionnaires/${sessionId}`);
        const c = summary.consciousness;
        if (c) {
          this.postCalibration = { noticed: c.post_calibration_noticed, text: c.post_calibration_text || '' };
          this.cond1 = { noticed: c.cond1_noticed, guess: c.cond1_guess || null, text: c.cond1_text || '' };
          this.cond2 = { noticed: c.cond2_noticed, guess: c.cond2_guess || null, text: c.cond2_text || '' };
          this.postSession = {
            noticed: c.post_session_noticed,
            text: c.post_session_text || '',
            tempoGuess: c.post_session_tempo_guess || null,
            weightGuess: c.post_session_weight_guess || null,
          };
          this.consciousnessStage = 3; // show all stages
        }
      } catch (e) {
        this.error = `Could not load existing responses: ${e.message}`;
        return;
      }
      this.editingConsciousness = true;
      this.consciousnessSubmitted = false;
      this.error = null;
    },

    // ── Submit consciousness ───────────────────────────────────────────
    async submitConsciousness() {
      const msg = this.editingConsciousness
        ? 'Update consciousness check responses?'
        : 'Submit consciousness check?';
      if (!confirm(msg)) return;
      this.submitting = true;
      this.error = null;
      try {
        const sessionId = Alpine.store('session').currentSessionId;
        await api.post(`/api/questionnaires/${sessionId}/consciousness`, {
          post_calibration_noticed: this.postCalibration.noticed,
          post_calibration_text: this.postCalibration.text,
          cond1_noticed: this.cond1.noticed,
          cond1_guess: this.cond1.guess,
          cond1_text: this.cond1.text,
          cond2_noticed: this.cond2.noticed,
          cond2_guess: this.cond2.guess,
          cond2_text: this.cond2.text,
          post_session_noticed: this.postSession.noticed,
          post_session_text: this.postSession.text,
          post_session_tempo_guess: this.postSession.tempoGuess,
          post_session_weight_guess: this.postSession.weightGuess,
        });
        this.consciousnessSubmitted = true;
        this.editingConsciousness = false;
        this.lastSubmitted = { kind: 'consciousness' };
      } catch (e) {
        this.error = e.message;
      } finally {
        this.submitting = false;
      }
    },

    // ── Submit ratings ─────────────────────────────────────────────────
    async submitRatings() {
      if (!confirm('Submit overall ratings (agency, UEQ-S, ARI)? Responses cannot be edited after submission.')) return;
      this.submitting = true;
      this.error = null;
      try {
        const sessionId = Alpine.store('session').currentSessionId;
        const result = await api.post(`/api/questionnaires/${sessionId}/ratings`, {
          agency_q1: this.agency.q1,
          agency_q2: this.agency.q2,
          agency_q3: this.agency.q3,
          ueqs_items: this.ueqs,
          ari_items: this.ari,
        });
        this.ratingsSubmitted = true;
        this.lastSubmitted = {
          kind: 'ratings',
          agencyAggregate: result.agency_aggregate,
          ueqsPragmatic: result.ueqs_pragmatic,
          ariImmersion: result.ari_immersion,
        };
      } catch (e) {
        this.error = e.message;
      } finally {
        this.submitting = false;
      }
    },

    async saveNotes() {
      const sessionId = Alpine.store('session').currentSessionId;
      if (!sessionId) return;
      this.notesSaving = true;
      this.notesSaved = false;
      try {
        await api.patch(`/api/sessions/${sessionId}/notes`, {
          notes_setup: this.notesSetup,
          notes_use:   this.notesUse,
          notes_data:  this.notesData,
          notes:       this.notes,
        });
        this.notesSaved = true;
        setTimeout(() => { this.notesSaved = false; }, 2500);
      } catch (e) {
        this.error = e.message;
      } finally {
        this.notesSaving = false;
      }
    },
  };
}
