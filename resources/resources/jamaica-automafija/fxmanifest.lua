server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
deskripcija "automafija"
autor 'vulegg'

lua54 'yes'
shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'podesavanje.lua'
}

client_scripts {
    'klijent_automafija.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server_automafija.lua'
}

exports {
    'ObijVozilo',
}

server_exports {
    'HasOrgAccess',
}

dependencies {
    'ox_target',
    'ox_lib',
}
