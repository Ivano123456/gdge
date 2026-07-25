-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if Config.Language ~= 'it' then return end

Strings = {

    
    -- Notifiche client
    unauthorized_title = 'Non autorizzato',
    unauthorized_message = 'Non sei autorizzato a usare questo',
    not_on_duty_title = 'Non in servizio',
    not_on_duty_message = 'Devi essere in servizio',
    gps_enabled_title = 'GPS Attivato',
    gps_enabled_message = 'Tracciamento GPS attivato',
    gps_disabled_title = 'GPS Disattivato',
    gps_disabled_message = 'Tracciamento GPS disattivato',
    
    -- Notifiche server
    not_tracked_job_title = 'Non sei in un lavoro tracciato',
    not_tracked_job_message = 'Non puoi usare questo oggetto',
    item_not_registered_title = 'Questo oggetto non è registrato per il tuo lavoro',
    item_not_registered_message = 'Non puoi usare questo oggetto',
    item_removed_title = 'GPS Disattivato',
    item_removed_message = 'Il GPS è stato disattivato perché non hai più l\'oggetto richiesto',
    
    -- Formattazione blip
    blip_name_format = '%s (%s)', -- nome giocatore (etichetta lavoro)
    blip_name_far_format = '%s (%s) [LONTANO]', -- nome giocatore (etichetta lavoro) [LONTANO]
    
    -- Valori predefiniti
    default_worker_name = 'Lavoratore (%s)', -- Lavoratore (ID sorgente)
    default_job_label = 'Lavoratore',
}
