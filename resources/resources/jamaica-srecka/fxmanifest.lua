server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_script '@ox_lib/init.lua'

ui_page 'nui/index.html'

files {
	'nui/index.html',
	'nui/js/index.js',
	'nui/ui.js',
	'nui/css/style.css',
	'nui/logo.png',
	'nui/pop.mp3',
	'nui/win.mp3',
	'nui/lose.mp3',
}

client_scripts {
	'client.lua',
}

server_scripts {
	'server.lua',
}

dependencies {
	'es_extended',
	'ox_lib',
}
