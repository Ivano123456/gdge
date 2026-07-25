(function () {
    'use strict';

    var res = (typeof GetParentResourceName === 'function' && GetParentResourceName()) || 'jamaica-reportovi';
    function nui(path, body) {
        return fetch('https://' + res + '/' + path, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: body ? JSON.stringify(body) : '{}'
        });
    }

    var ICONS = {
        user: '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>',
        goto: '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="10" r="3"/><path d="M12 21.7C17.3 17 20 13 20 10a8 8 0 1 0-16 0c0 3 2.7 7 8 11.7z"/></svg>',
        heal: '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>',
        revive: '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19.69 14a6.9 6.9 0 0 0 .31-2V5l-8-3-3.16 1.18"/><path d="M4.73 4.73L4 5v7c0 6 8 10 8 10a20.29 20.29 0 0 0 5.62-4.38"/><line x1="1" y1="1" x2="23" y2="23"/></svg>',
        car: '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 0 0 2 12v4c0 .6.4 1 1 1h2"/><circle cx="7" cy="17" r="2"/><circle cx="17" cy="17" r="2"/></svg>',
        spectate: '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>',
        kick: '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg>',
        delete: '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>',
        inbox: '<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"/><path d="M5.45 5.11L2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"/></svg>'
    };

    var reports = [];
    var el = {
        player: document.getElementById('playerReportMenu'),
        admin: document.getElementById('adminReportMenu'),
        list: document.getElementById('reportsList'),
        count: document.getElementById('reportCount'),
        ta: document.getElementById('reportText'),
        cc: document.getElementById('charCount')
    };

    function closeUi() {
        el.player.classList.remove('active');
        el.admin.classList.remove('active');
        nui('closeUI').catch(function () {});
    }

    function openPlayerMenu() {
        el.player.classList.add('active');
        el.admin.classList.remove('active');
        el.ta.value = '';
        el.cc.textContent = '0';
    }

    function openAdminMenu() {
        el.admin.classList.add('active');
        el.player.classList.remove('active');
        renderReports();
    }

    function renderReports() {
        el.count.textContent = reports.length;
        if (!reports.length) {
            el.list.innerHTML = '<div class="empty-state"><div class="empty-state-icon">' + ICONS.inbox + '</div><div class="empty-state-text">Nema aktivnih reportova</div></div>';
            return;
        }
        el.list.innerHTML = reports.map(function (r) {
            return '<div class="report-card" data-id="' + r.id + '"><div class="report-header"><div class="player-info"><div class="player-avatar">' + ICONS.user + '</div><div class="player-details"><span class="player-name">' + r.playerName + '</span><span class="player-id">ID: ' + r.playerId + '</span></div></div><span class="report-time">' + r.time + '</span></div><div class="report-text">' + r.text + '</div><div class="action-buttons"><button type="button" class="action-btn goto" data-a="goto" data-t="' + r.playerId + '">' + ICONS.goto + ' GoTo</button><button type="button" class="action-btn heal" data-a="heal" data-t="' + r.playerId + '">' + ICONS.heal + ' Heal</button><button type="button" class="action-btn revive" data-a="revive" data-t="' + r.playerId + '">' + ICONS.revive + ' Revive</button><button type="button" class="action-btn car" data-a="givevehicle" data-t="' + r.playerId + '">' + ICONS.car + ' Auto</button><button type="button" class="action-btn spectate" data-a="spectate" data-t="' + r.playerId + '">' + ICONS.spectate + ' Spectate</button><button type="button" class="action-btn kick" data-a="kick" data-t="' + r.playerId + '">' + ICONS.kick + ' Kick</button><button type="button" class="action-btn delete" data-a="deletereport" data-t="' + r.id + '">' + ICONS.delete + ' Obriši</button></div></div>';
        }).join('');
    }

    el.list.addEventListener('click', function (e) {
        var btn = e.target.closest('.action-btn');
        if (!btn) return;
        var action = btn.getAttribute('data-a');
        var tid = parseInt(btn.getAttribute('data-t'), 10);
        if (action === 'kick' && !confirm('Ukloniti igrača ID ' + tid + '?')) return;
        nui('adminAction', { action: action, targetId: tid }).catch(function () {});
    });

    window.sendReport = function () {
        nui('sendReport', { text: el.ta.value }).then(function (r) { return r.json(); }).then(function (resp) {
            if (resp && resp.ok) {
                el.ta.value = '';
                el.cc.textContent = '0';
            }
        }).catch(function () {
            nui('clientNotify', { msg: 'Greška pri slanju reporta.' }).catch(function () {});
        });
    };

    window.closePlayerMenu = function () {
        el.player.classList.remove('active');
        nui('closeUI').catch(function () {});
    };

    window.closeAdminMenu = function () {
        el.admin.classList.remove('active');
        nui('closeUI').catch(function () {});
    };

    el.ta.addEventListener('input', function () {
        var c = el.ta.value.length;
        if (c > 500) {
            el.ta.value = el.ta.value.substring(0, 500);
            c = 500;
        }
        el.cc.textContent = String(c);
    });

    window.addEventListener('message', function (e) {
        var d = e.data;
        switch (d.type) {
            case 'openPlayerReport':
                openPlayerMenu();
                break;
            case 'openAdminReports':
                reports = d.reports || [];
                openAdminMenu();
                break;
            case 'updateReports':
                reports = d.reports || [];
                renderReports();
                break;
            case 'hidePlayer':
                el.player.classList.remove('active');
                break;
        }
    });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeUi();
    });
})();
