var isVehicleShopOpen = false;

var notificationQueue = [];
var maxNotifications = 5;

var NOTIFICATION_ICONS = {
    success: 'fas fa-check-circle',
    error: 'fas fa-times-circle',
    warning: 'fas fa-exclamation-triangle',
    info: 'fas fa-info-circle',
    sluzbe: 'fas fa-shield-halved'
};

var NOTIFICATION_TITLES = {
    success: 'USPJESNO',
    error: 'GRESKA',
    warning: 'UPOZORENJE',
    info: 'INFORMACIJA',
    sluzbe: 'SLUZBA'
};

function panelLoadingHtml() {
    return '<div class="panel-loading"><i class="fas fa-spinner fa-spin"></i><span>Ucitavanje...</span></div>';
}

function showSluzbeNotification(message, type, duration) {
    type = type || 'info';
    duration = duration || 5000;

    var container = document.getElementById('notificationContainer');
    if (!container) return;

    var notification = document.createElement('div');
    notification.className = 'sluzbe-notification ' + type;
    notification.innerHTML =
        '<div class="sluzbe-notification-icon"><i class="' + (NOTIFICATION_ICONS[type] || NOTIFICATION_ICONS.sluzbe) + '"></i></div>' +
        '<div class="sluzbe-notification-content">' +
            '<div class="sluzbe-notification-title">' + (NOTIFICATION_TITLES[type] || NOTIFICATION_TITLES.sluzbe) + '</div>' +
            '<div class="sluzbe-notification-message">' + message + '</div>' +
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

function openF6Menu(data) {
    document.getElementById('f6OrgName').innerText = data.orgName || 'Sluzba';
    document.getElementById('f6GpsBtn').style.display = data.showGps ? '' : 'none';
    $('#f6Menu').fadeIn(300);
}

function closeF6Menu() {
    $('#f6Menu').fadeOut(200);
    $.post('https://' + GetParentResourceName() + '/closeF6Menu', JSON.stringify({}));
}

function f6Action(action) {
    $('#f6Menu').fadeOut(200);
    $.post('https://' + GetParentResourceName() + '/f6Action', JSON.stringify({ action: action }));
}

function openVehicleShop(data) {
    data = data || {};
    document.getElementById('vehicleShopTitle').innerText = data.orgName || 'Sluzbena vozila';
    document.getElementById('vehicleShopContent').innerHTML = panelLoadingHtml();
    var menu = document.getElementById('vehicleShopMenu');
    if (menu) {
        menu.style.display = 'block';
        menu.classList.add('panel-visible');
    }
    isVehicleShopOpen = true;
}

function closeVehicleShop(silent) {
    var menu = document.getElementById('vehicleShopMenu');
    if (menu) {
        menu.classList.remove('panel-visible', 'panel-enter', 'panel-leave');
        menu.style.display = 'none';
    }
    isVehicleShopOpen = false;
    if (!silent) {
        $.post('https://' + GetParentResourceName() + '/closeVehicleShop', JSON.stringify({}));
    }
}

function vehicleShopCard(icon, title, sub, actionHtml) {
    return (
        '<article class="vehicle-card">' +
            '<div class="vehicle-card-icon"><i class="' + icon + '"></i></div>' +
            '<div class="vehicle-card-info">' +
                '<div class="vehicle-card-title">' + title + '</div>' +
                '<div class="vehicle-card-sub">' + sub + '</div>' +
            '</div>' +
            '<div class="vehicle-card-action">' + actionHtml + '</div>' +
        '</article>'
    );
}

function showVehicleShopList(data) {
    data = data || {};
    var purchase = data.purchase || [];
    var garage = data.garage || [];
    var impound = data.impound || [];
    var impoundPrice = data.impoundPrice || 500;
    var container = document.getElementById('vehicleShopContent');
    var rows = [];

    if (garage.length > 0) {
        rows.push('<div class="shop-section-title"><i class="fas fa-warehouse"></i> Moja vozila u garazi</div>');
        for (var g = 0; g < garage.length; g++) {
            var gv = garage[g];
            var outTag = gv.stored ? '' : '<span class="out-tag">Van garaze</span>';
            var spawnBtn = gv.stored
                ? '<button type="button" class="vehicle-btn vehicle-btn-primary vehicle-spawn-btn" data-id="' + gv.id + '"><i class="fas fa-key"></i> Izvadi</button>'
                : '<button type="button" class="vehicle-btn vehicle-btn-muted" disabled>Van garaze</button>';
            rows.push(vehicleShopCard(
                'fas fa-car',
                escapeHtml(gv.label || gv.model) + outTag,
                escapeHtml(gv.plate || ''),
                spawnBtn
            ));
        }
    }

    if (impound.length > 0) {
        rows.push('<div class="shop-section-title shop-section-impound"><i class="fas fa-truck-pickup"></i> Impound sluzbenih vozila</div>');
        for (var j = 0; j < impound.length; j++) {
            var iv = impound[j];
            rows.push(vehicleShopCard(
                'fas fa-lock',
                escapeHtml(iv.label || iv.model) + '<span class="impound-tag">Impound</span>',
                escapeHtml(iv.plate || '') + ' · $' + formatNumber(impoundPrice) + ' za vracanje',
                '<button type="button" class="vehicle-btn vehicle-btn-warning vehicle-impound-btn" data-id="' + iv.id + '"><i class="fas fa-dollar-sign"></i> Vrati</button>'
            ));
        }
    }

    if (purchase.length > 0) {
        rows.push('<div class="shop-section-title"><i class="fas fa-cart-shopping"></i> Kupovina</div>');
        for (var i = 0; i < purchase.length; i++) {
            var v = purchase[i];
            var priceText = v.cijena > 0 ? ('$' + formatNumber(v.cijena)) : 'Besplatno';
            rows.push(vehicleShopCard(
                'fas fa-car-side',
                escapeHtml(v.label || v.model),
                escapeHtml(v.model) + ' · ' + priceText,
                '<button type="button" class="vehicle-btn vehicle-btn-primary vehicle-buy-btn" data-model="' + String(v.model).replace(/"/g, '') + '"><i class="fas fa-cart-shopping"></i> Kupi</button>'
            ));
        }
    }

    if (rows.length === 0) {
        container.innerHTML = '<div class="empty-state">Nemate vozila u garazi niti dostupnih za kupovinu.</div>';
        container.onclick = null;
        return;
    }

    container.innerHTML = rows.join('');
    container.onclick = function (e) {
        var buyBtn = e.target.closest('.vehicle-buy-btn');
        if (buyBtn) {
            var model = buyBtn.getAttribute('data-model');
            if (model) {
                $.post('https://' + GetParentResourceName() + '/purchaseVehicle', JSON.stringify({ model: model }));
            }
            return;
        }
        var spawnBtn = e.target.closest('.vehicle-spawn-btn');
        if (spawnBtn) {
            var id = spawnBtn.getAttribute('data-id');
            if (id) {
                $.post('https://' + GetParentResourceName() + '/spawnOrgVehicle', JSON.stringify({ id: parseInt(id, 10) }));
            }
            return;
        }
        var impoundBtn = e.target.closest('.vehicle-impound-btn');
        if (impoundBtn) {
            var impoundId = impoundBtn.getAttribute('data-id');
            if (impoundId) {
                $.post('https://' + GetParentResourceName() + '/payImpound', JSON.stringify({ id: parseInt(impoundId, 10) }));
            }
        }
    };
}

function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

function escapeHtml(text) {
    if (text === null || text === undefined) return '';
    return String(text)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

function hideAllMenus() {
    closeVehicleShop(true);
    $('#f6Menu').stop(true, true).hide();
}

window.addEventListener('message', function (event) {
    var item = event.data;

    if (item.type === 'sluzbeNotification') {
        showSluzbeNotification(item.message, item.notifType, item.duration);
        return;
    }

    if (item.type === 'openF6Menu') {
        openF6Menu(item);
        return;
    }

    if (item.type === 'openVehicleShop') {
        openVehicleShop(item);
        return;
    }

    if (item.type === 'vehicleShopList') {
        showVehicleShopList(item);
        return;
    }

    if (item.type === 'closeAllMenus') {
        hideAllMenus();
    }
});

$(document).keyup(function (e) {
    if (e.keyCode === 27) {
        hideAllMenus();
        $.post('https://' + GetParentResourceName() + '/zatvori', JSON.stringify({}));
    }
});
