server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
lua54 'yes'
deskripcija 'skripta za dokumente'
autor 'vule.gg'

shared_scripts {
   '@es_extended/imports.lua',
   '@ox_lib/init.lua'
}

client_scripts {
    'cl_main.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'sv_main.lua'
}

ui_page 'src/index.html'
files {
    'src/*.*',
    'src/assets/*.*',
    'shared.lua'
}
