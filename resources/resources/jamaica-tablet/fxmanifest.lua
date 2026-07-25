server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'

description 'Jamaica MDT — policijski tablet'
version '2.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

server_export 'BroadcastRecordRemoved'
server_export 'GetWantedStars'
server_export 'ResolveJailMinutesForWanted'
server_export 'ClearWarrantsOnJail'
server_export 'ClearWantedOnJail'

client_scripts {
    'client/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/api.js',
    'html/app.js'
}


dependencies {
    'es_extended',
    'ox_lib',
    'oxmysql'
}
