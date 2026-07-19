(function () {
  'use strict';

  var STORAGE_KEY = 'hg-reading-mode';
  var root = document.documentElement;

  function currentMode() {
    var mode = root.dataset.readingMode || 'comfort';
    return mode === 'wide' ? 'wide' : 'comfort';
  }

  function applyMode(mode) {
    mode = mode === 'wide' ? 'wide' : 'comfort';
    root.dataset.readingMode = mode;
    try { localStorage.setItem(STORAGE_KEY, mode); } catch (e) {}

    var buttons = document.querySelectorAll('.reading-mode-btn');
    for (var i = 0; i < buttons.length; i++) {
      var btn = buttons[i];
      var active = btn.getAttribute('data-reading-mode') === mode;
      btn.classList.toggle('is-active', active);
      btn.setAttribute('aria-pressed', active ? 'true' : 'false');
    }
  }

  document.addEventListener('DOMContentLoaded', function () {
    applyMode(currentMode());
    var toolbar = document.querySelector('.reading-toolbar');
    if (!toolbar) return;
    toolbar.addEventListener('click', function (e) {
      var btn = e.target.closest('.reading-mode-btn');
      if (!btn) return;
      applyMode(btn.getAttribute('data-reading-mode'));
    });
  });
})();
