Locales['de'] = {

    -- TextUI

    ['buy_business'] = {
        text = '[E] Kaufe ${road} ${name} für ${price}' .. Config.Currency,
        color = 'darkblue',
        side = 'right'
    },

    ['access_business'] = {
        text = '[E] Öffne ${name}',
        color = 'darkblue',
        side = 'right'
    },

    ['get_fuel'] = {
        text = '[E] Hole Treibstoff',
        color = 'darkblue',
        side = 'right'
    },

    ['get_trailer'] = {
        text = 'Trailer anhängen',
        color = 'darkblue',
        side = 'right'
    },

    ['finish_mission'] = {
        text = '[E] Mission beenden',
        color = 'darkblue',
        side = 'right'
    },

    ['refuel_vehicle'] = {
        text = '[E] Tanken',
        color = 'darkblue',
        side = 'right'
    },

    ['refuel_with_jerrycan'] = {
        text = '[E] mit Benzinkanister Tanken',
        color = 'darkblue',
        side = 'right'
    },

    ['stop_refueling_jerrycan'] = {
        text = '[E] Aufhören mit Tanken',
        color = 'darkblue',
        side = 'right'
    },

    ['put_nozzle'] = {
        text = '[E] Stutzen ins Auto stecken'
    },

    ['take_nozzle'] = {
        text = '[E] Stutzen nehmen'
    },

    ['nozzle_in_pump'] = {
        text = '[E] Stutzen zurücklegen'
    },
    
    ['refuel_jerrycan'] = {
        text = '[E] Benzinkanister auffüllen'
    },

    ['refueling_vehicle'] = {
        text = 'Tanke Fahrzeug...'
    },

    -- Requests

    ['hired_requests'] = {
        text = 'Willst du angestellt werden von ',
    },

    -- Error Notifications

    ['not_enough_money'] = {
        title = 'Tankstelle',
        text = 'Du hast nicht genug Geld',
        type = 'error',
        time = 5000,
    },

    ['not_enough_money_business'] = {
        title = 'Tankstelle',
        text = 'Du hast nicht genug Geld in deiner Firma',
        type = 'error',
        time = 5000,
    },

    ['max_stores'] = {
        title = 'Tankstelle',
        text = 'Du hast bereits das Maximum an Läden erreicht',
        type = 'error',
        time = 5000,
    },

    ['something_wrong'] = {
        title = 'Tankstelle',
        text = 'Etwas ist schiefgelaufen, versuche es später nochmal',
        type = 'error',
        time = 5000,
    },

    ['gas_price_high'] = {
        title = 'Tankstelle',
        text = 'Du kannst den Preis nicht zu ${price} ändern' .. Config.Currency .. ' das Maximum ist ${max}' .. Config.Currency,
        type = 'error',
        time = 5000,
    },

    ['price_negative'] = {
        title = 'Tankstelle',
        text = 'Du kannst keine Negativ Zahl eingeben',
        type = 'error',
        time = 5000,
    },

    ['use_numbers_only'] = {
        title = 'Tankstelle',
        text = 'Der Tankpreis muss eingetragen werden',
        type = 'error',
        time = 5000,
    },

    ['already_employee'] = {
        title = 'Tankstelle',
        text = '${name} ist bereits bei dir Eingestellt',
        type = 'error',
        time = 5000,
    },

    ['max_employees'] = {
        title = 'Tankstelle',
        text = 'Du kannst ${name} nicht einstellen weil du bereits ${max} Mitarbeiter hast',
        type = 'error',
        time = 5000,
    },

    ['cant_hire_yourself'] = {
        title = 'Tankstelle',
        text = 'Du kannst dich nicht selbst einstellen',
        type = 'error',
        time = 5000,
    },

    ['change_own_grade'] = {
        title = 'Tankstelle',
        text = 'Du kannst deinen Eigenen Rang nicht einstellen',
        type = 'error',
        time = 5000,
    },

    ['near_error'] = {
        title = 'Tankstelle',
        text = 'keiner in der nähe',
        type = 'error',
        time = 5000,
    },

    ['max_stock'] = {
        title = 'Tankstelle',
        text = 'Du kannst das nicht Updaten weil du nur ${maxStock}L haben kannst',
        type = 'error',
        time = 5000,
    },

    ['employee_not_exist'] = {
        title = 'Tankstelle',
        text = 'Dieser Mitarbeiter Exestiert nicht',
        type = 'error',
        time = 5000,
    },

    ['got_fired'] = {
        title = 'Tankstelle',
        text = 'Du wurdest Gefeuert bei ${store_name}',
        type = 'error',
        time = 5000,
    },

    ['fired_himself'] = {
        title = 'Tankstelle',
        text = '${playerName} hat sich selbst entlassen',
        type = 'error',
        time = 5000,
    },

    ['no_vehicle'] = {
        title = 'Tankstelle',
        text = 'Für diesen Auftrag fehlt dir das ${vehicle} Fahrzeug',
        type = 'error',
        time = 5000,
    },

    ['only_one_order'] = {
        title = 'Tankstelle',
        text = 'Du hast bereits einen Aktiven Auftrag',
        type = 'error',
        time = 5000,
    },

    ['order_canceled'] = {
        title = 'Tankstelle',
        text = 'Du hast den Auftrag abgebrochen',
        type = 'error',
        time = 5000,
    },

    ['order_canceled_no_trailer'] = {
        title = 'Tankstelle',
        text = 'Der Auftrag wurde abgebrochen,weil du den Falschen Trailer/keinen Trailer besitzt',
        type = 'error',
        time = 5000,
    },

    ['cant_accept_order'] = {
        title = 'Gas Station',
        text = 'Sie können diese Bestellung nicht annehmen, da die Liter auf der Mission den maximalen Vorrat überschreiten',
        type = 'error',
        time = 5000,
    },

    ['max_fuel_already'] = {
        title = 'Tankstelle',
        text = 'Dein Fahrzeug ist bereits Vollgetankt',
        type = 'error',
        time = 5000,
    },

    ['cant_refuel_that_much'] = {
        title = 'Tankstelle',
        text = 'Du kannst nur ${fuelMax}L Tanken',
        type = 'error',
        time = 5000,
    },

    ['no_stock'] = {
        title = 'Tankstelle',
        text = 'Diese Tankstelle hat kein Treibstoff',
        type = 'error',
        time = 5000,
    },

    ['no_stock_input'] = {
        title = 'Tankstelle',
        text = 'Dein Fahrzeug kann nur bis ${fuelToVehicle}L getankt werden',
        type = 'error',
        time = 5000,
    },

    ['no_stock_input_jerrycan'] = {
        title = 'Tankstelle',
        text = 'Der Benzinkanister kann nur ${fuelToVehicle}L halten',
        type = 'error',
        time = 5000,
    },

    ['already_refueling'] = {
        title = 'Tankstelle',
        text = 'Du tankst gerade',
        type = 'error',
        time = 5000,
    },

    ['more_than_max_stock'] = {
        title = 'Tankstelle',
        text = 'Du kannst nicht ${liters}L bestellen,weil die Tankstelle nur ${maxStock}L halten kann.',
        type = 'error',
        time = 5000,
    },

    ['wrong_trailer'] = {
        title = 'Tankstelle',
        text = 'Du hast den Falschen Trailer angehängt',
        type = 'error',
        time = 5000,
    },

    ['no_vehicle_nearby'] = {
        title = 'Tankstelle',
        text = 'Es ist kein Fahrzeug in der nähe',
        type = 'error',
        time = 5000,
    },

    ['cant_refuel'] = {
        title = 'Tankstelle',
        text = 'Dieses Fahrzeug kannst du nicht betanken',
        type = 'error',
        time = 5000,
    },

    ['on_a_vehicle'] = {
        title = 'Tankstelle',
        text = 'Du kannst nicht aus dem Auto heraus Tanken.',
        type = 'error',
        time = 5000,
    },
    
    ['cant_refuel_0'] = {
        title = 'Tankstelle',
        text = 'Du kannst nicht 0 liter Tanken',
        type = 'error',
        time = 5000,
    },

    ['no_fuel_jerrycan'] = {
        title = 'Tankstelle',
        text = 'Du hast nicht genug Treibstoff im Benzinkanister',
        type = 'error',
        time = 5000,
    },

    ['jerrycan_full'] = {
        title = 'Tankstelle',
        text = 'Benzinkanister ist voll',
        type = 'error',
        time = 5000,
    },

    ['stop_refueling'] = {
        title = 'Tankstelle',
        text = 'Das Tanken wurde abgebrochen weil du ins Auto gestiegen bist',
        type = 'error',
        time = 5000,
    },

    ['wrong_vehicle'] = {
        title = 'Tankstelle',
        text = 'Dieses Fahrzeug kann nicht betankt werden',
        type = 'error',
        time = 5000,
    },
    
    -- Success Notifications

    ['bought_store'] = {
        title = 'Tankstelle',
        text = 'Du hast ${name} für ${price} gekauft' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['money_deposited'] = {
        title = 'Tankstelle',
        text = 'Du hast ${money}' .. Config.Currency .. ' in die Firma eingezahlt',
        type = 'success',
        time = 5000,
    },

    ['money_withdrawn'] = {
        title = 'Tankstelle',
        text = 'Du hast ${money}' .. Config.Currency .. ' von der Firma ausgezahlt',
        type = 'success',
        time = 5000,
    },

    ['sold_business'] = {
        title = 'Tankstelle',
        text = 'Du hast die Firma für ${money} verkauft' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['gas_price_changed'] = {
        title = 'Tankstelle',
        text = 'Tankpreis zu ${price} geändert' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['vehicle_bought'] = {
        title = 'Tankstelle',
        text = 'Du kaufst ${vehicle} für ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['updated_stock'] = {
        title = 'Tankstelle',
        text = 'Du hast ${maxStock}L zu ${maxStockUpdated}L geupdated für ${price} ' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['got_hired'] = {
        title = 'Tankstelle',
        text = 'Die Firma ${store_name} hat dich eingestellt',
        type = 'success',
        time = 5000,
    },

    ['success_hired'] = {
        title = 'Tankstelle',
        text = 'Du hast ${hired_name} angestellt',
        type = 'success',
        time = 5000,
    },

    ['success_fired'] = {
        title = 'Tankstelle',
        text = 'Du entlässt ${fired_name}',
        type = 'success',
        time = 5000,
    },

    ['fired_yourself'] = {
        title = 'Tankstelle',
        text = 'Du hast dich selbst entlassen',
        type = 'success',
        time = 5000,
    },

    ['change_rank'] = {
        title = 'Tankstelle',
        text = 'Du änderst den Rang von ${name} zu ${job}',
        type = 'success',
        time = 5000,
    },

    ['gas_fill'] = {
        title = 'Tankstelle',
        text = 'Du Tankst ${liters}L für ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['ordered_success'] = {
        title = 'Tankstelle',
        text = 'Du hast einen Auftrag erstellt von ${liters}L für ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['order_accepted'] = {
        title = 'Tankstelle',
        text = 'Du hast den Auftrag angenommen',
        type = 'success',
        time = 5000,
    },

    ['vehicle_filled'] = {
        title = 'Tankstelle',
        text = 'Das Fahrzeug ist vollgetankt',
        type = 'success',
        time = 5000,
    },

    ['trailer_attached'] = {
        title = 'Tankstelle',
        text = 'Der Trailer wurde erfolgreich angehängt, Gehe zur Tankstelle zurück',
        type = 'success',
        time = 5000,
    },

    ['order_completed'] = {
        title = 'Tankstelle',
        text = 'Du hast den Auftrag abgeschlossen und Erhälst ${reward}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['vehicle_refueled'] = {
        title = 'Tankstelle',
        text = 'Du hast dein Fahrzeug mit ${fuelToVehicle}L für ${priceToPay} getankt' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['jerrycan_refueled'] = {
        title = 'Tankstelle',
        text = 'Du hast den Benzinkanister mit ${fuelToVehicle}L für ${priceToPay} aufgefüllt' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['vehicle_refueled_jerrycan'] = {
        title = 'Tankstelle',
        text = 'Du hast dein Fahrzeug mit dem Benzinkanister aufgefüllt',
        type = 'success',
        time = 5000,
    },

    ['get_jerrycan_item'] = {
        title = 'Tankstelle',
        text = 'Du kaufst einen Benzinkanister für ${priceToPay}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    -- Info Notifications

    ['start_mission'] = {
        title = 'Tankstelle',
        text = 'Gehe zum Fahrzeug um den Auftrag zu starten',
        type = 'info',
        time = 5000,
    },

    ['mission_location'] = {
        title = 'Tankstelle',
        text = 'Gehe zum Wegpunkt auf deiner Karte',
        type = 'info',
        time = 5000,
    },

    ['vehicle_being_refueled'] = {
        title = 'Tankstelle',
        text = 'Dein Fahrzeug wird getankt',
        type = 'info',
        time = 5000,
    },

    ['jerrycan_being_refueled'] = {
        title = 'Tankstelle',
        text = 'Dein Benzinkanister wird aufgefüllt',
        type = 'info',
        time = 5000,
    },
}