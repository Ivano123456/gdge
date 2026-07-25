var playerGradeLabel;
var targetPlayerName;
var targetCitizenID;
var playersInfo;
var playerName;
var playerSex;
var jobGrades;
var isOnDuty;
var currency;
var locales;

var playerIsBoss = false;

var targetPlayerGrade = 0;
var onlinePlayers = 0;
var totalPlayers = 0;
var societyMoney = 0;
var todayTime = '00:00';
var totalPlayerMinutes = 0;
var todayMinutes = 0;

var table = [];

var timeLocale;

async function retrieveNUI(
    eventName, data = {}) {
    const options = {
          method: "post",
          headers: { 
            "Content-Type": "application/json; charset=UTF-8" 
            },
          body: JSON.stringify(data),
    };

    const resourceName = window.GetParentResourceName 
    ? window.GetParentResourceName() 
    : "nui-frame-app";

    try {
        const resp = await fetch(`https://${resourceName}/${eventName}`, options);
        return await resp.json();
    } catch (error) {
        return null;
    }
}

window.addEventListener('message', function(event) {
	switch (event.data.action) {
		case 'bossmenu':
            locales = event.data.locales;
            playerSex = event.data.playerSex;
            playerName = event.data.playerName;
            playerJob = event.data.playerJob;
            playerGradeLabel = event.data.playerGradeLabel;
            playerCitizenID = event.data.playerCitizenID;
            onlinePlayers = event.data.onlinePlayers;
            totalPlayers = event.data.totalPlayers;
            playersInfo = event.data.playersInfo;
            societyMoney = event.data.societyMoney;
            currency = event.data.currency;
            jobGrades = event.data.jobGrades;
            timeLocale = event.data.timeLocale;
            gradesInfo = event.data.ranksInfo;
            playerJobLabel = event.data.playerJobLabel;
            playerIsBoss = event.data.playerIsBoss === true;
            setOverviewPage();
            $('#playerName').html(playerName);
            $('#playerGradeLabel').html(playerGradeLabel);
            let avatarImage = playerSex == "0" ? "./images/avatar_male.png" : "./images/avatar_female.png";
            $('#playerAvatar').html(`<img src=${avatarImage} class="avatar">`);
            setupUI();
            $('#bossMenu').fadeIn(500);
        break

        case 'updatePlayers':
            playersInfo = event.data.players;
            setEmployeesPage();
        break

        case 'dutymenu':
            locales = event.data.locales;
            isOnDuty = event.data.isOnDuty;
            dutyHours = JSON.parse(event.data.dutyHours);
            currentTime = event.data.time;
            setupDutyHours(dutyHours)
            $('#currentTimer').html(formatTime(event.data.time));
            setupUI();
            if (isOnDuty) { 
                $('#dutyTimerBtn').html(locales.gooffduty.toUpperCase()); 
                $('#dutyTimerBtn').css('background-color', '#dc3535')
            } else { 
                $('#dutyTimerBtn').html(locales.goonduty.toUpperCase()); 
                $('#dutyTimerBtn').css('background-color', '#1f5eff')
            }
            $('#dutyMenu').fadeIn(500);
        break

        case 'updateDutyTime':
            let eventTime = event.data.time;

            let totalPlayerTime = totalPlayerMinutes + eventTime;
            let totalPlayerHours = Math.floor(totalPlayerTime / 60);
            let totalPlayerMins = totalPlayerTime % 60;
            let totalPlayerTimeFormatted = `${totalPlayerHours.toString().padStart(2, '0')}:${totalPlayerMins.toString().padStart(2, '0')}`;

            let updatedTodayTime = todayTime + eventTime;
            let todayHours = Math.floor(updatedTodayTime / 60);
            let todayMins = updatedTodayTime % 60;
            let todayTimeFormatted = `${todayHours.toString().padStart(2, '0')}:${todayMins.toString().padStart(2, '0')}`;

            $('#currentTimer').html(formatTime(eventTime));
            $('#todayDate').html(todayTimeFormatted + ' ' + locales.hours);
            $('#totalHoursUser').html(totalPlayerTimeFormatted + ' ' + locales.hours);
        break;
    }
})


// Functions

function LocaleString(money) {
    return money.toLocaleString().replace(/,/g, ',') + currency;
}

function formatTime(seconds) {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    seconds = seconds % 60;

    return [hours, minutes, seconds]
        .map(v => v < 10 ? "0" + v : v)
        .filter((v,i) => v !== "00" || i > 0)
        .join(":");
}

function checkIfEmpty() {
    if ($('#deposit_amount').val() != "" && $('#deposit_amount').val() != 0 && $('#deposit_amount').val() > 0) {
        $('#deposit').prop('disabled', false);
    } else {
        $('#deposit').prop('disabled', true);
    }

    if ($('#withdraw_amount').val() != "" && $('#withdraw_amount').val() != 0 && $('#withdraw_amount').val() > 0) {
        $('#withdraw').prop('disabled', false);
    } else {
        $('#withdraw').prop('disabled', true);
    }
    if ($('#bonus-amount').val() != "" && $('#bonus-amount').val() != 0 && $('#bonus-amount').val() > 0) {
        $('#give-bonus').prop('disabled', false);
    } else {
        $('#give-bonus').prop('disabled', true);
    }
}

function setupUI() {
    $('#overview-text').html(locales.overview);
    $('#employees-text').html(locales.employees);
    $('#grades-text').html(locales.grades);
    $('#storage-text').html(locales.storage);
    $('#outfits-text').html(locales.outfits);
    $('#logout-text').html(locales.logout);
    $('#menu-title').html(locales.menu);
    $('#page-title-overview').html(locales.overview);
    $('#finances-title').html(locales.finances);
    $('#balance-title').html(locales.balance);
    $('#deposit-money').html(locales.deposit); 
    $('#withdraw-money').html(locales.withdraw);
    $('#employees-title').html(locales.employees);
    $('#total-title').html(locales.total);
    $('#online-title').html(locales.online);
    $('#most-active-employees-title').html(locales.mostActiveEmployees);
    $('#online-employees').html(onlinePlayers);
    $('#total-employees').html(totalPlayers);
    $('#company_balance').html(LocaleString(societyMoney));
    $('#deposit-money-title').html(locales.depositmoney);
    $('#withdraw-money-title').html(locales.withdrawmoney);
    $('#hire-employee-title').html(locales.hireEmployee);
    $('#deposit_amount').attr('placeholder', locales.amount);
    $('#withdraw_amount').attr('placeholder', locales.amount);
    $('#deposit').html(locales.deposit);
    $('#withdraw').html(locales.withdraw);
    $('#select-title').html(locales.selectperson);
    $('#hire_employee').html(locales.hire);
    $('#employee-name-title').html(locales.name);
    $('#employee-grade-title').html(locales.grade);
    $('#edit-employee-title').html(locales.editemployee);
    $('#fire_employee_btn').html('<i class="fas fa-trash"></i> ' + locales.fireemployee);
    $('#give_bonus_btn').html('<i class="fas fa-coins"></i> ' + locales.givebonus);
    $('#edit_employee').html(locales.save);
    $('#fire-employee-title').html(locales.fireemployee);
    $('#cancel_fire').html(locales.cancel);
    $('#fire_employee').html(locales.fire);
    $('#delete_grade').html(locales.delete);
    $('#dutyTimerBtn').html(locales.goonduty.toUpperCase());
    $('#inspect-performance-title').html(locales.performance);
    $('#inspect-name').html(locales.name);
    $('#inspect-status').html(locales.status);
    $('#inspect-total, #total-duty-title').html(locales.total);
    $('#inspect-last-seven-days').html(locales.lastsevendays);
    $('#duty-title').html(locales.duty);
    $('#last-online').html(locales.lastonline);
    $('#give-bonus-title').html(locales.givebonus);
    $('#bonus-amount-title').html(locales.amount + ' (' + currency + ')');
    $('#cancel-give-bonus').html(locales.cancel);
    $('#give-bonus').html(locales.confirm);
    $('#bonus-amount').attr('placeholder', 100);
}

function setupDutyHours(dutyHours) {
    let row = '';
    let totalMinutes = 0;

    for (let i = 0; i < dutyHours.length; i++) {
        let date = new Date(dutyHours[i].date);
        date.setHours(0, 0, 0, 0);
        let weekday = [locales.sunday, locales.monday, locales.tuesday, locales.wednesday, locales.thursday, locales.friday, locales.saturday][date.getDay()];
        if (dutyHours[i].today) {
            todayMinutes = dutyHours[i].minutes;
            weekday += ` <span class="gtext fs1">(${locales.today})</span>`;
        }
        let hours = Math.floor(dutyHours[i].minutes / 60);
        let minutes = dutyHours[i].minutes % 60;
        let time = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
        totalMinutes += dutyHours[i].minutes;
        let timeElement = dutyHours[i].today ? `<span id="todayDate" class="gtext dayHours">${time} ${locales.hours}</span>` : `<span class="gtext dayHours">${time} ${locales.hours}</span>`;
        row = `
        <div class="doftw2 mt-2">
            <span class="dayName">${weekday}</span>
            ${timeElement}
        </div>
        ` + row;
    }
    totalPlayerMinutes = totalMinutes;
    let totalHours = Math.floor(totalMinutes / 60);
    let remainingMinutes = totalMinutes % 60;
    let totalTime = `${totalHours.toString().padStart(2, '0')}:${remainingMinutes.toString().padStart(2, '0')}`;
    $('#dutyHoursUser').html(row);
    $('#totalHoursUser').html(`${totalTime} ${locales.hours}`);
}

function setOverviewPage() {
    $('#employees_page').removeClass('selected');
    $('#overview_page').addClass('selected');
    $('#page_info').html(`
    <div class="row">
        <div class="col col-md-6 d-flex justify-content-center pr05">
            <div class="card card-o w-100">
                <div class="card-header card-o-header text-center">
                    <span id="finances-title" class="card-o-title"></span>
                </div>
                <div class="card-body card-o-body finances_card-body text-center pt-025">
                    <div class="d-flex justify-content-center flex-column h-66">
                        <div id="balance-title" class="fff fs175"></div>
                        <div class="fs175" id="company_balance"></div>
                    </div>
                    <hr class="mg050 margin-05">
                    <button type="button" id="deposit-money" class="btn btn-blue w-100 mt-2 dep_with-buttons" data-bs-toggle="modal" data-bs-target="#depositModal"></button>
                    <button type="button" id="withdraw-money" class="btn btn-blue w-100 mt-2 dep_with-buttons" data-bs-toggle="modal" data-bs-target="#withdrawModal"></button>
                </div>
            </div>
        </div>
        <div class="col col-md-6 d-flex justify-content-center pl05">
            <div class="card card-o w-100">
                <div class="card-header card-o-header text-center">
                    <span id="employees-title" class="card-o-title"></span>
                </div>
                <div class="card-body card-o-body fuel_card-body text-center pt-025">
                    <div class="d-flex justify-content-center flex-column">
                        <div class="mt-12 mb-09">
                            <div id="total-title" class="fff fs175"></div>
                            <div id="total-employees" class="fs175"></div>
                        </div>
                        <hr class="mg050 margin-07">
                        <div class="mt-09">
                            <div id="online-title" class="fff fs175"></div>
                            <div id="online-employees" class="fs175"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="card card-o d-flex flex-column">
        <div class="card-header card-o-header text-center">
            <span id="most-active-employees-title" class="card-o-title"></span>
        </div>
        <div class="card-body card-o-body">
            <div id="three-employees" class="row h-100"></div>
        </div>
    </div>
    `);

    if (playersInfo && playersInfo.length > 0) {
        playersInfo.sort((a, b) => {
            var hoursA = a.totalDutyHours.split(':').map(Number);
            var hoursB = b.totalDutyHours.split(':').map(Number);
            return (hoursB[0]*60 + hoursB[1]) - (hoursA[0]*60 + hoursA[1]);
        });
    }

    let row = '';
    for (let i = 0; i < 3; i++) {
        if (playersInfo && playersInfo.length > 0 && playersInfo[i]) {
            var avatar = 'images/avatar_female.png';
            if (playersInfo[i].gender == 0) {  avatar = 'images/avatar_male.png'; }
            row += `
            <div class="col col-md-4 d-flex justify-content-center pr05">
                <div class="card emp-card w-100">
                    <div class="card-header card-o-header borderbot text-center">
                        <span class="slot_title">${playersInfo[i].name}</span>
                    </div>
                    <div class="card-body text-center emp_height">
                        <div class="used_slot">
                            <img src=${avatar} class="emp_img">
                        </div>
                        <div class="d-flex flex-column mt-03 fs1125">
                            <div>
                                <span class="fff">${locales.grade}:</span> ${playersInfo[i].gradeLabel}
                            </div>
                            <div>
                                <span class="fff">${locales.lastweek}:</span> ${playersInfo[i].totalDutyHours} ${locales.hours}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            `;
        } else {
            row += `
            <div class="col col-md-4 d-flex justify-content-center pr05">
                <div class="card emp-card w-100">
                    <div class="card-header card-o-header borderbot text-center">
                        <span class="slot_title">${locales.noinfoavailable}</span>
                    </div>
                    <div class="card-body text-center emp_height">
                        <div class="used_slot">
                            <img src=${avatar} class="emp_img">
                        </div>
                        <div class="d-flex flex-column mt-03 fs1125">
                            <div>
                                <span class="fff">${locales.grade}:</span> ${locales.nodata}
                            </div>
                            <div>
                                <span class="fff">${locales.lastweek}:</span> ${locales.nodata}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            `;
        }
    }
    $('#three-employees').html(row);
    setupUI();
}

function setEmployeesPage() {
    $('#employees_page').addClass('selected');
    $('#overview_page').removeClass('selected');
    $('#page_info').html(`
    <div class="d-flex">
        <button id="getNearPlayers" type="button" class="btn btn-blue hire-emp">${locales.hireEmployee}</button>
    </div>
    <table id="employeesTable" class="mt-025">
        <thead>
            <tr>
                <th class="text-center">${locales.name}</th>
                <th class="text-center">${locales.grade}</th>
                <th class="text-center">${locales.hours}</th>
                <th class="text-center">${locales.actions}</th>
            </tr>
        </thead>
        <tbody id="employeesTableData">
        </tbody>
    </table>
    `);

    let row = '';

    playersInfo.sort((a, b) => {
        if (a.online && !b.online) {
            return -1;
        }
        if (!a.online && b.online) {
            return 1;
        }
        if (a.online == b.online) {
            if (a.grade > b.grade) {
                return -1;
            }
            if (a.grade < b.grade) {
                return 1;
            }
        }
        return 0;
    });

    for (let i = 0; i < playersInfo.length; i++) {
        if (playersInfo[i]) {
            var online = playersInfo[i].online ? 'onduty' : 'offduty';
            var hoursMinutes = playersInfo[i].totalDutyHours.split(':').map(Number);
            var roundedHours = Math.round((hoursMinutes[0] + hoursMinutes[1] / 60));
            const editLabel = locales.edit.toUpperCase();
            row += `
            <tr>
                <td class="text-center align-middle"><span class="emp-status ${online}"></span>&nbsp;&nbsp;${playersInfo[i].name}</td>
                <td class="text-center align-middle">${playersInfo[i].gradeLabel}</td>
                <td class="text-center align-middle">${roundedHours} <span class="inspect-hours" onClick="inspectHours('${playersInfo[i].citizenid}')" data-bs-toggle="modal" data-bs-target="#inspectHoursModal"><i class="fa-solid fa-magnifying-glass"></i></span></td>
                <td class="text-center align-middle"><button type="button" class="btn btn-blue btn-editemployee" onClick="editEmployee('${playersInfo[i].citizenid}')" data-bs-toggle="modal" data-bs-target="#editEmployeeModal"><i class="fa-solid fa-pen-to-square"></i> ${editLabel}</button></td>
            </tr>
            `;
        }
    }
    $('#employeesTableData').html(row);   

    var table_id = document.getElementById('employeesTable');
    table.push(new simpleDatatables.DataTable(table_id, {
        perPageSelect: false,
        perPage: 6,
    }));
}

async function inspectHours(citizenid) {
    for (let i = 0; i < playersInfo.length; i++) {
        if (playersInfo[i].citizenid == citizenid) {
            targetCitizenID = playersInfo[i].citizenid;
            var isOnline = playersInfo[i].online ? 'onduty' : 'offduty';
            if (isOnline == 'onduty') { $('#inspectHoursStatus').html(locales.online); } else { $('#inspectHoursStatus').html(locales.offline); }
            $('#inspectHoursName').html(playersInfo[i].name);
            $('#last-online-time').html(playersInfo[i].lastOnline);
            var playerHours = await retrieveNUI('getPlayerHours', { citizenID: targetCitizenID });
            playerHours = JSON.parse(playerHours);
            let row = '';
            let totalMinutes = 0;
            
            for (let j = 0; j < playerHours.length; j++) {
                let date = new Date(playerHours[j].date);
                date.setHours(0, 0, 0, 0);
                let weekday = [locales.sunday, locales.monday, locales.tuesday, locales.wednesday, locales.thursday, locales.friday, locales.saturday][date.getDay()];
                if (playerHours[j].today) {
                    weekday += ` <span class="gtext fs1">(${locales.today})</span>`;
                }
                let hours = Math.floor(playerHours[j].minutes / 60);
                let minutes = playerHours[j].minutes % 60;
                let time = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
                totalMinutes += playerHours[j].minutes;
                row = `
                <div class="doftw">
                    <span class="inspectHoursDay">${weekday}</span>
                    <span class="gtext inspectHoursTime">${time} ${locales.hours}</span>
                </div>
                ` + row;
            }
            let totalHours = Math.floor(totalMinutes / 60);
            let remainingMinutes = totalMinutes % 60;
            let totalTime = `${totalHours.toString().padStart(2, '0')}:${remainingMinutes.toString().padStart(2, '0')}`;
            $('#inspectHoursDays').html(row);
            $('#inspectHoursTotal').html(`${totalTime} ${locales.hours}`);
        }
    }
}

function editEmployee(citizenid) {
    for (let i = 0; i < playersInfo.length; i++) {
        if (playersInfo[i].citizenid == citizenid) {
            targetCitizenID = playersInfo[i].citizenid;
            let grades = '', grade = '', playerGradeOption = '';
            Object.keys(jobGrades).forEach((key) => {
                if (playersInfo[i] && key == playersInfo[i].grade) {
                    targetPlayerGrade = key;
                    playerGradeOption = `<option value="${key}">${jobGrades[key].label} (${locales.grade} ${key})</option>`;
                } else {
                    grade += `<option value="${key}">${jobGrades[key].label} (${locales.grade} ${key})</option>`;
                }
            });
            targetPlayerName = playersInfo[i].name;
            grades = playerGradeOption + grade;
            $('#dropdownGrade').html(grades).prop('disabled', false);
            $('#employee_name').val(playersInfo[i].name);
            $('#fire-player-message').html(`${locales.wanttofire} <span id="firePlayerName">${playersInfo[i].name}</span>?`);
            $('#fire_employee_btn').removeClass('disabled').css({ 'pointer-events': '', 'opacity': '', 'cursor': '' });
            $('#fire_employee_btn').attr('data-bs-toggle', 'modal').attr('data-bs-target', '#fireEmployeeModal').attr('data-bs-dismiss', 'modal');
            $('#edit_employee').attr('disabled', 'disabled');
            break;
        }
    }
}

// Event Listeners

$(document).on('click', "#edit_employee", async function() {
    let rank = $('#dropdownGrade').val();
    let targetPlayerGradeLabel = '';
    let isBoss = false;
    Object.keys(jobGrades).forEach((key) => {
        if (key == rank || String(jobGrades[key].grade) === String(rank) || String(jobGrades[key].rank) === String(rank)) {
            targetPlayerGradeLabel = jobGrades[key].label;
            if (jobGrades[key].name == 'boss') {
                isBoss = true;
            }
        }
    });
    if (playerCitizenID == targetCitizenID) {
        retrieveNUI('cantEditSelf')
        return;
    }
    let players = await retrieveNUI('editEmployee', { citizenid: targetCitizenID, grade: rank, targetPlayerName: targetPlayerName, gradeLabel: targetPlayerGradeLabel, isBoss: isBoss});
    playersInfo = players;
    setEmployeesPage();
    $("#edit_employee").attr("disabled", "disabled");
});

$(document).on('click', "#fire_employee", async function() {
    if (playerCitizenID == targetCitizenID) {
        retrieveNUI('cantFireSelf')
        return;
    }
    let players = await retrieveNUI('fireEmployee', { citizenid: targetCitizenID, targetPlayerName: targetPlayerName });
    playersInfo = players;
    setEmployeesPage();
    $("#fire_employee").attr("disabled", "disabled");
});

$(document).on('click', "#deposit", async function() {
    var amount = $('#deposit_amount').val();
    var money = await retrieveNUI('depositMoney', { amount: amount, society: playerJob, societyLabel: playerJobLabel });
    if (!money) { return; }
    societyMoney = money;
    $('#company_balance').html(LocaleString(societyMoney));
    $('#deposit_amount').val('');
    $('#deposit').prop('disabled', true);
});

$(document).on('click', "#withdraw", async function() {
    var amount = $('#withdraw_amount').val();
    var money = await retrieveNUI('withdrawMoney', { amount: amount, society: playerJob, societyLabel: playerJobLabel });
    if (!money) { return; }
    societyMoney = money;
    $('#company_balance').html(LocaleString(societyMoney));
    $('#withdraw_amount').val('');
    $('#withdraw').prop('disabled', true);
});

$(document).on('click', "#getNearPlayers", async function() {
    var players = await retrieveNUI('getClosePeople');
    if (!players) { return; }
    var num = players.length;
    var dropdown = ``;
    dropdown += `<option value="${0}">${locales.selectuser}</option>`;
    if(num > 0){
        $('#hireEmployeeModal').modal('toggle');

        for(var i = 0; i < num; i++) {
            dropdown += `
                <option value="${players[i].id}">${players[i].name} (${players[i].id})</option>
            `;
        }
    }
    $('#dropdown_to_hire').html(dropdown);
});

$(document).on('click', "#hire_employee", async function() {
    var hiredPerson = $('#dropdown_to_hire').val();
    var players = await retrieveNUI('hireEmployee', { citizenid: hiredPerson });
    playersInfo = players;
    setEmployeesPage();
});

$(document).on('click', "#storage_page", function() {
    retrieveNUI('openStorage', { job: playerJob })
    $('#bossMenu').fadeOut(500);
});

$(document).on('click', "#outfits_page", function() {
    retrieveNUI('openClothing')
    $('#bossMenu').fadeOut(500);
});

$(document).on('click', "#logout-btn", function() {
    $('#bossMenu').fadeOut(500);
    retrieveNUI('close')
});

$(document).on('click', "#employees_page", function() {
    $('#page_info').html('');
    setEmployeesPage();
});

$(document).on('click', "#overview_page", function() {
    $('#page_info').html('');
    setOverviewPage();
});

$(document).on('click', "#closeDutyMenu", function() {
    $('#dutyMenu').fadeOut(500);
    retrieveNUI('close')
});

$("#dropdownGrade").change(function() {
    let rank = $(this).val();
    if (rank != targetPlayerGrade) {
        $("#edit_employee").removeAttr("disabled");
    } else if (rank == targetPlayerGrade) {
        $("#edit_employee").attr("disabled", "disabled");
    }
});

$("#dropdown_to_hire").change(function() {
    var hireValue = $(this).val();
    if (hireValue != 0) {
        $("#hire_employee").removeAttr("disabled");
    } else if (hireValue == 0) {
        $("#hire_employee").attr("disabled", "disabled");
    }
});

$(document).ready(function() {
    document.onkeyup = function(event) {
        if (event.code == "Escape") {
            $('#bossMenu').fadeOut(500);
            $('#dutyMenu').fadeOut(500);
            retrieveNUI('close')
        }
    };
});

$(document).on('click', "#dutyTimerBtn", function() {
    isOnDuty = !isOnDuty;
    retrieveNUI('startDuty')
    if (isOnDuty) {
        $('#dutyTimerBtn').html(locales.gooffduty.toUpperCase());
        $('#dutyTimerBtn').css('background-color', '#dc3535')
    } else {
        $('#dutyTimerBtn').html(locales.goonduty.toUpperCase());
        $('#dutyTimerBtn').css('background-color', '#1f5eff')
        $('#currentTimer').html('00:00');
        var finalTime = currentTime + todayMinutes;
        var finalTimeFormatted = formatTime(finalTime) + ' ' + locales.hours;
        $('#todayDate').html(finalTimeFormatted);
    }
});

$(document).on('click', "#give-bonus", async function() {
    var bonusAmount = $('#bonus-amount').val();
    var money = await retrieveNUI('giveBonus', { citizenid: targetCitizenID, amount: bonusAmount, targetName: targetPlayerName, job: playerJob, jobLabel: playerJobLabel });
    if (!money) { return; }
    societyMoney = money;
    $('#company_balance').html(LocaleString(societyMoney));
    $('#bonus-amount').val('');
    $('#give-bonus').prop('disabled', true);
});