-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
if Config.Language ~= 'da' then return end

Strings = {

    
    -- Client notifications
    unauthorized_title = 'Uautoriseret',
    unauthorized_message = 'Du er ikke autoriseret til at bruge dette',
    not_on_duty_title = 'Ikke på vagt',
    not_on_duty_message = 'Du skal være på vagt',
    gps_enabled_title = 'GPS Aktiveret',
    gps_enabled_message = 'GPS-sporing aktiveret',
    gps_disabled_title = 'GPS Deaktiveret',
    gps_disabled_message = 'GPS-sporing deaktiveret',
    
    -- Server notifications
    not_tracked_job_title = 'Du er ikke i et sporet job',
    not_tracked_job_message = 'Du kan ikke bruge denne genstand',
    item_not_registered_title = 'Denne genstand er ikke registreret til dit job',
    item_not_registered_message = 'Du kan ikke bruge denne genstand',
    item_removed_title = 'GPS Deaktiveret',
    item_removed_message = 'GPS blev deaktiveret, da du ikke længere har det krævede objekt',
    
    -- Blip formatting
    blip_name_format = '%s (%s)', -- spillernavn (jobtitel)
    blip_name_far_format = '%s (%s) [LANGT VÆK]', -- spillernavn (jobtitel) [LANGT VÆK]
    
    -- Default values
    default_worker_name = 'Arbejder (%s)', -- Arbejder (kilde-id)
    default_job_label = 'Arbejder',
}
