Locales['es'] = {

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
        text = '[E] Obtener combustible',
        color = 'darkblue',
        side = 'right'
    },

    ['get_trailer'] = {
        text = 'Adjuntar remolque',
        color = 'darkblue',
        side = 'right'
    },

    ['finish_mission'] = {
        text = '[E] Terminar misión',
        color = 'darkblue',
        side = 'right'
    },

    ['refuel_vehicle'] = {
        text = '[E] Recargar vehículo',
        color = 'darkblue',
        side = 'right'
    },

    ['refuel_with_jerrycan'] = {
        text = '[E] Recargar con Bidón',
        color = 'darkblue',
        side = 'right'
    },

    ['stop_refueling_jerrycan'] = {
        text = '[E] Detener Recarga',
        color = 'darkblue',
        side = 'right'
    },

    ['put_nozzle'] = {
        text = '[E] Colocar boquilla en vehículo'
    },

    ['take_nozzle'] = {
        text = '[E] Quitar boquilla del vehículo'
    },

    ['nozzle_in_pump'] = {
        text = '[E] Colocar boquilla en bomba'
    },
    
    ['refuel_jerrycan'] = {
        text = '[E] Recargar Bidón'
    },

    ['refueling_vehicle'] = {
        text = 'Recargando Vehículo...'
    },

    -- Requests

    ['hired_requests'] = {
        text = '¿Quieres ser contratado por',
    },

    -- Error Notifications

    ['not_enough_money'] = {
        title = 'Gasolinera',
        text = 'No tienes suficiente dinero',
        type = 'error',
        time = 5000,
    },

    ['not_enough_money_business'] = {
        title = 'Gasolinera',
        text = 'No tienes suficiente dinero en el negocio',
        type = 'error',
        time = 5000,
    },

    ['max_stores'] = {
        title = 'Gasolinera',
        text = 'Has alcanzado el máximo de negocios en propiedad',
        type = 'error',
        time = 5000,
    },

    ['something_wrong'] = {
        title = 'Gasolinera',
        text = 'Algo salió mal, inténtalo de nuevo más tarde',
        type = 'error',
        time = 5000,
    },

    ['gas_price_high'] = {
        title = 'Gasolinera',
        text = 'No puedes cambiar el precio de la gasolina a ${price}' .. Config.Currency .. ' porque el máximo es ${max}' .. Config.Currency,
        type = 'error',
        time = 5000,
    },

    ['price_negative'] = {
        title = 'Gasolinera',
        text = 'No puedes utilizar números negativos',
        type = 'error',
        time = 5000,
    },

    ['use_numbers_only'] = {
        title = 'Gasolinera',
        text = 'El precio de la gasolina debe estar lleno',
        type = 'error',
        time = 5000,
    },

    ['already_employee'] = {
        title = 'Gasolinera',
        text = '${name} ya está trabajando en tu gasolinera',
        type = 'error',
        time = 5000,
    },

    ['max_employees'] = {
        title = 'Gasolinera',
        text = 'No puedes contratar a ${name} porque has alcanzado el máximo de ${max} empleados en la gasolinera',
        type = 'error',
        time = 5000,
    },

    ['cant_hire_yourself'] = {
        title = 'Gasolinera',
        text = 'No puedes contratarte a ti mismo',
        type = 'error',
        time = 5000,
    },

    ['change_own_grade'] = {
        title = 'Gasolinera',
        text = 'No puedes cambiar tu propio rango',
        type = 'error',
        time = 5000,
    },

    ['near_error'] = {
        title = 'Gasolinera',
        text = 'No hay nadie cerca',
        type = 'error',
        time = 5000,
    },

    ['max_stock'] = {
        title = 'Gasolinera',
        text = 'No puedes hacer esa actualización porque el máximo de stock es ${maxStock}L',
        type = 'error',
        time = 5000,
    },

    ['employee_not_exist'] = {
        title = 'Gasolinera',
        text = 'Ese empleado no existe',
        type = 'error',
        time = 5000,
    },

    ['got_fired'] = {
        title = 'Gasolinera',
        text = 'Fuiste despedido de ${store_name}',
        type = 'error',
        time = 5000,
    },

    ['fired_himself'] = {
        title = 'Gasolinera',
        text = '${playerName} se despidió a sí mismo',
        type = 'error',
        time = 5000,
    },

    ['no_vehicle'] = {
        title = 'Gasolinera',
        text = 'No puedes hacer ese pedido porque no tienes el vehículo ${vehicle}',
        type = 'error',
        time = 5000,
    },

    ['only_one_order'] = {
        title = 'Gasolinera',
        text = 'No puedes aceptar un pedido mientras tengas uno activo',
        type = 'error',
        time = 5000,
    },

    ['order_canceled'] = {
        title = 'Gasolinera',
        text = 'Has cancelado el pedido',
        type = 'error',
        time = 5000,
    },

    ['order_canceled_no_trailer'] = {
        title = 'Gasolinera',
        text = 'El pedido se canceló porque no tienes el remolque correcto adjunto o no tienes un remolque',
        type = 'error',
        time = 5000,
    },

    ['cant_accept_order'] = {
        title = 'Gas Station',
        text = 'No puedes aceptar ese pedido porque los litros de la misión superan el stock máximo',
        type = 'error',
        time = 5000,
    },

    ['max_fuel_already'] = {
        title = 'Gasolinera',
        text = 'Tu vehículo ya tiene el tanque lleno',
        type = 'error',
        time = 5000,
    },

    ['cant_refuel_that_much'] = {
        title = 'Gasolinera',
        text = 'Solo puedes recargar ${fuelMax}L',
        type = 'error',
        time = 5000,
    },

    ['no_stock'] = {
        title = 'Gasolinera',
        text = 'La gasolinera no tiene combustible',
        type = 'error',
        time = 5000,
    },

    ['no_stock_input'] = {
        title = 'Gasolinera',
        text = 'Tu vehículo solo puede llevar ${fuelToVehicle}L',
        type = 'error',
        time = 5000,
    },

    ['no_stock_input_jerrycan'] = {
        title = 'Gasolinera',
        text = 'Tu bidón solo puede llevar ${fuelToVehicle}L',
        type = 'error',
        time = 5000,
    },

    ['already_refueling'] = {
        title = 'Gasolinera',
        text = 'Ya estás recargando',
        type = 'error',
        time = 5000,
    },

    ['more_than_max_stock'] = {
        title = 'Gasolinera',
        text = 'No puedes ordenar ${liters}L porque el máximo de stock de tu gasolinera es ${maxStock}L',
        type = 'error',
        time = 5000,
    },

    ['wrong_trailer'] = {
        title = 'Gasolinera',
        text = 'Adjuntaste el remolque equivocado',
        type = 'error',
        time = 5000,
    },

    ['no_vehicle_nearby'] = {
        title = 'Gasolinera',
        text = 'No hay un vehículo cerca',
        type = 'error',
        time = 5000,
    },

    ['cant_refuel'] = {
        title = 'Gasolinera',
        text = 'No puedes recargar ese vehículo',
        type = 'error',
        time = 5000,
    },

    ['on_a_vehicle'] = {
        title = 'Gasolinera',
        text = 'No puedes recargar dentro de un vehículo',
        type = 'error',
        time = 5000,
    },
    
    ['cant_refuel_0'] = {
        title = 'Gasolinera',
        text = 'No puedes recargar 0 litros',
        type = 'error',
        time = 5000,
    },

    ['no_fuel_jerrycan'] = {
        title = 'Gasolinera',
        text = 'No tienes suficiente combustible en el bidón',
        type = 'error',
        time = 5000,
    },

    ['jerrycan_full'] = {
        title = 'Gasolinera',
        text = 'El bidón está lleno',
        type = 'error',
        time = 5000,
    },

    ['stop_refueling'] = {
        title = 'Gasolinera',
        text = 'La recarga se ha cancelado porque entraste en el vehículo',
        type = 'error',
        time = 5000,
    },

    ['wrong_vehicle'] = {
        title = 'Gasolinera',
        text = 'No puedes recargar ese vehículo con el bidón',
        type = 'error',
        time = 5000,
    },
    
    -- Success Notifications

    ['bought_store'] = {
        title = 'Gasolinera',
        text = 'Has comprado ${name} por ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['money_deposited'] = {
        title = 'Gasolinera',
        text = 'Has depositado ${money}' .. Config.Currency .. ' en el negocio',
        type = 'success',
        time = 5000,
    },

    ['money_withdrawn'] = {
        title = 'Gasolinera',
        text = 'Has retirado ${money}' .. Config.Currency .. ' del negocio',
        type = 'success',
        time = 5000,
    },

    ['sold_business'] = {
        title = 'Gasolinera',
        text = 'Has vendido el negocio por ${money}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['gas_price_changed'] = {
        title = 'Gasolinera',
        text = 'Has cambiado el precio de la gasolina a ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['vehicle_bought'] = {
        title = 'Gasolinera',
        text = 'Has comprado ${vehicle} por ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['updated_stock'] = {
        title = 'Gasolinera',
        text = 'Has actualizado el stock máximo de ${maxStock}L a ${maxStockUpdated}L por ${price} ' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['got_hired'] = {
        title = 'Gasolinera',
        text = 'Has sido contratado en ${store_name}',
        type = 'success',
        time = 5000,
    },

    ['success_hired'] = {
        title = 'Gasolinera',
        text = 'Has contratado a ${hired_name}',
        type = 'success',
        time = 5000,
    },

    ['success_fired'] = {
        title = 'Gasolinera',
        text = 'Has despedido a ${fired_name}',
        type = 'success',
        time = 5000,
    },

    ['fired_yourself'] = {
        title = 'Gasolinera',
        text = 'Te has despedido con éxito',
        type = 'success',
        time = 5000,
    },

    ['change_rank'] = {
        title = 'Gasolinera',
        text = 'Has cambiado el rango de ${name} a ${job}',
        type = 'success',
        time = 5000,
    },

    ['gas_fill'] = {
        title = 'Gasolinera',
        text = 'Has llenado tu coche con ${liters}L por ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['ordered_success'] = {
        title = 'Gasolinera',
        text = 'Has realizado un pedido de ${liters}L por ${price}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['order_accepted'] = {
        title = 'Gasolinera',
        text = 'Has aceptado el pedido',
        type = 'success',
        time = 5000,
    },

    ['vehicle_filled'] = {
        title = 'Gasolinera',
        text = 'El vehículo está lleno, vuelve a la gasolinera',
        type = 'success',
        time = 5000,
    },

    ['trailer_attached'] = {
        title = 'Gasolinera',
        text = 'El remolque se ha adjuntado correctamente, vuelve a la gasolinera',
        type = 'success',
        time = 5000,
    },

    ['order_completed'] = {
        title = 'Gasolinera',
        text = 'Has completado con éxito el pedido y has recibido ${reward}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['vehicle_refueled'] = {
        title = 'Gasolinera',
        text = 'Has recargado tu vehículo con ${fuelToVehicle}L por ${priceToPay}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    ['jerrycan_refueled'] = {
        title = 'Gasolinera',
        text = 'Has recargado tu bidón con ${fuelToVehicle}L por ${priceToPay}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },    

    ['vehicle_refueled_jerrycan'] = {
        title = 'Gasolinera',
        text = 'Has recargado tu vehículo con el bidón',
        type = 'success',
        time = 5000,
    },

    ['get_jerrycan_item'] = {
        title = 'Gasolinera',
        text = 'Has comprado el bidón por ${priceToPay}' .. Config.Currency,
        type = 'success',
        time = 5000,
    },

    -- Info Notifications

    ['start_mission'] = {
        title = 'Gasolinera',
        text = 'Ve al vehículo para comenzar la misión',
        type = 'info',
        time = 5000,
    },

    ['mission_location'] = {
        title = 'Gasolinera',
        text = 'Ve a la ubicación marcada en tu mapa',
        type = 'info',
        time = 5000,
    },

    ['vehicle_being_refueled'] = {
        title = 'Gasolinera',
        text = 'Tu vehículo está siendo recargado',
        type = 'info',
        time = 5000,
    },

    ['jerrycan_being_refueled'] = {
        title = 'Gasolinera',
        text = 'Tu bidón está siendo recargado',
        type = 'info',
        time = 5000,
    },
}