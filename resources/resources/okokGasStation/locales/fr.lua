Locales['fr'] = {

    -- TextUI

    ['buy_business'] = {
        text = '[E] Achetez ${road} ${name} pour ${price}' .. Config.Currency,
        color = 'darkblue',
        side = 'right'
    },

    ['access_business'] = {
        text = '[E] Ouvrir ${name}',
        color = 'darkblue',
        side = 'right'
    },

    ['get_fuel'] = {
        text = '[E] Obtenir essence',
        color = 'darkblue',
        side = 'right'
    },

    ['get_trailer'] = {
        text = 'Attacher remorque',
        color = 'darkblue',
        side = 'right'
    },

    ['finish_mission'] = {
        text = '[E] Finir mission',
        color = 'darkblue',
        side = 'right'
    },

    ['refuel_vehicle'] = {
        text = '[E] Remplir véhicule',
        color = 'darkblue',
        side = 'right'
    },

    ['refuel_with_jerrycan'] = {
        text = '[E] Remplir avec un jerrican',
        color = 'darkblue',
        side = 'right'
    },

    ['stop_refueling_jerrycan'] = {
        text = '[E] Stopper remplissage',
        color = 'darkblue',
        side = 'right'
    },

    ['put_nozzle'] = {
        text = '[E] Mettre le pistolet dans le véhicule'
    },

    ['take_nozzle'] = {
        text = '[E] Retirer le pistolet'
    },

    ['nozzle_in_pump'] = {
        text = '[E] Remettre le pistolet dans la pompe'
    },
    
    ['refuel_jerrycan'] = {
        text = '[E] Remplir Jerrican'
    },

    ['refueling_vehicle'] = {
        text = 'Remplissage en cours...'
    },

    -- Requests

    ['hired_requests'] = {
        text = 'Voulez-vous être embauché par',
    },

    -- Error Notifications

    ['not_enough_money'] = {
        title = 'Gas Station',
        text = 'Pas assez d\'argent',
        type = 'error',
        time = 5000,
    },

    ['not_enough_money_business'] = {
        title = 'Gas Station',
        text = 'Pas assez d\'argent dans la société',
        type = 'error',
        time = 5000,
    },

    ['max_stores'] = {
        title = 'Gas Station',
        text = 'Vous avez atteint le nombre maximum de propriétés que vous pouvez posseder',
        type = 'error',
        time = 5000,
    },

    ['something_wrong'] = {
        title = 'Gas Station',
        text = 'Erreur, reessayez plus tard',
        type = 'error',
        time = 5000,
    },

    ['gas_price_high'] = {
        title = 'Gas Station',
        text = 'Vous ne pouvez pas changer le prix de l\'essence a ${price}' .. Config.Currency .. ' parce que le maximum est ${max}' .. Config.Currency,
        type = 'error',
        time = 5000,
    },

    ['price_negative'] = {
        title = 'Gas Station',
        text = 'Vous ne pouvez pas utiliser de nombres négatifs',
        type = 'error',
        time = 5000,
    },

    ['use_numbers_only'] = {
        title = 'Gas Station',
        text = 'Vous devez remplir le champ Prix',
        type = 'error',
        time = 5000,
    },

    ['already_employee'] = {
        title = 'Gas Station',
        text = '${name} est déjà employé dans votre station',
        type = 'error',
        time = 5000,
    },

    ['max_employees'] = {
        title = 'Gas Station',
        text = 'Vous ne pouvez pas embaucher ${name} vous avez atteint le maximum de ${max} employés dans votre station essence',
        type = 'error',
        time = 5000,
    },

    ['cant_hire_yourself'] = {
        title = 'Gas Station',
        text = 'Vous ne pouvez pas vous employer vous même',
        type = 'error',
        time = 5000,
    },

    ['change_own_grade'] = {
        title = 'Gas Station',
        text = 'Vous ne pouvez pas changer votre propre grade',
        type = 'error',
        time = 5000,
    },

    ['near_error'] = {
        title = 'Gas Station',
        text = 'Aucun citoyen proche',
        type = 'error',
        time = 5000,
    },

    ['max_stock'] = {
        title = 'Gas Station',
        text = 'Le stock maximum est de ${maxStock}L',
        type = 'error',
        time = 5000,
    },

    ['employee_not_exist'] = {
        title = 'Gas Station',
        text = 'Cet employé n\'existe pas',
        type = 'error',
        time = 5000,
    },

    ['got_fired'] = {
        title = 'Gas Station',
        text = 'Vous avez été renvoyé de ${store_name}',
        type = 'error',
        time = 5000,
    },

    ['fired_himself'] = {
        title = 'Gas Station',
        text = '${playerName} a démissionné',
        type = 'error',
        time = 5000,
    },

    ['no_vehicle'] = {
        title = 'Gas Station',
        text = 'Vous ne pouvez pas faire cette commande, vous n\'avez pas le véhicule ${vehicle}',
        type = 'error',
        time = 5000,
    },

    ['only_one_order'] = {
        title = 'Gas Station',
        text = 'Vous ne pouvez pas accepter une autre mission vous en avez déjà une active',
        type = 'error',
        time = 5000,
    },

    ['order_canceled'] = {
        title = 'Gas Station',
        text = 'Vous avez annulé la commande',
        type = 'error',
        time = 5000,
    },

    ['order_canceled_no_trailer'] = {
        title = 'Gas Station',
        text = 'La commande a été annulée car vous n\'avez pas la bonne remorque attachée ou vous n\'avez pas de remorque',
        type = 'error',
        time = 5000,
    },

    ['cant_accept_order'] = {
        title = 'Gas Station',
        text = 'Vous ne pouvez pas accepter cette commande car les litres de la mission dépassent le stock maximum',
        type = 'error',
        time = 5000,
    },

    ['max_fuel_already'] = {
        title = 'Gas Station',
        text = 'Votre véhicule est déjà plein',
        type = 'error',
        time = 5000,
    },

    ['cant_refuel_that_much'] = {
        title = 'Gas Station',
        text = 'Vous pouvez seulement remplir ${fuelMax}L',
        type = 'error',
        time = 5000,
    },

    ['no_stock'] = {
        title = 'Gas Station',
        text = 'La station n\'a plus d\'essence',
        type = 'error',
        time = 5000,
    },

    ['no_stock_input'] = {
        title = 'Gas Station',
        text = 'Votre véhicule peut seulement contenir ${fuelToVehicle}L',
        type = 'error',
        time = 5000,
    },

    ['no_stock_input_jerrycan'] = {
        title = 'Gas Station',
        text = 'Votre jerrican peut seulement contenir ${fuelToVehicle}L',
        type = 'error',
        time = 5000,
    },

    ['already_refueling'] = {
        title = 'Gas Station',
        text = 'Remplissage déjà en cours',
        type = 'error',
        time = 5000,
    },

    ['more_than_max_stock'] = {
        title = 'Gas Station',
        text = 'Vous ne pouvez pas commander ${liters}L parce que le stock max de votre station est de ${maxStock}L',
        type = 'error',
        time = 5000,
    },

    ['wrong_trailer'] = {
        title = 'Gas Station',
        text = 'Mauvaise remorque',
        type = 'error',
        time = 5000,
    },

    ['no_vehicle_nearby'] = {
        title = 'Gas Station',
        text = 'Aucun véhicule proche',
        type = 'error',
        time = 5000,
    },

    ['cant_refuel'] = {
        title = 'Gas Station',
        text = 'Ce véhicule ne peut etre rempli',
        type = 'error',
        time = 5000,
    },

    ['on_a_vehicle'] = {
        title = 'Gas Station',
        text = 'Vous devez sortir du véhicule pour le remplir',
        type = 'error',
        time = 5000,
    },
    
    ['cant_refuel_0'] = {
        title = 'Gas Station',
        text = 'Vous ne pouvez pas remplir 0 litres',
        type = 'error',
        time = 5000,
    },

    ['no_fuel_jerrycan'] = {
        title = 'Gas Station',
        text = 'Pas assez d\'essence dans le jerrican',
        type = 'error',
        time = 5000,
    },

    ['jerrycan_full'] = {
        title = 'Gas Station',
        text = 'Jerrican plein',
        type = 'error',
        time = 5000,
    },

    ['stop_refueling'] = {
        title = 'Gas Station',
        text = 'Remplissage annulé, vous etes entré dans le véhicule',
        type = 'error',
        time = 5000,
    },

    ['wrong_vehicle'] = {
        title = 'Gas Station',
        text = 'Mauvais véhicule',
        type = 'error',
        time = 5000,
    },
    
    -- Success Notifications

    ['bought_store'] = {
        title = 'Gas Station',
        text = 'Vous avez acheté ${name} pour ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['money_deposited'] = {
        title = 'Gas Station',
        text = 'Vous avez déposé ${money}' .. Config.Currency .. ' dans l\'entreprise',
        type = 'success',
        time = 5000,
    },

    ['money_withdrawn'] = {
        title = 'Gas Station',
        text = 'Vous avez retiré ${money}' .. Config.Currency .. ' de l\'entreprise',
        type = 'success',
        time = 5000,
    },

    ['sold_business'] = {
        title = 'Gas Station',
        text = 'Vous avez vendu votre entrerprise pour ${money}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['gas_price_changed'] = {
        title = 'Gas Station',
        text = 'Vous avez changé le prix de l\'essence a ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['vehicle_bought'] = {
        title = 'Gas Station',
        text = 'Vous avez acheté ${vehicle} pour ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['updated_stock'] = {
        title = 'Gas Station',
        text = 'Vous avez mis a jour le stock max de ${maxStock}L a ${maxStockUpdated}L pour ${price} ' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['got_hired'] = {
        title = 'Gas Station',
        text = 'Vous avez été embauché par ${store_name}',
        type = 'success',
        time = 5000,
    },

    ['success_hired'] = {
        title = 'Gas Station',
        text = 'Vous avez embauché ${hired_name}',
        type = 'success',
        time = 5000,
    },

    ['success_fired'] = {
        title = 'Gas Station',
        text = 'Vous avez viré ${fired_name}',
        type = 'success',
        time = 5000,
    },

    ['fired_yourself'] = {
        title = 'Gas Station',
        text = 'Vous avez démissioné',
        type = 'success',
        time = 5000,
    },

    ['change_rank'] = {
        title = 'Gas Station',
        text = 'Vous avez changé le rand de ${name} pour ${job}',
        type = 'success',
        time = 5000,
    },

    ['gas_fill'] = {
        title = 'Gas Station',
        text = 'Vous avez rempli votre véhicule avec ${liters}L pour ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['ordered_success'] = {
        title = 'Gas Station',
        text = 'Vous avez commandé ${liters}L pour ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['order_accepted'] = {
        title = 'Gas Station',
        text = 'Commande acceptée',
        type = 'success',
        time = 5000,
    },

    ['vehicle_filled'] = {
        title = 'Gas Station',
        text = 'Véhicule plein, retournez à la station essence',
        type = 'success',
        time = 5000,
    },

    ['trailer_attached'] = {
        title = 'Gas Station',
        text = 'Remorque correctement attachée, retournez à la station essence',
        type = 'success',
        time = 5000,
    },

    ['order_completed'] = {
        title = 'Gas Station',
        text = 'Commande terminée, vous avez reçu ${reward}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['vehicle_refueled'] = {
        title = 'Gas Station',
        text = 'Vous avez rempli votre véhicule avec ${fuelToVehicle}L pour ${priceToPay}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['jerrycan_refueled'] = {
        title = 'Gas Station',
        text = 'Vous avez rempli votre jerrican avec ${fuelToVehicle}L pour ${priceToPay}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['vehicle_refueled_jerrycan'] = {
        title = 'Gas Station',
        text = 'Vous avez rempli votre véhicule avec le jerrican',
        type = 'success',
        time = 5000,
    },

    ['get_jerrycan_item'] = {
        title = 'Gas Station',
        text = 'Vous avez acheté un jerrican pour ${priceToPay}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    -- Info Notifications

    ['start_mission'] = {
        title = 'Gas Station',
        text = 'Allez au véhicule pour commencer la mission',
        type = 'info',
        time = 5000,
    },

    ['mission_location'] = {
        title = 'Gas Station',
        text = 'Rendez vous au point indiqué sur votre GPS',
        type = 'info',
        time = 5000,
    },

    ['vehicle_being_refueled'] = {
        title = 'Gas Station',
        text = 'Véhicule en cours de remplissage',
        type = 'info',
        time = 5000,
    },

    ['jerrycan_being_refueled'] = {
        title = 'Gas Station',
        text = 'Jerrican en cours de remplissage',
        type = 'info',
        time = 5000,
    },
}