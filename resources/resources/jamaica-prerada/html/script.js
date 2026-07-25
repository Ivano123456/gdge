const container = document.getElementById('craftContainer');
const closeBtn = document.getElementById('closeBtn');
const craftBtn = document.getElementById('craftBtn');
const craftTimeEl = document.getElementById('craftTime');
const inputStockEl = document.getElementById('inputStock');

let state = {
    recipe: null,
    canCraft: false,
};

function itemImg(item) {
    return `nui://ox_inventory/web/images/${item}.png`;
}

function post(name, data) {
    return fetch(`https://${GetParentResourceName()}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data || {}),
    });
}

function formatDuration(ms) {
    const sec = Math.ceil((ms || 0) / 1000);
    return `${sec}s po komadu`;
}

function updateCraftBtn() {
    craftBtn.disabled = !state.canCraft;
}

function renderRecipe(recipe) {
    state.recipe = recipe;

    document.getElementById('recipeName').textContent = recipe.label;
    document.getElementById('detailIcon').innerHTML = `<i class="${recipe.icon}"></i>`;

    document.getElementById('inputImg').src = itemImg(recipe.input.item);
    document.getElementById('outputImg').src = itemImg(recipe.output.item);
    document.getElementById('inputLabel').textContent = recipe.input.label;
    document.getElementById('outputLabel').textContent = recipe.output.label;

    craftTimeEl.textContent = formatDuration(recipe.duration);
    updateCraftBtn();
}

function openUi(data) {
    inputStockEl.textContent = String(data.inputCount || 0);
    state.canCraft = (data.maxCraft || 0) >= 1;

    renderRecipe(data.recipe);
    container.classList.remove('hidden');
}

function closeUi() {
    container.classList.add('hidden');
    state = { recipe: null, canCraft: false };
}

window.addEventListener('message', (event) => {
    const data = event.data;
    if (!data || !data.action) return;

    if (data.action === 'open') {
        openUi(data);
    } else if (data.action === 'close') {
        closeUi();
    }
});

closeBtn.addEventListener('click', () => post('close'));
craftBtn.addEventListener('click', () => {
    if (!state.recipe || !state.canCraft) return;
    post('craft', { amount: 1 });
});

document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && !container.classList.contains('hidden')) {
        post('close');
    }
});
