server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'jamaica-renta'
description 'Rent vozila i plovila — NUI, ox_target, HUD timer'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/discord_config.lua',
    'server/discord.lua',
    'server/main.lua',
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target',
}

exports {
    'HasActiveRent',
    'IsRentVehicle',
    'GetRentVehicle',
}
