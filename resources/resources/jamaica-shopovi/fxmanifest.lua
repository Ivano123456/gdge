server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'jamaica-shopovi'
description 'Shopovi'
author 'Maxwell'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'cl_main.lua',
    'cl_admin.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'sv_main.lua',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',
}

dependencies {
    'ox_lib',
    'oxmysql',
    'es_extended',
}
