server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name "MrNewbBeeKeeping"
description "A simple and fun beekeeping script for FiveM, focused on player owned hives and honey production."
author "MrNewb"
version "1.5.3"

shared_scripts {
	'@ox_lib/init.lua',
	'src/shared/config.lua',
	'src/shared/groundHashes.lua',
	'src/shared/zones.lua',
	'src/shared/init.lua',
}

client_script {
	'src/open/client/*.lua',
	'src/client/classes/*.lua',
	'src/client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'src/open/server/*.lua',
	'src/server/*.lua',
}

files {
	'locales/*.*',
}

dependencies {
	'/server:6116',
	'/onesync',
	'ox_lib',
	'community_bridge',
}

escrow_ignore {
	'src/shared/*.lua',     	-- Config files
	'src/open/client/*.lua',    -- open files
	'src/open/server/*.lua',    -- open files
}

data_file 'DLC_ITYP_REQUEST' 'stream/jim_g_beehive_prop.ytyp'
dependency '/assetpacks'