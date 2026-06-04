// Thin fetch wrapper for the REST API

/**
 * Parse a session_date string stored in the DB.
 * Legacy sessions: SQLite datetime('now') → UTC in "YYYY-MM-DD HH:MM:SS" (space separator).
 * New sessions: Python datetime.now() → local ISO "YYYY-MM-DDTHH:MM:SS" (T separator).
 * Detect by presence of space-separator → treat as UTC; T-separator → treat as local.
 */
function parseDate(d) {
  if (!d) return new Date(NaN);
  if (d.includes(' ') && !d.includes('T')) return new Date(d.replace(' ', 'T') + 'Z');
  return new Date(d);
}

/** Format a session_date string for human display in the user's local timezone. */
function formatDate(d) {
  const dt = parseDate(d);
  if (isNaN(dt)) return '—';
  return dt.toLocaleString();
}

function _extractDetail(detail, fallback) {
  if (!detail) return fallback;
  if (typeof detail === 'string') return detail;
  // FastAPI Pydantic validation errors: array of {loc, msg, type}
  if (Array.isArray(detail)) {
    return detail.map(d => {
      const loc = d.loc ? d.loc.slice(1).join('.') : '';
      return loc ? `${loc}: ${d.msg}` : d.msg;
    }).join('; ');
  }
  return JSON.stringify(detail);
}

const api = {
  async get(url) {
    const resp = await fetch(url);
    if (!resp.ok) {
      const err = await resp.json().catch(() => ({}));
      throw new Error(_extractDetail(err.detail, resp.statusText));
    }
    return resp.json();
  },

  async post(url, body = null) {
    const opts = { method: 'POST', headers: { 'Content-Type': 'application/json' } };
    if (body) opts.body = JSON.stringify(body);
    const resp = await fetch(url, opts);
    if (!resp.ok) {
      const err = await resp.json().catch(() => ({}));
      throw new Error(_extractDetail(err.detail, resp.statusText));
    }
    return resp.json();
  },

  async patch(url, body) {
    const resp = await fetch(url, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    });
    if (!resp.ok) {
      const err = await resp.json().catch(() => ({}));
      throw new Error(_extractDetail(err.detail, resp.statusText));
    }
    return resp.json();
  },

  async put(url, body) {
    const resp = await fetch(url, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    });
    if (!resp.ok) {
      const err = await resp.json().catch(() => ({}));
      throw new Error(_extractDetail(err.detail, resp.statusText));
    }
    return resp.json();
  },

  async uploadFile(url, file) {
    const fd = new FormData();
    fd.append('file', file);
    const resp = await fetch(url, { method: 'POST', body: fd });
    if (!resp.ok) {
      const err = await resp.json().catch(() => ({}));
      throw new Error(_extractDetail(err.detail, resp.statusText));
    }
    return resp.json();
  },
};
