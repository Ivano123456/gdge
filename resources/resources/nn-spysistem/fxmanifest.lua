server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version "cerulean"

description "Nano Spy System - Advanced Surveillance Equipment"
author "NANO Scripts"
version '1.0.6'

lua54 'yes'

games {
  "gta5"
}

-- Dependencies
dependencies {
    'oxmysql',
    'ox_lib',
    'nn_lib',
    'nn_bridge'
}

-- NUI
ui_page 'web/build/index.html'

-- Config
shared_script {
    'config.lua',
    '@ox_lib/init.lua',
    '@nn_bridge/init.lua'
}

-- Scripts
client_scripts {
    'lib/cl_lib.lua',
    'client/*.lua'
}

server_scripts {
    'lib/sv_lib.lua',
    'server/00_callbacks.lua',
    'server/*.lua'
}

-- Files for NUI
files {
    'web/build/**/*',
    'sounds/**/*'
}

escrow_ignore {
  'config.lua'
}

files {
  'stream/nano_spy_cam.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/nano_spy_cam.ytyp'
dependency '/assetpacks'
dependency '/assetpacks'