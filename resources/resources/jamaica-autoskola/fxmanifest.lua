server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'Jamaica Scripts'
description 'Jamaica Auto-skola'
version '1.0'

shared_script '@ox_lib/init.lua'

client_scripts {
    'client.lua'
}

shared_scripts {
    'config.lua',
}
server_scripts {
   '@oxmysql/lib/MySQL.lua',
   'server.lua'
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/css/style.css',
    'web/js/script.js',
    'web/img/license-bike.jpg',
    'web/img/license-car.jpg',
    'web/img/license-truck.jpg',
}
