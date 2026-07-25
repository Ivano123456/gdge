const state = {
    open: false,
    items: [],
    itemMap: new Map(),
    cash: 0,
    bank: 0,
    selectedId: null,
    quantity: 1,
    payment: 'cash',
};

const els = {};

function $(id) {
    return els[id] || (els[id] = document.getElementById(id));
}

function resourceName() {
    try { return GetParentResourceName(); } catch { return 'jamaica-apoteka'; }
}

function nuiPost(endpoint, data) {
    return fetch(`https://${resourceName()}/${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data ?? {}),
    }).then(r => r.json()).catch(() => null);
}

function formatMoney(n) {
    return '$' + Number(n || 0).toLocaleString('sr-RS');
}

function itemImage(item) {
    return `nui://ox_inventory/web/images/${item}.png`;
}

function getItem(id) {
    return state.itemMap.get(id) || null;
}

function updateHeader() {
    $('cashDisplay').textContent = formatMoney(state.cash);
    $('bankDisplay').textContent = formatMoney(state.bank);
    $('itemCount').textContent = `${state.items.length} artikala`;
}

function setImageFallback(parent, icon) {
    parent.innerHTML = `<div class="box-icon-fallback"><i class="fa-solid ${icon || 'fa-capsules'}"></i></div>`;
}

function renderGrid() {
    const grid = $('itemGrid');
    const list = state.items;

    if (!list.length) {
        grid.innerHTML = '<div class="grid-empty">Nema artikala</div>';
        return;
    }

    grid.innerHTML = list.map(item => `
        <div class="box" data-id="${item.id}">
            <div class="box-visual">
                <span class="box-tag-float">${item.tag || 'Artikal'}</span>
                <img class="box-img" src="${itemImage(item.item)}" alt="${item.label}"
                    data-icon="${item.icon || 'fa-capsules'}">
            </div>
            <div class="box-body">
                <div class="box-name">${item.label}</div>
                <div class="box-desc">${item.description || ''}</div>
                <div class="box-footer">
                    <div class="box-price">${formatMoney(item.price)}</div>
                    <div class="box-buy-hint"><i class="fa-solid fa-hand-pointer"></i> Kupi</div>
                </div>
            </div>
        </div>
    `).join('');

    grid.querySelectorAll('.box-img').forEach(img => {
        img.addEventListener('error', () => setImageFallback(img.parentElement, img.dataset.icon), { once: true });
    });
}

function renderStats(stats) {
    const el = $('modalStats');
    const entries = Object.entries(stats || {});
    el.innerHTML = entries.length
        ? entries.map(([k, v]) => `<span class="stat-pill">${k}: ${v}</span>`).join('')
        : '';
}

function openModal(id) {
    const item = getItem(id);
    if (!item) return;

    state.selectedId = id;
    state.quantity = 1;
    state.payment = 'cash';

    document.querySelectorAll('.pay-opt').forEach(b => {
        b.classList.toggle('active', b.dataset.pay === 'cash');
    });

    const wrap = $('modalImgWrap');
    wrap.innerHTML = `<img id="modalImage" src="${itemImage(item.item)}" alt="${item.label}">`;
    const img = wrap.querySelector('img');
    if (img) {
        img.addEventListener('error', () => {
            wrap.innerHTML = `<div class="box-icon-fallback modal-icon-fallback"><i class="fa-solid ${item.icon || 'fa-capsules'}"></i></div>`;
        }, { once: true });
    }

    $('modalName').textContent = item.label;
    $('modalDesc').textContent = item.description || '';
    $('modalPrice').textContent = formatMoney(item.price);
    renderStats(item.stats);

    const maxQty = item.maxQty || 1;
    $('qtyRow').classList.toggle('hidden', maxQty <= 1);
    $('qtyHint').textContent = maxQty > 1 ? `Max ${maxQty}` : '';
    updateModalQty();
    $('buyBtn').disabled = false;
    $('buyModal').classList.remove('hidden');
}

function closeModal() {
    $('buyModal').classList.add('hidden');
    state.selectedId = null;
}

function updateModalQty() {
    const item = getItem(state.selectedId);
    if (!item) return;

    const maxQty = item.maxQty || 1;
    state.quantity = Math.max(1, Math.min(maxQty, state.quantity));

    $('qtyValue').textContent = state.quantity;
    $('qtyMinus').disabled = state.quantity <= 1;
    $('qtyPlus').disabled = state.quantity >= maxQty;
    $('modalPrice').textContent = formatMoney(item.price * state.quantity);
}

async function purchase() {
    const item = getItem(state.selectedId);
    if (!item) return;

    const btn = $('buyBtn');
    btn.disabled = true;

    const result = await nuiPost('purchase', {
        itemId: item.id,
        quantity: state.quantity,
        payment: state.payment,
    });

    if (result?.ok) {
        if (result.cash !== undefined) state.cash = result.cash;
        if (result.bank !== undefined) state.bank = result.bank;
        updateHeader();
        closeModal();
    } else {
        btn.disabled = false;
    }
}

function openShop(data) {
    state.open = true;
    state.items = data.items || [];
    state.itemMap = new Map(state.items.map(i => [i.id, i]));
    state.cash = data.cash || 0;
    state.bank = data.bank || 0;
    state.quantity = 1;
    state.payment = 'cash';

    $('shopTitle').textContent = data.shopLabel || 'Apoteka Jamaica';
    updateHeader();
    renderGrid();
    $('shopWindow').classList.remove('hidden');
}

function closeShop() {
    if (!state.open) return;
    closeModal();
    state.open = false;
    $('shopWindow').classList.add('hidden');
    nuiPost('close');
}

$('buyBtn').addEventListener('click', purchase);
$('modalClose').addEventListener('click', closeModal);
$('itemGrid').addEventListener('click', (e) => {
    const box = e.target.closest('.box');
    if (box) openModal(box.dataset.id);
});

$('qtyMinus').addEventListener('click', () => {
    state.quantity--;
    updateModalQty();
});

$('qtyPlus').addEventListener('click', () => {
    state.quantity++;
    updateModalQty();
});

document.querySelectorAll('.pay-opt').forEach(btn => {
    btn.addEventListener('click', () => {
        state.payment = btn.dataset.pay;
        document.querySelectorAll('.pay-opt').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
    });
});

$('buyModal').addEventListener('click', (e) => {
    if (e.target.id === 'buyModal') closeModal();
});

document.addEventListener('keydown', (e) => {
    if (!state.open || e.key !== 'Escape') return;
    if ($('buyModal').classList.contains('hidden')) closeShop();
    else closeModal();
});

window.addEventListener('message', (event) => {
    const data = event.data;
    if (!data?.action) return;

    if (data.action === 'open') openShop(data);
    else if (data.action === 'close') closeShop();
});
