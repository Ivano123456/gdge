var RES = 'jamaica-shopovi';
try {
    RES = GetParentResourceName();
} catch (err) {}

var IMG = 'nui://ox_inventory/web/images/';
var FALLBACK = "data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%2256%22 height=%2256%22%3E%3Crect fill=%22%23121620%22 width=%2256%22 height=%2256%22 rx=%228%22/%3E%3Ctext fill=%22%2322c55e%22 font-size=%2210%22 x=%2250%25%22 y=%2250%25%22 text-anchor=%22middle%22 dy=%22.3em%22%3E?%3C/text%3E%3C/svg%3E";

function imgFallback(ev) {
    var img = ev.target;
    if (!img || img.tagName !== 'IMG' || img.dataset.fallback) return;
    img.dataset.fallback = '1';
    img.src = FALLBACK;
}

var dom = {
    shop: document.getElementById('shopPanel'),
    restock: document.getElementById('restockPanel'),
    shopSub: document.getElementById('shopSubtitle'),
    restockSub: document.getElementById('restockSubtitle'),
    toolbar: document.getElementById('toolbarTitle'),
    cats: document.getElementById('categoryList'),
    grid: document.getElementById('productGrid'),
    restockGrid: document.getElementById('restockGrid'),
    search: document.getElementById('searchInput'),
};

var shop = { items: [], categories: [], hasOwner: false, trackStock: false, label: '' };
var restock = { items: [], label: '' };
var itemMap = {};
var catMap = {};
var cat = 'sve';
var query = '';
var payShop = 'bank';
var payRestock = 'bank';
var qty = {};
var searchTimer;

function nui(ep, data) {
    fetch('https://' + RES + '/' + ep, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data !== undefined ? data : {}),
    }).catch(function() {});
}

function money(n) {
    return '$' + (n || 0).toLocaleString('en-US');
}

function rebuildMaps() {
    itemMap = {};
    catMap = {};
    for (var i = 0; i < shop.items.length; i++) itemMap[shop.items[i].id] = shop.items[i];
    for (var j = 0; j < shop.categories.length; j++) catMap[shop.categories[j].id] = shop.categories[j].label;
}

function filterItems() {
    var q = query.trim().toLowerCase();
    var out = [];
    for (var i = 0; i < shop.items.length; i++) {
        var it = shop.items[i];
        if (cat !== 'sve' && it.category !== cat) continue;
        if (q && it.name.toLowerCase().indexOf(q) === -1 && it.itemName.toLowerCase().indexOf(q) === -1) continue;
        out.push(it);
    }
    return out;
}

function maxQty(it) {
    if (!shop.trackStock) return 50;
    var stock = it.stock != null ? it.stock : 0;
    return Math.max(0, Math.min(stock, 50));
}

function getQty(id, it) {
    var m = maxQty(it);
    if (m < 1) return 0;
    var v = qty[id] || 1;
    if (v > m) v = m;
    if (v < 1) v = 1;
    qty[id] = v;
    return v;
}

function renderCats() {
    var cats = shop.categories.length ? shop.categories : [{ id: 'sve', label: 'SVE' }];
    var html = '';
    for (var i = 0; i < cats.length; i++) {
        var c = cats[i];
        html += '<button type="button" class="cat-btn' + (cat === c.id ? ' active' : '') + '" data-cat="' + c.id + '">' + c.label + '</button>';
    }
    dom.cats.innerHTML = html;
}

function renderProducts() {
    var items = filterItems();
    var catLabel = catMap[cat] || 'SVE';
    dom.toolbar.textContent = catLabel + ' · ' + items.length + ' proizvoda';

    if (!items.length) {
        dom.grid.innerHTML = '<div class="empty">Nema proizvoda</div>';
        return;
    }

    var unlimited = !shop.trackStock;
    var html = '';
    for (var i = 0; i < items.length; i++) {
        var it = items[i];
        var stock = it.stock;
        var ok = unlimited || (stock != null && stock > 0);
        var mq = maxQty(it);
        var q = getQty(it.id, it);
        var pct = unlimited ? 100 : Math.min(100, Math.round(((stock || 0) / (it.maxStock || 200)) * 100));
        var fill = unlimited ? '' : stock <= 0 ? 'empty' : pct <= 25 ? 'low' : '';

        var stockBlock = '';
        if (shop.trackStock) {
            var stockHtml = stock <= 0
                ? '<span class="stock out">NEMA NA STANJU</span>'
                : '<span class="stock ' + (pct <= 25 ? 'low' : 'ok') + '">NA STANJU: ' + stock + '</span>';
            stockBlock = '<div class="stock-wrap"><div class="bar"><div class="fill ' + fill + '" style="width:' + pct + '%"></div></div>' + stockHtml + '</div>';
        }

        html += '<article class="card' + (unlimited ? ' card-free' : '') + (ok ? '' : ' dim') + '">' +
            '<div class="thumb"><img src="' + IMG + it.image + '.png" alt=""></div>' +
            '<div class="name">' + it.name + '</div>' +
            '<div class="price">' + money(it.price) + '</div>' +
            '<span class="tag">' + (catMap[it.category] || it.category) + '</span>' +
            stockBlock +
            '<div class="qty">' +
                '<button type="button" class="qty-btn" data-m="' + it.id + '"' + (ok && q > 1 ? '' : ' disabled') + '>−</button>' +
                '<span class="qty-n">' + q + '</span>' +
                '<button type="button" class="qty-btn" data-p="' + it.id + '"' + (ok && q < mq ? '' : ' disabled') + '>+</button>' +
            '</div>' +
            '<button type="button" class="btn-buy" data-buy="' + it.id + '"' + (ok ? '' : ' disabled') + '>' + (ok ? 'KUPI · ' + money(it.price * q) : 'NEMA NA STANJU') + '</button>' +
        '</article>';
    }
    dom.grid.innerHTML = html;
}

function renderShop() {
    dom.shopSub.textContent = shop.label || 'Market';
    renderCats();
    renderProducts();
}

function renderRestock() {
    dom.restockSub.textContent = restock.label || 'Market';
    if (!restock.items.length) {
        dom.restockGrid.innerHTML = '<div class="empty">Nema artikala</div>';
        return;
    }
    var html = '';
    for (var i = 0; i < restock.items.length; i++) {
        var it = restock.items[i];
        var can = it.stock < it.maxStock;
        html += '<article class="restock-row">' +
            '<img src="' + IMG + it.image + '.png" alt="">' +
            '<div class="restock-info">' +
                '<div class="restock-name">' + it.name + '</div>' +
                '<div class="restock-meta">Stanje: ' + it.stock + '/' + it.maxStock + ' · ' + money(it.unitCost) + '/kom</div>' +
            '</div>' +
            '<div class="restock-ctrl">' +
                '<input type="number" class="qty-in" data-item="' + it.itemName + '" value="10" min="1" max="' + (it.maxStock - it.stock) + '">' +
                '<button type="button" class="btn-buy btn-sm" data-restock="' + it.itemName + '"' + (can ? '' : ' disabled') + '>DOPUNI</button>' +
            '</div>' +
        '</article>';
    }
    dom.restockGrid.innerHTML = html;
}

function openShop(data) {
    qty = {};
    shop = {
        items: data.items || [],
        categories: data.categories || [],
        hasOwner: !!data.hasOwner,
        trackStock: !!data.trackStock,
        label: data.label || '',
    };
    cat = 'sve';
    query = '';
    payShop = 'bank';
    dom.search.value = '';
    rebuildMaps();
    setPay('shop', 'bank');
    dom.shop.classList.remove('hidden');
    dom.restock.classList.add('hidden');
    renderShop();
}

function openRestock(data) {
    restock = { items: data.items || [], label: data.label || '' };
    payRestock = 'bank';
    setPay('restock', 'bank');
    dom.restock.classList.remove('hidden');
    dom.shop.classList.add('hidden');
    renderRestock();
}

function patchStock(stocks) {
    if (!stocks) return;
    for (var i = 0; i < shop.items.length; i++) {
        var name = shop.items[i].itemName;
        if (stocks[name] != null) shop.items[i].stock = stocks[name];
    }
    renderProducts();
}

function patchRestock(itemName, stock) {
    for (var i = 0; i < restock.items.length; i++) {
        if (restock.items[i].itemName === itemName) {
            restock.items[i].stock = stock;
            break;
        }
    }
    renderRestock();
}

function setPay(scope, method) {
    var root = document.querySelector('.pay-toggle[data-scope="' + scope + '"]');
    if (!root) return;
    var btns = root.querySelectorAll('.pay-opt');
    for (var i = 0; i < btns.length; i++) {
        btns[i].classList.toggle('active', btns[i].getAttribute('data-pay') === method);
    }
    if (scope === 'shop') payShop = method;
    else payRestock = method;
}

function closePanel(panel, ep) {
    panel.classList.add('hidden');
    nui(ep);
}

dom.grid.addEventListener('error', imgFallback, true);
dom.restockGrid.addEventListener('error', imgFallback, true);

document.addEventListener('click', function(e) {
    var t = e.target;
    if (!t || !t.closest) return;

    var pay = t.closest('.pay-opt');
    if (pay) {
        var toggle = pay.closest('.pay-toggle');
        if (toggle) setPay(toggle.getAttribute('data-scope'), pay.getAttribute('data-pay'));
        return;
    }

    var catBtn = t.closest('.cat-btn');
    if (catBtn) {
        cat = catBtn.getAttribute('data-cat');
        renderCats();
        renderProducts();
        return;
    }

    var minus = t.closest('[data-m]');
    if (minus) {
        var itm = itemMap[Number(minus.getAttribute('data-m'))];
        if (itm) { qty[itm.id] = Math.max(1, (qty[itm.id] || 1) - 1); renderProducts(); }
        return;
    }

    var plus = t.closest('[data-p]');
    if (plus) {
        var itp = itemMap[Number(plus.getAttribute('data-p'))];
        if (itp) { qty[itp.id] = Math.min(maxQty(itp), (qty[itp.id] || 1) + 1); renderProducts(); }
        return;
    }

    var buy = t.closest('[data-buy]');
    if (buy && !buy.disabled) {
        var itb = itemMap[Number(buy.getAttribute('data-buy'))];
        if (!itb) return;
        var q = getQty(itb.id, itb);
        if (q < 1 || (shop.trackStock && (itb.stock == null || itb.stock <= 0))) return;
        nui('Kupovina', { items: [{ name: itb.itemName, quantity: q, price: itb.price }], total: itb.price * q, paymentMethod: payShop });
        qty[itb.id] = 1;
        return;
    }

    var restockBtn = t.closest('[data-restock]');
    if (restockBtn && !restockBtn.disabled) {
        var input = restockBtn.parentElement.querySelector('.qty-in');
        var n = Math.floor(Number(input ? input.value : 0) || 0);
        if (n < 1) { nui('obavestenje', 'Unesite validnu količinu.'); return; }
        nui('Restock', { itemName: restockBtn.getAttribute('data-restock'), quantity: n, paymentMethod: payRestock });
    }
});

dom.search.addEventListener('input', function(e) {
    clearTimeout(searchTimer);
    searchTimer = setTimeout(function() { query = e.target.value; renderProducts(); }, 120);
});

window.addEventListener('message', function(event) {
    var d = event.data;
    if (!d) return;
    switch (d.akcija) {
        case 'otvori_shop':
            if (d.data) openShop(d.data);
            break;
        case 'osvezi_stock':
            patchStock(d.stocks);
            break;
        case 'otvori_restock':
            if (d.data) openRestock(d.data);
            break;
        case 'osvezi_restock_item':
            patchRestock(d.item, d.stock);
            break;
        case 'zatvori':
            dom.shop.classList.add('hidden');
            break;
        case 'zatvori_restock':
            dom.restock.classList.add('hidden');
            break;
    }
});

document.addEventListener('keydown', function(e) {
    if (e.key !== 'Escape') return;
    if (!dom.shop.classList.contains('hidden')) closePanel(dom.shop, 'zatvori');
    else if (!dom.restock.classList.contains('hidden')) closePanel(dom.restock, 'zatvori_restock');
});
