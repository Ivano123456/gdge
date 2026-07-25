server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'

name 'jamaica-glavnimenu'

author 'Jamaica RP'
description 'Jamaica — Shop, Battlepass, Kutije, Dnevne nagrade'
version '1.0.0'

lua54 'yes'

dependencies {
    'es_extended',
    'oxmysql',
}

shared_scripts {
    'config.lua',
    'config_cases.lua',
    'config_battlepass.lua'
}

client_scripts {
    'client/main.lua',
    'client/missions.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/discord_config.lua',
    'server/discord.lua',
    'server/helpers.lua',
    'server/coins.lua',
    'server/battlepass.lua',
    'server/cases.lua',
    'server/stash.lua',
    'server/daily.lua',
    'server/missions.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/*.svg',
    'html/img/*.png',
    'html/img/**/*.png',
    'html/images/*.png',
}
