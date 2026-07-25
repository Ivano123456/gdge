const defaultVehicles = {
    faggio: {
        name: 'Motor',
        price: 75,
        model: 'faggio',
        stat: 'Brzo',
        image: 'https://docs.fivem.net/vehicles/faggio.webp'
    },
    blista: {
        name: 'Auto',
        price: 125,
        model: 'blista',
        stat: '4 Sjedala',
        image: 'https://docs.fivem.net/vehicles/blista.webp'
    },
    sanchez: {
        name: 'Dirt Bike',
        price: 100,
        model: 'sanchez',
        stat: 'Offroad',
        image: 'https://docs.fivem.net/vehicles/sanchez.webp'
    },
    bati: {
        name: 'Sport Bike',
        price: 150,
        model: 'bati',
        stat: 'Super Brzo',
        image: 'https://docs.fivem.net/vehicles/bati.webp'
    }
};

const colorMap = {
    red: { r: 230, g: 57, b: 70 },
    orange: { r: 247, g: 127, b: 0 },
    blue: { r: 67, g: 97, b: 238 },
    green: { r: 57, g: 255, b: 20 },
    yellow: { r: 255, g: 190, b: 11 },
    white: { r: 255, g: 255, b: 255 },
    black: { r: 26, g: 26, b: 26 }
};

let uiVisible = false;
let selectedVehicle = 'faggio';
let selectedColor = 'green';
let rentTime = 1;
let rentType = 'land';
let vehicles = { ...defaultVehicles };
const maxRentTime = 60;
const minRentTime = 1;

let container, mainVehicleImage, totalPriceEl, rentTimeEl, vehicleListEl, panelTitleEl, headerTitleEl, sidebarTitleEl;

document.addEventListener('DOMContentLoaded', function() {
    container = document.getElementById('rentContainer');
    mainVehicleImage = document.getElementById('mainVehicleImage');
    totalPriceEl = document.getElementById('totalPrice');
    rentTimeEl = document.getElementById('rentTime');
    vehicleListEl = document.getElementById('vehicleList');
    panelTitleEl = document.getElementById('panelTitle');
    headerTitleEl = document.getElementById('headerTitle');
    sidebarTitleEl = document.getElementById('sidebarTitle');

    setupEventListeners();
});

function normalizeVehicles(source) {
    const normalized = {};
    for (const [key, vehicle] of Object.entries(source || {})) {
        normalized[key] = {
            name: vehicle.name,
            price: vehicle.price,
            model: vehicle.model,
            stat: vehicle.stat || 'Rent',
            image: vehicle.image || `https://docs.fivem.net/vehicles/${vehicle.model}.webp`
        };
    }
    return normalized;
}

function setupVehicleCardListeners() {
    document.querySelectorAll('.vehicle-card').forEach(card => {
        card.addEventListener('click', function(e) {
            e.preventDefault();
            const vehicleKey = this.dataset.vehicle;
            if (vehicleKey) {
                selectVehicle(vehicleKey);
            }
        });
    });
}

function setupEventListeners() {
    document.querySelectorAll('.color-swatch').forEach(swatch => {
        swatch.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            const color = this.dataset.color;
            if (color) {
                selectColor(color);
            }
        });
    });

    document.addEventListener('keydown', function(e) {
        if (!uiVisible) return;
        if (e.key === 'Escape') {
            closeUI();
        }
        if (e.key === 'ArrowLeft') {
            changeTime(-1);
        }
        if (e.key === 'ArrowRight') {
            changeTime(1);
        }
    });
}

function renderVehicleList() {
    if (!vehicleListEl) return null;

    vehicleListEl.innerHTML = '';
    let firstKey = null;

    for (const [key, vehicle] of Object.entries(vehicles)) {
        if (!firstKey) firstKey = key;

        const card = document.createElement('div');
        card.className = 'vehicle-card';
        card.dataset.vehicle = key;
        card.dataset.price = String(vehicle.price);
        card.dataset.name = vehicle.name;
        card.innerHTML = `
            <div class="vehicle-image">
                <img src="${vehicle.image}" alt="${vehicle.name}">
            </div>
            <div class="vehicle-info">
                <span class="vehicle-name">${vehicle.name}</span>
                <div class="vehicle-stats">
                    <div class="stat">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/>
                        </svg>
                        <span>${vehicle.stat}</span>
                    </div>
                </div>
            </div>
            <div class="price-tag">
                <span class="price-value">${vehicle.price}$</span>
                <span class="price-label">/min</span>
            </div>
        `;
        vehicleListEl.appendChild(card);
    }

    setupVehicleCardListeners();
    return firstKey;
}

function applyUiTitles(titles) {
    if (headerTitleEl) {
        headerTitleEl.textContent = titles.header || 'RENT CAR';
    }
    if (panelTitleEl) {
        panelTitleEl.innerHTML = `${titles.subtitle || 'Renta Car'}<br><span>V6</span>`;
    }
    if (sidebarTitleEl) {
        sidebarTitleEl.textContent = titles.sidebar || 'Vozila';
    }
}

function selectVehicle(vehicleKey) {
    if (!vehicles[vehicleKey]) return;

    selectedVehicle = vehicleKey;

    document.querySelectorAll('.vehicle-card').forEach(card => {
        card.classList.remove('active');
        if (card.dataset.vehicle === vehicleKey) {
            card.classList.add('active');
        }
    });

    updateDisplay();
}

function selectColor(color) {
    if (!colorMap[color]) return;

    selectedColor = color;

    document.querySelectorAll('.color-swatch').forEach(swatch => {
        if (swatch.dataset.color === color) {
            swatch.classList.add('active');
        } else {
            swatch.classList.remove('active');
        }
    });
}

function changeTime(delta) {
    rentTime += delta;

    if (rentTime < minRentTime) rentTime = minRentTime;
    if (rentTime > maxRentTime) rentTime = maxRentTime;

    updateDisplay();
}

function updateDisplay() {
    const vehicle = vehicles[selectedVehicle];
    if (!vehicle) return;

    if (mainVehicleImage) {
        mainVehicleImage.src = vehicle.image;
        mainVehicleImage.alt = vehicle.name;
    }

    const totalPrice = vehicle.price * rentTime;
    if (totalPriceEl) {
        totalPriceEl.textContent = totalPrice.toLocaleString() + '$';
    }

    if (rentTimeEl) {
        if (rentTime === 1) {
            rentTimeEl.textContent = '1 Minuta';
        } else if (rentTime < 5) {
            rentTimeEl.textContent = rentTime + ' Minute';
        } else {
            rentTimeEl.textContent = rentTime + ' Minuta';
        }
    }
}

function rent(paymentMethod) {
    const vehicle = vehicles[selectedVehicle];
    if (!vehicle) return;

    const totalPrice = vehicle.price * rentTime;

    sendNUI('rentVehicle', {
        vehicle: selectedVehicle,
        model: vehicle.model,
        color: selectedColor,
        colorRGB: colorMap[selectedColor],
        time: rentTime,
        price: totalPrice,
        paymentMethod: paymentMethod
    });
}

function hidePanel() {
    uiVisible = false;
    document.body.classList.remove('ui-open');
    if (container) {
        container.classList.remove('active');
    }
}

function showUI(data) {
    uiVisible = true;
    document.body.classList.add('ui-open');

    if (container) {
        container.classList.add('active');
    }

    rentType = data && data.rentType === 'water' ? 'water' : 'land';
    vehicles = normalizeVehicles(data && data.vehicles ? data.vehicles : defaultVehicles);

    const titles = data && data.uiTitles && data.uiTitles[rentType]
        ? data.uiTitles[rentType]
        : {
            header: rentType === 'water' ? 'RENT BOAT' : 'RENT CAR',
            subtitle: rentType === 'water' ? 'Renta Brodova' : 'Renta Car',
            sidebar: rentType === 'water' ? 'Plovila' : 'Vozila'
        };
    applyUiTitles(titles);

    if (data) {
        if (data.username) {
            const usernameEl = document.querySelector('.username');
            if (usernameEl) usernameEl.textContent = data.username;
        }
        if (data.balance !== undefined) {
            const balanceEl = document.querySelector('.balance');
            if (balanceEl) balanceEl.textContent = data.balance.toLocaleString() + '$';
        }
        const avatarEl = document.getElementById('userAvatar');
        if (avatarEl) {
            avatarEl.referrerPolicy = 'no-referrer';
            avatarEl.crossOrigin = 'anonymous';
            avatarEl.onerror = function() {
                this.onerror = null;
                this.src = 'https://cdn.discordapp.com/embed/avatars/0.png';
            };
            avatarEl.src = data.avatar || 'https://cdn.discordapp.com/embed/avatars/0.png';
        }
    }

    selectedColor = 'green';
    rentTime = 1;

    const firstKey = renderVehicleList() || 'faggio';
    selectedVehicle = firstKey;

    document.querySelectorAll('.vehicle-card').forEach(card => {
        card.classList.remove('active');
        if (card.dataset.vehicle === selectedVehicle) {
            card.classList.add('active');
        }
    });

    document.querySelectorAll('.color-swatch').forEach(swatch => {
        if (swatch.dataset.color === 'green') {
            swatch.classList.add('active');
        } else {
            swatch.classList.remove('active');
        }
    });

    updateDisplay();
}

function closeUI() {
    if (!uiVisible) return;
    hidePanel();
    sendNUI('closeUI', {});
}

function sendNUI(action, data) {
    if (typeof GetParentResourceName === 'function') {
        fetch(`https://${GetParentResourceName()}/${action}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        }).catch(function() {});
    }
}

window.addEventListener('message', function(event) {
    const data = event.data;

    switch (data.action) {
        case 'show':
            showUI(data);
            break;
        case 'hide':
            hidePanel();
            break;
        case 'updateBalance':
            const balanceEl = document.querySelector('.balance');
            if (balanceEl && data.balance !== undefined) {
                balanceEl.textContent = data.balance.toLocaleString() + '$';
            }
            break;
        case 'updateUsername':
            const usernameEl = document.querySelector('.username');
            if (usernameEl && data.username) {
                usernameEl.textContent = data.username;
            }
            break;
        case 'setVehicles':
            if (data.vehicles) {
                vehicles = normalizeVehicles(data.vehicles);
                renderVehicleList();
                updateDisplay();
            }
            break;
    }
});

window.RentCar = {
    show: showUI,
    hide: closeUI,
    selectVehicle: selectVehicle,
    selectColor: selectColor,
    rent: rent,
    changeTime: changeTime
};
