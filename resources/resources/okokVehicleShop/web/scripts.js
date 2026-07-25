var weeklyGoal = 0;
var table = [];
var isTestDriving = false;
var selectedVehicle = null;
var selectedIndex = 0;
var testDriveInterval = null;
var selectedCategory = null;
var selectedVehicleIndex = 0;
var buyingVehicle = false;
var baseVehicleData = null;
var backFromVehicles = false;
var canClickOnCategory = true;
var personalPurchase = true;
var financedVehicleInfo = null;
var standMoney = 0;
var standId = null;
var standOwnerId = null;
var uniqueCategories = [];
var uniqueTypes = [];
var vehicleShowcaseSelected = null;
var categoryLabels = {};
var allVehiclesListed = false;
var vehicleStats = {};
var vehicleSelected = null;
var enableTradeIns = false;
var vehicleToChangePriceDiscount = 0;
var financedVehiclesEnabled = true;
var menuClosed = false;

const tradeinSelect = document.getElementById('vehicle_tradein');

// Retrieve NUI

async function retrieveNUI(
    eventName, data = {}) {
    const options = { method: "post", headers: {"Content-Type": "application/json; charset=UTF-8" }, body: JSON.stringify(data)};
    const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : "nui-frame-app";
    try {
        const resp = await fetch(`https://${resourceName}/${eventName}`, options);
        return await resp.json();
    } catch (error) {
        return null;
    }
}

function capitalizeFirst(str) {
  if (!str) return "";
  return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}


function updateTradeinOptions() {
    if (tradeinSelect && enableTradeIns) {
        var vehicles = playerVehicles;
        if (!personalPurchase) vehicles = societyVehicles;
        tradeinSelect.innerHTML = '';
        const noneOption = document.createElement('option');
        noneOption.value = '0';
        noneOption.selected = true;
        noneOption.textContent = locales.translations.tradeindefaultvalue;
        tradeinSelect.appendChild(noneOption);
        if (Array.isArray(vehicles) && vehicleSelected !== null && typeof vehicleSelected !== 'undefined' && vehicleSelected) {
            // Get the price, using max_price as fallback if price doesn't exist
            let selectedVehiclePrice;
            if (vehicleSelected.price) {
                selectedVehiclePrice = parseFloat(vehicleSelected.price);
            } else if (vehicleSelected.max_price) {
                selectedVehiclePrice = parseFloat(vehicleSelected.max_price);
            } else {
                selectedVehiclePrice = 0;
            }

            if (vehicleSelected.discount > 0) {
                selectedVehiclePrice = selectedVehiclePrice * (1 - vehicleSelected.discount / 100);
            }

            vehicles
                .filter(vehicle => {
                    const vehiclePrice = parseFloat(vehicle.price) || 0;
                    return vehiclePrice < selectedVehiclePrice;
                })
                .sort((a, b) => {
                    const priceA = parseFloat(a.price) || 0;
                    const priceB = parseFloat(b.price) || 0;
                    return priceA - priceB; // Sort by price ascending (lowest first)
                })
                .forEach(function(vehicle, idx) {
                    const option = document.createElement('option');
                    option.value = vehicle.plate || (idx+1);
                    option.textContent = `${capitalizeFirst(vehicle.name)} [${vehicle.plate}] (${setLocaleString(vehicle.price)})`;
                    tradeinSelect.appendChild(option);
                });
        }
    }
}

// Function to update trade-in price display and recalculate total
function updateTradeinPriceDisplay() {
    if (enableTradeIns) {
        const selectedTradeinValue = tradeinSelect.value;
        let tradeinPrice = 0;
        let tradeinPlate = null;
        var vehicles = playerVehicles;
        if (!personalPurchase) vehicles = societyVehicles;

        if (selectedTradeinValue !== '0' && Array.isArray(vehicles)) {
            // Find the selected trade-in vehicle by plate
            const selectedTradeinVehicle = vehicles.find(vehicle =>
                vehicle.plate === selectedTradeinValue
            );
            
            if (selectedTradeinVehicle) {
                tradeinPrice = parseFloat(selectedTradeinVehicle.price) || 0;
                tradeinPlate = selectedTradeinVehicle.plate;
            }
        }
        
        // Store the trade-in vehicle plate in vehicleSelected
        if (vehicleSelected) {
            vehicleSelected.tradeinPlate = tradeinPlate;
        }
        
        // Update the trade-in price display
        const tradeinPriceElement = document.getElementById('vehicle_tradein_price');
        if (tradeinPriceElement) {
            // Check if custom plate fee is visible
            const plateFeeVisible = $(".vehicle_platefee_div").css('display') === 'flex';
            
            if (tradeinPrice > 0) {
                $(".vehicle_tradein_div").css('display', 'flex');
                $("#vehicle_buy_price_title").html(locales.translations.finalprice);
                tradeinPriceElement.textContent = `-${setLocaleString(tradeinPrice)}`;
                tradeinPriceElement.className = 'tradein-text'; // Red styling
            } else {
                $(".vehicle_tradein_div").css('display', 'none');
                // Show "Final Price" if custom plate is visible, otherwise "Price"
                if (plateFeeVisible) {
                    $("#vehicle_buy_price_title").html(locales.translations.finalprice);
                } else {
                    $("#vehicle_buy_price_title").html(locales.translations.price);
                }
                tradeinPriceElement.textContent = '-0€';
                tradeinPriceElement.className = 'tradein-text';
            }
        }
        
        // Recalculate and update final price
        updateFinalPrice(tradeinPrice);
    }
}

// Function to calculate and update the final vehicle price
function updateFinalPrice(tradeinPrice = 0) {
    if (!vehicleSelected) return;
    
    // Get base price from selected vehicle
    let basePrice = 0;
    if (vehicleSelected.price) {
        basePrice = parseFloat(vehicleSelected.price);
    } else if (vehicleSelected.max_price) {
        basePrice = parseFloat(vehicleSelected.max_price);
    }

/*     if (vehicleSelected.discount > 0) {
        basePrice = basePrice * (1 - vehicleSelected.discount / 100);
    } */
    
    // Update the base price display
    const basePriceElement = document.getElementById('vehicle_base_price_price');
    if (basePriceElement) {
        basePriceElement.textContent = `${setLocaleString(basePrice)}`;
    }
    
    // Check if custom plate fee should be added
    let platePrice = 0;
    const plateFeeDiv = document.querySelector('.vehicle_platefee_div');
    if (plateFeeDiv && window.getComputedStyle(plateFeeDiv).display === 'flex') {
        platePrice = parseFloat(customPlatePrice) || 0;
    }
    
    // Calculate final price (base price + plate price - trade-in value)
    var finalPrice = basePrice + platePrice - tradeinPrice;
    
    // Update the final price display
    const finalPriceElement = document.getElementById('vehicle_buy_price');
    if (finalPriceElement) {
        if (vehicleSelected.discount > 0) {
            finalPrice = finalPrice * (1 - vehicleSelected.discount / 100);
        }
        finalPriceElement.textContent = `${setLocaleString(finalPrice)}`;
    }
    
    // Store the final price in vehicleSelected so the buy button uses it
    vehicleSelected.finalPrice = finalPrice;
}

function restartCustomPlate() {
    document.getElementById("vehicle_plate").value = "";
    $('#standard').addClass('btn-active');
    $('#custom').removeClass('btn-active');
    $('#custom').addClass('btn-inactive');
    $(".vehicle_plate").css('display', 'none');
    $(".vehicle_platefee_div").css('display', 'none');
}
// Add event listener for trade-in select changes
if (tradeinSelect) {
    tradeinSelect.addEventListener('change', updateTradeinPriceDisplay);
}


// NUI Callbacks

window.addEventListener('message', function(event) {
    switch (event.data.action) {
        case 'loading':
            locales = event.data.locales;
            currency = event.data.currency;
            currencySide = event.data.currencySide;
            $("#loading_data_card").html(locales.translations.loadingdata);
            selectedWindow = "loading";
            $('.loading').fadeIn();
            break

        case 'dashboard':
            standInfo = event.data.standInfo;
            playerName = event.data.playerName;
            playerGrade = event.data.playerGrade;
            playerSex = event.data.playerSex;
            playerIdentifier = event.data.playerIdentifier;
            useLocalImages = event.data.useLocalImages;
            useSameImageForAllVehicles = event.data.useSameImageForAllVehicles;
            jobRanks = event.data.jobRanks;
            isSubowner = event.data.isSubowner;
            sellStandPrice = standInfo.sellPrice;
            categoriesLabels = event.data.categoriesLabels;
            vehicleShowcaseData = event.data.vehicleShowcaseData;
            menuClosed = false;

            if (standInfo.owner == playerIdentifier) {
                setupDashboard();
            } else if (isSubowner) {
                setupDashboard();
            }
            
            setupUI();

            if (standInfo.owner == playerIdentifier) {
                $("#dashboard").css('display', 'flex').hide().fadeIn();
                setTimeout(function() {
                    $('.loading').fadeOut();
                }, 500);
            } else if (isSubowner) {
                $("#dashboard").css('display', 'flex').hide().fadeIn();
                setTimeout(function() {
                    $('.loading').fadeOut();
                }, 500);
            } else {
                $("#orders").css('display', 'flex').hide().fadeIn();
                setTimeout(function() {
                    $('.loading').fadeOut();
                    setupOrders();
                }, 500);
            }


            setTimeout(function() {
                $('.loadingtxt').html(`${locales.translations.loggingout}`);
            }, 1000);

            $("#goal-buttons").html('');
            for (let i = 0; i < event.data.weeklyGoalOptions.length; i++) {
                $("#goal-buttons").append(`<button class="goal-btn" data-value="${event.data.weeklyGoalOptions[i]}" onclick="setGoal(this.dataset.value)">${setLocaleString(event.data.weeklyGoalOptions[i])}</button>`);
            }

            break

        case 'buyBusiness':
            selectedWindow = "buyBusinessModal";
            standInfo = event.data.standInfo;
            locales = event.data.locales;
            currency = event.data.currency;
            currencySide = event.data.currencySide;
            $("#buy_business_text").html(locales.translations.doyouwanttobuy + " " + standInfo.label + " " + locales.translations.forprice + " " + setLocaleString(standInfo.price) + "?");
            setupUI();
            var modal = document.getElementById('buyBusinessModal');
            modal.style.display = 'flex';
            setTimeout(function () {
                modal.classList.add('show');
            }, 50);
            break


        case 'openVehicleListing':
            standInfo = event.data.standInfo;
            locales = event.data.locales;
            currency = event.data.currency;
            currencySide = event.data.currencySide;
            useLocalImages = event.data.useLocalImages;
            useSameImageForAllVehicles = event.data.useSameImageForAllVehicles;
            isTestDriving = false;
            vehicleListingType = event.data.vehicleListingType;
            categoriesLabels = event.data.categoriesLabels;
            playerName = event.data.playerName;
            playerIdentifier = event.data.playerIdentifier;
            phone = event.data.phone;
            isStandVip = event.data.isStandVip;
            playerVipCoins = event.data.playerVipCoins;
            financeVehiclesSettings = event.data.financeVehiclesSettings;
            playerVehicles = event.data.playerVehicles;
            societyVehicles = event.data.societyVehicles;
            enableTradeIns = event.data.enableTradeIns;
            enableCustomPlates = event.data.enableCustomPlates;
            customPlatePrice = event.data.customPlatePrice;
            vehiclesWithClasses = event.data.vehiclesWithClasses;
            financedVehiclesEnabled = event.data.financedVehiclesEnabled !== false;
            menuClosed = false;

            if (!financedVehiclesEnabled) {
                $('#finance_vehicle_btn').hide();
            } else {
                $('#finance_vehicle_btn').show();
                if (isStandVip) {
                    $('#finance_vehicle_btn').css('cursor', 'not-allowed').prop('disabled', true);
                } else {
                    $('#finance_vehicle_btn').css('cursor', 'pointer').prop('disabled', false);
                }
            }

            if (event.data.selectedVehicleIndex !== undefined) {window.lastSelectedIndex = event.data.selectedVehicleIndex}
            if (!enableTradeIns) {
                $("#vehicle_tradein_name_title").css('display', 'none');
                $("#vehicle_tradein").css('display', 'none');
                $("#vehicle_base_price_title").css('display', 'none');
                $("#vehicle_base_price_price").css('display', 'none');
                $("#vehicle_tradein_title").css('display', 'none');
                $("#vehicle_tradein_price").css('display', 'none');
            }
            if (!enableCustomPlates) {
                $(".plate-type-container").css('display', 'none');
                $("#vehicle_plate_name_title").css('display', 'none');
            }
            
            $('#vehicle_platefee_price').html("+" + setLocaleString(customPlatePrice));
            restartCustomPlate();
            updateTradeinOptions();
            setupUI();
            if (vehicleListingType == 'categories') {
                setupVehicleListingPrimary(selectedCategory);
                if (selectedCategory) {selectCategory(selectedCategory)}
            } else {
                setupVehicleListingSecondary();
            }
        break

        case 'updateVehicleStats':
            updateVehicleStats(event.data.stats);
        break

        case 'testDriveVehicle':
            testDriveTime = event.data.time;
            $(".test-drive-container").css('display', 'flex').hide().fadeIn();
            startTestDriveCountdown(testDriveTime);
        break

        case 'endTestDrive':
            clearInterval(testDriveInterval);
            $(".test-drive-container").fadeOut();
        break
        
        case 'canCloseMenu':
            closeMenu();
        break

        case 'updateEmployees':
            standInfo = event.data.standInfo;
            setupEmployees();
        break

        case 'closeMenu':
            closeMenu();
        break

        case 'updateShopinfo':
            standInfo = event.data.standInfo;
        break

        case 'openFinancedVehicles':
            locales = event.data.locales;
            currency = event.data.currency;
            currencySide = event.data.currencySide;
            financedVehicles = event.data.financedVehicles;
            setupMyFinancedVehicles();
            selectedWindow = "myFinancedVehiclesModal";
            setDatatableColor('#373737', '1rem', '1rem');
            setupUI();
        break

        case 'openAdminMenu':
            $("#loading_data_card").html(locales.translations.loadingdata);
            locales = event.data.locales;
            currency = event.data.currency;
            currencySide = event.data.currencySide;
            standsInfo = event.data.standsInfo;
            playerName = event.data.playerName;
            vehicleCount = event.data.vehicleCount;
            vehicleStockCount = event.data.vehicleStockCount;
            mostSoldVehicle = event.data.mostSoldVehicle;
            allVehicleList = event.data.allVehicleList;
            vehicleShowcaseData = event.data.vehicleShowcaseData;
            availableCategories = event.data.availableCategories;
            menuClosed = false;
            setupUI();
            $("#admin").css('display', 'flex').hide().fadeIn();
            setTimeout(function() {
                $('.loading').fadeOut();
                setupAdminMenu();
            }, 500);

            setTimeout(function() {
                $('.loadingtxt').html(`${locales.translations.loggingout}`);
            }, 1000);
        break

        case 'updateShowcaseTable':
            vehicleShowcaseData = event.data.vehicleShowcaseData;
            if (selectedWindow === "vehicleDashboardShowcase") {
                setupVehicleDashboardShowcase();
            } else {
                setupVehicleShowcase();
            }
        break

        case 'sellVehicle':
            locales = event.data.locales;
            currency = event.data.currency;
            currencySide = event.data.currencySide;
            vehicleSellData = event.data.vehicleData;
            openSellVehicleModal();
        break

}})


// Functions

function setupUI() {
    $("#buy_business_title").html(locales.translations.areyousure);
    $("#closeBuyBusinessButton").html(locales.translations.cancel);
    $("#buybusiness_btn_modal").html(locales.translations.buy);
	$("#deposit_money").attr("placeholder", locales.translations.amount);
    $("#deposit_money_title").html(locales.translations.depositmoney);
    $("#deposit_btn").html(locales.translations.deposit);
    $('#withdraw_money_title').html(locales.translations.withdrawmoney);
    $("#withdraw_btn").html(locales.translations.withdraw);
    $("#withdraw_money").attr("placeholder", locales.translations.amount);
    $('#weekly_goal_title').html(locales.translations.weeklygoal);
    $('#custom-goal-input').attr("placeholder", locales.translations.customamount);
    $("#set-goal-btn").html(locales.translations.setgoal);
    $("#buy_vehicle_title").html(locales.translations.buyvehicle);
    $("#buy_vehicle_btn").html(locales.translations.buy);
    $("#buy_vehicle_price").attr("placeholder", locales.translations.amount);
    $("#change_price_title").html(locales.translations.changeprice);
    $("#change_price_btn").html(locales.translations.confirm);
    $("#change_price_input").attr("placeholder", locales.translations.newprice);
    $("#old_price_title").html(locales.translations.oldprice + " (" + currency + ")");
    $("#new_price_title").html(locales.translations.newprice + " (" + currency + ")");
    $("#min_price_title").html(locales.translations.minprice + " (" + currency + ")");
    $("#max_price_title").html(locales.translations.maxprice + " (" + currency + ")");
    $("#order_vehicle_title").html(locales.translations.ordervehicle);
    $("#full_name_title").html(locales.translations.fullname);
    $("#phone_number_title").html(locales.translations.phonenumber);
    $("#vehicle_title").html(locales.translations.vehicle);
    $("#price_title").html(locales.translations.price + " (" + currency + ")");
    $("#order_vehicle_btn").html(locales.translations.ordervehicle);
    $("#order_info_title").html(locales.translations.orderinfo);
    $("#edit_order_vehicle_title").html(locales.translations.vehicle);
    $("#edit_order_customer_title").html(locales.translations.customer);
    $("#edit_order_phone_title").html(locales.translations.phonenumber);
    $("#edit_order_agreed_price_title").html(locales.translations.price + " (" + currency + ")");
    $("#edit_order_notes_title").html(locales.translations.notes);
    $("#edit_order_status_title").html(locales.translations.status);
    $("#my_orders_title").html(locales.translations.myorders);
    $("#hire_employee_title").html(locales.translations.hireemployee);
    $("#confirmHireEmployee").html(locales.translations.hire);
    $("#edit_employee_title").html(locales.translations.editemployee);
    $("#edit_employee_btn").html(locales.translations.save);
    $("#employee_name_title").html(locales.translations.fullname);
    $("#total_earned_title").html(locales.translations.totalearned);
    $("#employee_grade_title").html(locales.translations.grade);
    $("#fire_employee_title_btn").html('<i class="fa-solid fa-trash"></i>' + locales.translations.fireemployee);
    $("#employee_grades_title").html(locales.translations.newgrade);
    $('#fire_employee_title').html(locales.translations.fireemployee);
    $("#fire_employee_btn, #fire_employee_btn_final").html(locales.translations.fire);
    $("#cancel_fire_employee_btn").html(locales.translations.cancel);
    $("#buy_vehicle_customer_title").html(locales.translations.buyvehicle);
    $("#personal, #personal_order").html(locales.translations.personal);
    $("#society, #society_order").html(locales.translations.society);
    $("#vehicle_buy_name_title").html(locales.translations.vehiclename);
    $("#vehicle_buy_price_title").html(locales.translations.price);
    $("#vehicle_base_price_title").html(locales.translations.baseprice);
    $("#vehicle_plate_name_title").html(locales.translations.plate);
    $("#standard").html(locales.translations.standard);
    $("#custom").html(locales.translations.custom);
    $("#vehicle_platefee_title").html(locales.translations.platefee);
    $('#vehicle_plate').attr('placeholder', locales.translations.customplate);
    $("#vehicle_tradein_title").html(locales.translations.tradein);
    $("#vehicle_tradein_name_title").html(locales.translations.tradeintitle);
    $("#finance_vehicle_title").html(locales.translations.financevehicle);
    $("#finance_vehicle_btn").html(locales.translations.finance);
    $("#buy_vehicle_btn_final").html(locales.translations.buy);
    $("#vehicle_finance_name_title").html(locales.translations.vehiclename);
    $("#vehicle_finance_price_title").html(locales.translations.price);
    $("#vehicle_finance_interest_rate_title").html(locales.translations.interestrate);
    $("#vehicle_finance_period_title").html(locales.translations.financeperiod);
    $("#vehicle_finance_first_payment_title").html(locales.translations.firstpayment + " (" + currency + ")");
    $("#vehicle_finance_monthly_payment_title").html(locales.translations.monthlypayment + " (" + currency + ")");
    $("#vehicle_finance_total_price_title").html(locales.translations.totalprice + " (" + currency + ")");
    $("#cancel_finance_vehicle_btn").html(locales.translations.cancel);
    $("#finance_vehicle_btn_final").html(locales.translations.confirm);
    $("#my_financed_vehicles_title").html(locales.translations.myfinancedvehicles);
    $("#edit_dealership_title").html(locales.translations.editdealership);
    $("#close-dealership-modal-btn").html(locales.translations.cancel);
    $("#confirm-dealership-modal-btn").html(locales.translations.save);
    $("#dealership_name_title").html(locales.translations.dealershipname);
    $("#dealership_owner_name_title").html(locales.translations.owner);
    $("#dealership_money_title").html(locales.translations.money + " (" + currency + ")" + '<span class="editable-dealership">(' + locales.translations.editable + ')</span>');
    $("#dealership_type_title").html(locales.translations.type);
    $("#change_owner_title").html(locales.translations.changeowner);
    $("#dealership_owner_id_title").html(locales.translations.ownerid + '<span class="editable-dealership">(' + locales.translations.editable + ')</span>');
    $("#all_stock_title").html(locales.translations.allvehicles);
    $("#all_stock_text").html(locales.translations.areyousureallstock);
    $("#closeAllStockButton").html(locales.translations.cancel);
    $("#allStock_btn_modal").html(locales.translations.confirm);
    $("#discount_title").html(locales.translations.discount + " (%)");
    $("#toggle_listed_title").html(locales.translations.areyousure);
    $("#closeToggleListedButton").html(locales.translations.cancel);
    $("#toggleListed_btn_modal").html(locales.translations.confirm);
}



function checkIfEmpty() {
    if ($("#deposit_money").val() == "" || $("#deposit_money").val() <= 0) {$("#deposit_btn").prop('disabled', true)} else {$("#deposit_btn").prop('disabled', false)};
    if ($("#withdraw_money").val() == "" || $("#withdraw_money").val() <= 0) {$("#withdraw_btn").prop('disabled', true)} else {$("#withdraw_btn").prop('disabled', false)};
    if ($("#custom-goal-input").val() == "" || $("#custom-goal-input").val() <= 0) {$("#set-goal-btn").prop('disabled', true)} else {$("#set-goal-btn").prop('disabled', false)};
    if ($("#buy_vehicle_price").val() == "" || $("#buy_vehicle_price").val() <= 0) {$("#buy_vehicle_btn").prop('disabled', true)} else {$("#buy_vehicle_btn").prop('disabled', false)};
    // Verifica se houve mudança no preço
    const newPriceValue = $("#change_price_input").val();
    const priceChanged = newPriceValue != "" && parseFloat(newPriceValue) > 0;
    
    // Verifica se houve mudança no desconto
    const newDiscountValue = $("#change_discount_input").val();
    const currentDiscount = parseFloat(newDiscountValue) || 0;
    const discountChanged = currentDiscount != vehicleToChangePriceDiscount;
    
    // Verifica se o desconto é válido (>= 0)
    const discountValid = newDiscountValue == "" || (newDiscountValue != "" && parseFloat(newDiscountValue) >= 0);
    
    // O botão fica habilitado se:
    // 1. O preço foi alterado (preenchido e > 0) E o desconto é válido, OU
    // 2. Apenas o desconto foi alterado (mesmo que o preço não tenha sido alterado)
    if ((priceChanged && discountValid) || (discountChanged && discountValid)) {
        $("#change_price_btn").prop('disabled', false);
    } else {
        $("#change_price_btn").prop('disabled', true);
    }
    if ($("#dropdown_to_hire").val() == "") {$("#confirmHireEmployee").prop('disabled', true)} else {$("#confirmHireEmployee").prop('disabled', false)};

    if ($("#vehicle_plate").val() == "") {$(".vehicle_platefee_div").css('display', 'none');} else {$(".vehicle_platefee_div").css('display', 'flex');};
    
    // Check if we should show "Final Price" or just "Price"
    const hasCustomPlate = $("#vehicle_plate").val() !== "";
    const plateFeeVisible = $(".vehicle_platefee_div").css('display') === 'flex';
    
    // Update final price when plate fee visibility changes
    if (enableTradeIns) {
        const tradeinSelect = document.getElementById('vehicle_tradein');
        const selectedTradeinValue = tradeinSelect ? tradeinSelect.value : '0';
        let tradeinPrice = 0;
        const hasTradein = selectedTradeinValue !== '0';
        
        if (hasTradein) {
            var vehicles = playerVehicles;
            if (!personalPurchase) vehicles = societyVehicles;
            
            if (Array.isArray(vehicles)) {
                const selectedTradeinVehicle = vehicles.find(vehicle => vehicle.plate === selectedTradeinValue);
                if (selectedTradeinVehicle) {
                    tradeinPrice = parseFloat(selectedTradeinVehicle.price) || 0;
                }
            }
        }
        
        // Update price title based on whether we have trade-in or custom plate
        if (hasTradein || plateFeeVisible) {
            $("#vehicle_buy_price_title").html(locales.translations.finalprice);
        } else {
            $("#vehicle_buy_price_title").html(locales.translations.price);
        }
        
        updateFinalPrice(tradeinPrice);
    } else {
        // Even without trade-ins, change title if custom plate is selected
        if (plateFeeVisible) {
            $("#vehicle_buy_price_title").html(locales.translations.finalprice);
        } else {
            $("#vehicle_buy_price_title").html(locales.translations.price);
        }
        updateFinalPrice(0);
    }

    const selectedGrade = $("#employee_grades").val();
    const currentEmployeeRank = currentEditingEmployee ? currentEditingEmployee.rank - 1 : null;
    if (selectedGrade == "" || selectedGrade == currentEmployeeRank) {$("#edit_employee_btn").prop('disabled', true)} else {$("#edit_employee_btn").prop('disabled', false)}
    
    const currentMoney = parseInt($("#dealership_money").val()) || 0;
    if ($("#dealership_money").val() == "" || currentMoney == standMoney) {
        $("#confirm-dealership-modal-btn").prop('disabled', true);
    } else {
        $("#confirm-dealership-modal-btn").prop('disabled', false);
    }
    const currentOwnerId = $("#dealership_owner_id").val();
    if (currentOwnerId == "" || currentOwnerId == standOwnerId) {
        $("#confirm-dealership-modal-btn").prop('disabled', true);
    } else {
        $("#confirm-dealership-modal-btn").prop('disabled', false);
    }

    if (selectedWindow == "editVehicleModal") {
        const minVal = $("#vehicle_min_price").val();
        const maxVal = $("#vehicle_max_price").val();
        const categoryVal = $("#vehicle_category").val();
        const typeVal = $("#vehicle_type").val();
    
        if ((minVal !== "" && parseFloat(minVal) < 0) || (maxVal !== "" && parseFloat(maxVal) < 0)) {
            $("#confirm-edit-vehicle-btn").prop('disabled', true);
            
            setTimeout(() => {
                $("#confirm-edit-vehicle-btn").prop('disabled', true);
            }, 0);
            
            setTimeout(() => {
                $("#confirm-edit-vehicle-btn").prop('disabled', true);
            }, 10);
            
            return;
        }
    
        const minPriceChanged = minVal !== "" && parseFloat(minVal) >= 0 && parseFloat(minVal) != selectedVehicle.min_price;
        const maxPriceChanged = maxVal !== "" && parseFloat(maxVal) >= 0 && parseFloat(maxVal) != selectedVehicle.max_price;
        const categoryChanged = categoryVal !== "" && categoryVal != selectedVehicle.category;
        const typeChanged = typeVal !== "" && typeVal != selectedVehicle.type;
    
        if (minPriceChanged || maxPriceChanged || categoryChanged || typeChanged) {
            $("#confirm-edit-vehicle-btn").prop('disabled', false);
        } else {
            $("#confirm-edit-vehicle-btn").prop('disabled', true);
        }
    }

    if ($("#vehicle_name_add").val() == "" || $("#vehicle_id_add").val() == "" || $("#vehicle_min_price_add").val() == "" || $("#vehicle_max_price_add").val() == "" || $("#vehicle_min_price_add").val() <= 0 || $("#vehicle_max_price_add").val() <= 0) {
        $("#confirm-add-vehicle-btn").prop('disabled', true);
    } else {
        $("#confirm-add-vehicle-btn").prop('disabled', false);
    }

    if (selectedWindow == "vehicleShowcase" || selectedWindow == "vehicleDashboardShowcase") {
        if ($("#vehicle_name_showcase_add").val() == "" || $("#vehicle_id_showcase_add").val() == "" || $("#vehicle_color_showcase_add").val() == "" || $("#vehicle_plate_showcase_add").val() == "") {
            $("#confirm-add-vehicle-showcase-btn").prop('disabled', true);
        } else {
            $("#confirm-add-vehicle-showcase-btn").prop('disabled', false);
        }
    }
}

function setLocaleString(money) {
    return currencySide == 'left' ? currency + Math.floor(money).toLocaleString().replace(/,/g, '.') : Math.floor(money).toLocaleString().replace(/,/g, '.') + currency;
}

function setLocaleStringVip(money) {
    return currencySide == 'left' ? '<i class="fa-solid fa-coins mr-1"></i>' + Math.floor(money).toLocaleString().replace(/,/g, '.') : Math.floor(money).toLocaleString().replace(/,/g, '.') + '<i class="fa-solid fa-coins ml-1"></i>';
}

function setWeeklyGoalProgress(percent, target) {
    const progressElement = document.getElementById('weekly-progress');
    const progressText = document.getElementById('progress-text');
    const roundedPercent = Math.round(percent);
    progressElement.style.width = `${percent}%`;
    progressText.textContent = `${roundedPercent}% ${locales.translations.of} ${setLocaleString(target)}`;
}

// Helper function to trigger modal close events
function triggerModalCloseEvent(modalId) {
    const event = new CustomEvent('modalClosed', {
        detail: { modalId: modalId }
    });
    document.dispatchEvent(event);
    
    // Also trigger jQuery event for compatibility
    $(document).trigger('modalClosed', { modalId: modalId });
}

function closeMenu() {
    if (selectedWindow == "sellVehicleModal") {
        retrieveNUI('closeMenu', {})
        return;
    }
    if (selectedWindow == "buyBusinessModal") {
        var modal = $('#buyBusinessModal');
        modal.removeClass('show');
        setTimeout(function () {
            modal.css('display', 'none');
        }, 300);
        retrieveNUI('closeMenu', {})
        return;
    }
    if (selectedWindow == "myFinancedVehiclesModal") {
        var modal = $('#myFinancedVehiclesModal');
        modal.removeClass('show');
        setTimeout(function () {
            modal.css('display', 'none');
            triggerModalCloseEvent('myFinancedVehiclesModal');
        }, 300);
        retrieveNUI('closeMenu', {})
        return;
    }
    if (selectedWindow == "financedVehicleInfoModal") {
        var modal = $('#financedVehicleInfoModal');
        modal.removeClass('show');
        setTimeout(function () {
            modal.css('display', 'none');
        }, 300);
        retrieveNUI('closeMenu', {})
        return;
    }
    if (selectedWindow == "vehicleListing") {

        if (vehicleListingType == 'categories') {
            $('#vehicle-listing-primary').fadeOut(500);
            $('.overlay-primary').fadeOut(500);
            retrieveNUI('fadeIn')
        } else {
            $('#vehicle-listing-secondary').fadeOut(500);
            $('.overlay-secondary').fadeOut(500);
            retrieveNUI('fadeIn')
        }
        retrieveNUI('closeMenu', { vehicleListing: true, testDriving: isTestDriving, buyingVehicle: buyingVehicle })
        buyingVehicle = false;

        var modal = $('#buyVehicleCustomerModal');
        modal.removeClass('show');
        setTimeout(function () {
            modal.css('display', 'none');
        }, 300);

        return;
    }

    $(".loading").fadeIn();

    $('.modal.show').removeClass('show');
    setTimeout(function() {
        $('.modal').css('display', 'none');
    }, 300);

    setTimeout(function() {
        $("#dashboard, #stock, #orders, #customerorders, #employees, #salesHistory, #logs, #admin, #vehiclesList, #vehiclesShowcase").hide();
        $(".loading").fadeOut();

        retrieveNUI('closeMenu', {})
    }, 500);
}

function setGoal(value) {
    weeklyGoal = value;
    $(".goal-btn").removeClass('active');
    event.target.classList.add('active');
    $("#set-goal-btn").prop('disabled', false);
}

function setDatatableColor(color, right, bottom) {
    const styleId = 'datatable-custom-styles';
    let existingStyle = document.getElementById(styleId);
    
    if (existingStyle) {existingStyle.remove()}
    
    const style = document.createElement('style');
    style.id = styleId;
    style.textContent = `
        .dataTable-pagination a {
            background-color: ${color} !important;
        }
        .dataTable-pagination a:hover {
            background-color: #1f5eff !important;
            transition: .25s;
        }
        tr {
            background-color: ${color} !important;
        }
        tr:hover {
            background-color: ${color} !important;
        }
        tbody tr {
            background-color: ${color} !important;
        }
        tbody tr:hover {
            background-color: ${color} !important;
        }
        .dataTable-table tbody tr {
            background-color: ${color} !important;
        }
        .dataTable-table tbody tr:hover {
            background-color: ${color} !important;
        }
        .dataTable-pagination {
            position: fixed;
            right: ${right} !important;
            bottom: ${bottom} !important;
        }
    `;
    
    document.head.appendChild(style);
}

function setDatatableSearchSettings(right, top, borderRadius, width) {

    const styleId = 'datatable-custom-search-styles';
    let existingStyle = document.getElementById(styleId);
    
    if (existingStyle) {existingStyle.remove()}
    
    const style = document.createElement('style');
    style.id = styleId;
    style.textContent = `

    .dataTable-search {
        right: ${right} !important;
        top: ${top} !important;
    }

    .dataTable-input {
        width: ${width} !important;
        border-radius: ${borderRadius} !important;
    }
    `;
    
    document.head.appendChild(style);
}

function openSellVehicleModal() {
    $('#sell_vehicle_title').html(locales.translations.areyousure);
    $('#closeSellVehicleButton').html(locales.translations.cancel);
    $('#sellvehicle_btn_modal').html(locales.translations.sell);
    $('#sell_vehicle_text').html(locales.translations.doyouwanttosell + " " + vehicleSellData.vehicleName + " " + locales.translations.forprice + " " + setLocaleString(vehicleSellData.vehiclePrice) + "?");
   
    var modal = document.getElementById('sellVehicleModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
}

$(document).on('click', '#closeSellVehicleModal, #closeSellVehicleButton', function() {
    selectedWindow = "sellVehicleModal";
    var modal = $('#sellVehicleModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
    closeMenu();
});

$(document).on('click', '#sellvehicle_btn_modal', function() {
    selectedWindow = "sellVehicleModal";
    retrieveNUI('sellVehicle', { vehicleData: vehicleSellData });
    var modal = $('#sellVehicleModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
    closeMenu();
});


function setupAdminMenu() {
    $('#admin').html('');

    $('#admin').html(`
    <div class="info">
        <div class="logo">
            <div class="okok">${locales.translations.okok}</div>
            <div class="resource">${locales.translations.vehicleshop}</div>
        </div>
        <div class="navbar">
            <div class="navbar-items">
                <a id="overview-stands-btn" class="nav-item nav-item-selected"><i class="bi bi-grid-1x2-fill"></i><span class="nav-item-text">${locales.translations.overview}</span></a>
                <a id="vehicles-stands-btn" class="nav-item mt-05"><i class="bi bi-archive-fill"></i><span class="nav-item-text">${locales.translations.vehicles}</span></a>
                <a id="car-showcase-btn" class="nav-item mt-05"><i class="bi bi-car-front-fill"></i><span class="nav-item-text">${locales.translations.carshowcase}</span></a>
            </div>
            <div class="user-info">
                <div class="user-info-img">
                    <img src="./img/avatar_male.png" class="avatar">
                </div>
                <div class="user-info-data">
                    <span class="char-name">${playerName}</span>
                    <span class="grade">${locales.translations.admin}</span>
                </div>
                <div id="logout-btn" class="logout">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                </div>
            </div>
        </div>
    </div>
    
    <div class="content">
        <div class="page">
            <span class="page-title">${locales.translations.overview}</span>
        </div>
        <div class="page-info">
            <div class="row">
                <div class="item" style="height: 17.5rem;">
                    <div class="item-header">
                        <div class="item-title">${locales.translations.dealershipsinfo}</div>
                    </div>
                    <div class="finances-item-content">
                        <div class="stats-item" style="height: 33.3%;">
                            <div class="fff">${locales.translations.totaldealerships}</div>
                            <div class="d5d6da" id="total-dealerships"></div>
                        </div>
                        <div class="stats-item" style="height: 33.3%;">
                            <div class="fff">${locales.translations.withoutowner}</div>
                            <div class="d5d6da" id="without-owner"></div>
                        </div>
                        <div class="stats-item" style="height: 33.3%;">
                            <div class="fff">${locales.translations.totalmoney}</div>
                            <div class="d5d6da" id="total-money"></div>
                        </div>
                    </div>
                </div>
                <div class="item" style="height: 17.5rem;">
                    <div class="item-header">
                        <div class="item-title">${locales.translations.vehiclesinfo}</div>
                    </div>
                    <div class="stats-item-content">
                        <div class="stats-item" style="height: 33.3%;">
                            <div class="fff">${locales.translations.totalvehicles}</div>
                            <div class="d5d6da" id="total-vehicles">0</div>
                        </div>
                        <div class="stats-item" style="height: 33.3%;">
                            <div class="fff">${locales.translations.instock}</div>
                            <div class="d5d6da" id="in-stock">0</div>
                        </div>
                        <div class="stats-item" style="height: 33.3%;">
                            <div class="fff">${locales.translations.mostsold}</div>
                            <div class="d5d6da" id="most-sold">${mostSoldVehicle || locales.translations.na}</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="item-double" style="height: 22.5rem;">

                    <div id="popular-vehicles" class="item-content">
                        <table id="adminMenuTable" class="mt-dealerships">
                            <thead>
                                <tr>
                                    <th class="text-center">${locales.translations.name}</th>
                                    <th class="text-center">${locales.translations.owner}</th>
                                    <th class="text-center">${locales.translations.money}</th>
                                    <th class="text-center">${locales.translations.actions}</th>
                                </tr>
                            </thead>
                            <tbody id="adminMenuTableData"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>`);

    selectedWindow = "adminMenu";

    let row = ``;
    let totalMoney = 0;
    let totalDealerships = 0;
    let withoutOwner = 0;
    $('#adminMenuTableData').html('');

    if (typeof standsInfo === 'object' && !Array.isArray(standsInfo)) {
        const dealershipKeys = Object.keys(standsInfo).sort();

        for (let i = 0; i < dealershipKeys.length; i++) {
            const key = dealershipKeys[i];
            const standInfo = standsInfo[key];
            row += `
                <tr style="height: 4.075rem;">
                    <td class="text-center align-middle">${standInfo.label}</td>
                    <td class="text-center align-middle">${standInfo.owner_name || locales.translations.na}</td>
                    <td class="text-center align-middle">${setLocaleString(standInfo.money || 0)}</td>
                    <td class="text-center align-middle"><button onclick="openEditDealershipModal('${key}')" class="btn btn-blue btn-edit"><i class="fas fa-pen"></i> ${locales.translations.edit}</button></td>
                </tr>
            `;
            totalMoney += parseInt(standInfo.money) || 0;
            totalDealerships++;
            if (!standInfo.owner) {withoutOwner++}
        }
    }
    
    $('#total-dealerships').html(totalDealerships);
    $('#without-owner').html(withoutOwner);
    $('#total-money').html(setLocaleString(totalMoney));
    $('#total-vehicles').html(vehicleCount);
    $('#in-stock').html(vehicleStockCount);
    
    $('#adminMenuTableData').append(row);

    var table_id = document.getElementById('adminMenuTable');
    table.push(new simpleDatatables.DataTable(table_id, {
        perPageSelect: false,
        searchable: false,
        perPage: 3,
        labels: {
            placeholder: locales.translations.search,
            perPage: locales.translations.entriesperpage,
            noRows: locales.translations.nodealershipsfound,
            noResults: locales.translations.noresultsfound
        }
    }));

    setDatatableColor('#272727', '23.125rem', '2.2rem');

}

$(document).on('click', '#overview-stands-btn', function() {
    $('#vehiclesList, #vehiclesShowcase').hide();
    setupAdminMenu();
    $('#admin').css('display', 'flex');
});

$("#confirm-edit-vehicle-btn").click(async function() {
    const currentMinPrice = parseInt($("#vehicle_min_price").val()) || 0;
    const currentMaxPrice = parseInt($("#vehicle_max_price").val()) || 0;
    const currentCategory = $("#vehicle_category").val();
    const currentType = $("#vehicle_type").val();

    var modal = $('#editVehicleModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);

    const result = await retrieveNUI('editVehicle', { vehicleName: selectedVehicle.vehicle_name, vehicleId: selectedVehicle.vehicle_id, minPrice: currentMinPrice, maxPrice: currentMaxPrice, category: currentCategory, type: currentType });

    if (!result) return;

    allVehicleList = result;
    setupVehicleList();
});

$(document).on('click', '#delete-vehicle-btn', async function() {
    const vehicleId = selectedVehicle.vehicle_id;
    const vehicleName = selectedVehicle.vehicle_name;

    var modal = $('#editVehicleModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);

    const result = await retrieveNUI('deleteVehicle', { vehicleId: vehicleId, vehicleName: vehicleName });

    if (!result) return;
    allVehicleList = result;
    setupVehicleList();
});

$(document).on('click', '#add-vehicle-btn', async function() {
    $("#add_vehicle_title").html(locales.translations.addvehicle);
    $("#vehicle_name_add_title").html(locales.translations.vehiclename);
    $("#vehicle_id_add_title").html(locales.translations.vehicleid);
    $("#vehicle_category_add_title").html(locales.translations.category);
    $("#vehicle_type_add_title").html(locales.translations.type);
    $("#vehicle_min_price_add_title").html(locales.translations.minprice);
    $("#vehicle_max_price_add_title").html(locales.translations.maxprice);
    $("#cancel-add-vehicle-btn").html(locales.translations.cancel);
    $("#confirm-add-vehicle-btn").html(locales.translations.save);
    $("#vehicle_name_add, #vehicle_id_add, #vehicle_category_add, #vehicle_type_add, #vehicle_min_price_add, #vehicle_max_price_add").val('');

    $("#vehicle_name_add").attr('placeholder', locales.translations.exampleName);
    $("#vehicle_id_add").attr('placeholder', locales.translations.exampleId);
    $("#vehicle_category_add").attr('placeholder', locales.translations.exampleCategory);
    $("#vehicle_type_add").attr('placeholder', locales.translations.exampleType);
    $("#vehicle_min_price_add").attr('placeholder', locales.translations.exampleMinPrice);
    $("#vehicle_max_price_add").attr('placeholder', locales.translations.exampleMaxPrice);

    $("#vehicle_category_add, #vehicle_type_add").html('');

    for (let i = 0; i < uniqueCategories.length; i++) {
        $("#vehicle_category_add").append(`<option value="${uniqueCategories[i]}">${uniqueCategories[i]}</option>`);
    }
    for (let i = 0; i < uniqueTypes.length; i++) {
        $("#vehicle_type_add").append(`<option value="${uniqueTypes[i]}">${uniqueTypes[i]}</option>`);
    }

    var modal = document.getElementById('addVehicleModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
});

$(document).on('click', '#confirm-add-vehicle-btn', async function() {
    const currentMinPrice = parseInt($("#vehicle_min_price_add").val()) || 0;
    const currentMaxPrice = parseInt($("#vehicle_max_price_add").val()) || 0;
    const currentCategory = $("#vehicle_category_add").val();
    const currentType = $("#vehicle_type_add").val();
    const currentName = $("#vehicle_name_add").val();
    const currentId = $("#vehicle_id_add").val();

    var modal = $('#addVehicleModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);

    const result = await retrieveNUI('addVehicle', { vehicleName: currentName, vehicleId: currentId, minPrice: currentMinPrice, maxPrice: currentMaxPrice, category: currentCategory, type: currentType });

    if (!result) return;
    allVehicleList = result;
    setupVehicleList();
});

$(document).on('click', '#closeAddVehicleModal, #cancel-add-vehicle-btn', function() {
    var modal = $('#addVehicleModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});


function setupVehicleList() {
    $('#vehiclesList').html('');
    $('#vehiclesList').html(`
    <div class="info">
        <div class="logo">
            <div class="okok">${locales.translations.okok}</div>
            <div class="resource">${locales.translations.vehicleshop}</div>
        </div>
        <div class="navbar">
            <div class="navbar-items">
                <a id="overview-stands-btn" class="nav-item"><i class="bi bi-grid-1x2-fill"></i><span class="nav-item-text">${locales.translations.overview}</span></a>
                <a id="vehicles-stands-btn" class="nav-item nav-item-selected mt-05"><i class="bi bi-archive-fill"></i><span class="nav-item-text">${locales.translations.vehicles}</span></a>
                <a id="car-showcase-btn" class="nav-item mt-05"><i class="bi bi-car-front-fill"></i><span class="nav-item-text">${locales.translations.carshowcase}</span></a>
            </div>
            <div class="user-info">
                <div class="user-info-img">
                    <img src="./img/avatar_male.png" class="avatar">
                </div>
                <div class="user-info-data">
                    <span class="char-name">${playerName}</span>
                    <span class="grade">${locales.translations.admin}</span>
                </div>
                <div id="logout-btn" class="logout">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                </div>
            </div>
        </div>
    </div>
    
    <div class="content">
        <div class="page" style="display: flex; justify-content: space-between;">
            <span class="page-title">${locales.translations.vehicleslist}</span>
            <div class="page-actions">
                <button id="add-vehicle-btn" class="btn btn-blue"><i class="fas fa-plus"></i> ${locales.translations.addvehicle}</button>
            </div>

        </div>
        <div class="page-info">
            <table id="vehicleListTable" class="mt-vehicles">
                <thead>
                    <tr>
                        <th class="text-center">${locales.translations.vehiclename}</th>
                        <th class="text-center">${locales.translations.type}</th>
                        <th class="text-center">${locales.translations.minprice}</th>
                        <th class="text-center">${locales.translations.maxprice}</th>
                        <th class="text-center">${locales.translations.actions}</th>
                    </tr>
                </thead>
                <tbody id="vehicleListTableData"></tbody>
            </table>
        </div>
    </div>`);

    selectedWindow = "adminMenu";

    let row = ``;
    uniqueCategories = [];
    uniqueTypes = [];
    
    const sortedVehicleList = [...allVehicleList].sort((a, b) => {
        const aStartsWithNumber = /^\d/.test(a.vehicle_name);
        const bStartsWithNumber = /^\d/.test(b.vehicle_name);
        
        if (aStartsWithNumber && bStartsWithNumber) {
            return a.vehicle_name.localeCompare(b.vehicle_name, undefined, {numeric: true, sensitivity: 'base'});
        }
        
        if (aStartsWithNumber && !bStartsWithNumber) {
            return 1;
        }
        if (!aStartsWithNumber && bStartsWithNumber) {
            return -1;
        }
        
        return a.vehicle_name.localeCompare(b.vehicle_name, undefined, {sensitivity: 'base'});
    });

    $("#vehicle_category_add, #vehicle_type_add").html('');

    if (typeof standsInfo === 'object' && !Array.isArray(standsInfo)) {
        const dealershipKeys = Object.keys(standsInfo);
        for (let i = 0; i < dealershipKeys.length; i++) {
            const key = dealershipKeys[i];
            const standInfo = standsInfo[key];
            if (standInfo.type && !uniqueTypes.includes(standInfo.type)) {
                uniqueTypes.push(standInfo.type);
            }
        }
    }

    if (availableCategories && typeof availableCategories === 'object') {
        const categoryKeys = Object.keys(availableCategories);
        uniqueCategories = [...new Set([...uniqueCategories, ...categoryKeys])];
    } else if (Array.isArray(availableCategories)) {
        uniqueCategories = [...new Set([...uniqueCategories, ...availableCategories])];
    }

    for (let i = 0; i < sortedVehicleList.length; i++) {
        const vehicle = sortedVehicleList[i];
        const originalIndex = allVehicleList.indexOf(vehicle);

        row += `
            <tr>
                <td class="text-center align-middle">${vehicle.vehicle_name}</td>
                <td class="text-center align-middle">${vehicle.type}</td>
                <td class="text-center align-middle">${setLocaleString(vehicle.min_price)}</td>
                <td class="text-center align-middle">${setLocaleString(vehicle.max_price)}</td>
                <td class="text-center align-middle"><button onclick="openVehicleInfoModal(${originalIndex})" type="button" class="btn btn-blue btn-edit"><i class="fas fa-pen"></i> ${locales.translations.edit}</button></td>
            </tr>
        `;
    }
    
    $('#vehicleListTableData').append(row);

    var table_id = document.getElementById('vehicleListTable');
    table.push(new simpleDatatables.DataTable(table_id, {
        perPageSelect: false,
        searchable: true,
        perPage: 8,
        labels: {
            placeholder: locales.translations.search,
            perPage: locales.translations.entriesperpage,
            noRows: locales.translations.novehiclesfound,
            noResults: locales.translations.noresultsfound
        }
    }));

    setDatatableColor('#373737', '1rem', '1rem');
    setDatatableSearchSettings('10.6875rem', '1.0625rem', '0.3125rem', '8rem');

    $('#admin, #vehiclesShowcase').hide();
    $('#vehiclesList').css('display', 'flex');
}


$(document).on('click', '#vehicles-stands-btn', function() {
    setupVehicleList();
});

function openVehicleInfoModal(index) {
    vehicleInfo = allVehicleList[index];

    selectedVehicle = vehicleInfo;

    selectedWindow = "editVehicleModal";

    $("#edit_vehicle_title").html(locales.translations.editvehicle);
    $("#vehicle_name_title").html(locales.translations.vehiclename);
    $("#vehicle_category_title").html(locales.translations.category);
    $("#vehicle_type_title").html(locales.translations.type);
    $("#vehicle_min_price_title").html(locales.translations.minprice);
    $("#vehicle_max_price_title").html(locales.translations.maxprice);
    $("#cancel-edit-vehicle-btn").html(locales.translations.cancel);
    $("#confirm-edit-vehicle-btn").html(locales.translations.save);
    $("#delete-vehicle-btn").html(locales.translations.deletevehicle);

    $("#vehicle_category, #vehicle_type").html('');

    let categoryOptions = `<option value="${vehicleInfo.category}">${vehicleInfo.category}</option>`;
    for (let i = 0; i < uniqueCategories.length; i++) {
        if (uniqueCategories[i] !== vehicleInfo.category) {
            categoryOptions += `<option value="${uniqueCategories[i]}">${uniqueCategories[i]}</option>`;
        }
    }
    $("#vehicle_category").html(categoryOptions);

    let typeOptions = `<option value="${vehicleInfo.type}">${vehicleInfo.type}</option>`;
    for (let i = 0; i < uniqueTypes.length; i++) {
        if (uniqueTypes[i] !== vehicleInfo.type) {
            typeOptions += `<option value="${uniqueTypes[i]}">${uniqueTypes[i]}</option>`;
        }
    }
    $("#vehicle_type").html(typeOptions);

    $("#vehicle_name").val(vehicleInfo.vehicle_name);
    $("#vehicle_min_price").val(vehicleInfo.min_price);
    $("#vehicle_max_price").val(vehicleInfo.max_price);
    var modal = document.getElementById('editVehicleModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
}

function setupVehicleShowcase() {
    $('#vehiclesShowcase').html('');

    $('#vehiclesShowcase').html(`
    <div class="info">
        <div class="logo">
            <div class="okok">${locales.translations.okok}</div>
            <div class="resource">${locales.translations.vehicleshop}</div>
        </div>
        <div class="navbar">
            <div class="navbar-items">
                <a id="overview-stands-btn" class="nav-item"><i class="bi bi-grid-1x2-fill"></i><span class="nav-item-text">${locales.translations.overview}</span></a>
                <a id="vehicles-stands-btn" class="nav-item mt-05"><i class="bi bi-archive-fill"></i><span class="nav-item-text">${locales.translations.vehicles}</span></a>
                <a id="car-showcase-btn" class="nav-item nav-item-selected mt-05"><i class="bi bi-car-front-fill"></i><span class="nav-item-text">${locales.translations.carshowcase}</span></a>
            </div>
            <div class="user-info">
                <div class="user-info-img">
                    <img src="./img/avatar_male.png" class="avatar">
                </div>
                <div class="user-info-data">
                    <span class="char-name">${playerName}</span>
                    <span class="grade">${locales.translations.admin}</span>
                </div>
                <div id="logout-btn" class="logout">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                </div>
            </div>
        </div>
    </div>
    
    <div class="content">
        <div class="page" style="display: flex; justify-content: space-between;">
            <span class="page-title">${locales.translations.vehicleshowcase}</span>
            <div class="page-actions">
                <button id="add-showcase-vehicle-btn" class="btn btn-blue"><i class="fas fa-plus"></i> ${locales.translations.addvehicle}</button>
            </div>
        </div>
        <div class="page-info">
            <table id="vehicleShowcaseTable" class="mt-vehicles">
                <thead>
                    <tr>
                        <th class="text-center">${locales.translations.vehiclename}</th>
                        <th class="text-center">${locales.translations.shop}</th>
                        <th class="text-center">${locales.translations.plate}</th>
                        <th class="text-center">${locales.translations.actions}</th>
                    </tr>
                </thead>
                <tbody id="vehicleShowcaseTableData"></tbody>
            </table>
        </div>
    </div>`);

    selectedWindow = "vehicleShowcase";

    let row = ``;
    for (let i = 0; i < vehicleShowcaseData.length; i++) {
        const vehicle = vehicleShowcaseData[i];
        row += `
            <tr>
                <td class="text-center align-middle">${vehicle.vehicle_name}</td>
                <td class="text-center align-middle">${vehicle.shop}</td>
                <td class="text-center align-middle">${vehicle.plate}</td>
                <td class="text-center align-middle"><button onclick="deleteVehicleShowcase(${i})" type="button" class="btn btn-red btn-edit"><i class="fas fa-trash"></i> ${locales.translations.delete}</button></td>
            </tr>
        `;
    }
    $('#vehicleShowcaseTableData').append(row);

    var table_id = document.getElementById('vehicleShowcaseTable');
    table.push(new simpleDatatables.DataTable(table_id, {
        perPageSelect: false,
        searchable: true,
        perPage: 8,
        labels: {
            placeholder: locales.translations.search,
            perPage: locales.translations.entriesperpage,
            noRows: locales.translations.novehiclesfound,
            noResults: locales.translations.noresultsfound
        }
    }));

    setDatatableColor('#373737', '1rem', '1rem');
    setDatatableSearchSettings('10.6875rem', '1.0625rem', '0.3125rem', '8rem');

    $('#admin, #vehiclesList').hide();
    $('#vehiclesShowcase').css('display', 'flex');
}

function setupVehicleDashboardShowcase() {
    $('#vehiclesShowcase').html('');

    $('#vehiclesShowcase').html(`
    <div class="info">
        <div class="logo">
            <div class="okok">okok</div>
            <div class="resource">Vehicle Shop</div>
        </div>
        <div class="navbar">
            <div class="navbar-items">
                <a id="overview-btn" class="nav-item"><i class="bi bi-grid-1x2-fill"></i><span class="nav-item-text">${locales.translations.overview}</span></a>
                <a id="stock-btn" class="nav-item mt-05"><i class="bi bi-archive-fill"></i><span class="nav-item-text">${locales.translations.stock}</span></a>
                <a id="saleshistory-btn" class="nav-item mt-05"><i class="bi bi-file-earmark-check-fill"></i><span class="nav-item-text">${locales.translations.saleshistory}</span></a>
                <a id="employees-btn" class="nav-item mt-05"><i class="bi bi-people-fill"></i><span class="nav-item-text">${locales.translations.employees}</span></a>
                <a id="orders-btn" class="nav-item mt-05"><i class="bi bi-pin-map-fill"></i><span class="nav-item-text">${locales.translations.orders}</span></a>
                <a id="customerorders-btn" class="nav-item mt-05"><i class="bi bi-bag-fill"></i><span class="nav-item-text">${locales.translations.customerorders}</span></a>
                <a id="logs-btn" class="nav-item mt-05"><i class="bi bi-folder-fill"></i><span class="nav-item-text">${locales.translations.logs}</span></a>
                <a id="car-showcase-dashboard-btn" class="nav-item mt-05 nav-item-selected"><i class="bi bi-car-front-fill"></i><span class="nav-item-text">${locales.translations.carshowcase}</span></a>
                <a id="sell-business" class="nav-item mt-05 sell-business"><i class="bi bi-building-fill-x"></i><span class="nav-item-text">${locales.translations.sellbusiness}</span></a>
            </div>
            <div class="user-info">
                 <div class="user-info-img">
                     <img src="${playerSex == "0" ? "./img/avatar_male.png" : "./img/avatar_female.png"}" class="avatar">
                 </div>
                <div class="user-info-data">
                    <span class="char-name">${playerName}</span>
                    <span class="grade">${playerGrade}</span>
                </div>
                <div id="logout-btn" class="logout">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                </div>
            </div>
        </div>
    </div>
    
    <div class="content">
        <div class="page" style="display: flex; justify-content: space-between;">
            <span class="page-title">${locales.translations.vehicleshowcase}</span>
            <div class="page-actions">
                <button id="add-showcase-dashboard-vehicle-btn" class="btn btn-blue"><i class="fas fa-plus"></i> ${locales.translations.addvehicle}</button>
            </div>
        </div>
        <div class="page-info">
            <table id="vehicleShowcaseTable" class="mt-vehicles">
                <thead>
                    <tr>
                        <th class="text-center">${locales.translations.vehiclename}</th>
                        <th class="text-center">${locales.translations.shop}</th>
                        <th class="text-center">${locales.translations.plate}</th>
                        <th class="text-center">${locales.translations.actions}</th>
                    </tr>
                </thead>
                <tbody id="vehicleShowcaseTableData"></tbody>
            </table>
        </div>
    </div>`);

    selectedWindow = "vehicleDashboardShowcase";

    if (standInfo.owner != playerIdentifier) {
        if (!isSubowner) {
            $("#overview-btn, #stock-btn, #saleshistory-btn, #employees-btn, #logs-btn, #car-showcase-dashboard-btn, .sell-business").hide();
        }
    }

    if (isSubowner) { $(".sell-business").hide()}

    let row = ``;
    // Filter vehicles to show only those belonging to the current stand
    const currentStandId = standInfo.id;
    
    for (let i = 0; i < vehicleShowcaseData.length; i++) {
        const vehicle = vehicleShowcaseData[i];
        
        // Only show vehicles that belong to the current stand
        if (vehicle.shop === currentStandId) {
            row += `
                <tr>
                    <td class="text-center align-middle">${vehicle.vehicle_name}</td>
                    <td class="text-center align-middle">${vehicle.shop}</td>
                    <td class="text-center align-middle">${vehicle.plate}</td>
                    <td class="text-center align-middle"><button onclick="deleteVehicleShowcase(${i})" type="button" class="btn btn-red btn-edit"><i class="fas fa-trash"></i> ${locales.translations.delete}</button></td>
                </tr>
            `;
        }
    }
    $('#vehicleShowcaseTableData').append(row);

    var table_id = document.getElementById('vehicleShowcaseTable');
    table.push(new simpleDatatables.DataTable(table_id, {
        perPageSelect: false,
        searchable: true,
        perPage: 8,
        labels: {
            placeholder: locales.translations.search,
            perPage: locales.translations.entriesperpage,
            noRows: locales.translations.novehiclesfound,
            noResults: locales.translations.noresultsfound
        }
    }));

    setDatatableColor('#373737', '1rem', '1rem');
    setDatatableSearchSettings('10.6875rem', '1.0625rem', '0.3125rem', '8rem');

    $('#admin, #vehiclesList').hide();
    $('#vehiclesShowcase').css('display', 'flex');
}

$(document).on('click', '#add-showcase-vehicle-btn', function() {
    $("#add_vehicle_showcase_title").html(locales.translations.addvehicle);
    $("#vehicle_name_showcase_add_title").html(locales.translations.vehiclename);
    $("#vehicle_id_showcase_add_title").html(locales.translations.vehicleid)
    $("#vehicle_shop_showcase_add_title").html(locales.translations.shop);
    $("#vehicle_color_showcase_add_title").html(locales.translations.color);
    $("#vehicle_plate_showcase_add_title").html(locales.translations.plate);
    $("#vehicle_name_showcase_add").attr('placeholder', locales.translations.vehiclename);
    $("#vehicle_id_showcase_add").attr('placeholder', locales.translations.vehicleid);
    $("#vehicle_color_showcase_add").attr('placeholder', '255, 255, 255');
    $("#vehicle_plate_showcase_add").attr('placeholder', locales.translations.plate);
    $("#cancel-add-vehicle-showcase-btn").html(locales.translations.cancel);
    $("#confirm-add-vehicle-showcase-btn").html(locales.translations.add);

    const shopOptions = Object.entries(standsInfo)
        .sort(([keyA], [keyB]) => keyA.localeCompare(keyB))
        .map(([key, shop]) => {
            return `<option value="${key}">${key}</option>`;
        }).join('');
    $("#vehicle_shop_showcase_add").html(shopOptions);
    $("#vehicle_shop_showcase_add").prop('disabled', false); // Ensure dropdown is enabled for admin

    var modal = document.getElementById('addVehicleShowcaseModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
});

$(document).on('click', '#add-showcase-dashboard-vehicle-btn', function() {
    $("#add_vehicle_showcase_title").html(locales.translations.addvehicle);
    $("#vehicle_name_showcase_add_title").html(locales.translations.vehiclename);
    $("#vehicle_id_showcase_add_title").html(locales.translations.vehicleid)
    $("#vehicle_shop_showcase_add_title").html(locales.translations.shop);
    $("#vehicle_color_showcase_add_title").html(locales.translations.color);
    $("#vehicle_plate_showcase_add_title").html(locales.translations.plate);
    $("#vehicle_name_showcase_add").attr('placeholder', locales.translations.vehiclename);
    $("#vehicle_id_showcase_add").attr('placeholder', locales.translations.vehicleid);
    $("#vehicle_color_showcase_add").attr('placeholder', '255, 255, 255');
    $("#vehicle_plate_showcase_add").attr('placeholder', locales.translations.plate);
    $("#cancel-add-vehicle-showcase-btn").html(locales.translations.cancel);
    $("#confirm-add-vehicle-showcase-btn").html(locales.translations.add);

    // Use standInfo instead of standsInfo and lock to current stand
    const currentStandId = standInfo.id;
    const shopOptions = `<option value="${currentStandId}">${currentStandId}</option>`;
    $("#vehicle_shop_showcase_add").html(shopOptions);
    $("#vehicle_shop_showcase_add").prop('disabled', true);

    var modal = document.getElementById('addVehicleShowcaseModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
});

$(document).on('click', '#closeAddVehicleShowcaseModal, #cancel-add-vehicle-showcase-btn', function() {
    var modal = $('#addVehicleShowcaseModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$(document).on('click', '#confirm-add-vehicle-showcase-btn', function() {
    var modal = $('#addVehicleShowcaseModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
        $("#vehicle_name_showcase_add, #vehicle_id_showcase_add, #vehicle_color_showcase_add, #vehicle_plate_showcase_add").val('');
    }, 500);
    closeMenu();

    const vehicleName = $("#vehicle_name_showcase_add").val();
    const vehicleId = $("#vehicle_id_showcase_add").val();
    const vehicleColor = $("#vehicle_color_showcase_add").val();
    const vehiclePlate = $("#vehicle_plate_showcase_add").val();
    const vehicleShop = $("#vehicle_shop_showcase_add").val();

    $("#confirm-add-vehicle-showcase-btn").prop('disabled', true);

    retrieveNUI('addVehicleShowcase', { vehicleName: vehicleName, vehicleId: vehicleId, vehicleColor: vehicleColor, vehiclePlate: vehiclePlate, vehicleShop: vehicleShop });
});

function deleteVehicleShowcase(index) {
    const vehicle = vehicleShowcaseData[index];

    vehicleShowcaseSelected = vehicle;

    $("#delete_vehicle_showcase_title").html(locales.translations.deletevehicle);
    $("#delete_vehicle_showcase_text").html(locales.translations.doyouwanttodelete + " " + vehicle.vehicle_name + "?");
    var modal = document.getElementById('deleteVehicleShowcaseModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
    $("#cancel_delete_vehicle_showcase_btn").html(locales.translations.cancel);
    $("#delete_vehicle_showcase_btn").html(locales.translations.delete);
}

$(document).on('click', '#delete_vehicle_showcase_btn', function() {
    var modal = $('#deleteVehicleShowcaseModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);

    retrieveNUI('deleteVehicleShowcase', { vehicle: vehicleShowcaseSelected });
});

$(document).on('click', '#cancel_delete_vehicle_showcase_btn, #closeDeleteVehicleShowcaseModal', function() {
    var modal = $('#deleteVehicleShowcaseModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$(document).on('click', '#car-showcase-btn', function() {
    setupVehicleShowcase();
});

$(document).on('click', '#car-showcase-dashboard-btn', function() {
    $('#dashboard, #stock, #salesHistory, #employees, #orders, #customerorders, #logs').hide();
    setupVehicleDashboardShowcase();
    $('#vehiclesShowcase').show();
});

function openEditDealershipModal(key) {
    const dealership = standsInfo[key];
    $("#dealership_name").val(dealership.label);
    $("#dealership_owner_name").val(dealership.owner_name || locales.translations.na);
    $("#dealership_money").val(dealership.money || 0);
    $("#dealership_type").val(dealership.type);
    $("#dealership_owner_id").val(dealership.owner || locales.translations.na);
    if (!dealership.owner) {
        $("#dealership_money").prop('readonly', true);
    } else {
        $("#dealership_money").prop('readonly', false);
    }
    standMoney = dealership.money;
    standId = key;
    standOwnerId = dealership.owner;
    var modal = document.getElementById('editDealershipModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
}

$(document).on('click', '#confirm-dealership-modal-btn', async function() {
    const currentMoney = parseInt($("#dealership_money").val()) || 0;
    const currentOwnerId = $("#dealership_owner_id").val();
    const result = await retrieveNUI('editDealership', { standId: standId, money: currentMoney, ownerId: currentOwnerId });
    var modal = $('#editDealershipModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
    $("#confirm-dealership-modal-btn").prop('disabled', true);
    if (!result) return;
    standsInfo = result;
    setupAdminMenu();
});

function setupMyFinancedVehicles() {
    $('#my-financed-vehicles-container').html('');

    $('#my-financed-vehicles-container').html(`
        <div class="page-info padding-0">
                <table id="myOrdersTable" style="margin-bottom: -0.625rem;">
                    <thead>
                        <tr>
                            <th class="text-center">${locales.translations.vehiclename}</th>
                            <th class="text-center">${locales.translations.remainingvalue}</th>
                            <th class="text-center">${locales.translations.months}</th>
                            <th class="text-center">${locales.translations.nextpayment}</th>
                            <th class="text-center">${locales.translations.action}</th>
                        </tr>
                    </thead>
                    <tbody id="myOrdersTableData"></tbody>
                </table>
                </div>
            </div>
        </div>
        `);

    $('#myFinancedVehiclesTableData').html(``)

    if (financedVehicles) {
        if (financedVehicles.length > 6) {
            $('#myFinancedVehiclesTable').css('margin-bottom', '2.465rem');
        } else {
            $('#myFinancedVehiclesTable').css('margin-bottom', '-0.625rem');
        }
    }

    let row = ``;
    for (let i = 0; i < financedVehicles.length; i++) {
        const vehicleInfo = financedVehicles[i];
        const missingAmount = vehicleInfo.finance_amount - vehicleInfo.paid_amount;
        const monthsLeft = vehicleInfo.total_payments - vehicleInfo.success_payments;
        row += `
            <tr>
                <td class="text-center align-middle">${vehicleInfo.vehicle_name}</td>
                <td class="text-center align-middle">${setLocaleString(missingAmount)}</td>
                <td class="text-center align-middle">${monthsLeft} ${locales.translations.monthsleft}</td>
                <td class="text-center align-middle">${vehicleInfo.is_less_than_minute ? locales.translations.lessthanaminute : (vehicleInfo.is_hours ? vehicleInfo.next_payment + ' ' + locales.translations.hours : vehicleInfo.next_payment + ' ' + locales.translations.minutes)}</td>
                <td class="text-center align-middle"><button onclick="openFinancedVehicleInfo(${i})" type="button" class="btn btn-blue btn-edit"><i class="fas fa-eye"></i> ${locales.translations.view}</button></td>
            </tr>
        `;
    }
    $('#myOrdersTableData').append(row);

    var table_id = document.getElementById('myOrdersTable');
    table.push(new simpleDatatables.DataTable(table_id, {
        perPageSelect: false,
        searchable: false,
        perPage: 6,
        labels: {
            placeholder: locales.translations.search,
            perPage: locales.translations.entriesperpage,
            noRows: locales.translations.novehiclesfound,
            noResults: locales.translations.noresultsfound
        }
    }));
    
    var modal = document.getElementById('myFinancedVehiclesModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
}

function openFinancedVehicleInfo(index) {
    financedVehicleInfo = financedVehicles[index];
    var modal = $('#myFinancedVehiclesModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);

    setTimeout(function() {
        selectedWindow = "financedVehicleInfoModal";
        const vehicleInfo = financedVehicles[index];
        const missingAmount = vehicleInfo.finance_amount - vehicleInfo.paid_amount;
        $("#vehicle_finance_name_info_title").html(locales.translations.vehiclename);
        $("#vehicle_finance_remaining_value_title").html(locales.translations.remainingvalue + " (" + currency + ")");
        $("#finance_vehicle_info_title").html(locales.translations.vehiclefinancedinfo);
        $("#vehicle_finance_total_amount_title").html(locales.translations.totalamount + " (" + currency + ")");
        $("#vehicle_finance_remaining_value_title").html(locales.translations.remainingvalue + " (" + currency + ")");
        $("#vehicle_finance_monthly_payment_info_title").html(locales.translations.monthlypayment + " (" + currency + ")");
        $("#payment_progress_title").html(locales.translations.paymentprogress);
        $("#make_finance_payment_btn").html(locales.translations.makepayment);
        $("#pay_off_loan_btn").html(locales.translations.payoffloan);

        $("#vehicle_finance_info_name").val(vehicleInfo.vehicle_name);
        $("#vehicle_finance_monthly_payment_info").val(setLocaleString(vehicleInfo.monthly_payment));
        $("#vehicle_finance_total_amount").val(setLocaleString(vehicleInfo.finance_amount));
        $("#vehicle_finance_remaining_value").val(setLocaleString(missingAmount));

        createPaymentProgressBar(vehicleInfo.total_payments, vehicleInfo.success_payments);

        var modal = document.getElementById('financedVehicleInfoModal');
        modal.style.display = 'flex';
        setTimeout(function () {
            modal.classList.add('show');
        }, 50);
    }, 250);
}

$(document).on('click', '#make_finance_payment_btn', async function() {
    var result = await retrieveNUI('makeFinancePayment', { vehicleInfo: financedVehicleInfo })

    if (!result) return;

    const vehicleInfo = result;

    if (vehicleInfo.success_payments == vehicleInfo.total_payments) {
        var modal = $('#financedVehicleInfoModal');
        modal.removeClass('show');
        setTimeout(function () {
            modal.css('display', 'none');
        }, 500);
        retrieveNUI('closeMenu', {})
        return;
    }

    const missingAmount = vehicleInfo.finance_amount - vehicleInfo.paid_amount;
    $("#vehicle_finance_name_info_title").html(locales.translations.vehiclename);
    $("#vehicle_finance_remaining_value_title").html(locales.translations.remainingvalue + " (" + currency + ")");
    $("#finance_vehicle_info_title").html(locales.translations.vehiclefinancedinfo);
    $("#vehicle_finance_total_amount_title").html(locales.translations.totalamount + " (" + currency + ")");
    $("#vehicle_finance_remaining_value_title").html(locales.translations.remainingvalue + " (" + currency + ")");
    $("#vehicle_finance_monthly_payment_info_title").html(locales.translations.monthlypayment + " (" + currency + ")");
    $("#payment_progress_title").html(locales.translations.paymentprogress);
    $("#make_finance_payment_btn").html(locales.translations.makepayment);
    $("#pay_off_loan_btn").html(locales.translations.payoffloan);

    $("#vehicle_finance_info_name").val(vehicleInfo.vehicle_name);
    $("#vehicle_finance_monthly_payment_info").val(setLocaleString(vehicleInfo.monthly_payment));
    $("#vehicle_finance_total_amount").val(setLocaleString(vehicleInfo.finance_amount));
    $("#vehicle_finance_remaining_value").val(setLocaleString(missingAmount));

    addSinglePayment(vehicleInfo.success_payments);

})

$(document).on('click', '#pay_off_loan_btn', async function() {
    var result = await retrieveNUI('payOffLoan', { vehicleInfo: financedVehicleInfo })

    if (!result) return;
    retrieveNUI('closeMenu', {})
    var modal = $('#financedVehicleInfoModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
})

// UI Setup

function filterVehicles(searchTerm) {
    if (!window.baseVehicleData) return;

    const baseList = window.baseVehicleData;
    const previouslySelectedId = vehicleSelected ? vehicleSelected.vehicle_id : null;

    if (!searchTerm || searchTerm.trim() === '') {
        window.currentVehicleData = baseList;
        window.originalVehicleData = baseList;
        let autoSelectIndex = -1;
        if (previouslySelectedId) {
            autoSelectIndex = baseList.findIndex(v => v.vehicle_id === previouslySelectedId);
        }
        if (vehicleListingType == 'categories') {
            updateVehicleListPrimary(autoSelectIndex);
        } else {
            updateVehicleList(autoSelectIndex);
        }
        return;
    }

    const filteredVehicles = baseList.filter(vehicle => {
        const vehicleName = vehicle.vehicle_name.toLowerCase();
        const vehicleId = vehicle.vehicle_id.toLowerCase();
        return vehicleName.includes(searchTerm) || vehicleId.includes(searchTerm);
    });

    window.currentVehicleData = filteredVehicles;
    window.originalVehicleData = filteredVehicles;

    let autoSelectIndex = -1;
    if (previouslySelectedId) {
        autoSelectIndex = filteredVehicles.findIndex(v => v.vehicle_id === previouslySelectedId);
    }
    if (vehicleListingType == 'categories') {
        updateVehicleListPrimary(autoSelectIndex);
    } else {
        updateVehicleList(autoSelectIndex);
    }
}

function startTestDriveCountdown(seconds) {
    clearInterval(testDriveInterval);
    let remaining = seconds;
    $("#test-drive-text").html(`${locales.translations.endtestdrive} ${remaining} ${locales.translations.seconds}`);
    testDriveInterval = setInterval(function() {
        remaining--;
        if (remaining > 0) {
            $("#test-drive-text").html(`${locales.translations.endtestdrive} ${remaining} ${locales.translations.seconds}`);
        } else {
            clearInterval(testDriveInterval);
            $(".test-drive-container").fadeOut();
        }
    }, 1000);
}

function updateVehicleListPrimary(selectedIndex = 0) {
    if (!window.currentVehicleData) return;

    let row = "";
    const standInfo = window.standInfo || { id: 'default' };

    for (let i = 0; i < window.currentVehicleData.length; i++) {
        const vehicle = window.currentVehicleData[i];

        if (vehicle.type != standInfo.type) {continue}

        let stockData = vehicle.stock;
        if (typeof stockData === 'string') {
            try {
                stockData = JSON.parse(stockData);
            } catch (e) {
                stockData = {};
            }
        }
        
        if (!stockData || typeof stockData !== 'object') {stockData = {}}

        const currentStandStock = stockData[standInfo.id] || {amount: 0, price: 0, listed: true};

        if (currentStandStock.amount > 0) {vehicle.status = "in-stock"} else {vehicle.status = "out-of-stock"}

        if (!currentStandStock.listed) {currentStandStock.listed = true}

        let displayPrice;
        if (currentStandStock.price == 0 || !currentStandStock.price) {
            displayPrice = setLocaleString(vehicle.max_price);
        } else {
            displayPrice = setLocaleString(currentStandStock.price);
        }

        let imageUrl;
        if (useSameImageForAllVehicles) {
            imageUrl = `img/vehicles/default.png`;
        } else if (useLocalImages) {
            imageUrl = `img/vehicles/${vehicle.vehicle_id}.png`;
        } else {
            imageUrl = `https://raw.githubusercontent.com/SrPeterr/okokvehicle-images/refs/heads/main/vehicles-all/${vehicle.vehicle_id}.png`;
        }

        const imgElement = `<img src="${imageUrl}" class="vehicle-card-image-size" onerror="if (!this._attemptedLocal) {this._attemptedLocal = true; this.src='img/vehicles/${vehicle.vehicle_id}.png';} else {this.onerror=null;this.src='img/vehicles/default.png';}">`;

        const actualIndex = window.originalVehicleData.findIndex(v => v.vehicle_id === vehicle.vehicle_id);
        
        // Get vehicle class from vehiclesWithClasses
        let vehicleClass = 'N/A';
        if (vehiclesWithClasses && vehiclesWithClasses[vehicle.vehicle_id]) {
            vehicleClass = vehiclesWithClasses[vehicle.vehicle_id].class || 'N/A';
        }

        row += `
            <div class="vehicle-card" onclick="selectVehicle(${i}, true)" data-original-index="${actualIndex}">
                <div class="top-card-info">
                    <div class="vehicle-status ${vehicle.status}">
                        ${vehicle.status == 'in-stock' ? locales.translations.onstock : locales.translations.outofstock}
                    </div>
                    <div class="vehicle-amount">
                        <div class="vehicle-amount-available">${currentStandStock.amount}</div>
                        <svg class="vehicle-amount-icon" xmlns="http://www.w3.org/2000/svg"  width="22"  height="22"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-car"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M7 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M5 17h-2v-6l2 -5h9l4 5h1a2 2 0 0 1 2 2v4h-2m-4 0h-6m-6 -6h15m-6 0v-5" /></svg>
                    </div>
                </div>
                <div class="vehicle-card-image">
                    ${imgElement}
                </div>
                <div class="vehicle-card-info-2">
                    <div class="vehicle-card-info">
                        <div class="vehicle-card-info-name">${vehicle.vehicle_name}</div>
                        <div class="vehicle-card-info-title">${displayPrice}</div>
                    </div>
                    ${vehicleClass !== 'N/A' ? `<div class="vehicle-card-class" style="font-size:${vehicleClass === 'S+' ? '0.875rem' : '1rem'}">${vehicleClass}</div>` : ''}
                </div>
            </div> 
        `;
    }

    $('#vehicle-list-primary').html(row);

    if (selectedIndex >= 0 && selectedIndex < window.currentVehicleData.length) {
        selectVehicle(selectedIndex, false);
    }
}

function updateVehicleList(selectedIndex = 0) {
    if (!window.currentVehicleData) return;

    let row = "";
    const standInfo = window.standInfo || { id: 'default' };

    for (let i = 0; i < window.currentVehicleData.length; i++) {
        const vehicle = window.currentVehicleData[i];

        if (vehicle.type != standInfo.type) {continue}

        let stockData = vehicle.stock;
        if (typeof stockData === 'string') {
            try {
                stockData = JSON.parse(stockData);
            } catch (e) {
                stockData = {};
            }
        }
        
        if (!stockData || typeof stockData !== 'object') {stockData = {}}

        const currentStandStock = stockData[standInfo.id] || {amount: 0, price: 0, listed: true};

        if (currentStandStock.amount > 0) {vehicle.status = "in-stock"} else {vehicle.status = "out-of-stock"}

        if (!currentStandStock.listed) {currentStandStock.listed = true}

        let displayPrice;
        if (currentStandStock.price == 0 || !currentStandStock.price) {
            displayPrice = setLocaleString(vehicle.max_price);
        } else {
            displayPrice = setLocaleString(currentStandStock.price);
        }

        let imageUrl;
        if (useSameImageForAllVehicles) {
            imageUrl = `img/vehicles/default.png`;
        } else if (useLocalImages) {
            imageUrl = `img/vehicles/${vehicle.vehicle_id}.png`;
        } else {
            imageUrl = `https://raw.githubusercontent.com/SrPeterr/okokvehicle-images/refs/heads/main/vehicles-all/${vehicle.vehicle_id}.png`;
        }

        const imgElement = `<img src="${imageUrl}" class="vehicle-card-image-size" onerror="if (!this._attemptedLocal) {this._attemptedLocal = true; this.src='img/vehicles/${vehicle.vehicle_id}.png';} else {this.onerror=null;this.src='img/vehicles/default.png';}">`;

        const actualIndex = window.originalVehicleData.findIndex(v => v.vehicle_id === vehicle.vehicle_id);
        
        // Get vehicle class from vehiclesWithClasses
        let vehicleClass = 'N/A';
        if (vehiclesWithClasses && vehiclesWithClasses[vehicle.vehicle_id]) {
            vehicleClass = vehiclesWithClasses[vehicle.vehicle_id].class || 'N/A';
        }

        row += `
            <div class="vehicle-card-second" onclick="selectVehicle(${i}, true)" data-original-index="${actualIndex}">
                <div class="top-card-info">
                    <div class="vehicle-status ${vehicle.status}">
                        ${vehicle.status == 'in-stock' ? locales.translations.onstock : locales.translations.outofstock}
                    </div>
                    <div class="vehicle-amount">
                        <div class="vehicle-amount-available">${currentStandStock.amount}</div>
                        <svg class="vehicle-amount-icon" xmlns="http://www.w3.org/2000/svg"  width="22"  height="22"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-car"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M7 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M5 17h-2v-6l2 -5h9l4 5h1a2 2 0 0 1 2 2v4h-2m-4 0h-6m-6 -6h15m-6 0v-5" /></svg>
                    </div>
                </div>
                <div class="vehicle-card-image">
                    ${imgElement}
                </div>
                <div class="vehicle-card-info-2">
                    <div class="vehicle-card-info">
                        <div class="vehicle-card-info-name">${vehicle.vehicle_name}</div>
                        <div class="vehicle-card-info-title">${displayPrice}</div>
                    </div>
                    ${vehicleClass !== 'N/A' 
  ? `<div class="vehicle-card-class" style="font-size:${vehicleClass === 'S+' ? '0.875rem' : '1rem'}">${vehicleClass}</div>` 
  : ''}
                </div>
            </div> 
        `;
    }

    $('#vehicles-list-second').html(row);

    if (selectedIndex >= 0 && selectedIndex < window.currentVehicleData.length) {
        selectVehicle(selectedIndex, false);
    }
}

function selectVehicle(index, isClick, skipUpdateLastSelected = false) {

    var selectedVehicleFromCurrent = window.currentVehicleData[index];
    var newIndex = index;
    if (!selectedVehicleFromCurrent) { 
        selectedVehicleFromCurrent = window.currentVehicleData[0];
        newIndex = 0;
    }

    selectedCategory = null;

    if (vehicleListingType == 'categories') {
        $('.vehicle-card').removeClass('vehicle-card-selected');
        $('.vehicle-card').eq(newIndex).addClass('vehicle-card-selected');
    } else {
        $('.vehicle-card-second').removeClass('vehicle-card-selected');
        $('.vehicle-card-second').eq(newIndex).addClass('vehicle-card-selected');
    }

    selectedVehicleIndex = newIndex;
    
    let stockData = selectedVehicleFromCurrent.stock;
        if (typeof stockData === 'string') {
            try {
                stockData = JSON.parse(stockData);
            } catch (e) {
                stockData = {};
            }
        }
        
        if (!stockData || typeof stockData !== 'object') {stockData = {}}

        const currentStandStock = stockData[standInfo.id] || {amount: 0, price: 0, listed: true};

        if (currentStandStock.amount > 0) {selectedVehicleFromCurrent.status = "in-stock"} else {selectedVehicleFromCurrent.status = "out-of-stock"}

        if (!currentStandStock.listed) {currentStandStock.listed = true}

        let displayPrice;
        if (isStandVip) {
            if (currentStandStock.price == 0 || !currentStandStock.price) {
                displayPrice = setLocaleStringVip(selectedVehicleFromCurrent.max_price);
            } else {
                displayPrice = setLocaleStringVip(currentStandStock.price);
            }
        } else {
            if (currentStandStock.price == 0 || !currentStandStock.price) {
                displayPrice = setLocaleString(selectedVehicleFromCurrent.max_price);
            } else {
                displayPrice = setLocaleString(currentStandStock.price);
            }
        }
    
    let actualIndex = 0;
    if (window.originalVehicleData && selectedVehicleFromCurrent) {
        actualIndex = window.originalVehicleData.findIndex(v => v.vehicle_id === selectedVehicleFromCurrent.vehicle_id);
    }
    
    if (currentStandStock.discount > 0) {

        $('#vehicle-price-value').html(setLocaleString(Math.floor(currentStandStock.price * (1 - currentStandStock.discount / 100))));
    } else {
        $('#vehicle-price-value').html(displayPrice);
    }
    $('#vehicle-name').html(selectedVehicleFromCurrent.vehicle_name);
    if (isClick) {
        retrieveNUI('selectVehicle', { vehicle: selectedVehicleFromCurrent, vehicleIndex: actualIndex });
    }

    if (selectedVehicleFromCurrent.status == "in-stock") {
        $('#purchase-vehicle-button-icon').html(`<svg xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="1.5"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-shopping-cart"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M6 19m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 19m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 17h-11v-14h-2" /><path d="M6 5l14 1l-1 7h-13" /></svg>`);
        $('#purchase-vehicle-button-text').html(locales.translations.purchasevehicle);
    } else {
        $('#purchase-vehicle-button-icon').html(`<svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-loader"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 6l0 -3" /><path d="M16.25 7.75l2.15 -2.15" /><path d="M18 12l3 0" /><path d="M16.25 16.25l2.15 2.15" /><path d="M12 18l0 3" /><path d="M7.75 16.25l-2.15 2.15" /><path d="M6 12l-3 0" /><path d="M7.75 7.75l-2.15 -2.15" /></svg>`);
        $('#purchase-vehicle-button-text').html(locales.translations.ordervehicle); 
    }

    vehicleSelected = selectedVehicleFromCurrent;

    if (currentStandStock.price == 0 || !currentStandStock.price) {
        vehicleSelected.price = selectedVehicleFromCurrent.max_price;
        vehicleSelected.discount = 0;
    } else {
        vehicleSelected.price = currentStandStock.price;
        vehicleSelected.discount = currentStandStock.discount;
    }

    selectedVehicle = actualIndex;

    if (!skipUpdateLastSelected) {
        window.lastSelectedIndex = actualIndex;
    }

    // Update trade-in options when a new vehicle is selected
    updateTradeinOptions();
    restartCustomPlate();
    
    // Reset trade-in dropdown to "None" and update display
    if (tradeinSelect) {
        tradeinSelect.value = '0';
        // Trigger the price display update to show 0 trade-in value
        updateTradeinPriceDisplay();
    } else {
        // If tradeinSelect is not available, just update the final price with 0 trade-in
        updateFinalPrice(0);
    }
}

function updateVehicleStats(stats) {
    $('#stat-value-0').text(stats.engine + '%');
    updateStatBarsById('stat-bars-0', stats.engine);
    
    $('#stat-value-1').text(stats.transmission + '%');
    updateStatBarsById('stat-bars-1', stats.transmission);
    
    $('#stat-value-2').text(stats.suspension + '%');
    updateStatBarsById('stat-bars-2', stats.suspension);
    
    $('#stat-value-3').text(stats.brakes + '%');
    updateStatBarsById('stat-bars-3', stats.brakes);
    
    $('#stat-value-4').text(stats.armor + '%');
    updateStatBarsById('stat-bars-4', stats.armor);

    $('#stat-value-5').text(stats.topSpeed + ' km/h');
    updateStatBarsById('stat-bars-5', stats.topSpeed);

    $('#stat-value-6').text(stats.trunk + ' Kg');
    updateStatBarsById('stat-bars-6', stats.trunk);
}

function updateStatBarsById(barId, percentage) {
    const steps = $(`#${barId} .vehicle-step`);
    const activeSteps = Math.round((percentage / 100) * steps.length);
    
    steps.removeClass('active');
    for (let i = 0; i < activeSteps; i++) {
        $(steps[i]).addClass('active');
    }
}

function updateStatBars(statItem, percentage) {
    const steps = statItem.find('.vehicle-step');
    const activeSteps = Math.round((percentage / 100) * steps.length);
    
    steps.removeClass('active');
    for (let i = 0; i < activeSteps; i++) {
        $(steps[i]).addClass('active');
    }
}

function testDriveVehicle() {
    $('#test-drive-button').prop('disabled', true);
    $('#test-drive-button').css('opacity', 0.5);
    $('#test-drive-button').css('cursor', 'not-allowed');

    setTimeout(() => {
        $('#test-drive-button').prop('disabled', false);
        $('#test-drive-button').css('opacity', 1);
        $('#test-drive-button').css('cursor', 'pointer');
    }, 3000);
    retrieveNUI('testDriveVehicle', { vehicleId: vehicleSelected.vehicle_id, vehicleName: vehicleSelected.vehicle_name, standId: standInfo.id });
    isTestDriving = true;

}

function buyVehicleClient() {
    var vehicleName = vehicleSelected.vehicle_name;
    var vehiclePrice = vehicleSelected.max_price;

    selectedCategory = null;
    selectedVehicleIndex = 0;

    if (vehicleSelected.stock) {

        let stockData = vehicleSelected.stock;
        if (typeof stockData === 'string') {try {stockData = JSON.parse(stockData)} catch (e) {stockData = {}}}
        

        const currentShopStock = stockData[standInfo.id];

        if (currentShopStock && currentShopStock.price) {
            var baseVehiclePrice = currentShopStock.price;
            var discount = currentShopStock.discount;
            vehiclePrice = baseVehiclePrice * (1 - discount / 100);
        }

        if (currentShopStock && currentShopStock.amount > 0) {

            $('#vehicle_buy_name').val(vehicleName);
            if (vehicleSelected.discount > 0) {
                $('#vehicle_buy_price').val(setLocaleString(Math.floor(vehiclePrice * (1 - vehicleSelected.discount / 100))));
            } else {
                $('#vehicle_buy_price').val(vehiclePrice);
            }
            if (enableTradeIns) {
                $('#vehicle_base_price_price').html(setLocaleString(vehiclePrice));
                $('#vehicle_buy_price').html(setLocaleString(vehiclePrice));
            } else {
                $('#vehicle_buy_price').html(setLocaleString(vehiclePrice));
            }

            var buyModal = document.getElementById('buyVehicleCustomerModal');
            buyModal.style.display = 'flex';
            setTimeout(function () {
                buyModal.classList.add('show');
            }, 50);
        } else {
            vehicleSelected.price = vehiclePrice;
            $('#full_name').val(playerName);
            $('#phone_number').val(phone);
            $('#vehicle').val(vehicleName);
            $('#price').val(vehiclePrice);
            if (vehicleSelected.discount > 0) {
                $('#price').val(setLocaleString(Math.floor(vehiclePrice * (1 - vehicleSelected.discount / 100))));
            } else {
                $('#price').val(vehiclePrice);
            }
            var modal = document.getElementById('customerOrderModal');
            modal.style.display = 'flex';
            setTimeout(function () {
                modal.classList.add('show');
            }, 50);
        }
    } else {
        vehicleSelected.price = vehiclePrice;
        $('#full_name').val(playerName);
        $('#phone_number').val(phone);
        $('#vehicle').val(vehicleName);
        $('#price').val(vehiclePrice);
        if (vehicleSelected.discount > 0) {
            $('#price').val(setLocaleString(Math.floor(vehiclePrice * (1 - vehicleSelected.discount / 100))));
        } else {
            $('#price').val(vehiclePrice);
        }
        var modal = document.getElementById('customerOrderModal');
        modal.style.display = 'flex';
        setTimeout(function () {
            modal.classList.add('show');
        }, 50);
    }
}


function selectCategory(category) {

    if (!canClickOnCategory) return;

    let vehicles = standInfo.vehicles;
    let row = '';
    let filteredVehicles = [];

    selectedCategory = category;

    for (let i = 0; i < vehicles.length; i++) {
        if (vehicles[i].category === category) {
            filteredVehicles.push(vehicles[i]);
        }
    }

    window.baseVehicleData = filteredVehicles;
    window.currentVehicleData = filteredVehicles;
    window.originalVehicleData = filteredVehicles;

    for (let j = 0; j < filteredVehicles.length; j++) {
        const vehicle = filteredVehicles[j];

        if (vehicle.type != standInfo.type) {continue}

        let stockData = vehicle.stock;
        if (typeof stockData === 'string') {
            try {
                stockData = JSON.parse(stockData);
            } catch (e) {
                stockData = {};
            }
        }
        if (!stockData || typeof stockData !== 'object') {stockData = {}}
        const currentStandStock = stockData[standInfo.id] || {amount: 0, price: 0, listed: true};
        if (currentStandStock.amount > 0) {
            vehicle.status = "in-stock";
        } else {
            vehicle.status = "out-of-stock";
        }
        if (!currentStandStock.listed) {currentStandStock.listed = true}
        let displayPrice;
        if (isStandVip) {
            if (currentStandStock.price == 0 || !currentStandStock.price) {
                displayPrice = setLocaleStringVip(vehicle.max_price);
            } else {
                displayPrice = setLocaleStringVip(currentStandStock.price);
            }
        } else {
            if (currentStandStock.price == 0 || !currentStandStock.price) {
                displayPrice = setLocaleString(vehicle.max_price);
            } else {
                displayPrice = setLocaleString(currentStandStock.price);
            }
        }
        let imageUrl;
        if (useSameImageForAllVehicles) {
            imageUrl = `img/vehicles/default.png`;
        } else if (useLocalImages) {
            imageUrl = `img/vehicles/${vehicle.vehicle_id}.png`;
        } else {
            imageUrl = `https://raw.githubusercontent.com/SrPeterr/okokvehicle-images/refs/heads/main/vehicles-all/${vehicle.vehicle_id}.png`;
        }

        const imgElement = `<img src="${imageUrl}" class="vehicle-card-image-size" onerror="if (!this._attemptedLocal) {this._attemptedLocal = true; this.src='img/vehicles/${vehicle.vehicle_id}.png';} else {this.onerror=null;this.src='img/vehicles/default.png';}">`;
        
        // Get vehicle class from vehiclesWithClasses
        let vehicleClass = 'N/A';
        if (vehiclesWithClasses && vehiclesWithClasses[vehicle.vehicle_id]) {
            vehicleClass = vehiclesWithClasses[vehicle.vehicle_id].class || 'N/A';
        }

        row += `
            <div class="vehicle-card" onclick="selectVehicle(${j}, true)">
                <div class="top-card-info">
                    <div class="vehicle-status ${vehicle.status}">
                        ${vehicle.status == 'in-stock' ? locales.translations.onstock : locales.translations.outofstock}
                    </div>
                    <div class="vehicle-amount">
                        <div class="vehicle-amount-available">${currentStandStock.amount}</div>
                        <svg class="vehicle-amount-icon" xmlns="http://www.w3.org/2000/svg"  width="22"  height="22"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-car"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M7 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M5 17h-2v-6l2 -5h9l4 5h1a2 2 0 0 1 2 2v4h-2m-4 0h-6m-6 -6h15m-6 0v-5" /></svg>
                    </div>
                </div>
                <div class="vehicle-card-image">
                    ${imgElement}
                </div>
                <div class="vehicle-card-info-2">
                    <div class="vehicle-card-info">
                        <div class="vehicle-card-info-name">${vehicle.vehicle_name}</div>
                        <div class="vehicle-card-info-title">${currentStandStock.discount > 0 ? `<span style="text-decoration: line-through;">${displayPrice}</span> <span class="vehicle-card-info-discount">${setLocaleString(Math.floor(currentStandStock.price * (1 - currentStandStock.discount / 100)))}</span>` : displayPrice}</div>
                    </div>
                    ${vehicleClass !== 'N/A' 
  ? `<div class="vehicle-card-class" style="font-size:${vehicleClass === 'S+' ? '0.875rem' : '1rem'}">${vehicleClass}</div>` 
  : ''}
                </div>
            </div>
        `;
    }

    window.currentVehicleData = filteredVehicles;
    window.originalVehicleData = filteredVehicles;
    $('#vehicle-list-primary').hide().html(row);
    setTimeout(() => {
        $('#vehicle-list-primary').removeClass('fadeInUp').show().addClass('fadeInUp');
        $('#vehicle-stats-container, #vehicle-info-container, #vehicles-buttons-left').css({
            'transform': 'translateY(20px)',
            'opacity': '0',
            'display': 'flex'
        });
        setTimeout(() => {
            $('#vehicle-stats-container, #vehicle-info-container, #vehicles-buttons-left').css({
                'transform': 'translateY(0)',
                'opacity': '1',
                'animation': 'fadeInUp 0.6s ease-out forwards'
            });
        }, 100);
    }, 10);


    if (filteredVehicles.length > 0) {
        if (selectedVehicleIndex) {
            selectVehicle(selectedVehicleIndex, true);
            selectedVehicleIndex = 0;
        } else {
            selectVehicle(0, true);
        }
    }

    backFromVehicles = true;

    if (filteredVehicles.length > 8 ) { $('#vehicle-buttons-right').fadeIn() } else { $('#vehicle-buttons-right').fadeOut() }

    $('#vehicle-desc-category').text(categoriesLabels[category]);
}

function setupVehicleListingPrimary(selectedCategory) {
    selectedWindow = "vehicleListing";
    $('#vehicle-listing-primary').html('');
    $('#vehicle-listing-primary').html(`
    <div class="vehicle-listing-primary-container">
        <div class="top-container">
            <div class="vehicle-info">
                <div id="vehicle-info-container" class="d-flex-column">
                    <div>
                        <div id="vehicle-desc-category" class="vehicle-description"></div>
                        <div id="vehicle-name" class="vehicle-name"></div>
                    </div>
                    <div class="vehicle-color-picker-container">
                        <div class="vehicle-color-picker-title"><i class="fa-solid fa-palette"></i>${locales.translations.selectthecolor}</div>
                        <div class="vehicle-color-picker">
                            <div class="color-picker">
                                <canvas id="color-area" class="color-picker-canvas"></canvas>
                                <div class="hue-slider-container">
                                    <input type="range" id="hue-slider" min="0" max="360" value="0">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="vehicle-price">
                        <div class="vehicle-price-title">${locales.translations.price}</div>
                        <div id="vehicle-price-value" class="vehicle-price-value"></div>
                    </div>
                    <div class="vehicle-options gap-1">
                        <button class="vehicle-option-button" onclick="buyVehicleClient()">
                            <div class="vehicle-option-button-content">
                                <svg id="purchase-vehicle-button-icon" class="vehicle-option-button-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="1.5"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-shopping-cart"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M6 19m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 19m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 17h-11v-14h-2" /><path d="M6 5l14 1l-1 7h-13" /></svg>
                                <div id="purchase-vehicle-button-text" class="vehicle-option-button-text">${locales.translations.purchasevehicle}</div>
                            </div>
                        </button>
                        <button id="test-drive-button" class="vehicle-option-button btn-dark" onclick="testDriveVehicle()">
                            <div class="vehicle-option-button-content">
                                <svg class="vehicle-option-button-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="1.5"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-steering-wheel"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 12m-9 0a9 9 0 1 0 18 0a9 9 0 1 0 -18 0" /><path d="M12 12m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M12 14l0 7" /><path d="M10 12l-6.75 -2" /><path d="M14 12l6.75 -2" /></svg>
                                <div class="vehicle-option-button-text">${locales.translations.testdrive}</div>
                            </div>
                            <div id="vehicle-test-drive-price" class="vehicle-test-drive-price"></div>
                        </button>
                    </div>
                </div>
            </div>
            <div class="vehicle-stats">
                <div class="d-flex-row">
                    <button id="my-orders-button" class="exit-dealership-button mr-1">${locales.translations.myorders}<svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-car"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M7 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M5 17h-2v-6l2 -5h9l4 5h1a2 2 0 0 1 2 2v4h-2m-4 0h-6m-6 -6h15m-6 0v-5" /></svg></button>
                    <button id="exit-dealership-button" class="exit-dealership-button">${locales.translations.exit}<svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-arrow-narrow-right"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M5 12l14 0" /><path d="M15 16l4 -4" /><path d="M15 8l4 4" /></svg></button>
                </div>
                <div class="vehicle-spacer">
                    <div id="vehicle-stats-container" class="d-flex-column">
                        <div class="vehicle-name-stats">${locales.translations.caracteristics}</div>
                        <div class="vehicle-stats-container">

                            <div class="vehicle-stats-item">
                                <div class="vehicle-stats-item-content">
                                    <div class="vehicle-stats-item-title" id="stat-title-0">
                                        <svg class="vehicle-stats-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-engine"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M3 10v6" /><path d="M12 5v3" /><path d="M10 5h4" /><path d="M5 13h-2" /><path d="M6 10h2l2 -2h3.382a1 1 0 0 1 .894 .553l1.448 2.894a1 1 0 0 0 .894 .553h1.382v-2h2a1 1 0 0 1 1 1v6a1 1 0 0 1 -1 1h-2v-2h-3v2a1 1 0 0 1 -1 1h-3.465a1 1 0 0 1 -.832 -.445l-1.703 -2.555h-2v-6z" /></svg>
                                        ${locales.translations.engine}
                                    </div>
                                    <div class="vehicle-stats-item-value" id="stat-value-0">0%</div>
                                </div>
                                <div class="vehicle-steps-bar" id="stat-bars-0">
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                </div>
                            </div>
                            <div class="vehicle-stats-item">
                                <div class="vehicle-stats-item-content">
                                    <div class="vehicle-stats-item-title" id="stat-title-1">
                                        <svg class="vehicle-stats-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-gear"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M7.5 7.5m0 0a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0" /><path d="M7.5 7.5v-3a2.5 2.5 0 0 1 5 0v3" /><path d="M7.5 7.5v3a2.5 2.5 0 0 0 5 0v-3" /><path d="M16.5 7.5m0 0a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0" /><path d="M16.5 7.5v-3a2.5 2.5 0 0 1 5 0v3" /><path d="M16.5 7.5v3a2.5 2.5 0 0 0 5 0v-3" /></svg>
                                        ${locales.translations.transmission}
                                    </div>
                                    <div class="vehicle-stats-item-value" id="stat-value-1">0%</div>
                                </div>
                                <div class="vehicle-steps-bar" id="stat-bars-1">
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                </div>
                            </div>
                            <div class="vehicle-stats-item">
                                <div class="vehicle-stats-item-content">
                                    <div class="vehicle-stats-item-title" id="stat-title-2">
                                        <svg class="vehicle-stats-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-car"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M7 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M5 17h-2v-6l2 -5h9l4 5h1a2 2 0 0 1 2 2v4h-2m-4 0h-6m-6 -6h15m-6 0v-5" /></svg>
                                        ${locales.translations.suspension}
                                    </div>
                                    <div class="vehicle-stats-item-value" id="stat-value-2">0%</div>
                                </div>
                                <div class="vehicle-steps-bar" id="stat-bars-2">
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                </div>
                            </div>
                            <div class="vehicle-stats-item">
                                <div class="vehicle-stats-item-content">
                                    <div class="vehicle-stats-item-title" id="stat-title-3">
                                        <svg class="vehicle-stats-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-hand-stop"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M8 13v.01" /><path d="M16 13v.01" /><path d="M12 5v14" /><path d="M12 5a5 5 0 0 0 -5 5v4a5 5 0 0 0 10 0v-4a5 5 0 0 0 -5 -5z" /></svg>
                                        ${locales.translations.brakes}
                                    </div>
                                    <div class="vehicle-stats-item-value" id="stat-value-3">0%</div>
                                </div>
                                <div class="vehicle-steps-bar" id="stat-bars-3">
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                </div>
                            </div>
                            <div class="vehicle-stats-item">
                                <div class="vehicle-stats-item-content">
                                    <div class="vehicle-stats-item-title" id="stat-title-4">
                                        <svg class="vehicle-stats-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-shield"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 3a12 12 0 0 0 8.5 3a12 12 0 0 1 -8.5 15a12 12 0 0 1 -8.5 -15a12 12 0 0 0 8.5 -3" /></svg>
                                        ${locales.translations.armor}
                                    </div>
                                    <div class="vehicle-stats-item-value" id="stat-value-4">0%</div>
                                </div>
                                <div class="vehicle-steps-bar" id="stat-bars-4">
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                    <div class="vehicle-step"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="vehicles-container">
            <div class="vehicles-buttons">
                <div class="vehicles-buttons-left">
                    <div id="vehicles-buttons-left">
                        <button id="return-category-button" class="return-category-button">
                            <svg class="vehicle-category-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-arrow-narrow-left"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M5 12l14 0" /><path d="M5 12l4 4" /><path d="M5 12l4 -4" /></svg>
                            <div class="return-category-button-text">${locales.translations.returncategory}</div>
                        </button>
                        <div class="search-input-wrapper">
                            <svg class="search-input-icon" xmlns="http://www.w3.org/2000/svg"  width="18"  height="18"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-search"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M10 10m-7 0a7 7 0 1 0 14 0a7 7 0 1 0 -14 0" /><path d="M21 21l-6 -6" /></svg><input type="text" class="search-input" placeholder="Search">
                        </div>
                    </div>
                </div>
                <div class="vehicles-buttons-right">
                    <div id="vehicle-buttons-right" class="d-flex-row h-2025">
                        <button id="go-left-button" class="go-left-button">
                            <svg class="vehicle-stats-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-arrow-narrow-left"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M5 12l14 0" /><path d="M5 12l4 4" /><path d="M5 12l4 -4" /></svg>
                        </button>
                        <button id="go-right-button" class="go-right-button">
                            <svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-arrow-narrow-right"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M5 12l14 0" /><path d="M15 16l4 -4" /><path d="M15 8l4 4" /></svg>
                        </button>
                    </div>
                </div>
            </div>
            <div id="vehicle-list-primary" class="vehicles-list"></div>
        </div>
    </div>
        `);

    $('#vehicle-test-drive-price').text(standInfo.testDriveSettings.paid ? setLocaleString(standInfo.testDriveSettings.price) : locales.translations.free);

    if (standInfo.hasOwner && standInfo.owner != null) {
        var hasCustomOrder = false;
        var availableOrders = 0;

        if (!standInfo.orders) {standInfo.orders = []}

        for (let i = 0; i < standInfo.orders.length; i++) {
            if (standInfo.orders[i].customer_id == playerIdentifier) {
                hasCustomOrder = true;
                if (standInfo.orders[i].status == 'ready') {
                    availableOrders++;
                }
            }
        }

        if (hasCustomOrder) {
            $('#my-orders-button').addClass('order-available-button');
        } else {
            $('#my-orders-button').css('opacity', '0.5');
            $('#my-orders-button').css('cursor', 'not-allowed');
            $('#my-orders-button').prop('disabled', true);
        }

        if (availableOrders > 0) {
            const badge = $('<div class="order-available-button-badge">' + availableOrders + '</div>');
            $('#my-orders-button').append(badge);
        }
    } else {
        $('#my-orders-button').hide();
    }

    $("#return-category-button").click(function() {
        canClickOnCategory = false;
        setupVehicleCategories();
    });

    $('.search-input').on('input', function() {
        const searchTerm = $(this).val().toLowerCase();
        filterVehicles(searchTerm);
    });

    $('#go-left-button').on('click', function() {
        const vehicleList = document.getElementById('vehicle-list-primary');
        if (vehicleList.scrollLeft > 10) {
            const newScrollLeft = Math.max(0, vehicleList.scrollLeft - 305);
            vehicleList.scrollTo({
                left: newScrollLeft,
                behavior: 'smooth'
            });
        }
    });

    $('#go-right-button').on('click', function() {
        const vehicleList = document.getElementById('vehicle-list-primary');
        const maxScroll = vehicleList.scrollWidth - vehicleList.clientWidth;
        if (vehicleList.scrollLeft < (maxScroll - 50)) {
            const newScrollLeft = Math.min(maxScroll, vehicleList.scrollLeft + 305);
            vehicleList.scrollTo({
                left: newScrollLeft,
                behavior: 'smooth'
            });
        }
    });

    $(document).on('keydown', function(e) {
        if (selectedWindow === "vehicleListing") {
            const vehicleList = document.getElementById('vehicle-list-primary');
            const maxScroll = vehicleList.scrollWidth - vehicleList.clientWidth;
            
            if (e.key === 'ArrowLeft') {
                e.preventDefault();
                if (vehicleList.scrollLeft > 10) {
                    const newScrollLeft = Math.max(0, vehicleList.scrollLeft - 305);
                    vehicleList.scrollTo({
                        left: newScrollLeft,
                        behavior: 'smooth'
                    });
                }
            } else if (e.key === 'ArrowRight') {
                e.preventDefault();
                if (vehicleList.scrollLeft < (maxScroll - 50)) {
                    const newScrollLeft = Math.min(maxScroll, vehicleList.scrollLeft + 305);
                    vehicleList.scrollTo({
                        left: newScrollLeft,
                        behavior: 'smooth'
                    });
                }
            }
        }
    });

    setupVehicleCategories(selectedCategory);

    $('.overlay-primary').css('display', 'flex').hide().fadeIn(500);
    $('#vehicle-listing-primary').css('display', 'flex').hide().fadeIn(500);

    $('#exit-dealership-button').on('click', function() {
        closeMenu();
    });

    const colorArea = document.getElementById('color-area');
    const hueSlider = document.getElementById('hue-slider');
    const ctx = colorArea.getContext('2d');
    let hue = 0;
    let selected = { x: 0.5, y: 0.0 };

    function drawColorArea(hue) {
        const width = colorArea.width;
        const height = colorArea.height;
        ctx.clearRect(0, 0, width, height);
        ctx.fillStyle = `hsl(${hue}, 100%, 50%)`;
        ctx.fillRect(0, 0, width, height);
        const whiteGrad = ctx.createLinearGradient(0, 0, width, 0);
        whiteGrad.addColorStop(0, 'white');
        whiteGrad.addColorStop(1, 'transparent');
        ctx.fillStyle = whiteGrad;
        ctx.fillRect(0, 0, width, height);
        const blackGrad = ctx.createLinearGradient(0, 0, 0, height);
        blackGrad.addColorStop(0, 'transparent');
        blackGrad.addColorStop(1, 'black');
        ctx.fillStyle = blackGrad;
        ctx.fillRect(0, 0, width, height);
        const px = selected.x * width;
        const py = selected.y * height;
        drawSelectionIndicator(px, py);
    }

    function drawSelectionIndicator(x, y) {
        ctx.save();
        ctx.beginPath();
        ctx.arc(x, y, 7, 0, 2 * Math.PI);
        ctx.lineWidth = 2;
        ctx.strokeStyle = '#fff';
        ctx.shadowColor = '#000';
        ctx.shadowBlur = 2;
        ctx.stroke();
        ctx.beginPath();
        ctx.arc(x, y, 3, 0, 2 * Math.PI);
        ctx.fillStyle = getColorAtPosition(x, y);
        ctx.shadowBlur = 0;
        ctx.fill();
        ctx.restore();
    }

    function getColorAtPosition(x, y) {
        const width = colorArea.width;
        const height = colorArea.height;
        const s = x / width;
        const v = 1 - (y / height);
        const rgb = hsvToRgb(hue / 360, s, v);
        return `rgb(${rgb[0]}, ${rgb[1]}, ${rgb[2]})`;
    }

    function hsvToRgb(h, s, v) {
        let r, g, b;
        let i = Math.floor(h * 6);
        let f = h * 6 - i;
        let p = v * (1 - s);
        let q = v * (1 - f * s);
        let t = v * (1 - (1 - f) * s);
        switch (i % 6) {
            case 0: r = v, g = t, b = p; break;
            case 1: r = q, g = v, b = p; break;
            case 2: r = p, g = v, b = t; break;
            case 3: r = p, g = q, b = v; break;
            case 4: r = t, g = p, b = v; break;
            case 5: r = v, g = p, b = q; break;
        }
        return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
    }

    function resizeCanvas() {
        const rect = colorArea.getBoundingClientRect();
        colorArea.width = rect.width;
        colorArea.height = rect.height;
        drawColorArea(hue);
    }

    window.addEventListener('resize', resizeCanvas);
    resizeCanvas();
    
    function initializeColorPicker() {
        hue = 0;
        hueSlider.value = 0;
        
        selected = { x: 0.03, y: 0.05 };
        
        drawColorArea(hue);
        
        retrieveNUI('changeVehicleColor', {
            r: 255,
            g: 255,
            b: 255
        });
    }
    
    setTimeout(initializeColorPicker, 100);

    hueSlider.addEventListener('input', function() {
        hue = parseInt(this.value);
        drawColorArea(hue);
        
        const color = getColorAtPosition(selected.x * colorArea.width, selected.y * colorArea.height);
        const rgb = color.match(/\d+/g);
        if (rgb && rgb.length >= 3) {
            retrieveNUI('changeVehicleColor', {
                r: parseInt(rgb[0]),
                g: parseInt(rgb[1]),
                b: parseInt(rgb[2])
            });
        }
    });

    colorArea.addEventListener('mousedown', function(e) {
        function pickColor(ev) {
            const rect = colorArea.getBoundingClientRect();
            const x = Math.max(0, Math.min(ev.clientX - rect.left, colorArea.width));
            const y = Math.max(0, Math.min(ev.clientY - rect.top, colorArea.height));
            selected.x = x / colorArea.width;
            selected.y = y / colorArea.height;
            drawColorArea(hue);
            
            const color = getColorAtPosition(x, y);
            const rgb = color.match(/\d+/g);
            if (rgb && rgb.length >= 3) {
                retrieveNUI('changeVehicleColor', {
                    r: parseInt(rgb[0]),
                    g: parseInt(rgb[1]),
                    b: parseInt(rgb[2])
                });
            }
        }
        pickColor(e);
        function onMove(ev) { pickColor(ev); }
        function onUp() {
            window.removeEventListener('mousemove', onMove);
            window.removeEventListener('mouseup', onUp);
        }
            window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
    });

    if (!selectedCategory) {
        $('#vehicle-stats-container, #vehicle-info-container, #vehicles-buttons-left').css('display', 'none');
    }

    retrieveNUI('vehicleListingLoaded', {});
}

function setupVehicleCategories(selectedCategory) {
    let row = ``;

    setTimeout(() => {
        $('#vehicle-list-primary').removeClass('fadeInUp').show().addClass('fadeInUp');
        if (backFromVehicles) {
            $('#vehicle-stats-container, #vehicle-info-container, #vehicles-buttons-left').css({
                'transform': 'translateY(0)',
                'animation': 'fadeOutDown 0.6s ease-out forwards'
            });
        }
    }, 10);

    setTimeout(() => {
        if (backFromVehicles && !selectedCategory) {
            $('#vehicle-stats-container, #vehicle-info-container, #vehicles-buttons-left').hide();
            backFromVehicles = false;
            canClickOnCategory = true;
        }
    }, 610)

    const categories = [...new Set(
        standInfo.vehicles.map(v => v.category).filter(category => category && category.trim() !== "")
    )];

    if (categories.length > 8 ) { $('#vehicle-buttons-right').fadeIn() } else { $('#vehicle-buttons-right').fadeOut() }

    categories.forEach(category => {
        row += `
            <div onclick="selectCategory('${category}')" class="vehicle-card">
                <div class="top-card-info"></div>
                <div class="vehicle-card-image">
                    <img src="img/vehicles/default.png" class="vehicle-card-image">
                </div>
                <div class="vehicle-card-info">
                    <div class="vehicle-card-info-name">${categoriesLabels[category]}</div>
                </div>
            </div>
        `;
    });
    $('#vehicle-list-primary').hide().html(row);

}

function setupVehicleListingSecondary() {
    selectedWindow = "vehicleListing";

    $('#vehicle-listing-secondary').html('');
    $('#vehicle-listing-secondary').html(`
    <div class="top-container second-vehicle-container">
        <div class="vehicles-container-second custom-width">
            <div class="vehicle-second-title">${locales.translations.car.toUpperCase()} <span>${locales.translations.dealership.toUpperCase()}</span></div>
            <div class="vehicle-second-description">
                <div class="vehicle-second-description-title">${locales.translations.car} ${locales.translations.catalog}</div>
                <div class="vehicle-second-car-amount">${standInfo.vehicles.length} ${locales.translations.cars}</div>
            </div>
            <div class="search-input-wrapper-second">
                <svg class="search-input-icon-second" xmlns="http://www.w3.org/2000/svg"  width="18"  height="18"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-search"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M10 10m-7 0a7 7 0 1 0 14 0a7 7 0 1 0 -14 0" /><path d="M21 21l-6 -6" /></svg><input type="text" class="search-input-second" placeholder="${locales.translations.search}">
            </div>
            <div id="vehicles-list-second" class="vehicles-list-second"></div>
        </div>
        <div class="vehicle-info" style="display: flex; flex-direction: column; justify-content: flex-end; align-items: center;">
            <div id="vehicle-name" class="vehicle-name" style="text-transform: none; font-size: 2.225rem; font-weight: 500; margin-bottom: 1.5rem;">Name of Vehicle</div>
            <div style="position: relative; display: flex; justify-content: space-between; align-items: center; width: 100%;">
                <div class="vehicle-price2" style="display: flex; align-items: center; flex-direction: column; justify-content: center; width: 33%; text-align: center;">
                    <div class="vehicle-price-title" style="font-weight: 300; font-size: 0.75rem;">Top Speed</div>
                    <div id="stat-value-5" class="vehicle-price-value" style="font-size: 1rem;">320km/h</div>
                </div>

                <div class="vehicle-price2" style="position: absolute; left: 50%; transform: translateX(-50%); display: flex; align-items: center; flex-direction: column; text-align: center; z-index: 10;">
                    <div class="vehicle-price-title" style="font-weight: 300;">${locales.translations.price}</div>
                    <div id="vehicle-price-value" class="vehicle-price-value"></div>
                </div>

                <div class="vehicle-price2" style="display: flex; align-items: center; flex-direction: column; justify-content: center; width: 33%; text-align: center;">
                    <div class="vehicle-price-title" style="font-weight: 300; font-size: 0.75rem;">Trunk Size</div>
                    <div id="stat-value-6" class="vehicle-price-value" style="font-size: 1rem;">180kg</div>
                </div>
            </div>
            
            <div class="vehicle-options" style="display: flex; flex-direction: row;">
                <button class="vehicle-option-button" style="width: 15rem;" onclick="buyVehicleClient()">
                    <div class="vehicle-option-button-content">
                        <svg id="purchase-vehicle-button-icon" class="vehicle-option-button-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="1.5"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-shopping-cart"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M6 19m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 19m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 17h-11v-14h-2" /><path d="M6 5l14 1l-1 7h-13" /></svg>
                        <div id="purchase-vehicle-button-text" class="vehicle-option-button-text">${locales.translations.purchasevehicle}</div>
                    </div>
                </button>
                <button id="test-drive-button" class="vehicle-option-button btn-dark" style="width: 15rem; margin-left: 1rem;" onclick="testDriveVehicle()">
                    <div class="vehicle-option-button-content">
                        <svg class="vehicle-option-button-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="1.5"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-steering-wheel"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 12m-9 0a9 9 0 1 0 18 0a9 9 0 1 0 -18 0" /><path d="M12 12m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M12 14l0 7" /><path d="M10 12l-6.75 -2" /><path d="M14 12l6.75 -2" /></svg>
                        <div class="vehicle-option-button-text">${locales.translations.testdrive}</div>
                    </div>
                    <div id="vehicle-test-drive-price" class="vehicle-test-drive-price"></div>
                </button>
            </div>
        </div>
        <div class="vehicle-stats" style="width: 22rem;">
            <div class="d-flex-row">
                <button id="my-orders-button" class="exit-dealership-button mr-1">${locales.translations.myorders}<svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-car"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M7 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M5 17h-2v-6l2 -5h9l4 5h1a2 2 0 0 1 2 2v4h-2m-4 0h-6m-6 -6h15m-6 0v-5" /></svg></button>
                <button id="exit-dealership-button" class="exit-dealership-button">${locales.translations.exit}<svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-arrow-narrow-right"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M5 12l14 0" /><path d="M15 16l4 -4" /><path d="M15 8l4 4" /></svg></button>
            </div>
            <div class="vehicle-spacer">
                <div class="vehicle-name-stats">${locales.translations.caracteristics}</div>
                <div class="vehicle-stats-container">
                    <div class="vehicle-stats-item">
                        <div class="vehicle-stats-item-content">
                            <div class="vehicle-stats-item-title" id="stat-title-0">
                                <svg class="vehicle-stats-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-engine"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M3 10v6" /><path d="M12 5v3" /><path d="M10 5h4" /><path d="M5 13h-2" /><path d="M6 10h2l2 -2h3.382a1 1 0 0 1 .894 .553l1.448 2.894a1 1 0 0 0 .894 .553h1.382v-2h2a1 1 0 0 1 1 1v6a1 1 0 0 1 -1 1h-2v-2h-3v2a1 1 0 0 1 -1 1h-3.465a1 1 0 0 1 -.832 -.445l-1.703 -2.555h-2v-6z" /></svg>
                                ${locales.translations.engine}
                            </div>
                            <div class="vehicle-stats-item-value" id="stat-value-0">0%</div>
                        </div>
                        <div class="vehicle-steps-bar" id="stat-bars-0">
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                        </div>
                    </div>
                    <div class="vehicle-stats-item">
                        <div class="vehicle-stats-item-content">
                            <div class="vehicle-stats-item-title" id="stat-title-1">
                                <svg class="vehicle-stats-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-gear"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M7.5 7.5m0 0a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0" /><path d="M7.5 7.5v-3a2.5 2.5 0 0 1 5 0v3" /><path d="M7.5 7.5v3a2.5 2.5 0 0 0 5 0v-3" /><path d="M16.5 7.5m0 0a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0" /><path d="M16.5 7.5v-3a2.5 2.5 0 0 1 5 0v3" /><path d="M16.5 7.5v3a2.5 2.5 0 0 0 5 0v-3" /></svg>
                                ${locales.translations.transmission}
                            </div>
                            <div class="vehicle-stats-item-value" id="stat-value-1">0%</div>
                        </div>
                        <div class="vehicle-steps-bar" id="stat-bars-1">
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                        </div>
                    </div>
                    <div class="vehicle-stats-item">
                        <div class="vehicle-stats-item-content">
                            <div class="vehicle-stats-item-title" id="stat-title-2">
                                <svg class="vehicle-stats-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-car"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M7 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M5 17h-2v-6l2 -5h9l4 5h1a2 2 0 0 1 2 2v4h-2m-4 0h-6m-6 -6h15m-6 0v-5" /></svg>
                                ${locales.translations.suspension}
                            </div>
                            <div class="vehicle-stats-item-value" id="stat-value-2">0%</div>
                        </div>
                        <div class="vehicle-steps-bar" id="stat-bars-2">
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                        </div>
                    </div>
                    <div class="vehicle-stats-item">
                        <div class="vehicle-stats-item-content">
                            <div class="vehicle-stats-item-title" id="stat-title-3">
                                <svg class="vehicle-stats-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-hand-stop"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M8 13v.01" /><path d="M16 13v.01" /><path d="M12 5v14" /><path d="M12 5a5 5 0 0 0 -5 5v4a5 5 0 0 0 10 0v-4a5 5 0 0 0 -5 -5z" /></svg>
                                ${locales.translations.brakes}
                            </div>
                            <div class="vehicle-stats-item-value" id="stat-value-3">0%</div>
                        </div>
                        <div class="vehicle-steps-bar" id="stat-bars-3">
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                        </div>
                    </div>
                    <div class="vehicle-stats-item">
                        <div class="vehicle-stats-item-content">
                            <div class="vehicle-stats-item-title" id="stat-title-4">
                                <svg class="vehicle-stats-icon" xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-shield"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 3a12 12 0 0 0 8.5 3a12 12 0 0 1 -8.5 15a12 12 0 0 1 -8.5 -15a12 12 0 0 0 8.5 -3" /></svg>
                                ${locales.translations.armor}
                            </div>
                            <div class="vehicle-stats-item-value" id="stat-value-4">0%</div>
                        </div>
                        <div class="vehicle-steps-bar" id="stat-bars-4">
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                            <div class="vehicle-step"></div>
                        </div>
                    </div>
                </div>
                <div class="vehicle-color-picker-title" style="display: flex; justify-content: flex-start; width: 100%;"><i class="fa-solid fa-palette"></i> ${locales.translations.selectthecolor}</div>
                <div class="vehicle-color-picker">
                    <div class="color-picker">
                        <canvas id="color-area" class="color-picker-canvas-second"></canvas>
                        <div class="hue-slider-container">
                            <input type="range" id="hue-slider" min="0" max="360" value="0">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div> `);

    $('#vehicle-test-drive-price').text(standInfo.testDriveSettings.paid ? setLocaleString(standInfo.testDriveSettings.price) : locales.translations.free);

    let row = "";

    for (let i = 0; i < standInfo.vehicles.length; i++) {
        
        const vehicle = standInfo.vehicles[i];

        if (vehicle.type != standInfo.type) {continue}

        let stockData = vehicle.stock;
        if (typeof stockData === 'string') {
            try {
                stockData = JSON.parse(stockData);
            } catch (e) {
                stockData = {};
            }
        }
        
        if (!stockData || typeof stockData !== 'object') {stockData = {}}

        const currentStandStock = stockData[standInfo.id] || {amount: 0, price: 0, listed: false};


        if (currentStandStock.amount > 0) {
            vehicle.status = "in-stock";
            $('#purchase-vehicle-button-icon').html(`<svg xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="1.5"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-shopping-cart"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M6 19m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 19m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 17h-11v-14h-2" /><path d="M6 5l14 1l-1 7h-13" /></svg>`);
            $('#purchase-vehicle-button-text').html(locales.translations.purchasevehicle);
        } else {
            $('#purchase-vehicle-button-icon').html(`<svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-loader"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 6l0 -3" /><path d="M16.25 7.75l2.15 -2.15" /><path d="M18 12l3 0" /><path d="M16.25 16.25l2.15 2.15" /><path d="M12 18l0 3" /><path d="M7.75 16.25l-2.15 2.15" /><path d="M6 12l-3 0" /><path d="M7.75 7.75l-2.15 -2.15" /></svg>`);
            $('#purchase-vehicle-button-text').html(locales.translations.ordervehicle); 
            vehicle.status = "out-of-stock"; 
        }

        if (!currentStandStock.listed) {currentStandStock.listed = true}

        let displayPrice;
        if (standInfo.isVip) {
            if (currentStandStock.price == 0 || !currentStandStock.price) {
                displayPrice = setLocaleStringVip(vehicle.max_price);
            } else {
                displayPrice = setLocaleStringVip(currentStandStock.price);
            }
        } else {
            if (currentStandStock.price == 0 || !currentStandStock.price) {
                displayPrice = setLocaleString(vehicle.max_price);
            } else {
                displayPrice = setLocaleString(currentStandStock.price);
            }
        }

        let imageUrl;
        if (useSameImageForAllVehicles) {
            imageUrl = `img/vehicles/default.png`;
        } else if (useLocalImages) {
            imageUrl = `img/vehicles/${vehicle.vehicle_id}.png`;
        } else {
            imageUrl = `https://raw.githubusercontent.com/SrPeterr/okokvehicle-images/refs/heads/main/vehicles-all/${vehicle.vehicle_id}.png`;
        }

        const imgElement = `<img src="${imageUrl}" class="vehicle-card-image-size" onerror="if (!this._attemptedLocal) {this._attemptedLocal = true; this.src='img/vehicles/${vehicle.vehicle_id}.png';} else {this.onerror=null;this.src='img/vehicles/default.png';}">`;

        // Get vehicle class from vehiclesWithClasses
        let vehicleClass = 'N/A';
        
        if (vehiclesWithClasses && vehiclesWithClasses[vehicle.vehicle_id]) {
            vehicleClass = vehiclesWithClasses[vehicle.vehicle_id].class || 'N/A';
        }

        row += `
            <div class="vehicle-card-second" onclick="selectVehicle(${i}, true)" data-original-index="${i}">
                <div class="top-card-info">
                    <div class="vehicle-status ${vehicle.status}">
                        ${vehicle.status == 'in-stock' ? locales.translations.onstock : locales.translations.outofstock}
                    </div>
                    <div class="vehicle-amount">
                        <div class="vehicle-amount-available">${currentStandStock.amount}</div>
                        <svg class="vehicle-amount-icon" xmlns="http://www.w3.org/2000/svg"  width="22"  height="22"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-car"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M7 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M17 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M5 17h-2v-6l2 -5h9l4 5h1a2 2 0 0 1 2 2v4h-2m-4 0h-6m-6 -6h15m-6 0v-5" /></svg>
                    </div>
                </div>
                <div class="vehicle-card-image">
                    ${imgElement}
                </div>
                <div class="vehicle-card-info-2">
                    <div class="vehicle-card-info">
                        <div class="vehicle-card-info-name">${vehicle.vehicle_name}</div>
                        ${currentStandStock.discount > 0 ? 
                            `<div class="vehicle-card-info-title" style="display: flex; flex-direction: row; align-items: center;">
                                <span style="text-decoration: line-through;">${displayPrice}</span> 
                                <span class="vehicle-card-info-discount">${setLocaleString(Math.floor(currentStandStock.price * (1 - currentStandStock.discount / 100)))}</span>
                            </div>` : 
                            `<div class="vehicle-card-info-title">${displayPrice}</div>`
                        }
                    </div>
                    ${vehicleClass !== 'N/A' 
  ? `<div class="vehicle-card-class" style="font-size:${vehicleClass === 'S+' ? '0.875rem' : '1rem'}">${vehicleClass}</div>` 
  : ''}
                </div>
            </div> 
        `;

    }

    if (standInfo.hasOwner && standInfo.owner != null) {
        let hasCustomOrder = false;
        let availableOrders = 0;

        const orders = Array.isArray(standInfo?.orders) ? standInfo.orders : [];

        for (const order of orders) {
            if (!order) continue;  // skip null/undefined entries

            if (order.customer_id === playerIdentifier) {
                hasCustomOrder = true;
            }
            if (order.status === 'ready') {
                availableOrders++;
            }
        }

        if (hasCustomOrder) {
            $('#my-orders-button').addClass('order-available-button');
        } else {
            $('#my-orders-button').css('opacity', '0.5');
            $('#my-orders-button').css('cursor', 'not-allowed');
            $('#my-orders-button').prop('disabled', true);
        }

        if (availableOrders > 0) {
            const badge = $('<div class="order-available-button-badge">' + availableOrders + '</div>');
            $('#my-orders-button').append(badge);
        }

    } else {
        $('#my-orders-button').hide();
    }

    setTimeout(() => {
        $('#vehicles-list-second').html(row);
        
        if (window.lastSelectedIndex !== undefined) {
            
            const selectedVehicleFromOriginal = window.originalVehicleData[window.lastSelectedIndex];
            const selectedIndexInCurrent = window.currentVehicleData.findIndex(v => v.vehicle_id === selectedVehicleFromOriginal.vehicle_id);
            
            if (selectedIndexInCurrent !== -1) {
                selectVehicle(selectedIndexInCurrent, true);
            } else {
                $('.vehicle-card-second').removeClass('vehicle-card-selected');
                $('#vehicle-price-value').text('Select a vehicle');
                $('#vehicle-name').text('No vehicle selected');
                vehicleSelected = null;
            }
        } else {
            selectVehicle(0, true);
        }
    }, 10);

    window.baseVehicleData = standInfo.vehicles;
    window.originalVehicleData = standInfo.vehicles;
    window.currentVehicleData = standInfo.vehicles;
    window.standInfo = standInfo;
    
    if (window.lastSelectedIndex === undefined) {window.lastSelectedIndex = 0}

    $('.search-input-second').on('input', function() {
        const searchTerm = $(this).val().toLowerCase();
        filterVehicles(searchTerm);
    });

    $('#exit-dealership-button').on('click', function() {
        closeMenu();
    });

    $('.overlay-secondary').css('display', 'flex').hide().fadeIn(500);
    $('#vehicle-listing-secondary').css('display', 'flex').hide().fadeIn(500);

    checkAllVehiclesListedStatus();

    const colorArea = document.getElementById('color-area');
    const hueSlider = document.getElementById('hue-slider');
    const ctx = colorArea.getContext('2d');
    let hue = 0;
    let selected = { x: 0.5, y: 0.0 };

    function drawColorArea(hue) {
        const width = colorArea.width;
        const height = colorArea.height;
        ctx.clearRect(0, 0, width, height);
        ctx.fillStyle = `hsl(${hue}, 100%, 50%)`;
        ctx.fillRect(0, 0, width, height);
        const whiteGrad = ctx.createLinearGradient(0, 0, width, 0);
        whiteGrad.addColorStop(0, 'white');
        whiteGrad.addColorStop(1, 'transparent');
        ctx.fillStyle = whiteGrad;
        ctx.fillRect(0, 0, width, height);
        const blackGrad = ctx.createLinearGradient(0, 0, 0, height);
        blackGrad.addColorStop(0, 'transparent');
        blackGrad.addColorStop(1, 'black');
        ctx.fillStyle = blackGrad;
        ctx.fillRect(0, 0, width, height);
        const px = selected.x * width;
        const py = selected.y * height;
        drawSelectionIndicator(px, py);
    }

    function drawSelectionIndicator(x, y) {
        ctx.save();
        ctx.beginPath();
        ctx.arc(x, y, 7, 0, 2 * Math.PI);
        ctx.lineWidth = 2;
        ctx.strokeStyle = '#fff';
        ctx.shadowColor = '#000';
        ctx.shadowBlur = 2;
        ctx.stroke();
        ctx.beginPath();
        ctx.arc(x, y, 3, 0, 2 * Math.PI);
        ctx.fillStyle = getColorAtPosition(x, y);
        ctx.shadowBlur = 0;
        ctx.fill();
        ctx.restore();
    }

    function getColorAtPosition(x, y) {
        const width = colorArea.width;
        const height = colorArea.height;
        const s = x / width;
        const v = 1 - (y / height);
        const rgb = hsvToRgb(hue / 360, s, v);
        return `rgb(${rgb[0]}, ${rgb[1]}, ${rgb[2]})`;
    }

    function hsvToRgb(h, s, v) {
        let r, g, b;
        let i = Math.floor(h * 6);
        let f = h * 6 - i;
        let p = v * (1 - s);
        let q = v * (1 - f * s);
        let t = v * (1 - (1 - f) * s);
        switch (i % 6) {
            case 0: r = v, g = t, b = p; break;
            case 1: r = q, g = v, b = p; break;
            case 2: r = p, g = v, b = t; break;
            case 3: r = p, g = q, b = v; break;
            case 4: r = t, g = p, b = v; break;
            case 5: r = v, g = p, b = q; break;
        }
        return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
    }

    function resizeCanvas() {
        const rect = colorArea.getBoundingClientRect();
        colorArea.width = rect.width;
        colorArea.height = rect.height;
        drawColorArea(hue);
    }

    window.addEventListener('resize', resizeCanvas);
    resizeCanvas();
    
    function initializeColorPicker() {
        hue = 0;
        hueSlider.value = 0;
        
        selected = { x: 0.03, y: 0.05 };
        
        drawColorArea(hue);
        
        retrieveNUI('changeVehicleColor', {
            r: 255,
            g: 255,
            b: 255
        });
    }
    
    setTimeout(initializeColorPicker, 100);

    hueSlider.addEventListener('input', function() {
        hue = parseInt(this.value);
        drawColorArea(hue);
        
        const color = getColorAtPosition(selected.x * colorArea.width, selected.y * colorArea.height);
        const rgb = color.match(/\d+/g);
        if (rgb && rgb.length >= 3) {
            retrieveNUI('changeVehicleColor', {
                r: parseInt(rgb[0]),
                g: parseInt(rgb[1]),
                b: parseInt(rgb[2])
            });
        }
    });

    colorArea.addEventListener('mousedown', function(e) {
        function pickColor(ev) {
            const rect = colorArea.getBoundingClientRect();
            const x = Math.max(0, Math.min(ev.clientX - rect.left, colorArea.width));
            const y = Math.max(0, Math.min(ev.clientY - rect.top, colorArea.height));
            selected.x = x / colorArea.width;
            selected.y = y / colorArea.height;
            drawColorArea(hue);
            
            const color = getColorAtPosition(x, y);
            const rgb = color.match(/\d+/g);
            if (rgb && rgb.length >= 3) {
                retrieveNUI('changeVehicleColor', {
                    r: parseInt(rgb[0]),
                    g: parseInt(rgb[1]),
                    b: parseInt(rgb[2])
                });
            }
        }
        pickColor(e);
        function onMove(ev) { pickColor(ev); }
        function onUp() {
            window.removeEventListener('mousemove', onMove);
            window.removeEventListener('mouseup', onUp);
        }
            window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
    });

    retrieveNUI('vehicleListingLoaded', {});
}

function setupDashboard() {
    $('#dashboard').html('');
    $('#dashboard').html(`
        <div class="info">
            <div class="logo">
                <div class="okok">${locales.translations.okok}</div>
                <div class="resource">${locales.translations.vehicleshop}</div>
            </div>
            <div class="navbar">
                <div class="navbar-items">
                    <a id="overview-btn" class="nav-item nav-item-selected"><i class="bi bi-grid-1x2-fill"></i><span class="nav-item-text">${locales.translations.overview}</span></a>
                    <a id="stock-btn" class="nav-item mt-05"><i class="bi bi-archive-fill"></i><span class="nav-item-text">${locales.translations.stock}</span></a>
                    <a id="saleshistory-btn" class="nav-item mt-05"><i class="bi bi-file-earmark-check-fill"></i><span class="nav-item-text">${locales.translations.saleshistory}</span></a>
                    <a id="employees-btn" class="nav-item mt-05"><i class="bi bi-people-fill"></i><span class="nav-item-text">${locales.translations.employees}</span></a>
                    <a id="orders-btn" class="nav-item mt-05"><i class="bi bi-pin-map-fill"></i><span class="nav-item-text">${locales.translations.orders}</span></a>
                    <a id="customerorders-btn" class="nav-item mt-05"><i class="bi bi-bag-fill"></i><span class="nav-item-text">${locales.translations.customerorders}</span></a>
                    <a id="logs-btn" class="nav-item mt-05"><i class="bi bi-folder-fill"></i><span class="nav-item-text">${locales.translations.logs}</span></a>
                    <a id="car-showcase-dashboard-btn" class="nav-item mt-05"><i class="bi bi-car-front-fill"></i><span class="nav-item-text">${locales.translations.carshowcase}</span></a>
                    <a id="sell-business" class="nav-item mt-05 sell-business"><i class="bi bi-building-fill-x"></i><span class="nav-item-text">${locales.translations.sellbusiness}</span></a>
                </div>
                <div class="user-info">
                    <div class="user-info-img">
                        <img src="${playerSex == "0" ? "./img/avatar_male.png" : "./img/avatar_female.png"}" class="avatar">
                    </div>
                    <div class="user-info-data">
                        <span class="char-name">${playerName}</span>
                        <span class="grade">${playerGrade}</span>
                    </div>
                    <div id="logout-btn" class="logout">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="content">
            <div class="page">
                <span class="page-title">${locales.translations.overview}</span>
            </div>
            <div class="page-info">
                <div class="row">
                    <div class="item">
                        <div class="item-header">
                            <div class="item-title">${locales.translations.finances}</div>
                        </div>
                        <div class="finances-item-content">
                            <div class="finances-balance-div">
                                <div class="fff">${locales.translations.balance}</div>
                                <div id="stand-balance" class="d5d6da">${setLocaleString(standInfo.money)}</div>
                            </div>
                            <div class="finances-buttons">
                                <div id="deposit-money" class="btn-blue fnb">${locales.translations.deposit}</div>
                                <div id="withdraw-money" class="btn-blue fnb">${locales.translations.withdraw}</div>
                            </div>
                            <div class="finances-wp">
                                <div class="wpg">${locales.translations.weeklyprofitgoal}</span></div>
                                <div class="progress-bar">
                                    <div class="progress" id="weekly-progress"></div>
                                </div>
                                <div id="progress-text"></div>
                                <div id="manage-goal" class="finances-wp-manage">${locales.translations.manage}</div>
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="item-header">
                            <div class="item-title">${locales.translations.statistics}</div>
                        </div>
                        <div class="stats-item-content">
                            <div class="stats-item">
                                <div class="fff">${locales.translations.instock}</div>
                                <div class="d5d6da">${standInfo.fullStockAmount}</div>
                            </div>
                            <div class="stats-item">
                                <div class="fff">${locales.translations.onsale}</div>
                                <div class="d5d6da">${standInfo.onSaleAmount}</div>
                            </div>
                            <div class="stats-item">
                                <div class="fff">${locales.translations.pendingorders}</div>
                                <div id="pending-orders" class="d5d6da"></div>
                            </div>
                            <div class="stats-item">
                                <div class="fff">${locales.translations.awaitingdelivery}</div>
                                <div id="awaiting-delivery" class="d5d6da"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="item-double">
                        <div class="item-header">
                            <div class="item-title">${locales.translations.popularvehicles}</div>
                            <div onclick="setupSalesHistory()" class="pv-viewall">${locales.translations.viewall}</div>
                        </div>
                        <div id="popular-vehicles" class="item-content"></div>
                    </div>
                </div>
            </div>
        </div>
    `);

    if (isSubowner) { $(".sell-business").hide()}

    $("#popular-vehicles").html(``);

    setDatatableColor('#373737', '1rem', '1rem');
    setDatatableSearchSettings('1rem', '1.0625rem', '0.3125rem', '8rem');

    let row = ``;
    let vehicles = 3;

    if (!standInfo.salesHistory) {standInfo.salesHistory = []}

    if (standInfo.salesHistory.length == 0) {
        for (let i = 0; i < 3; i++) {

            $("#popular-vehicles").append(`
            <div class="msv">
                <div class="msv-item-header">
                    <div class="msv-item-title">${locales.translations.nodata}</div>
                </div>
                <div class="msv-item-body">
                    <div class="msv-item-img-div">
                        <div class="no_data">?</div>
                    </div>
                    <div class="total-sold">${locales.translations.nodata}</div>
                </div>
            </div>
                `);
        }
    } else {
        if (standInfo.salesHistory.length < 3) { vehicles = standInfo.salesHistory.length }

        const sortedSalesHistory = [...standInfo.salesHistory].sort((a, b) => {
            const salesA = standInfo.salesCount[a.vehicle_id] || 0;
            const salesB = standInfo.salesCount[b.vehicle_id] || 0;
            return salesB - salesA;
        });

        const uniqueVehicles = [];
        const seenIds = new Set();
        for (let i = 0; i < sortedSalesHistory.length && uniqueVehicles.length < 3; i++) {
            const v = sortedSalesHistory[i];
            if (!seenIds.has(v.vehicle_id)) {
                uniqueVehicles.push(v);
                seenIds.add(v.vehicle_id);
            }
        }

        let row = "";
        for (let i = 0; i < uniqueVehicles.length; i++) {
            const v = uniqueVehicles[i];
            let imageUrl;
            if (useSameImageForAllVehicles) {
                imageUrl = `img/vehicles/default.png`;
            } else if (useLocalImages) {
                imageUrl = `img/vehicles/${v.vehicle_id}.png`;
            } else {
                imageUrl = `https://raw.githubusercontent.com/SrPeterr/okokvehicle-images/refs/heads/main/vehicles-all/${v.vehicle_id}.png`;
            }
            const imgElement = `<img src="${imageUrl}" class="vehicle-card-image-size" onerror="if (!this._attemptedLocal) {this._attemptedLocal = true; this.src='img/vehicles/${v.vehicle_id}.png';} else {this.onerror=null;this.src='img/vehicles/default.png';}">`;
            row += `
                <div class="msv">
                    <div class="msv-item-header">
                        <div class="msv-item-title">${v.vehicle_name}</div>
                    </div>
                    <div class="msv-item-body">
                        <div class="msv-item-img-div">
                            <div class="vehicle-card-image">
                                ${imgElement}
                            </div>
                        </div>
                        <div class="total-sold">${locales.translations.sold}: ${standInfo.salesCount[v.vehicle_id]}</div>
                    </div>
                </div>
            `;
        }
        for (let i = uniqueVehicles.length; i < 3; i++) {
            row += `
                <div class="msv">
                    <div class="msv-item-header">
                        <div class="msv-item-title">${locales.translations.nodata}</div>
                    </div>
                    <div class="msv-item-body">
                        <div class="msv-item-img-div">
                            <div class="no_data">?</div>
                        </div>
                        <div class="total-sold">${locales.translations.nodata}</div>
                    </div>
                </div>
            `;
        }
        $("#popular-vehicles").html(row);
    }

    var pendingOrders = 0;
    var awaitingDelivery = 0;

    if (!standInfo.orders) {standInfo.orders = []}

    for (let i = 0; i < standInfo.orders.length; i++) {
        if (standInfo.orders[i]) {
            if (standInfo.orders[i].status == 'pending') {
                pendingOrders++;
            } else if (standInfo.orders[i].status == 'ready') {
                awaitingDelivery++;
            }
        }
    }

    $('#pending-orders').html(pendingOrders);
    $('#awaiting-delivery').html(awaitingDelivery);

    setWeeklyGoalProgress(standInfo.weekly_profit_goal_percentage, standInfo.weekly_profit_goal);
};

function searchStock() {
    const searchTerm = $('#search-input-stock').val().toLowerCase();
    const selectedCategory = window.selectedValue;
    
    let filteredVehicles = standInfo.vehicles.filter(vehicle => {
        const matchesSearch = vehicle.vehicle_name.toLowerCase().includes(searchTerm);
        const matchesCategory = selectedCategory === "all" || vehicle.category === selectedCategory;
        
        return matchesSearch && matchesCategory;
    });
    
    setupStockVehicles(filteredVehicles);
}

function filterStockByCategory() {
    const selectedCategory = window.selectedValue;
    const searchTerm = $('#search-input-stock').val().toLowerCase();
    
    let filteredVehicles = standInfo.vehicles.filter(vehicle => {
        const matchesSearch = vehicle.vehicle_name.toLowerCase().includes(searchTerm);
        const matchesCategory = selectedCategory === "all" || vehicle.category === selectedCategory;
        
        return matchesSearch && matchesCategory;
    });
    
    setupStockVehicles(filteredVehicles);
}

function setupStockVehicles(vehicles) {
    let row = ``

    for (let i = 0; i < vehicles.length; i++) {
        const vehicle = vehicles[i];

        if (vehicle.type != standInfo.type) {continue}

        const originalIndex = standInfo.vehicles.findIndex(v => v.vehicle_id === vehicle.vehicle_id);

        let stockData = vehicle.stock;
        if (typeof stockData === 'string') {
            try {
                stockData = JSON.parse(stockData);
            } catch (e) {
                stockData = {};
            }
        }
        
        if (!stockData || typeof stockData !== 'object') {stockData = {}}

        const currentStandStock = stockData[standInfo.id] || {amount: 0, price: 0, listed: true};

        if (currentStandStock.amount > 0) {vehicle.status = "in-stock"} else {vehicle.status = "vehicle-status-gray"}

        if (typeof currentStandStock.listed !== 'boolean') {currentStandStock.listed = true}

        let displayPrice;
        if (currentStandStock.price == 0 || !currentStandStock.price) {
            displayPrice = setLocaleString(vehicle.max_price);
        } else {
            displayPrice = setLocaleString(currentStandStock.price);
        }

        let imageUrl;
        if (useSameImageForAllVehicles) {
            imageUrl = `img/vehicles/default.png`;
        } else if (useLocalImages) {
            imageUrl = `img/vehicles/${vehicle.vehicle_id}.png`;
        } else {
            imageUrl = `https://raw.githubusercontent.com/SrPeterr/okokvehicle-images/refs/heads/main/vehicles-all/${vehicle.vehicle_id}.png`;
        }

        const imgElement = `<img src="${imageUrl}" class="vehicle-card-image-size" onerror="if (!this._attemptedLocal) {this._attemptedLocal = true; this.src='img/vehicles/${vehicle.vehicle_id}.png';} else {this.onerror=null;this.src='img/vehicles/default.png';}">`;

        row += `
        <div class="catalog-card" data-vehicle-index="${originalIndex}">
            <div class="catalog-card-header">
                <div class="catalog-card-title">${vehicle.vehicle_name.substring(0, 10)}</div>
                <div>
                    <div class="vehicle-status ${vehicle.status}">${currentStandStock.amount} ${locales.translations.onstock}</div>
                </div>
            </div>
            <div class="catalog-card-img-div">
                <div class="vehicle-card-image">
                    ${imgElement}
                </div>
                <div onClick="changePrice(${originalIndex})" class="catalog-card-price">${displayPrice}</div>
            </div>
            <div class="catalog-card-footer">
                <div onClick="toggleListed(${originalIndex})" class="buy-btn ${currentStandStock.listed ? "green" : "red"}">${currentStandStock.listed ? locales.translations.listed : locales.translations.unlisted}</div>
                <div onClick="buyVehicle(${originalIndex})" class="buy-btn">${locales.translations.buy}</div>
            </div>
        </div>`
    }

    $("#stock-cards").html(row);
    
    checkAllVehiclesListedStatus();
}

function setupStock() {
    // Clear all existing event listeners to prevent duplicates
    $("#all-stock-btn").off();
    $("#closeAllStockButton, #closeAllStockModal").off();
    $("#allStock_btn_modal").off();
    $("#custom-select-header").off();
    $(document).off('click.stockSetup');
    $(document).off('click', '.custom-select-option');
    
    $('#stock').html('');
    $('#stock').html(`
    <div class="info">
        <div class="logo">
            <div class="okok">${locales.translations.okok}</div>
            <div class="resource">${locales.translations.vehicleshop}</div>
        </div>
        <div class="navbar">
            <div class="navbar-items">
                <a id="overview-btn" class="nav-item"><i class="bi bi-grid-1x2-fill"></i><span class="nav-item-text">${locales.translations.overview}</span></a>
                <a id="stock-btn" class="nav-item mt-05 nav-item-selected"><i class="bi bi-archive-fill"></i><span class="nav-item-text">${locales.translations.stock}</span></a>
                <a id="saleshistory-btn" class="nav-item mt-05"><i class="bi bi-file-earmark-check-fill"></i><span class="nav-item-text">${locales.translations.saleshistory}</span></a>
                <a id="employees-btn" class="nav-item mt-05"><i class="bi bi-people-fill"></i><span class="nav-item-text">${locales.translations.employees}</span></a>
                <a id="orders-btn" class="nav-item mt-05"><i class="bi bi-pin-map-fill"></i><span class="nav-item-text">${locales.translations.orders}</span></a>
                <a id="customerorders-btn" class="nav-item mt-05"><i class="bi bi-bag-fill"></i><span class="nav-item-text">${locales.translations.customerorders}</span></a>
                <a id="logs-btn" class="nav-item mt-05"><i class="bi bi-folder-fill"></i><span class="nav-item-text">${locales.translations.logs}</span></a>
                <a id="car-showcase-dashboard-btn" class="nav-item mt-05"><i class="bi bi-car-front-fill"></i><span class="nav-item-text">${locales.translations.carshowcase}</span></a>
                <a id="sell-business" class="nav-item mt-05 sell-business"><i class="bi bi-building-fill-x"></i><span class="nav-item-text">${locales.translations.sellbusiness}</span></a>
            </div>
            <div class="user-info">
                 <div class="user-info-img">
                     <img src="${playerSex == "0" ? "./img/avatar_male.png" : "./img/avatar_female.png"}" class="avatar">
                 </div>
                <div class="user-info-data">
                    <span class="char-name">${playerName}</span>
                    <span class="grade">${playerGrade}</span>
                </div>
                <div id="logout-btn" class="logout">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                </div>
            </div>
        </div>
    </div>
    
    <div class="content">
        <div class="page">
            <span class="page-title">${locales.translations.stock}</span>
            <div class="d-flex-row">
                <div class="all-stock-btn" id="all-stock-btn">

                    <i class="fa-solid fa-eye"></i>

                </div>
                <div class="custom-select-container">
                    <div class="custom-select-header" id="custom-select-header">
                        <span class="custom-select-selected" id="custom-select-selected">${locales.translations.all}</span>
                        <i class="fas fa-chevron-down custom-select-arrow" id="custom-select-arrow"></i>
                    </div>
                    <div class="custom-select-dropdown" id="custom-select-dropdown">
                        <div class="custom-select-option" data-value="all" data-index="0">${locales.translations.all}</div>
                    </div>
                </div>
                <div class="search-bar">
                    <input type="text" id="search-input-stock" onkeyup="searchStock()" class="search-input-stock" placeholder="${locales.translations.search}">
                </div>

            </div>
        </div>
        <div class="page-info">
            <div class="catalog-cards-container">
                <div id="stock-cards" class="catalog-cards"></div>
            </div>
        </div>
    </div>
    `);

    checkAllVehiclesListedStatus();
    
    if (allVehiclesListed) {
        $('#all-stock-btn').html(`
            <i class="fa-solid fa-eye-slash"></i>
        `);
    } else {
        $('#all-stock-btn').html(`
            <i class="fa-solid fa-eye"></i>
        `);
    }

    $("#all-stock-btn").on("click", function() {
        if (allVehiclesListed) {
            $('#all_stock_title').text(locales.translations.unlistvehicles);
            $('#all_stock_text').text(locales.translations.unlistallstock);
        } else {
            $('#all_stock_title').text(locales.translations.listvehicles);
            $('#all_stock_text').text(locales.translations.listallstock);
        }
        var modal = document.getElementById('allStockModal');
        modal.style.display = 'flex';
        setTimeout(function () {
            modal.classList.add('show');
        }, 50);
    });
    
    $("#closeAllStockButton, #closeAllStockModal").on("click", function() {
        var modal = document.getElementById('allStockModal');
        modal.classList.remove('show');
        setTimeout(function () {
            modal.style.display = 'none';
        }, 300);
    });
    
    $("#allStock_btn_modal").on("click", async function() {
        const desiredState = !allVehiclesListed;
        const updatedInfo = await retrieveNUI("setAllVehiclesListed", {standId: standInfo.id, allVehiclesListed: desiredState});
        
        if (updatedInfo) {
            standInfo = updatedInfo;
            
            allVehiclesListed = desiredState;
            
            if (allVehiclesListed) {
                $('#all-stock-btn').html(`
                    <i class="fa-solid fa-eye-slash"></i>
                `);
            } else {
                $('#all-stock-btn').html(`
                    <i class="fa-solid fa-eye"></i>
                `);
            }
    
            var modal = document.getElementById('allStockModal');
            modal.classList.remove('show');
            setTimeout(function () {
                modal.style.display = 'none';
            }, 300);
            
            setupStockVehicles(standInfo.vehicles);
        }
    });

    const uniqueCategories = new Set();
    for (let i = 0; i < standInfo.vehicles.length; i++) {
        const vehicle = standInfo.vehicles[i];
        if (vehicle.type != standInfo.type) {continue}
        uniqueCategories.add(vehicle.category);
    }

    const categoriesArray = Array.from(uniqueCategories);
        categoriesArray.forEach((category, index) => {
        let optionClass = '';
        if (index === categoriesArray.length - 1) {
            optionClass = 'last-option';
        }
        
        $("#custom-select-dropdown").append(`<div class="custom-select-option ${optionClass}" data-value="${category}" data-index="${index + 1}">${categoriesLabels[category]}</div>`);
    });

    window.selectedValue = 'all';
    
    $(".custom-select-option[data-value='all']").addClass('selected');
    
    $("#custom-select-header").on('click', function() {
        $("#custom-select-dropdown").toggleClass('show');
        $("#custom-select-arrow").toggleClass('rotate');
    });
    
    $(document).off('click.stockSetup').on('click.stockSetup', function(e) {
        if (!$(e.target).closest('.custom-select-container').length) {
            $("#custom-select-dropdown").removeClass('show');
            $("#custom-select-arrow").removeClass('rotate');
        }
    });
    
    $(document).on('click', '.custom-select-option', function() {
        const value = $(this).data('value');
        const text = $(this).text();
        
        window.selectedValue = value;
        $("#custom-select-selected").text(text);
        $("#custom-select-dropdown").removeClass('show');
        $("#custom-select-arrow").removeClass('rotate');
        
        $(".custom-select-option").removeClass('selected');
        $(this).addClass('selected');
        
        filterStockByCategory();
    });

    if (isSubowner) { $(".sell-business").hide()}

    setupStockVehicles(standInfo.vehicles);

    $("#stock").css('display', 'flex').hide().show();
        
    if (standInfo.vehicles && standInfo.vehicles.length > 9) {
        $('.catalog-cards').css('width', '51.575rem');
    } else {
        $('.catalog-cards').css('width', '51rem');
    }
    setDatatableSearchSettings('1rem', '1.0625rem', '0.3125rem', '8rem');
};

function setupSalesHistory() {
    $('#salesHistory').html('');
    $('#salesHistory').html(`
    <div class="info">
        <div class="logo">
            <div class="okok">okok</div>
            <div class="resource">Vehicle Shop</div>
        </div>
        <div class="navbar">
            <div class="navbar-items">
                <a id="overview-btn" class="nav-item"><i class="bi bi-grid-1x2-fill"></i><span class="nav-item-text">${locales.translations.overview}</span></a>
                <a id="stock-btn" class="nav-item mt-05"><i class="bi bi-archive-fill"></i><span class="nav-item-text">${locales.translations.stock}</span></a>
                <a id="saleshistory-btn" class="nav-item mt-05 nav-item-selected"><i class="bi bi-file-earmark-check-fill"></i><span class="nav-item-text">${locales.translations.saleshistory}</span></a>
                <a id="employees-btn" class="nav-item mt-05"><i class="bi bi-people-fill"></i><span class="nav-item-text">${locales.translations.employees}</span></a>
                <a id="orders-btn" class="nav-item mt-05"><i class="bi bi-pin-map-fill"></i><span class="nav-item-text">${locales.translations.orders}</span></a>
                <a id="customerorders-btn" class="nav-item mt-05"><i class="bi bi-bag-fill"></i><span class="nav-item-text">${locales.translations.customerorders}</span></a>
                <a id="logs-btn" class="nav-item mt-05"><i class="bi bi-folder-fill"></i><span class="nav-item-text">${locales.translations.logs}</span></a>
                <a id="car-showcase-dashboard-btn" class="nav-item mt-05"><i class="bi bi-car-front-fill"></i><span class="nav-item-text">${locales.translations.carshowcase}</span></a>
                <a id="sell-business" class="nav-item mt-05 sell-business"><i class="bi bi-building-fill-x"></i><span class="nav-item-text">${locales.translations.sellbusiness}</span></a>
            </div>
            <div class="user-info">
                 <div class="user-info-img">
                     <img src="${playerSex == "0" ? "./img/avatar_male.png" : "./img/avatar_female.png"}" class="avatar">
                 </div>
                <div class="user-info-data">
                    <span class="char-name">${playerName}</span>
                    <span class="grade">${playerGrade}</span>
                </div>
                <div id="logout-btn" class="logout">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                </div>
            </div>
        </div>
    </div>
    
    <div class="content">
        <div class="page">
            <span class="page-title">${locales.translations.saleshistory}</span>
        </div>
        <div class="page-info">
            <table id="salesHistoryTable" class="mt-2875">
                <thead>
                    <tr>
                        <th class="text-center">${locales.translations.vehicle}</th>
                        <th class="text-center">${locales.translations.price}</th>
                        <th class="text-center">${locales.translations.customer}</th>
                        <th class="text-center">${locales.translations.date}</th>
                    </tr>
                </thead>
                <tbody id="salesHistoryTableData"></tbody>
            </table>
            </div>
        </div>
    </div>
    `);

    if (isSubowner) { $(".sell-business").hide()}

    $('#salesHistoryTableData').html(``)

    let row = ``;
    if (standInfo.salesHistory && standInfo.salesHistory.length > 0) {
        for (let i = 0; i < standInfo.salesHistory.length; i++) {
            const sale = standInfo.salesHistory[i];
            row += `
                <tr>
                    <td class="text-center align-middle">${sale.vehicle_name}</td>
                    <td class="text-center align-middle">${setLocaleString(sale.price)}</td>
                    <td class="text-center align-middle">${sale.buyer_name}</td>
                    <td class="text-center align-middle">${sale.date}</td>
                </tr>
            `;
        }
    }

    $('#salesHistoryTableData').append(row);

    var table_id = document.getElementById('salesHistoryTable');
    table.push(new simpleDatatables.DataTable(table_id, {
        perPageSelect: false,
        perPage: 8,
        labels: {
            placeholder: locales.translations.search,
            perPage: locales.translations.entriesperpage,
            noRows: locales.translations.novehiclesfound,
            noResults: locales.translations.noresultsfound
        }
    }));
    $("#salesHistory").css('display', 'flex').hide().show();
    setDatatableSearchSettings('1rem', '1.0625rem', '0.3125rem', '8rem');
};

function setupEmployees() {
    $('#employees').html('');
    $('#employees').html(`
    <div class="info">
        <div class="logo">
            <div class="okok">okok</div>
            <div class="resource">Vehicle Shop</div>
        </div>
        <div class="navbar">
            <div class="navbar-items">
                <a id="overview-btn" class="nav-item"><i class="bi bi-grid-1x2-fill"></i><span class="nav-item-text">${locales.translations.overview}</span></a>
                <a id="stock-btn" class="nav-item mt-05"><i class="bi bi-archive-fill"></i><span class="nav-item-text">${locales.translations.stock}</span></a>
                <a id="saleshistory-btn" class="nav-item mt-05"><i class="bi bi-file-earmark-check-fill"></i><span class="nav-item-text">${locales.translations.saleshistory}</span></a>
                <a id="employees-btn" class="nav-item mt-05 nav-item-selected"><i class="bi bi-people-fill"></i><span class="nav-item-text">${locales.translations.employees}</span></a>
                <a id="orders-btn" class="nav-item mt-05"><i class="bi bi-pin-map-fill"></i><span class="nav-item-text">${locales.translations.orders}</span></a>
                <a id="customerorders-btn" class="nav-item mt-05"><i class="bi bi-bag-fill"></i><span class="nav-item-text">${locales.translations.customerorders}</span></a>
                <a id="logs-btn" class="nav-item mt-05"><i class="bi bi-folder-fill"></i><span class="nav-item-text">${locales.translations.logs}</span></a>
                <a id="car-showcase-dashboard-btn" class="nav-item mt-05"><i class="bi bi-car-front-fill"></i><span class="nav-item-text">${locales.translations.carshowcase}</span></a>
                <a id="sell-business" class="nav-item mt-05 sell-business"><i class="bi bi-building-fill-x"></i><span class="nav-item-text">${locales.translations.sellbusiness}</span></a>
            </div>
            <div class="user-info">
                 <div class="user-info-img">
                     <img src="${playerSex == "0" ? "./img/avatar_male.png" : "./img/avatar_female.png"}" class="avatar">
                 </div>
                <div class="user-info-data">
                    <span class="char-name">${playerName}</span>
                    <span class="grade">${playerGrade}</span>
                </div>
                <div id="logout-btn" class="logout">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                </div>
            </div>
        </div>
    </div>
    
    <div class="content">
        <div class="page">
            <span class="page-title">${locales.translations.manageemployees}</span>
            <button class="btn btn-blue" onclick="hireEmployee()"><i class="fa-solid fa-plus"></i>${locales.translations.hireemployee}</button>
        </div>
        <div class="page-info">
            <div id="employees-list" class="catalog-cards"></div>
        </div>
    </div>
    `);

    if (isSubowner) { $(".sell-business").hide()}

    setupEmployeesList();

    $("#employees").css('display', 'flex').hide().show();
}

function setupEmployeesList() {
    $('#employees-list').html('');
    let row = ``;

    if (!standInfo.employees || typeof standInfo.employees !== 'object') {standInfo.employees = {}}

    var employeesLength = Object.keys(standInfo.employees).length;

    if (employeesLength == 0) {

        row += `
        <div class="no-employees">
            <div class="no-employees-text">${locales.translations.noemployeesfound}</div>
        </div>
        `;
    } else {
        Object.values(standInfo.employees).forEach(employee => {
            row += `
                <div class="catalog-card">
                    <div class="catalog-card-header">
                        <div>
    
                        </div>
                        <div>
                            <div class="vehicle-status in-stock">${setLocaleString(employee.earned)} ${locales.translations.earned}</div>
                        </div>
                    </div>
                    <div class="catalog-card-img-div mt-0425">
                        <img src="img/avatar_male.png" class="employee-card-img">
                        <div class="employee-card-title">${employee.name}</div>
                    </div>
                    <div class="catalog-card-footer">
                        <div onclick="editEmployee('${employee.identifier}')" class="remove-btn"><i class="fa-solid fa-pen"></i>${locales.translations.editemployee}</div>
                    </div>
                </div>
            `;
        });
    }

    $('#employees-list').append(row);
}

async function hireEmployee() {
    var closePlayers = await retrieveNUI('getClosePlayers', {})

    $("#dropdown_to_hire").html('<option disabled selected value="">' + locales.translations.selectemployee + '</option>');

    if (closePlayers == 'error') return;

    for (let i = 0; i < closePlayers.length; i++) {
        const player = closePlayers[i];
        $("#dropdown_to_hire").append(`<option value="${player.identifier}">${player.name}</option>`);
    }

    var modal = document.getElementById('hireEmployeeModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
}

var currentEditingEmployee = null;

function getRankName(rankNumber) {
    if (rankNumber === null || rankNumber === undefined) return "";
    const rankIndex = rankNumber - 1;
    if (rankIndex >= 0 && rankIndex < jobRanks.length) {
        return jobRanks[rankIndex].rank;
    }
    return "";
}

function editEmployee(identifier) {

    var modal = document.getElementById('editEmployeeModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
    
    var employee = null;


    if (!standInfo.employees || typeof standInfo.employees !== 'object') {
        standInfo.employees = {};
    }

    Object.values(standInfo.employees).forEach(emp => {
        if (emp.identifier === identifier) {
            employee = emp;
        }
    });
    
    currentEditingEmployee = employee;

    if (employee) {
        $("#employee_name").val(employee.name);
        $("#total_earned").val(setLocaleString(employee.earned));
        
        if (employee.rank !== undefined) {
            const rankIndex = employee.rank - 1;
            if (rankIndex >= 0 && rankIndex < jobRanks.length) {
                $("#employee_grades").val(rankIndex);
                $("#employee_grade").val(jobRanks[rankIndex].rank);
            }
        }
    }
    
    $("#employee_grades").html('');
    jobRanks.forEach((rank, index) => {$("#employee_grades").append(`<option value="${index}">${rank.rank}</option>`)});
    $("#employee_grades").off('change').on('change', function() {checkIfEmpty()});
    
    if (employee && employee.rank !== undefined) {
        const rankIndex = employee.rank - 1;
        if (rankIndex >= 0 && rankIndex < jobRanks.length) {
            $("#employee_grades").val(rankIndex);
            $("#employee_grade").val(jobRanks[rankIndex].rank);
        }
    }
}

function setupOrders() {
    $('#orders').html('');
    $('#orders').html(`
    <div class="info">
        <div class="logo">
            <div class="okok">okok</div>
            <div class="resource">Vehicle Shop</div>
        </div>
        <div class="navbar">
            <div class="navbar-items">
                <a id="overview-btn" class="nav-item"><i class="bi bi-grid-1x2-fill"></i><span class="nav-item-text">${locales.translations.overview}</span></a>
                <a id="stock-btn" class="nav-item mt-05"><i class="bi bi-archive-fill"></i><span class="nav-item-text">${locales.translations.stock}</span></a>
                <a id="saleshistory-btn" class="nav-item mt-05"><i class="bi bi-file-earmark-check-fill"></i><span class="nav-item-text">${locales.translations.saleshistory}</span></a>
                <a id="employees-btn" class="nav-item mt-05"><i class="bi bi-people-fill"></i><span class="nav-item-text">${locales.translations.employees}</span></a>
                <a id="orders-btn" class="nav-item mt-05 nav-item-selected"><i class="bi bi-pin-map-fill"></i><span class="nav-item-text">${locales.translations.orders}</span></a>
                <a id="customerorders-btn" class="nav-item mt-05"><i class="bi bi-bag-fill"></i><span class="nav-item-text">${locales.translations.customerorders}</span></a>
                <a id="logs-btn" class="nav-item mt-05"><i class="bi bi-folder-fill"></i><span class="nav-item-text">${locales.translations.logs}</span></a>
                <a id="car-showcase-dashboard-btn" class="nav-item mt-05"><i class="bi bi-car-front-fill"></i><span class="nav-item-text">${locales.translations.carshowcase}</span></a>
                <a id="sell-business" class="nav-item mt-05 sell-business"><i class="bi bi-building-fill-x"></i><span class="nav-item-text">${locales.translations.sellbusiness}</span></a>
            </div>
            <div class="user-info">
                 <div class="user-info-img">
                     <img src="${playerSex == "0" ? "./img/avatar_male.png" : "./img/avatar_female.png"}" class="avatar">
                 </div>
                <div class="user-info-data">
                    <span class="char-name">${playerName}</span>
                    <span class="grade">${playerGrade}</span>
                </div>
                <div id="logout-btn" class="logout">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                </div>
            </div>
        </div>
    </div>
    
    <div class="content">
        <div class="page">
            <span class="page-title">${locales.translations.orders}</span>
        </div>
        <div class="page-info">
            <table id="ordersTable" class="mt-2875">
                <thead>
                    <tr>
                        <th class="text-center">${locales.translations.vehicle}</th>
                        <th class="text-center">${locales.translations.reward}</th>
                        <th class="text-center">${locales.translations.employee}</th>
                        <th class="text-center">${locales.translations.actions}</th>
                    </tr>
                </thead>
                <tbody id="ordersTableData"></tbody>
            </table>
            </div>
        </div>
    </div>
    `);

    if (standInfo.owner != playerIdentifier) {
        if (!isSubowner) {
            $("#overview-btn, #stock-btn, #saleshistory-btn, #employees-btn, #logs-btn, #car-showcase-dashboard-btn, .sell-business").hide();
        }
    }

    if (isSubowner) { $(".sell-business").hide()}

    let row = ``;
    for (let i = 0; i < standInfo.orders.length; i++) {
        const order = standInfo.orders[i];
        if (!order) continue;
        if (order.status == 'ready' || order.custom_order == 1) {
            continue;
        }
        if (order.employee_id == '') {
            row += `
                <tr>
                    <td class="text-center align-middle">${order.vehicle_name}</td>
                    <td class="text-center align-middle">${setLocaleString(order.reward)}</td>
                    <td class="text-center align-middle">${locales.translations.none}</td>
                    <td class="text-center align-middle"><button id="accept-order_${i}" onclick="acceptOrder(${i})" type="button" class="btn btn-blue btn-edit"><i class="fas fa-check"></i> ${locales.translations.accept}</button></td>
                </tr>
            `;
        } else if (order.employee_id == playerIdentifier) {
            row += `
                <tr>
                    <td class="text-center align-middle">${order.vehicle_name}</td>
                    <td class="text-center align-middle">${setLocaleString(order.reward)}</td>
                    <td class="text-center align-middle">${order.employee_name}</td>
                    <td class="text-center align-middle"><button id="cancel-order_${i}" onclick="cancelOrder(${i})" type="button" class="btn btn-blue btn-edit btn-cancel"><i class="fas fa-xmark"></i> ${locales.translations.cancel}</button></td>
                </tr>
            `;
        } else {
            row += `
                <tr>
                    <td class="text-center align-middle">${order.vehicle_name}</td>
                    <td class="text-center align-middle">${setLocaleString(order.reward)}</td>
                    <td class="text-center align-middle">${order.employee_name}</td>
                    <td class="text-center align-middle"><button id="complete-order_${i}" onclick="completeOrder(${i})" type="button" class="btn btn-blue btn-edit" disabled><i class="fas fa-spinner"></i> ${locales.translations.inprogress}</button></td>
                </tr>
            `;
        }
    }

    $('#ordersTableData').append(row);

    var table_id = document.getElementById('ordersTable');
    table.push(new simpleDatatables.DataTable(table_id, {
        perPageSelect: false,
        perPage: 8,
        labels: {
            placeholder: locales.translations.search,
            perPage: locales.translations.entriesperpage,
            noRows: locales.translations.noordersfound,
            noResults: locales.translations.noresultsfound
        }
    }));

    $("#orders").css('display', 'flex').hide().show();
    setDatatableSearchSettings('1rem', '1.0625rem', '0.3125rem', '8rem');
}

function setupLogs() {
    $('#logs').html('');
    $('#logs').html(`
    <div class="info">
        <div class="logo">
            <div class="okok">okok</div>
            <div class="resource">Vehicle Shop</div>
        </div>
        <div class="navbar">
            <div class="navbar-items">
                <a id="overview-btn" class="nav-item"><i class="bi bi-grid-1x2-fill"></i><span class="nav-item-text">${locales.translations.overview}</span></a>
                <a id="stock-btn" class="nav-item mt-05"><i class="bi bi-archive-fill"></i><span class="nav-item-text">${locales.translations.stock}</span></a>
                <a id="saleshistory-btn" class="nav-item mt-05"><i class="bi bi-file-earmark-check-fill"></i><span class="nav-item-text">${locales.translations.saleshistory}</span></a>
                <a id="employees-btn" class="nav-item mt-05"><i class="bi bi-people-fill"></i><span class="nav-item-text">${locales.translations.employees}</span></a>
                <a id="orders-btn" class="nav-item mt-05"><i class="bi bi-pin-map-fill"></i><span class="nav-item-text">${locales.translations.orders}</span></a>
                <a id="customerorders-btn" class="nav-item mt-05"><i class="bi bi-bag-fill"></i><span class="nav-item-text">${locales.translations.customerorders}</span></a>
                <a id="logs-btn" class="nav-item mt-05 nav-item-selected"><i class="bi bi-folder-fill"></i><span class="nav-item-text">${locales.translations.logs}</span></a>
                <a id="car-showcase-dashboard-btn" class="nav-item mt-05"><i class="bi bi-car-front-fill"></i><span class="nav-item-text">${locales.translations.carshowcase}</span></a>
                <a id="sell-business" class="nav-item mt-05 sell-business"><i class="bi bi-building-fill-x"></i><span class="nav-item-text">${locales.translations.sellbusiness}</span></a>
            </div>
            <div class="user-info">
                 <div class="user-info-img">
                     <img src="${playerSex == "0" ? "./img/avatar_male.png" : "./img/avatar_female.png"}" class="avatar">
                 </div>
                <div class="user-info-data">
                    <span class="char-name">${playerName}</span>
                    <span class="grade">${playerGrade}</span>
                </div>
                <div id="logout-btn" class="logout">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                </div>
            </div>
        </div>
    </div>
    
    <div class="content">
        <div class="page">
            <span class="page-title">${locales.translations.logs}</span>
        </div>
        <div class="page-info">
            <table id="logsTable" class="mt-2875">
                <thead>
                    <tr>
                        <th class="text-center">${locales.translations.employeename}</th>
                        <th class="text-center">${locales.translations.action}</th>
                        <th class="text-center">${locales.translations.date}</th>
                    </tr>
                </thead>
                <tbody id="logsTableData"></tbody>
            </table>
            </div>
        </div>
    </div>
    `);

    if (standInfo.owner != playerIdentifier) {
        if (!isSubowner) {
            $("#overview-btn, #stock-btn, #saleshistory-btn, #employees-btn, #logs-btn, #car-showcase-dashboard-btn, .sell-business").hide();
        }
    }

    if (isSubowner) { $(".sell-business").hide()}

    let row = ``;
    if (standInfo.logs) {
        for (let i = 0; i < standInfo.logs.length; i++) {
            const log = standInfo.logs[i];
            row += `
                <tr>
                    <td class="text-center align-middle">${log.employee_name}</td>
                    <td class="text-center align-middle">${log.action}</td>
                    <td class="text-center align-middle">${log.date}</td>
                </tr>
            `;
        }
    }

    $('#logsTableData').append(row);

    var table_id = document.getElementById('logsTable');
    table.push(new simpleDatatables.DataTable(table_id, {
        perPageSelect: false,
        perPage: 8,
        labels: {
            placeholder: locales.translations.search,
            perPage: locales.translations.entriesperpage,
            noRows: locales.translations.nologsfound,
            noResults: locales.translations.noresultsfound
        }
    }));

    $("#logs").css('display', 'flex').hide().show();
    setDatatableSearchSettings('1rem', '1.0625rem', '0.3125rem', '8rem');
}

function setupCustomerOrders() {
    $('#customerorders').html('');
    $('#customerorders').html(`
    <div class="info">
        <div class="logo">
            <div class="okok">okok</div>
            <div class="resource">Vehicle Shop</div>
        </div>
        <div class="navbar">
            <div class="navbar-items">
                <a id="overview-btn" class="nav-item"><i class="bi bi-grid-1x2-fill"></i><span class="nav-item-text">${locales.translations.overview}</span></a>
                <a id="stock-btn" class="nav-item mt-05"><i class="bi bi-archive-fill"></i><span class="nav-item-text">${locales.translations.stock}</span></a>
                <a id="saleshistory-btn" class="nav-item mt-05"><i class="bi bi-file-earmark-check-fill"></i><span class="nav-item-text">${locales.translations.saleshistory}</span></a>
                <a id="employees-btn" class="nav-item mt-05"><i class="bi bi-people-fill"></i><span class="nav-item-text">${locales.translations.employees}</span></a>
                <a id="orders-btn" class="nav-item mt-05"><i class="bi bi-pin-map-fill"></i><span class="nav-item-text">${locales.translations.orders}</span></a>
                <a id="customerorders-btn" class="nav-item mt-05 nav-item-selected"><i class="bi bi-bag-fill"></i><span class="nav-item-text">${locales.translations.customerorders}</span></a>
                <a id="logs-btn" class="nav-item mt-05"><i class="bi bi-folder-fill"></i><span class="nav-item-text">${locales.translations.logs}</span></a>
                <a id="car-showcase-dashboard-btn" class="nav-item mt-05"><i class="bi bi-car-front-fill"></i><span class="nav-item-text">${locales.translations.carshowcase}</span></a>
                <a id="sell-business" class="nav-item mt-05 sell-business"><i class="bi bi-building-fill-x"></i><span class="nav-item-text">${locales.translations.sellbusiness}</span></a>
            </div>
            <div class="user-info">
                 <div class="user-info-img">
                     <img src="${playerSex == "0" ? "./img/avatar_male.png" : "./img/avatar_female.png"}" class="avatar">
                 </div>
                <div class="user-info-data">
                    <span class="char-name">${playerName}</span>
                    <span class="grade">${playerGrade}</span>
                </div>
                <div id="logout-btn" class="logout">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                </div>
            </div>
        </div>
    </div>
    
    <div class="content">
        <div class="page">
            <span class="page-title">${locales.translations.customerorders}</span>
        </div>
        <div class="page-info">
            <table id="customerOrdersTable" class="mt-2875">
                <thead>
                    <tr>
                        <th class="text-center">${locales.translations.vehicle}</th>
                        <th class="text-center">${locales.translations.reward}</th>
                        <th class="text-center">${locales.translations.customer}</th>
                        <th class="text-center">${locales.translations.employee}</th>
                        <th class="text-center">${locales.translations.actions}</th>
                    </tr>
                </thead>
                <tbody id="customerOrdersTableData"></tbody>
            </table>
            </div>
        </div>
    </div>
    `);

    if (standInfo.owner != playerIdentifier) {
        if (!isSubowner) {
            $("#overview-btn, #stock-btn, #saleshistory-btn, #employees-btn, #logs-btn, #car-showcase-dashboard-btn, .sell-business").hide();
        }
    }

    if (isSubowner) { $(".sell-business").hide()}

    let row = ``;
    for (let i = 0; i < standInfo.orders.length; i++) {
        const order = standInfo.orders[i];
        if (!order) continue; // Skip null/undefined entries
        if (order.status == 'ready' || order.custom_order == 0) {
            continue;
        }
        if (order.status == 'pending' && order.employee_id == '') {
            row += `
                <tr>
                    <td class="text-center align-middle">${order.vehicle_name}</td>
                    <td class="text-center align-middle">${setLocaleString(order.reward)}</td>
                    <td class="text-center align-middle">${order.customer_name}</td>
                    <td class="text-center align-middle">${locales.translations.none}</td>
                    <td class="text-center align-middle"><button id="accept-order_${i}" onclick="acceptOrder(${i})" type="button" class="btn btn-blue btn-edit"><i class="fas fa-check"></i> ${locales.translations.accept}</button></td>
                </tr>
            `;
        } else if (order.employee_id == playerIdentifier) {
            row += `
                <tr>
                    <td class="text-center align-middle">${order.vehicle_name}</td>
                    <td class="text-center align-middle">${setLocaleString(order.reward)}</td>
                    <td class="text-center align-middle">${order.customer_name}</td>
                    <td class="text-center align-middle">${order.employee_name}</td>
                    <td class="text-center align-middle"><button id="cancel-order_${i}" onclick="cancelOrder(${i})" type="button" class="btn btn-blue btn-edit btn-cancel"><i class="fas fa-xmark"></i> ${locales.translations.cancel}</button></td>
                </tr>
            `;
        } else {
            row += `
                <tr>
                    <td class="text-center align-middle">${order.vehicle_name}</td>
                    <td class="text-center align-middle">${setLocaleString(order.reward)}</td>
                    <td class="text-center align-middle">${order.customer_name}</td>
                    <td class="text-center align-middle">${order.employee_name}</td>
                    <td class="text-center align-middle"><button id="complete-order_${i}" onclick="completeOrder(${i})" type="button" class="btn btn-blue btn-edit" disabled><i class="fas fa-spinner"></i> ${locales.translations.inprogress}</button></td>
                </tr>
            `;
        }
    }

    $('#customerOrdersTableData').append(row);

    var table_id = document.getElementById('customerOrdersTable');
    table.push(new simpleDatatables.DataTable(table_id, {
        perPageSelect: false,
        perPage: 7,
        labels: {
            placeholder: locales.translations.search,
            perPage: locales.translations.entriesperpage,
            noRows: locales.translations.nologsfound,
            noResults: locales.translations.noresultsfound
        }
    }));

    $("#customerorders").css('display', 'flex').hide().show();
    setDatatableSearchSettings('1rem', '1.0625rem', '0.3125rem', '8rem');
}

async function acceptOrder(orderIndex) {
    const order = standInfo.orders[orderIndex];
    var result = await retrieveNUI('acceptOrder', { standId: standInfo.id, orderId: order.id, vehicleId: order.vehicle_id, vehicleName: order.vehicle_name, vehicleColor: order.vehicle_color })
    if (result != false) {
        standInfo = result;
        if (order.custom_order == 0) {setupOrders()} else {setupCustomerOrders()}
    }
}

async function cancelOrder(orderIndex) {
    const order = standInfo.orders[orderIndex];
    var result = await retrieveNUI('cancelOrder', { standId: standInfo.id, orderId: order.id })
    if (result != false) {
        standInfo = result;
        if (order.custom_order == 0) {setupOrders()} else {setupCustomerOrders()}
    }
}

async function cancelOrderCustomer(orderIndex) {
    const order = standInfo.orders[orderIndex];
    var result = await retrieveNUI('cancelOrderCustomer', { standId: standInfo.id, orderId: order.id, isStandVip: isStandVip })
    if (result != false) {
        standInfo = result;
        setupMyOrders();
    }
}

async function claimOrderCustomer(orderIndex) {
    var modal = $('#myOrdersModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 300);
    
    const order = standInfo.orders[orderIndex];
    var result = await retrieveNUI('claimOrderCustomer', { standId: standInfo.id, orderId: order.id, orderInfo: order })
    if (result != false) {
        standInfo = result;
    }
}

function buyVehicle(vehicleIndex) {
    const vehicle = standInfo.vehicles[vehicleIndex];
    $("#buy_vehicle_text").html(`${locales.translations.doyouwanttobuy} ${vehicle.vehicle_name} ${locales.translations.forprice} ${setLocaleString(vehicle.owner_buy_price)}?`);
    vehicleToPurchase = vehicle.vehicle_id;
    var modal = document.getElementById('buyVehicleModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
}

async function toggleListed(vehicleIndex) {
    const vehicle = standInfo.vehicles[vehicleIndex];
    vehicleToToggleListed = vehicle.vehicle_id;
    vehicleToToggleListedIndex = vehicleIndex;
    var vehicleListedStatus = "";

    let stockData = vehicle.stock;
    if (typeof stockData === 'string') {
        try {
            stockData = JSON.parse(stockData);
        } catch (e) {
            stockData = {};
        }
    }
    
    if (!stockData || typeof stockData !== 'object') {stockData = {}}
    
    const currentStandStock = stockData[standInfo.id] || {amount: 0, price: 0, listed: true};
    
    if (currentStandStock.amount > 0) {vehicle.status = "in-stock"} else {vehicle.status = "out-of-stock"}

    vehicleListedStatus = currentStandStock.listed;

    if (vehicleListedStatus) {
        $("#toggle_listed_text").html(locales.translations.areyousuretoggleunlisted + " " + vehicle.vehicle_name + "?");
    } else {
        $("#toggle_listed_text").html(locales.translations.areyousuretogglelisted + " " + vehicle.vehicle_name + "?");
    }

    var modal = document.getElementById('toggleListedModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
}

$(document).on('click', '#closeToggleListedModal, #closeToggleListedButton', function() {
    var modal = $('#toggleListedModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 300);
});

$(document).on('click', '#toggleListed_btn_modal', async function() {
    let result = await retrieveNUI('toggleListed', { standId: standInfo.id, vehicleId: vehicleToToggleListed })
    if (result != false) {
        standInfo = result;
        updateSingleCard(vehicleToToggleListedIndex);
    }
    var modal = $('#toggleListedModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 300);
});

function updateSingleCard(vehicleIndex) {
    const vehicle = standInfo.vehicles[vehicleIndex];
    
    let stockData = vehicle.stock;
    if (typeof stockData === 'string') {
        try {
            stockData = JSON.parse(stockData);
        } catch (e) {
            stockData = {};
        }
    }
    
    if (!stockData || typeof stockData !== 'object') {stockData = {}}
    
    const currentStandStock = stockData[standInfo.id] || {amount: 0, price: 0, listed: true};
    
    if (currentStandStock.amount > 0) {vehicle.status = "in-stock"} else {vehicle.status = "out-of-stock"}

    if (typeof currentStandStock.listed !== 'boolean') {currentStandStock.listed = true}
    
    let displayPrice;
    if (currentStandStock.price == 0 || !currentStandStock.price) {
        displayPrice = setLocaleString(vehicle.max_price);
    } else {
        displayPrice = setLocaleString(currentStandStock.price);
    }
    
    const cardElement = document.querySelector(`[data-vehicle-index="${vehicleIndex}"]`);
    if (cardElement) {
        cardElement.querySelector('.vehicle-status').textContent = `${currentStandStock.amount} ${locales.translations.onstock}`;
        cardElement.querySelector('.vehicle-status').className = `vehicle-status ${vehicle.status}`;
        cardElement.querySelector('.catalog-card-price').textContent = displayPrice;
        cardElement.querySelector('.buy-btn').textContent = currentStandStock.listed ? locales.translations.listed : locales.translations.unlisted;
        cardElement.querySelector('.buy-btn').className = `buy-btn ${currentStandStock.listed ? "green" : "red"}`;
    }
}

function changePrice(vehicleIndex) {
    const vehicle = standInfo.vehicles[vehicleIndex];
    vehicleToChangePrice = vehicle.vehicle_id;
    vehicleToChangePriceIndex = vehicleIndex;
    
    let stockData = vehicle.stock;
    if (typeof stockData === 'string') {
        try {
            stockData = JSON.parse(stockData);
        } catch (e) {
            stockData = {};
        }
    }
    
    if (!stockData || typeof stockData !== 'object') {stockData = {}}
    
    const currentStandStock = stockData[standInfo.id] || {amount: 0, price: vehicle.max_price, listed: false, discount: 0};

    vehicleToChangePricePrice = currentStandStock.price;
    vehicleToChangePriceDiscount = currentStandStock.discount || 0;
    
    var modal = document.getElementById('changePriceModal');
    $("#change_discount_input").val(currentStandStock.discount);
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
        
        let currentPrice = currentStandStock.price || vehicle.max_price;
        let oldPrice = setLocaleString(currentPrice);
        oldPrice = oldPrice.replace(currency, "");
        $("#old_price").val(oldPrice);
        
        let minPrice = setLocaleString(vehicle.min_price);
        minPrice = minPrice.replace(currency, "");
        $("#min_price").val(minPrice);
        
        let maxPrice = setLocaleString(vehicle.max_price);
        maxPrice = maxPrice.replace(currency, "");
        $("#max_price").val(maxPrice);
    }, 50);
}

// Events

$(document).on('click', '#sell-business', function() {
    selectedWindow = "sellBusinessModal";
    $("#sell_business_title").html(locales.translations.areyousure);
    $("#closeSellBusinessButton").html(locales.translations.cancel);
    $("#sellbusiness_btn_modal").html(locales.translations.sell);
    $("#sell_business_text").html(locales.translations.doyouwanttosell + " " + standInfo.label + " " + locales.translations.forprice + " " + setLocaleString(sellStandPrice) + "?");
    setupUI();
    var modal = document.getElementById('sellBusinessModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
});

$(document).on('click', '#closeBuyBusinessModal, #closeBuyBusinessButton', function() {
    closeMenu();
});

$(document).on('click', '#closeSellBusinessModal, #closeSellBusinessButton', function() {
    var modal = $('#sellBusinessModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 300);
});

$(document).on('click', '#buybusiness_btn_modal', function() {
    retrieveNUI('buyStand', { standId: standInfo.id })
    closeMenu();
});

$(document).on('click', '#sellbusiness_btn_modal', function() {
    var modal = $('#sellBusinessModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 300);
    closeMenu();
    retrieveNUI('sellStand', { standId: standInfo.id })
});

$(document).on('click', '#deposit-money', function() {
    var modal = document.getElementById('depositModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
});

$("#deposit_btn").click( async function() {
    var amount = $("#deposit_money").val();
    var result = await retrieveNUI('depositMoney', { standId: standInfo.id, amount: amount })
    if (result != false) {
        standInfo = result;
        $("#stand-balance").html(setLocaleString(standInfo.money));
    }
    var modal = $('#depositModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
        $("#deposit_money").val('');
        $("#deposit_btn").prop('disabled', true);
    }, 500);
});

$(document).on('click', '#withdraw-money', function() {
    var modal = document.getElementById('withdrawModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
});

$("#withdraw_btn").click( async function() {
    var amount = $("#withdraw_money").val();
    var result = await retrieveNUI('withdrawMoney', { standId: standInfo.id, amount: amount })
    if (result != false) {
        standInfo = result;
        $("#stand-balance").html(setLocaleString(standInfo.money));
    }
    var modal = $('#withdrawModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
        $("#withdraw_money").val('');
        $("#withdraw_btn").prop('disabled', true);
    }, 500);
});

$("#closeDepositModal").click(function() {
    var modal = $('#depositModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$("#closeChangePriceModal").click(function() {
    var modal = $('#changePriceModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$("#closeBuyVehicleCustomerModal").click(function() {
    var modal = $('#buyVehicleCustomerModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$("#closeWithdrawModal").click(function() {
    var modal = $('#withdrawModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$("#closeWeeklyGoalModal").click(function() {
    var modal = $('#weeklyGoalModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$("#closeCustomerOrderModal").click(function() {
    var modal = $('#customerOrderModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$("#closeMyOrdersModal").click(function() {
    var modal = $('#myOrdersModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$("#closeHireEmployeeModal").click(function() {
    var modal = $('#hireEmployeeModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$("#closeEditEmployeeModal").click(function() {
    var modal = $('#editEmployeeModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
    currentEditingEmployee = null;
});

$("#closeFireEmployeeModal").click(function() {
    var modal = $('#fireEmployeeModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$("#closeBuyVehicleModal").click(function() {
    var modal = $('#buyVehicleModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$("#closeEditDealershipModal").click(function() {
    var modal = $('#editDealershipModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
    standMoney = 0;
});

$("#close-dealership-modal-btn").click(function() {
    var modal = $('#editDealershipModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
    standMoney = 0;
});

$("#closeEditVehicleModal").click(function() {
    var modal = $('#editVehicleModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$("#cancel-edit-vehicle-btn").click(function() {
    var modal = $('#editVehicleModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$("#dealership_money").on('input', function() {
    const currentMoney = parseInt($(this).val()) || 0;
    if ($(this).val() == "" || currentMoney == standMoney) {
        $("#confirm-dealership-modal-btn").prop('disabled', true);
    } else {
        $("#confirm-dealership-modal-btn").prop('disabled', false);
    }
});

// Event listeners para os campos do veículo
$("#vehicle_min_price, #vehicle_max_price, #vehicle_category, #vehicle_type").on('input change', function() {
    if (!selectedVehicle) return;
    
    const minPriceChanged = $("#vehicle_min_price").val() != "" && $("#vehicle_min_price").val() != selectedVehicle.min_price;
    const maxPriceChanged = $("#vehicle_max_price").val() != "" && $("#vehicle_max_price").val() != selectedVehicle.max_price;
    const categoryChanged = $("#vehicle_category").val() != "" && $("#vehicle_category").val() != selectedVehicle.category;
    const typeChanged = $("#vehicle_type").val() != "" && $("#vehicle_type").val() != selectedVehicle.type;

    if (minPriceChanged || maxPriceChanged || categoryChanged || typeChanged) {
        $("#confirm-edit-vehicle-btn").prop('disabled', false);
    } else {
        $("#confirm-edit-vehicle-btn").prop('disabled', true);
    }
});

$("#order_vehicle_btn").click(async function() {
    var modal = $('#customerOrderModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500); 
    $('#my-orders-button').addClass('order-available-button');
    $('#my-orders-button').prop('disabled', false);
    $('#my-orders-button').css('cursor', 'pointer');
    $('#my-orders-button').css('opacity', '1');
    var result = await retrieveNUI('orderVehicleCustomer', { standId: standInfo.id, vehicleInfo: vehicleSelected, isStandVip: isStandVip, personalPurchase: personalPurchase })
    if (result != false) {standInfo = result}
});

$(document).on('click', '#my-orders-button', function() {
    var modal = document.getElementById('myOrdersModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
    setupMyOrders();
});

$(document).on('click', '#confirmHireEmployee', async function() {
    var playerIdentifier = $("#dropdown_to_hire").val();
    var result = await retrieveNUI('hireEmployee', { standId: standInfo.id, employeeId: playerIdentifier })
    if (result != false) {standInfo = result}
    var modal = $('#hireEmployeeModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
    setupEmployeesList();
});

$(document).on('click', '#personal', function() {
    $('#personal').addClass('btn-active');
    $('#society').removeClass('btn-active');
    $('#society').addClass('btn-inactive');
    if (financedVehiclesEnabled) {
        $('#finance_vehicle_btn').prop('disabled', false).css('cursor', 'pointer').css('opacity', '1');
    }
    personalPurchase = true;
    updateTradeinOptions();
    updateTradeinPriceDisplay();
});

$(document).on('click', '#personal_order', function() {
    $('#personal_order').addClass('btn-active');
    $('#society_order').removeClass('btn-active');
    $('#society_order').addClass('btn-inactive');
    personalPurchase = true;
});

$(document).on('click', '#society', function() {
    $('#society').addClass('btn-active');
    $('#personal').removeClass('btn-active');
    $('#personal').addClass('btn-inactive');
    if (financedVehiclesEnabled) {
        $('#finance_vehicle_btn').prop('disabled', true).css('cursor', 'not-allowed').css('opacity', '0.5');
    }
    personalPurchase = false;
    updateTradeinOptions();
    updateTradeinPriceDisplay();
});

$(document).on('click', '#society_order', function() {
    $('#society_order').addClass('btn-active');
    $('#personal_order').removeClass('btn-active');
    $('#personal_order').addClass('btn-inactive');
    personalPurchase = false;
});

$(document).on('click', '#standard', function() {
    restartCustomPlate();
});

$(document).on('click', '#custom', function() {
    $('#custom').addClass('btn-active');
    $('#standard').removeClass('btn-active');
    $('#standard').addClass('btn-inactive');
    $(".vehicle_plate").css('display', 'flex');
    if ($("#vehicle_plate").val() != "") {$(".vehicle_platefee_div").css('display', 'flex');};
});

$(document).on('click', '#finance_vehicle_btn', function() {

    var modal = $('#buyVehicleCustomerModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
    
    setTimeout(function () {
        var vehiclePrice = parseFloat(vehicleSelected.price);
        if (vehicleSelected.discount > 0) {
            vehiclePrice = Math.floor(vehiclePrice * (1 - vehicleSelected.discount / 100));
        }
        var interestToPay = vehiclePrice * financeVehiclesSettings.interest_rate;
        var totalPrice = vehiclePrice + interestToPay;
        var monthlyPayment = Math.round(totalPrice / financeVehiclesSettings.payments);
        $("#vehicle_finance_name").val(vehicleSelected.vehicle_name);
        $("#vehicle_finance_price").val(vehiclePrice);
        $("#vehicle_finance_interest_rate").val(financeVehiclesSettings.interest_rate * 100 + "%");
        $("#vehicle_finance_period").val(financeVehiclesSettings.payments + " " + locales.translations.months);
        $("#vehicle_finance_monthly_payment").val(monthlyPayment);
        $("#vehicle_finance_total_price").val(Math.floor(totalPrice));

        var modal = document.getElementById('financeVehicleModal');
        modal.style.display = 'flex';
        setTimeout(function () {
            modal.classList.add('show');
        }, 50);

        financeVehicle = true;
    }, 200);
});

$("#finance_vehicle_btn_final").click(function() {
    retrieveNUI('financeVehicle', { vehicleInfo: vehicleSelected, isStandVip: isStandVip, personalPurchase: personalPurchase })
    var modal = $('#financeVehicleModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$("#closeMyFinancedVehiclesModal").click(function() {
    var modal = $('#myFinancedVehiclesModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
        triggerModalCloseEvent('myFinancedVehiclesModal');
    }, 500);
    closeMenu();
});

$("#cancel_finance_vehicle_btn").click(function() {
    var modal = $('#financeVehicleModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$(document).on('click', '#buy_vehicle_btn_final', async function() {

    $('#buy_vehicle_btn_final').prop('disabled', true);
    // Create a copy of vehicleSelected with the final calculated price
    let vehicleForPurchase = { ...vehicleSelected };
    if (vehicleSelected.finalPrice !== undefined) {
        vehicleForPurchase.price = vehicleSelected.finalPrice;
    }
    
    // Ensure trade-in plate is included
    if (vehicleSelected.tradeinPlate) {
        vehicleForPurchase.tradeinPlate = vehicleSelected.tradeinPlate;
    }
    
    // Get custom plate value and validate length
    const customPlateValue = $("#vehicle_plate").val();
    if (customPlateValue && customPlateValue.trim() !== "") {
        // Limit to 8 characters maximum
        const trimmedPlate = customPlateValue.substring(0, 8);
        vehicleForPurchase.customPlate = trimmedPlate;
    }
    
    // Call client callback to confirm purchase
    const canPurchase = await retrieveNUI('isPlateAvailable', { plate: vehicleForPurchase.customPlate });

    if (canPurchase === true) {
        const result = await retrieveNUI('buyVehicleCustomer', { vehicleInfo: vehicleForPurchase, isStandVip: isStandVip, personalPurchase: personalPurchase, standInfo: standInfo })
        if (result === 'error') {
            var modal = $('#buyVehicleCustomerModal');
            modal.removeClass('show');
            setTimeout(function () {
                modal.css('display', 'none');
            }, 500);
            $('#buy_vehicle_btn_final').prop('disabled', false);
            return}
        $('#buy_vehicle_btn_final').prop('disabled', false);
        buyingVehicle = true;
    }
});

function setupMyOrders() {
    $('#my-orders-container').html('');

    $('#my-orders-container').html(`
        <div class="page-info padding-0">
                <table id="myOrdersTable" style="margin-bottom: -0.625rem;">
                    <thead>
                        <tr>
                            <th class="text-center">${locales.translations.vehicle}</th>
                            <th class="text-center">${locales.translations.price}</th>
                            <th class="text-center">${locales.translations.status}</th>
                            <th class="text-center">${locales.translations.action}</th>
                        </tr>
                    </thead>
                    <tbody id="myOrdersTableData"></tbody>
                </table>
                </div>
            </div>
        </div>
        `);

    $('#myOrdersTableData').html(``)

    if (!standInfo.orders) return;
    if (standInfo.orders) {
        if (standInfo.orders.length > 6) {
            $('#myOrdersTable').css('margin-bottom', '2.465rem');
        } else {
            $('#myOrdersTable').css('margin-bottom', '-0.625rem');
        }
    }

    let row = ``;
    for (let i = 0; i < standInfo.orders.length; i++) {
        if (standInfo.orders[i].customer_id == playerIdentifier) {
            const sale = standInfo.orders[i];
            if (standInfo.orders[i].status == 'ready') {
                row += `
                    <tr>
                        <td class="text-center align-middle">${sale.vehicle_name}</td>
                        <td class="text-center align-middle">${isStandVip ? setLocaleStringVip(sale.price) : setLocaleString(sale.price)}</td>
                        <td class="text-center align-middle">${locales.translations.ready}</td>
                        <td class="text-center align-middle"><button onclick="claimOrderCustomer(${i})" type="button" class="btn btn-blue btn-edit btn-green"><i class="fas fa-check"></i> ${locales.translations.claim}</button></td>
                    </tr>
                `;
            } else if (standInfo.orders[i].status == 'pending') {
                row += `
                    <tr>
                        <td class="text-center align-middle">${sale.vehicle_name}</td>
                        <td class="text-center align-middle">${isStandVip ? setLocaleStringVip(sale.price) : setLocaleString(sale.price)}</td>
                        <td class="text-center align-middle">${locales.translations.pending}</td>
                        <td class="text-center align-middle"><button onclick="cancelOrderCustomer(${i})" type="button" class="btn btn-blue btn-edit btn-red"><i class="fas fa-xmark"></i> ${locales.translations.cancel}</button></td>
                    </tr>
                `;
            } else if (standInfo.orders[i].status == 'progress') {
                row += `
                <tr>
                    <td class="text-center align-middle">${sale.vehicle_name}</td>
                    <td class="text-center align-middle">${isStandVip ? setLocaleStringVip(sale.price) : setLocaleString(sale.price)}</td>
                    <td class="text-center align-middle">${locales.translations.inprogress}</td>
                    <td class="text-center align-middle disabled-button"><button type="button" class="btn btn-blue btn-edit opacity-50" disabled><i class="fas fa-spinner"></i> ${locales.translations.inprogress}</button></td>
                </tr>
            `;
            }
        }
    }
    $('#myOrdersTableData').append(row);

    var table_id = document.getElementById('myOrdersTable');
    table.push(new simpleDatatables.DataTable(table_id, {
        perPageSelect: false,
        searchable: false,
        perPage: 6,
        labels: {
            placeholder: locales.translations.search,
            perPage: locales.translations.entriesperpage,
            noRows: locales.translations.novehiclesfound,
            noResults: locales.translations.noresultsfound
        }
    }));
}

$("#set-goal-btn").click(async function() {
    if (weeklyGoal == 0) {weeklyGoal = $("#custom-goal-input").val()}
    if (weeklyGoal) {
        var result = await retrieveNUI('setWeeklyGoal', {  standId: standInfo.id, amount: weeklyGoal});
        if (result != false) {
            standInfo = result;
            setWeeklyGoalProgress(standInfo.weekly_profit_goal_percentage, standInfo.weekly_profit_goal);
        }
        var modal = $('#weeklyGoalModal');
        modal.removeClass('show');
        setTimeout(function () {
            modal.css('display', 'none');
            $("#set-goal-btn").prop('disabled', true);
            $("#custom-goal-input").val('');
            $(".goal-btn").removeClass('active');
            weeklyGoal = 0;
        }, 500);
    }
});

$("#change_price_btn").click(async function() {
    let newPrice = $("#change_price_input").val();
    let newDiscount = $("#change_discount_input").val();
    
    // Se o preço não foi alterado, usa o preço atual
    if (newPrice == "" || newPrice == null) {
        newPrice = vehicleToChangePricePrice;
    } else {
        newPrice = newPrice.replace(currency, "");
    }
    
    // Se o desconto estiver vazio, define como 0
    if (newDiscount == "" || newDiscount == null) {
        newDiscount = 0;
    }
    
    let result = await retrieveNUI('changePrice', { standId: standInfo.id, oldPrice: vehicleToChangePricePrice, vehicleId: vehicleToChangePrice, newPrice: newPrice, newDiscount: newDiscount })
    if (result != false) {
        standInfo = result;
        updateSingleCard(vehicleToChangePriceIndex);
    }
    var modal = $('#changePriceModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
        $("#change_price_input").val('');
        $("#change_discount_input").val('');
        $("#change_price_btn").prop('disabled', true);
    }, 500);
});

$("#buy_vehicle_btn").click(async function() {
    let amount = $("#buy_vehicle_price").val();
    let result = await retrieveNUI('buyVehicle', { standId: standInfo.id, vehicleId: vehicleToPurchase, amount: amount })
    if (result != 'error') {
        standInfo = result.standInfo;
        if (!result.isMissionForStock) {
            const vehicleIndex = standInfo.vehicles.findIndex(v => v.vehicle_id === vehicleToPurchase);
            if (vehicleIndex !== -1) {
                updateSingleCard(vehicleIndex);
            }
        }
    }
    var modal = $('#buyVehicleModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
        $("#buy_vehicle_price").val('');
        $("#buy_vehicle_btn").prop('disabled', true);
    }, 500);
});

$("#edit_employee_btn").click(async function() {
    var newRankIndex = $("#employee_grades").val();
    var newRank = parseInt(newRankIndex) + 1;
    var result = await retrieveNUI('editEmployee', { standId: standInfo.id, employeeId: currentEditingEmployee.identifier, newRank: newRank })
    if (result != false) {
        standInfo = result;
        setupEmployeesList();
    }
    var modal = $('#editEmployeeModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
    currentEditingEmployee = null;
});

$("#logout").click(function() {
    closeMenu();
});

$(document).on('click', '#manage-goal', function() {
    var modal = document.getElementById('weeklyGoalModal');
    modal.style.display = 'flex';
    setTimeout(function () {
        modal.classList.add('show');
    }, 50);
});

$(document).on('click', '#fire_employee_title_btn', function() {
    var modal = $('#editEmployeeModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
    setTimeout(function () {
        var modal = document.getElementById('fireEmployeeModal');
        modal.style.display = 'flex';
        setTimeout(function () {
            modal.classList.add('show');
        }, 50);
        if (currentEditingEmployee.identifier == playerIdentifier) {
            $("#fire_employee_text").html(locales.translations.doyouwanttofireyourself + "?");
        } else {
            $("#fire_employee_text").html(locales.translations.doyouwanttofire + " " + currentEditingEmployee.name + "?");
        }
        $("#fire_employee_btn_final").off('click').on('click', async function() {
            var result = await retrieveNUI('fireEmployee', { standId: standInfo.id, employeeId: currentEditingEmployee.identifier })
            if (result != false) {
                standInfo = result;
                setupEmployeesList();
            }
            var modal = $('#fireEmployeeModal');
            modal.removeClass('show');
            setTimeout(function () {
                modal.css('display', 'none');
            }, 500);
            currentEditingEmployee = null;
        });
    }, 300);
});

$("#cancel_fire_employee_btn").click(function() {
    var modal = $('#fireEmployeeModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 500);
});

$(document).on('click', '#logout-btn', function() {
    closeMenu();
});

$(document).on('click', '#overview-btn', function() {
    $('#stock, #salesHistory, #employees, #orders, #customerorders, #logs, #vehiclesShowcase').hide();
    setupDashboard();
    $('#dashboard').show();
});

$(document).on('click', '#stock-btn', function() {
    $('#dashboard, #salesHistory, #employees, #orders, #customerorders, #logs, #vehiclesShowcase').hide();
    setupStock();
});

$(document).on('click', '#saleshistory-btn', function() {
    $('#dashboard, #stock, #employees, #orders, #customerorders, #logs, #vehiclesShowcase').hide();
    setupSalesHistory();
});

$(document).on('click', '#employees-btn', function() {
    $('#dashboard, #stock, #salesHistory, #orders, #customerorders, #logs, #vehiclesShowcase').hide();
    setupEmployees();
});

$(document).on('click', '#orders-btn', function() {
    $('#dashboard, #stock, #salesHistory, #employees, #customerorders, #logs, #vehiclesShowcase').hide();
    setupOrders();
});

$(document).on('click', '#customerorders-btn', function() {
    $('#dashboard, #stock, #salesHistory, #employees, #orders, #logs, #vehiclesShowcase').hide();
    setupCustomerOrders();
});

$(document).on('click', '#logs-btn', function() {
    $('#dashboard, #stock, #salesHistory, #employees, #orders, #customerorders, #vehiclesShowcase').hide();
    setupLogs();
});

$(document).on('click', '#closeFinanceVehicleModal', function() {
    var modal = $('#financeVehicleModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 300);
});

$(document).on('click', '#closeFinanceVehicleInfoModal', function() {
    var modal = $('#financedVehicleInfoModal');
    modal.removeClass('show');
    setTimeout(function () {
        modal.css('display', 'none');
    }, 300);
    retrieveNUI('closeNuiFocus', {})
});

// Document Events

document.addEventListener('click', function(event) {
    if (event.target.closest('.modal') && !event.target.closest('.modal-content')) {
        const modal = $(event.target.closest('.modal'));
        const modalId = modal.attr('id');
        modal.removeClass('show');
        setTimeout(function () {
            modal.css('display', 'none');
            if (modalId) {
                triggerModalCloseEvent(modalId);
            }
        }, 300);
    }
});

$(document).ready(function() {
	document.onkeyup = function(data) {
		if (data.which == 27) {
            const openModals = $('.modal.show');
            const modalIds = [];
            openModals.each(function() {
                const modalId = $(this).attr('id');
                if (modalId) {
                    modalIds.push(modalId);
                }
            });
            $('.modal.show').removeClass('show');
            setTimeout(function () {
                $('.modal').css('display', 'none');
                modalIds.forEach(function(modalId) {
                    triggerModalCloseEvent(modalId);
                });
            }, 300);
            if (!menuClosed) {
                closeMenu();
                menuClosed = true;
            }
		}
	};
});

function createPaymentProgressBar(totalPayments, completedPayments) {
    const progressBar = document.getElementById('payment-progress-bar');
    if (!progressBar) return;
    
    const previousCompleted = parseInt(progressBar.getAttribute('data-completed') || 0);
    const hasNewCompletion = completedPayments > previousCompleted;
    
    if (!progressBar.hasAttribute('data-payments') || !hasNewCompletion) {
        progressBar.innerHTML = '';
        progressBar.setAttribute('data-payments', totalPayments);
        progressBar.setAttribute('data-completed', completedPayments);
        
        const baseLine = document.createElement('div');
        baseLine.className = 'payment-progress-line';
        progressBar.appendChild(baseLine);
        
        const completedLine = document.createElement('div');
        completedLine.className = 'payment-progress-line-completed';
        const completedPercentage = (completedPayments / totalPayments) * 100;
        completedLine.style.width = completedPercentage + '%';
        progressBar.appendChild(completedLine);
        
        for (let i = 0; i < totalPayments; i++) {
            const node = document.createElement('div');
            node.className = 'payment-progress-node';
            node.setAttribute('data-payment-index', i);
            
            if (i < completedPayments) {
                node.classList.add('completed');
                node.innerHTML = '<i class="fas fa-check"></i>';
            } else {
                node.classList.add('pending');
                node.innerHTML = '<i class="fas fa-spinner"></i>';
            }
            
            const paymentNumber = i + 1;
            const status = i < completedPayments ? 'Paid' : 'Pending';
            node.title = `Payment ${paymentNumber}: ${status}`;
            
            progressBar.appendChild(node);
        }
    } else {
        addSinglePayment(completedPayments);
    }
}

function addSinglePayment(completedPayments) {
    const progressBar = document.getElementById('payment-progress-bar');
    if (!progressBar) return;
    
    const totalPayments = parseInt(progressBar.getAttribute('data-payments'));
    const previousCompleted = parseInt(progressBar.getAttribute('data-completed') || 0);
    
    if (completedPayments <= previousCompleted) return;
    
    progressBar.setAttribute('data-completed', completedPayments);
    
    const completedLine = progressBar.querySelector('.payment-progress-line-completed');
    if (completedLine) {
        const completedPercentage = (completedPayments / totalPayments) * 100;
        completedLine.style.transition = 'width 0.8s ease-in-out';
        completedLine.style.width = completedPercentage + '%';
    }
    
    const targetNode = progressBar.querySelector(`[data-payment-index="${previousCompleted}"]`);
    if (targetNode) {
        targetNode.classList.remove('pending');
        targetNode.classList.add('completed');
        
        targetNode.style.transform = 'scale(0)';
        targetNode.style.opacity = '0';
        
        setTimeout(() => {
            targetNode.innerHTML = '<i class="fas fa-check"></i>';
            targetNode.style.transition = 'all 0.5s ease-out';
            targetNode.style.transform = 'scale(1.2)';
            targetNode.style.opacity = '1';
            
            setTimeout(() => {
                targetNode.style.transform = 'scale(1)';
            }, 200);
        }, 100);
        
        const paymentNumber = previousCompleted + 1;
        targetNode.title = `Payment ${paymentNumber}: Paid`;
    }
}

function updateColorText() {
    const colorPicker = document.getElementById('vehicle_color_picker_showcase_add');
    const colorText = document.getElementById('vehicle_color_showcase_add');
    
    if (colorPicker && colorText) {
        const hex = colorPicker.value;
        const r = parseInt(hex.substr(1, 2), 16);
        const g = parseInt(hex.substr(3, 2), 16);
        const b = parseInt(hex.substr(5, 2), 16);
        
        colorText.value = `${r},${g},${b}`;
        checkIfEmpty();
    }
}

$(document).on('input', '#vehicle_color_showcase_add', function() {
    const colorPicker = document.getElementById('vehicle_color_picker_showcase_add');
    const colorText = this.value;
    
    if (colorText && colorPicker) {
        const temp = document.createElement('div');
        temp.style.color = colorText;
        document.body.appendChild(temp);
        const computedColor = window.getComputedStyle(temp).color;
        document.body.removeChild(temp);

        if (computedColor !== 'rgba(0, 0, 0, 0)' && computedColor !== 'rgb(0, 0, 0)') {
            const rgb = computedColor.match(/\d+/g);
            if (rgb && rgb.length >= 3) {
                const hex = '#' + rgb.map(x => {
                    const hex = parseInt(x).toString(16);
                    return hex.length === 1 ? '0' + hex : hex;
                }).join('');
                colorPicker.value = hex;
            }
        }
    }
});

function checkAllVehiclesListedStatus() {
    if (!standInfo || !standInfo.vehicles) {
        allVehiclesListed = false;
        return false;
    }

    let allListed = true;
    let checkedVehicles = 0;
    let listedVehicles = 0;
    
    for (let i = 0; i < standInfo.vehicles.length; i++) {
        const vehicle = standInfo.vehicles[i];
        
        if (vehicle.type != standInfo.type) {
            continue;
        }

        checkedVehicles++;
        let stockData = vehicle.stock;
        if (typeof stockData === 'string') {
            try {
                stockData = JSON.parse(stockData);
            } catch (e) {
                stockData = {};
            }
        }
        
        if (!stockData || typeof stockData !== 'object') {
            stockData = {};
        }

        const currentStandStock = stockData[standInfo.id] || {amount: 0, price: 0, listed: false};
        
        if (!currentStandStock.listed) {
            allListed = false;
        } else {
            listedVehicles++;
        }
    }
    
    allVehiclesListed = allListed;
    return allListed;
}

$(document).on('modalClosed', function(event, data) {
    if (!data) return;
    if (data.modalId === 'myFinancedVehiclesModal' || data.modalId === 'financedVehicleInfoModal') {
        retrieveNUI('closeNuiFocus', {})
    }
});