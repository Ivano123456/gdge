client_script '@jamaica-pedovi/src/include/client.lua'


fx_version 'cerulean'
games {'gta5'}

author 'xxxx'
description 'xxxxx'
version '3.1'

files {
	'data/**/carvariations.meta',
	'data/**/handling.meta',
	'data/**/vehicles.meta',
	'data/**/vehiclelayouts.meta',
}

	data_file 'HANDLING_FILE'			'data/**/handling.meta'
	data_file 'VEHICLE_METADATA_FILE'	'data/**/vehicles.meta'
	data_file 'VEHICLE_VARIATION_FILE'	'data/**/carvariations.meta'
	data_file 'VEHICLE_LAYOUTS_FILE'	'data/**/vehiclelayouts.meta'

client_script 'vehicle_names.lua'

escrow_ignore {
    'vehicle_names.lua',
}

lua54 'yes'
dependency '/assetpacks'