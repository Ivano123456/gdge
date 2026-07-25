Locales['en'] = {

    -- TextUI

    ['buy_business'] = {
        text = '[E] Buy ${road} ${name} for ${price}' .. Config.Currency,
        color = 'darkblue',
        side = 'right'
    },

    ['access_business'] = {
        text = '[E] Open ${name}',
        color = 'darkblue',
        side = 'right'
    },

    ['get_fuel'] = {
        text = '[E] Get fuel',
        color = 'darkblue',
        side = 'right'
    },

    ['get_trailer'] = {
        text = 'Attach trailer',
        color = 'darkblue',
        side = 'right'
    },

    ['finish_mission'] = {
        text = '[E] Finish mission',
        color = 'darkblue',
        side = 'right'
    },

    ['refuel_vehicle'] = {
        text = '[E] Refuel vehicle',
        color = 'darkblue',
        side = 'right'
    },

    ['refuel_with_jerrycan'] = {
        text = '[E] Refuel with Jerrycan',
        color = 'darkblue',
        side = 'right'
    },

    ['stop_refueling_jerrycan'] = {
        text = '[E] Stop Refueling',
        color = 'darkblue',
        side = 'right'
    },

    ['put_nozzle'] = {
        text = '[E] Put nozzle in vehicle'
    },

    ['take_nozzle'] = {
        text = '[E] Take nozzle from vehicle'
    },

    ['nozzle_in_pump'] = {
        text = '[E] Put nozzle in pump'
    },
    
    ['refuel_jerrycan'] = {
        text = '[E] Refuel Jerrycan'
    },

    ['refueling_vehicle'] = {
        text = 'Refueling Vehicle...'
    },

    -- Requests

    ['hired_requests'] = {
        text = 'Do you want to be hired by',
    },

    -- Error Notifications

    ['not_enough_money'] = {
        title = 'Gas Station',
        text = 'You don\'t have enough money',
        type = 'error',
        time = 5000,
    },

    ['not_enough_money_business'] = {
        title = 'Gas Station',
        text = 'You don\'t have enough money on the business',
        type = 'error',
        time = 5000,
    },

    ['max_stores'] = {
        title = 'Gas Station',
        text = 'You have reached the maximum of stores owned',
        type = 'error',
        time = 5000,
    },

    ['something_wrong'] = {
        title = 'Gas Station',
        text = 'Something went wrong, try again later',
        type = 'error',
        time = 5000,
    },

    ['gas_price_high'] = {
        title = 'Gas Station',
        text = 'You can\'t change the gas price to ${price}' .. Config.Currency .. ' because the max is ${max}' .. Config.Currency,
        type = 'error',
        time = 5000,
    },

    ['price_negative'] = {
        title = 'Gas Station',
        text = 'You can\'t use negative numbers',
        type = 'error',
        time = 5000,
    },

    ['use_numbers_only'] = {
        title = 'Gas Station',
        text = 'The gas price has to be filled',
        type = 'error',
        time = 5000,
    },

    ['already_employee'] = {
        title = 'Gas Station',
        text = '${name} is already employed at your gas station',
        type = 'error',
        time = 5000,
    },

    ['max_employees'] = {
        title = 'Gas Station',
        text = 'You can\'t hire ${name} because you reached the max of ${max} employees at the gas station',
        type = 'error',
        time = 5000,
    },

    ['cant_hire_yourself'] = {
        title = 'Gas Station',
        text = 'You can\'t hire yourself',
        type = 'error',
        time = 5000,
    },

    ['change_own_grade'] = {
        title = 'Gas Station',
        text = 'You can\'t change your own grade',
        type = 'error',
        time = 5000,
    },

    ['near_error'] = {
        title = 'Gas Station',
        text = 'No one nearby',
        type = 'error',
        time = 5000,
    },

    ['max_stock'] = {
        title = 'Gas Station',
        text = 'You can\'t make that update because the max stock is ${maxStock}L',
        type = 'error',
        time = 5000,
    },

    ['employee_not_exist'] = {
        title = 'Gas Station',
        text = 'That employee doesn\'t exist',
        type = 'error',
        time = 5000,
    },

    ['got_fired'] = {
        title = 'Gas Station',
        text = 'You got fired from ${store_name}',
        type = 'error',
        time = 5000,
    },

    ['fired_himself'] = {
        title = 'Gas Station',
        text = '${playerName} fired himself',
        type = 'error',
        time = 5000,
    },

    ['no_vehicle'] = {
        title = 'Gas Station',
        text = 'You can\'t make that order because you don\'t have the vehicle ${vehicle}',
        type = 'error',
        time = 5000,
    },

    ['only_one_order'] = {
        title = 'Gas Station',
        text = 'You can\'t accept a order while you have one active',
        type = 'error',
        time = 5000,
    },

    ['order_canceled'] = {
        title = 'Gas Station',
        text = 'You canceled the order',
        type = 'error',
        time = 5000,
    },

    ['order_canceled_no_trailer'] = {
        title = 'Gas Station',
        text = 'The order was canceled because you don\'t have the right trailer attached or you don\'t have a trailer',
        type = 'error',
        time = 5000,
    },

    ['cant_accept_order'] = {
        title = 'Gas Station',
        text = 'You can\'t accept that order because the liters on the mission exceed the maximum stock',
        type = 'error',
        time = 5000,
    },

    ['max_fuel_already'] = {
        title = 'Gas Station',
        text = 'Your vehicle has already full tank',
        type = 'error',
        time = 5000,
    },

    ['cant_refuel_that_much'] = {
        title = 'Gas Station',
        text = 'You can only refuel ${fuelMax}L',
        type = 'error',
        time = 5000,
    },

    ['no_stock'] = {
        title = 'Gas Station',
        text = 'The gas station doesn\'t have any fuel',
        type = 'error',
        time = 5000,
    },

    ['no_stock_input'] = {
        title = 'Gas Station',
        text = 'Your vehicle can only carry ${fuelToVehicle}L',
        type = 'error',
        time = 5000,
    },

    ['no_stock_input_jerrycan'] = {
        title = 'Gas Station',
        text = 'Your jerrycan can only carry ${fuelToVehicle}L',
        type = 'error',
        time = 5000,
    },

    ['already_refueling'] = {
        title = 'Gas Station',
        text = 'You are already refueling',
        type = 'error',
        time = 5000,
    },

    ['more_than_max_stock'] = {
        title = 'Gas Station',
        text = 'You can\'t order ${liters}L because the max stock of your gas station is ${maxStock}L',
        type = 'error',
        time = 5000,
    },

    ['wrong_trailer'] = {
        title = 'Gas Station',
        text = 'You attached the wrong trailer',
        type = 'error',
        time = 5000,
    },

    ['no_vehicle_nearby'] = {
        title = 'Gas Station',
        text = 'There is no vehicle nearby',
        type = 'error',
        time = 5000,
    },

    ['cant_refuel'] = {
        title = 'Gas Station',
        text = 'You can\'t refuel that vehicle',
        type = 'error',
        time = 5000,
    },

    ['on_a_vehicle'] = {
        title = 'Gas Station',
        text = 'You can\'t refuel inside a vehicle',
        type = 'error',
        time = 5000,
    },
    
    ['cant_refuel_0'] = {
        title = 'Gas Station',
        text = 'You can\'t refuel 0 liters',
        type = 'error',
        time = 5000,
    },

    ['no_fuel_jerrycan'] = {
        title = 'Gas Station',
        text = 'You don\'t have enough fuel on the jerrycan',
        type = 'error',
        time = 5000,
    },

    ['jerrycan_full'] = {
        title = 'Gas Station',
        text = 'The jerrycan is full',
        type = 'error',
        time = 5000,
    },

    ['stop_refueling'] = {
        title = 'Gas Station',
        text = 'The refueling has been canceled because you entered the vehicle',
        type = 'error',
        time = 5000,
    },

    ['wrong_vehicle'] = {
        title = 'Gas Station',
        text = 'You are in the wrong vehicle',
        type = 'error',
        time = 5000,
    },
    
    -- Success Notifications

    ['bought_store'] = {
        title = 'Gas Station',
        text = 'You bought the ${name} for ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['money_deposited'] = {
        title = 'Gas Station',
        text = 'You deposited ${money}' .. Config.Currency .. ' into the business',
        type = 'success',
        time = 5000,
    },

    ['money_withdrawn'] = {
        title = 'Gas Station',
        text = 'You withdrawn ${money}' .. Config.Currency .. ' from the business',
        type = 'success',
        time = 5000,
    },

    ['sold_business'] = {
        title = 'Gas Station',
        text = 'You sold the business for ${money}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['gas_price_changed'] = {
        title = 'Gas Station',
        text = 'You changed the gas price to ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['vehicle_bought'] = {
        title = 'Gas Station',
        text = 'You bought ${vehicle} for ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['updated_stock'] = {
        title = 'Gas Station',
        text = 'You updated the max stock from ${maxStock}L to ${maxStockUpdated}L for ${price} ' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['got_hired'] = {
        title = 'Gas Station',
        text = 'You were hired for the ${store_name}',
        type = 'success',
        time = 5000,
    },

    ['success_hired'] = {
        title = 'Gas Station',
        text = 'You hired ${hired_name}',
        type = 'success',
        time = 5000,
    },

    ['success_fired'] = {
        title = 'Gas Station',
        text = 'You fired ${fired_name}',
        type = 'success',
        time = 5000,
    },

    ['fired_yourself'] = {
        title = 'Gas Station',
        text = 'You successfully fired yourself',
        type = 'success',
        time = 5000,
    },

    ['change_rank'] = {
        title = 'Gas Station',
        text = 'You changed the rank of ${name} to ${job}',
        type = 'success',
        time = 5000,
    },

    ['gas_fill'] = {
        title = 'Gas Station',
        text = 'You filled your car with ${liters}L for ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['ordered_success'] = {
        title = 'Gas Station',
        text = 'You placed an order of ${liters}L for ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['order_accepted'] = {
        title = 'Gas Station',
        text = 'You accepted the order',
        type = 'success',
        time = 5000,
    },

    ['vehicle_filled'] = {
        title = 'Gas Station',
        text = 'The vehicle is full, go back to the gas station',
        type = 'success',
        time = 5000,
    },

    ['trailer_attached'] = {
        title = 'Gas Station',
        text = 'The trailer was successfully attached, go back to the gas station',
        type = 'success',
        time = 5000,
    },

    ['order_completed'] = {
        title = 'Gas Station',
        text = 'You successfully finished the order and received ${reward}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['vehicle_refueled'] = {
        title = 'Gas Station',
        text = 'You refueled your vehicle with ${fuelToVehicle}L for ${priceToPay}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['jerrycan_refueled'] = {
        title = 'Gas Station',
        text = 'You refueled your jerrycan with ${fuelToVehicle}L for ${priceToPay}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['vehicle_refueled_jerrycan'] = {
        title = 'Gas Station',
        text = 'You refueled your vehicle with the jerrycan',
        type = 'success',
        time = 5000,
    },

    ['get_jerrycan_item'] = {
        title = 'Gas Station',
        text = 'You bought the jerry can for ${priceToPay}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    -- Info Notifications

    ['start_mission'] = {
        title = 'Gas Station',
        text = 'Go to the vehicle to start the mission',
        type = 'info',
        time = 5000,
    },

    ['mission_location'] = {
        title = 'Gas Station',
        text = 'Go to the location marked on your map',
        type = 'info',
        time = 5000,
    },

    ['vehicle_being_refueled'] = {
        title = 'Gas Station',
        text = 'Your vehicle is being refueled',
        type = 'info',
        time = 5000,
    },

    ['jerrycan_being_refueled'] = {
        title = 'Gas Station',
        text = 'Your jerrycan is being refueled',
        type = 'info',
        time = 5000,
    },
}