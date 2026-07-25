const State = {
    view: 'dashboard',
    job: '',
    dossier: null,
    dossierTab: 'overview',
    dossierTarget: null,
    searchResults: [],
    warrants: [],
    warrantFilter: '',
    warrantOnline: true,
    warrantPage: 1,
    suspects: {},
    tracking: new Set(),
    evidencija: [],
    evFilter: 'all',
    alertsOn: localStorage.getItem('mdtAlerts') !== 'off',
    chatUnread: false
};

const VIEW_META = {
    dashboard: { title: 'Pregled sistema', desc: 'Brzi uvid u aktivne operacije' },
    search: { title: 'Pretraga građana', desc: 'Ime, prezime ili identifikator' },
    plates: { title: 'Pretraga vozila', desc: 'Registarske tablice i vlasnici' },
    warrants: { title: 'Aktivne potjernice', desc: 'Raspored potjernica po licima' },
    bolo: { title: 'BOLO — potraga', desc: 'Raspisana potraga po vozilu, osobi ili lokaciji' },
    suspects: { title: 'Traženi osumnjičeni', desc: 'Wanted sistem i GPS praćenje' },
    evidencija: { title: 'Evidencija akcija', desc: 'Pregled aktivnosti ove sedmice' },
    online: { title: 'Online igrači', desc: 'Svi igrači trenutno na serveru' },
    units: { title: 'Aktivni službenici', desc: 'Policijske organizacije na dužnosti' },
    chat: { title: 'PD Chat', desc: 'Interna komunikacija jedinica' }
};

const WARRANT_PAGE = 25;

function setView(name) {
    State.view = name;
    document.querySelectorAll('.nav-item').forEach(b => b.classList.toggle('active', b.dataset.view === name));
    document.querySelectorAll('.view').forEach(v => v.classList.toggle('active', v.id === `view-${name}`));
    const meta = VIEW_META[name] || VIEW_META.dashboard;
    document.getElementById('view-title').textContent = meta.title;
    document.getElementById('view-desc').textContent = meta.desc;

    if (name === 'dashboard') loadDashboard();
    if (name === 'warrants') loadWarrants();
    if (name === 'bolo') loadBolo();
    if (name === 'suspects') loadSuspects();
    if (name === 'evidencija') loadEvidencija();
    if (name === 'online') loadOnline();
    if (name === 'units') loadUnits();
    if (name === 'chat') { State.chatUnread = false; syncChatBadge(); loadChat(); }
}

function openMdt(job) {
    State.job = job || '';
    document.getElementById('mdt-root').classList.remove('hidden');
    syncAlertBtn();
    setView('dashboard');
    MDT.getWantedList().then(list => {
        State.suspects = {};
        (list || []).forEach(s => { State.suspects[s.identifier] = s; });
        syncSuspectBadge();
    });
}

function hideMdt() {
    document.getElementById('mdt-root').classList.add('hidden');
    State.dossier = null;
    document.getElementById('input-search').value = '';
    document.getElementById('search-results').innerHTML = '<div class="empty">Unesite najmanje 2 karaktera</div>';
    clearDetail('search-detail');
    clearDetail('plate-detail');
}

function closeMdt() {
    MDT.close();
    hideMdt();
}

function clearDetail(id) {
    const el = document.getElementById(id);
    if (!el) return;
    el.innerHTML = `<div class="detail-empty"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg><p>Odaberite stavku za detalje</p></div>`;
}

function syncAlertBtn() {
    const btn = document.getElementById('btn-alerts');
    btn.textContent = State.alertsOn ? 'Alarmi: ON' : 'Alarmi: OFF';
    btn.classList.toggle('on', State.alertsOn);
    btn.classList.toggle('off', !State.alertsOn);
}

function syncSuspectBadge() {
    const n = Object.keys(State.suspects).length;
    const b = document.getElementById('badge-suspects');
    if (n > 0) { b.textContent = n; b.classList.remove('hidden'); }
    else b.classList.add('hidden');
}

function syncChatBadge() {
    document.getElementById('badge-chat').classList.toggle('hidden', !State.chatUnread);
}

function tickClock() {
    const d = new Date();
    document.getElementById('header-clock').textContent =
        `${String(d.getHours()).padStart(2,'0')}:${String(d.getMinutes()).padStart(2,'0')}`;
}

async function loadDashboard() {
    const [units, warrants, bolo, suspects] = await Promise.all([
        MDT.getActivePD(), MDT.getAllWarrants(), MDT.getBolo(), MDT.getWantedList()
    ]);

    document.getElementById('stat-units').textContent = (units || []).length;
    document.getElementById('stat-warrants').textContent = (warrants || []).length;
    document.getElementById('stat-suspects').textContent = (suspects || []).length;
    document.getElementById('stat-bolo').textContent = (bolo || []).filter(b => !b.resolved).length;

    const wEl = document.getElementById('dash-warrants');
    const sEl = document.getElementById('dash-suspects');

    if (!warrants || !warrants.length) wEl.innerHTML = '<div class="empty">Nema aktivnih potjernica</div>';
    else {
        wEl.innerHTML = '';
        warrants.slice(0, 6).forEach(w => {
            wEl.appendChild(buildMiniCard(
                `${w.firstname || ''} ${w.lastname || ''}`.trim(),
                w.tip || 'Potjernica',
                () => openDossierById(w.identifier)
            ));
        });
    }

    if (!suspects || !suspects.length) sEl.innerHTML = '<div class="empty">Nema traženih</div>';
    else {
        sEl.innerHTML = '';
        suspects.slice(0, 6).forEach(s => {
            sEl.appendChild(buildMiniCard(
                `${s.firstname || ''} ${s.lastname || ''}`.trim(),
                `${s.stars || 0} ★ · ${s.online ? 'Online' : 'Offline'}`,
                () => openDossierById(s.identifier)
            ));
        });
    }
}

function buildMiniCard(title, sub, onClick) {
    const d = document.createElement('div');
    d.className = 'card';
    d.innerHTML = `<div class="card-title">${esc(title)}</div><div class="card-sub">${esc(sub)}</div>`;
    d.addEventListener('click', onClick);
    return d;
}

let searchTimer = null;
function doSearch() {
    const q = document.getElementById('input-search').value.trim();
    const box = document.getElementById('search-results');
    if (q.length < 2) {
        box.innerHTML = '<div class="empty">Unesite najmanje 2 karaktera</div>';
        return;
    }
    box.innerHTML = '<div class="empty">Pretraživanje...</div>';
    MDT.searchPlayer(q).then(results => {
        State.searchResults = results || [];
        if (!State.searchResults.length) {
            box.innerHTML = '<div class="empty">Nema rezultata</div>';
            return;
        }
        box.innerHTML = '';
        State.searchResults.forEach(p => box.appendChild(buildPersonCard(p, 'search')));
    });
}

function buildPersonCard(p, ctx) {
    const card = document.createElement('div');
    card.className = 'card';
    const name = `${p.firstname || ''} ${p.lastname || ''}`.trim();
    const steam = p.steamName ? ` <span class="muted">[${esc(p.steamName)}]</span>` : '';
    let sub = `DOB: ${esc(p.dateofbirth || 'N/A')} · ${sexLabel(p.sex)}`;

    card.innerHTML = `
        <div class="card-row">
            <div class="card-with-avatar">
                <div class="initials">${esc(initials(p.firstname, p.lastname))}</div>
                <div>
                    <div class="card-title">${esc(name)}${steam}</div>
                    <div class="card-sub">${sub}</div>
                </div>
            </div>
            <div class="card-badges">${playerTags(p)}</div>
        </div>`;

    card.addEventListener('click', () => {
        document.querySelectorAll(`#${ctx === 'search' ? 'search' : 'plate'}-results .card`).forEach(c => c.classList.remove('selected'));
        card.classList.add('selected');
        renderDossier(p, ctx === 'search' ? 'search-detail' : 'plate-detail');
    });
    return card;
}

function renderDossier(player, panelId) {
    State.dossier = player;
    State.dossierTab = 'overview';
    State.dossierTarget = panelId;
    const panel = document.getElementById(panelId);

    const name = `${player.firstname || ''} ${player.lastname || ''}`.trim();
    panel.innerHTML = `
        <div class="dossier" id="dossier-root">
            <div class="dossier-head">
                <div class="initials">${esc(initials(player.firstname, player.lastname))}</div>
                <div class="dossier-head-info">
                    <div class="dossier-name">${esc(name)}</div>
                    <div class="dossier-meta">${esc(player.identifier || '')}${player.steamName ? ' · [' + esc(player.steamName) + ']' : ''}</div>
                </div>
                <div class="card-badges">${playerTags(player)}</div>
            </div>
            <div class="dossier-tabs">
                <button type="button" class="dtab active" data-dtab="overview">Pregled</button>
                <button type="button" class="dtab" data-dtab="warrants">Potjernice <span class="tag tag-warn" id="dt-w">${(player.warrants||[]).length}</span></button>
                <button type="button" class="dtab" data-dtab="notes">Dosije <span class="tag tag-note" id="dt-n">${player.notesCount||0}</span></button>
            </div>
            <div class="dossier-scroll" id="dossier-scroll"></div>
        </div>`;

    panel.querySelectorAll('.dtab').forEach(btn => {
        btn.addEventListener('click', () => {
            State.dossierTab = btn.dataset.dtab;
            panel.querySelectorAll('.dtab').forEach(b => b.classList.toggle('active', b === btn));
            paintDossierTab();
        });
    });
    paintDossierTab();
}

function paintDossierTab() {
    const p = State.dossier;
    const box = document.getElementById('dossier-scroll');
    if (!p || !box) return;

    if (State.dossierTab === 'overview') {
        const jailed = p.jail > 0;
        const hag = p.hag > 0;
        const status = jailed ? `ZATVOREN (${p.jail} min)` : (hag ? `HAG (${p.hag}h)` : 'SLOBODAN');
        const sc = (jailed || hag) ? '#eab308' : '#22c55e';
        box.innerHTML = `
            <div class="section-label">Lični podaci</div>
            <div class="grid-2">
                <div class="kv"><div class="kv-k">Datum rođenja</div><div class="kv-v">${esc(p.dateofbirth || 'N/A')}</div></div>
                <div class="kv"><div class="kv-k">Spol</div><div class="kv-v">${sexLabel(p.sex)}</div></div>
                <div class="kv"><div class="kv-k">Status</div><div class="kv-v" style="color:${sc}">${status}</div></div>
                <div class="kv"><div class="kv-k">Potjernice</div><div class="kv-v">${(p.warrants||[]).length}</div></div>
            </div>
            ${jailed ? `<div class="section-label">Zatvor</div><div class="kv"><div class="kv-k">Razlog</div><div class="kv-v">${esc(p.razlogjaila || 'N/A')}</div></div>` : ''}
            ${hag ? `<div class="section-label">HAG</div><div class="kv"><div class="kv-k">Razlog</div><div class="kv-v">${esc(p.hag_razlog || 'N/A')}</div></div>` : ''}`;
        return;
    }

    if (State.dossierTab === 'warrants') {
        let list = '';
        (p.warrants || []).forEach(w => {
            list += `<div class="warrant-box"><span class="tag tag-warn">${esc(w.tip||'Opšte')}</span><div class="note-text" style="margin-top:6px">${esc(w.razlog||'')}</div><button type="button" class="btn sm danger" style="margin-top:8px" data-revoke="${w.id}">Ukini</button></div>`;
        });
        if (!list) list = '<div class="empty" style="padding:20px">Nema aktivnih potjernica</div>';
        box.innerHTML = `
            <div class="section-label">Aktivne potjernice</div>${list}
            <div class="section-label" style="margin-top:16px">Nova potjernica</div>
            <div class="form-stack">
                <select class="field" id="new-w-type"><option value="Krivično">Krivično</option><option value="Saobraćaj">Saobraćaj</option><option value="Opšte">Opšte</option></select>
                <textarea class="field" id="new-w-reason" placeholder="Razlog..." maxlength="500"></textarea>
                <button type="button" class="btn primary" id="new-w-btn">Izda potjernicu</button>
            </div>`;
        box.querySelectorAll('[data-revoke]').forEach(btn => {
            btn.addEventListener('click', async () => {
                if (!await confirmDialog('Ukinuti potjernicu?')) return;
                const res = await MDT.revokeWarrant(Number(btn.dataset.revoke));
                if (res.success) refreshDossier(p.identifier);
            });
        });
        document.getElementById('new-w-btn').addEventListener('click', async () => {
            const razlog = document.getElementById('new-w-reason').value.trim();
            if (!textOk(razlog)) return;
            const tip = document.getElementById('new-w-type').value;
            const res = await MDT.addWarrant(p.identifier, tip, razlog);
            if (res.success) refreshDossier(p.identifier);
        });
        return;
    }

    if (State.dossierTab === 'notes') {
        box.innerHTML = `<div class="section-label">Bilješke</div><div id="notes-wrap"><div class="empty">Učitavanje...</div></div>
            <div class="form-stack"><textarea class="field" id="new-note" placeholder="Nova bilješka..." maxlength="500"></textarea>
            <button type="button" class="btn primary" id="new-note-btn">Dodaj u dosije</button></div>`;
        document.getElementById('new-note-btn').addEventListener('click', async () => {
            const note = document.getElementById('new-note').value.trim();
            if (!textOk(note)) return;
            const res = await MDT.addNote(p.identifier, note);
            if (res.success) { document.getElementById('new-note').value = ''; loadNotesList(p.identifier); }
        });
        loadNotesList(p.identifier);
    }
}

function textOk(t) { return t && t.length >= 1; }

async function loadNotesList(identifier) {
    const wrap = document.getElementById('notes-wrap');
    if (!wrap) return;
    const notes = await MDT.getNotes(identifier);
    if (State.dossier && State.dossier.identifier === identifier) {
        State.dossier.notesCount = (notes || []).length;
        const el = document.getElementById('dt-n');
        if (el) el.textContent = State.dossier.notesCount;
    }
    if (!notes || !notes.length) { wrap.innerHTML = '<div class="empty" style="padding:16px">Nema bilješki</div>'; return; }
    wrap.innerHTML = '';
    notes.forEach(n => {
        const d = document.createElement('div');
        d.className = 'note-box';
        d.innerHTML = `<div class="note-text">${esc(n.note)}</div><div class="note-meta">${esc(n.officer)} · ${new Date(n.created_at).toLocaleString('bs')}</div><button type="button" class="note-del">✕</button>`;
        d.querySelector('.note-del').addEventListener('click', async () => {
            if (!await confirmDialog('Obrisati bilješku?')) return;
            const res = await MDT.deleteNote(n.id);
            if (res.success) loadNotesList(identifier);
        });
        wrap.appendChild(d);
    });
}

async function refreshDossier(identifier) {
    const player = await MDT.getPlayerByIdentifier(identifier);
    if (!player || !player.identifier) return;
    State.dossier = player;
    renderDossier(player, State.dossierTarget || 'search-detail');
    refreshSearchCard(identifier);
}

function refreshSearchCard(identifier) {
    const card = document.querySelector(`#search-results .card.selected`);
    if (!card || !State.dossier) return;
    const badges = card.querySelector('.card-badges');
    if (badges) badges.innerHTML = playerTags(State.dossier);
}

async function openDossierById(identifier) {
    const p = await MDT.getPlayerByIdentifier(identifier);
    if (!p || !p.firstname) return;
    setView('search');
    renderDossier(p, 'search-detail');
}

let plateTimer = null;
function doPlateSearch() {
    const q = document.getElementById('input-plate').value.trim();
    const box = document.getElementById('plate-results');
    if (q.length < 2) { box.innerHTML = '<div class="empty">Unesite tablicu</div>'; return; }
    box.innerHTML = '<div class="empty">Pretraživanje...</div>';
    MDT.searchByPlate(q).then(results => {
        if (!results || !results.length) { box.innerHTML = '<div class="empty">Nema rezultata</div>'; return; }
        box.innerHTML = '';
        results.forEach(v => {
            const card = document.createElement('div');
            card.className = 'card';
            let model = '';
            try { model = JSON.parse(v.vehicle).model || ''; } catch (_) {}
            card.innerHTML = `
                <div class="card-row">
                    <div><div class="card-title">🚗 ${esc(v.plate)}</div>
                    <div class="card-sub">${esc(v.firstname||'')} ${esc(v.lastname||'')} · ${esc(String(model))}</div></div>
                    <div class="card-badges">${v.locked ? '<span class="tag tag-lock">ZAŠTIĆENO</span>' : (v.warrants&&v.warrants.length ? `<span class="tag tag-warn">${v.warrants.length} POTJ.</span>` : '<span class="tag tag-ok">ČIST</span>')}</div>
                </div>`;
            if (!v.locked) card.addEventListener('click', async () => {
                document.querySelectorAll('#plate-results .card').forEach(c => c.classList.remove('selected'));
                card.classList.add('selected');
                const owner = await MDT.getPlayerByIdentifier(v.identifier);
                if (owner && owner.firstname) renderDossier(owner, 'plate-detail');
            });
            box.appendChild(card);
        });
    });
}

function formatCommentDate(raw) {
    try {
        return new Date(raw).toLocaleString('bs-BA', { dateStyle: 'short', timeStyle: 'short' });
    } catch (_) {
        return String(raw || '');
    }
}

function paintCommentList(list, comments) {
    if (!comments || !comments.length) {
        list.innerHTML = '<div class="comments-empty">Nema komentara</div>';
        return;
    }
    list.innerHTML = '';
    comments.forEach(c => {
        const d = document.createElement('div');
        d.className = 'comment-item';
        const when = c.created_at ? formatCommentDate(c.created_at) : '';
        d.innerHTML = `
            <div class="comment-head">
                <span class="tag tag-org">${esc(c.org || 'PD')}</span>
                <span class="comment-author">${esc(c.officer || '')}</span>
                ${when ? `<span class="comment-time">${esc(when)}</span>` : ''}
            </div>
            <div class="comment-body">${esc(c.tekst || '')}</div>`;
        list.appendChild(d);
    });
}

function renderCommentsSection(wrap, comments, addFn, opts = {}) {
    const maxLen = opts.maxLen || 300;
    const placeholder = opts.placeholder || 'Komentar...';

    wrap.innerHTML = `
        <div class="comments-panel">
            <div class="comments-panel-head">
                <span class="comments-panel-title">Komentari</span>
                <span class="comments-panel-count">${(comments || []).length}</span>
            </div>
            <div class="comments-list"></div>
            <div class="comment-compose">
                <textarea class="field comment-field" placeholder="${placeholder}" maxlength="${maxLen}" rows="2"></textarea>
                <button type="button" class="btn sm primary comment-send">Dodaj</button>
            </div>
        </div>`;

    const list = wrap.querySelector('.comments-list');
    const input = wrap.querySelector('.comment-field');
    const btn = wrap.querySelector('.comment-send');
    paintCommentList(list, comments);

    const send = async () => {
        const t = input.value.trim();
        if (!t || btn.disabled) return;
        btn.disabled = true;
        input.value = '';
        const ok = await addFn(t);
        btn.disabled = false;
        if (ok !== false) input.focus();
    };

    btn.addEventListener('click', send);
    input.addEventListener('keydown', e => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            send();
        }
    });
    wrap.addEventListener('click', e => e.stopPropagation());
}

function filterWarrantsList() {
    let list = State.warrants;
    if (State.warrantOnline) list = list.filter(w => w.steamName);
    const q = State.warrantFilter.toLowerCase();
    if (q) list = list.filter(w => `${w.firstname||''} ${w.lastname||''}`.toLowerCase().includes(q));
    return list;
}

async function loadWarrants(force) {
    const box = document.getElementById('warrant-list');
    box.innerHTML = '<div class="empty">Učitavanje...</div>';
    State.warrants = await MDT.getAllWarrants(force) || [];
    State.warrantPage = 1;
    paintWarrants();
}

function paintWarrants() {
    const filtered = filterWarrantsList();
    const box = document.getElementById('warrant-list');
    const pages = document.getElementById('warrant-pages');
    const totalPages = Math.max(1, Math.ceil(filtered.length / WARRANT_PAGE));
    State.warrantPage = Math.min(State.warrantPage, totalPages);

    if (!filtered.length) {
        box.innerHTML = '<div class="empty">Nema potjernica</div>';
        pages.innerHTML = '';
        return;
    }

    const start = (State.warrantPage - 1) * WARRANT_PAGE;
    box.innerHTML = '';
    filtered.slice(start, start + WARRANT_PAGE).forEach(w => {
        const row = document.createElement('div');
        row.className = 'card';
        const name = `${w.firstname||''} ${w.lastname||''}`.trim();
        row.innerHTML = `
            <div class="card-row">
                <div><div class="card-title">${esc(name)}${w.steamName ? ` <span class="muted">[${esc(w.steamName)}]</span>` : ''}</div>
                <div class="card-sub">${esc(w.tip||'')} · ${esc(w.razlog||'')}</div></div>
                <button type="button" class="btn sm ghost btn-wc" data-wid="${w.id}">Komentari</button>
            </div>
            <div class="comments-wrap hidden" id="wc-${w.id}"></div>`;
        row.querySelector('.card-row > div').addEventListener('click', () => openDossierById(w.identifier));
        row.querySelector('.btn-wc').addEventListener('click', e => {
            e.stopPropagation();
            toggleWarrantComments(w.id, row);
        });
        box.appendChild(row);
    });

    pages.innerHTML = `<span class="page-info">${filtered.length} ukupno</span><div class="page-btns"></div>`;
    const ctr = pages.querySelector('.page-btns');
    if (totalPages <= 1) return;
    const mk = (label, page, dis) => {
        const b = document.createElement('button');
        b.textContent = label;
        b.disabled = !!dis;
        if (page === State.warrantPage) b.classList.add('active');
        b.addEventListener('click', () => { State.warrantPage = page; paintWarrants(); });
        ctr.appendChild(b);
    };
    mk('←', State.warrantPage - 1, State.warrantPage === 1);
    for (let p = Math.max(1, State.warrantPage - 2); p <= Math.min(totalPages, State.warrantPage + 2); p++) mk(String(p), p);
    mk('→', State.warrantPage + 1, State.warrantPage === totalPages);
}

async function toggleWarrantComments(wid, row) {
    const wrap = row.querySelector(`#wc-${wid}`);
    const btn = row.querySelector('.btn-wc');
    if (!wrap.classList.contains('hidden')) {
        wrap.classList.add('hidden');
        btn?.classList.remove('active');
        return;
    }
    wrap.classList.remove('hidden');
    btn?.classList.add('active');
    wrap.innerHTML = '<div class="comments-loading">Učitavanje...</div>';
    const comments = await MDT.getWarrantComments(wid);
    renderCommentsSection(wrap, comments, async (t) => {
        await MDT.addWarrantComment(wid, t);
        const fresh = await MDT.getWarrantComments(wid);
        const list = wrap.querySelector('.comments-list');
        const countEl = wrap.querySelector('.comments-panel-count');
        if (list) paintCommentList(list, fresh);
        if (countEl) countEl.textContent = (fresh || []).length;
    });
}

async function loadBolo() {
    const box = document.getElementById('bolo-list');
    box.innerHTML = '<div class="empty">Učitavanje...</div>';
    const list = await MDT.getBolo();
    if (!list || !list.length) { box.innerHTML = '<div class="empty">Nema BOLO upozorenja</div>'; return; }
    box.innerHTML = '';
    list.forEach(b => box.appendChild(buildBoloRow(b)));
}

function buildBoloRow(b) {
    const wrap = document.createElement('div');
    wrap.dataset.boloId = b.id;
    const resolved = b.resolved === true || b.resolved === 1;
    wrap.innerHTML = `
        <div class="bolo-card${resolved ? ' resolved' : ''}">
            <div class="bolo-head"><span class="tag tag-warn">${esc((b.type||'').toUpperCase())}</span>
            <span>${esc(b.firstname||'')} ${esc(b.lastname||'')} <span class="muted">[${esc(b.steamName||'')}]</span></span>
            <span class="muted" style="margin-left:auto">${esc(b.time||'')}</span></div>
            <div class="bolo-desc">${esc(b.desc||'')}</div>
            ${b.location ? `<div class="bolo-loc">📍 ${esc(b.location)}</div>` : ''}
            <div class="bolo-actions">
                ${resolved ? '<span class="tag tag-ok">RIJEŠENO</span>' : `<button type="button" class="btn sm ghost btn-resolve">Riješi</button>`}
                <button type="button" class="btn sm ghost btn-del-bolo">Obriši</button>
                <button type="button" class="btn sm ghost btn-bolo-c">Komentari</button>
            </div>
        </div>
        <div class="comments-wrap hidden bolo-c"></div>`;

    const resolveBtn = wrap.querySelector('.btn-resolve');
    if (resolveBtn) resolveBtn.addEventListener('click', () => MDT.resolveBolo(b.id));
    wrap.querySelector('.btn-del-bolo').addEventListener('click', async () => {
        if (await confirmDialog('Obrisati BOLO?')) MDT.deleteBolo(b.id);
    });
    wrap.querySelector('.btn-bolo-c').addEventListener('click', () => toggleBoloComments(b.id, wrap));
    return wrap;
}

async function toggleBoloComments(boloId, wrap) {
    const c = wrap.querySelector('.bolo-c');
    const btn = wrap.querySelector('.btn-bolo-c');
    if (!c.classList.contains('hidden')) {
        c.classList.add('hidden');
        btn?.classList.remove('active');
        return;
    }
    c.classList.remove('hidden');
    btn?.classList.add('active');
    c.innerHTML = '<div class="comments-loading">Učitavanje...</div>';
    const comments = await MDT.getBoloComments(boloId);
    renderCommentsSection(c, comments, async (t) => {
        await MDT.addBoloComment(boloId, t);
        const fresh = await MDT.getBoloComments(boloId);
        const list = c.querySelector('.comments-list');
        const countEl = c.querySelector('.comments-panel-count');
        if (list) paintCommentList(list, fresh);
        if (countEl) countEl.textContent = (fresh || []).length;
    }, { maxLen: 200 });
}

async function loadSuspects() {
    const box = document.getElementById('suspect-list');
    box.innerHTML = '<div class="empty">Učitavanje...</div>';
    const list = await MDT.getWantedList();
    State.suspects = {};
    (list || []).forEach(s => { State.suspects[s.identifier] = s; });
    syncSuspectBadge();
    paintSuspects();
    const needRetry = (list || []).some(s => s.online && !s.coords);
    if (needRetry) setTimeout(() => { if (State.view === 'suspects') loadSuspects(); }, 11000);
}

function paintSuspects() {
    const box = document.getElementById('suspect-list');
    const entries = Object.values(State.suspects);
    if (!entries.length) { box.innerHTML = '<div class="empty">Nema traženih</div>'; return; }
    entries.sort((a, b) => (b.stars || 0) - (a.stars || 0));
    box.innerHTML = '';
    entries.forEach(s => {
        const row = document.createElement('div');
        row.className = 'suspect-card';
        const name = `${s.firstname||''} ${s.lastname||''}`.trim();
        const tracking = State.tracking.has(s.identifier);
        const hasCoords = s.coords && s.coords.x != null;
        row.innerHTML = `
            <div style="flex:1;cursor:pointer" class="suspect-info">
                <div class="card-title">${s.online ? '<span class="online-dot">●</span>' : '<span class="offline-dot">●</span>'} ${esc(name)}${s.steamName ? ` <span class="muted">[${esc(s.steamName)}]</span>` : ''}</div>
                <div class="stars">${starsHtml(s.stars||0)}</div>
                ${s.victimName ? `<div class="card-sub">Ubistvo <span class="victim">${esc(s.victimName)}</span></div>` : ''}
            </div>
            <button type="button" class="btn sm ghost track-btn${tracking ? ' tracking' : ''}" ${hasCoords ? '' : 'disabled'}>${tracking ? 'Praćenje' : hasCoords ? 'Prati GPS' : 'Lociranje...'}</button>`;
        row.querySelector('.suspect-info').addEventListener('click', () => openDossierById(s.identifier));
        row.querySelector('.track-btn').addEventListener('click', () => toggleTrack(s));
        box.appendChild(row);
    });
}

function toggleTrack(s) {
    if (State.tracking.has(s.identifier)) {
        State.tracking.delete(s.identifier);
        MDT.removeBlip(s.identifier);
    } else {
        if (!s.coords) return;
        State.tracking.add(s.identifier);
        MDT.trackSuspect({
            identifier: s.identifier,
            coords: s.coords,
            stars: s.stars,
            name: `${s.firstname||''} ${s.lastname||''}`.trim()
        });
    }
    paintSuspects();
}

async function loadEvidencija() {
    const box = document.getElementById('evidencija-list');
    box.innerHTML = '<div class="empty">Učitavanje...</div>';
    const rows = await MDT.getEvidencija();
    const now = new Date();
    const dow = now.getDay() === 0 ? 6 : now.getDay() - 1;
    const weekStart = new Date(now);
    weekStart.setDate(now.getDate() - dow);
    weekStart.setHours(0, 0, 0, 0);
    State.evidencija = (rows || []).filter(e => !e.date || new Date(e.date) >= weekStart)
        .sort((a, b) => new Date(`${b.date||'1970-01-01'}T${b.time||'00:00'}`) - new Date(`${a.date||'1970-01-01'}T${a.time||'00:00'}`));
    paintEvidencija();
}

function paintEvidencija() {
    const box = document.getElementById('evidencija-list');
    let list = State.evidencija;
    if (State.evFilter !== 'all') list = list.filter(e => e.type === State.evFilter);
    if (!list.length) { box.innerHTML = '<div class="empty">Nema zapisa</div>'; return; }
    box.innerHTML = '';
    const typeCls = { warrant: 'ev-warrant', wanted: 'ev-wanted', jail: 'ev-jail', unjail: 'ev-unjail' };
    const typeLbl = { warrant: 'POTJERNICA', wanted: 'TRAŽEN', jail: 'ZATVOR', unjail: 'OSLOBOĐEN', sentence: 'OSUDA' };
    list.forEach(e => {
        const row = document.createElement('div');
        row.className = 'ev-row';
        const parts = [];
        if (e.jailTime) parts.push(`${e.jailTime} min`);
        if (e.stars) parts.push(`${e.stars} ★`);
        if (e.victimName) parts.push(`Ubistvo <span class="victim">${esc(e.victimName)}</span>`);
        else if (e.reason) parts.push(esc(e.reason));
        if (e.officerName) parts.push(`Oficir: ${esc(e.officerName)}`);
        row.innerHTML = `
            <span class="ev-type ${typeCls[e.type]||'ev-warrant'}">${typeLbl[e.type]||esc((e.type||'').toUpperCase())}</span>
            <div class="ev-body"><div class="ev-name">${esc(e.targetName)}${e.steamName ? ` <span class="muted">[${esc(e.steamName)}]</span>` : ''}</div>
            <div class="ev-detail">${parts.join(' · ') || '—'}</div></div>
            <span class="ev-time">${esc(formatEvTime(e))}</span>`;
        if (e.identifier) row.addEventListener('click', () => openDossierById(e.identifier));
        box.appendChild(row);
    });
}

function formatEvTime(e) {
    const t = (e.time || '').substring(0, 5);
    if (!e.date) return t;
    const diff = Date.now() - new Date(`${e.date}T${e.time}`).getTime();
    if (diff <= 86400000) return t;
    const d = new Date(e.date);
    const mo = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return `${String(d.getDate()).padStart(2,'0')}-${mo[d.getMonth()]}-${d.getFullYear()} ${t}`;
}

async function loadOnline() {
    const box = document.getElementById('online-list');
    box.innerHTML = '<div class="empty">Učitavanje...</div>';
    const list = await MDT.getOnlinePlayers();
    if (!list || !list.length) { box.innerHTML = '<div class="empty">Nema igrača</div>'; return; }
    box.innerHTML = '';
    list.forEach(p => {
        const row = document.createElement('div');
        row.className = 'card';
        row.innerHTML = `<div class="card-row"><div class="card-with-avatar"><div class="initials">${esc(initials(p.name,''))}</div><div><div class="card-title">${esc(p.name)}${p.steamName ? ` <span class="muted">[${esc(p.steamName)}]</span>` : ''}</div><div class="card-sub">ID: ${p.id}</div></div></div>${orgTag(p.jobName, p.jobLabel)}</div>`;
        row.addEventListener('click', async () => {
            const pl = await MDT.getPlayerById(p.id);
            if (pl && pl.firstname) { setView('search'); renderDossier(pl, 'search-detail'); }
        });
        box.appendChild(row);
    });
}

async function loadUnits() {
    const box = document.getElementById('units-list');
    box.innerHTML = '<div class="empty">Učitavanje...</div>';
    const list = await MDT.getActivePD();
    if (!list || !list.length) { box.innerHTML = '<div class="empty">Nema službenika na dužnosti</div>'; return; }
    box.innerHTML = '';
    list.forEach(p => {
        const row = document.createElement('div');
        row.className = 'card';
        row.innerHTML = `<div class="card-row"><div class="card-with-avatar"><div class="initials">${esc(initials(p.name,''))}</div><div><div class="card-title">${esc(p.name)}${p.steamName ? ` <span class="muted">[${esc(p.steamName)}]</span>` : ''}</div><div class="card-sub">${esc(p.gradeLabel||'')}</div></div></div>${orgTag(p.jobName, p.jobLabel)}</div>`;
        box.appendChild(row);
    });
}

async function loadChat() {
    const feed = document.getElementById('chat-feed');
    feed.innerHTML = '';
    const msgs = await MDT.getChatHistory();
    (msgs || []).forEach(appendChat);
    const sys = document.createElement('div');
    sys.className = 'chat-sys';
    sys.innerHTML = '<b>SISTEM:</b>Poruke su vidljive isključivo policijskim jedinicama.';
    feed.appendChild(sys);
    feed.scrollTop = feed.scrollHeight;
}

function appendChat(msg) {
    const feed = document.getElementById('chat-feed');
    const div = document.createElement('div');
    const owner = (msg.orgLabel || msg.org) === 'OWNER';
    if (msg.system) {
        div.className = 'chat-sys';
        div.innerHTML = `<b>SYSTEM:</b>${esc(msg.text)}`;
    } else {
        div.className = 'chat-msg';
        div.innerHTML = `
            <div class="chat-head">
                <span class="chat-org${owner ? ' chat-org-owner' : ''}">${esc(msg.orgLabel || msg.org)}${msg.gradeLabel ? ' | ' + esc(msg.gradeLabel) : ''}</span>
                ${owner ? `<span class="chat-steam">${esc(msg.steamName)}</span>` : `<span class="chat-name">${esc(msg.firstname)} ${esc(msg.lastname)}</span><span class="chat-steam">[${esc(msg.steamName)}]</span>`}
                <span class="chat-time">${esc(msg.time||'')}</span>
            </div>
            <div class="chat-text">${esc(msg.text)}</div>`;
    }
    feed.appendChild(div);
    feed.scrollTop = feed.scrollHeight;
}

function pushSuspectAlert(name, stars, victimName, victimSteam, steamName) {
    if (!State.alertsOn) return;
    const stack = document.getElementById('alert-stack');
    stack.innerHTML = '';
    const el = document.createElement('div');
    el.className = 'alert-popup';
    el.innerHTML = `
        <div class="alert-banner">🚨 Novi osumnjičeni — hitno</div>
        <div class="alert-body">
            <div class="card-title">${esc(name)}${steamName ? ` <span class="muted">[${esc(steamName)}]</span>` : ''}</div>
            <div class="stars">${starsHtml(stars)}</div>
            ${victimName ? `<div class="card-sub" style="margin-top:6px">Ubistvo <span class="victim">${esc(victimName)}</span>${victimSteam ? ` [${esc(victimSteam)}]` : ''}</div>` : ''}
        </div>`;
    stack.appendChild(el);
    setTimeout(() => { el.classList.add('out'); el.addEventListener('animationend', () => el.remove()); }, 6000);
}

function handleRecordRemoved(payload) {
    if (!payload || !payload.identifier) return;
    if (payload.source === 'haker') {
        showToast(payload.bulk ? 'Dosije ažuriran — haker obrisao zapise' : 'Zapis uklonjen (haker)');
    }
    State.warrants = [];
    if (State.view === 'warrants') loadWarrants(true);
    if (State.dossier && State.dossier.identifier === payload.identifier) {
        if (payload.bulk || payload.recordType === 'all') refreshDossier(payload.identifier);
        else if (payload.recordType === 'potjernica') refreshDossier(payload.identifier);
        else if (payload.recordType === 'dosje' && State.dossierTab === 'notes') loadNotesList(payload.identifier);
    }
}

window.addEventListener('message', e => {
    const d = e.data;
    if (d.action === 'open') openMdt(d.job);
    if (d.action === 'close') hideMdt();
    if (d.action === 'chatMessage') {
        appendChat(d.message);
        if (State.view !== 'chat') { State.chatUnread = true; syncChatBadge(); }
    }
    if (d.action === 'newBolo') {
        const box = document.getElementById('bolo-list');
        if (State.view === 'bolo' && d.bolo) {
            if (box.querySelector('.empty')) box.innerHTML = '';
            box.insertBefore(buildBoloRow(d.bolo), box.firstChild);
        }
    }
    if (d.action === 'boloDeleted') {
        const w = document.querySelector(`[data-bolo-id="${d.id}"]`);
        if (w) w.remove();
    }
    if (d.action === 'boloResolved') {
        const w = document.querySelector(`[data-bolo-id="${d.id}"]`);
        if (w) { w.remove(); if (State.view === 'bolo') loadBolo(); }
    }
    if (d.action === 'newWarrant' || d.action === 'newEvidencija') {
        if (State.view === 'warrants') loadWarrants(true);
        if (State.view === 'evidencija') loadEvidencija();
        if (State.view === 'dashboard') loadDashboard();
    }
    if (d.action === 'recordRemoved') handleRecordRemoved(d.data || d);
    if (d.action === 'newSuspect') pushSuspectAlert(d.name, d.stars, d.victimName, d.victimSteam, d.steamName);
    if (d.action === 'suspectUpdate') {
        State.suspects[d.identifier] = { ...State.suspects[d.identifier], ...d.data, identifier: d.identifier };
        syncSuspectBadge();
        if (State.view === 'suspects') paintSuspects();
    }
    if (d.action === 'suspectCleared') {
        delete State.suspects[d.identifier];
        State.tracking.delete(d.identifier);
        syncSuspectBadge();
        if (State.view === 'suspects') loadSuspects();
    }
});

document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('sidebar-nav').addEventListener('click', e => {
        const btn = e.target.closest('.nav-item');
        if (btn) setView(btn.dataset.view);
    });
    document.querySelectorAll('[data-goto]').forEach(b => {
        b.addEventListener('click', () => setView(b.dataset.goto));
    });
    document.getElementById('btn-close').addEventListener('click', closeMdt);
    document.getElementById('btn-alerts').addEventListener('click', () => {
        State.alertsOn = !State.alertsOn;
        localStorage.setItem('mdtAlerts', State.alertsOn ? 'on' : 'off');
        syncAlertBtn();
    });
    document.getElementById('input-search').addEventListener('input', () => {
        clearTimeout(searchTimer);
        searchTimer = setTimeout(doSearch, 400);
    });
    document.getElementById('input-plate').addEventListener('input', () => {
        clearTimeout(plateTimer);
        plateTimer = setTimeout(doPlateSearch, 400);
    });
    document.getElementById('btn-warrant-refresh').addEventListener('click', () => loadWarrants(true));
    document.getElementById('btn-warrant-online').addEventListener('click', function() {
        State.warrantOnline = !State.warrantOnline;
        this.classList.toggle('active', State.warrantOnline);
        State.warrantPage = 1;
        paintWarrants();
    });
    document.getElementById('input-warrant-filter').addEventListener('input', function() {
        State.warrantFilter = this.value.trim();
        State.warrantPage = 1;
        paintWarrants();
    });
    document.getElementById('btn-suspects-refresh').addEventListener('click', loadSuspects);
    document.getElementById('btn-online-refresh').addEventListener('click', loadOnline);
    document.getElementById('btn-units-refresh').addEventListener('click', loadUnits);
    document.getElementById('btn-bolo-post').addEventListener('click', async () => {
        const desc = document.getElementById('bolo-desc').value.trim();
        if (!desc) return;
        await MDT.postBolo(document.getElementById('bolo-type').value, desc, document.getElementById('bolo-loc').value.trim());
        document.getElementById('bolo-desc').value = '';
        document.getElementById('bolo-loc').value = '';
    });
    document.getElementById('btn-chat-send').addEventListener('click', sendChat);
    document.getElementById('chat-input').addEventListener('keydown', e => { if (e.key === 'Enter') sendChat(); });
    document.getElementById('ev-filters').addEventListener('click', e => {
        const chip = e.target.closest('.filter-chip');
        if (!chip) return;
        State.evFilter = chip.dataset.filter;
        document.querySelectorAll('#ev-filters .filter-chip').forEach(c => c.classList.toggle('active', c === chip));
        paintEvidencija();
    });
    document.getElementById('btn-warrant-online').classList.add('active');
    tickClock();
    setInterval(tickClock, 30000);
});

document.addEventListener('keydown', e => {
    if (e.key === 'Escape') { e.preventDefault(); closeMdt(); }
});

async function sendChat() {
    const input = document.getElementById('chat-input');
    const text = input.value.trim();
    if (!text) return;
    input.value = '';
    await MDT.sendChatMessage(text);
}
