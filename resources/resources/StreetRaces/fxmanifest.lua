server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'

author 'Jamaica'
description 'Street Racing Script with ox_lib integration'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    'races_cl.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'races_sv.lua'
}

dependencies {
    'es_extended',
    'oxmysql',
    'ox_lib',
}

lua54 'yes'
