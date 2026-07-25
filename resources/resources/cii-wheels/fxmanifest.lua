client_script '@jamaica-pedovi/src/include/client.lua'


fx_version 'cerulean'

game 'gta5'
lua54 'yes'

client_script {
    'client/vehicle_names.lua'
}

files{
    'data/carcols.meta'
}

data_file 'CARCOLS_FILE' 'data/carcols.meta'
dependency '/assetpacks'