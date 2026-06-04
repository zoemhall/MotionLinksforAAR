// Keyboard shortcut system for the live session view
function initKeyboardShortcuts(sendPhaseFn) {
  const SHORTCUTS = {
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
    '0': 0,
    's': 9,
    'S': 9,
  };

  document.addEventListener('keydown', (e) => {
    // Ignore when typing in form fields
    const tag = e.target.tagName;
    if (tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT') return;

    // Only active during live view
    const liveView = document.getElementById('view-live');
    if (!liveView || liveView.style.display === 'none') return;
    // Check Alpine store
    if (window.Alpine && Alpine.store('nav').view !== 'live') return;

    const phase = SHORTCUTS[e.key];
    if (phase !== undefined) {
      e.preventDefault();
      sendPhaseFn(phase);

      // Visual flash on corresponding button
      const btn = document.querySelector(`[data-phase="${phase}"]`);
      if (btn) {
        btn.classList.add('flash');
        setTimeout(() => btn.classList.remove('flash'), 200);
      }
    }
  });
}
