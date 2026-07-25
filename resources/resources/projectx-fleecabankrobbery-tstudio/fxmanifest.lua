server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'
fx_version "cerulean"

game "gta5"

author 'Project X'

description 'Project X TStudio Fleeca Bank Robbery'

version '1.0.4'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    "config/config.lua",
    'locales/*.lua',
}

client_scripts {
    "opensource/client/client.lua",
    "encrypted/client/client.lua",
}

server_scripts {
    "opensource/server/server.lua",
    "encrypted/server/server.lua",
}

lua54 "yes"

escrow_ignore {
    'config/config.lua',
    'locales/*.lua',
    "opensource/client/client.lua",
    "opensource/server/server.lua",
}

dependency '/assetpacks'
dependency '/assetpacks'