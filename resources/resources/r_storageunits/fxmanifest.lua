server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'
---@diagnostic disable: undefined-global

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'r_storageunits'
description 'Advanced Storage Units System for FiveM'
author 'r_scripts'
version '2.1.1'

shared_scripts {
  '@ox_lib/init.lua',
  'utils/shared.lua',
  'locales/*.lua',
  'configs/*.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'utils/server.lua',
  'core/server/*.lua',
}

client_scripts {
  'utils/client.lua',
  'core/client/*.lua',
}

ui_page 'nui/build/index.html'
files {
  'nui/build/index.html',
  'nui/build/**/*'
}

dependencies {
  'ox_lib',
  'r_bridge',
  'oxmysql'
}

escrow_ignore {
  'core/server/webhook.lua',
  'install/**/*.*',
  'locales/*.*',
  'configs/*.lua',
}
dependency '/assetpacks'