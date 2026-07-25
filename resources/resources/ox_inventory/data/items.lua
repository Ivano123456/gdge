return {

	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},

	['black_money'] = {
		label = 'Prljav Novac',
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['lockpick'] = {
		label = 'Alat za Obijanje',
		weight = 160,
		rarity = 'uncommon',
		stack = true,
		description = 'Pomaze vam da obijete bravu nekih vrata.',
	},

	['money'] = {
		label = 'Money',
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		allowArmed = true
	},

	['armour'] = {
		label = 'Pancir',
		weight = 500,
		stack = true,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 3500
		}
	},

	['clothing'] = {
		label = 'Clothing',
		consume = 0,
	},

	['mastercard'] = {
		label = 'Fleeca Card',
		stack = false,
		weight = 10,
		client = {
			image = 'card_bank.png'
		}
	},

	['printer_document'] = {
		label = 'Document',
		weight = 10,
		stack = false,
		close = true,
		consume = 0,
		server = {
			export = 'p_dojjob.printer_document'
		}
	},

	['barut'] = {
		label = 'Barut',
		stack = true,
		close = true,
		description = 'Prah za municiju i oružje.',
	},

	['boombox'] = {
		label = 'Boombox',
		weight = 1000,
		stack = false
	},

	['vatromet'] = {
		label = 'Vatromet',
		weight = 800,
		stack = true,
		close = true,
		consume = 0,
		description = 'Kutija sa vatrometom. Potreban je upaljač za paljenje.',
		client = {
			export = 'jamaica-vatromet.pocniVatromet',
		},
	},

	['upaljac'] = {
		label = 'Upaljač',
		weight = 50,
		stack = true,
		close = true,
		description = 'Potreban za paljenje vatrometa.',
	},

	['binoculars'] = {
		label = 'Dvogled',
		weight = 500,
		stack = false,
		close = true,
		consume = 0,
		description = 'Koristi za uvećanje udaljenih objekata.',
		client = {
			export = 'jamaica_utils.koristiDvogled',
		},
	},
	
	['speed'] = {
		label = 'Speed',
		weight = 5,
		stack = true,
		close = true,
		description = 'Sirovi speed.',
	},

	['heroin'] = {
		label = 'Heroin',
		weight = 8,
		stack = true,
		close = true,
		description = 'Preradjen heroin.',
	},

	['cannabis'] = {
		label = 'Cannabis',
		weight = 8,
		stack = true,
		close = true,
		description = 'Biljka koja blago leci.',
	},

	['kesica_vutre'] = {
		label = 'Kesica vutre',
		weight = 5,
		stack = true,
		close = true,
		description = 'Preradjen cannabis u kesici, spreman za motanje.',
	},
	
	['megaphone'] = {
		label = 'Megaphone',
		weight = 500,
		consume = 0,
		client = {
			export = 'jraxion_megaphone.UseMegaphone',
		},
		stack = false,
	},
	

	['rizla'] = {
		label = 'Rizla',
		weight = 1,
		stack = true,
		close = true,
		description = 'Papir za motanje jointa. Potrebna kesica vutre.',
	},

	['joint'] = {
		label = 'Joint',
		weight = 8,
		stack = true,
		close = true,
		description = 'Marihuana za koristenje.',
	},

	['mdmu'] = {
		label = 'MDMA',
		weight = 8,
		stack = true,
		close = true,
		description = 'Daje pancir.',
	},

	['cocaine'] = {
		label = 'Kokain',
		weight = 8,
		stack = true,
		close = true,
		description = 'Supstanca koja daje armor.',
	},

	['cocaine_list'] = {
		label = 'Cocain List',
		weight = 8,
		stack = true,
		close = true,
		description = 'Sirovina sa polja cocain liste.',
	},

	['meth'] = {
		label = 'Meth',
		weight = 8,
		stack = true,
		close = true,
		description = 'Daje jaci speed boost.',
	},

	['supertableta'] = {
		label = 'Super Tableta',
		allowArmed = true,
		weight = 0,
		stack = true,
		description = 'Napredna tableta koja povecava brzinu trcanja za 400% na 60 sekundi i sprecava umor.',
		client = {
			anim = {
				dict = 'mp_player_intdrink',
				clip = 'loop_bottle'
			},
			disable = {
				move = false,
				car = false,
				combat = false
			},
			useWhileDead = false,
			usetime = 2500
		}
	},

	['superarmor'] = {
		label = 'Super Armor',
		weight = 1000,
		stack = false,
		close = true,
		description = 'Napredni pancir sa usporenjem kretanja.',
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 3500
		}
	},

	-- hrana
	['burger'] = {
		label = 'Burger',
		weight = 220,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate a delicious burger'
		},
	},

	['sandwich'] = {
		label = 'Sendvic',
		weight = 200,
		stack = true,
		close = true,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'Pojeo/la si sendvic.',
		},
	},

	['pizza'] = {
		label = 'Pizza',
		weight = 380,
		client = {
			status = { hunger = 300000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'Pojeo/la si pizzu.',
		},
	},

	['bs_hamburger'] = {
		label = 'Klasični Burger',
		weight = 280,
		client = {
			status = { hunger = 300000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'Pojeo/la si klasični burger.',
		},
	},

	['bs_cheeseburger'] = {
		label = 'Cheeseburger',
		weight = 300,
		client = {
			status = { hunger = 300000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'Pojeo/la si cheeseburger.',
		},
	},

	['bs_double_burger'] = {
		label = 'Double Burger',
		weight = 380,
		client = {
			status = { hunger = 350000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2800,
			notification = 'Pojeo/la si double burger.',
		},
	},

	['bs_chicken_burger'] = {
		label = 'Chicken Burger',
		weight = 290,
		client = {
			status = { hunger = 300000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'Pojeo/la si chicken burger.',
		},
	},

	['bs_fries'] = {
		label = 'Pomfrit',
		weight = 180,
		client = {
			status = { hunger = 150000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2000,
			notification = 'Pojeo/la si pomfrit.',
		},
	},

	['biftek'] = {
		label = 'Biftek',
		weight = 320,
		client = {
			status = { hunger = 300000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2800,
			notification = 'Pojeo/la si biftek.',
		},
	},

	['pasta'] = {
		label = 'Pasta',
		weight = 300,
		client = {
			status = { hunger = 300000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'Pojeo/la si pastu.',
		},
	},

	['waffle'] = {
		label = 'Waffle',
		weight = 180,
		client = {
			status = { hunger = 300000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2200,
			notification = 'Pojeo/la si waffle.',
		},
	},

	['baklava'] = {
		label = 'Baklava',
		weight = 120,
		client = {
			status = { hunger = 300000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2000,
			notification = 'Pojeo/la si baklavu.',
		},
	},

	['cevapi_desetka'] = {
		label = 'Ćevapi (desetka)',
		weight = 280,
		client = {
			status = { hunger = 350000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2800,
			notification = 'Pojeo/la si ćevape.',
		},
	},

	['cevapi_petica'] = {
		label = 'Ćevapi (petica)',
		weight = 200,
		client = {
			status = { hunger = 250000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'Pojeo/la si ćevape.',
		},
	},

	['burek'] = {
		label = 'Burek',
		weight = 240,
		client = {
			status = { hunger = 280000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'Pojeo/la si burek.',
		},
	},

	['sirnica'] = {
		label = 'Sirnica',
		weight = 220,
		client = {
			status = { hunger = 260000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2400,
			notification = 'Pojeo/la si sirnicu.',
		},
	},

	['zeljanica'] = {
		label = 'Zeljanica',
		weight = 220,
		client = {
			status = { hunger = 260000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2400,
			notification = 'Pojeo/la si zeljanicu.',
		},
	},

	['krompirusa'] = {
		label = 'Krompiruša',
		weight = 230,
		client = {
			status = { hunger = 260000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2400,
			notification = 'Pojeo/la si krompirušu.',
		},
	},

	-- pice
	['water'] = {
		label = 'Voda',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'Popio/la si osvezavajucu vodu.'
		}
	},

	['voda'] = {
		label = 'Voda',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'Popio/la si vodu.',
		},
	},

	['sprunk'] = {
		label = 'Sprunk',
		weight = 350,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'Popio/la si Sprunk.',
		},
	},

	['fizwiz'] = {
		label = 'Fizwiz',
		weight = 330,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'Popio/la si Fizwiz.',
		},
	},

	['jogurt'] = {
		label = 'Jogurt',
		weight = 300,
		client = {
			status = { thirst = 150000, hunger = 50000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'Popio/la si jogurt.',
		},
	},

	['pivo'] = {
		label = 'Pivo',
		weight = 400,
		client = {
			status = { thirst = 180000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'Popio/la si pivo.',
		},
	},

	['repairkit'] = {
		label = 'Alat za popravku',
		weight = 2000,
		stack = true,
		close = true,
		consume = 1,
		description = 'Koristi pored vozila da ga popravis.',
		client = {
			export = 'jamaica-mehanicar.useRepairKit',
		},
	},

	['gps_tracker'] = {
		label = 'GPS Tracker',
		weight = 150,
		stack = true,
		close = true,
		description = 'Sluzbena oprema — postavi na vozilo za pracenje 15 minuta.',
		client = {
			export = 'jamaica-sluzbe.useGpsTracker',
		},
	},

	['bodycam'] = {
		label = 'Body Kamera',
		weight = 200,
		stack = false,
		close = true,
		description = 'Sluzbena body kamera za snimanje u patroli.',
	},

	['dashcam'] = {
		label = 'Dash Kamera',
		weight = 300,
		stack = false,
		close = true,
		description = 'Sluzbena kamera za montazu na patrolno vozilo.',
	},

	['fingerprint'] = {
		label = 'Fingerprint skener',
		weight = 200,
		stack = false,
		close = true,
		description = 'Sluzbeni skener otiska prsta.',
	},

	--[[ sluzbe_gps iskljucen — koristi se drugi resurs za kolege
	['sluzbe_gps'] = {
		label = 'Sluzbeni GPS',
		weight = 200,
		stack = false,
		close = false,
	},
	]]

	['gps'] = {
		label = 'GPS',
		weight = 200,
		stack = false,
		close = true,
	},

	['keys'] = {
		label = 'Kljucevi',
		weight = 50,
		stack = false,
		close = false,
		server = {
			export = 'okokGarage.lockvehicle',
		},
	},

	['lisice'] = {
		label = 'Lisice',
		weight = 200,
		stack = true,
		close = true,
		description = 'Sluzbena oprema za vezivanje lica.',
	},

	['handcuff_key'] = {
		label = 'Kljuc za lisice',
		weight = 50,
		stack = true,
		close = true,
		description = 'Sluzbena oprema za skidanje lisica.',
	},

	['racechip'] = {
		label = 'Race Chip',
		weight = 100,
		stack = false,
		consume = 0,
		description = 'Koristi iz inventara za izbornik uličnih utrki.',
		client = {
			export = 'StreetRaces.useRaceChip',
		},
	},


	["gazbottle"] = {
		label = "Gas Bottle",
		weight = 2,
		stack = true,
		close = true,
	},

	["gold"] = {
		label = "Gold",
		weight = 1,
		stack = true,
		close = true,
	},

	["medikit"] = {
		label = "Medikit",
		weight = 2,
		stack = true,
		close = true,
	},

	["selfrevive"] = {
		label = "Self Revive",
		weight = 100,
		stack = true,
		close = true,
	},

	["adrenalin"] = {
		label = "Adrenalin",
		weight = 100,
		stack = true,
		close = true,
	},

	["packaged_plank"] = {
		label = "Packaged wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol"] = {
		label = "Oil",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol_raffin"] = {
		label = "Processed oil",
		weight = 1,
		stack = true,
		close = true,
	},

	["phone"] = {
		label = "Telefon",
		weight = 190,
		stack = false,
		close = true,
	},

	['classified_contract'] = {
		label = 'District Contract',
		weight = 50,
		stack = true,
		close = true,
		description = 'Pristupni ugovor za hitman misije.',
	},

	['jewels'] = {
		label = 'Nakit sa draguljima',
		weight = 200,
		stack = true,
		close = true,
		description = 'Dragocen nakit koristen kao deposit za ugovore.',
	},

	['redxtableta'] = {
		label = 'RedX Tableta',
		weight = 50,
		stack = true,
		close = true,
		description = 'Smanjuje stress za 10%.',
		client = {
			anim = { dict = 'mp_suicide', clip = 'pill', flag = 49 },
			disable = { move = true, car = true, combat = true },
			usetime = 3000,
			cancel = true,
			allowRagdoll = true,
			export = 'jamaica-stress.useRedXTablet',
		},
	},

	['ultrastresstableta'] = {
		label = 'Ultra Stress Tableta',
		weight = 50,
		stack = true,
		close = true,
		description = 'Potpuno uklanja stress. Samo za sluzbe.',
		client = {
			anim = { dict = 'mp_suicide', clip = 'pill', flag = 49 },
			disable = { move = true, car = true, combat = true },
			usetime = 3000,
			cancel = true,
			allowRagdoll = true,
			export = 'jamaica-stress.useUltraTablet',
		},
	},

	["outfit_bag"] = {
		label = "Outfit Bag",
		weight = 500,
		stack = false,
		close = true,
		client = {
			export = "wais-outfitbag.useBag"
		},
		metadata = {}
	},

	['casino_chips'] = {
		label = 'Kazino cipovi',
		weight = 0,
		stack = true,
		close = true,
		description = 'Cipovi za Diamond Casino. Menjaju se za novac kod blagajne.',
	},

	['srecka'] = {
		label = 'Grebalica',
		weight = 10,
		stack = true,
		close = true,
		description = 'Sastavi tri dijamanta i osvoji novcanu nagradu.',
	},

	-- lambra tunerchip
	["tunerchip1"] = {
		label = "Tuner Chip 1",
		weight = 250,
		stack = true,
		close = true
	},

	["tunerchip2"] = {
		label = "Tuner Chip 2",
		weight = 250,
		stack = true,
		close = true
	},

	["tunerchip3"] = {
		label = "Tuner Chip 3",
		weight = 250,
		stack = true,
		close = true
	},
	["tunerchipr"] = {
		label = "Chip removal",
		weight = 250,
		stack = true,
		close = true
	},

	['kutija'] = {
		label = 'Welcome Kutija',
		weight = 100,
		stack = true,
		close = true,
		description = 'Welcome spinner kutija — otvori je i osvoji nagradu za dobrodoslicu na server.',
		server = {
			export = 'jamaica-welcomee.useKutija',
		},
	},

	['nanospytablet'] = {
		label = 'Nano Spy Tablet',
		weight = 3,
		stack = false,
		close = true,
		description = 'Advanced surveillance tablet for monitoring spy devices',
	},

	['nanospymic'] = {
		label = 'Nano Spy Microphone',
		weight = 1,
		stack = true,
		close = true,
		description = 'Hidden surveillance microphone for audio monitoring',
	},

	['nanospycam'] = {
		label = 'Nano Spy Camera',
		weight = 1,
		stack = true,
		close = true,
		description = 'Hidden spy camera for visual surveillance',
	},

	['nanospygps'] = {
		label = 'Nano Spy GPS Tracker',
		weight = 1,
		stack = true,
		close = true,
		description = 'GPS tracking device for vehicle surveillance',
	},

	['digiscanner'] = {
		label = 'Digital Scanner',
		weight = 1,
		stack = true,
		close = true,
		description = 'Professional device scanner that can detect nearby spy devices through electromagnetic signatures',
	},

	['coal_ore'] = {
		label = 'Ugljena ruda',
		stack = true,
		close = true,
		description = 'Sirova ugljena ruda iz rudnika. Koristi se za crafting.',
	},

	['sulfur_chunk'] = {
		label = 'Komad sumpora',
		stack = true,
		close = true,
		description = 'Komad sumpora iz rudnika.',
	},

	['graphite_chunk'] = {
		label = 'Komad grafita',
		stack = true,
		close = true,
		description = 'Komad grafita iz rudnika.',
	},

	['quartz_crystal'] = {
		label = 'Kvarcni kristal',
		stack = true,
		close = true,
		description = 'Kvarcni kristal iz rudnika.',
	},

	['corundum_chunk'] = {
		label = 'Komad korunda',
		stack = true,
		close = true,
		description = 'Komad korunda iz rudnika.',
	},

	['diamond_crystal'] = {
		label = 'Dijamantski kristal',
		stack = true,
		close = true,
		description = 'Dijamantski kristal iz rudnika.',
	},

	['emerald_ring'] = {
		label = 'Smaragdni prsten',
		weight = 85,
		stack = true,
		close = true,
		description = 'Prsten sa smaragdnim kristalom.',
	},

	['emerald_necklace'] = {
		label = 'Smaragdna ogrlica',
		weight = 105,
		stack = true,
		close = true,
		description = 'Ogrlica sa smaragdnim kristalom.',
	},

	['ruby_ring'] = {
		label = 'Rubinski prsten',
		weight = 85,
		stack = true,
		close = true,
		description = 'Prsten sa rubinskim kristalom.',
	},

	['ruby_necklace'] = {
		label = 'Rubinska ogrlica',
		weight = 105,
		stack = true,
		close = true,
		description = 'Ogrlica sa rubinskim kristalom.',
	},

	['diamond_ring'] = {
		label = 'Dijamantski prsten',
		weight = 90,
		stack = true,
		close = true,
		description = 'Prsten sa dijamantskim kristalom.',
	},

	['diamond_necklace'] = {
		label = 'Dijamantska ogrlica',
		weight = 110,
		stack = true,
		close = true,
		description = 'Ogrlica sa dijamantskim kristalom.',
	},

	-- kontenjeri crafting
	['celicni_ostaci'] = {
		label = 'Čelični ostaci',
		stack = true,
		close = true,
		description = 'Komadi čelika iz kontejnera. Osnova za sklapanje oružja.',
	},

	['plastika'] = {
		label = 'Plastika',
		stack = true,
		close = true,
		description = 'Plastični delovi iz kontejnera. Koristi se za kundak i kućište.',
	},

	['bakar_zica'] = {
		label = 'Bakar žica',
		stack = true,
		close = true,
		description = 'Bakar iz kontejnera. Za ožičenje i precizne delove oružja.',
	},

	['guma'] = {
		label = 'Guma',
		stack = true,
		close = true,
		description = 'Gumeni delovi iz kontejnera. Za rukohvat i amortizaciju.',
	},

	['srafovi'] = {
		label = 'Šrafovi',
		stack = true,
		close = true,
		description = 'Metalni šrafovi iz kontejnera. Za sklapanje oružja i opreme.',
	},

	['opruga'] = {
		label = 'Opruga',
		stack = true,
		close = true,
		description = 'Opruga iz kontejnera. Del mehanizma oružja.',
	},

	['prazna_cahura'] = {
		label = 'Prazna čahura',
		stack = true,
		close = true,
		description = 'Prazna čahura iz kontejnera. Pomaže pri pravljenju municije.',
	},

	['elektronski_otpad'] = {
		label = 'Elektronski otpad',
		stack = true,
		close = true,
		description = 'Elektronski otpad iz kontejnera. Za naprednije komade oružja.',
	},

	['balisticno_platno'] = {
		label = 'Balističko platno',
		stack = true,
		close = true,
		description = 'Ojačano platno iz kontejnera. Za sklapanje pancira.',
	},

	['scrap_metal'] = {
		label = 'Metalni Otpad',
		stack = true,
		close = true,
		description = 'Staro gvožđe iz smeća.',
	},

	['old_armor'] = {
		label = 'Stari pancir',
		stack = true,
		close = true,
		description = 'Oštećeni pancir za reciklažu.',
	},

	['weapon_parts'] = {
		label = 'Delovi za Oružje',
		stack = true,
		close = true,
		description = 'Razni delovi za sklapanje oružja.',
	},

	-- d3MBA money print
	['money_print_sheet'] = {
		label = 'List za štampu',
		weight = 120,
		stack = true,
		close = true,
		description = 'Papir za štampanje novčanica.',
	},

	['money_print_black_ink'] = {
		label = 'Crno mastilo',
		weight = 250,
		stack = true,
		close = true,
		description = 'Crno mastilo za mašinu za štampanje novca.',
	},

	['money_print_color_ink'] = {
		label = 'Kolor mastilo',
		weight = 250,
		stack = true,
		close = true,
		description = 'Kolor mastilo za mašinu za štampanje novca.',
	},

	['money_print_microscope'] = {
		label = 'Mikroskop',
		weight = 2000,
		stack = true,
		close = true,
		description = 'Za overu odštampanog lista novca.',
	},

	['money_print_printer'] = {
		label = 'Štampač',
		weight = 200,
		stack = true,
		close = true,
		description = 'Prenosni štampač za ekstrakciju mastila.',
	},

	['money_print_hacking_laptop'] = {
		label = 'Laptop za hakovanje',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Za hakovanje i dobijanje kolor šablona.',
	},

	['money_print_black_blueprint_1'] = {
		label = 'Crni šablon 20$',
		weight = 100,
		stack = true,
		close = true,
		description = 'Šablon sa receptom mastila za novčanicu od 20$.',
	},

	['money_print_black_blueprint_2'] = {
		label = 'Crni šablon 50$',
		weight = 100,
		stack = true,
		close = true,
		description = 'Šablon sa receptom mastila za novčanicu od 50$.',
	},

	['money_print_black_blueprint_3'] = {
		label = 'Crni šablon 100$',
		weight = 100,
		stack = true,
		close = true,
		description = 'Šablon sa receptom mastila za novčanicu od 100$.',
	},

	['money_print_color_blueprint_1'] = {
		label = 'Kolor šablon 20$',
		weight = 100,
		stack = true,
		close = true,
		description = 'Kolor šablon sa receptom mastila za novčanicu od 20$.',
	},

	['money_print_color_blueprint_2'] = {
		label = 'Kolor šablon 50$',
		weight = 100,
		stack = true,
		close = true,
		description = 'Kolor šablon sa receptom mastila za novčanicu od 50$.',
	},

	['money_print_color_blueprint_3'] = {
		label = 'Kolor šablon 100$',
		weight = 100,
		stack = true,
		close = true,
		description = 'Kolor šablon sa receptom mastila za novčanicu od 100$.',
	},

	['money_print_printed_money_sheet_1'] = {
		label = 'Odštampani list novca 20$',
		weight = 150,
		stack = true,
		close = true,
		description = 'Odštampani list novčanica od 20$. Iseci na stolu ili overi mikroskopom.',
	},

	['money_print_printed_money_sheet_2'] = {
		label = 'Odštampani list novca 50$',
		weight = 150,
		stack = true,
		close = true,
		description = 'Odštampani list novčanica od 50$. Iseci na stolu ili overi mikroskopom.',
	},

	['money_print_printed_money_sheet_3'] = {
		label = 'Odštampani list novca 100$',
		weight = 150,
		stack = true,
		close = true,
		description = 'Odštampani list novčanica od 100$. Iseci na stolu ili overi mikroskopom.',
	},

	['money_print_certified_money_sheet_1'] = {
		label = 'Overeni list novca 20$',
		weight = 150,
		stack = true,
		close = true,
		description = 'Overeni list novčanica od 20$, spreman za sečenje.',
	},

	['money_print_certified_money_sheet_2'] = {
		label = 'Overeni list novca 50$',
		weight = 150,
		stack = true,
		close = true,
		description = 'Overeni list novčanica od 50$, spreman za sečenje.',
	},

	['money_print_certified_money_sheet_3'] = {
		label = 'Overeni list novca 100$',
		weight = 150,
		stack = true,
		close = true,
		description = 'Overeni list novčanica od 100$, spreman za sečenje.',
	},

	-- tk_jail
	['ankle_monitor'] = {
		label = 'Elektronska narukvica',
		weight = 500,
		stack = true,
		close = true,
		description = 'Sluzbena oprema za pracenje zatvorenika na uslovnoj slobodi.',
	},

	['power_saw'] = {
		label = 'Elektricna testera',
		weight = 5000,
		stack = true,
		close = true,
		description = 'Sluzbena oprema za skidanje elektronske narukvice.',
	},

	['prisunflower'] = {
		label = 'Zatvorski suncokret',
		weight = 50,
		stack = true,
		close = false,
	},

	['prisunflower_seed'] = {
		label = 'Seme zatvorskog suncokreta',
		weight = 10,
		stack = true,
		close = true,
	},

	['watering_can'] = {
		label = 'Kanta za zalivanje',
		weight = 2500,
		stack = true,
		close = false,
	},

	['jail_chemicals'] = {
		label = 'Hemikalije',
		weight = 10,
		stack = true,
		close = false,
	},

	['slammer'] = {
		label = 'Slammer',
		weight = 10,
		stack = true,
		close = false,
	},

	['jail_lab_tools'] = {
		label = 'Laboratorijska oprema',
		weight = 100,
		stack = true,
		close = false,
	},

	['jail_cigarette'] = {
		label = 'Zatvorska cigareta',
		weight = 10,
		stack = true,
		close = false,
	},

	['jail_lighter'] = {
		label = 'Rucno napravljen upaljac',
		weight = 50,
		stack = true,
		close = true,
	},

	['jail_explosive'] = {
		label = 'Rucno napravljena eksplozivna naprava',
		weight = 500,
		stack = true,
		close = true,
	},

	['plastic_knife'] = {
		label = 'Plasticni noz',
		weight = 5,
		stack = true,
		close = false,
	},

	['plastic_spoon'] = {
		label = 'Plasticna kasika',
		weight = 5,
		stack = true,
		close = false,
	},

	['plastic_fork'] = {
		label = 'Plasticna viljuska',
		weight = 5,
		stack = true,
		close = false,
	},

	['sharpened_plastic_knife'] = {
		label = 'Naocreni plasticni noz',
		weight = 5,
		stack = true,
		close = true,
	},

	['sharpened_plastic_spoon'] = {
		label = 'Naocrena plasticna kasika',
		weight = 5,
		stack = true,
		close = true,
	},

	['sharpened_plastic_fork'] = {
		label = 'Naocrena plasticna viljuska',
		weight = 5,
		stack = true,
		close = true,
	},

	['freedom_chip'] = {
		label = 'A32 cip za slobodu',
		weight = 10,
		stack = true,
		close = true,
	},

	['fence_cutters'] = {
		label = 'Sekac za ogradu',
		weight = 1000,
		stack = true,
		close = true,
	},

	['jail_shovel'] = {
		label = 'Rucno napravljena lopata',
		weight = 3000,
		stack = true,
		close = true,
	},

	['jail_security_card'] = {
		label = 'Zatvorska sigurnosna kartica',
		weight = 50,
		stack = true,
		close = false,
	},

	['battery'] = {
		label = 'Baterija',
		weight = 250,
		stack = true,
		close = false,
	},

	['metal_scrap'] = {
		label = 'Metalni otpad',
		weight = 10,
		stack = true,
		close = false,
	},

	['electronic_scrap'] = {
		label = 'Elektronski otpad',
		weight = 10,
		stack = true,
		close = false,
	},

	['plastic_scrap'] = {
		label = 'Plasticni otpad',
		weight = 10,
		stack = true,
		close = false,
	},

	['tape'] = {
		label = 'Lepila traka',
		weight = 10,
		stack = true,
		close = false,
	},

	['electric_cable'] = {
		label = 'Elektricni kabl',
		weight = 10,
		stack = true,
		close = false,
	},

	['metal_pipe'] = {
		label = 'Metalna cev',
		weight = 10,
		stack = true,
		close = false,
	},

	['tin_foil'] = {
		label = 'Aluminijumska folija',
		weight = 10,
		stack = true,
		close = false,
	},

	['gunpowder'] = {
		label = 'Barut',
		weight = 10,
		stack = true,
		close = false,
	},

	['prison_mdt'] = {
		label = 'Zatvorski MDT',
		weight = 100,
		stack = true,
		close = true,
		description = 'Sluzbeni tablet za upravljanje zatvorenima i uslovnom slobodom.',
	},

	-- projectx fleeca pljacka
	['x_device'] = {
		label = 'Hakerski uredjaj',
		weight = 125,
		stack = false,
		close = true,
		description = 'Elektronski uredjaj za hakovanje sigurnosnih sistema.',
	},

	['x_laptop'] = {
		label = 'Hakerski laptop',
		weight = 1500,
		stack = false,
		close = true,
		description = 'Prenosni laptop za pristup bankarskim sistemima.',
	},

	['pliers'] = {
		label = 'Klesta',
		weight = 200,
		stack = true,
		close = true,
		description = 'Alat za secenje zica i kablova.',
	},

	['bag'] = {
		label = 'Torba za pljacku',
		weight = 400,
		stack = false,
		close = true,
		description = 'Velika torba za prenos ukradene robe.',
	},

	['fleecacard'] = {
		label = 'Fleeca kartica',
		weight = 25,
		stack = false,
		close = true,
		description = 'Sigurnosna kartica za pristup Fleeca banci.',
	},

	['employeepictures'] = {
		label = 'Slike zaposlenih',
		weight = 25,
		stack = false,
		close = true,
		description = 'Fotografije zaposlenih u banci.',
	},

	['x_phone'] = {
		label = 'Hakerski telefon',
		weight = 100,
		stack = false,
		close = true,
		description = 'Modifikovani telefon za elektronske prodire.',
	},

	['x_stethoscope'] = {
		label = 'Elektronski stetoskop',
		weight = 150,
		stack = false,
		close = true,
		description = 'Uredjaj za osluskivanje sefova i brava.',
	},

	['goldbar'] = {
		label = 'Zlatna poluga',
		weight = 500,
		stack = true,
		close = true,
		description = 'Poluga cistog zlata iz trezora.',
	},

	['diamond'] = {
		label = 'Dijamant',
		weight = 50,
		stack = true,
		close = true,
		description = 'Vredan dijamant iz trezora.',
	},

	-- projectx mxc vangelico jewelry heist
	['glass_cutter'] = {
		label = 'Rezac stakla',
		weight = 1000,
		stack = false,
		close = true,
		description = 'Alat za secenje stakla na zlatarskim vitrinama.',
	},

	['x_circuittester'] = {
		label = 'Tester strujnih kola',
		weight = 200,
		stack = false,
		close = true,
		description = 'Uredjaj za testiranje elektricnih kola u zlatari.',
	},

	['mxckey'] = {
		label = 'MXC kljuc',
		weight = 200,
		stack = false,
		close = true,
		description = 'Poseban kljuc za pristup MXC zlatari.',
	},

	['x_fingerprintbag'] = {
		label = 'Kesica za otiske',
		weight = 200,
		stack = false,
		close = true,
		description = 'Kesica za cuvanje otisaka prstiju.',
	},

	['x_fingerprinttape'] = {
		label = 'Traka za otiske',
		weight = 200,
		stack = false,
		close = true,
		description = 'Specijalna traka za uzimanje otisaka prstiju.',
	},

	['thermite'] = {
		label = 'Termit',
		weight = 500,
		stack = true,
		close = true,
		description = 'Eksplozivna smesa za probijanje sigurnosnih vrata.',
	},

	['box_of_jewelry'] = {
		label = 'Kutija nakita',
		weight = 2500,
		stack = false,
		close = true,
		description = 'Kutija puna ukradenog nakita iz zlatarne.',
	},

	['x_panther_gem'] = {
		label = 'Panterski dragulj',
		weight = 2500,
		stack = false,
		close = true,
		description = 'Retki panterski dragulj iz VIP izloga.',
	},

	['giant_gem'] = {
		label = 'Veliki dragulj',
		weight = 2500,
		stack = false,
		close = true,
		description = 'Ogroman dragulj iz zlatarske vitrine.',
	},

	['giant_gem_green'] = {
		label = 'Veliki zeleni dragulj',
		weight = 2500,
		stack = false,
		close = true,
		description = 'Ogroman zeleni dragulj iz VIP izloga.',
	},

	['gem_necklace'] = {
		label = 'Draguljska ogrlica',
		weight = 2500,
		stack = false,
		close = true,
		description = 'Raskosna ogrlica sa draguljima iz zlatarne.',
	},

	['sapphire_necklace'] = {
		label = 'Safirna ogrlica',
		weight = 200,
		stack = true,
		close = true,
		description = 'Ogrlica sa safirnim kristalom.',
	},

	['sapphire_ring'] = {
		label = 'Safirni prsten',
		weight = 200,
		stack = true,
		close = true,
		description = 'Prsten sa safirnim kristalom.',
	},

	['sapphire_earring'] = {
		label = 'Safirne mindjuse',
		weight = 200,
		stack = true,
		close = true,
		description = 'Mindjuse sa safirnim kristalom.',
	},

	['diamond_earring'] = {
		label = 'Dijamantske mindjuse',
		weight = 200,
		stack = true,
		close = true,
		description = 'Mindjuse sa dijamantskim kristalom.',
	},

	['ruby_earring'] = {
		label = 'Rubinske mindjuse',
		weight = 200,
		stack = true,
		close = true,
		description = 'Mindjuse sa rubinskim kristalom.',
	},

	['emerald_earring'] = {
		label = 'Smaragdne mindjuse',
		weight = 200,
		stack = true,
		close = true,
		description = 'Mindjuse sa smaragdnim kristalom.',
	},

	['pacificcard'] = {
		label = 'Pacific kartica',
		weight = 25,
		stack = false,
		close = true,
		description = 'Sigurnosna kartica za pristup Pacific banci.',
	},

	-- tk houserobbery
	['cutter'] = {
		label = 'Rezac stakla',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Alat za secenje stakla na vitrinama i displejima.',
	},

	['silver_coin'] = {
		label = 'Srebrni novcic',
		weight = 50,
		stack = true,
		close = true,
		description = 'Stari srebrni novcic pronadjen u kuci.',
	},

	['gold_coin'] = {
		label = 'Zlatni novcic',
		weight = 50,
		stack = true,
		close = true,
		description = 'Stari zlatni novcic pronadjen u kuci.',
	},

	['charlotte_ring'] = {
		label = 'Charlotte prsten',
		weight = 50,
		stack = true,
		close = true,
		description = 'Vredan prsten ukraden iz kuce.',
	},

	['simbolos_chain'] = {
		label = 'Simbolos lanac',
		weight = 100,
		stack = true,
		close = true,
		description = 'Zlatni lanac ukraden iz kuce.',
	},

	['action_figure'] = {
		label = 'Akciona figura',
		weight = 100,
		stack = true,
		close = true,
		description = 'Kolekcionarska akciona figura.',
	},

	['nominos_ring'] = {
		label = 'Nominos prsten',
		weight = 50,
		stack = true,
		close = true,
		description = 'Vredan prsten ukraden iz kuce.',
	},

	['boss_chain'] = {
		label = 'BOSS lanac',
		weight = 200,
		stack = true,
		close = true,
		description = 'Tezak zlatni lanac ukraden iz kuce.',
	},

	['branded_cigarette'] = {
		label = 'Brendirana cigareta',
		weight = 10,
		stack = true,
		close = true,
		description = 'Pakovanje skupih cigareta.',
	},

	['branded_cigarette_box'] = {
		label = 'Brendirana paklica',
		weight = 200,
		stack = true,
		close = true,
		description = 'Celokupna paklica brendiranih cigareta.',
	},

	['ninja_figure'] = {
		label = 'Ninja figura',
		weight = 50,
		stack = true,
		close = true,
		description = 'Kolekcionarska ninja figura.',
	},

	['painting'] = {
		label = 'Slika',
		weight = 100,
		stack = true,
		close = true,
		description = 'Ukradena slika sa zida.',
	},

	['statue'] = {
		label = 'Statua',
		weight = 200,
		stack = true,
		close = true,
		description = 'Ukradena ukrasna statua.',
	},

	['ancient_egypt_artifact'] = {
		label = 'Drevni egipatski artefakt',
		weight = 200,
		stack = true,
		close = true,
		description = 'Retki egipatski artefakt velike vrednosti.',
	},

	['ruby'] = {
		label = 'Rubin',
		weight = 100,
		stack = true,
		close = true,
		description = 'Dragoceni rubin iz staklene vitrine.',
	},

	['danburite'] = {
		label = 'Danburit',
		weight = 100,
		stack = true,
		close = true,
		description = 'Retki dragi kamen velike vrednosti.',
	},

	['trading_painting'] = {
		label = 'Trgovacka slika',
		weight = 100,
		stack = true,
		close = true,
		description = 'Ukradena slika pogodna za otkup.',
	},

	['television'] = {
		label = 'Televizor',
		weight = 5000,
		stack = false,
		close = true,
		description = 'Ukraden flat televizor iz kuce.',
	},

	['music_player'] = {
		label = 'Muzicki aparat',
		weight = 2000,
		stack = false,
		close = true,
		description = 'Ukraden radio ili muzicki aparat.',
	},

	['microwave'] = {
		label = 'Mikrotalasna',
		weight = 3500,
		stack = false,
		close = true,
		description = 'Ukradena mikrotalasna pecnica.',
	},

	['computer'] = {
		label = 'Racunar',
		weight = 2500,
		stack = false,
		close = true,
		description = 'Ukraden desktop racunar.',
	},

	['coffee_machine'] = {
		label = 'Aparat za kafu',
		weight = 1000,
		stack = false,
		close = true,
		description = 'Ukraden aparat za kafu.',
	},

	-- beekeping
	['beehive'] = {
		label = 'Kosnica',
		weight = 2000,
		stack = false,
		close = true,
	},

	['queen_bee'] = {
		label = 'Matica',
		weight = 10,
		stack = true,
		close = true,
	},

	['worker_bees'] = {
		label = 'Radilice',
		weight = 10,
		stack = true,
		close = true,
	},

	['bees_wax'] = {
		label = 'Pcelinji vosak',
		weight = 1,
		stack = true,
		close = true,
	},

	['red_honey'] = {
		label = 'Crveni pcelinji med',
		weight = 1,
		stack = true,
		close = true,
	},

	['green_honey'] = {
		label = 'Zeleni pcelinji med',
		weight = 1,
		stack = true,
		close = true,
	},

	['blue_honey'] = {
		label = 'Plavi pcelinji med',
		weight = 1,
		stack = true,
		close = true,
	},

	['bees_honey'] = {
		label = 'Pcelinji med',
		weight = 1,
		stack = true,
		close = true,
	},

	['id_card'] = {
		label = 'Licna karta',
		weight = 1,
		stack = false,
		close = true,
		description = 'Dokument sa tvojim podacima za identifikaciju.',
	},

	['job_card'] = {
		label = 'Sluzbena kartica',
		weight = 1,
		stack = false,
		close = true,
		description = 'Sluzbena identifikaciona kartica.',
	},

	['fake_id_card'] = {
		label = 'Lazna licna karta',
		weight = 1,
		stack = false,
		close = true,
		description = 'Lazni dokument sa tudjim podacima.',
	},

	['fake_job_card'] = {
		label = 'Lazna sluzbena kartica',
		weight = 1,
		stack = false,
		close = true,
		description = 'Lazna sluzbena identifikaciona kartica.',
	},

	['driver_license'] = {
		label = 'Vozacka dozvola',
		weight = 1,
		stack = false,
		close = true,
		description = 'Dozvola za upravljanje vozilom.',
	},

	['weapons_license'] = {
		label = 'Dozvola za oruzje',
		weight = 1,
		stack = false,
		close = true,
		description = 'Dozvola za posedovanje i koriscenje oruzja.',
	},

	-- wasabi pacific
	['thermite_bomb'] = {
		label = 'Termit bomba',
		weight = 5,
		stack = true,
		close = true,
		description = 'Termit bomba za probijanje metalnih prepreka.',
	},

	['c4_bomb'] = {
		label = 'C4 bomba',
		weight = 5,
		stack = true,
		close = true,
		description = 'C4 eksploziv za razbijanje zakljucanih objekata.',
	},

	['drill'] = {
		label = 'Busilica',
		weight = 5,
		stack = true,
		close = true,
		description = 'Busilica za otvaranje sefova i brava.',
	},

	['laptop'] = {
		label = 'Laptop',
		weight = 5,
		stack = true,
		close = true,
		description = 'Laptop za hakovanje sistema.',
	},

	['usb_stick'] = {
		label = 'USB stick',
		weight = 5,
		stack = true,
		close = true,
		description = 'USB stick sa podacima.',
	},

	['antique_bottle'] = {
		label = 'Anticka boca',
		weight = 5,
		stack = true,
		close = true,
		description = 'Retka anticka boca.',
	},

	['gold_bar'] = {
		label = 'Zlatna poluga',
		weight = 5,
		stack = true,
		close = true,
		description = 'Poluga cistog zlata.',
	},

	['gold_monkey'] = {
		label = 'Zlatni majmun',
		weight = 5,
		stack = true,
		close = true,
		description = 'Zlatna figura majmuna.',
	},

	['lapis_panther'] = {
		label = 'Lapis panter',
		weight = 5,
		stack = true,
		close = true,
		description = 'Skulptura pantera od lapisa.',
	},

	['platinum_bar'] = {
		label = 'Platinasta poluga',
		weight = 5,
		stack = true,
		close = true,
		description = 'Poluga ciste platine.',
	},

	['rembrandt'] = {
		label = 'Rembrandt',
		weight = 5,
		stack = true,
		close = true,
		description = 'Vredna Rembrandtova slika.',
	},

	['ruby_diamond'] = {
		label = 'Rubinski dijamant',
		weight = 5,
		stack = true,
		close = true,
		description = 'Retki rubinski dijamant.',
	},

	['van_gogh'] = {
		label = 'Van Gogh',
		weight = 5,
		stack = true,
		close = true,
		description = 'Vredna Van Goghova slika.',
	},
}