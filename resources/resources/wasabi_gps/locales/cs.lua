-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if Config.Language ~= 'cs' then return end

Strings = {

    
    -- Klientské notifikace
    unauthorized_title = 'Neautorizováno',
    unauthorized_message = 'Nemáte oprávnění k použití',
    not_on_duty_title = 'Nejste ve službě',
    not_on_duty_message = 'Musíte být ve službě',
    gps_enabled_title = 'GPS Zapnuto',
    gps_enabled_message = 'GPS sledování zapnuto',
    gps_disabled_title = 'GPS Vypnuto',
    gps_disabled_message = 'GPS sledování vypnuto',
    
    -- Serverové notifikace
    not_tracked_job_title = 'Nejste ve sledované práci',
    not_tracked_job_message = 'Nemůžete použít tento předmět',
    item_not_registered_title = 'Tento předmět není registrován pro vaši práci',
    item_not_registered_message = 'Nemůžete použít tento předmět',
    item_removed_title = 'GPS Vypnuto',
    item_removed_message = 'GPS bylo vypnuto, protože již nemáte požadovaný předmět',
    
    -- Formátování značek
    blip_name_format = '%s (%s)', -- jméno hráče (označení práce)
    blip_name_far_format = '%s (%s) [DALEKO]', -- jméno hráče (označení práce) [DALEKO]
    
    -- Výchozí hodnoty
    default_worker_name = 'Pracovník (%s)', -- Pracovník (ID zdroje)
    default_job_label = 'Pracovník',
}
