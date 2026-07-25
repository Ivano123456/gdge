const RES = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'jamaica-welcomee';

let state = {
    caseData: null,
    imagePath: 'nui://ox_inventory/web/images/%s.png',
    spinning: false
};

function post(name, data) {
    return fetch(`https://${RES}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data || {})
    }).then(r => r.json()).catch(() => false);
}

function localPlaceholder(kind) {
    return `nui://${RES}/html/img/${kind}.svg`;
}

function inventoryImage(itemName) {
    if (!itemName) return null;
    return state.imagePath.replace('%s', String(itemName).toLowerCase());
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
    const gt = (meta && meta.giveItemType) || '';

    if (itemName && gt !== 'money' && itemName !== 'money') {
        push(inventoryImage(itemName));
    }
    if (gt === 'money' || itemName === 'money') {
        push(inventoryImage('money'));
        push(localPlaceholder('money'));
    }
    if (gt === 'vehicle') {
        push(localPlaceholder('vehicle'));
    }
    if ((gt === 'weapon' || gt === 'item') && itemName) {
        push(inventoryImage(itemName));
    }
    if (gt === 'weapon') {
        push(localPlaceholder('weapon'));
    }
    push(localPlaceholder('placeholder'));

    const filtered = chain.filter(url => url !== el.src);
    let step = 0;
    el.onerror = function() {
        if (step < filtered.length) {
            this.src = filtered[step++];
        } else {
            this.onerror = null;
        }
    };
}

function isMoneyCaseItem(item) {
    return item && (item.giveItemType === 'money' || item.itemName === 'money');
}

function caseItemCaption(item) {
    if (!item || !isMoneyCaseItem(item)) return '';
    return item.label || String(item.itemCount || '');
}

function buildCaseItemVisual(item) {
    const wrap = document.createElement('div');
    wrap.className = 'case-item-visual' + (isMoneyCaseItem(item) ? ' is-money' : '');
    const img = document.createElement('img');
    img.src = item.image || '';
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

function openCase(caseData) {
    if (state.spinning) return;
    state.spinning = true;

    const ITEM_W = 140;
    const ITEM_GAP = 12;
    const ITEM_STEP = ITEM_W + ITEM_GAP;
    const ROW_PAD = 20;
    const WIN_INDEX = 34;
    const SPIN_MS = 4200;

    const app = document.getElementById('app');
    app.classList.remove('hidden');

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
    app.appendChild(overlay);

    const row = overlay.querySelector('.spinner-items');
    const viewport = overlay.querySelector('.spinner-viewport');

    post('openCaseSelect', {}).then(result => {
        if (!result || result === false) {
            overlay.remove();
            app.classList.add('hidden');
            state.spinning = false;
            post('close');
            return;
        }

        const items = (caseData && caseData.items) || [];
        if (!items.length) {
            overlay.remove();
            app.classList.add('hidden');
            state.spinning = false;
            post('close');
            return;
        }

        const pickRandom = () => items[Math.floor(Math.random() * items.length)];
        const display = [];
        for (let i = 0; i < WIN_INDEX; i++) display.push(pickRandom());
        display.push(result);
        for (let i = 0; i < 6; i++) display.push(pickRandom());

        display.forEach((it, idx) => {
            const d = document.createElement('div');
            d.className = 'spinner-item' + (idx === WIN_INDEX ? ' win-target' : '') + (isMoneyCaseItem(it) ? ' is-money' : '');
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
        }, SPIN_MS + 200);
    });
}

function showCaseResult(item) {
    const media = document.getElementById('caseResultMedia');
    media.innerHTML = '';
    media.className = 'case-result-media' + (isMoneyCaseItem(item) ? ' is-money' : '');
    media.appendChild(buildCaseItemVisual(item));
    document.getElementById('caseResultLabel').textContent = isMoneyCaseItem(item) ? '' : (item.label || '');
    document.getElementById('caseResultType').textContent = item.itemType || '';
    document.getElementById('caseModal').classList.remove('hidden');
}

function closeAll() {
    document.getElementById('caseModal').classList.add('hidden');
    document.getElementById('app').replaceChildren();
    document.getElementById('app').classList.add('hidden');
    state.spinning = false;
}

document.getElementById('btnCollect').onclick = () => {
    post('collectCaseItem').then(() => {
        closeAll();
        post('close');
    });
};

window.addEventListener('message', (event) => {
    const data = event.data;
    if (!data || !data.action) return;

    if (data.action === 'open') {
        if (data.imagePath) state.imagePath = data.imagePath;
        state.caseData = data.caseData || null;
        openCase(state.caseData);
    }

    if (data.action === 'forceClose') {
        closeAll();
    }
});

document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        if (state.spinning) return;
        if (!document.getElementById('caseModal').classList.contains('hidden')) return;
    }
});
