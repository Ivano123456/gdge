-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if Config.Language ~= 'es' then return end

Strings = {

    
    -- Notificaciones del cliente
    unauthorized_title = 'No autorizado',
    unauthorized_message = 'No estás autorizado para usar esto',
    not_on_duty_title = 'Fuera de servicio',
    not_on_duty_message = 'Debes estar en servicio',
    gps_enabled_title = 'GPS Activado',
    gps_enabled_message = 'Seguimiento GPS activado',
    gps_disabled_title = 'GPS Desactivado',
    gps_disabled_message = 'Seguimiento GPS desactivado',
    
    -- Notificaciones del servidor
    not_tracked_job_title = 'No estás en un trabajo rastreado',
    not_tracked_job_message = 'No puedes usar este objeto',
    item_not_registered_title = 'Este objeto no está registrado para tu trabajo',
    item_not_registered_message = 'No puedes usar este objeto',
    item_removed_title = 'GPS Desactivado',
    item_removed_message = 'El GPS ha sido desactivado porque ya no tienes el objeto requerido',
    
    -- Formato del marcador
    blip_name_format = '%s (%s)', -- nombre del jugador (etiqueta del trabajo)
    blip_name_far_format = '%s (%s) [LEJOS]', -- nombre del jugador (etiqueta del trabajo) [LEJOS]
    
    -- Valores predeterminados
    default_worker_name = 'Trabajador (%s)', -- Trabajador (ID de origen)
    default_job_label = 'Trabajador',
}
