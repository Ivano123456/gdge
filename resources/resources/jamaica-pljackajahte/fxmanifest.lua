server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

dependencies { 'es_extended', 'ox_lib', 'jamaica-sluzbe' }

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
    'locales.lua',
}

server_scripts {
    '@jamaica-sluzbe/shared.lua',
    'server.lua',
}

client_script 'client.lua'
