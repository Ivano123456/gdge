var garageData = {};
var currentGarageTab = 'cars';
var garageResetTimer = null;
var garageResetSeconds = 0;
var warHudTimer = null;
var warHudEndsUnix = 0;

var notificationQueue = [];
var maxNotifications = 5;

var NOTIFICATION_ICONS = {
    success: 'fas fa-check-circle',
    error: 'fas fa-times-circle',
    warning: 'fas fa-exclamation-triangle',
    info: 'fas fa-info-circle',
    mafia: 'fas fa-building-shield'
};

var NOTIFICATION_TITLES = {
    success: 'USPJESNO',
    error: 'GRESKA',
    warning: 'UPOZORENJE',
    info: 'INFORMACIJA',
    mafia: 'ORGANIZACIJA'
};

function showMafiaNotification(message, type, duration) {
    type = type || 'mafia';
    duration = duration || 5000;

    var container = document.getElementById('notificationContainer');
    if (!container) return;

    var notification = document.createElement('div');
    notification.className = 'mafia-notification ' + type;
    notification.innerHTML =
        '<div class="mafia-notification-icon"><i class="' + (NOTIFICATION_ICONS[type] || NOTIFICATION_ICONS.mafia) + '"></i></div>' +
        '<div class="mafia-notification-content">' +
            '<div class="mafia-notification-title">' + (NOTIFICATION_TITLES[type] || NOTIFICATION_TITLES.mafia) + '</div>' +
            '<div class="mafia-notification-message">' + message + '</div>' +
        '</div>';

    container.appendChild(notification);
    notificationQueue.push(notification);

    while (notificationQueue.length > maxNotifications) {
        var oldNotification = notificationQueue.shift();
        if (oldNotification && oldNotification.parentNode) {
            oldNotification.classList.add('hiding');
            setTimeout(function () {
                if (oldNotification.parentNode) {
                    oldNotification.parentNode.removeChild(oldNotification);
                }
            }, 300);
        }
    }

    notification.style.setProperty('--duration', duration + 'ms');

    setTimeout(function () {
        if (!notification || !notification.parentNode) return;
        notification.classList.add('hiding');
        var index = notificationQueue.indexOf(notification);
        if (index > -1) notificationQueue.splice(index, 1);
        setTimeout(function () {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, duration);
}

function updateWarHudTimer() {
    if (!warHudEndsUnix) return;
    var left = warHudEndsUnix - Math.floor(Date.now() / 1000);
    var el = document.getElementById('warHudTimer');
    if (!el) return;
    if (left <= 0) {
        hideWarHud();
        return;
    }
    var m = Math.floor(left / 60);
    var s = left % 60;
    el.innerText = m + ':' + (s < 10 ? '0' : '') + s;
}

function showWarHud(data) {
    if (!data || !data.endsUnix || data.endsUnix <= Math.floor(Date.now() / 1000)) {
        hideWarHud();
        return;
    }
    document.getElementById('warHudAttackerLabel').innerText = data.attackerLabel || 'A';
    document.getElementById('warHudDefenderLabel').innerText = data.defenderLabel || 'B';
    document.getElementById('warHudAttackerKills').innerText = data.attackerKills || 0;
    document.getElementById('warHudDefenderKills').innerText = data.defenderKills || 0;
    warHudEndsUnix = data.endsUnix || 0;
    var hud = document.getElementById('warHud');
    hud.hidden = false;
    hud.classList.add('is-active');
    updateWarHudTimer();
    if (warHudTimer) clearInterval(warHudTimer);
    warHudTimer = setInterval(updateWarHudTimer, 1000);
}

function hideWarHud() {
    var hud = document.getElementById('warHud');
    if (!hud) return;
    hud.hidden = true;
    hud.classList.remove('is-active');
    warHudEndsUnix = 0;
    if (warHudTimer) {
        clearInterval(warHudTimer);
        warHudTimer = null;
    }
}

function hideAllMenus() {
    closeGarageMenu(true);
}

function formatResetTime(seconds) {
    if (seconds <= 0) return '';
    var mins = Math.floor(seconds / 60);
    var secs = seconds % 60;
    return mins + ':' + (secs < 10 ? '0' : '') + secs;
}

function updateResetTimerDisplay() {
    var timerEl = document.getElementById('garageResetTimer');
    if (!timerEl) return;

    if (garageResetSeconds > 0) {
        timerEl.innerHTML = '<i class="fas fa-clock"></i> Reset: ' + formatResetTime(garageResetSeconds);
        timerEl.style.display = 'inline-flex';
        garageResetSeconds--;
    } else {
        timerEl.style.display = 'none';
        if (garageResetTimer) {
            clearInterval(garageResetTimer);
            garageResetTimer = null;
        }
    }
}

function startResetTimer(seconds) {
    if (garageResetTimer) {
        clearInterval(garageResetTimer);
        garageResetTimer = null;
    }

    garageResetSeconds = seconds || 0;

    if (garageResetSeconds > 0) {
        updateResetTimerDisplay();
        garageResetTimer = setInterval(updateResetTimerDisplay, 1000);
    } else {
        var timerEl = document.getElementById('garageResetTimer');
        if (timerEl) timerEl.style.display = 'none';
    }
}

function openGarageMenu(data) {
    garageData = data;
    document.getElementById('garageOrgName').innerText = data.orgName || 'Organizacija';
    document.getElementById('garageSpawnedCount').innerText = data.spawnedCount || 0;
    document.getElementById('garageLimit').innerText = data.limit || '∞';
    startResetTimer(data.resetTimeSeconds || 0);
    updateGarageTabs(data);

    if (data.vehicles && Object.keys(data.vehicles).length > 0) {
        switchGarageTab('cars');
    } else if (data.helicopters && Object.keys(data.helicopters).length > 0) {
        switchGarageTab('helicopters');
    } else if (data.boats && Object.keys(data.boats).length > 0) {
        switchGarageTab('boats');
    } else {
        switchGarageTab('cars');
    }

    $('#garageMenu').fadeIn(300);
}

function updateGarageTabs(data) {
    var tabs = {
        cars: data.vehicles,
        helicopters: data.helicopters,
        boats: data.boats
    };

    document.querySelectorAll('.garage-tab').forEach(function (tabEl) {
        var key = tabEl.dataset.tab;
        var list = tabs[key];
        if (list && Object.keys(list).length > 0) {
            tabEl.classList.remove('disabled');
        } else {
            tabEl.classList.add('disabled');
        }
    });
}

function switchGarageTab(tab) {
    currentGarageTab = tab;

    document.querySelectorAll('.garage-tab').forEach(function (tabEl) {
        tabEl.classList.toggle('active', tabEl.dataset.tab === tab);
    });

    var vehicles = {};
    var icon = 'fa-car';
    var emptyMessage = 'Nema vozila u garazi';

    if (tab === 'helicopters') {
        vehicles = garageData.helicopters || {};
        icon = 'fa-helicopter';
        emptyMessage = 'Nema helikoptera u garazi';
    } else if (tab === 'boats') {
        vehicles = garageData.boats || {};
        icon = 'fa-ship';
        emptyMessage = 'Nema brodova u garazi';
    } else {
        vehicles = garageData.vehicles || {};
    }

    populateVehicleList(vehicles, icon, emptyMessage, tab);
}

function populateVehicleList(vehicles, icon, emptyMessage, vehicleType) {
    var container = document.getElementById('garageVehicleList');
    container.innerHTML = '';
    var vehicleKeys = Object.keys(vehicles);

    if (vehicleKeys.length === 0) {
        container.innerHTML =
            '<div class="garage-empty-message">' +
                '<i class="fas ' + icon + '"></i>' +
                '<p>' + emptyMessage + '</p>' +
            '</div>';
        return;
    }

    vehicleKeys.forEach(function (model) {
        var label = vehicles[model];
        var item = document.createElement('div');
        item.className = 'vehicle-tile garage-vehicle-item';
        item.innerHTML =
            '<div class="vehicle-tile-icon garage-vehicle-icon"><i class="fas ' + icon + '"></i></div>' +
            '<div class="garage-vehicle-info">' +
                '<div class="vehicle-tile-name garage-vehicle-name">' + label + '</div>' +
                '<div class="vehicle-tile-model garage-vehicle-model">' + model + '</div>' +
            '</div>' +
            '<i class="fas fa-chevron-right garage-vehicle-arrow"></i>';
        item.onclick = function () {
            spawnVehicle(model, vehicleType);
        };
        container.appendChild(item);
    });
}

function spawnVehicle(model, vehicleType) {
    $.post('https://' + GetParentResourceName() + '/garageSpawnVehicle', JSON.stringify({
        model: model,
        vehicleType: vehicleType
    }));
    closeGarageMenu();
}

function closeGarageMenu(silent) {
    if (garageResetTimer) {
        clearInterval(garageResetTimer);
        garageResetTimer = null;
    }
    garageResetSeconds = 0;
    $('#garageMenu').fadeOut(200);
    if (!silent) {
        $.post('https://' + GetParentResourceName() + '/closeGarageMenu', JSON.stringify({}));
    }
}

window.addEventListener('message', function (event) {
    var item = event.data;

    if (item.type === 'mafiaNotification') {
        showMafiaNotification(item.message, item.notifType, item.duration);
        return;
    }

    if (item.type === 'openGarageMenu') {
        openGarageMenu(item);
        return;
    }

    if (item.type === 'warHudShow') {
        showWarHud(item);
        return;
    }

    if (item.type === 'warHudHide') {
        hideWarHud();
    }
});

$(document).keyup(function (e) {
    if (e.keyCode === 27) {
        hideAllMenus();
        $.post('https://' + GetParentResourceName() + '/zatvori', JSON.stringify({}));
    }
});
