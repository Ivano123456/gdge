server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




-- Author: Ayazwai
-- Github: https://github.com/ayazwai
-- Discord: https://discord.gg/0resmon
-- LinkendIn: https://www.linkedin.com/in/ayaz-ekrem-770305212/

use_experimental_fxv2_oal 'yes'
fx_version 'bodacious'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]]--

author 'Ayazwai'
version '1.0.2'
scriptname 'wais-outfitbag'
description 'A clothing outfit bag system for FiveM supporting multiple frameworks and appearance systems.'

--[[ Resource Information ]]--

shared_scripts {
    'config.lua',
    'locales/*.lua',
    'bridge/framework.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'bridge/editable/utils.lua',
    'bridge/editable/client.lua',
    'bridge/esx/client.lua',
    'bridge/qb/client.lua',
    'client/client.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'bridge/editable/server.lua',
    'bridge/esx/server.lua',
    'bridge/qb/server.lua',
    'server/editable.lua',
    'server/server.lua',
}

escrow_ignore {
    'config.lua',
    'locales/*.lua',
    'server/editable.lua',
    'bridge/editable/*.lua',
    '!ITEMS/*.lua',
}

dependencys {
    'ox_lib',
}

ui_page "web/dist/index.html"
files {
    'web/dist/*.js',
    'web/dist/index.html',

    'web/public/**/*.png',
    'web/public/css/*.*',
    'web/public/locales/*.json',
}

dependency '/assetpacks'