server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'

description 'Cool Radio for ESX, Coverted By Mycroft & Benzo'
version '2.0.0'

shared_scripts  {'@es_extended/imports.lua', '@jamaica-sluzbe/shared.lua', 'config.lua'}

client_scripts {
  'client.lua'
}

server_script 'server.lua'

ui_page('html/ui.html')

files {'html/ui.html', 'html/js/script.js', 'html/css/style.css', 'html/img/radio.png'}

lua54 'yes'