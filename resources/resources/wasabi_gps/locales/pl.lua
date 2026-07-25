-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if Config.Language ~= 'pl' then return end

Strings = {

    
    -- Powiadomienia klienta
    unauthorized_title = 'Brak uprawnień',
    unauthorized_message = 'Nie masz uprawnień do użycia tego',
    not_on_duty_title = 'Nie na służbie',
    not_on_duty_message = 'Musisz być na służbie',
    gps_enabled_title = 'GPS Włączony',
    gps_enabled_message = 'Śledzenie GPS włączone',
    gps_disabled_title = 'GPS Wyłączony',
    gps_disabled_message = 'Śledzenie GPS wyłączone',
    
    -- Powiadomienia serwera
    not_tracked_job_title = 'Nie jesteś w śledzonej pracy',
    not_tracked_job_message = 'Nie możesz użyć tego przedmiotu',
    item_not_registered_title = 'Ten przedmiot nie jest zarejestrowany dla twojej pracy',
    item_not_registered_message = 'Nie możesz użyć tego przedmiotu',
    item_removed_title = 'GPS Wyłączony',
    item_removed_message = 'GPS został wyłączony, ponieważ nie masz już wymaganego przedmiotu',
    
    -- Formatowanie znacznika
    blip_name_format = '%s (%s)', -- nazwa gracza (etykieta pracy)
    blip_name_far_format = '%s (%s) [DALEKO]', -- nazwa gracza (etykieta pracy) [DALEKO]
    
    -- Wartości domyślne
    default_worker_name = 'Pracownik (%s)', -- Pracownik (ID źródłowe)
    default_job_label = 'Pracownik',
}
