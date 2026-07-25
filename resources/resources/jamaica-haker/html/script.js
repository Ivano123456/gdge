const resource = (typeof GetParentResourceName === 'function')
    ? GetParentResourceName()
    : 'jamaica-haker';

const root = document.getElementById('root');
const daysLeft = document.getElementById('daysLeft');
const playerIdInput = document.getElementById('playerId');
const btnSearch = document.getElementById('btnSearch');
const btnClose = document.getElementById('btnClose');
const emptyState = document.getElementById('emptyState');
const resultWrap = document.getElementById('resultWrap');
const targetName = document.getElementById('targetName');
const targetId = document.getElementById('targetId');
const targetCount = document.getElementById('targetCount');
const recordsList = document.getElementById('recordsList');

let current = {
    playerId: null,
    name: null,
    records: [],
};

function post(endpoint, data) {
    return fetch(`https://${resource}/${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data || {}),
    });
}

function formatMoney(n) {
    return Number(n || 0).toLocaleString('sr-RS') + '$';
}

function setEmpty(title, text) {
    emptyState.innerHTML = `
        <div class="empty-icon"><i class="fa-solid fa-user-secret"></i></div>
        <strong>${escapeHtml(title)}</strong>
        <span>${escapeHtml(text)}</span>
    `;
}

function resetView() {
    current = { playerId: null, name: null, records: [] };
    resultWrap.classList.add('hidden');
    emptyState.classList.remove('hidden');
    setEmpty('Nema aktivne pretrage', 'Unesi ID igrača da vidiš dosijee i poternice.');
    recordsList.innerHTML = '';
}

function renderRecords(records) {
    recordsList.innerHTML = '';

    if (!records || records.length === 0) {
        recordsList.innerHTML = `
            <div class="no-records">
                <i class="fa-regular fa-folder-open"></i>
                <span>Nema zapisa.</span>
            </div>
        `;
        targetCount.textContent = '0 zapisa';
        return;
    }

    targetCount.textContent = records.length + (records.length === 1 ? ' zapis' : ' zapisa');

    records.forEach((rec) => {
        const tip = rec.tip === 'potjernica' ? 'potjernica' : 'dosje';
        const isWarrant = tip === 'potjernica';
        const label = isWarrant ? 'Poternica' : 'Dosije';
        const icon = isWarrant ? 'fa-file-circle-exclamation' : 'fa-folder-open';
        const el = document.createElement('div');
        el.className = 'record' + (isWarrant ? ' warrant-row' : '');
        el.dataset.id = String(rec.id);
        el.dataset.tip = tip;
        el.innerHTML = `
            <div class="record-info">
                <div class="record-top">
                    <span class="badge ${isWarrant ? 'warrant' : ''}">
                        <i class="fa-solid ${icon}"></i>${label}
                    </span>
                    <span class="record-price">${formatMoney(rec.cena)}</span>
                </div>
                <div class="record-text">${escapeHtml(rec.text || '—')}</div>
                <div class="record-meta">${escapeHtml(rec.meta || '')}</div>
            </div>
            <button type="button" class="btn danger">
                <i class="fa-solid fa-trash-can"></i>Obriši
            </button>
        `;

        el.querySelector('button').addEventListener('click', () => {
            const btn = el.querySelector('button');
            btn.disabled = true;
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i>Poslato';
            post('offerDelete', {
                playerId: current.playerId,
                recordId: rec.id,
                recordTip: tip,
            });
            setTimeout(() => {
                if (btn.isConnected) {
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fa-solid fa-trash-can"></i>Obriši';
                }
            }, 2500);
        });

        recordsList.appendChild(el);
    });
}

function escapeHtml(str) {
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

function showResult(data) {
    if (!data) {
        resetView();
        emptyState.classList.remove('hidden');
        setEmpty('Igrač nije pronađen', 'Proveri ID i pokušaj ponovo.');
        return;
    }

    current.playerId = data.playerId;
    current.name = data.name;
    current.records = data.records || [];

    emptyState.classList.add('hidden');
    resultWrap.classList.remove('hidden');
    targetName.textContent = data.name || 'Nepoznato';
    targetId.textContent = String(data.playerId);
    renderRecords(current.records);
}

function doSearch() {
    const id = playerIdInput.value.trim();
    if (!id) return;
    post('lookup', { playerId: id });
}

btnSearch.addEventListener('click', doSearch);
playerIdInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') doSearch();
});

btnClose.addEventListener('click', () => post('close'));

document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') post('close');
});

window.addEventListener('message', (event) => {
    const msg = event.data || {};

    switch (msg.action) {
        case 'open':
            root.classList.remove('hidden');
            daysLeft.textContent = String(msg.days || 0);
            playerIdInput.value = '';
            resetView();
            setTimeout(() => playerIdInput.focus(), 50);
            break;

        case 'close':
            root.classList.add('hidden');
            break;

        case 'updateDays':
            daysLeft.textContent = String(msg.days || 0);
            break;

        case 'lookupResult':
            showResult(msg.data);
            break;

        case 'recordDeleted': {
            const info = msg.data || {};
            if (String(current.playerId) !== String(info.playerId)) break;
            const rid = String(info.recordId);
            current.records = current.records.filter((r) => !(String(r.id) === rid && r.tip === info.recordTip));
            renderRecords(current.records);
            break;
        }
    }
});
