client_script '@jamaica-pedovi/src/include/client.lua'
fx_version "cerulean"
game "gta5"
lua54 "yes"

author 'MXC'
description 'JEWELRY'
version '1.0.0'

this_is_a_map 'yes'

data_file 'TIMECYCLEMOD_FILE' 'mxc_timecycle_list_01.xml'
data_file 'AUDIO_GAMEDATA' '[audio]/mxc_jewelry_game.dat'

files {
    'mxc_timecycle_list_01.xml',
    '[audio]/mxc_jewelry_game.dat151.rel',
}

client_script {
    'client.lua',
}

escrow_ignore {
    'stream/[multi-location]/[1-VangelicoRockfordHills]/[gta5files]/*.ydr',
    'stream/[interior]/mxc_jewelry_props_editableneonlogo.ydr',
    'jewelry_entityset_mods.lua'
}
dependency '/assetpacks'