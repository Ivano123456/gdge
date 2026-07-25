const RES = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'jamaica-glavnimenu';
const GC = () => (state.data && state.data.coinLabel) || 'GC';

function localPlaceholder(kind) {
    const ph = (state.data && state.data.placeholders) || {};
    return ph[kind] || `nui://${RES}/html/img/${kind}.svg`;
}

function vehicleImageSrc(name) {
    let key = String(name || '').replace(/\.png$/i, '').toLowerCase().replace(/\\/g, '/');
    const parts = key.split('/').filter(Boolean);
    key = (parts[parts.length - 1] || key).replace(/^\.+/, '');
    return key ? `img/${key}.png` : '';
}

function renderProductImage(wrap, src, meta) {
    if (!wrap) return null;
    wrap.replaceChildren();
    const img = document.createElement('img');
    img.alt = (meta && meta.alt) || '';
    img.src = src || '';
    if (meta) imgFallback(img, meta);
    wrap.appendChild(img);
    return img;
}

let state = {
    data: null,
    tab: 'boxes',
    cart: [],
    bpPage: { civilni: 1, pro: 1 },
    caseTab: 'premium',
    spinning: false
};

const NAV = [
    { section: 'Opste' },
    { id: 'boxes', label: 'Shop', parent: true, tag: 'NOVO' },
    { id: 'boxes', label: 'Kutije', sub: true },
    { id: 'my-boxes', label: 'Moje kutije', sub: true, stashBadge: true },
    { id: 'shop-gangs', label: 'Gangovi', sub: true, soon: true },
    { id: 'missions', label: 'Misije' },
    { id: 'battlepass', label: 'Battlepass' },
    { id: 'daily', label: 'Dnevne nagrade' },
    { id: 'active', label: 'Aktivna igra' },
    { id: 'promo', label: 'Promo kodovi' },
    { section: 'Extra' },
    { id: 'faq', label: 'Pitanja i odgovori' },
    { id: 'apply', label: 'Prijava', soon: true }
];

const PAGE_META = {
    'boxes': { title: 'Kutije', desc: 'Premium spinovi za GC i Standard spinovi za SC — klikni sliku za nagrade. Otvori kad hoces u Moje kutije.', icon: '📦' },
    'my-boxes': { title: 'Moje kutije', desc: 'Kutije koje si kupio cekaju ovde — otvori ih kad ti odgovara, nije obavezno odmah.', icon: '🎁' },
    'shop-gangs': { title: 'Gangovi', desc: 'Gang paketi i bonusi — uskoro.', icon: '⚔' },
    'missions': { title: 'Misije', desc: 'Zavrsi misije i osvoji SC ili novac.', icon: '🎯' },
    'battlepass': { title: 'Battlepass', desc: 'Civilni i Pro battlepass sa ekskluzivnim nagradama po levelima.', icon: '🏆' },
    'daily': { title: 'Dnevne nagrade', desc: 'Svaki dan preuzmi nagradu — 30 dana ciklusa sa bonus danima!', icon: '📅' },
    'active': { title: 'Aktivna igra', desc: 'Budi aktivan i zaradi SC za Standard kutije.', icon: '⏱' },
    'promo': { title: 'Promo kodovi', desc: 'Unesi promo kod i aktiviraj GC.', icon: '🎟' },
    'faq': { title: 'Pitanja i odgovori', desc: 'Detaljna uputstva za sve panele menija — Shop, misije, nagrade i vise.', icon: '?' },
    'apply': { title: 'Prijava', desc: 'Prijavi se za staff / content creator — uskoro.', icon: '📝' }
};

function ticketUrl() {
    return (state.data && (state.data.ticketDiscord || state.data.shopDiscord)) || 'https://discord.com/channels/1331004435379519509/1354478916680683682';
}

function openDiscord(url) {
    post('openUrl', { url: url || ticketUrl() });
}

function inventoryImage(itemName) {
    if (!itemName) return null;
    const template = (state.data && state.data.imagePath) || 'nui://ox_inventory/web/images/%s.png';
    return template.replace('%s', String(itemName).toLowerCase());
}

function imgFallback(el, meta) {
    if (!el) return;
    const chain = [];
    const seen = new Set();
    const push = (url) => {
        if (!url || seen.has(url)) return;
        seen.add(url);
        chain.push(url);
    };

    const itemName = meta && meta.itemName;
    const gt = (meta && (meta.giveItemType || meta.type)) || '';

    if (itemName && gt !== 'money' && itemName !== 'money' && gt !== 'gold') {
        push(inventoryImage(itemName));
    }
    if (gt === 'money' || itemName === 'money') {
        push(inventoryImage('money'));
        push(localPlaceholder('money'));
    }
    if (gt === 'gold') {
        push(localPlaceholder('coin'));
    }
    if (gt === 'vehicle') {
        if (itemName) {
            const key = vehicleImageSrc(itemName).replace(/^img\//, '').replace(/\.png$/, '');
            if (key) {
                push(`img/${key}.png`);
                push(`nui://${RES}/html/img/${key}.png`);
            }
        }
        push(localPlaceholder('vehicle'));
    }
    if ((gt === 'weapon' || gt === 'item') && itemName) {
        push(inventoryImage(itemName));
    }
    if (gt === 'weapon') {
        push(localPlaceholder('weapon'));
    }
    if (gt === 'package') push(localPlaceholder('package'));
    if (gt === 'case') push(localPlaceholder('case'));
    push(localPlaceholder('default'));

    const filtered = chain.filter(url => url !== el.src);
    let step = 0;
    el.onerror = function() {
        if (step < filtered.length) {
            this.src = filtered[step++];
            this.classList.remove('img-broken');
        } else {
            this.onerror = null;
            this.classList.add('img-broken');
        }
    };
}

function isMoneyCaseItem(item) {
    return item && (item.giveItemType === 'money' || item.itemName === 'money');
}

function isGoldCaseItem(item) {
    return item && item.giveItemType === 'gold';
}

function caseItemCaption(item) {
    if (!item) return '';
    if (isMoneyCaseItem(item)) return item.label || formatMoney(item.itemCount);
    if (isGoldCaseItem(item)) return item.label || `${item.itemCount} ${GC()}`;
    return '';
}

function caseItemDisplayName(item) {
    if (!item) return '';
    if (isMoneyCaseItem(item)) return item.label || formatMoney(item.itemCount);
    if (isGoldCaseItem(item)) return item.label || `${item.itemCount} ${GC()}`;
    return item.label || item.itemName || '';
}

function buildCaseItemVisual(item) {
    const wrap = document.createElement('div');
    wrap.className = 'case-item-visual' + (isMoneyCaseItem(item) ? ' is-money' : '') + (isGoldCaseItem(item) ? ' is-gold' : '');
    const img = document.createElement('img');
    img.src = (item.giveItemType === 'vehicle' && item.itemName ? vehicleImageSrc(item.itemName) : '')
        || (isGoldCaseItem(item) ? localPlaceholder('coin') : '')
        || item.image || '';
    img.alt = item.label || '';
    imgFallback(img, { itemName: item.itemName, giveItemType: item.giveItemType });
    wrap.appendChild(img);
    const caption = caseItemCaption(item);
    if (caption) {
        const cap = document.createElement('div');
        cap.className = 'case-item-caption';
        cap.textContent = caption;
        wrap.appendChild(cap);
    }
    return wrap;
}

function findCaseData(uniqueId, caseType) {
    const list = caseType === 'standard' ? state.data.standardCases : state.data.premiumCases;
    return (list || []).find(c => c.uniqueId === uniqueId);
}

function stashCount() {
    return (state.data && state.data.caseStash && state.data.caseStash.length) || 0;
}

function applyPurchaseResult(r) {
    if (!r || !state.data) return;
    if (r.goldcoin !== undefined) state.data.goldcoin = r.goldcoin;
    if (r.standardcoin !== undefined) state.data.standardcoin = r.standardcoin;
    if (r.caseStash) state.data.caseStash = r.caseStash;
    updateBalanceUI();
    buildNav();
    if (state.tab === 'my-boxes') renderPage();
}

function buildCartItem(spin) {
    return {
        cartType: 'spin',
        type: 'spin',
        id: spin.id,
        label: spin.label,
        price: spin.price,
        priceType: spin.priceType || 'GC'
    };
}

function purchaseSpin(spin, onDone) {
    if (state.spinning) return;
    post('buyCaseItem', { type: 'spin', id: spin.id }).then(r => {
        if (r && r.ok) {
            applyPurchaseResult(r);
            toast('Spin kupljen — pogledaj Moje kutije!');
            if (onDone) onDone(true);
        } else {
            toast((r && r.message) || 'Nemate dovoljno coina!');
            refreshBalance();
            if (onDone) onDone(false);
        }
    });
}

function openStashedCase(entry, onDone) {
    if (state.spinning) return;
    post('consumeStashCase', { stashId: entry.id }).then(r => {
        if (!r || !r.ok) {
            toast((r && r.message) || 'Kutija nije pronadjena.');
            if (r && r.caseStash) state.data.caseStash = r.caseStash;
            buildNav();
            if (state.tab === 'my-boxes') renderPage();
            if (onDone) onDone(false);
            return;
        }
        if (r.caseStash) state.data.caseStash = r.caseStash;
        buildNav();
        const caseData = findCaseData(r.caseUniqueId, r.caseType);
        if (!caseData) {
            toast('Kutija nije pronadjena u sistemu.');
            if (state.tab === 'my-boxes') renderPage();
            if (onDone) onDone(false);
            return;
        }
        openCase({ ...caseData, caseType: r.caseType, skipPayment: true }, ok => {
            refreshBalance();
            if (state.tab === 'my-boxes') renderPage();
            if (onDone) onDone(ok);
        });
    });
}

function post(name, data = {}) {
    return fetch(`https://${RES}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    }).then(r => r.json()).catch(() => ({}));
}

function toast(msg) {
    const el = document.getElementById('toast');
    el.textContent = msg;
    el.classList.remove('hidden');
    clearTimeout(toast._t);
    toast._t = setTimeout(() => el.classList.add('hidden'), 3200);
}

function buildNav() {
    const nav = document.getElementById('nav');
    nav.innerHTML = '';
    NAV.forEach(item => {
        if (item.section) {
            const s = document.createElement('div');
            s.className = 'nav-section';
            s.textContent = item.section;
            nav.appendChild(s);
            return;
        }
        const el = document.createElement('div');
        el.className = item.sub ? 'nav-sub' : 'nav-item';
        if (item.soon) el.style.opacity = '.7';
        const stashTag = item.stashBadge && stashCount() > 0
            ? `<span class="tag tag-new">${stashCount()}</span>`
            : '';
        el.innerHTML = `<span>${item.label}</span>${item.tag ? `<span class="tag tag-new">${item.tag}</span>` : ''}${stashTag}${item.soon ? '<span class="tag tag-soon">USKORO</span>' : ''}`;
        if (!item.soon) {
            el.onclick = () => switchTab(item.id);
        }
        if (state.tab === item.id && !item.parent) el.classList.add('active');
        nav.appendChild(el);
    });
}

function switchTab(tab) {
    state.tab = tab;
    buildNav();
    renderPage();
    const meta = PAGE_META[tab] || PAGE_META['boxes'];
    document.getElementById('pageTitle').textContent = meta.title;
    document.getElementById('pageDesc').textContent = meta.desc;
    document.getElementById('pageIcon').textContent = meta.icon;
    updateBalanceUI();
}

function renderProductCard(item, type) {
    const card = document.createElement('div');
    card.className = 'product-card';
    const imgSrc = item.image || '';
    const isPackage = type === 'package';
    const priceLabel = isPackage ? `${item.coins} ${GC()}` : `${item.price} ${GC()}`;
    card.innerHTML = `
        <div class="badge-row">
            ${item.tag ? `<span class="badge badge-new">${item.tag}</span>` : '<span></span>'}
            ${item.hot ? '<span class="badge badge-hot">HOT</span>' : ''}
        </div>
        <div class="product-img-wrap"></div>
        <div class="product-body">
            <div class="product-title">${item.label}</div>
            <div class="product-price">${priceLabel}</div>
            <div class="product-actions">
                ${type === 'spin' ? '<button class="btn btn-green buy-now">KUPI</button><button class="btn btn-outline add-cart">KORPA</button>' : '<button class="btn btn-green buy-now">KUPI</button>'}
            </div>
            ${isPackage ? '<span class="link-more">Procitaj vise</span>' : ''}
        </div>`;
    const imgWrap = card.querySelector('.product-img-wrap');
    if (imgWrap && (imgSrc || (type === 'spin' && item.itemName))) {
        if (type === 'spin') {
            renderProductImage(imgWrap, vehicleImageSrc(item.itemName) || imgSrc, {
                itemName: item.itemName,
                giveItemType: 'vehicle',
            });
        } else {
            const meta = type === 'package' ? { kind: 'package' } : null;
            renderProductImage(imgWrap, imgSrc, meta);
        }
    }
    if (type === 'spin') {
        card.querySelector('.buy-now').onclick = () => purchaseSpin(item);
        card.querySelector('.add-cart').onclick = () => addToCart(buildCartItem(item));
    } else if (isPackage) {
        card.querySelector('.buy-now').onclick = () => openDiscord(item.directLink || ticketUrl());
    } else {
        card.querySelector('.buy-now').onclick = () => openDiscord(item.directLink || ticketUrl());
    }
    const moreLink = card.querySelector('.link-more');
    if (moreLink) {
        moreLink.onclick = () => openDiscord(item.directLink || ticketUrl());
    }
    return card;
}

function openCaseContentsModal(title, items, price, priceType) {
    const modal = document.getElementById('caseContentsModal');
    const grid = document.getElementById('caseContentsGrid');
    const sub = document.getElementById('caseContentsSub');
    document.getElementById('caseContentsTitle').textContent = title || 'Nagrade u kutiji';
    const currency = priceType === 'SC' ? 'SC' : GC();
    sub.textContent = price ? `Cena: ${price} ${currency} · ${(items || []).length} mogucih nagrada` : `${(items || []).length} mogucih nagrada`;
    grid.innerHTML = '';
    if (!items || !items.length) {
        grid.innerHTML = '<div class="case-contents-empty">Nema definisanih nagrada.</div>';
    } else {
        items.forEach(it => {
            const cell = document.createElement('div');
            cell.className = 'case-contents-item' + (isMoneyCaseItem(it) ? ' is-money' : '');
            const visual = buildCaseItemVisual(it);
            cell.appendChild(visual);
            const name = document.createElement('div');
            name.className = 'case-contents-name';
            name.textContent = caseItemDisplayName(it);
            cell.appendChild(name);
            if (it.itemType) {
                const tier = document.createElement('div');
                tier.className = 'case-contents-tier tier-' + (it.itemType || 'common');
                tier.textContent = it.itemType;
                cell.appendChild(tier);
            }
            grid.appendChild(cell);
        });
    }
    modal.classList.remove('hidden');
}

function appendSpinCard(grid, spin) {
    const caseType = spin.caseType || (state.caseTab === 'standard' ? 'standard' : 'premium');
    const linked = findCaseData(spin.caseUniqueId, caseType);
    const items = linked ? linked.items : [];
    const first = items[0];
    const preview = (linked && linked.coverImage)
        || spin.image
        || (first && first.giveItemType === 'vehicle' ? vehicleImageSrc(first.itemName) : '')
        || (first ? first.image : '');

    const card = document.createElement('div');
    card.className = 'product-card';
    const currency = spin.priceType === 'SC' ? 'SC' : GC();
    const priceLabel = `${spin.price} ${currency}`;
    card.innerHTML = `
        <div class="badge-row">
            ${spin.tag ? `<span class="badge badge-new">${spin.tag}</span>` : (linked && linked.isNew ? '<span class="badge badge-new">NOVO</span>' : '<span></span>')}
            ${spin.hot ? '<span class="badge badge-hot">HOT</span>' : `<span class="badge badge-hot">${currency}</span>`}
        </div>
        <div class="product-img-wrap case-img-clickable" title="Klikni za pregled nagrada"></div>
        <div class="product-body">
            <div class="product-title">${spin.label}</div>
            <div class="product-price">${priceLabel}</div>
            <div class="case-preview-hint">Klikni sliku za sve nagrade</div>
            <div class="product-actions case-actions"></div>
        </div>`;
    const imgWrap = card.querySelector('.product-img-wrap');
    if (imgWrap && preview) {
        renderProductImage(imgWrap, preview, {
            itemName: spin.itemName || (first && first.itemName),
            giveItemType: first && first.giveItemType
        });
    }
    imgWrap.onclick = () => openCaseContentsModal(spin.label, items, spin.price, spin.priceType);
    const actions = card.querySelector('.case-actions');
    actions.innerHTML = '<button class="btn btn-green buy-now">KUPI</button><button class="btn btn-outline add-cart">KORPA</button>';
    actions.querySelector('.buy-now').onclick = () => purchaseSpin(spin);
    actions.querySelector('.add-cart').onclick = () => addToCart(buildCartItem(spin));
    grid.appendChild(card);
}

function addToCart(item) {
    state.cart.push({ ...item, uid: Date.now() + Math.random() });
    document.getElementById('cartCount').textContent = state.cart.length;
    toast(`${item.label} dodat u korpu`);
}

function cartTotals() {
    return state.cart.reduce((t, i) => {
        if ((i.priceType || 'GC') === 'SC') t.sc += Number(i.price) || 0;
        else t.gc += Number(i.price) || 0;
        return t;
    }, { gc: 0, sc: 0 });
}

function renderCartModal() {
    const list = document.getElementById('cartItems');
    const totalEl = document.getElementById('cartTotal');
    list.innerHTML = '';
    if (!state.cart.length) {
        list.innerHTML = '<div style="color:#64748b">Korpa je prazna</div>';
        totalEl.textContent = `Ukupno: 0 ${GC()}`;
        return;
    }
    state.cart.forEach((item, index) => {
        const cur = (item.priceType || 'GC') === 'SC' ? 'SC' : GC();
        const r = document.createElement('div');
        r.className = 'cart-row';
        r.innerHTML = `
            <span>${item.label}</span>
            <span>${item.price} ${cur}</span>
            <div class="cart-row-actions">
                <button class="btn btn-outline btn-sm cart-remove">X</button>
            </div>`;
        r.querySelector('.cart-remove').onclick = () => {
            state.cart.splice(index, 1);
            document.getElementById('cartCount').textContent = state.cart.length;
            renderCartModal();
        };
        list.appendChild(r);
    });
    const totals = cartTotals();
    const parts = [];
    if (totals.gc) parts.push(`${totals.gc} ${GC()}`);
    if (totals.sc) parts.push(`${totals.sc} SC`);
    totalEl.textContent = `Ukupno: ${parts.join(' + ') || '0'} (imate ${state.data.goldcoin} ${GC()}, ${state.data.standardcoin || 0} SC)`;
}

function checkoutCart() {
    if (!state.cart.length) return;
    const totals = cartTotals();
    if (state.data.goldcoin < totals.gc || (state.data.standardcoin || 0) < totals.sc) {
        toast('Nemate dovoljno coina za celu korpu!');
        return;
    }
    const items = state.cart.map(i => ({ type: 'spin', id: i.id }));
    post('buyCasesBatch', { items }).then(r => {
        if (r && r.ok) {
            state.cart = [];
            document.getElementById('cartCount').textContent = '0';
            applyPurchaseResult(r);
            document.getElementById('cartModal').classList.add('hidden');
            toast(`${r.count || 1} kutija kupljeno — pogledaj Moje kutije!`);
        } else {
            toast((r && r.message) || 'Kupovina nije uspela.');
            refreshBalance();
        }
    });
}

function stashPreviewSrc(entry) {
    if (entry.previewModel) return vehicleImageSrc(entry.previewModel);
    const caseData = findCaseData(entry.caseUniqueId, entry.caseType);
    if (!caseData) return '';
    const first = caseData.items && caseData.items[0];
    if (first && first.giveItemType === 'vehicle' && first.itemName) {
        return vehicleImageSrc(first.itemName);
    }
    return caseData.coverImage || (first ? first.image : '');
}

function renderMyBoxes() {
    const wrap = document.createElement('div');
    const stash = state.data.caseStash || [];
    if (!stash.length) {
        wrap.className = 'empty-state panel';
        wrap.innerHTML = `
            <h3>Nemate kupljenih kutija</h3>
            <p style="color:#94a3b8;margin-top:8px;line-height:1.5">Kupite kutije u shopu — cuvaju se ovde dok ih ne otvorite. Mozete kupiti vise odjednom i otvoriti kad god hocete.</p>
            <button class="btn btn-green" style="margin-top:16px" id="goShopBoxes">IDI NA KUTIJE</button>`;
        wrap.querySelector('#goShopBoxes').onclick = () => switchTab('boxes');
        return wrap;
    }

    const header = document.createElement('div');
    header.className = 'panel stash-header';
    header.innerHTML = `
        <h3 class="stash-title">Vase kutije <span class="stash-count-badge">${stash.length}</span></h3>
        <p style="color:#94a3b8;font-size:13px;margin-top:6px">Klikni OTVORI kad budes spreman — nije obavezno odmah nakon kupovine.</p>`;
    wrap.appendChild(header);

    const grid = document.createElement('div');
    grid.className = 'grid-cards';
    stash.forEach(entry => {
        const caseData = findCaseData(entry.caseUniqueId, entry.caseType);
        const items = caseData ? caseData.items : [];
        const preview = stashPreviewSrc(entry);
        const card = document.createElement('div');
        card.className = 'product-card stash-card';
        card.innerHTML = `
            <div class="badge-row"><span></span><span class="badge badge-hot">${entry.caseType === 'standard' ? 'SC' : GC()}</span></div>
            <div class="product-img-wrap case-img-clickable" title="Pregled nagrada"></div>
            <div class="product-body">
                <div class="product-title">${entry.label}</div>
                <div class="product-price stash-ready">Spremno za otvaranje</div>
                <button class="btn btn-purple full open-stash">OTVORI KUTIJU</button>
            </div>`;
        const imgWrap = card.querySelector('.product-img-wrap');
        if (imgWrap && preview) {
            renderProductImage(imgWrap, preview, {
                itemName: entry.previewModel,
                giveItemType: 'vehicle'
            });
        }
        imgWrap.onclick = () => openCaseContentsModal(entry.label, items);
        card.querySelector('.open-stash').onclick = () => openStashedCase(entry);
        grid.appendChild(card);
    });
    wrap.appendChild(grid);
    return wrap;
}

function renderBoxes() {
    const wrap = document.createElement('div');
    const tabs = document.createElement('div');
    tabs.className = 'tabs';
    tabs.innerHTML = `
        <div class="tab ${state.caseTab === 'premium' ? 'active' : ''}" data-tab="premium">Premium spinovi</div>
        <div class="tab ${state.caseTab === 'standard' ? 'active' : ''}" data-tab="standard">Standard spinovi</div>`;
    tabs.querySelectorAll('.tab').forEach(t => {
        t.onclick = () => { state.caseTab = t.dataset.tab; renderPage(); };
    });
    wrap.appendChild(tabs);
    const grid = document.createElement('div');
    grid.className = 'grid-cards';
    const spins = state.caseTab === 'standard'
        ? (state.data.shopStandardSpins || [])
        : (state.data.shopSpins || []);
    if (!spins.length) {
        const empty = document.createElement('div');
        empty.className = 'empty-state panel';
        empty.innerHTML = '<h3>Nema spinova u ovoj kategoriji</h3>';
        wrap.appendChild(empty);
        return wrap;
    }
    spins.forEach(spin => appendSpinCard(grid, spin));
    wrap.appendChild(grid);
    return wrap;
}

function openCase(caseData, onDone) {
    if (state.spinning) return;
    state.spinning = true;

    const ITEM_W = 140;
    const ITEM_GAP = 12;
    const ITEM_STEP = ITEM_W + ITEM_GAP;
    const ROW_PAD = 20;
    const WIN_INDEX = 34;
    const SPIN_MS = 4200;

    const overlay = document.createElement('div');
    overlay.className = 'case-open-overlay';
    overlay.innerHTML = `
        <div class="spinner-track">
            <div class="spinner-pointer" aria-hidden="true"></div>
            <div class="spinner-fade spinner-fade-left"></div>
            <div class="spinner-fade spinner-fade-right"></div>
            <div class="spinner-viewport">
                <div class="spinner-items"></div>
            </div>
        </div>`;
    document.getElementById('app').appendChild(overlay);

    const row = overlay.querySelector('.spinner-items');
    const viewport = overlay.querySelector('.spinner-viewport');

    const caseType = caseData.caseType || (state.caseTab === 'premium' ? 'premium' : 'standard');
    post('openCaseSelect', { uniqueId: caseData.uniqueId, caseType, skipPayment: caseData.skipPayment === true }).then(result => {
        if (!result || result === false) {
            overlay.remove();
            state.spinning = false;
            toast('Nemate dovoljno ' + (caseData.priceType === 'SC' ? 'SC!' : `${GC()}!`));
            refreshBalance();
            if (onDone) onDone(false);
            return;
        }

        const items = caseData.items || [];
        if (!items.length) {
            overlay.remove();
            state.spinning = false;
            toast('Kutija nema nagrada.');
            if (onDone) onDone(false);
            return;
        }

        const pickRandom = () => items[Math.floor(Math.random() * items.length)];
        const display = [];
        for (let i = 0; i < WIN_INDEX; i++) display.push(pickRandom());
        display.push(result);
        for (let i = 0; i < 6; i++) display.push(pickRandom());

        display.forEach((it, idx) => {
            const d = document.createElement('div');
            d.className = 'spinner-item' + (idx === WIN_INDEX ? ' win-target' : '') + (isMoneyCaseItem(it) ? ' is-money' : '') + (isGoldCaseItem(it) ? ' is-gold' : '');
            d.appendChild(buildCaseItemVisual(it));
            row.appendChild(d);
        });

        row.style.transform = 'translateX(0)';

        requestAnimationFrame(() => {
            requestAnimationFrame(() => {
                const viewportW = viewport.clientWidth;
                const winCenter = ROW_PAD + (WIN_INDEX * ITEM_STEP) + (ITEM_W / 2);
                const offset = Math.max(0, winCenter - (viewportW / 2));
                row.style.transform = `translateX(-${offset}px)`;

                const winEl = row.children[WIN_INDEX];
                if (winEl) {
                    setTimeout(() => winEl.classList.add('win'), SPIN_MS - 120);
                }
            });
        });

        setTimeout(() => {
            overlay.remove();
            state.spinning = false;
            showCaseResult(result);
            refreshBalance();
            if (onDone) onDone(true);
        }, SPIN_MS + 200);
    });
}

let caseResultBusy = false;

function isCaseResultOpen() {
    const modal = document.getElementById('caseModal');
    return modal && !modal.classList.contains('hidden');
}

function collectCaseReward(silent) {
    if (caseResultBusy || !isCaseResultOpen()) return Promise.resolve(false);
    caseResultBusy = true;
    document.getElementById('caseModal').classList.add('hidden');
    return post('collectCaseItem').then(r => {
        caseResultBusy = false;
        if (r && r.ok) {
            if (!silent) toast('Predmet prikupljen! Vozilo ide u garazu.');
            refreshBalance();
            return true;
        }
        if (!silent) toast('Greska');
        return false;
    }).catch(() => {
        caseResultBusy = false;
        return false;
    });
}

function sellCaseReward() {
    if (caseResultBusy || !isCaseResultOpen()) return Promise.resolve(false);
    caseResultBusy = true;
    document.getElementById('caseModal').classList.add('hidden');
    return post('sellCaseItem').then(ok => {
        caseResultBusy = false;
        toast(ok ? 'Prodato za coine!' : 'Greska');
        refreshBalance();
        return !!ok;
    }).catch(() => {
        caseResultBusy = false;
        return false;
    });
}

function showCaseResult(item) {
    const media = document.getElementById('caseResultMedia');
    media.innerHTML = '';
    media.className = 'case-result-media' + (isMoneyCaseItem(item) ? ' is-money' : '') + (isGoldCaseItem(item) ? ' is-gold' : '');
    media.appendChild(buildCaseItemVisual(item));
    document.getElementById('caseResultLabel').textContent = (isMoneyCaseItem(item) || isGoldCaseItem(item)) ? '' : (item.label || '');
    document.getElementById('caseResultType').textContent = item.itemType || '';
    caseResultBusy = false;
    document.getElementById('caseModal').classList.remove('hidden');
    document.getElementById('btnCollect').onclick = () => { collectCaseReward(); };
    document.getElementById('btnSell').onclick = () => { sellCaseReward(); };
}

function renderBattlepass() {
    const bp = state.data.battlepass;
    if (!bp) return document.createElement('div');
    const wrap = document.createElement('div');
    wrap.className = 'bp-layout';
    const pct = Math.min(100, Math.round((bp.currentXP / bp.maxXP) * 100));
    const proPct = bp.hasPro ? Math.min(100, Math.round((bp.proXP / bp.proMaxXP) * 100)) : 0;
    wrap.innerHTML = `
        <div class="bp-sidebar panel">
            <div class="bp-stat"><div class="val">${bp.currentXP}/${bp.maxXP}</div><div class="lbl">CIVILNI XP</div></div>
            <div class="level-ring" style="--pct:${pct}%"><span>${bp.playerLevel}</span></div>
            <div class="bp-stat"><div class="lbl">DO SLJEDECEG LEVELA</div><div class="val" style="font-size:16px">${bp.timeRemaining} min</div></div>
            <hr style="border-color:rgba(51,65,85,.5);margin:8px 0">
            <div class="bp-stat"><div class="val">${bp.hasPro ? bp.proXP + '/' + bp.proMaxXP : '—'}</div><div class="lbl">PRO XP</div></div>
            <div class="level-ring" style="--pct:${proPct}%"><span>${bp.proLevel}</span></div>
            <button class="btn btn-gold full" id="buyProBtn">${bp.hasPro ? 'PRO AKTIVAN' : 'KUPI PRO'}</button>
        </div>
        <div class="bp-tracks"></div>`;
    wrap.querySelector('#buyProBtn').onclick = () => openDiscord(ticketUrl());
    const tracks = wrap.querySelector('.bp-tracks');
    tracks.appendChild(buildBpTrack('CIVILNI BATTLEPASS', 'civilni', bp.civilniRewards, bp.claimedRewards, bp.playerLevel, false));
    tracks.appendChild(buildBpTrack('BATTLEPASS PRO', 'pro', bp.premiumRewards, bp.premiumClaimedRewards, bp.proLevel, !bp.hasPro));
    return wrap;
}

function getBpReward(rewards, level) {
    if (!rewards) return null;
    if (Array.isArray(rewards)) return rewards[level - 1] || null;
    return rewards[level] || rewards[String(level)] || null;
}

function getBpMaxPage(rewards) {
    if (!rewards) return 1;
    const count = Array.isArray(rewards)
        ? rewards.filter(Boolean).length
        : Object.keys(rewards).length;
    return Math.max(1, Math.ceil(count / 5));
}

function buildBpTrack(title, type, rewards, claimed, level, locked) {
    const sec = document.createElement('div');
    sec.className = 'panel';
    const maxPage = getBpMaxPage(rewards);
    const page = Math.min(state.bpPage[type] || 1, maxPage);
    state.bpPage[type] = page;
    const start = (page - 1) * 5;
    sec.innerHTML = `<div class="bp-track-header"><div class="bp-track-title">${title}</div>
        <div><button class="btn btn-outline bp-prev" data-t="${type}">◀</button>
        <button class="btn btn-outline bp-next" data-t="${type}">▶</button></div></div>`;
    const cards = document.createElement('div');
    cards.className = 'bp-cards';
    for (let i = 1; i <= 5; i++) {
        const lvl = start + i;
        const r = getBpReward(rewards, lvl);
        if (!r) continue;
        const isClaimed = claimed.includes(lvl);
        const canClaim = !locked && level >= lvl && !isClaimed;
        const card = document.createElement('div');
        card.className = 'bp-card' + (canClaim ? ' claimable' : ' locked');
        card.innerHTML = `
            <div class="lvl">LEVEL ${lvl}</div>
            ${r.image ? `<img src="${r.image}" alt="">` : '<div class="bp-img-ph"></div>'}
            <div class="name">${r.label}</div>
            <button class="claim ${isClaimed ? 'claim-done' : canClaim ? 'claim-ready' : 'claim-wait'}">
                ${isClaimed ? 'PREUZETO' : canClaim ? 'PREUZMI' : locked ? 'NEMATE PRO' : 'NA CEKANJU'}
            </button>`;
        const bpImg = card.querySelector('img');
        if (bpImg) imgFallback(bpImg, { itemName: r.rewardName, giveItemType: r.rewardType });
        if (canClaim) {
            card.querySelector('.claim').onclick = () => {
                post('claimBpReward', { type, level: lvl });
            };
        }
        cards.appendChild(card);
    }
    const cardCount = cards.children.length;
    if (cardCount > 0) {
        cards.style.gridTemplateColumns = `repeat(${cardCount}, minmax(0, 1fr))`;
    }
    sec.appendChild(cards);
    sec.querySelector('.bp-prev').onclick = () => { if (state.bpPage[type] > 1) { state.bpPage[type]--; renderPage(); } };
    sec.querySelector('.bp-next').onclick = () => { if (state.bpPage[type] < maxPage) { state.bpPage[type]++; renderPage(); } };
    return sec;
}

function renderDaily() {
    const d = state.data.daily;
    const wrap = document.createElement('div');
    if (!d) {
        wrap.className = 'panel';
        wrap.innerHTML = '<div class="empty-state"><h3>Ucitavanje...</h3></div>';
        return wrap;
    }

    wrap.className = 'daily-layout';

    const header = document.createElement('div');
    header.className = 'panel daily-header';
    header.innerHTML = `
        <div class="daily-header-top">
            <div>
                <h3 class="daily-title">Dnevni streak</h3>
                <p class="daily-sub">Dan <strong>${d.nextDay || 1}</strong> / 30 — svako polje pokazuje nagradu za taj dan.</p>
            </div>
            <div class="daily-streak-badge">${d.streak}<span>/30</span></div>
        </div>
        <div class="daily-streak-track" id="dailyStreakTrack"></div>
        <button class="btn btn-gold full" id="claimDailyBtn" ${d.canClaim ? '' : 'disabled'}>${d.canClaim ? 'PREUZMI DANASNJU NAGRADU' : 'Danas vec preuzeto'}</button>`;
    wrap.appendChild(header);

    const track = header.querySelector('#dailyStreakTrack');
    (d.days || []).forEach(day => {
        const dot = document.createElement('div');
        const reward = day.reward || {};
        dot.className = 'daily-streak-dot'
            + (day.claimed ? ' claimed' : '')
            + (day.current ? ' current' : '')
            + (day.bonus ? ' bonus' : '');
        const tip = reward.label || reward.amountLabel || '';
        dot.title = `Dan ${day.day}` + (tip ? ` — ${tip}` : '') + (day.bonus ? ' (bonus)' : '');
        dot.innerHTML = `
            <span class="daily-dot-day">${day.day}</span>
            <div class="daily-dot-media">
                <img src="${reward.image || ''}" alt="">
            </div>
            <span class="daily-dot-amount">${reward.amountLabel || reward.label || ''}</span>`;
        const img = dot.querySelector('img');
        if (img) {
            imgFallback(img, {
                itemName: reward.item,
                giveItemType: reward.type === 'item' ? 'item' : reward.type,
                type: reward.type,
            });
        }
        track.appendChild(dot);
    });

    const btn = header.querySelector('#claimDailyBtn');
    if (d.canClaim) {
        btn.onclick = () => {
            post('claimDaily').then(r => {
                if (r.ok) {
                    state.data.daily = r.payload.state;
                    const reward = r.payload.reward || {};
                    toast('Preuzeto: ' + (reward.amountLabel || reward.label || 'nagrada'));
                    refreshBalance();
                    renderPage();
                } else toast('Vec si preuzeo danas.');
            });
        };
    }
    return wrap;
}

function buildDailyRewardCard(entry, isBonus) {
    const card = document.createElement('div');
    card.className = 'daily-reward-card' + (isBonus ? ' bonus' : '');
    const meta = {
        itemName: entry.item,
        giveItemType: entry.type === 'item' ? 'item' : entry.type,
        type: entry.type,
    };
    card.innerHTML = `
        ${isBonus ? '<div class="daily-reward-day"></div>' : ''}
        <div class="daily-reward-media">
            <img src="${entry.image || ''}" alt="">
        </div>
        <div class="daily-reward-amount">${entry.amountLabel || entry.label || ''}</div>
        <div class="daily-reward-name">${entry.label || ''}</div>`;
    const img = card.querySelector('img');
    if (img) imgFallback(img, meta);
    return card;
}

function missionRewardLabel(reward) {
    if (!reward) return '';
    const amount = reward.amount || 0;
    if (reward.type === 'money') return `${Number(amount).toLocaleString('sr-RS')}$`;
    if (reward.type === 'sc' || reward.type === 'silver') return `${amount} SC`;
    return `${amount} ${GC()}`;
}

function renderMissions() {
    const wrap = document.createElement('div');
    wrap.className = 'panel';
    (state.data.missions || []).forEach(m => {
        const el = document.createElement('div');
        el.className = 'mission-item';
        const prog = m.completed ? 'Zavrseno' : `Napredak: ${m.progress || 0}/${m.target || 1}`;
        const progColor = m.completed ? '#4ade80' : '#94a3b8';
        el.innerHTML = `<h4>${m.label}</h4><p>${m.desc}</p><p style="margin-top:6px;color:#fbbf24;font-size:12px">Nagrada: ${missionRewardLabel(m.reward)}</p><p style="margin-top:4px;color:${progColor};font-size:12px">${prog}</p>`;
        wrap.appendChild(el);
    });
    return wrap;
}

function renderPromo() {
    const wrap = document.createElement('div');
    wrap.className = 'panel promo-box';
    wrap.innerHTML = `
        <h3>Promo kod</h3>
        <p style="color:#94a3b8;font-size:13px;margin-top:6px">Unesi kod sa Discorda ili od administracije.</p>
        <input type="text" id="promoInput" placeholder="Unesi kod..." maxlength="32">
        <button class="btn btn-green full" id="promoBtn">AKTIVIRAJ</button>`;
    wrap.querySelector('#promoBtn').onclick = () => {
        const code = wrap.querySelector('#promoInput').value.trim();
        post('redeemCode', { code }).then(r => {
            if (r.ok) { toast(`+${r.amount} ${GC()}!`); refreshBalance(); }
            else toast('Neispravan kod.');
        });
    };
    return wrap;
}

const FAQ_CATS = [
    { id: 'najnovije', label: 'Najnovije', icon: '🔥' },
    { id: 'sve', label: 'Sve', icon: '☰' },
    { id: 'misije', label: 'Misije', icon: '🏆' },
    { id: 'nagrade', label: 'Nagrade', icon: '📅' },
    { id: 'igra', label: 'Igra', icon: '🎮' },
];

const FAQ_CAT_META = {
    misije: { label: 'Misije', icon: '🏆' },
    nagrade: { label: 'Nagrade', icon: '📅' },
    igra: { label: 'Igra', icon: '🎮' },
};

function filterFaqItems(cat) {
    const items = state.data.faq || [];
    if (cat === 'najnovije') return items.filter(f => f.latest);
    if (cat === 'sve') return items;
    return items.filter(f => f.cat === cat);
}

function renderFaqList(container, cat, openIdx) {
    const items = filterFaqItems(cat);
    const catInfo = FAQ_CATS.find(c => c.id === cat) || FAQ_CATS[1];
    container.querySelector('.faq-list-title').textContent = catInfo.label.toUpperCase();
    container.querySelector('.faq-list-count').textContent = items.length === 1 ? '1 pitanje' : `${items.length} pitanja`;

    const list = container.querySelector('.faq-accordion');
    list.innerHTML = '';
    if (!items.length) {
        list.innerHTML = '<div class="faq-empty">Nema pitanja u ovoj kategoriji.</div>';
        return;
    }

    items.forEach((f, i) => {
        const row = document.createElement('div');
        row.className = 'faq-row' + (openIdx === i ? ' open' : '');
        const meta = FAQ_CAT_META[f.cat] || { label: 'Opšte', icon: '❓' };
        row.innerHTML = `
            <div class="faq-row-head">
                <span class="faq-row-num">${i + 1}</span>
                <span class="faq-row-q">${f.q}</span>
                <span class="faq-row-tag"><span class="faq-row-tag-ico">${meta.icon}</span>${meta.label}</span>
                <button type="button" class="faq-row-toggle" aria-label="Otvori odgovor">▼</button>
            </div>
            <div class="faq-row-body"><p>${f.a}</p></div>`;
        const toggle = () => {
            const wasOpen = row.classList.contains('open');
            list.querySelectorAll('.faq-row.open').forEach(r => r.classList.remove('open'));
            if (!wasOpen) row.classList.add('open');
        };
        row.querySelector('.faq-row-head').onclick = toggle;
        row.querySelector('.faq-row-toggle').onclick = (e) => { e.stopPropagation(); toggle(); };
        list.appendChild(row);
    });
}

function renderFaq() {
    if (!state.faqCat) state.faqCat = 'sve';
    if (state.faqOpen === undefined) state.faqOpen = null;

    const wrap = document.createElement('div');
    wrap.className = 'faq-layout';

    const sidebar = document.createElement('aside');
    sidebar.className = 'faq-cats panel';
    sidebar.innerHTML = `
        <div class="faq-cats-head"><span class="faq-cats-ico">📋</span> KATEGORIJE</div>
        <nav class="faq-cats-nav" id="faqCatNav"></nav>
        <p class="faq-cats-note">Sva pitanja i odgovori će biti dodani ovdje. Posjećuj ovaj panel redovno za nove informacije i ažuriranja!</p>`;

    const nav = sidebar.querySelector('#faqCatNav');
    FAQ_CATS.forEach(c => {
        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'faq-cat-btn' + (state.faqCat === c.id ? ' active' : '');
        btn.innerHTML = `<span class="faq-cat-ico">${c.icon}</span><span>${c.label}</span>${c.id === 'sve' && state.faqCat === 'sve' ? '<span class="faq-cat-dot"></span>' : ''}`;
        btn.onclick = () => {
            state.faqCat = c.id;
            state.faqOpen = null;
            renderFaqRefresh(wrap);
        };
        nav.appendChild(btn);
    });

    const main = document.createElement('div');
    main.className = 'faq-main';
    main.innerHTML = `
        <div class="faq-list-panel panel">
            <div class="faq-list-head">
                <div class="faq-list-head-left">
                    <span class="faq-list-qmarks">???</span>
                    <span class="faq-list-title">SVE</span>
                </div>
                <span class="faq-list-count">0 pitanja</span>
            </div>
            <div class="faq-accordion"></div>
        </div>
        <div class="faq-support panel">
            <div class="faq-support-ico">💬</div>
            <div class="faq-support-text">
                <strong>Niste pronašli odgovor?</strong>
                <span>Kontaktirajte nas i pomoći ćemo vam s vašim pitanjima.</span>
            </div>
            <button type="button" class="btn btn-blue faq-support-btn" id="faqSupportBtn">💬 Kontaktiraj podršku</button>
        </div>`;

    main.querySelector('#faqSupportBtn').onclick = () => openDiscord(ticketUrl());

    wrap.appendChild(sidebar);
    wrap.appendChild(main);
    renderFaqList(main, state.faqCat, state.faqOpen);
    return wrap;
}

function renderFaqRefresh(root) {
    const main = root.querySelector('.faq-main');
    const nav = root.querySelector('#faqCatNav');
    if (!main || !nav) return;

    nav.querySelectorAll('.faq-cat-btn').forEach((btn, i) => {
        const c = FAQ_CATS[i];
        btn.classList.toggle('active', state.faqCat === c.id);
        const dot = btn.querySelector('.faq-cat-dot');
        if (dot) dot.remove();
        if (c.id === 'sve' && state.faqCat === 'sve') {
            btn.insertAdjacentHTML('beforeend', '<span class="faq-cat-dot"></span>');
        }
    });
    renderFaqList(main, state.faqCat, state.faqOpen);
}

function renderActive() {
    const wrap = document.createElement('div');
    wrap.className = 'panel';
    wrap.innerHTML = `
        <h3>Aktivna igra</h3>
        <p style="color:#94a3b8;margin:12px 0;line-height:1.5">Dok si online, automatski dobijas <strong style="color:#94a3b8">3 SC</strong> svakih 60 minuta (samo za Standard kutije).</p>
        <p style="color:#94a3b8;line-height:1.5">Battlepass XP: <strong style="color:#60a5fa">+${state.data.battlepass ? '10' : '?'}</strong> svakih 10 minuta za sve online igrace.</p>
        <div style="margin-top:20px;padding:16px;border-radius:12px;background:rgba(30,41,59,.7);border:1px solid rgba(51,65,85,.4)">
            <div style="font-size:13px;color:#94a3b8">Trenutno stanje</div>
            <div style="font-size:22px;font-weight:800;color:#fbbf24;margin-top:4px">${state.data.goldcoin} ${GC()}</div>
            <div style="font-size:14px;color:#94a3b8;margin-top:6px">${state.data.standardcoin || 0} SC (Standard kutije)</div>
        </div>`;
    return wrap;
}

function renderPlaceholder(title) {
    const d = document.createElement('div');
    d.className = 'empty-state panel';
    d.innerHTML = `<h3>${title}</h3><p>Ova sekcija stize uskoro. Prati Discord za obavijesti.</p>`;
    return d;
}

function formatMoney(n) {
    const num = Number(n);
    if (!num || Number.isNaN(num)) return '';
    return num.toLocaleString('sr-RS') + '$';
}

function renderPage() {
    const c = document.getElementById('content');
    c.innerHTML = '';
    const map = {
        'shop-spins': renderBoxes,
        'boxes': renderBoxes,
        'my-boxes': renderMyBoxes,
        'shop-gangs': () => renderPlaceholder('Gang paketi'),
        'missions': renderMissions,
        'battlepass': renderBattlepass,
        'daily': renderDaily,
        'active': renderActive,
        'promo': renderPromo,
        'faq': renderFaq,
        'apply': () => renderPlaceholder('Prijava')
    };
    const fn = map[state.tab] || renderBoxes;
    c.appendChild(fn());
}

function refreshBalance() {
    post('refreshData').then(data => {
        if (!data || data.goldcoin === undefined) return;
        state.data.goldcoin = data.goldcoin;
        state.data.standardcoin = data.standardcoin;
        if (data.battlepass) state.data.battlepass = data.battlepass;
        if (data.caseStash) state.data.caseStash = data.caseStash;
        updateBalanceUI();
        buildNav();
    });
}

function updateBalanceUI() {
    document.getElementById('goldBalance').textContent = state.data.goldcoin;
    const scEl = document.getElementById('standardBalance');
    if (scEl) scEl.textContent = state.data.standardcoin || 0;
    const bp = state.data.battlepass;
    if (bp) {
        const pct = Math.min(100, Math.round((bp.currentXP / bp.maxXP) * 100));
        document.getElementById('xpFill').style.width = pct + '%';
        document.getElementById('xpText').textContent = `${bp.currentXP} / ${bp.maxXP} XP · Lv ${bp.playerLevel}`;
    }
}

function setProfileUI(player) {
    const name = (player && player.name) || 'Igrac';
    document.getElementById('profileName').textContent = name;
    const avatarEl = document.getElementById('profileAvatar');
    avatarEl.referrerPolicy = 'no-referrer';
    avatarEl.crossOrigin = 'anonymous';
    avatarEl.onerror = function() {
        this.onerror = null;
        this.src = 'https://cdn.discordapp.com/embed/avatars/0.png';
    };
    avatarEl.src = (player && player.avatar) || 'https://cdn.discordapp.com/embed/avatars/0.png';
}

function openHub(payload) {
    state.data = payload.data;
    state.cart = [];
    document.getElementById('cartCount').textContent = '0';
    setProfileUI(payload.data.player);
    updateBalanceUI();
    buildNav();
    switchTab(payload.tab || 'boxes');
    document.getElementById('app').classList.remove('hidden');
}

async function closeHub() {
    // ESC / zatvaranje dok je PRIKUPI/PRODAJ otvoren = auto PRIKUPI (da ne izgube nagradu)
    if (isCaseResultOpen()) {
        await collectCaseReward(true);
    }
    document.getElementById('app').classList.add('hidden');
    document.getElementById('caseModal').classList.add('hidden');
    document.getElementById('caseContentsModal').classList.add('hidden');
    post('close');
}

document.getElementById('btnBuyCredits').onclick = () => openDiscord(ticketUrl());
document.getElementById('btnCart').onclick = () => {
    renderCartModal();
    document.getElementById('cartModal').classList.remove('hidden');
};
document.getElementById('btnCheckout').onclick = () => checkoutCart();
document.getElementById('btnCloseCart').onclick = () => document.getElementById('cartModal').classList.add('hidden');
document.getElementById('btnCloseCaseContents').onclick = () => document.getElementById('caseContentsModal').classList.add('hidden');
document.getElementById('caseContentsModal').addEventListener('click', e => {
    if (e.target.id === 'caseContentsModal') document.getElementById('caseContentsModal').classList.add('hidden');
});

document.addEventListener('keydown', e => {
    if (e.key === 'Escape') {
        const caseContentsModal = document.getElementById('caseContentsModal');
        if (!caseContentsModal.classList.contains('hidden')) {
            caseContentsModal.classList.add('hidden');
            return;
        }
        // PRIKUPI/PRODAJ modal: ESC = auto prikupi pa zatvori hub
        closeHub();
    }
});

window.addEventListener('message', e => {
    const msg = e.data;
    if (msg.action === 'open') openHub(msg);
    if (msg.action === 'switchTab') switchTab(msg.tab || 'boxes');
    if (msg.action === 'close') document.getElementById('app').classList.add('hidden');
    if (msg.action === 'updateBattlepass' && state.data) {
        state.data.battlepass = msg.battlepass;
        if (state.tab === 'battlepass') renderPage();
        updateBalanceUI();
    }
    if (msg.action === 'updateBalance' && state.data) {
        state.data.goldcoin = msg.goldcoin;
        state.data.standardcoin = msg.standardcoin;
        updateBalanceUI();
    }
    if (msg.action === 'bigWin' && msg.info) {
        toast(`${msg.info.name} je osvojio ${msg.info.label}!`);
    }
    if (msg.action === 'openUrl' && msg.url) {
        window.invokeNative?.('openUrl', msg.url);
    }
});
