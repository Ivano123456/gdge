server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'jamaica-pdzaplena'
description 'PD zaplena civilnih vozila u garaži'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target',
    'oxmysql',
}

exports {
    'IsVehiclePdImpounded',
    'GetImpoundDisplay',
    'CanOwnerSpawn',
}
