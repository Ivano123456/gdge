-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if Config.Language ~= 'de' then return end

Strings = {

    
    -- Client-Benachrichtigungen
    unauthorized_title = 'Nicht autorisiert',
    unauthorized_message = 'Sie sind nicht berechtigt, dies zu verwenden',
    not_on_duty_title = 'Nicht im Dienst',
    not_on_duty_message = 'Sie müssen im Dienst sein',
    gps_enabled_title = 'GPS aktiviert',
    gps_enabled_message = 'GPS-Verfolgung aktiviert',
    gps_disabled_title = 'GPS deaktiviert',
    gps_disabled_message = 'GPS-Verfolgung deaktiviert',
    
    -- Server-Benachrichtigungen
    not_tracked_job_title = 'Sie sind nicht in einem verfolgten Job',
    not_tracked_job_message = 'Sie können diesen Gegenstand nicht verwenden',
    item_not_registered_title = 'Dieser Gegenstand ist nicht für Ihren Job registriert',
    item_not_registered_message = 'Sie können diesen Gegenstand nicht verwenden',
    item_removed_title = 'GPS deaktiviert',
    item_removed_message = 'GPS wurde deaktiviert, da Sie den erforderlichen Gegenstand nicht mehr besitzen',
    
    -- Blip-Formatierung
    blip_name_format = '%s (%s)', -- Spielername (Job-Bezeichnung)
    blip_name_far_format = '%s (%s) [ENTFERNT]', -- Spielername (Job-Bezeichnung) [ENTFERNT]
    
    -- Standardwerte
    default_worker_name = 'Arbeiter (%s)', -- Arbeiter (Quell-ID)
    default_job_label = 'Arbeiter',
}
