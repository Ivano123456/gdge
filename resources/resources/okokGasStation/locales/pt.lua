Locales['pt'] = {

    -- TextUI

    ['buy_business'] = {
        text = '[E] Comprar ${road} ${name} por ${price}' .. Config.Currency,
        color = 'darkblue',
        side = 'right'
    },

    ['access_business'] = {
        text = '[E] Abrir ${name}',
        color = 'darkblue',
        side = 'right'
    },

    ['get_fuel'] = {
        text = '[E] Obter Combustível',
        color = 'darkblue',
        side = 'right'
    },

    ['get_trailer'] = {
        text = '[E] Obter Trailer',
        color = 'darkblue',
        side = 'right'
    },

    ['finish_mission'] = {
        text = '[E] Terminar Missão',
        color = 'darkblue',
        side = 'right'
    },

    ['refuel_vehicle'] = {
        text = '[E] Reabastecer Veículo',
        color = 'darkblue',
        side = 'right'
    },

    ['refuel_with_jerrycan'] = {
        text = '[E] Reabastecer com Galão de Combustível',
        color = 'darkblue',
        side = 'right'
    },

    ['stop_refueling_jerrycan'] = {
        text = '[E] Parar de Reabastecer',
        color = 'darkblue',
        side = 'right'
    },

    ['put_nozzle'] = {
        text = '[E] Colocar nozzle no Veículo',
    },

    ['take_nozzle'] = {
        text = '[E] Tirar nozzle do veículo'
    },

    ['nozzle_in_pump'] = {
        text = '[E] Colocar nozzle na bomba'
    },
    
    ['refuel_jerrycan'] = {
        text = '[E] Reabastecer galão de combustível'
    },

    ['refueling_vehicle'] = {
        text = 'A reabastecer veículo...'
    },

    -- Requests

    ['hired_requests'] = {
        text = 'Queres ser contratado para',
    },

    -- Error Notifications

    ['not_enough_money'] = {
        title = 'Posto de Combustível',
        text = 'Não tens dinheiro suficiente',
        type = 'error',
        time = 5000,
    },

    ['not_enough_money_business'] = {
        title = 'Posto de Combustível',
        text = 'Não tens dinheiro suficiente na empresa',
        type = 'error',
        time = 5000,
    },

    ['max_stores'] = {
        title = 'Posto de Combustível',
        text = 'Atingiste o máximo de lojas que podes ter',
        type = 'error',
        time = 5000,
    },

    ['something_wrong'] = {
        title = 'Posto de Combustível',
        text = 'Alguma coisa correu mal, tenta novamente mais tarde',
        type = 'error',
        time = 5000,
    },

    ['gas_price_high'] = {
        title = 'Posto de Combustível',
        text = 'Não podes alterar o preço do combustível para ${price}' .. Config.Currency .. ' porque o máximo é ${max}' .. Config.Currency,
        type = 'error',
        time = 5000,
    },

    ['price_negative'] = {
        title = 'Posto de Combustível',
        text = 'Não podes usar números negativos',
        type = 'error',
        time = 5000,
    },

    ['use_numbers_only'] = {
        title = 'Posto de Combustível',
        text = 'O preço do combustível tem de ser preenchido',
        type = 'error',
        time = 5000,
    },

    ['already_employee'] = {
        title = 'Posto de Combustível',
        text = '${name} já é teu funcionário',
        type = 'error',
        time = 5000,
    },

    ['max_employees'] = {
        title = 'Posto de Combustível',
        text = 'Não podes contratar ${name} porque atingiste o máximo de ${max} funcionários',
        type = 'error',
        time = 5000,
    },

    ['cant_hire_yourself'] = {
        title = 'Posto de Combustível',
        text = 'Não te podes contratar a ti mesmo',
        type = 'error',
        time = 5000,
    },

    ['change_own_grade'] = {
        title = 'Posto de Combustível',
        text = 'Não podes alterar o teu próprio cargo',
        type = 'error',
        time = 5000,
    },

    ['near_error'] = {
        title = 'Posto de Combustível',
        text = 'Sem ninguém por perto',
        type = 'error',
        time = 5000,
    },

    ['max_stock'] = {
        title = 'Posto de Combustível',
        text = 'Tu não podes melhorar o stock porque o máximo é ${maxStock}L',
        type = 'error',
        time = 5000,
    },

    ['employee_not_exist'] = {
        title = 'Posto de Combustível',
        text = 'Esse funcionário não existe',
        type = 'error',
        time = 5000,
    },

    ['got_fired'] = {
        title = 'Posto de Combustível',
        text = 'Foste despedido de ${store_name}',
        type = 'error',
        time = 5000,
    },

    ['fired_himself'] = {
        title = 'Posto de Combustível',
        text = '${playerName} despediu-se',
        type = 'error',
        time = 5000,
    },

    ['no_vehicle'] = {
        title = 'Posto de Combustível',
        text = 'Não podes fazer essa missão porque não tens o veículo ${vehicle}',
        type = 'error',
        time = 5000,
    },

    ['only_one_order'] = {
        title = 'Posto de Combustível',
        text = 'Não podes aceitar outra missão enquanto tens outra ativa',
        type = 'error',
        time = 5000,
    },

    ['order_canceled'] = {
        title = 'Posto de Combustível',
        text = 'Tu cancelaste a missão',
        type = 'error',
        time = 5000,
    },

    ['order_canceled_no_trailer'] = {
        title = 'Posto de Combustível',
        text = 'Tu cancelaste a missão porque não tens o trailer ou não é o correto',
        type = 'error',
        time = 5000,
    },

    ['cant_accept_order'] = {
        title = 'Gas Station',
        text = 'Não podes aceitar a missão porque os litros da mesma excedem o stock máximo',
        type = 'error',
        time = 5000,
    },

    ['max_fuel_already'] = {
        title = 'Posto de Combustível',
        text = 'O teu veículo tem o tanque de combustível cheio',
        type = 'error',
        time = 5000,
    },

    ['cant_refuel_that_much'] = {
        title = 'Posto de Combustível',
        text = 'Tu só podes reabastecer ${fuelMax}L',
        type = 'error',
        time = 5000,
    },

    ['no_stock'] = {
        title = 'Posto de Combustível',
        text = 'O Posto de Combustível não tem combustível',
        type = 'error',
        time = 5000,
    },

    ['no_stock_input'] = {
        title = 'Posto de Combustível',
        text = 'O teu veículo só leva ${fuelToVehicle}L',
        type = 'error',
        time = 5000,
    },

    ['no_stock_input_jerrycan'] = {
        title = 'Posto de Combustível',
        text = 'O teu galão de combustível só pode levar ${fuelToVehicle}L',
        type = 'error',
        time = 5000,
    },

    ['already_refueling'] = {
        title = 'Posto de Combustível',
        text = 'Já estás a reabastecer',
        type = 'error',
        time = 5000,
    },

    ['more_than_max_stock'] = {
        title = 'Posto de Combustível',
        text = 'Tu não podes pedir ${liters}L porque o stock máximo do posto de combustível é ${maxStock}L',
        type = 'error',
        time = 5000,
    },

    ['wrong_trailer'] = {
        title = 'Posto de Combustível',
        text = 'Tu não tens o trailer correto',
        type = 'error',
        time = 5000,
    },

    ['no_vehicle_nearby'] = {
        title = 'Posto de Combustível',
        text = 'Não há veículos por perto',
        type = 'error',
        time = 5000,
    },

    ['cant_refuel'] = {
        title = 'Posto de Combustível',
        text = 'Tu não podes reabastecer esse veículo',
        type = 'error',
        time = 5000,
    },

    ['on_a_vehicle'] = {
        title = 'Posto de Combustível',
        text = 'Não podes reabastecer enquanto estás dentro de um veículo',
        type = 'error',
        time = 5000,
    },
    
    ['cant_refuel_0'] = {
        title = 'Posto de Combustível',
        text = 'Não podes reabastecer 0 litros',
        type = 'error',
        time = 5000,
    },

    ['no_fuel_jerrycan'] = {
        title = 'Posto de Combustível',
        text = 'Tu não tens combustível no galão de combustível',
        type = 'error',
        time = 5000,
    },

    ['jerrycan_full'] = {
        title = 'Posto de Combustível',
        text = 'O galão de combustível está cheio',
        type = 'error',
        time = 5000,
    },

    ['stop_refueling'] = {
        title = 'Posto de Combustível',
        text = 'O reabastecimento foi cancelado porque entraste no veículo',
        type = 'error',
        time = 5000,
    },

    ['wrong_vehicle'] = {
        title = 'Posto de Combustível',
        text = 'Estás no veículo errado',
        type = 'error',
        time = 5000,
    },
    
    -- Success Notifications

    ['bought_store'] = {
        title = 'Posto de Combustível',
        text = 'Compraste ${name} por ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['money_deposited'] = {
        title = 'Posto de Combustível',
        text = 'Depositaste ${money}' .. Config.Currency .. ' na empresa',
        type = 'success',
        time = 5000,
    },

    ['money_withdrawn'] = {
        title = 'Posto de Combustível',
        text = 'Levantaste ${money}' .. Config.Currency .. ' da empresa',
        type = 'success',
        time = 5000,
    },

    ['sold_business'] = {
        title = 'Posto de Combustível',
        text = 'Vendeste a empresa por ${money}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['gas_price_changed'] = {
        title = 'Posto de Combustível',
        text = 'Alteraste o preço do combustível para ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['vehicle_bought'] = {
        title = 'Posto de Combustível',
        text = 'Compraste ${vehicle} por ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['updated_stock'] = {
        title = 'Posto de Combustível',
        text = 'Melhoraste o stock máximo de ${maxStock}L para ${maxStockUpdated}L por ${price} ' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['got_hired'] = {
        title = 'Posto de Combustível',
        text = 'Foste contratado para ${store_name}',
        type = 'success',
        time = 5000,
    },

    ['success_hired'] = {
        title = 'Posto de Combustível',
        text = 'Contrataste ${hired_name}',
        type = 'success',
        time = 5000,
    },

    ['success_fired'] = {
        title = 'Posto de Combustível',
        text = 'Despediste ${fired_name}',
        type = 'success',
        time = 5000,
    },

    ['fired_yourself'] = {
        title = 'Posto de Combustível',
        text = 'Despediste-te com sucesso',
        type = 'success',
        time = 5000,
    },

    ['change_rank'] = {
        title = 'Posto de Combustível',
        text = 'Alteraste o cargo de ${name} para ${job}',
        type = 'success',
        time = 5000,
    },

    ['gas_fill'] = {
        title = 'Posto de Combustível',
        text = 'Reabasteceste o veículo com ${liters}L por ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['ordered_success'] = {
        title = 'Posto de Combustível',
        text = 'Criaste uma missão com ${liters}L por ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['order_accepted'] = {
        title = 'Posto de Combustível',
        text = 'Aceitaste a missão',
        type = 'success',
        time = 5000,
    },

    ['vehicle_filled'] = {
        title = 'Posto de Combustível',
        text = 'O veículo está reabastecido, podes voltar para a Posto de Combustível',
        type = 'success',
        time = 5000,
    },

    ['trailer_attached'] = {
        title = 'Posto de Combustível',
        text = 'Obteste o trailer, podes voltar para a Posto de Combustível',
        type = 'success',
        time = 5000,
    },

    ['order_completed'] = {
        title = 'Posto de Combustível',
        text = 'Terminaste a missão e recebeste ${reward}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['vehicle_refueled'] = {
        title = 'Posto de Combustível',
        text = 'Rreabasteceste o teu veículo com ${fuelToVehicle}L por ${priceToPay}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['jerrycan_refueled'] = {
        title = 'Posto de Combustível',
        text = 'Reabasteceste o teu galão de combustível com ${fuelToVehicle}L por ${priceToPay}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['vehicle_refueled_jerrycan'] = {
        title = 'Posto de Combustível',
        text = 'Reabasteceste o teu veículo com o galão de combustível',
        type = 'success',
        time = 5000,
    },

    ['get_jerrycan_item'] = {
        title = 'Posto de Combustível',
        text = 'Compraste o galão de combustível por ${priceToPay}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    -- Info Notifications

    ['start_mission'] = {
        title = 'Posto de Combustível',
        text = 'Vai para o veículo para começar a missão',
        type = 'info',
        time = 5000,
    },

    ['mission_location'] = {
        title = 'Posto de Combustível',
        text = 'Vai para a localização marcada no mapa',
        type = 'info',
        time = 5000,
    },

    ['vehicle_being_refueled'] = {
        title = 'Posto de Combustível',
        text = 'O veículo está a ser reabastecido',
        type = 'info',
        time = 5000,
    },

    ['jerrycan_being_refueled'] = {
        title = 'Posto de Combustível',
        text = 'O galão de combustível está a ser reabastecido',
        type = 'info',
        time = 5000,
    },
}