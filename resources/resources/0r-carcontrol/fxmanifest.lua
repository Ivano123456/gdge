server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'
fx_version 'adamant'
game 'gta5'
lua54 'yes'

ui_page 'ui/index.html'

author 'vezironi'
description 'Car control script built for fivem that looks up to date and modern'

version '1.0.2'

files {
    "ui/fonts/*.ttf",
    "ui/fonts/*.otf",
    "ui/img/*.**",
    "ui/index.html",
    "ui/script.js",
    "ui/style.css",
}

shared_scripts {
    'shared/**.lua'
}

client_scripts {
    'client/**.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    -- '@mysql-async/lib/MySQL.lua', -- if you are using ESX framework uncommand this
    'server/**.lua'
}

escrow_ignore {
    'shared/**.lua',
    'client/**.lua',
    'server/**.lua'
}
dependency '/assetpacks'
dependency '/assetpacks'