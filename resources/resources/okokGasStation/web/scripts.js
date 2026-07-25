var closePeopleList = [];
var vehicleList = [];
var table = [];

var salesHistoryList = {};
var employeesList = {};
var capacityList = {};
var ordersList = {};
var vehicles = {};
var ranks = {};

var	modalEmployeeTotalOrders = "";
var fireEmployeeNameChange = "";
var	modalEmployeeGrade = "";
var modalVehicleLabel = "";
var modalVehiclePrice = "";
var modalEmployeeName = "";
var orderLongVehicle = "";
var playerRankLabel = "";
var employeeCitizen = "";
var selectedWindow = "";
var vehicleLabel = "";
var firstOwner = "";
var playerName = "";
var employeeID = "";
var vehicleID = "";
var currency = "";
var storeID = "";
var name = "";

var stockToUpdatePrice = 0;
var percentageStock = 0;
var maxConfigStock = 0;
var businessPrice = 0;
var stockToUpdate = 0;
var fuelToVehicle = 0;
var fuelAvailable = 0;
var currentStock = 0;
var orderLiters = 0;
var orderVehicle = 0;
var playerRank = 0;
var priceToPay = 0;
var orderPrice = 0;
var storeMoney = 0;
var fuelPrice = 0;
var maxStock = 0;
var gasPrice = 0;
var oldFuel = 0;
var rank = 0;

var tid = undefined;

var isSubOwner = false;
var currencyOnLeft = false;
var isOwner = false;
var hasOwner = false;

window.addEventListener('message', function(event) {
	switch (event.data.action) {
		case 'loading':
			selectedWindow = "loading";
			$('.loading').fadeIn();
			break

		case 'overview':
			isOwner = false;
			currency = event.data.userCurrency
			currencyOnLeft = event.data.currencySide
			playerName = event.data.playerName
			storeMoney = event.data.storeMoney
			gasPrice = event.data.gasPrice
			storeID = event.data.storeID
			currentStock = event.data.currentStock
			maxStock = event.data.maxStock
			maxConfigStock = event.data.maxConfigStock
			percentageStock = Math.floor(event.data.percentageStock);
			vehicleList = event.data.vehicleList
			capacityList = event.data.capacityList
			employeesList = event.data.employeesList
			ranks = event.data.ranks
			salesHistoryList = event.data.salesHistoryList
			ordersList = event.data.ordersList
			employeeCitizen = event.data.playerID;
			firstOwner = event.data.firstOwner;
			var secondOwner = event.data.secondOwner;
			if (maxStock == maxConfigStock) {
				document.getElementById("increase_capacity").disabled = true;
				document.getElementById("increase_capacity").textContent = "Dostignut maksimalni kapacitet";
			}
			for(var i = 0; i < employeesList.length; i++) {
				if (employeesList[i].identifier == employeeCitizen) {
						playerRank = employeesList[i].rank;
					if (employeesList[i].rank == secondOwner ) {
                        isSubOwner = true;
					}	  
				}
			}
			for (var i = 0; i < ranks.length; i++) {
				if (playerRank == ranks[i].rank) {
					playerRankLabel = ranks[i].label.toUpperCase();
				}
			}
			if (firstOwner == employeeCitizen) { isOwner = true; playerRankLabel = "VLASNIK"; };
				
			orderList();
			if (event.data.playerSex == "0") {
				avatar = `<img src="./img/avatar_male.png" class="avatar">`;
			} else {
				avatar = `<img src="./img/avatar_female.png" class="avatar">`;
			}

			if (isOwner == true || isSubOwner == true) {
				if (selectedWindow == "loading") {
					openOverview();
					$(".overview").fadeIn();
				}
				setTimeout(function() {
					$('.loading').fadeOut();
				}, 300);
					selectedWindow = "overview";
					businessPrice = event.data.businessPrice
					$(`#business_sell_price`).html(businessPrice + currency);
					sendCapacityList();
				break
			} else {
				if (selectedWindow == "loading") {
					openOrders();
					$(".orders").fadeIn();
				}
				setTimeout(function() {
					$('.loading').fadeOut();
				}, 300);
					selectedWindow = "orders";
				break
			}


		case 'buyBusiness':
			selectedWindow = "buyBusiness";
			$("#shop_price").html(`${numberWithSpaces(event.data.price)}`  + event.data.currency);
			$("#shop_name").html(event.data.road + ' ' + event.data.name);
			var modalId = $('#buybusiness_modal');
	    	var buyBusinessModal = new bootstrap.Modal(modalId);
	    	buyBusinessModal.show();
			break

		case 'updateMoney':
			storeMoney = event.data.storeMoney
			$("#company_balance").html(event.data.storeMoney + currency);
			break

		case 'defaultGasPrice':
			$(".change_price_pl").val(event.data.storeMoney);
			break

		case 'updateCapacityValues':
			maxStock = event.data.totalStock;
			storeMoney = event.data.priceToUpdate;
			$("#company_balance").html(storeMoney + currency);
            var percentageStockUpdated = Math.floor(event.data.percentageStock);
			$('#stock_info').html(`${percentageStockUpdated}% - ${currentStock}/<span class="increase_capacity">${maxStock}</span>L`);
			const CapacityBtn = document.getElementById("increase_capacity");
			var totalCapacity = maxStock + stockToUpdate;
			CapacityBtn.innerHTML = `${maxStock}L <i class="fas fa-arrow-right"></i> ${totalCapacity}L <b>(${capacityList[0].price}${currency})</b>`;
			if (maxStock == maxConfigStock) {
				document.getElementById("increase_capacity").disabled = true;
				document.getElementById("increase_capacity").textContent = "Dostignut maksimalni kapacitet";
			}
			break

		case 'updateInfo':

			storeMoney = event.data.MoneyToUpdate;
			vehicleList = event.data.vehicleList
			$("#company_balance").html(event.data.MoneyToUpdate + currency);

			const button = document.querySelector(`#${event.data.VehicleIDToUpdate}`);
			button.innerHTML = 'Owned';
			button.setAttribute("disabled", "");
			break

		case 'updateNearPlayers':		
			nearPlayers = event.data.nearPlayers;
			var num = nearPlayers.length;
			var dropdown = ``;
			dropdown += `<option value="${0}">Select a person</option>`;
			if(num > 0){

				$('#hireEmployeeModal').modal('toggle');
				
				for(var i = 0; i < num; i++) {
					dropdown += `
						<option value="${nearPlayers[i].id}">${nearPlayers[i].name} (${nearPlayers[i].id})</option>
					`;
				}
			} 
			
			$('#dropdown_to_hire').html(dropdown);
			break

		case 'updateEmployees':
			employeesList = event.data.employeesList;
			openEmployees();
			break

		case 'updateOrders':
			ordersList = event.data.ordersList;
			openOrders();
			break

		case 'refuelVehicle':
			currency = event.data.userCurrency;
			currencyOnLeft = event.data.currencySide;
			hasOwner = event.data.hasOwner;
			fuelToVehicle = event.data.fuelToVehicle;
			priceToPay = event.data.priceToPay;
			storeID = event.data.storeID;
			fuelPrice = event.data.fuelPrice;
			oldFuel = event.data.oldFuel;
			fuelAvailable = event.data.fuelAvailable;
			openRefuel();
			break

		case 'refuelJerrycan':
			currency = event.data.userCurrency;
			currencyOnLeft = event.data.currencySide;
			hasOwner = event.data.hasOwner;
			fuelToVehicle = event.data.fuelToVehicle;
			priceToPay = event.data.priceToPay;
			storeID = event.data.storeID;
			fuelPrice = event.data.fuelPrice;
			oldFuel = event.data.oldFuel;
			fuelAvailable = event.data.fuelAvailable;
			openRefuelJerrycan();
			break

		case 'closeMenu':
			closeMenu();
			break
	}
})



// Global Functions

function numberWithSpaces(x) {
	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function checkIfEmpty() {

	if (document.getElementById("deposit_money").value != "" && document.getElementById("deposit_money").value > 0) {
		document.getElementById('deposit').disabled = false;
	} else {
		document.getElementById('deposit').disabled = true;
	}
	if (document.getElementById("withdraw_money").value != "" && document.getElementById("withdraw_money").value > 0) {
		document.getElementById('withdraw').disabled = false;
	} else {
		document.getElementById('withdraw').disabled = true;
	}
}	


// Overview, Cars and Capacity

function openOverview() {
	selectedWindow = "overview";
	$('#overview_menu').html(``);
	$('#overview_menu').append(`
	<div class="row h-100" id="menu">
		<div class="col-md-2 d-flex flex-column sidebar-s">
			<img src="./img/logo.png" class="logo">
			<hr>
			<span class="sidebar-title">Meni</span>
			<div id="sidebarOverview">
				<p class="sidebar-item mt-2 selected" id="overview_page"><i class="bi bi-grid-1x2-fill"></i> <span class="ms-1">Pregled</span></p>
				<p class="sidebar-item" id="orders_page"><i class="fas fa-map-location-dot"></i> <span class="ms-1">Narudžbe</span></p>
				<p class="sidebar-item" id="employees_page"><i class="fas fa-user-friends"></i> <span class="ms-1">Zaposleni</span></p>
				<p class="sidebar-item" id="saleshistory_page"><i class="fas fa-chart-column"></i> <span class="ms-1">Istorija prodaje</span></p>
			</div>
			<p id="close_overview" class="sidebar-item mt-auto logout"><i class="fas fa-sign-out-alt"></i></i> <span class="ms-1">Izlaz</span></p>
		</div>
		<div class="col-md-10 tab-s">
			<div class="d-flex justify-content-between align-items-center">
				<span class="selected-page"><span id="page-title">Pregled</span></span>
				<div>
					<span class="username align-middle">
						<span id="playerName">${playerName}</span> <span id="avatar">${avatar}</span>
						<div class="grade">${playerRankLabel}</div>
					</span>
				</div> 
			</div>
			<hr>
			<div class="d-flex flex-column" id="page_info">
				<div class="row">
					<div class="col col-md-6 d-flex justify-content-center pr05">
						<div class="card card-o w-100">
							<div class="card-header card-o-header text-center">
								<span class="card-o-title">Finansije</span>
							</div>
							<div class="card-body card-o-body finances_card-body text-center pt-025">
								<div class="d-flex justify-content-center flex-column">
									<div id="balance_currency_side" class="mt-12 mb-09">
									</div>
								</div>
								<hr class="mg050">
								<button type="button" class="btn btn-blue w-100 mt-2 dep_with-buttons" data-bs-toggle="modal" data-bs-target="#depositModal">Uplati</button>
								<button type="button" class="btn btn-blue w-100 mt-2 dep_with-buttons" data-bs-toggle="modal" data-bs-target="#withdrawModal">Podigni</button>
							</div>
						</div>
					</div>
					<div class="col col-md-6 d-flex justify-content-center pl05">
						<div class="card card-o w-100">
							<div class="card-header card-o-header text-center">
								<span class="card-o-title">Gorivo</span>
							</div>
							<div class="card-body card-o-body fuel_card-body text-center pt-025">
								<div class="d-flex justify-content-center flex-column">
									<div class="mt-12 mb-09">
										<div class="fff fs175">Ukupan kapacitet</div>
										<div class="fs175" id="stock_info" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#increaseCapacityModal">${percentageStock}% - ${currentStock}/<span class="increase_capacity">${maxStock}</span>L</div>
									</div>
									<hr class="mg050">
									<div id="set_price_per_liter" class="mt-09">
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="card card-o d-flex flex-column">
					<div class="card-header card-o-header text-center">
						<span class="card-o-title">Vozila</span>
					</div>
					<div class="card-body card-o-body">
					<div  id="car_list" class="row h-100">
					</div>
					</div>
				</div>
			</div>
		</div>
	</div>
`);

	if ( currencyOnLeft == true ) {
		$('#balance_currency_side').append(`
			<div class="fff fs175">Stanje</div>
			<div class="fs175" id="company_balance">${currency}${storeMoney}</div>
		`);
		$('#set_price_per_liter').append(`
			<div class="fff fs175">Cena po litru</div>
			<div class="fs175">${currency}<input type="number" pattern="[0-9]+\.[0-9]{2}" maxlength="5" class="change_price_pl" data-name="${gasPrice}" data-business_id = "${storeID}" value="${gasPrice}"></div>
		`);
	} else {
		$('#balance_currency_side').append(`
			<div class="fff fs175">Stanje</div>
			<div class="fs175" id="company_balance">${storeMoney}${currency}</div>
		`);
		$('#set_price_per_liter').append(`
			<div class="fff fs175">Cena po litru</div>
			<div class="fs175"><input type="number" pattern="[0-9]+\.[0-9]{2}" maxlength="5" class="change_price_pl" data-name="${gasPrice}" data-business_id = "${storeID}" value="${gasPrice}">${currency}</div>
		`);
	}
	
	if ( isOwner == true ) {
		$('#sidebarOverview').append(`
		<p class="sidebar-item-red" id="sell_business" data-bs-toggle="modal" data-bs-target="#sellbusiness_modal"><i class="fas fa-building"></i> <span class="ms-1">Prodaj firmu</span></p>
		`);
	}

	sendVehiclesToOverview()
}


// Send vehicles to overview menu

function sendVehiclesToOverview() {

	cardToAdd = ``;
	$('#car_list').html(``);

	for(var i = 0; i < vehicleList.length; i++) {
		let label = vehicleList[i].label;
		let name = vehicleList[i].vehicleid;
		let capacity = vehicleList[i].capacity;
		let price =  vehicleList[i].price;
		let owned = '';
		let buttonText = price + currency;
		let buttonTextLeft = currency + price;
		let vehicleID = 'vehicle_' + i;
		vehicles[vehicleID] = vehicleID;
		let classes = 'pr05';

		if (vehicleList[i].owned == true) {
			owned = 'disabled';
			buttonText = 'Kupljeno';
		} 

		if(i == 0){
			classes = 'pr05';
		} else if(i == 1){
			classes = 'pl05 pr05';
		} else if(i == 2){
			classes = 'pl05';
		}

		if ( currencyOnLeft == true ) {
			cardToAdd += `
					<div class="col col-md-4 d-flex justify-content-center ${classes}">
						<div class="card veh-card w-100">
							<div class="card-header card-o-header veh_borderbot text-center">
								<span class="veh_slot_title">${label} (${capacity}L)</span>
							</div>
							<div class="card-body text-center veh_height">
								<div class="used_slot">
									<img src="./img/${name}.png" class="veh_img">
								</div>
								<div class="d-flex mt-09">
									<button type="button" id=${name} data-bs-toggle="modal" data-bs-target="#buyvehicle_modal" class="btn btn-blue veh_btn w-100" value=${price} ${owned} onClick="buyVehicle('${name}')">${buttonTextLeft}</button>
								</div>
							</div>
						</div>
					</div>
					`;
			vehicles[`vehicle_${i}`] = name;
		} else {
			cardToAdd += `
			<div class="col col-md-4 d-flex justify-content-center ${classes}">
				<div class="card veh-card w-100">
					<div class="card-header card-o-header veh_borderbot text-center">
						<span class="veh_slot_title">${label} (${capacity}L)</span>
					</div>
					<div class="card-body text-center veh_height">
						<div class="used_slot">
							<img src="./img/${name}.png" class="veh_img">
						</div>
						<div class="d-flex mt-09">
							<button type="button" id=${name} data-bs-toggle="modal" data-bs-target="#buyvehicle_modal" class="btn btn-blue veh_btn w-100" value=${price} ${owned} onClick="buyVehicle('${name}')">${buttonText}</button>
						</div>
					</div>
				</div>
			</div>
			`;
			vehicles[`vehicle_${i}`] = name;
		}
	}

	$('#car_list').append(cardToAdd);

}


// Change the variables to buy the vehicle

function buyVehicle(name) {
    for (let i = 0; i < vehicleList.length; i++) {
        if (vehicleList[i].vehicleid == name) {

            modalVehicleLabel = vehicleList[i].label;
            modalVehiclePrice = vehicleList[i].price;
            vehicleID = vehicleList[i].vehicleid;
            changeBuyVehicleModalInfo();
        }
    };
}


// Change the modal info to buy the vehicle

function changeBuyVehicleModalInfo() {
	if ( currencyOnLeft == true ) {
		$('#vehicle_price').html(``);
		$('#vehicle_price').append(`<b>${modalVehicleLabel}</b> (${currency}${modalVehiclePrice})`);
	} else {
		$('#vehicle_price').html(``);
		$('#vehicle_price').append(`<b>${modalVehicleLabel}</b> (${modalVehiclePrice}${currency})`);
	}	
} 


// Send the capacity list from the config to the select

function sendCapacityList() {

	$('#dropdown_capacity').html(``);
	optionToAdd = ``;

	for(var i = 0; i < capacityList.length; i++) {

		let capacity = capacityList[i].capacity;

		optionToAdd += `
				<option value="${capacity}">${capacity}L</option>
		`;

	}

	$('#dropdown_capacity').append(optionToAdd);

	const CapacityBtn = document.getElementById("increase_capacity");
	var toUpdate = parseInt(capacityList[0].capacity) + parseInt(maxStock);
	if (maxStock == maxConfigStock) {
		CapacityBtn.innerHTML = `Dostignut maksimalni kapacitet`;
	} else {
		CapacityBtn.innerHTML = `${maxStock}L <i class="fas fa-arrow-right"></i> ${toUpdate}L <b>(${capacityList[0].price}${currency})</b>`;
	}

	stockToUpdate = parseInt(capacityList[0].capacity);
	stockToUpdatePrice = capacityList[0].price;
} 


// Orders Table

function openOrders() {
	selectedWindow = "orders";
	$('#orders_menu').html(``);
	$('#orders_menu').append(`
	<div class="row h-100" id="menu">
		<div class="col-md-2 d-flex flex-column sidebar-s">
			<img src="./img/logo.png" class="logo">
			<hr>
			<span class="sidebar-title">Meni</span>
			<div id="sidebarOrderMenu">
			</div>
			<p id="close_overview" class="sidebar-item mt-auto logout"><i class="fas fa-sign-out-alt"></i></i> <span class="ms-1">Izlaz</span></p>
		</div>
		<div class="col-md-10 tab-s">
			<div class="d-flex justify-content-between align-items-center">
				<span class="selected-page"><span id="page-title">Narudžbe</span></span>
				<div>
					<span class="username align-middle">
					<span id="playerName">${playerName}</span> <span id="avatar">${avatar}</span>
						<div id="playerGrade" class="grade">${playerRankLabel}</div>
					</span>
				</div>
			</div>
			<hr>
			<div class="d-flex flex-column gap0" id="page_info">
			<div id="createOrders" class="d-flex">
			</div>
			<table id="ordersTable" class="mt-025">
				<thead>
					<tr>
						<th class="text-center">Litri</th>
						<th class="text-center">Nagrada</th>
						<th class="text-center">Zaposleni</th>
						<th class="text-center">Akcije</th>
					</tr>
				</thead>
				<tbody id="ordersTableData">
				</tbody>
			</table></div>
		</div>
	</div>
	`)

	if (isOwner == true ) {
		$('#sidebarOrderMenu').html(`
		<p class="sidebar-item mt-2" id="overview_page"><i class="bi bi-grid-1x2-fill"></i> <span class="ms-1">Pregled</span></p>
		<p class="sidebar-item selected"><i class="fas fa-map-location-dot"></i> <span class="ms-1">Narudžbe</span></p>
		<p class="sidebar-item" id="employees_page"><i class="fas fa-user-friends"></i> <span class="ms-1">Zaposleni</span></p>
		<p class="sidebar-item" id="saleshistory_page"><i class="fas fa-chart-column"></i> <span class="ms-1">Istorija prodaje</span></p>
		<p class="sidebar-item-red" id="sell_business" data-bs-toggle="modal" data-bs-target="#sellbusiness_modal"><i class="fas fa-building"></i> <span class="ms-1">Prodaj firmu</span></p>
		`)
		$('#createOrders').html(`
		<button type="button" class="btn btn-blue hire-emp" data-bs-toggle="modal" data-bs-target="#newOrderModal">Nova narudžba</button>
		`)
	} else if (isSubOwner == true ) {
		$('#sidebarOrderMenu').html(`
		<p class="sidebar-item mt-2" id="overview_page"><i class="bi bi-grid-1x2-fill"></i> <span class="ms-1">Pregled</span></p>
		<p class="sidebar-item selected"><i class="fas fa-map-location-dot"></i> <span class="ms-1">Narudžbe</span></p>
		<p class="sidebar-item" id="employees_page"><i class="fas fa-user-friends"></i> <span class="ms-1">Zaposleni</span></p>
		<p class="sidebar-item" id="saleshistory_page"><i class="fas fa-chart-column"></i> <span class="ms-1">Istorija prodaje</span></p>
		`)
		$('#createOrders').html(`
		<button type="button" class="btn btn-blue hire-emp" data-bs-toggle="modal" data-bs-target="#newOrderModal">Nova narudžba</button>
		`)
	} else {
		$('#sidebarOrderMenu').html(`
		<p class="sidebar-item selected"><i class="fas fa-map-location-dot"></i> <span class="ms-1">Narudžbe</span></p>
		<p class="sidebar-item-red" id="fire_myself" data-bs-toggle="modal" data-bs-target="#firemyself_modal"><i class="fas fa-user-tie"></i> <span class="ms-1">Daj otkaz</span></p>
		`)
		document.getElementById('createOrders').style.marginTop = '2.685rem';
	}

	$('#ordersTableData').html(``)

	
		var row = ``
		for (var i = 0; i < ordersList.length; i++) {
			if (ordersList[i].in_progress == 0) {
				row += `
				<tr>
					<td class="text-center align-middle">${ordersList[i].liters}L</td>
					<td class="text-center align-middle">${ordersList[i].reward}${currency}</td>
					<td class="text-center align-middle">${ordersList[i].employee_name}</td>
					<td class="text-center align-middle"><button type="button" class="btn btn-blue btn-acceptorder" onClick="acceptOrder('${ordersList[i].id}')"><i class="fas fa-check"></i> PRIHVATI</button></td>
				</tr>
					</tr>
				`;
			} else {
				if (ordersList[i].employee_id == employeeCitizen) {
					row += `
					<tr>
						<td class="text-center align-middle">${ordersList[i].liters}L</td>
						<td class="text-center align-middle">${ordersList[i].reward}${currency}</td>
						<td class="text-center align-middle">${ordersList[i].employee_name}</td>
						<td class="text-center align-middle"><button type="button" class="btn btn-red btn-acceptorder" onClick="stopOrder('${ordersList[i].id}')"><i class="fas fa-xmark"></i> OTKAŽI</button></td>
					</tr>
						</tr>
					`;
				} else {
					row += `
					<tr>
						<td class="text-center align-middle">${ordersList[i].liters}L</td>
						<td class="text-center align-middle">${ordersList[i].reward}${currency}</td>
						<td class="text-center align-middle">${ordersList[i].employee_name}</td>
						<td class="text-center align-middle"><button type="button" class="btn btn-blue btn-acceptorder" onClick="acceptOrder('${ordersList[i].id}')" disabled><i class="fas fa-check"></i> PRIHVAĆENO</button></td>
					</tr>
						</tr>
					`;
				} 
			}
		} 
	$('#ordersTableData').append(row);

	var table_id = document.getElementById('ordersTable');
	table.push(new simpleDatatables.DataTable(table_id, {
		perPageSelect: false,
		perPage: 6,
		labels: {
			placeholder: "Pretraga...",
			noRows: "Nema unosa",
			noResults: "Nema rezultata za pretragu",
		}
	}));
}

function orderList() {
	$('#dropdownOrders').html(``);
	var dropdown = ``;
	dropdown += `<option value="${0}">Izaberi narudžbu</option>`;
	if(vehicleList.length > 0){
	
		for(var i = 0; i < vehicleList.length; i++) {
			dropdown += `
				<option value="${vehicleList[i].price}">${vehicleList[i].label} (${vehicleList[i].capacity}L) - ${vehicleList[i].orderPrice}${currency}</option>
			`;
		}
	} 
	
	$('#dropdownOrders').html(dropdown);
} 


// Accept order 

function acceptOrder(order) {
    for (let i = 0; i < ordersList.length; i++) {
        if (ordersList[i].id == order) {

            var orderID = ordersList[i].id;
			var orderVehicleID = ordersList[i].vehicle;
			var orderAmount = ordersList[i].liters;
			var orderReward = ordersList[i].reward;
			var longVehicle = ordersList[i].long_vehicle;

			$.post('https://okokGasStation/action', JSON.stringify({
				action: "acceptOrder",
				orderID: orderID,
				StoreID: storeID,
				orderVehicleID: orderVehicleID,
				longVehicle: longVehicle,
				orderAmount: orderAmount,
				orderReward: orderReward
			}));
        }
    };
}


// Stop order

function stopOrder(order) {
    for (let i = 0; i < ordersList.length; i++) {
        if (ordersList[i].id == order) {

			var orderID = ordersList[i].id;

			$.post('https://okokGasStation/action', JSON.stringify({
				action: "stopOrder",
				storeID: storeID,
				orderID: orderID
			}));

        }
    };
}


// Open Refuel Menu

function openRefuel() {
	$('#refuelSide').html(``)
	selectedWindow = "refuelVehicle";

	var row = ``
	if (currencyOnLeft == false) {
		row += `<span class="pr">
		<input type="number" id="refuel_price" class="form-control fcont2 mt-3" onkeyup="checkIfEmpty()" maxlength="10" value=${priceToPay.toFixed(2)} disabled>
		<span class="eur">${currency}</span>
	</span>
	<span class="pr">
		<input type="number" id="refuel_liters" class="form-control fcont2 mt-3" onkeyup="checkIfEmpty()" maxlength="10" value=${fuelToVehicle} disabled>
		<span class="liters">L</span>
	</span>`;
	} else {
		row += `<span class="pr">
		<span class="dol">${currency}</span>
		<input type="number" id="refuel_price" class="form-control fcont2 pr-19 mt-3" onkeyup="checkIfEmpty()" maxlength="10" value=${priceToPay.toFixed(2)}>
	</span>
	<span class="pr">
		<input type="number" id="refuel_liters" class="form-control fcont2 mt-3" onkeyup="checkIfEmpty()" maxlength="10" value=${fuelToVehicle}>
		<span class="liters">L</span>
	</span>`;
	}
	$('#refuelSide').append(row);
	$("#refuelMenuModal").fadeIn();

	var inputPrice = document.getElementById("refuel_price");
	var inputRefuel = document.getElementById("refuel_liters");

	inputPrice.oninput = function() {
		var inputValue = parseFloat(inputPrice.value);
		var liters = inputValue / fuelPrice;
		if (isNaN(liters)) {
			inputRefuel.value = "0.00"
			inputPrice.value = "0.00"
	  	} else {
			inputRefuel.value = liters.toFixed(2);
		}

	};
	
	inputRefuel.oninput = function() {
		var litersValue = parseFloat(inputRefuel.value);
		var price = litersValue * fuelPrice;
		if (isNaN(price)) {
			inputRefuel.value = "0.00"
			inputPrice.value = "0.00"
	  	} else {
	  		inputPrice.value = price.toFixed(2);
		}
	};
	
}


// Open Refuel Jerrycan Menu

function openRefuelJerrycan() {
	$('#refuelSideJerrycan').html(``)
	selectedWindow = "refuelJerrycan";

	var row = ``
	if (currencyOnLeft == false) {
		row += `<span class="pr">
		<input type="number" id="refuel_price_jerrycan" class="form-control fcont2 mt-3" onkeyup="checkIfEmpty()" maxlength="10" value=${priceToPay.toFixed(2)} disabled>
		<span class="eur">${currency}</span>
	</span>
	<span class="pr">
		<input type="number" id="refuel_liters_jerrycan" class="form-control fcont2 mt-3" onkeyup="checkIfEmpty()" maxlength="10" value=${fuelToVehicle} disabled>
		<span class="liters">L</span>
	</span>`;
	} else {
		row += `<span class="pr">
		<span class="dol">${currency}</span>
		<input type="number" id="refuel_price_jerrycan" class="form-control fcont2 pr-19 mt-3" onkeyup="checkIfEmpty()" maxlength="10" value=${priceToPay.toFixed(2)}>
	</span>
	<span class="pr">
		<input type="number" id="refuel_liters_jerrycan" class="form-control fcont2 mt-3" onkeyup="checkIfEmpty()" maxlength="10" value=${fuelToVehicle}>
		<span class="liters">L</span>
	</span>`;
	}
	$('#refuelSideJerrycan').append(row);
	$("#refuelJerrycanMenuModal").fadeIn();

	var inputPrice = document.getElementById("refuel_price_jerrycan");
	var inputRefuel = document.getElementById("refuel_liters_jerrycan");

	inputPrice.oninput = function() {
		var inputValue = parseFloat(inputPrice.value);
		var liters = inputValue / fuelPrice;
		if (isNaN(liters)) {
			inputRefuel.value = "0.00"
			inputPrice.value = "0.00"
	  	} else {
			inputRefuel.value = liters.toFixed(2);
		}

	};
	
	inputRefuel.oninput = function() {
		var litersValue = parseFloat(inputRefuel.value);
		var price = litersValue * fuelPrice;
		if (isNaN(price)) {
			inputRefuel.value = "0.00"
			inputPrice.value = "0.00"
	  	} else {
	  		inputPrice.value = price.toFixed(2);
		}
	};
	
}


// Employees Table

function openEmployees() {
	selectedWindow = "employees";
	$('#employees_menu').html(``);
	$('#employees_menu').append(`
	<div class="row h-100" id="menu">
		<div class="col-md-2 d-flex flex-column sidebar-s">
			<img src="./img/logo.png" class="logo">
			<hr>
			<span class="sidebar-title">Meni</span>
			<div id="sidebarEmployees">
				<p class="sidebar-item mt-2" id="overview_page"><i class="bi bi-grid-1x2-fill"></i> <span class="ms-1">Pregled</span></p>
				<p class="sidebar-item" id="orders_page"><i class="fas fa-map-location-dot"></i> <span class="ms-1">Narudžbe</span></p>
				<p class="sidebar-item selected" ><i class="fas fa-user-friends"></i> <span class="ms-1">Zaposleni</span></p>
				<p class="sidebar-item" id="saleshistory_page"><i class="fas fa-chart-column"></i> <span class="ms-1">Istorija prodaje</span></p>
			</div>
			<p id="close_overview" class="sidebar-item mt-auto logout"><i class="fas fa-sign-out-alt"></i></i> <span class="ms-1">Izlaz</span></p>
		</div>
		<div class="col-md-10 tab-s">
			<div class="d-flex justify-content-between align-items-center">
				<span class="selected-page"><span id="page-title">Zaposleni</span></span>
				<div>
					<span class="username align-middle">
					<span id="playerName">${playerName}</span> <span id="avatar">${avatar}</span>
						<div class="grade">${playerRankLabel}</div>
					</span>
				</div>
			</div>
			<hr>
			<div class="d-flex flex-column gap0" id="page_info">
			<div class="d-flex">
				<button type="button" id="hireEmployeeButton" class="btn btn-blue hire-emp" data-bs-target="#hireEmployeeModal">Zaposli radnika</button>
			</div>
			<table id="employeesTable"class="mt-025">
					<thead>
						<tr>
							<th class="text-center">Ime</th>
							<th class="text-center">Rank</th>
							<th class="text-center">Ukupno narudžbi</th>
							<th class="text-center">Akcije</th>
						</tr>
					</thead>
					<tbody id="employeesTableData">
					</tbody>
				</table>
			</div>
		</div>
	</div>
	`);

	if ( isOwner == true ) {
		$('#sidebarEmployees').append(`
		<p class="sidebar-item-red" id="sell_business" data-bs-toggle="modal" data-bs-target="#sellbusiness_modal"><i class="fas fa-building"></i> <span class="ms-1">Prodaj firmu</span></p>
		`);
	}

	$('#employeesTableData').html(``)
	var row = ``
	for (var i = 0; i < employeesList.length; i++) {
			row += `
			<tr>
			<td class="text-center align-middle">${employeesList[i].name}</td>
				<td class="text-center align-middle">${employeesList[i].rankTag}</td>
				<td class="text-center align-middle">${employeesList[i].orders}</td>
				<td class="text-center align-middle"><button type="button" class="btn btn-blue btn-editgarage" data-employee_name="${employeesList[i].name}" data-employee_rank="${employeesList[i].rankTag}" data-employee_earned="${employeesList[i].orders}" data-bs-toggle="modal" data-bs-target="#editEmployeeModal" onClick="editEmployee('${employeesList[i].name}')"><i class="fa-solid fa-pen-to-square"></i> IZMENI</button></td>
			</tr>
				</tr>
			`;
	}
	
	$('#employeesTableData').append(row);

	var table_id = document.getElementById('employeesTable');
	table.push(new simpleDatatables.DataTable(table_id, {
		perPageSelect: false,
		perPage: 6,
		labels: {
			placeholder: "Pretraga...",
			noRows: "Nema unosa",
			noResults: "Nema rezultata za pretragu",
		}
	}));
} 


// Edit Employees info

function editEmployee(name) {
    for (let i = 0; i < employeesList.length; i++) {
        if (employeesList[i].name == name) {

            modalEmployeeName = employeesList[i].name;
            modalEmployeeTotalOrders = employeesList[i].orders;
            modalEmployeeGrade = employeesList[i].rankTag;
			employeeID = employeesList[i].identifier;
            changeEmployeesModalInfo();
        }
    };
}


// Change the info to fire player

function changeEmployeesModalInfo() {
	document.getElementById("fireEmployeeNameChange").innerHTML = 'Da li želiš da otpustiš ' + modalEmployeeName + "?";
	document.getElementById("employee_name").value = modalEmployeeName;
	document.getElementById("employee_total-orders").value = modalEmployeeTotalOrders;
	var num = ranks.length;
	var dropdown = ``;
	dropdown += `<option value="${0}">${modalEmployeeGrade}</option>`;
	if(num > 0){
		
		for(var i = 0; i < num; i++) {
			if (ranks[i].label != modalEmployeeGrade) { 
				dropdown += `
					<option value="${ranks[i].rank}">${ranks[i].label}</option>
				`;
			}
		}
	} 
	
	$('#dropdownRanks').html(dropdown);
} 


// Sale History Table

function openSalesHistory() {
	selectedWindow = "saleshistory";
	$('#sales_menu').html(``);
	$('#sales_menu').append(`
	<div class="row h-100" id="menu">
	<div class="col-md-2 d-flex flex-column sidebar-s">
		<img src="./img/logo.png" class="logo">
		<hr>
		<span class="sidebar-title">Meni</span>
		<div id="sidebarSalesHistory">
			<p class="sidebar-item mt-2" id="overview_page"><i class="bi bi-grid-1x2-fill"></i> <span class="ms-1">Pregled</span></p>
			<p class="sidebar-item" id="orders_page"><i class="fas fa-map-location-dot"></i> <span class="ms-1">Narudžbe</span></p>
			<p class="sidebar-item" id="employees_page"><i class="fas fa-user-friends"></i> <span class="ms-1">Zaposleni</span></p>
			<p class="sidebar-item selected"><i class="fas fa-chart-column"></i> <span class="ms-1">Istorija prodaje</span></p>
		</div>
		<p id="close_overview" class="sidebar-item mt-auto logout"><i class="fas fa-sign-out-alt"></i></i> <span class="ms-1">Izlaz</span></p>
	</div>
	<div class="col-md-10 tab-s">
		<div class="d-flex justify-content-between align-items-center">
			<span class="selected-page"><span id="page-title">Istorija prodaje</span></span>
			<div>
				<span class="username align-middle">
				<span id="playerName">${playerName}</span> <span id="avatar">${avatar}</span>
					<div class="grade">${playerRankLabel}</div>
				</span>
			</div>
		</div>
		<hr>
		<div class="d-flex flex-column gap0" id="page_info">
		<table id="salesHistoryTable" class="mt-295">
			<thead>
				<tr>
					<th class="text-center">Datum</th>
					<th class="text-center">Litri</th>
					<th class="text-center">Vrednost</th>
					<th class="text-center">Kupac</th>
				</tr>
			</thead>
			<tbody id="salesHistoryTableData">
			</tbody>
		</table>
		</div>
	</div>
	`);

	if ( isOwner == true ) {
		$('#sidebarSalesHistory').append(`
		<p class="sidebar-item-red" id="sell_business" data-bs-toggle="modal" data-bs-target="#sellbusiness_modal"><i class="fas fa-building"></i> <span class="ms-1">Prodaj firmu</span></p>
		`);
	}

	$('#salesHistoryTableData').html(``)
	var row = ``

	for (var i = 0; i < salesHistoryList.length; i++) {
			row += `
			<tr>
				<td class="text-center align-middle">${salesHistoryList[i].date}</td>
				<td class="text-center align-middle">${salesHistoryList[i].liters}L</td>
				<td class="text-center align-middle">${salesHistoryList[i].price}${currency}</td>
				<td class="text-center align-middle">${salesHistoryList[i].buyer_name}</td>
			</tr>
				</tr>
			`;
	}
	
	$('#salesHistoryTableData').append(row);

	var table_id = document.getElementById('salesHistoryTable');
	table.push(new simpleDatatables.DataTable(table_id, {
		perPageSelect: false,
		perPage: 6,
		labels: {
			placeholder: "Pretraga...",
			noRows: "Nema unosa",
			noResults: "Nema rezultata za pretragu",
		}
	}));
}


// Close Menu Functions

function abortTimer() {
	clearTimeout(tid);
}

function closeMenu() {
	var time = 300
	abortTimer();

	if (selectedWindow == "buyBusiness") {
		$("#buyBusinessModal").modal('hide');
		selectedWindow = "";
		time = 0;
		$.post('https://okokGasStation/action', JSON.stringify({
			action: "close",
		}));
	}

	if (selectedWindow != "") {
		$('.loading').fadeIn();
		$('.loadingtxt').html(`Odjava...`);
		time = 300
	} 

	setTimeout(function() {
		if (selectedWindow == "loading") {
			$(".loading").fadeOut();
		} else if (selectedWindow == "overview") {
			$(".overview").fadeOut();
		}  else if (selectedWindow == "orders") {
			$(".orders").fadeOut();
		} else if (selectedWindow == "employees") {
			$(".employees").fadeOut();
		} else if (selectedWindow == "saleshistory") {
			$(".sales").fadeOut();
		}

		selectedWindow = "";

		setTimeout(function() {
			$('.loading').fadeOut();
			$.post('https://okokGasStation/action', JSON.stringify({
				action: "close",
			}));
			setTimeout(function() {
				$('.loadingtxt').html(`Učitavanje...`);
			}, 700);
		}, time);
	}, time);

	setTimeout(function(){
		$('.modal').modal('hide');
	}, time);
}


// Close Menu

$(document).on('click', "#close_overview", function() {
	closeMenu();
});


// On Esc Key

$(document).ready(function() {
	document.onkeyup = function(data) {

		if (data.which == 27) {
			if (selectedWindow == "refuelVehicle") {
				$("#refuelMenuModal").fadeOut();
				selectedWindow = "";
				$.post('https://okokGasStation/action', JSON.stringify({
					action: "close",
				}));
				setTimeout(function() {
					document.getElementById("fullFill").classList.replace("btn-odark", "btn-blue");
					document.getElementById("customFill").classList.replace("btn-blue", "btn-odark");
				}, 300);
			} else if (selectedWindow == "refuelJerrycan") {
				$("#refuelJerrycanMenuModal").fadeOut();
				selectedWindow = "";
				$.post('https://okokGasStation/action', JSON.stringify({
					action: "close",
				}));
				setTimeout(function() {
					document.getElementById("fullFillJerrycan").classList.replace("btn-odark", "btn-blue");
					document.getElementById("customFillJerrycan").classList.replace("btn-blue", "btn-odark");
				}, 300);
			} else {
				closeMenu();
			}
		}
	};
});	


// Page Changes

$(document).on('click', "#overview_page", function() {
	$('.orders, .employees, .sales').hide();
	openOverview();
	$('.overview').show();

});

$(document).on('click', "#orders_page", function() {
	$('.overview, .employees, .sales').hide();
	openOrders();
	$('.orders').show();

});

$(document).on('click', "#employees_page", function() {
	$('.orders, .overview, .sales').hide();
	openEmployees();
	$('.employees').show();
});

$(document).on('click', "#saleshistory_page", function() {
	$('.orders, .overview, .employees').hide();
	openSalesHistory();
	$('.sales').show();
});


// Buy Business Modals

$(document).on('click', "#buybusiness_btn_modal", function() {
	$.post('https://okokGasStation/action', JSON.stringify({
		action: "buyBusiness"
	}));
});

$(document).on('click', "#closeBuyBusinessButton", function() {
	$.post('https://okokGasStation/action', JSON.stringify({
		action: "close",
	}));
});

$(document).on('click', "#closeRefuelMenu", function() {
	$("#refuelMenuModal").fadeOut();
	$.post('https://okokGasStation/action', JSON.stringify({
		action: "close",
	}));
	setTimeout(function() {
		document.getElementById("fullFill").classList.replace("btn-odark", "btn-blue");
		document.getElementById("customFill").classList.replace("btn-blue", "btn-odark");
	}, 300);
});

$(document).on('click', "#closeRefuelJerrycanMenu", function() {
	$("#refuelJerrycanMenuModal").fadeOut();
	$.post('https://okokGasStation/action', JSON.stringify({
		action: "close",
	}));
	setTimeout(function() {
		document.getElementById("fullFillJerrycan").classList.replace("btn-odark", "btn-blue");
		document.getElementById("customFillJerrycan").classList.replace("btn-blue", "btn-odark");
	}, 300);
});


// Sell Business Modals

$(document).on('click', "#sellbusiness_button_modal", function() {
	closeMenu();
	$.post('https://okokGasStation/action', JSON.stringify({
		action: "sellBusiness",
		storeID: storeID,
		businessPrice: businessPrice
	}));
});


// Deposit Modals

$(document).on('click', "#depositModal", function() {
	$('#depositModal').fadeIn();
});

$('#depositModal').on('hidden.bs.modal', function() {
	$("#deposit_money").val("");
})

$(document).on('click', "#deposit", function() {

	if (document.getElementById("deposit_money").value > 0) {
		$.post('https://okokGasStation/action', JSON.stringify({
			action: "depositMoney",
			companyID: storeID,
			amount: document.getElementById("deposit_money").value,
			storeMoney: storeMoney
		}));
	}
});


// Withdraw Modals

$(document).on('click', "#withdrawModal", function() {
	$('#withdrawModal').fadeIn();
});

$('#withdrawModal').on('hidden.bs.modal', function() {
	$("#withdraw_money").val("");
})

$(document).on('click', "#withdraw", function() {

	if (document.getElementById("withdraw_money").value > 0) {
		$.post('https://okokGasStation/action', JSON.stringify({
			action: "withdrawMoney",
			companyID: storeID,
			amount: document.getElementById("withdraw_money").value,
			storeMoney: storeMoney
		}));
	}
});


// Change Capacity Modal

const selectElement = document.getElementById("dropdown_capacity");
selectElement.addEventListener("change", () => {
	if (maxStock == maxConfigStock) {
		document.getElementById("increase_capacity").disabled = true;
		document.getElementById("increase_capacity").textContent = "Dostignut maksimalni kapacitet";
	} else {

		const selectedValue = selectElement.value;
		const newValue = parseInt(selectedValue) + parseInt(maxStock);
		const Btn = document.getElementById("increase_capacity");
		Btn.disabled = false;
		const capacitySelected = capacityList.find(capacity => capacity.capacity === parseInt(selectedValue));
		Btn.innerHTML = `${maxStock}L <i class="fas fa-arrow-right"></i> ${newValue}L <b>(${capacitySelected.price}${currency})</b>`
		stockToUpdate = parseInt(selectedValue);
		stockToUpdatePrice = capacitySelected.price;
	}
});


$(document).on('click', "#increase_capacity", function() {
	$.post('https://okokGasStation/action', JSON.stringify({
		action: "increaseCapacity",
		storeID: storeID,
		currentStock: currentStock,
		maxStock: maxStock,
		stockToUpdate: stockToUpdate,
		stockToUpdatePrice: stockToUpdatePrice,
		storeMoney: storeMoney

	}));
});


// Buy Vehicle Modal

$(document).on('click', "#buyvehicle_button_modal", function() {
	$.post('https://okokGasStation/action', JSON.stringify({
		action: "buyVehicle",
		VehicleName: modalVehicleLabel,
		VehicleID: vehicleID,
		VehiclePrice: modalVehiclePrice,
		StoreID: storeID,
		StoreMoney: storeMoney
	}));
});

$(document).on('click', "#hireEmployeeButton", function() {
	$.post('https://okokGasStation/action', JSON.stringify({
		action: "getClosePeople",
	}));
});


// Orders Modal

document.getElementById("dropdownOrders").addEventListener("change", function() {
	var orderValue = document.getElementById("dropdownOrders").value;
	if (orderValue != 0) {
		document.getElementById("new_order").removeAttribute("disabled");
	} else if (orderValue == 0) {
		document.getElementById("new_order").setAttribute("disabled", "disabled");
	}
	for (var i = 0; i < vehicleList.length; i++) {
		
		if (vehicleList[i].price == orderValue) {
			orderLiters = vehicleList[i].capacity
			orderPrice = vehicleList[i].orderPrice
			orderVehicle = vehicleList[i].vehicleid
			orderLongVehicle = vehicleList[i].longTruck
			vehicleLabel = vehicleList[i].label
		}
	}
  });

$(document).on('click', "#new_order", function() {
	$.post('https://okokGasStation/action', JSON.stringify({
		action: "newOrder",
		orderLiters: orderLiters,
		orderPrice: orderPrice,
		orderVehicle: orderVehicle,
		orderLongVehicle: orderLongVehicle,
		storeID: storeID,
		StoreMoney: storeMoney,
		vehicleLabel: vehicleLabel
	}));
	setTimeout(function() {
		orderList();
	}, 200);
	
});


// Hire Players Modal

document.getElementById("dropdown_to_hire").addEventListener("change", function() {
	var hireValue = document.getElementById("dropdown_to_hire").value;
	if (hireValue != 0) {
		document.getElementById("confirmHireEmployee").removeAttribute("disabled");
	} else if (hireValue == 0) {
		document.getElementById("confirmHireEmployee").setAttribute("disabled", "disabled");
	}
  });

$(document).on('click', "#confirmHireEmployee", function() {
	var hiredPerson = document.getElementById('dropdown_to_hire').value
	$.post('https://okokGasStation/action', JSON.stringify({
		action: "hireEmployee",
		hiredPerson: hiredPerson,
		storeID: storeID,
	}));
});


// Fire Player Modal

$(document).on('click', "#fire_employee", function() {
	$.post('https://okokGasStation/action', JSON.stringify({
		action: "fireEmployee",
		storeID: storeID,
		employeeID: employeeID,
	}));
});


// Fire Myself Modal

$(document).on('click', "#firemyself_button_modal", function() {
	$.post('https://okokGasStation/action', JSON.stringify({
		action: "fireMyself",
		storeID: storeID,
		employeeCitizen: employeeCitizen,
		firstOwner: firstOwner
	}));
});

// Edit Employees Modal

document.getElementById("dropdownRanks").addEventListener("change", function() {
	rank = document.getElementById("dropdownRanks").value;
	if (rank != 0) {
		document.getElementById("edit_employee").removeAttribute("disabled");
	} else if (rank == 0) {
		document.getElementById("edit_employee").setAttribute("disabled", "disabled");
	}
  });

$(document).on('click', "#edit_employee", function() {
	$.post('https://okokGasStation/action', JSON.stringify({
		action: "editEmployee",
		storeID: storeID,
		employeeID: employeeID,
		employeeRank: rank,
	}));
	document.getElementById("edit_employee").setAttribute("disabled", "disabled");
});


// Change Gas Price

$(document).ready(function() {
    const parent = document.querySelector('.overview')

    parent.addEventListener('keydown', function(event) {
        if (event.key === 'Enter' && event.target.classList.contains('change_price_pl')) {
            var price = event.target.value.trim();
            var oldprice = gasPrice;
            var store_id = event.target.getAttribute("data-business_id");
            if (price != oldprice) {
                event.target.setAttribute("data-name", price);
				gasPrice = price;
                $.post('https://okokGasStation/action', JSON.stringify({
                    action: "changeGasPrice",
                    price: price,
                    storeID: store_id,
					oldPrice: oldprice
                }));
            }
			gasPrice = price;
        }
    })

	parent.addEventListener('focusout', function(event) {
        if (event.target.classList.contains('change_price_pl')) {
            var price = event.target.value.trim();
            var oldprice = gasPrice;
            var store_id = event.target.getAttribute("data-business_id");
            if (price != oldprice) {
                event.target.setAttribute("data-name", price);
				gasPrice = price;
                $.post('https://okokGasStation/action', JSON.stringify({
                    action: "changeGasPrice",
                    price: price,
                    storeID: store_id,
					oldPrice: oldprice
                }));
            }
        }
    })
});


$(document).on('click', "#refuel_vehicle", function() {
	var refuel_price = parseFloat($('#refuel_price').val());
	var refuel_liters = parseFloat($('#refuel_liters').val());
	if (refuel_liters <= fuelToVehicle) {
		$.post('https://okokGasStation/action', JSON.stringify({
			action: "refuelFullVehicle",
			storeID: storeID,
			fuelToVehicle: refuel_liters,
			priceToPay: refuel_price,
			oldFuel: oldFuel,
			hasOwner: hasOwner,
			fuelAvailable: fuelAvailable,
			fuelingVehicle: true
		}));
		$("#refuelMenuModal").fadeOut();
		selectedWindow = "";
		$.post('https://okokGasStation/action', JSON.stringify({
			action: "close",
		}));
		setTimeout(function() {
			document.getElementById("fullFill").classList.replace("btn-odark", "btn-blue");
			document.getElementById("customFill").classList.replace("btn-blue", "btn-odark");
		}, 300);
	} else {
		$.post('https://okokGasStation/action', JSON.stringify({
			action: "setLastFuel",
			fuelToVehicle: fuelToVehicle,
			fuelingVehicle: true
		}));
		$('#refuel_liters').val(fuelToVehicle);
		$('#refuel_price').val(priceToPay);
	}
});

$(document).on('click', "#refuel_jerrycan", function() {
	var refuel_price = parseFloat($('#refuel_price_jerrycan').val());
	var refuel_liters = parseFloat($('#refuel_liters_jerrycan').val());
	if (refuel_liters <= fuelToVehicle) {
		$.post('https://okokGasStation/action', JSON.stringify({
			action: "refuelJerrycan",
			storeID: storeID,
			fuelToVehicle: refuel_liters,
			priceToPay: refuel_price,
			oldFuel: oldFuel,
			hasOwner: hasOwner,
			fuelAvailable: fuelAvailable,
			fuelingVehicle: false
		}));
		$("#refuelJerrycanMenuModal").fadeOut();
		selectedWindow = "";
		$.post('https://okokGasStation/action', JSON.stringify({
			action: "close",
		}));
		setTimeout(function() {
			document.getElementById("fullFillJerrycan").classList.replace("btn-odark", "btn-blue");
			document.getElementById("customFillJerrycan").classList.replace("btn-blue", "btn-odark");
		}, 300);
	} else {
		$.post('https://okokGasStation/action', JSON.stringify({
			action: "setLastFuel",
			fuelToVehicle: fuelToVehicle,
			fuelingVehicle: false
		}));
		$('#refuel_liters_jerrycan').val(fuelToVehicle);
		$('#refuel_price_jerrycan').val(priceToPay);
	}
});

$(document).on('click', "#customFill", function() {

	document.getElementById("customFill").classList.replace("btn-odark", "btn-blue");
	document.getElementById("fullFill").classList.replace("btn-blue", "btn-odark");
	document.getElementById("refuel_price").removeAttribute("disabled");
	document.getElementById("refuel_liters").removeAttribute("disabled");

	document.getElementById("refuel_price").value = "0.00";
	document.getElementById("refuel_liters").value = "0.00";

});

$(document).on('click', "#fullFill", function() {

	document.getElementById("fullFill").classList.replace("btn-odark", "btn-blue");
	document.getElementById("customFill").classList.replace("btn-blue", "btn-odark");
	document.getElementById("refuel_price").setAttribute("disabled", "disabled");
	document.getElementById("refuel_liters").setAttribute("disabled", "disabled");

	document.getElementById("refuel_price").value = priceToPay.toFixed(2);
	document.getElementById("refuel_liters").value = fuelToVehicle;

});


$(document).on('click', "#customFillJerrycan", function() {
	document.getElementById("refuel_price_jerrycan").removeAttribute("disabled");
	document.getElementById("refuel_liters_jerrycan").removeAttribute("disabled");

	document.getElementById("refuel_price_jerrycan").value = "0.00";
	document.getElementById("refuel_liters_jerrycan").value = "0.00";
	document.getElementById("customFillJerrycan").classList.replace("btn-odark", "btn-blue");
	document.getElementById("fullFillJerrycan").classList.replace("btn-blue", "btn-odark");

});

$(document).on('click', "#fullFillJerrycan", function() {
	document.getElementById("fullFillJerrycan").classList.replace("btn-odark", "btn-blue");
	document.getElementById("customFillJerrycan").classList.replace("btn-blue", "btn-odark");
	document.getElementById("refuel_price_jerrycan").setAttribute("disabled", "disabled");
	document.getElementById("refuel_liters_jerrycan").setAttribute("disabled", "disabled");

	document.getElementById("refuel_price_jerrycan").value = priceToPay.toFixed(2);
	document.getElementById("refuel_liters_jerrycan").value = fuelToVehicle;

});