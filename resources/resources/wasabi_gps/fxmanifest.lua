server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'

author 'Wasabi Scripts'
description 'Advanced GPS Blip System for Multiple Jobs'
version '1.0.5'

shared_scripts {
    'config.lua',
    'locales/*.lua'
}

server_scripts {
    'framework/**/server.lua',
    'server/*.lua'
}

client_scripts {
    'framework/**/client.lua',
    'client/*.lua'
}

escrow_ignore {
    'client/_customize.lua',
    'framework/**/*.lua',
    'locales/*.lua',
    'config.lua'
}



dependency '/assetpacks'