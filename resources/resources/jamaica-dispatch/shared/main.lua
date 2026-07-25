return {

    FrameworkNames = {
        esx = 'es_extended',
        qbox = 'qb-core',
        qb = 'qb-core'
    },

    EventListeneri = {
         onPlayerDeath = "esx:onPlayerDeath",
    },

    PolicijskiPoslovi = { 'police' },
    AmbulancijskiPoslovi = { 'hitna', 'ambulance', 'doa' },
    panicButtonCommand = 'sos',
    panicButtonKey = '',

    Dodaci = {
       ['PanicButton'] = {
          naSmrtiIgraca = false, -- # false | true --  ako je ovo na false igrac mora ukucati komandu ili keybind u suprotnom automatski cim umre ako je u policijskoj sluzbi ce se pozvati panic button 
          enablajKomandu = true, -- # sama rec kaze | Ako ovo ugasis ni keymaping ne radi takodje...
        },
        ['Tucnjava'] = false, -- # aktiviraj | deaktiviraj *dojavu*
        ['Eksplozija'] = false, -- # aktiviraj | deaktiviraj *dojavu*
        ['ObijanjeVozila'] = false, -- # aktiviraj | deaktiviraj *dojavu*
        ['OtimanjeVozila'] = false, -- # aktiviraj | deaktiviraj *dojavu*
        ['PrekoracenjeBrzine'] = false, -- # aktiviraj | deaktiviraj *dojavu* 
    },

    DefaultAlerts = {
        Speeding = false,
        Shooting = true,
        Autotheft = false,
        Melee = false,
        Explosion = false
    },

    Cooldowns = {
        ['panic_button'] = 30, 
        ['remove_panic_blip'] = 60,
        ['Shooting'] = 15,
        ['Melee'] = 10,
        ['AutotheftJack'] = 10,
        ['AutotheftAlarm'] = 10,
    },

    SluzbeniKodovi = {
        ['ranjen_policajac'] = '10-99'
    },

    DozvoljenaOruzja = {
        'WEAPON_GRENADE',
        'WEAPON_BZGAS',
        'WEAPON_MOLOTOV',
        'WEAPON_STICKYBOMB',
        'WEAPON_PROXMINE',
        'WEAPON_SNOWBALL',
        'WEAPON_PIPEBOMB',
        'WEAPON_BALL',
        'WEAPON_SMOKEGRENADE',
        'WEAPON_FLARE',
        'WEAPON_PETROLCAN',
        'WEAPON_FIREEXTINGUISHER',
        'WEAPON_MUSKET',
        'WEAPON_HAZARDCAN',
        'WEAPON_RAYCARBINE',
        'WEAPON_STUNGUN'
    },

}