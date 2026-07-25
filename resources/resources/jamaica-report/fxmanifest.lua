server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'jamaica-reportovi'
description 'Igrački report: /pomoc | Admin lista: /lp'
version '1.0.0'

dependencies {
    'es_extended',
}

shared_script 'config.lua'

ui_page 'report.html'

files {
    'report.html',
    'style.css',
    'script.js',
}

client_scripts {
    '@es_extended/imports.lua',
    'client.lua',
}

server_scripts {
    '@es_extended/imports.lua',
    'server.lua',
}
