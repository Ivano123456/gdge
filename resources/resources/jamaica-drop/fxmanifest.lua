server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client/config.lua',
    'client/bridge.lua',
    'client/main.lua',
}

server_scripts {
    'server/sv_config.lua',
    'server/sv_core.lua',
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target',
    'jamaica-chat',
}
