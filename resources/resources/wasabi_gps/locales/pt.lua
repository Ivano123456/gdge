-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if Config.Language ~= 'pt' then return end

Strings = {

    
    -- Notificações do cliente
    unauthorized_title = 'Não autorizado',
    unauthorized_message = 'Você não está autorizado a usar isso',
    not_on_duty_title = 'Fora de serviço',
    not_on_duty_message = 'Você precisa estar em serviço',
    gps_enabled_title = 'GPS Ativado',
    gps_enabled_message = 'Rastreamento GPS ativado',
    gps_disabled_title = 'GPS Desativado',
    gps_disabled_message = 'Rastreamento GPS desativado',
    
    -- Notificações do servidor
    not_tracked_job_title = 'Você não está em um trabalho rastreado',
    not_tracked_job_message = 'Você não pode usar este item',
    item_not_registered_title = 'Este item não está registrado para seu trabalho',
    item_not_registered_message = 'Você não pode usar este item',
    item_removed_title = 'GPS Desativado',
    item_removed_message = 'O GPS foi desativado porque você não possui mais o item necessário',
    
    -- Formatação do blip
    blip_name_format = '%s (%s)', -- nome do jogador (cargo)
    blip_name_far_format = '%s (%s) [LONGE]', -- nome do jogador (cargo) [LONGE]
    
    -- Valores padrão
    default_worker_name = 'Trabalhador (%s)', -- Trabalhador (ID da fonte)
    default_job_label = 'Trabalhador',
}
