Locales['nl'] = {

    -- TextUI

    ['buy_business'] = {
        text = '[E] Koop ${road} ${name} voor '.. Config.Currency.. '${price}',
        color = 'darkblue',
        side = 'right'
    },

    ['access_business'] = {
        text = '[E] Open ${name}',
        color = 'darkblue',
        side = 'right'
    },

    ['get_fuel'] = {
        text = '[E] Brandstof halen',
        color = 'darkblue',
        side = 'right'
    },

    ['get_trailer'] = {
        text = 'Trailer aankoppelen',
        color = 'darkblue',
        side = 'right'
    },

    ['finish_mission'] = {
        text = '[E] Missie voltooien',
        color = 'darkblue',
        side = 'right'
    },

    ['refuel_vehicle'] = {
        text = '[E] Voertuig tanken',
        color = 'darkblue',
        side = 'right'
    },

    ['refuel_with_jerrycan'] = {
        text = '[E] Tanken met jerrycan',
        color = 'darkblue',
        side = 'right'
    },

    ['stop_refueling_jerrycan'] = {
        text = '[E] Stop met tanken',
        color = 'darkblue',
        side = 'right'
    },

    ['put_nozzle'] = {
        text = '[E] Plaats het tankstuk in het voertuig'
    },

    ['take_nozzle'] = {
        text = '[E] Neem het tankstuk uit het voertuig'
    },

    ['nozzle_in_pump'] = {
        text = '[E] Plaats het tankstuk in de pomp'
    },
    
    ['refuel_jerrycan'] = {
        text = '[E] Jerrycan bijvullen'
    },

    ['refueling_vehicle'] = {
        text = 'Voertuig tanken...'
    },

    -- Requests

    ['hired_requests'] = {
        text = 'Wil je ingehuurd worden door',
    },

    -- Error Notifications

    ['not_enough_money'] = {
        title = 'Benzine Station',
        text = 'Je hebt niet genoeg geld',
        type = 'error',
        time = 5000,
    },

    ['not_enough_money_business'] = {
        title = 'Benzine Station',
        text = 'Je hebt niet genoeg geld op het bedrijf',
        type = 'error',
        time = 5000,
    },

    ['max_stores'] = {
        title = 'Benzine Station',
        text = 'Je hebt het maximum aantal winkels bereikt',
        type = 'error',
        time = 5000,
    },

    ['something_wrong'] = {
        title = 'Benzine Station',
        text = 'Er is iets misgegaan, probeer het later opnieuw',
        type = 'error',
        time = 5000,
    },

    ['gas_price_high'] = {
        title = 'Benzine Station',
        text = 'U kunt de gasprijs niet wijzigen in '.. Config.Currency ..  '${price} omdat de max '.. Config.Currency.. '${max} is',
        type = 'error',
        time = 5000,
    },

    ['price_negative'] = {
        title = 'Benzine Station',
        text = 'U kunt geen negatieve getallen gebruiken',
        type = 'error',
        time = 5000,
    },

    ['use_numbers_only'] = {
        title = 'Benzine Station',
        text = 'De gasprijs moet gevuld worden',
        type = 'error',
        time = 5000,
    },

    ['already_employee'] = {
        title = 'Benzine Station',
        text = '${name} is al werkzaam bij uw tankstation',
        type = 'error',
        time = 5000,
    },

    ['max_employees'] = {
        title = 'Benzine Station',
        text = 'U kunt ${name} niet inhuren omdat u het maximum van ${max} werknemers bij het tankstation hebt bereikt',
        type = 'error',
        time = 5000,
    },

    ['cant_hire_yourself'] = {
        title = 'Benzine Station',
        text = 'Je kunt jezelf niet inhuren',
        type = 'error',
        time = 5000,
    },

    ['change_own_grade'] = {
        title = 'Benzine Station',
        text = 'Je kunt je eigen rank niet wijzigen',
        type = 'error',
        time = 5000,
    },

    ['near_error'] = {
        title = 'Benzine Station',
        text = 'Niemand in de buurt',
        type = 'error',
        time = 5000,
    },

    ['max_stock'] = {
        title = 'Benzine Station',
        text = 'U kunt die update niet uitvoeren omdat de maximale voorraad ${maxStock}L is',
        type = 'error',
        time = 5000,
    },

    ['employee_not_exist'] = {
        title = 'Benzine Station',
        text = 'Die werknemer bestaat niet',
        type = 'error',
        time = 5000,
    },

    ['got_fired'] = {
        title = 'Benzine Station',
        text = 'Je bent ontslagen van ${store_name}',
        type = 'error',
        time = 5000,
    },

    ['fired_himself'] = {
        title = 'Benzine Station',
        text = '${playerName} fired himself',
        type = 'error',
        time = 5000,
    },

    ['no_vehicle'] = {
        title = 'Benzine Station',
        text = 'U kunt die bestelling niet plaatsen omdat u het voertuig ${vehicle} niet hebt',
        type = 'error',
        time = 5000,
    },

    ['only_one_order'] = {
        title = 'Benzine Station',
        text = 'Je kunt een bestelling niet accepteren terwijl je er een actief hebt',
        type = 'error',
        time = 5000,
    },

    ['order_canceled'] = {
        title = 'Benzine Station',
        text = 'Je hebt de bestelling geannuleerd',
        type = 'error',
        time = 5000,
    },

    ['order_canceled_no_trailer'] = {
        title = 'Gas Station',
        text = 'De bestelling is geannuleerd omdat je niet de juiste trailer hebt, of omdat je geen trailer hebt',
        type = 'error',
        time = 5000,
    },

    ['cant_accept_order'] = {
        title = 'Gas Station',
        text = 'Je kunt die bestelling niet accepteren omdat de liters op de missie de maximale voorraad overschrijden',
        type = 'error',
        time = 5000,
    },

    ['max_fuel_already'] = {
        title = 'Benzine Station',
        text = 'Uw voertuig heeft al een volle tank',
        type = 'error',
        time = 5000,
    },

    ['cant_refuel_that_much'] = {
        title = 'Benzine Station',
        text = 'U kunt maximaal ${fuelMax}L tanken',
        type = 'error',
        time = 5000,
    },

    ['no_stock'] = {
        title = 'Benzine Station',
        text = 'Het tankstation heeft geen brandstof',
        type = 'error',
        time = 5000,
    },

    ['no_stock_input'] = {
        title = 'Benzine Station',
        text = 'Uw voertuig mag alleen ${fuelToVehicle}L vervoeren',
        type = 'error',
        time = 5000,
    },

    ['no_stock_input_jerrycan'] = {
        title = 'Benzine Station',
        text = 'Uw jerrycan kan alleen ${fuelToVehicle}L vervoeren',
        type = 'error',
        time = 5000,
    },

    ['already_refueling'] = {
        title = 'Benzine Station',
        text = 'Je bent al aan het tanken',
        type = 'error',
        time = 5000,
    },

    ['more_than_max_stock'] = {
        title = 'Benzine Station',
        text = 'U kunt ${liters}L niet bestellen omdat de maximale voorraad van uw tankstation ${maxStock}L is',
        type = 'error',
        time = 5000,
    },

    ['wrong_trailer'] = {
        title = 'Benzine Station',
        text = 'Je hebt de verkeerde aanhangwagen bevestigd',
        type = 'error',
        time = 5000,
    },

    ['no_vehicle_nearby'] = {
        title = 'Benzine Station',
        text = 'Er is geen voertuig in de buurt',
        type = 'error',
        time = 5000,
    },

    ['cant_refuel'] = {
        title = 'Benzine Station',
        text = 'U kunt dat voertuig niet tanken',
        type = 'error',
        time = 5000,
    },

    ['on_a_vehicle'] = {
        title = 'Benzine Station',
        text = 'U kunt niet tanken in een voertuig',
        type = 'error',
        time = 5000,
    },
    
    ['cant_refuel_0'] = {
        title = 'Benzine Station',
        text = 'Je kunt niet 0 liter tanken',
        type = 'error',
        time = 5000,
    },

    ['no_fuel_jerrycan'] = {
        title = 'Benzine Station',
        text = 'Je hebt niet genoeg brandstof in de jerrycan',
        type = 'error',
        time = 5000,
    },

    ['jerrycan_full'] = {
        title = 'Benzine Station',
        text = 'The jerrycan is full',
        type = 'error',
        time = 5000,
    },

    ['stop_refueling'] = {
        title = 'Benzine Station',
        text = 'Het tanken is geannuleerd omdat u in het voertuig bent gestapt',
        type = 'error',
        time = 5000,
    },

    ['wrong_vehicle'] = {
        title = 'Benzine Station',
        text = 'Je zit niet in het juiste voertuig',
        type = 'error',
        time = 5000,
    },
    
    -- Success Notifications

    ['bought_store'] = {
        title = 'Benzine Station',
        text = 'Je hebt de ${name} gekocht voor '.. Config.Currency.. '${price}',
        type = 'success',
        time = 5000,
    },

    ['money_deposited'] = {
        title = 'Benzine Station',
        text = 'Je hebt '.. Config.Currency ..'${money} gestort in het bedrijf',
        type = 'success',
        time = 5000,
    },

    ['money_withdrawn'] = {
        title = 'Benzine Station',
        text = 'Je hebt '.. Config.Currency ..'${money} opgenomen van het bedrijf',
        type = 'success',
        time = 5000,
    },

    ['sold_business'] = {
        title = 'Benzine Station',
        text = 'Je hebt het bedrijf verkocht voor '.. Config.Currency..' ${money}',
        type = 'success',
        time = 5000,
    },

    ['gas_price_changed'] = {
        title = 'Benzine Station',
        text = 'Je hebt de gasprijs gewijzigd in '.. Config.Currency.. '${price}',
        type = 'success',
        time = 5000,
    },

    ['vehicle_bought'] = {
        title = 'Benzine Station',
        text = 'Je hebt ${vehicle} gekocht voor '.. Config.Currency..'${price}',
        type = 'success',
        time = 5000,
    },

    ['updated_stock'] = {
        title = 'Benzine Station',
        text = 'Je hebt de maximale voorraad bijgewerkt van ${maxStock}L naar ${maxStockUpdated}L voor '.. Config.Currency..'${price}',
        type = 'success',
        time = 5000,
    },

    ['got_hired'] = {
        title = 'Benzine Station',
        text = 'Je bent aangenomen voor de ${store_name}',
        type = 'success',
        time = 5000,
    },

    ['success_hired'] = {
        title = 'Benzine Station',
        text = 'Je hebt ${hired_name} ingehuurd',
        type = 'success',
        time = 5000,
    },

    ['success_fired'] = {
        title = 'Benzine Station',
        text = 'Je hebt ${fired_name} ontslagen',
        type = 'success',
        time = 5000,
    },

    ['fired_yourself'] = {
        title = 'Benzine Station',
        text = 'Je hebt jezelf met succes ontslagen',
        type = 'success',
        time = 5000,
    },

    ['change_rank'] = {
        title = 'Benzine Station',
        text = 'Je hebt de rang van ${name} gewijzigd in ${job}',
        type = 'success',
        time = 5000,
    },

    ['gas_fill'] = {
        title = 'Benzine Station',
        text = 'Je hebt je auto gevuld met ${liters}L voor '.. Config.Currency..'${price}',
        type = 'success',
        time = 5000,
    },

    ['ordered_success'] = {
        title = 'Benzine Station',
        text = 'Je hebt een bestelling geplaatst van ${liters}L voor '.. Config.Currency..'${price}',
        type = 'success',
        time = 5000,
    },

    ['order_accepted'] = {
        title = 'Benzine Station',
        text = 'Je hebt de bestelling geaccepteerd',
        type = 'success',
        time = 5000,
    },

    ['vehicle_filled'] = {
        title = 'Benzine Station',
        text = 'Het voertuig is vol, ga terug naar het tankstation',
        type = 'success',
        time = 5000,
    },

    ['trailer_attached'] = {
        title = 'Benzine Station',
        text = 'De trailer is succesvol bevestigd, terug naar het tankstation',
        type = 'success',
        time = 5000,
    },

    ['order_completed'] = {
        title = 'Benzine Station',
        text = 'Je hebt de bestelling voltooid en '.. Config.Currency..'${reward} ontvangen',
        type = 'success',
        time = 5000,
    },

    ['vehicle_refueled'] = {
        title = 'Benzine Station',
        text = 'U hebt uw voertuig getankt met ${fuelToVehicle}L voor '.. Config.Currency..'${priceToPay}',
        type = 'success',
        time = 5000,
    },

    ['jerrycan_refueled'] = {
        title = 'Benzine Station',
        text = 'Je hebt je jerrycan getankt met ${fuelToVehicle}L voor '.. Config.Currency..'${priceToPay}',
        type = 'success',
        time = 5000,
    },

    ['vehicle_refueled_jerrycan'] = {
        title = 'Benzine Station',
        text = 'U hebt uw voertuig getankt met de jerrycan',
        type = 'success',
        time = 5000,
    },

    ['get_jerrycan_item'] = {
        title = 'Benzine Station',
        text = 'Je hebt de jerrycan gekocht voor '.. Config.Currency..'${priceToPay}',
        type = 'success',
        time = 5000,
    },

    -- Info Notifications

    ['start_mission'] = {
        title = 'Benzine Station',
        text = 'Ga naar het voertuig om de missie te starten',
        type = 'info',
        time = 5000,
    },

    ['mission_location'] = {
        title = 'Benzine Station',
        text = 'Ga naar de locatie die op uw kaart is aangegeven',
        type = 'info',
        time = 5000,
    },

    ['vehicle_being_refueled'] = {
        title = 'Benzine Station',
        text = 'Uw voertuig wordt getankt',
        type = 'info',
        time = 5000,
    },

    ['jerrycan_being_refueled'] = {
        title = 'Benzine Station',
        text = 'Je jerrycan wordt bijgetankt',
        type = 'info',
        time = 5000,
    },
}