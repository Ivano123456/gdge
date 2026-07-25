(function () {
  'use strict';

  const app = document.getElementById('app');

  const el = {
    dirtyBalance: document.getElementById('dirtyBalance'),
    taxRate: document.getElementById('taxRate'),
    taxRateInline: document.getElementById('taxRateInline'),
    amountInput: document.getElementById('amountInput'),
    amountError: document.getElementById('amountError'),
    lineAmount: document.getElementById('lineAmount'),
    lineTax: document.getElementById('lineTax'),
    lineNet: document.getElementById('lineNet'),
    washBtn: document.getElementById('washBtn'),
    washAmount: document.getElementById('washAmount'),
    washRemaining: document.getElementById('washRemaining'),
    tapeFill: document.getElementById('tapeFill'),
    tapePercent: document.getElementById('tapePercent'),
    doneAmount: document.getElementById('doneAmount'),
    cooldownClock: document.getElementById('cooldownClock'),
    stampTime: document.getElementById('stampTime'),
    docSuffix: document.getElementById('docSuffix'),
    statusText: document.getElementById('statusText'),
    chips: document.querySelectorAll('.chip'),
  };

  const state = {
    balance: 0,
    taxRate: 0.30,
    resourceName: 'moneywash',
    washAmount: 0,
    washDuration: 30000,
    maxPerWash: 10000000,
  };

  const fmt = (n) => '$' + Math.max(0, Math.floor(Number(n) || 0)).toLocaleString('en-US');
  const fmtNeg = (n) => '-' + fmt(n);

  function setState(next) { app.setAttribute('data-state', next); }
  function setStatus(text) { el.statusText.textContent = text; }

  function parseAmount(raw) {
    const digits = String(raw ?? '').replace(/[^0-9]/g, '');
    if (!digits) return 0;
    return Math.min(parseInt(digits, 10), 999999999);
  }

  function updateReceipt() {
    const amt = parseAmount(el.amountInput.value);
    const tax = Math.floor(amt * state.taxRate);
    const net = amt - tax;

    el.lineAmount.textContent = fmt(amt);
    el.lineTax.textContent = amt > 0 ? fmtNeg(tax) : '-$0';
    el.lineNet.textContent = fmt(net);

    let err = '';
    if (amt > 0 && amt > state.balance) err = 'Nemate toliko prljavog novca';
    else if (amt > state.maxPerWash) err = 'Maksimalno $10,000,000 po pranju';

    el.amountError.textContent = err;
    el.amountError.classList.toggle('on', Boolean(err));

    el.washBtn.disabled = !(amt > 0 && !err);
  }

  function resetReady() {
    el.amountInput.value = '';
    el.amountError.textContent = '';
    el.amountError.classList.remove('on');
    el.washBtn.classList.remove('pending');
    el.washBtn.disabled = true;
    el.tapeFill.style.width = '0%';
    el.tapePercent.textContent = '0%';
    el.washAmount.textContent = fmt(0);
    el.washRemaining.textContent = '00:30';
    updateReceipt();
  }

  // -----------------------------
  // input handling
  // -----------------------------
  el.amountInput.addEventListener('input', (e) => {
    const cleaned = e.target.value.replace(/[^0-9]/g, '');
    if (cleaned !== e.target.value) e.target.value = cleaned;
    updateReceipt();
  });

  el.chips.forEach((chip) => {
    chip.addEventListener('click', () => {
      const pct = parseFloat(chip.dataset.pct) / 100;
      const v = Math.min(state.maxPerWash, Math.floor(state.balance * pct));
      el.amountInput.value = String(v);
      updateReceipt();
    });
  });

  // -----------------------------
  // actions
  // -----------------------------
  let submitTimeout = null;

  function submitWash() {
    const amt = parseAmount(el.amountInput.value);
    if (amt <= 0 || amt > state.balance || amt > state.maxPerWash) return;

    state.washAmount = amt;
    el.washBtn.disabled = true;
    el.washBtn.classList.add('pending');
    setStatus('SLANJE');
    post('wash', { amount: amt });

    clearTimeout(submitTimeout);
    submitTimeout = setTimeout(() => {
      el.washBtn.classList.remove('pending');
      setStatus('SPREMNO');
      updateReceipt();
    }, 4500);
  }

  function cancel() { post('close', {}); }

  document.querySelectorAll('[data-action="cancel"]').forEach((b) =>
    b.addEventListener('click', cancel)
  );
  el.washBtn.addEventListener('click', submitWash);

  document.addEventListener('keydown', (e) => {
    const s = app.getAttribute('data-state');
    if (s === 'hidden' || s === 'washing' || s === 'done') return;
    if (e.key === 'Escape') cancel();
    else if (e.key === 'Enter' && s === 'ready' && !el.washBtn.disabled) submitWash();
  });

  // -----------------------------
  // NUI ↔ Lua
  // -----------------------------
  function post(name, payload) {
    fetch(`https://${state.resourceName}/${name}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json;charset=UTF-8' },
      body: JSON.stringify(payload || {}),
    }).catch(() => {});
  }

  // -----------------------------
  // wash animation
  // -----------------------------
  let washRAF = null;
  let washFinished = false;

  function runWashAnimation(amount, durationMs) {
    washFinished = false;
    const start = performance.now();
    const net = Math.floor(amount * (1 - state.taxRate));

    cancelAnimationFrame(washRAF);
    const tick = (now) => {
      const elapsed = now - start;
      const pct = Math.min(1, elapsed / durationMs);

      el.tapeFill.style.width = (pct * 100).toFixed(2) + '%';
      el.tapePercent.textContent = Math.floor(pct * 100) + '%';
      el.washAmount.textContent = fmt(Math.floor(net * pct));

      const remainingS = Math.ceil(Math.max(0, durationMs - elapsed) / 1000);
      const mm = String(Math.floor(remainingS / 60)).padStart(2, '0');
      const ss = String(remainingS % 60).padStart(2, '0');
      el.washRemaining.textContent = `${mm}:${ss}`;

      if (pct < 1) {
        washRAF = requestAnimationFrame(tick);
      } else if (!washFinished) {
        washFinished = true;
        post('washComplete', { amount });
        showDone(net);
      }
    };
    washRAF = requestAnimationFrame(tick);
  }

  function showDone(net) {
    setState('done');
    el.doneAmount.textContent = fmt(net);
    setStatus('GOTOVO');
    setTimeout(() => post('close', {}), 2600);
  }

  // -----------------------------
  // cooldown countdown
  // -----------------------------
  let cooldownInterval = null;
  function startCooldown(ms) {
    clearInterval(cooldownInterval);
    const startAt = performance.now();
    const render = () => {
      const remaining = Math.max(0, ms - (performance.now() - startAt));
      const s = Math.ceil(remaining / 1000);
      const mm = String(Math.floor(s / 60)).padStart(2, '0');
      const ss = String(s % 60).padStart(2, '0');
      el.cooldownClock.textContent = `${mm}:${ss}`;
      if (remaining <= 0) clearInterval(cooldownInterval);
    };
    render();
    cooldownInterval = setInterval(render, 500);
  }

  // -----------------------------
  // inbound messages from Lua
  // -----------------------------
  window.addEventListener('message', (ev) => {
    const data = ev.data || {};
    switch (data.action) {
      case 'open':
        state.balance      = Math.max(0, Math.floor(Number(data.balance) || 0));
        state.taxRate      = typeof data.taxRate === 'number' ? data.taxRate : 0.30;
        state.washDuration = Number(data.washDuration) || 30000;
        state.resourceName = data.resourceName || state.resourceName;

        el.dirtyBalance.textContent = fmt(state.balance);
        el.taxRate.textContent = Math.round(state.taxRate * 100) + '%';
        el.taxRateInline.textContent = Math.round(state.taxRate * 100) + '%';
        resetReady();
        randomizeStamp();

        if (data.cooldownMs && data.cooldownMs > 0) {
          setState('cooldown');
          setStatus('ZAKLJUCANO');
          startCooldown(data.cooldownMs);
        } else {
          setState('ready');
          setStatus('SPREMNO');
          setTimeout(() => el.amountInput.focus(), 140);
        }
        break;

      case 'washing':
        clearTimeout(submitTimeout);
        el.washBtn.classList.remove('pending');
        state.washAmount = Number(data.amount) || state.washAmount;
        state.washDuration = Number(data.duration) || state.washDuration;
        setStatus('U PRANJU');
        setState('washing');
        runWashAnimation(state.washAmount, state.washDuration);
        break;

      case 'rejected':
        clearTimeout(submitTimeout);
        el.washBtn.classList.remove('pending');
        setStatus('SPREMNO');
        updateReceipt();
        break;

      case 'close':
      case 'cancelled':
        cleanupAndHide();
        break;
    }
  });

  function cleanupAndHide() {
    cancelAnimationFrame(washRAF);
    clearInterval(cooldownInterval);
    clearTimeout(submitTimeout);
    setState('hidden');
    resetReady();
  }

  function randomizeStamp() {
    const d = new Date();
    el.stampTime.textContent =
      `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')} UTC`;
    const letter = String.fromCharCode(65 + Math.floor(Math.random() * 26));
    const num = Math.floor(1000 + Math.random() * 8999);
    el.docSuffix.textContent = `${letter}-${num}`;
  }
})();
