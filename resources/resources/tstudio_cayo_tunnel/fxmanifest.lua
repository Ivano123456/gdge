server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'
fx_version 'cerulean'
lua54 'yes'
game "gta5"

author 'tstudio - turbosaif / uNiqx'
description 'Cayo Perico Tunnel'
version '1.1.8'

this_is_a_map "yes"

data_file 'GTXD_PARENTING_DATA' 'data/gtxd.meta'
data_file 'WATER_FILE' 'water_heistisland.xml'
data_file 'WATER_FILE' 'water_tunnel.xml'
data_file 'WATER_FILE' 'water_pearlsresort.xml'

files {
    'water_heistisland.xml',
    'water_pearlsresort.xml',
    'water_tunnel.xml',
    'data/gtxd.meta'
}

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/client.lua',
}

escrow_ignore {
    'water_heistisland.xml',
    'water_pearlsresort.xml',
    'water_tunnel.xml',
    'config.lua',
}
dependency '/assetpacks'