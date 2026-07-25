const resource = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'jamaica-banke';

const ui = document.getElementById('main');
const amountInput = document.getElementById('amountInput');
const transferId = document.getElementById('transferId');
const confirmButton = document.getElementById('confirmButton');
const balanceLabel = document.getElementById('balance');
const cashLabel = document.getElementById('cashBalance');
const cardOwner = document.getElementById('cardOwner');

let currentAction = 'withdraw';

const labels = {
    withdraw: 'Podigni novac',
    deposit: 'Položi novac',
    transfer: 'Pošalji transfer',
};

function formatMoney(value) {
    const n = Math.floor(Number(value) || 0);
    return '$' + n.toLocaleString('en-US');
}

function parseAmount(str) {
    return Math.floor(Number(String(str || '').replace(/,/g, '')) || 0);
}

function post(endpoint, data) {
    return fetch(`https://${resource}/${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data || {}),
    });
}

function closeUI() {
    if (ui.classList.contains('hidden')) return;
    ui.classList.add('hidden');
    amountInput.value = '';
    transferId.value = '';
    post('close');
}

function selectAction(action) {
    currentAction = action;
    document.querySelectorAll('.buttons button').forEach((btn) => {
        btn.classList.toggle('active', btn.dataset.action === action);
    });
    amountInput.value = '';
    transferId.value = '';
    transferId.classList.toggle('hidden', action !== 'transfer');
    confirmButton.textContent = labels[action] || 'Potvrdi';
}

function submitTransaction() {
    const amount = parseAmount(amountInput.value);
    if (amount < 1) return;

    if (currentAction === 'transfer') {
        const target = Math.floor(Number(transferId.value) || 0);
        if (target < 1) return;
        post('transfer', { amount, target });
    } else if (currentAction === 'deposit') {
        post('deposit', { amount });
    } else {
        post('withdraw', { amount });
    }

    amountInput.value = '';
    transferId.value = '';
}

function setBalances(bank, cash) {
    balanceLabel.textContent = formatMoney(bank);
    cashLabel.textContent = formatMoney(cash);
}

document.querySelectorAll('.buttons button').forEach((btn) => {
    btn.addEventListener('click', () => selectAction(btn.dataset.action));
});

confirmButton.addEventListener('click', submitTransaction);

amountInput.addEventListener('input', () => {
    const raw = amountInput.value.replace(/\D/g, '').slice(0, 9);
    amountInput.value = raw ? Number(raw).toLocaleString('en-US') : '';
});

transferId.addEventListener('input', () => {
    transferId.value = transferId.value.replace(/\D/g, '').slice(0, 4);
});

document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && !ui.classList.contains('hidden')) {
        closeUI();
    }
    if (e.key === 'Enter' && !ui.classList.contains('hidden')) {
        submitTransaction();
    }
});

window.addEventListener('message', (event) => {
    const data = event.data;
    if (!data || !data.action) return;

    if (data.action === 'open') {
        cardOwner.textContent = data.playerName || '—';
        setBalances(data.bank, data.cash);
        selectAction('withdraw');
        ui.classList.remove('hidden');
    }

    if (data.action === 'updateBalances') {
        setBalances(data.bank, data.cash);
    }

    if (data.action === 'close') {
        ui.classList.add('hidden');
    }
});
