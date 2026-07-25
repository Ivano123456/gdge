server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




lua54 'yes'
fx_version 'cerulean'
game 'gta5'
author 'Josip "j0le" Tomašević'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config/config.lua',
}

client_scripts {
    'client/client.lua',
    'client/cleanup.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config/Webhookovi.lua',
    'server/server.lua',
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/deathsound.mp3',
}

ui_page 'html/index.html'

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target',
}
