/* ============================================================
   Gojjam International Bank – Main JavaScript
   ============================================================ */

'use strict';

// ── Password Strength Meter ──────────────────────────────────────────────────
(function () {
  const input  = document.getElementById('password');
  const fill   = document.getElementById('strengthFill');
  const label  = document.getElementById('strengthLabel');
  const tip    = document.getElementById('strengthTip');
  if (!input) return;

  input.addEventListener('input', function () {
    const val   = this.value;
    const score = computeStrength(val);

    // remove all classes
    fill.className = 'strength-fill';
    fill.classList.add('strength-' + score);

    const labels = ['Very Weak', 'Weak', 'Fair', 'Strong', 'Very Strong'];
    const colors = ['#dc3545', '#dc3545', '#ffc107', '#17a2b8', '#28a745'];
    label.textContent  = val ? labels[score] : '';
    label.style.color  = colors[score];

    if (tip) {
      const tips = [];
      if (val.length < 8)           tips.push('At least 8 characters');
      if (!/[A-Z]/.test(val))       tips.push('One uppercase letter');
      if (!/[a-z]/.test(val))       tips.push('One lowercase letter');
      if (!/[0-9]/.test(val))       tips.push('One number');
      if (!/[!@#$%^&*()_+\-=\[\]{};':\"\\|,.<>\/?]/.test(val))
                                    tips.push('One special character (!@#$...)');
      tip.textContent = tips.length ? 'Missing: ' + tips.join(', ') : '✔ Password meets requirements';
      tip.style.color = tips.length ? '#856404' : '#155724';
    }
  });

  function computeStrength(pwd) {
    if (!pwd) return 0;
    let score = 0;
    if (pwd.length >= 8)  score++;
    if (/[A-Z]/.test(pwd)) score++;
    if (/[0-9]/.test(pwd)) score++;
    if (/[!@#$%^&*()_+\-=\[\]{};':\"\\|,.<>\/?]/.test(pwd)) score++;
    return score;
  }
})();

// ── Balance Toggle ──────────────────────────────────────────────────────────
(function () {
  const toggle    = document.getElementById('balanceToggle');
  const display   = document.getElementById('balanceDisplay');
  const icon      = document.getElementById('toggleIcon');
  if (!toggle || !display) return;

  const masked = '••••••';
  const real   = display.getAttribute('data-balance');
  let   shown  = false;

  toggle.addEventListener('click', function () {
    shown = !shown;
    display.textContent = shown ? 'ETB ' + formatNumber(real) : masked;
    icon.className = shown ? 'bi bi-eye-slash' : 'bi bi-eye';
    toggle.title   = shown ? 'Hide balance' : 'Show balance';
  });

  function formatNumber(n) {
    return parseFloat(n).toLocaleString('en-ET', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  }
})();

// ── Tab Switcher ─────────────────────────────────────────────────────────────
(function () {
  document.querySelectorAll('.bank-tab').forEach(function (tab) {
    tab.addEventListener('click', function () {
      const target = this.getAttribute('data-target');

      // Deactivate all tabs & panes in the same group
      const group = this.closest('.bank-tabs');
      group.querySelectorAll('.bank-tab').forEach(t => t.classList.remove('active'));
      document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));

      // Activate selected
      this.classList.add('active');
      const pane = document.getElementById(target);
      if (pane) pane.classList.add('active');
    });
  });
})();

// ── Fee Calculator ────────────────────────────────────────────────────────────
(function () {
  const amountInput = document.getElementById('amountInput');
  const feeDisplay  = document.getElementById('feeDisplay');
  const totalDisplay= document.getElementById('totalDisplay');
  if (!amountInput || !feeDisplay) return;

  amountInput.addEventListener('input', function () {
    const amount  = parseFloat(this.value) || 0;
    const fee     = parseFloat(feeDisplay.getAttribute('data-fee')) || 0;
    const total   = amount + fee;

    document.getElementById('feeAmount')   && (document.getElementById('feeAmount').textContent   = fee.toFixed(2));
    document.getElementById('totalAmount') && (document.getElementById('totalAmount').textContent  = total.toFixed(2));
  });
})();

// ── Transfer type switcher (show/hide SWIFT fields) ──────────────────────────
(function () {
  const typeSelect    = document.getElementById('transferType');
  const internalFields= document.getElementById('internalFields');
  const externalFields= document.getElementById('externalFields');
  const intlFields    = document.getElementById('intlFields');
  if (!typeSelect) return;

  typeSelect.addEventListener('change', function () {
    const v = this.value;
    if (internalFields) internalFields.style.display = (v === 'INTERNAL')       ? 'block' : 'none';
    if (externalFields) externalFields.style.display = (v === 'EXTERNAL')       ? 'block' : 'none';
    if (intlFields)     intlFields.style.display     = (v === 'INTERNATIONAL')  ? 'block' : 'none';
  });

  // Trigger on load
  typeSelect.dispatchEvent(new Event('change'));
})();

// ── Deposit type switcher ─────────────────────────────────────────────────────
(function () {
  const depositType   = document.getElementById('depositType');
  const internalDep   = document.getElementById('internalDepFields');
  const externalDep   = document.getElementById('externalDepFields');
  const intlDep       = document.getElementById('intlDepFields');
  if (!depositType) return;

  depositType.addEventListener('change', function () {
    const v = this.value;
    if (internalDep) internalDep.style.display = (v === 'INTERNAL')       ? 'block' : 'none';
    if (externalDep) externalDep.style.display = (v === 'EXTERNAL')       ? 'block' : 'none';
    if (intlDep)     intlDep.style.display     = (v === 'INTERNATIONAL')  ? 'block' : 'none';
  });

  depositType.dispatchEvent(new Event('change'));
})();

// ── Session timeout warning ───────────────────────────────────────────────────
(function () {
  const TIMEOUT_MS  = 15 * 60 * 1000;   // 15 minutes
  const WARNING_MS  = 2  * 60 * 1000;   // warn at 2 minutes remaining
  let   timer;

  function resetTimer() {
    clearTimeout(timer);
    timer = setTimeout(function () {
      const ok = confirm('Your session will expire in 2 minutes. Click OK to stay logged in.');
      if (ok) resetTimer();
    }, TIMEOUT_MS - WARNING_MS);
  }

  ['click', 'keydown', 'scroll', 'mousemove'].forEach(function (e) {
    document.addEventListener(e, resetTimer, { passive: true });
  });

  resetTimer();
})();

// ── Confirm dialogs ────────────────────────────────────────────────────────────
document.querySelectorAll('[data-confirm]').forEach(function (el) {
  el.addEventListener('click', function (e) {
    if (!confirm(this.getAttribute('data-confirm'))) e.preventDefault();
  });
});

// ── Auto-dismiss alerts ────────────────────────────────────────────────────────
document.querySelectorAll('.alert-bank').forEach(function (alert) {
  setTimeout(function () {
    alert.style.transition = 'opacity 0.5s';
    alert.style.opacity    = '0';
    setTimeout(() => alert.remove(), 500);
  }, 5000);
});
