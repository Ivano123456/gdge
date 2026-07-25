local zapoceo_parkiranje = false
local cachePodaci = {}
local aktivnaGarazaPozicija = nil
local aktivnaOtkupPonuda = false
local automafijaPeds = {}
local automafijaPedSpawning = {}
local automafijaZones = {}
local pozicijeJobs = {}
local obijanjeTargetPostavljen = false
local automafijaInitRunning = false

for _, v in pairs(Podesavanje.Pozicije) do
    if v.posao then
        pozicijeJobs[v.posao] = true
    end
end

local function getPlayerJob()
    return ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name
end

local function imaPristupAutomafiji()
    local playerJob = getPlayerJob()
    return playerJob ~= nil and pozicijeJobs[playerJob] == true
end

local function ocistiPoziciju(k)
    if automafijaPeds[k] and DoesEntityExist(automafijaPeds[k]) then
        exports.ox_target:removeLocalEntity(automafijaPeds[k], { 'automafija_garaza_' .. k })
        DeleteEntity(automafijaPeds[k])
    end
    automafijaPeds[k] = nil
    automafijaPedSpawning[k] = nil

    if automafijaZones[k] then
        exports.ox_target:removeZone('automafija_zaplena_' .. k)
        automafijaZones[k] = nil
    end
end

local function otvoriZaplenaMeni()
    local pedic = PlayerPedId()
    lib.registerContext({
        id = 'izaberi_automafija',
        title = 'Lista opcija automafije :',
        options = {
            {
                title = 'Zapleni vozilo u garazu automafije',
                description = 'Vozilo prelazi iz vlasnistva igraca u vlasnistvo automafije',
                onSelect = function()
                    parkirajVoziloAUTOMAFIJA()
                end,
                icon = 'fa-solid fa-car'
            },
            {
                title = 'Rastavi vozilo u delove',
                description = 'Nestaje sa lica zemlje',
                onSelect = function()
                    if IsPedInAnyVehicle(pedic, true) then
                        local vozilo = GetVehiclePedIsIn(pedic, false)
                        local podatak = ESX.Game.GetVehicleProperties(vozilo)
                        ESX.TriggerServerCallback('jamaica_automafija:TablicaProveriGarazu', function(postoji)
                            if postoji then
                                local canRastavi = lib.callback.await('jamaica_automafija:mozeLiRastaviti', false, cachePodaci)
                                if canRastavi then
                                    rastaviAUtic()
                                else
                                    ESX.ShowNotification('Nije proslo ' .. (Podesavanje.RastavljanjeDana or 2) .. ' dana od zaplene da bi mogli da rastavite vozilo!')
                                end
                            else
                                ESX.ShowNotification('Ovo vozilo se ne nalazi u garazi automafije!')
                            end
                        end, podatak.plate)
                    else
                        ESX.ShowNotification('Morate biti u vozilu!')
                    end
                end,
                icon = 'fa-solid fa-gears'
            },
            {
                title = 'Parkiraj vozilo u garazu automafije',
                description = 'Parkiras vozilo nakon vadjenja iz iste garaze',
                onSelect = function()
                    if IsPedInAnyVehicle(pedic, true) then
                        parkirajUMRTVUgarazicu()
                    else
                        ESX.ShowNotification('Morate biti u vozilu!')
                    end
                end,
                icon = 'fa-solid fa-square-parking'
            },
        }
    })
    lib.showContext('izaberi_automafija')
end

local function obrisiPedNaLokaciji(coords, heading, osimPed)
    for _, entity in ipairs(GetGamePool('CPed')) do
        if entity ~= osimPed and entity ~= PlayerPedId() and not IsPedAPlayer(entity) then
            local entityCoords = GetEntityCoords(entity)
            if #(entityCoords - coords) < 1.0 and math.abs(GetEntityHeading(entity) - heading) < 5.0 then
                DeleteEntity(entity)
            end
        end
    end
end

local function postaviPoziciju(k, v)
    if automafijaPedSpawning[k] then
        return
    end

    if automafijaPeds[k] and DoesEntityExist(automafijaPeds[k]) then
        return
    end

    automafijaPedSpawning[k] = true
    obrisiPedNaLokaciji(v.kordinate, v.heading)

    lib.requestModel(v.hash)
    local pedModel = GetHashKey(v.hash)

    if automafijaPeds[k] and DoesEntityExist(automafijaPeds[k]) then
        automafijaPedSpawning[k] = nil
        return
    end

    local ped = CreatePed(4, pedModel, v.kordinate.x, v.kordinate.y, v.kordinate.z - 1, v.heading, false, false)
    SetEntityAsMissionEntity(ped, true, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityVisible(ped, true, false)
    SetModelAsNoLongerNeeded(pedModel)
    automafijaPeds[k] = ped
    automafijaPedSpawning[k] = nil

    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'automafija_garaza_' .. k,
            icon = 'fa-solid fa-tower-observation',
            label = 'Lista zaplenjenih vozila',
            distance = 3.5,
            onSelect = function()
                otvoriGarazuMafija(k)
            end,
        },
    })

    if not automafijaZones[k] then
        local coords = v.marker_zaplena
        automafijaZones[k] = exports.ox_target:addSphereZone({
            name = 'automafija_zaplena_' .. k,
            coords = vec3(coords.x, coords.y, coords.z),
            radius = Podesavanje.ZaplenaRadius or 2.0,
            options = {
                {
                    name = 'automafija_zaplena_menu_' .. k,
                    icon = 'fa-solid fa-car',
                    label = 'Opcije automafije',
                    distance = 3.0,
                    onSelect = function()
                        otvoriZaplenaMeni()
                    end,
                },
            },
        })
    end
end

local function syncAutomafijaSveta()
    local playerJob = getPlayerJob()

    for k, v in pairs(Podesavanje.Pozicije) do
        if playerJob == v.posao then
            postaviPoziciju(k, v)
        else
            ocistiPoziciju(k)
        end
    end
end

local function postaviObijanjeTarget()
    if obijanjeTargetPostavljen or GetResourceState('ox_target') ~= 'started' then return end

    exports.ox_target:addGlobalVehicle({
        {
            name = 'automafija_obij_vozilo',
            icon = 'fa-solid fa-unlock-keyhole',
            label = 'Topli bravu vozila',
            distance = Podesavanje.ObijanjeDistance or 3.0,
            canInteract = function(entity)
                if not imaPristupAutomafiji() then return false end
                if IsPedInAnyVehicle(PlayerPedId(), false) then return false end
                local lockStatus = GetVehicleDoorLockStatus(entity)
                return lockStatus > 1 and lockStatus ~= 8
            end,
            onSelect = function(data)
                obijanjeVozilaAutoMafija(data.entity)
            end,
        },
    })

    obijanjeTargetPostavljen = true
end

local function initAutomafija()
    if automafijaInitRunning then return end
    automafijaInitRunning = true

    CreateThread(function()
        while GetResourceState('ox_target') ~= 'started' do Wait(200) end
        postaviObijanjeTarget()
        syncAutomafijaSveta()
        automafijaInitRunning = false
    end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    initAutomafija()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    syncAutomafijaSveta()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if obijanjeTargetPostavljen then
        exports.ox_target:removeGlobalVehicle('automafija_obij_vozilo')
        obijanjeTargetPostavljen = false
    end
    for k in pairs(Podesavanje.Pozicije) do
        ocistiPoziciju(k)
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if not ESX.PlayerData or not ESX.PlayerData.job then return end
    initAutomafija()
end)

CreateThread(function()
    while not ESX.PlayerData or not ESX.PlayerData.job do
        Wait(500)
    end
    initAutomafija()
end)

RegisterCommand(Podesavanje.VracanjeKomanda, function(_, args)
    ESX.TriggerServerCallback('jamaica_automafija:hasGarageAccess', function(hasAccess)
        if not hasAccess then
            ESX.ShowNotification('Nemate pristup garazi automafije za vasu organizaciju!')
            return
        end
        local targetId = tonumber(args[1])
        if not targetId then
            ESX.ShowNotification('Upotreba: /' .. Podesavanje.VracanjeKomanda .. ' [id igraca]')
            return
        end
        if not IsPedInAnyVehicle(PlayerPedId(), true) then
            ESX.ShowNotification('Morate biti u vozilu za ovu opciju!')
            return
        end
        TriggerServerEvent('jamaica_automafija:ponudiOtkup', targetId)
    end)
end)

obijanjeVozilaAutoMafija = function(vozilo)
    if not imaPristupAutomafiji() then
        ESX.ShowNotification('Vasa organizacija nema pristup auto mafiji!')
        return
    end

    ESX.TriggerServerCallback('jamaica_automafija:jelMozeObiti', function(moze)
        if moze then
            local pedic = PlayerPedId()
            local coords = GetEntityCoords(pedic)
            local najblizevozilo = vozilo

            if not najblizevozilo or najblizevozilo == 0 or not DoesEntityExist(najblizevozilo) then
                najblizevozilo = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
            end

            if najblizevozilo == 0 then
                ESX.ShowNotification('Nema vozila u blizini!')
                return
            end

            local tablice = GetVehicleNumberPlateText(najblizevozilo)
            local statusvrata = GetVehicleDoorLockStatus(najblizevozilo)
            ESX.TriggerServerCallback('jamaica_automafija:jelMozeObitiSpecificnoVozilo', function(data)
                if data then
                    if statusvrata > 1 and statusvrata ~= 8 then
                        ESX.ShowNotification('Krenuli ste da topite bravu vozila!')

                        TaskStartScenarioInPlace(pedic, 'WORLD_HUMAN_WELDING', 0, false)
                        FreezeEntityPosition(pedic, true)

                        ESX.ShowNotification('Alarm vozila se aktivirao!')
                        TriggerServerEvent('jamaica_automafija:SyncajZvuk', NetworkGetNetworkIdFromEntity(najblizevozilo))

                        local text = 'Neko pokusava da spali bravu vrata tudjeg vozila!'
                        TriggerServerEvent('core_dispach:addCall', '12=11', text, '', coords, 'policija', 10000, 11, 5)

                        lib.progressBar({
                            duration = Podesavanje.VremeTopljenja * 1000,
                            label = 'Topljenje brave vrata..',
                            position = 'bottom',
                            useWhileDead = false,
                            disable = {
                                car = true,
                            },
                        })

                        ESX.ShowNotification('Brava istopljena!')

                        SetVehicleDoorsLocked(najblizevozilo, 1)
                        SetVehicleDoorsLockedForAllPlayers(najblizevozilo, false)

                        FreezeEntityPosition(pedic, false)
                        ClearPedTasksImmediately(pedic)

                        TriggerServerEvent('jamaica_automafija:LogObio', tablice)
                    else
                        ESX.ShowNotification('Ovo vozilo nije zakljucano!')
                    end
                end
            end, tablice)
        end
    end)
end

exports('ObijVozilo', obijanjeVozilaAutoMafija)

RegisterNetEvent('jamaica_automafija:ClientZvuk')
AddEventHandler('jamaica_automafija:ClientZvuk', function(netId)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if vehicle == 0 or not DoesEntityExist(vehicle) then return end
    SetVehicleAlarm(vehicle, true)
    SetVehicleAlarmTimeLeft(vehicle, Podesavanje.AlarmVozila * 1000)
end)

RegisterNetEvent('jamaica_automafija:notifikacijaTelefon')
AddEventHandler('jamaica_automafija:notifikacijaTelefon', function(data)
    ESX.ShowNotification('Vozilo sa tablicama : ' .. data.tablice .. ' je u vlasnistvu  : ' .. data.ime .. ' ' .. data.prezime)
end)

RegisterNetEvent('jamaica_automafija:otkupPonuda')
AddEventHandler('jamaica_automafija:otkupPonuda', function(data)
    aktivnaOtkupPonuda = true
    local poruka = ('Zelite li otkupiti vozilo %s [%s] za %s$? Pritisnite F4 da prihvatite.'):format(
        data.autoime or 'vozilo',
        data.tablice or '',
        data.cena or 0
    )
    ESX.ShowNotification(poruka)
    TriggerEvent('chat:addMessage', {
        color = { 255, 255, 255 },
        multiline = true,
        args = { 'AUTO MAFIJA', poruka }
    })
    lib.showTextUI('[F4] Prihvati otkup vozila — ' .. (data.cena or 0) .. '$')
    SetTimeout((data.trajanje or Podesavanje.OtkupTrajanje or 120) * 1000, function()
        if aktivnaOtkupPonuda then
            aktivnaOtkupPonuda = false
            lib.hideTextUI()
        end
    end)
end)

RegisterNetEvent('jamaica_automafija:obrisiVoziloOtkup')
AddEventHandler('jamaica_automafija:obrisiVoziloOtkup', function()
    local vozilo = GetVehiclePedIsIn(PlayerPedId(), false)
    if vozilo ~= 0 then
        ESX.Game.DeleteVehicle(vozilo)
    end
    cachePodaci = {}
end)

RegisterCommand('+automafija_prihvati_otkup', function()
    if aktivnaOtkupPonuda then
        aktivnaOtkupPonuda = false
        lib.hideTextUI()
        TriggerServerEvent('jamaica_automafija:prihvatiOtkup')
    end
end, false)

RegisterCommand('-automafija_prihvati_otkup', function() end, false)
RegisterKeyMapping('+automafija_prihvati_otkup', 'Automafija — prihvati otkup vozila', 'keyboard', 'F4')

rastaviAUtic = function()
    local vozilo = GetVehiclePedIsIn(PlayerPedId(), false)
    local podatak = ESX.Game.GetVehicleProperties(vozilo)
    ESX.TriggerServerCallback('jamaica_automafija:rastaviVozilo', function(nijevan)
        if nijevan then
            ESX.TriggerServerCallback('jamaica_automafija:dajLOvu', function(autopostoji)
                if autopostoji then
                    TaskLeaveVehicle(PlayerPedId(), vozilo, 0)
                    Wait(2500)
                    ESX.Game.DeleteVehicle(vozilo)
                end
            end, podatak.plate)
        end
    end, podatak.plate)
end

parkirajUMRTVUgarazicu = function()
    local vozilo = GetVehiclePedIsIn(PlayerPedId(), false)
    local podatak = ESX.Game.GetVehicleProperties(vozilo)
    ESX.TriggerServerCallback('jamaica_automafija:jelUGarazi', function(vangaraze)
        if vangaraze then
            TriggerServerEvent('jamaica_automafija:setajStateVozilaU', podatak.plate)
            TaskLeaveVehicle(PlayerPedId(), vozilo, 0)
            Wait(2500)
            ESX.Game.DeleteVehicle(vozilo)
            cachePodaci = {}
            ESX.ShowNotification('Vozilo parkirano u garazu automafije')
        end
    end, podatak.plate)
end

local function isZaplenaBannedVehicle(vozilo)
    local zabrana = Podesavanje.ZabranaZaplene or {}
    if #zabrana == 0 or not vozilo or vozilo == 0 then return false end
    local vehicleId = GetEntityArchetypeName and GetEntityArchetypeName(vozilo)
    if type(vehicleId) ~= 'string' then return false end
    vehicleId = vehicleId:match('^%s*(.-)%s*$')
    if not vehicleId or vehicleId == '' then return false end
    local lowerId = string.lower(vehicleId)
    for i = 1, #zabrana do
        if string.lower(zabrana[i]) == lowerId then
            return true
        end
    end
    return false
end

parkirajVoziloAUTOMAFIJA = function()
    if IsPedInAnyVehicle(PlayerPedId(), true) then
        local vozilo = GetVehiclePedIsIn(PlayerPedId(), false)
        if isZaplenaBannedVehicle(vozilo) then
            ESX.ShowNotification('Ovo vozilo se ne moze zapleniti!')
            return
        end
        local podatak = ESX.Game.GetVehicleProperties(vozilo)
        local postoji = lib.callback.await('jamaica_automafija:ProveriVlasnika', false, podatak.plate, podatak.model)
        local zaplenaStatus = lib.callback.await('jamaica_automafija:mozelZapleniti', false) or {}
        if not zapoceo_parkiranje then
            if postoji then
                if zaplenaStatus.ok then
                    zapoceo_parkiranje = true
                    lib.progressBar({
                        duration = Podesavanje.ZaplenaVreme * 1000,
                        label = 'Zaplenjujete vozilo',
                        position = 'bottom',
                        useWhileDead = false,
                        disable = {
                            car = true,
                        },
                    })
                    TriggerServerEvent('jamaica_automafija:dodajTable', podatak, podatak.plate)
                    ESX.ShowNotification('Uspesno ste zaplenili vozilo.')
                    TaskLeaveVehicle(PlayerPedId(), vozilo, 0)
                    Wait(2500)
                    ESX.Game.DeleteVehicle(vozilo)
                    zapoceo_parkiranje = false
                elseif zaplenaStatus.reason == 'cooldown' then
                    ESX.ShowNotification('Trenutno je cooldown u toku, sacekajte jos ' .. (zaplenaStatus.minutes or Podesavanje.ZaplenaCooldownMin or 30) .. ' minuta!')
                elseif zaplenaStatus.reason == 'no_access' then
                    ESX.ShowNotification('Nemate pristup garazi automafije za vasu organizaciju!')
                else
                    ESX.ShowNotification('Zaplena vozila trenutno nije moguca!')
                end
            else
                zapoceo_parkiranje = false
                ESX.ShowNotification('Ovo vozilo niko ne poseduje!')
            end
        else
            ESX.ShowNotification('Trenutno vec parkirate vozilo!')
        end
    else
        ESX.ShowNotification('Morate biti u vozilu za ovu opciju!')
        zapoceo_parkiranje = false
    end
end

otvoriGarazuMafija = function(k)
    aktivnaGarazaPozicija = k
    ESX.TriggerServerCallback('jamaica_automafija:PovuciGarazu', function(data)
        if data then
            local opcije = {}
            for i = 1, #data do
                local podatak = data[i]
                opcije[#opcije + 1] = {
                    title = GetDisplayNameFromVehicleModel(podatak.vozilo.model),
                    description = 'Tablice vozila : ' .. podatak.tablice .. '\nIzvuceno vozilo ' .. podatak.datum_zaplene,
                    progress = podatak.vozilo.fuelLevel,
                    icon = 'fa-solid fa-hashtag',
                    event = 'jamaica_automafija:stvoriVozilo',
                    arrow = true,
                    args = { mod = podatak.vozilo, Data = podatak }
                }
            end
            lib.registerContext({
                id = 'automafija_garazaid',
                title = 'Lista vozila u garazi :',
                options = opcije
            })
            lib.showContext('automafija_garazaid')
        end
    end)
end

RegisterNetEvent('jamaica_automafija:stvoriVozilo')
AddEventHandler('jamaica_automafija:stvoriVozilo', function(data)
    if not data or not data.mod then return end

    local playerJob = getPlayerJob()
    local k = aktivnaGarazaPozicija
    local v = k and Podesavanje.Pozicije[k]

    if v and playerJob == v.posao then
        stvoriVoziloAGararaza(data.mod, k, data.Data)
        return
    end

    local coords = GetEntityCoords(PlayerPedId(), true)
    for pk, pv in pairs(Podesavanje.Pozicije) do
        if playerJob == pv.posao and (#(coords - pv.kordinate) < 15.0 or #(coords - pv.spawn_vozila) < 15.0) then
            stvoriVoziloAGararaza(data.mod, pk, data.Data)
            return
        end
    end

    ESX.ShowNotification('Morate biti blizu garaze automafije da izvadite vozilo!')
end)

stvoriVoziloAGararaza = function(podatak_1, podatak_2, podatak_3)
    local cacheVozilo = nil
    ESX.TriggerServerCallback('jamaica_automafija:jelVanGaraze', function(nijevan)
        if nijevan then
            if ESX.Game.IsSpawnPointClear(vector(Podesavanje.Pozicije[podatak_2].spawn_vozila.x, Podesavanje.Pozicije[podatak_2].spawn_vozila.y, Podesavanje.Pozicije[podatak_2].spawn_vozila.z), 3.5) then
                ESX.Game.SpawnVehicle(podatak_1.model, vector(Podesavanje.Pozicije[podatak_2].spawn_vozila.x, Podesavanje.Pozicije[podatak_2].spawn_vozila.y, Podesavanje.Pozicije[podatak_2].spawn_vozila.z), Podesavanje.Pozicije[podatak_2].spawn_heading, function(vozilo)
                    cacheVozilo = vozilo
                    cachePodaci = podatak_3
                    ESX.Game.SetVehicleProperties(cacheVozilo, podatak_1)
                    SetVehicleFuelLevel(cacheVozilo, podatak_1.fuelLevel)
                    TaskWarpPedIntoVehicle(PlayerPedId(), cacheVozilo, -1)
                    SetVehRadioStation(cacheVozilo, 'OFF')
                    TriggerServerEvent('jamaica_automafija:setajStateVozilaVan', podatak_1.plate)
                    Wait(500)
                    ESX.ShowNotification('Vozilo uspesno izvadjeno iz garaze!')
                end)
            else
                ESX.ShowNotification('Trenutno nema slobodnog mesta za stvaranje vozila!')
            end
        end
    end, podatak_1.plate)
end
