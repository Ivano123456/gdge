server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'jamaica-welcomee'
description 'Welcome kutija sa spinner nagradama za odobrene igrace'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    '@es_extended/imports.lua',
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@es_extended/imports.lua',
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/*.svg',
}

dependencies {
    'es_extended',
    'oxmysql',
}

server_export 'useKutija'
server_export 'GiveWelcomeBox'
server_export 'StartWelcomeBox'
