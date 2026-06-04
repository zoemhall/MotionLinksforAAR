// App shell: Alpine stores, hash router, and global state

document.addEventListener('alpine:init', () => {

  // --- Navigation store ---
  Alpine.store('nav', {
    view: 'dashboard',
    pendingConsciousnessEdit: false,
    navigate(view) {
      this.view = view;
      window.location.hash = '#/' + view;
    },
  });

  // --- Session store ---
  Alpine.store('session', {
    currentSessionId: null,
    currentSession: null,
    sessions: [],
    bleStatus: 'disconnected',
    droppedPackets: 0,
    latency: null,
    currentPhase: 0,
    phaseStart: null,
    isRecording: false,
    lastDeviceMs: null,    // updated by WebSocket as packets arrive

    async loadSessions() {
      try {
        this.sessions = await api.get('/api/sessions');
      } catch (e) {
        console.error('Failed to load sessions:', e);
      }
    },

    async loadSession(id) {
      this.currentSessionId = id;  // set synchronously so detail view reads the correct ID immediately
      try {
        this.currentSession = await api.get(`/api/sessions/${id}`);
      } catch (e) {
        console.error('Failed to load session:', e);
      }
    },

    setPhase(phase) {
      this.currentPhase = phase;
      this.phaseStart = Date.now();
    },
  });

  // --- Phase labels ---
  Alpine.store('phases', {
    labels: {
      0: 'Idle', 1: 'Calibration', 2: 'A-Pre', 3: 'A-Drift',
      4: 'B-Light', 5: 'B-Heavy', 6: 'Phase 6', 7: 'Phase 7',
      8: 'Phase 8', 9: 'Sync Pulse',
    },
    colors: {
      0: '#6B7280', 1: '#3B82F6', 2: '#10B981', 3: '#F59E0B',
      4: '#8B5CF6', 5: '#F43F5E', 6: '#06B6D4', 7: '#EC4899',
      8: '#84CC16', 9: '#FFFFFF',
    },
  });
});

// --- Hash router ---
function initRouter() {
  function route() {
    const hash = window.location.hash || '#/dashboard';
    const path = hash.replace('#/', '');
    const parts = path.split('/');

    // Guard: if a recording is active and the researcher is navigating away from
    // the live view via the hash router, warn before proceeding.
    // (window.onbeforeunload only fires on tab close, not on in-app navigation.)
    try {
      const isRecording = Alpine.store('session')?.isRecording;
      const currentView = Alpine.store('nav')?.view;
      if (isRecording && currentView === 'live') {
        const targetView = parts[0] || 'dashboard';
        // Allow navigation within the same live session
        const stayingOnLive = targetView === 'session' &&
          parseInt(parts[1]) === Alpine.store('session').currentSessionId &&
          parts[2] === 'live';
        if (!stayingOnLive) {
          const ok = confirm(
            '⚠ Recording is active!\n\n' +
            'Leaving the live view will stop stage-event logging (the insole keeps recording to flash).\n\n' +
            'Are you sure you want to navigate away?'
          );
          if (!ok) {
            // Restore the URL without re-triggering a hashchange
            const sid = Alpine.store('session').currentSessionId;
            window.history.pushState(null, '', `#/session/${sid}/live`);
            return;
          }
        }
      }
    } catch (_) { /* Alpine not ready yet — allow navigation */ }

    if (parts[0] === 'session' && parts.length >= 3) {
      // #/session/123/live, #/session/123/post, etc.
      const id = parseInt(parts[1]);
      const view = parts[2];
      Alpine.store('session').loadSession(id);
      Alpine.store('nav').view = view;
    } else {
      Alpine.store('nav').view = parts[0] || 'dashboard';
    }
  }

  window.addEventListener('hashchange', route);
  route(); // Initial route
}

// Initialize on DOM ready
document.addEventListener('DOMContentLoaded', () => {
  initRouter();
});
