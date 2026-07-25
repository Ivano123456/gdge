return {
	{
		coords = vec3(463.1541, -1009.1578, 30.7074),
		target = {
			loc = vec3(463.1541, -1009.1578, 30.7074), --
			length = 1.2,
			width = 5.6,
			heading = 0,
			minZ = 29.49,
			maxZ = 32.09,
			label = 'Otvori licni ormaric'
		},
		name = 'policelocker',
		label = 'Licni ormaric',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = {['policija'] = 0}
	},

	{
		coords = vec3(301.3, -600.23, 43.28),
		target = {
			loc = vec3(301.82, -600.99, 43.29),
			length = 0.6,
			width = 1.8,
			heading = 340,
			minZ = 43.34,
			maxZ = 44.74,
			label = 'Open personal locker'
		},
		name = 'emslocker',
		label = 'Personal Locker',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = {['ambulance'] = 0}
	},
}
