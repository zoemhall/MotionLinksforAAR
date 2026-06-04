// Tag panel Alpine.js component — used in live view (active session) and detail view.
// Captures stage and latest device_ms automatically when called from the live view.
//
// Usage:
//   <div x-data="tagPanelData(getStageFn)"></div>
//
// `getStageFn` is an optional callback returning the current stage id string;
// pass null in the detail view (after-the-fact tagging).

function tagPanelData(getStageFn) {
  return {
    sessionTags: [],       // tags already on this session
    frequentTags: [],      // [{tag, count}, ...]
    newTagText: '',
    busy: false,
    error: null,

    async init() {
      await this.refresh();
    },

    async refresh() {
      try {
        const sessionId = Alpine.store('session').currentSessionId;
        if (!sessionId) return;
        const [tags, freq] = await Promise.all([
          api.get(`/api/sessions/${sessionId}/tags`),
          api.get('/api/tags/frequent?limit=8'),
        ]);
        this.sessionTags = tags;
        this.frequentTags = freq;
      } catch (e) {
        console.error('Failed to load tags:', e);
      }
    },

    async addTag(tagText, note = '') {
      const tag = (tagText || '').trim();
      if (!tag) return;
      this.busy = true;
      this.error = null;
      try {
        const sessionId = Alpine.store('session').currentSessionId;
        const stage = (typeof getStageFn === 'function') ? getStageFn() : null;
        const deviceMs = Alpine.store('session').lastDeviceMs;
        await api.post(`/api/sessions/${sessionId}/tags`, {
          tag,
          stage,
          note,
          device_ms: deviceMs,
        });
        this.newTagText = '';
        await this.refresh();
      } catch (e) {
        this.error = e.message;
      } finally {
        this.busy = false;
      }
    },

    async addCustomTag() {
      await this.addTag(this.newTagText);
    },

    async deleteTag(tagId) {
      if (!confirm('Remove this tag?')) return;
      try {
        const sessionId = Alpine.store('session').currentSessionId;
        await fetch(`/api/sessions/${sessionId}/tags/${tagId}`, { method: 'DELETE' });
        await this.refresh();
      } catch (e) {
        alert('Delete failed: ' + e.message);
      }
    },

    formatDeviceMs(ms) {
      if (ms == null) return '-';
      const secs = Math.floor(ms / 1000);
      const m = String(Math.floor(secs / 60)).padStart(2, '0');
      const s = String(secs % 60).padStart(2, '0');
      return `${m}:${s}`;
    },
  };
}
