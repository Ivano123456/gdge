server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'

shared_script '@ox_lib/init.lua'

client_script 'client.lua'
server_script 'server.lua'

exports {
    'pocniVatromet',
}

dependencies {
    'ox_lib',
}
