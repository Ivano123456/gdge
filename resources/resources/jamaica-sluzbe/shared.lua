SluzbeNui = {
    ImpoundCena = 500,
    VoziloPlatePrefix = {
        police = 'PD',
        sud = 'SUD',
    },
}

SluzbeGps = {
    Item = 'gps_tracker',
    MaxActive = 2,
    DurationSec = 900,
    PlaceDistance = 4.0,
    ProgressMs = 8000,
    CooldownMs = 3000,
    BlipSprite = 225,
    BlipColor = 1,
    BlipScale = 0.9,
}

SluzbeJobAliases = {}

SluzbeRadioAccess = {
    police = true,
}

PoliceOruzarnicaArtikli = {
    { item = "weapon_tacticalrifle", label = "Tactical Rifle", kolicina = 1, serial = true, cijena = 20000, rankovi = { 11 } },
    { item = "at_suppressor_heavy", label = "Tactical Suppressor", kolicina = 1, serial = false, cijena = 2500, rankovi = { 11 } },
    { item = "weapon_combatpistol", label = "Combat Pistol", kolicina = 1, serial = true, cijena = 5000 },
    { item = "at_suppressor_light", label = "Suppressor", kolicina = 1, serial = false, cijena = 1500 },
    { item = "ammo-9", label = "9mm", kolicina = 1, serial = false, cijena = 2 },
    { item = "ammo-rifle", label = "Rifle Ammo", kolicina = 1, serial = false, cijena = 3 },
    { item = "weapon_stungun", label = "Teaser", kolicina = 1, serial = true, cijena = 500 },
    { item = "weapon_flashbang", label = "Flashbang", kolicina = 1, serial = false, cijena = 1000 },
    { item = "lisice", label = "Lisice", kolicina = 1, serial = false, cijena = 0 },
    { item = "handcuff_key", label = "Kljuc za lisice", kolicina = 1, serial = false, cijena = 0 },
    { item = "megaphone", label = "Megaphone", kolicina = 1, serial = false, cijena = 0 },
    { item = "bodycam", label = "Body Kamera", kolicina = 1, serial = false, cijena = 0 },
    { item = "dashcam", label = "Dash Kamera", kolicina = 1, serial = false, cijena = 0 },
    { item = "fingerprint", label = "Fingerprint skener", kolicina = 1, serial = false, cijena = 0 },
    { item = "weapon_nightstick", label = "Pendrek", kolicina = 1, serial = false, cijena = 0 },
    { item = "weapon_flashlight", label = "Lampa", kolicina = 1, serial = true, cijena = 0 },
    { item = "selfrevive", label = "Self Revive", kolicina = 1, serial = false, cijena = 1500, rankovi = { 11 } },
    { item = "ultrastresstableta", label = "Ultra Stress Tableta", kolicina = 1, serial = false, cijena = 100 },
    { item = "bandage", label = "Bandage", kolicina = 1, serial = false, cijena = 50 },
    { item = "armour", label = "Pancir", kolicina = 1, serial = false, cijena = 1000 },
    { item = "gps", label = "GPS", kolicina = 1, serial = false, cijena = 500 },
    { item = "gps_tracker", label = "GPS Tracker", kolicina = 1, serial = false, cijena = 1000 },
    { item = "nanospytablet", label = "Nano Spy Tablet", kolicina = 1, serial = false, cijena = 5000 },
    { item = "nanospymic", label = "Nano Spy Mikrofon", kolicina = 1, serial = false, cijena = 2000 },
    { item = "nanospycam", label = "Nano Spy Kamera", kolicina = 1, serial = false, cijena = 2000 },
    { item = "nanospygps", label = "Nano Spy GPS", kolicina = 1, serial = false, cijena = 1500 },
    { item = "digiscanner", label = "Digital Scanner", kolicina = 1, serial = false, cijena = 2500 },
    { item = "prison_mdt", label = "Zatvorski MDT", kolicina = 1, serial = false, cijena = 0 },
    { item = "ankle_monitor", label = "Elektronska narukvica", kolicina = 1, serial = false, cijena = 0 },
    { item = "power_saw", label = "Elektricna testera", kolicina = 1, serial = false, cijena = 0 },
}

function IsSluzbaJob(jobName)
    return GetSluzbaConfig(jobName) ~= nil
end

function GetSluzbaConfig(jobName)
    if not jobName or jobName == '' then return nil end
    local resolved = SluzbeJobAliases[jobName] or jobName
    local cfg = Podesavanja[resolved]
    if cfg then return cfg end
    for _, v in pairs(Podesavanja) do
        if v['posao'] == resolved then
            return v
        end
    end
    return nil
end

function GetSluzbaDispatchJobs()
    local jobs = {}
    local seen = {}
    for jobName in pairs(Podesavanja) do
        if not seen[jobName] then
            seen[jobName] = true
            jobs[#jobs + 1] = jobName
        end
    end
    for aliasJob in pairs(SluzbeJobAliases) do
        if not seen[aliasJob] then
            seen[aliasJob] = true
            jobs[#jobs + 1] = aliasJob
        end
    end
    return jobs
end

if IsDuplicityVersion() then
    function JeSluzbenik(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer or not xPlayer.job then return false end
        return IsSluzbaJob(xPlayer.job.name)
    end

    function JeNaDuznosti(source)
        if not source or not JeSluzbenik(source) then return false end
        if GetResourceState('okokBossMenu') ~= 'started' then return false end
        return exports.okokBossMenu:IsPlayerOnDuty(source) == true
    end

    function ProveriDuznostServer(source)
        if JeNaDuznosti(source) then return true end
        TriggerClientEvent('esx:showNotification', source, 'Morate biti na duznosti da biste koristili ovo!', 'error')
        return false
    end
else
    local cachedNaDuznosti = false

    CreateThread(function()
        while true do
            if JeSluzbenik() and GetResourceState('okokBossMenu') == 'started' then
                local ok, result = pcall(function()
                    return lib.callback.await('okokBossMenu:isOnDuty', false)
                end)
                cachedNaDuznosti = ok and result == true
            else
                cachedNaDuznosti = false
            end
            Wait(1500)
        end
    end)

    function JeSluzbenik()
        local pData = ESX.GetPlayerData()
        return pData and pData.job and IsSluzbaJob(pData.job.name)
    end

    function JeNaDuznosti()
        return cachedNaDuznosti
    end

    function ProveriDuznost()
        if JeNaDuznosti() then return true end
        ESX.ShowNotification('Morate biti na duznosti da biste koristili ovo!', 'error')
        return false
    end
end

Podesavanja = {
   ['police'] = {
        ['posao'] = "police",
        ['label'] = "Policijska Uprava",
        ['salter'] = vec4(-584.1463, -419.9313, 35.1845, 279.7762),
        ['bossmenu'] = {
            bossRank = 11,
        },
        ['blip'] = {
            aktiviraj = true,
            sprite = 137,
            velicina = 0.8,
            boja = 3,
            coords = vec3(-576.3237, -417.6183, 35.1678),
        },
        ['sef'] = {
            prop = true,
            model = "sf_prop_v_43_safe_s_bk_01a",
            coords = vec4(-571.5883, -417.2504, 39.6326, 189.9258),
            tezina = 1000,
            slotovi = 500,
            sifra = "1312",
            ownable = false,
            label = "Policijska Uprava | Stash",
        },
        ['evidence'] = {
             model = "csb_cop",
             coords = vec4(-608.1644, -413.6126, 35.1720, 325.6781),
        },
        ['helikopter'] = {
            model = "csb_cop",
            coords = vec4(-599.5594, -420.6175, 49.5453, 348.6772),
            parkiraj = vec4(-595.9653, -430.5149, 51.2867, 263.5717),
            vozila = {
                { model = "polmav", label = "Policijski Standardni", coords = vec4(-595.9653, -430.5149, 51.2867, 263.5717) },
            }
        },
        ['ormarici'] = {
           label = "Vas Privatni Ormaric",
           slotovi = 200,
           tezina = 300,
           coords = {
                vec3(-589.2894, -412.9188, 35.1721),
           },
        },
        ['oruzarnica'] = {
            model = "s_m_y_cop_01",
            coords = vec4(-608.3135, -410.5219, 35.1720, 234.4659),
            artikli = PoliceOruzarnicaArtikli,
        },
        ['vozila'] = {
            model = 's_m_y_cop_01',
            coords = vec4(-578.8842, -416.3690, 31.1603, 169.3477),
            spawnPoint = {
                vec4(-587.6483, -415.6345, 30.7486, 270.2717),
            },
            parkPoint = vec3(-587.6483, -415.6345, 30.7486),
            vozila = {
               { model = 'npolexp', label = 'Ford Explorer', cijena = 0 },
               { model = 'npolchar', label = 'Dodge Charger', cijena = 0 },
               { model = 'npolvic', label = 'Crown Victoria', cijena = 0 },
               { model = 'npolmm', label = 'Motor', cijena = 0 },
               { model = 'npolvette', label = 'Chevrolet Corvette', cijena = 0 },
               { model = 'npolchal', label = 'Dodge Challenger', cijena = 0 },
               { model = 'npolstang', label = 'Ford Mustang', cijena = 0 },
               { model = 'vc_samsg63221', label = 'Mercedes G Class', cijena = 0 },
               { model = 'nm_ctsv', label = 'Cadillac CTS-V', cijena = 0 },
               { model = 'zm_s500', label = 'Mercedes S500 Brabus', cijena = 0 },
            },
        },
    },
    ['sud'] = {
        ['posao'] = "sud",
        ['label'] = "Sud",
        ['oruzarnica'] = {
            model = "s_m_y_cop_01",
            coords = vec4(-1580.3148, 194.9883, 58.8536, 201.6472),
            artikli = {
                { item = "weapon_combatpdw", label = "Combat PDW", kolicina = 1, serial = true, cijena = 20000, rankovi = { 4, 5 } },
                { item = "lisice", label = "Lisice", kolicina = 1, serial = false, cijena = 0 },
                { item = "handcuff_key", label = "Kljuc za lisice", kolicina = 1, serial = false, cijena = 0 },
                { item = "weapon_stungun", label = "Teaser", kolicina = 1, serial = true, cijena = 500 },
                { item = "weapon_flashlight", label = "Lampa", kolicina = 1, serial = true, cijena = 0 },
                { item = "weapon_nightstick", label = "Pendrek", kolicina = 1, serial = false, cijena = 0 },
                { item = "bandage", label = "Bandage", kolicina = 1, serial = false, cijena = 50 },
                { item = "armour", label = "Pancir", kolicina = 1, serial = false, cijena = 1000 },
                { item = "radio", label = "Radio", kolicina = 1, serial = false, cijena = 0 },
                { item = "gps", label = "GPS", kolicina = 1, serial = false, cijena = 500 },
            },
        },
    },
}