-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if Config.Language ~= 'fr' then return end

Strings = {

    
    -- Notifications client
    unauthorized_title = 'Non autorisé',
    unauthorized_message = 'Vous n\'êtes pas autorisé à utiliser ceci',
    not_on_duty_title = 'Pas en service',
    not_on_duty_message = 'Vous devez être en service',
    gps_enabled_title = 'GPS Activé',
    gps_enabled_message = 'Suivi GPS activé',
    gps_disabled_title = 'GPS Désactivé',
    gps_disabled_message = 'Suivi GPS désactivé',
    
    -- Notifications serveur
    not_tracked_job_title = 'Vous n\'êtes pas dans un emploi suivi',
    not_tracked_job_message = 'Vous ne pouvez pas utiliser cet objet',
    item_not_registered_title = 'Cet objet n\'est pas enregistré pour votre emploi',
    item_not_registered_message = 'Vous ne pouvez pas utiliser cet objet',
    item_removed_title = 'GPS Désactivé',
    item_removed_message = 'Le GPS a été désactivé car vous n\'avez plus l\'objet requis',
    
    -- Format des balises
    blip_name_format = '%s (%s)', -- nom du joueur (étiquette d'emploi)
    blip_name_far_format = '%s (%s) [LOIN]', -- nom du joueur (étiquette d'emploi) [LOIN]
    
    -- Valeurs par défaut
    default_worker_name = 'Travailleur (%s)', -- Travailleur (ID source)
    default_job_label = 'Travailleur',
}
