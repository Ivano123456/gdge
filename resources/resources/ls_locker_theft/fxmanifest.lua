server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
games      { 'gta5' }
lua54 'yes'

author 'Lith Studios | Swizz'
description 'Post locker theft'
version '1.1.2'

ui_page "nui/index.html"

server_scripts {
    'server/editables/editables.lua',
    'server/editables/dispatch.lua',
    'server/editables/min_police.lua',
    'server/server_sync.lua',
    'server/server_units.lua',
    'server/server_cells.lua',
    'server/editables/loot.lua'
}

client_scripts {
    'client/editables/editables.lua',
    'client/helpers.lua',
    'client/client_sync.lua',
    'client/client_cells.lua',
    'client/editables/locker_cell_editables.lua',
    'client/editables/carry.lua',
    'client/client_units.lua',
    'client/editables/locker_unit_editables.lua',
    'client/editables/commands.lua'
}

shared_scripts {
    'hasher.lua',
    'locale.lua',
    'config.lua',
    'shared.lua'
}

escrow_ignore {
    'client/editables/*',
    'server/editables/*',
    'sound/*',
    'config.lua',
    'locale.lua',
    'shared.lua',
}
files {
    'nui/*'
}
dependencies {
    '/assetpacks',
    'kq_link',
    'jamaica-sluzbe',
}