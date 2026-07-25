fx_version "cerulean"
game 'gta5'
version '2.0.0'

description "lambra.tebex.io"
author "Delbes"

lua54 'yes'



shared_script '@ox_lib/init.lua'

--shared_script '@qbx_core/modules/lib.lua'
--client_script '@qbx_core/modules/playerdata.lua'


files {
	'data/lambratunerchip_sounds.dat54.rel',
	'audiodirectory/tunerchip_sounds.awc'
}

data_file 'AUDIO_WAVEPACK' 'audiodirectory'
data_file 'AUDIO_SOUNDDATA' 'data/lambratunerchip_sounds.dat'
data_file 'PTFX_ASSET' 'stream/veh_xs_vehicle_mods.ypt'

shared_scripts {
    'config.lua',
    'server/version.lua'
}


client_script 'framework/client.lua'
client_script 'client/handling.lua'
client_script 'client/main.lua'

server_script '@oxmysql/lib/MySQL.lua'
server_script 'framework/server.lua'
server_script 'server/main.lua'



escrow_ignore {
    'framework/client.lua',
    'framework/server.lua',
    "config.lua"
}

dependencies {
    '/onesync',                    -- requires state awareness to be enabled
    '/gameBuild:2060',               -- requires at least game build 2060
}

dependency '/assetpacks'