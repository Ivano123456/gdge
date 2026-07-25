-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if Config.Language ~= 'nl' then return end

Strings = {

    
    -- Client meldingen
    unauthorized_title = 'Niet geautoriseerd',
    unauthorized_message = 'U bent niet geautoriseerd om dit te gebruiken',
    not_on_duty_title = 'Niet in dienst',
    not_on_duty_message = 'U moet in dienst zijn',
    gps_enabled_title = 'GPS Ingeschakeld',
    gps_enabled_message = 'GPS-tracking ingeschakeld',
    gps_disabled_title = 'GPS Uitgeschakeld',
    gps_disabled_message = 'GPS-tracking uitgeschakeld',
    
    -- Server meldingen
    not_tracked_job_title = 'U heeft geen gevolgde baan',
    not_tracked_job_message = 'U kunt dit item niet gebruiken',
    item_not_registered_title = 'Dit item is niet geregistreerd voor uw baan',
    item_not_registered_message = 'U kunt dit item niet gebruiken',
    item_removed_title = 'GPS Uitgeschakeld',
    item_removed_message = 'GPS is uitgeschakeld omdat u het vereiste item niet meer heeft',
    
    -- Blip opmaak
    blip_name_format = '%s (%s)', -- spelersnaam (baanlabel)
    blip_name_far_format = '%s (%s) [VER]', -- spelersnaam (baanlabel) [VER]
    
    -- Standaardwaarden
    default_worker_name = 'Werknemer (%s)', -- Werknemer (bron-id)
    default_job_label = 'Werknemer',
}
