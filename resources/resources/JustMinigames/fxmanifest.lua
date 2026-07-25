server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'
fx_version 'adamant'
game 'gta5'

lua54 'yes'
author 'JustScripts'

client_script { 
    "config.lua",
    "client/*.lua",
}

server_script "server.lua"

files {
    'web/build/index.html',
    'web/build/static/js/*.js',
    'web/build/static/css/*.css',
    'web/build/images/**.png',
    "web/build/alarm.ogg",
    "web/build/ringtone.mp3"
}

ui_page 'web/build/index.html'

escrow_ignore "config.lua"
dependency '/assetpacks'