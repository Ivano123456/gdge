const state = {
    open: false,
    items: [],
    categories: [],
    hasLicense: false,
    cash: 0,
    bank: 0,
    currentCategory: 'all',
    selectedId: null,
    quantity: 1,
    payment: 'cash',
};

function resourceName() {
    try { return GetParentResourceName(); } catch { return 'jamaica-oruzarnice'; }
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

function fallbackImage(label) {
    return `data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='80' height='80'%3E%3Crect fill='%231e293b' width='80' height='80'/%3E%3C/svg%3E`;
}

function getItem(id) {
    return state.items.find(i => i.id === id) || null;
}

function getFiltered() {
    const list = state.items;
    return list.filter(i => state.currentCategory === 'all' || i.category === state.currentCategory);
}

function showToast(msg, type) {
    let el = document.getElementById('toast');
    if (!el) {
        el = document.createElement('div');
        el.id = 'toast';
        el.className = 'toast';
        document.body.appendChild(el);
    }
    el.textContent = msg;
    el.className = `toast ${type || 'success'} show`;
    setTimeout(() => el.classList.remove('show'), 3000);
}

function updateHeader() {
    const lic = document.getElementById('licenseText');
    lic.textContent = state.hasLicense ? 'Dozvola verifikovana' : 'Nema dozvole za oružje';
    lic.className = state.hasLicense ? 'ok' : 'bad';
    document.getElementById('cashDisplay').textContent = formatMoney(state.cash);
    document.getElementById('bankDisplay').textContent = formatMoney(state.bank);
}

function renderTabs() {
    const el = document.getElementById('categoryTabs');
    el.innerHTML = state.categories.map(cat => `
        <button type="button" class="tab ${cat.id === state.currentCategory ? 'active' : ''}" data-cat="${cat.id}">
            ${cat.name}
        </button>
    `).join('');

    el.querySelectorAll('.tab').forEach(btn => {
        btn.addEventListener('click', () => {
            state.currentCategory = btn.dataset.cat;
            renderTabs();
            renderGrid();
        });
    });
}

function renderGrid() {
    const el = document.getElementById('itemGrid');
    const list = getFiltered();

    if (!list.length) {
        el.innerHTML = '<div class="grid-empty">Nema artikala</div>';
        return;
    }

    el.innerHTML = list.map(item => `
        <div class="box" data-id="${item.id}">
            <img class="box-img" src="${itemImage(item.item)}" alt="${item.label}"
                onerror="this.src='${fallbackImage()}'">
            <div class="box-name">${item.label}</div>
            <div class="box-price">${formatMoney(item.price)}</div>
            ${item.requiresLicense ? '<span class="box-tag">Dozvola</span>' : ''}
        </div>
    `).join('');

    el.querySelectorAll('.box').forEach(box => {
        box.addEventListener('click', () => openModal(box.dataset.id));
    });
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

    const img = document.getElementById('modalImage');
    img.src = itemImage(item.item);
    img.onerror = () => { img.src = fallbackImage(); };

    document.getElementById('modalName').textContent = item.label;
    document.getElementById('modalPrice').textContent = formatMoney(item.price);

    const blocked = item.requiresLicense && !state.hasLicense;
    document.getElementById('modalWarn').classList.toggle('hidden', !blocked);

    const maxQty = item.maxQty || 1;
    const qtyRow = document.getElementById('qtyRow');
    qtyRow.classList.toggle('hidden', maxQty <= 1 && !(item.qtyStep && item.qtyStep > 1));

    document.getElementById('qtyHint').textContent = item.qtyStep && item.qtyStep > 1
        ? `${item.qtyStep} kom po paketu`
        : (maxQty > 1 ? `Max ${maxQty}` : '');

    updateModalQty();
    document.getElementById('buyBtn').disabled = blocked;
    document.getElementById('buyModal').classList.remove('hidden');
}

function closeModal() {
    document.getElementById('buyModal').classList.add('hidden');
    state.selectedId = null;
}

function updateModalQty() {
    const item = getItem(state.selectedId);
    if (!item) return;

    const maxQty = item.maxQty || 1;
    if (state.quantity > maxQty) state.quantity = maxQty;
    if (state.quantity < 1) state.quantity = 1;

    document.getElementById('qtyValue').textContent = state.quantity;
    document.getElementById('qtyMinus').disabled = state.quantity <= 1;
    document.getElementById('qtyPlus').disabled = state.quantity >= maxQty;
    document.getElementById('modalPrice').textContent = formatMoney(item.price * state.quantity);
}

async function purchase() {
    const item = getItem(state.selectedId);
    if (!item) return;

    if (item.requiresLicense && !state.hasLicense) {
        showToast('Potrebna dozvola za oružje!', 'error');
        return;
    }

    const btn = document.getElementById('buyBtn');
    btn.disabled = true;

    const result = await nuiPost('purchase', {
        itemId: item.id,
        quantity: state.quantity,
        payment: state.payment,
    });

    if (result && result.ok) {
        showToast(result.message || 'Kupljeno!', 'success');
        if (result.cash !== undefined) state.cash = result.cash;
        if (result.bank !== undefined) state.bank = result.bank;
        updateHeader();
        closeModal();
    } else {
        showToast((result && result.message) || 'Kupovina nije uspela.', 'error');
        btn.disabled = item.requiresLicense && !state.hasLicense;
    }
}

function openShop(data) {
    state.open = true;
    state.items = data.items || [];
    state.categories = data.categories || [];
    state.hasLicense = data.hasLicense === true;
    state.cash = data.cash || 0;
    state.bank = data.bank || 0;
    state.currentCategory = 'all';
    state.quantity = 1;
    state.payment = 'cash';

    document.getElementById('shopTitle').textContent = 'Oružarnica';
    updateHeader();
    renderTabs();
    renderGrid();
    document.getElementById('shopWindow').classList.remove('hidden');
}

function closeShop() {
    closeModal();
    state.open = false;
    document.getElementById('shopWindow').classList.add('hidden');
    nuiPost('close');
}

document.getElementById('buyBtn').addEventListener('click', purchase);

document.getElementById('qtyMinus').addEventListener('click', () => {
    state.quantity--;
    updateModalQty();
});

document.getElementById('qtyPlus').addEventListener('click', () => {
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

document.getElementById('buyModal').addEventListener('click', (e) => {
    if (e.target.id === 'buyModal') closeModal();
});

document.addEventListener('keydown', (e) => {
    if (!state.open) return;
    if (e.key === 'Escape') {
        if (!document.getElementById('buyModal').classList.contains('hidden')) {
            closeModal();
        } else {
            closeShop();
        }
    }
});

window.addEventListener('message', (event) => {
    const data = event.data;
    if (!data || !data.action) return;

    if (data.action === 'open') openShop(data);
    else if (data.action === 'close') closeShop();
    else if (data.action === 'updateMoney') {
        state.cash = data.cash ?? state.cash;
        state.bank = data.bank ?? state.bank;
        updateHeader();
    }
});
