server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'jamaica-haker'
description 'Haker — brisanje MDT dosijea/poternica uz F4 potvrdu'
version '2.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
}

dependencies {
    'es_extended',
    'ox_lib',
    'oxmysql',
    'jamaica-tablet',
    'jamaica_utils',
}

server_exports {
    'HasHackerAccess',
}
