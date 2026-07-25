-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
if not Config.Language then Config.Language = 'en' end
if Config.Language ~= 'en' then return end

Strings = {

    
    -- Client notifications
    unauthorized_title = 'Unauthorized',
    unauthorized_message = 'You are not authorized to use this',
    not_on_duty_title = 'Not on duty',
    not_on_duty_message = 'You must be on duty',
    gps_enabled_title = 'GPS Enabled',
    gps_enabled_message = 'GPS tracking enabled',
    gps_disabled_title = 'GPS Disabled',
    gps_disabled_message = 'GPS tracking disabled',
    
    -- Server notifications
    not_tracked_job_title = 'You are not in a tracked job',
    not_tracked_job_message = 'You cannot use this item',
    item_not_registered_title = 'This item is not registered for your job',
    item_not_registered_message = 'You cannot use this item',
    item_removed_title = 'GPS Disabled',
    item_removed_message = 'GPS has been disabled because you no longer have the required item',
    
    -- Blip formatting
    blip_name_format = '%s (%s)', -- player name (job label)
    blip_name_far_format = '%s (%s) [FAR]', -- player name (job label) [FAR]
    
    -- Default values
    default_worker_name = 'Worker (%s)', -- Worker (source id)
    default_job_label = 'Worker',
}
