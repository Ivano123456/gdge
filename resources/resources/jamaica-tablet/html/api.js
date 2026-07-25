const MDT = {
    resource: 'jamaica-tablet',

    nui(event, data) {
        return fetch(`https://${this.resource}/${event}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data || {})
        }).then(r => r.json()).catch(() => (Array.isArray(data) ? [] : {}));
    },

    close() { return this.nui('close'); },
    searchPlayer(q) { return this.nui('searchPlayer', { query: q }); },
    searchByPlate(plate) { return this.nui('searchByPlate', { plate }); },
    getActivePD() { return this.nui('getActivePD'); },
    getOnlinePlayers() { return this.nui('getOnlinePlayers'); },
    getAllWarrants(force) { return this.nui('getAllWarrants', { forceRefresh: !!force }); },
    getPlayerByIdentifier(id) { return this.nui('getPlayerByIdentifier', { identifier: id }); },
    getPlayerById(id) { return this.nui('getPlayerById', { id }); },
    getNotes(id) { return this.nui('getNotes', { identifier: id }); },
    addNote(id, note) { return this.nui('addNote', { identifier: id, note }); },
    deleteNote(noteId) { return this.nui('deleteNote', { noteId }); },
    addWarrant(id, tip, razlog) { return this.nui('addWarrant', { identifier: id, tip, razlog }); },
    revokeWarrant(warrantId) { return this.nui('revokeWarrant', { warrantId }); },
    getWarrantComments(warrantId) { return this.nui('getWarrantComments', { warrantId }); },
    addWarrantComment(warrantId, tekst) { return this.nui('addWarrantComment', { warrantId, tekst }); },
    deleteWarrantComment(commentId) { return this.nui('deleteWarrantComment', { commentId }); },
    getBolo() { return this.nui('getBolo'); },
    postBolo(type, desc, location) { return this.nui('postBolo', { type, desc, location }); },
    resolveBolo(id) { return this.nui('resolveBolo', { id }); },
    deleteBolo(id) { return this.nui('deleteBolo', { id }); },
    getBoloComments(boloId) { return this.nui('getBoloComments', { boloId }); },
    addBoloComment(boloId, tekst) { return this.nui('addBoloComment', { boloId, tekst }); },
    getEvidencija() { return this.nui('getEvidencija'); },
    getChatHistory() { return this.nui('getChatHistory'); },
    sendChatMessage(text) { return this.nui('sendChatMessage', { text }); },
    getWantedList() { return this.nui('getWantedList'); },
    trackSuspect(payload) { return this.nui('trackSuspect', payload); },
    removeBlip(identifier) { return this.nui('removeBlip', { identifier }); }
};

function esc(str) {
    if (str == null) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

function initials(first, last) {
    const a = (first || '?')[0] || '?';
    const b = (last || '')[0] || '';
    return (a + b).toUpperCase();
}

function starsHtml(n) {
    let h = '';
    for (let i = 0; i < 5; i++) h += `<span class="star${i < n ? ' on' : ''}">★</span>`;
    return h;
}

function playerTags(p) {
    let h = '';
    if (p.locked) return '<span class="tag tag-lock">ZAŠTIĆENO</span>';
    if (p.warrants && p.warrants.length) h += `<span class="tag tag-warn">${p.warrants.length} POTJ.</span>`;
    if (p.notesCount > 0) h += `<span class="tag tag-note">${p.notesCount} DOSIJE</span>`;
    if (p.jail > 0) h += `<span class="tag tag-jail">ZATVOR ${p.jail}m</span>`;
    if (p.hag > 0) h += `<span class="tag tag-jail">HAG ${p.hag}h</span>`;
    if (!h) h = '<span class="tag tag-ok">ČIST</span>';
    return h;
}

const POLICE = new Set(['police','noose','bia','delta','fib','kgb','saj','sheriff','sheriffp','sud','cia']);

function orgTag(job, label) {
    const cls = POLICE.has(job) ? 'tag-org' : 'tag-org-civ';
    return `<span class="tag ${cls}">${esc(label || job)}</span>`;
}

function sexLabel(s) {
    if (s === 'm') return 'Muško';
    if (s === 'f') return 'Žensko';
    return 'N/A';
}

function confirmDialog(msg) {
    return new Promise(resolve => {
        const modal = document.getElementById('modal');
        document.getElementById('modal-text').textContent = msg;
        modal.classList.remove('hidden');
        const yes = document.getElementById('modal-yes');
        const no = document.getElementById('modal-no');
        const done = v => { modal.classList.add('hidden'); yes.onclick = null; no.onclick = null; resolve(v); };
        yes.onclick = () => done(true);
        no.onclick = () => done(false);
    });
}

function showToast(msg) {
    const el = document.getElementById('toast');
    el.textContent = msg;
    el.classList.remove('hidden');
    clearTimeout(showToast._t);
    showToast._t = setTimeout(() => el.classList.add('hidden'), 4500);
}
