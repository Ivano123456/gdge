local FADE_MS = 337
local DEATH_DEBOUNCE = 400
local KNOCK_INVINC_MS = 750
local JOB_NAME = Jamaica.PotrebanPosao
local RESPAWN_SEC = Jamaica.Koordinate.Respawn.Sekunde
local KNOCK_ANIM = { dict = 'move_injured_ground', name = 'front_loop' }
local CPR_ANIM = { dict = 'mini@cpr@char_a@cpr_str', name = 'cpr_pumpchest' }

local Blip
local Objekt = {}
local Sekunde = RESPAWN_SEC
local MozePozvat = true
local NPC, NPCVozilo, NPCBlip
local Zvao = false
local zadnjaSmrtTick = 0
local deathScreenActive = false
local deathTimerToken = 0
local ProvjeraSmrti = false
local PrviSpawn = false
local Pretrazen = false
local Revivea, Bandazira = false, false
local Vozilo, Helikopter

local function zaustaviDeathTimer()
    deathTimerToken = deathTimerToken + 1
end

local function BolnicaUID(serverId)
    serverId = serverId or GetPlayerServerId(PlayerId())
    if GetResourceState('jamaica-uid') == 'started' then
        local ok, uid = pcall(function()
            return exports['jamaica-uid']:getUUIDBySource(serverId)
        end)
        if ok and uid then return tostring(uid) end
    end
    local lista = GlobalState.ListaUUID
    local uid = lista and lista[tostring(serverId)]
    return uid and tostring(uid) or 'N/A'
end

local function BolnicaIdentifier(serverId)
    if not serverId or serverId == GetPlayerServerId(PlayerId()) then
        return LocalPlayer.state.identifier or (ESX.GetPlayerData() or {}).identifier or 'N/A'
    end
    return Player(serverId).state.identifier or 'N/A'
end

local function DobijRespawnTacke()
    local tacke = {}
    for _, value in pairs(Jamaica.Koordinate.Respawn or {}) do
        if type(value) == 'table' and value.Koordinate and value.Heading ~= nil then
            tacke[#tacke + 1] = value
        end
    end
    return tacke
end

local function Pritisnuto(control)
    return IsDisabledControlJustPressed(0, control) or IsControlJustPressed(0, control)
end

local function Drzan(control)
    return IsDisabledControlPressed(0, control) or IsControlPressed(0, control)
end

local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end

    local camCoords = GetGameplayCamCoords()
    local dist = #(camCoords - vector3(x, y, z))
    local scale = (1 / dist) * 2 * (1 / GetGameplayCamFov()) * 100

    SetTextScale(0.0, 0.35 * scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

local function syncSmrt(mrtav, knockan)
    LocalPlayer.state:set('Knockan', knockan == true, true)
    LocalPlayer.state:set('Mrtav', mrtav == true, true)
    TriggerServerEvent('jamaica_bolnica>server>PostaviSmrt', mrtav == true, knockan == true)
end

local function screenFade(out)
    if out then
        DoScreenFadeOut(FADE_MS)
        Wait(FADE_MS)
    else
        DoScreenFadeIn(FADE_MS)
    end
end

local function najbliziIgrac(maxDist)
    local player, dist = ESX.Game.GetClosestPlayer()
    if player == -1 or dist > maxDist then return end
    return GetPlayerServerId(player), dist
end

local function targetState(serverId)
    return Player(serverId).state
end

local function obrisiNpcDoktora()
    if NPCBlip and DoesBlipExist(NPCBlip) then
        RemoveBlip(NPCBlip)
    end
    NPCBlip = nil

    if NPC and DoesEntityExist(NPC) then
        ClearPedTasksImmediately(NPC)
        SetEntityAsMissionEntity(NPC, true, true)
        DeletePed(NPC)
    end
    if NPCVozilo and DoesEntityExist(NPCVozilo) then
        SetEntityAsMissionEntity(NPCVozilo, true, true)
        DeleteVehicle(NPCVozilo)
    end
    NPC, NPCVozilo = nil, nil
end

local function oslobodiNpcPoziv()
    Zvao = false
    MozePozvat = true
    SendNUIMessage({ Bolnica = true })
end

local function npcPozivNeuspjeh()
    obrisiNpcDoktora()
    oslobodiNpcPoziv()
    ESX.ShowNotification('Bolnicar nije mogao doci vasu lokaciju, pozovite ponovo.', 'error')
end

--- Napad / smrt bolnicara: nestane sa vozilom, bez revive-a, NE moze se opet pozvati ovaj put.
local function prekiniNpcZbogNapada()
    obrisiNpcDoktora()
    Zvao = false
    MozePozvat = false
    SendNUIMessage({ Bolnica = false })
    ESX.ShowNotification('Bolnicar je napusten zbog napada. Ne mozete ga vise pozvati.', 'error')
end

local function npcJeUgrozen()
    if not NPC or not DoesEntityExist(NPC) then
        return true
    end
    if IsEntityDead(NPC) or IsPedDeadOrDying(NPC, true) or IsPedFatallyInjured(NPC) then
        return true
    end
    -- Pogodak od igraca / oruzja (ne i obicni sudar vozila)
    if HasEntityBeenDamagedByAnyPed(NPC) then
        return true
    end
    if HasEntityBeenDamagedByWeapon(NPC, 0, 2) then
        return true
    end
    return false
end

--- Najbrzi put: node 55–80m, max 6 pokusaja (manje native spam).
local function nadjiNpcSpawn(playerCoords)
    local bestCoord, bestHeading, bestScore

    for i = 1, 6 do
        local angle = (i / 6) * math.pi * 2.0 + math.random() * 0.4
        local dist = 55.0 + (i % 3) * 10.0
        local tx = playerCoords.x + math.cos(angle) * dist
        local ty = playerCoords.y + math.sin(angle) * dist
        local ok, nodeCoord, nodeHeading = GetClosestVehicleNodeWithHeading(tx, ty, playerCoords.z, 1, 3.0, 0)
        if ok and nodeCoord then
            local nodeDist = #(playerCoords - nodeCoord)
            if nodeDist >= 40.0 and nodeDist <= 120.0 then
                local score = math.abs(nodeDist - 65.0)
                if not bestScore or score < bestScore then
                    bestScore, bestCoord, bestHeading = score, nodeCoord, nodeHeading
                end
            end
        end
    end

    if bestCoord then
        return bestCoord, bestHeading
    end

    local ok, nodeCoord, nodeHeading = GetClosestVehicleNodeWithHeading(
        playerCoords.x + 50.0, playerCoords.y, playerCoords.z, 1, 3.0, 0
    )
    if ok and nodeCoord then
        return nodeCoord, nodeHeading
    end
end

local function setupNpcBlip(entity)
    if NPCBlip and DoesBlipExist(NPCBlip) then
        RemoveBlip(NPCBlip)
    end
    NPCBlip = AddBlipForEntity(entity)
    SetBlipSprite(NPCBlip, 61)
    SetBlipColour(NPCBlip, 1)
    SetBlipScale(NPCBlip, 0.8)
    SetBlipAsShortRange(NPCBlip, false)
    SetBlipRoute(NPCBlip, true)
    SetBlipRouteColour(NPCBlip, 1)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('NPC Bolnicar')
    EndTextCommandSetBlipName(NPCBlip)
end

local function zavrsiNpcRevive(playerHeading)
    if not LocalPlayer.state.Mrtav then
        obrisiNpcDoktora()
        Zvao = false
        return
    end

    if npcJeUgrozen() then
        return prekiniNpcZbogNapada()
    end

    lib.requestAnimDict(CPR_ANIM.dict, 2000)
    if NPC and DoesEntityExist(NPC) and not npcJeUgrozen() then
        ClearPedTasks(NPC)
        TaskPlayAnim(NPC, CPR_ANIM.dict, CPR_ANIM.name, 2.0, 2.0, -1, 1, 0.0, false, false, false)
    else
        return prekiniNpcZbogNapada()
    end

    local kraj = GetGameTimer() + 6500
    while GetGameTimer() < kraj do
        if not LocalPlayer.state.Mrtav then
            obrisiNpcDoktora()
            Zvao = false
            return
        end
        if npcJeUgrozen() then
            return prekiniNpcZbogNapada()
        end
        Wait(200)
    end

    if npcJeUgrozen() or not LocalPlayer.state.Mrtav then
        if not LocalPlayer.state.Mrtav then
            obrisiNpcDoktora()
            Zvao = false
            return
        end
        return prekiniNpcZbogNapada()
    end

    local coords = GetEntityCoords(PlayerPedId())
    Respawnaj(coords, playerHeading or GetEntityHeading(PlayerPedId()), false, false, false)
    TriggerServerEvent('jamaica_vr>server>ManipulacijaMrtvih', false)
    TriggerServerEvent('jamaica_bolnica>server>Log', 'Bolničar Respawn',
        ('**Igrač:** %s\n**Igračev Identifier:** %s\n**Igračev UID:** %s'):format(
            GetPlayerName(PlayerId()), BolnicaIdentifier(), BolnicaUID()
        ))
    obrisiNpcDoktora()
    Zvao = false
    MozePozvat = true
end

--- Jedan loop: adaptive wait, bez spam taskova, agresivan unstuck.
local function pokreniNpcDoktorLoop()
    CreateThread(function()
        local faza = 'voznja' -- voznja | izlazak | setnja | revive
        local pocetak = GetGameTimer()
        local timeout = 120000
        local lastTaskAt = 0
        local lastDist = 9999.0
        local stuck = 0
        local heading = GetEntityHeading(PlayerPedId())

        while NPC and DoesEntityExist(NPC) do
            if not LocalPlayer.state.Mrtav then
                obrisiNpcDoktora()
                Zvao = false
                return
            end

            if npcJeUgrozen() then
                return prekiniNpcZbogNapada()
            end

            if GetGameTimer() - pocetak > timeout then
                return npcPozivNeuspjeh()
            end

            local ped = PlayerPedId()
            local playerCoords = GetEntityCoords(ped)
            local npcCoords = GetEntityCoords(NPC)
            local dist = #(playerCoords - npcCoords)
            local inVeh = IsPedInAnyVehicle(NPC, false)
            local now = GetGameTimer()

            -- Adaptive tick: daleko = rjedje, blizu = cesce
            local waitMs = dist > 80.0 and 1200 or (dist > 30.0 and 700 or 350)

            if dist >= lastDist - 1.0 then
                stuck = stuck + 1
            else
                stuck = 0
            end
            lastDist = dist

            -- Unstuck: teleport na blizi node (ne spam ClearArea)
            if stuck >= 10 and dist > 18.0 and faza == 'voznja' and NPCVozilo and DoesEntityExist(NPCVozilo) then
                stuck = 0
                local ok, node = GetClosestVehicleNode(
                    playerCoords.x + 22.0, playerCoords.y, playerCoords.z, 1, 3.0, 0
                )
                if ok and node then
                    SetEntityCoordsNoOffset(NPCVozilo, node.x, node.y, node.z + 0.4, false, false, false)
                    SetVehicleOnGroundProperly(NPCVozilo)
                    SetPedIntoVehicle(NPC, NPCVozilo, -1)
                    TaskVehicleDriveToCoordLongrange(NPC, NPCVozilo, playerCoords.x, playerCoords.y, playerCoords.z, 35.0, 787004, 6.0)
                    lastTaskAt = now
                end
            end

            if faza == 'voznja' then
                if inVeh and NPCVozilo and DoesEntityExist(NPCVozilo) then
                    if now - lastTaskAt > 8000 then
                        TaskVehicleDriveToCoordLongrange(NPC, NPCVozilo, playerCoords.x, playerCoords.y, playerCoords.z, 35.0, 787004, 6.0)
                        lastTaskAt = now
                    end
                    if dist <= 16.0 then
                        faza = 'izlazak'
                        TaskLeaveVehicle(NPC, NPCVozilo, 0)
                        lastTaskAt = now
                        if NPCBlip and DoesBlipExist(NPCBlip) then
                            SetBlipRoute(NPCBlip, false)
                        end
                    end
                elseif not inVeh then
                    faza = 'setnja'
                    TaskGoToEntity(NPC, ped, -1, 1.8, 2.0, 1073741824, 0)
                    lastTaskAt = now
                end
            elseif faza == 'izlazak' then
                if not inVeh then
                    faza = 'setnja'
                    TaskGoToEntity(NPC, ped, -1, 1.8, 2.0, 1073741824, 0)
                    lastTaskAt = now
                elseif now - lastTaskAt > 4000 then
                    ClearPedTasksImmediately(NPC)
                    local vc = GetEntityCoords(NPCVozilo)
                    SetEntityCoordsNoOffset(NPC, vc.x + 1.5, vc.y, vc.z, false, false, false)
                    faza = 'setnja'
                    TaskGoToEntity(NPC, ped, -1, 1.8, 2.0, 1073741824, 0)
                    lastTaskAt = now
                end
            elseif faza == 'setnja' then
                if dist <= 2.4 then
                    faza = 'revive'
                    break
                end
                if now - lastTaskAt > 2500 then
                    TaskGoToEntity(NPC, ped, -1, 1.8, 2.0, 1073741824, 0)
                    lastTaskAt = now
                end
                if stuck >= 8 and dist > 8.0 then
                    stuck = 0
                    local dx = playerCoords.x - npcCoords.x
                    local dy = playerCoords.y - npcCoords.y
                    local len = math.sqrt(dx * dx + dy * dy)
                    if len > 0.1 then
                        SetEntityCoordsNoOffset(
                            NPC,
                            playerCoords.x - (dx / len) * 3.0,
                            playerCoords.y - (dy / len) * 3.0,
                            playerCoords.z,
                            false, false, false
                        )
                        TaskGoToEntity(NPC, ped, -1, 1.8, 2.0, 1073741824, 0)
                        lastTaskAt = now
                    end
                end
            end

            Wait(waitMs)
        end

        if faza == 'revive' and NPC and DoesEntityExist(NPC) and LocalPlayer.state.Mrtav and not npcJeUgrozen() then
            zavrsiNpcRevive(heading)
        elseif Zvao then
            if NPC and DoesEntityExist(NPC) and npcJeUgrozen() then
                prekiniNpcZbogNapada()
            else
                npcPozivNeuspjeh()
            end
        end
    end)
end

local function pozoviLokalnogBolnicara()
    if Zvao then
        return ESX.ShowNotification('Vec si pozvao/la bolnicara.')
    end

    Zvao = true
    ESX.ShowNotification('Pozvali ste lokalnog bolnicara.')

    CreateThread(function()
        -- Kratko cekanje prije spawna
        Wait(math.random(5000, 15000))

        if not LocalPlayer.state.Mrtav then
            Zvao = false
            return
        end

        local cfg = Jamaica.NPCBolnicar
        local pedHash = joaat(cfg.ModelPEDa or 's_m_m_doctor_01')
        local vehHash = joaat(cfg.ModelVozila or 'ambulance')

        RequestModel(vehHash)
        RequestModel(pedHash)

        local deadline = GetGameTimer() + 6000
        while (not HasModelLoaded(vehHash) or not HasModelLoaded(pedHash)) and GetGameTimer() < deadline do
            Wait(20)
        end

        if not HasModelLoaded(vehHash) or not HasModelLoaded(pedHash) then
            return npcPozivNeuspjeh()
        end

        obrisiNpcDoktora()

        local kordic = GetEntityCoords(PlayerPedId())
        local spawnCoord, spawnHeading = nadjiNpcSpawn(kordic)
        if not spawnCoord then
            SetModelAsNoLongerNeeded(vehHash)
            SetModelAsNoLongerNeeded(pedHash)
            return npcPozivNeuspjeh()
        end

        ClearAreaOfVehicles(spawnCoord.x, spawnCoord.y, spawnCoord.z, 6.0, false, false, false, false, false)

        -- Networkovani entity — vide ga i ostali igraci u okolini
        NPCVozilo = CreateVehicle(vehHash, spawnCoord.x, spawnCoord.y, spawnCoord.z + 0.35, spawnHeading or 0.0, true, true)
        if not NPCVozilo or NPCVozilo == 0 or not DoesEntityExist(NPCVozilo) then
            SetModelAsNoLongerNeeded(vehHash)
            SetModelAsNoLongerNeeded(pedHash)
            return npcPozivNeuspjeh()
        end

        local netDeadline = GetGameTimer() + 2500
        while not NetworkGetEntityIsNetworked(NPCVozilo) and GetGameTimer() < netDeadline do
            NetworkRegisterEntityAsNetworked(NPCVozilo)
            Wait(0)
        end

        local vehNetId = NetworkGetNetworkIdFromEntity(NPCVozilo)
        if vehNetId and vehNetId ~= 0 then
            SetNetworkIdCanMigrate(vehNetId, true)
            SetNetworkIdExistsOnAllMachines(vehNetId, true)
        end

        SetEntityAsMissionEntity(NPCVozilo, true, true)
        SetVehicleOnGroundProperly(NPCVozilo)
        SetVehicleNumberPlateText(NPCVozilo, 'EMS' .. math.random(1000, 9999))
        SetVehicleDoorsLocked(NPCVozilo, 2)
        SetVehicleEngineOn(NPCVozilo, true, true, false)
        SetVehicleSiren(NPCVozilo, true)
        SetEntityVisible(NPCVozilo, true, false)
        ResetEntityAlpha(NPCVozilo)
        SetEntityCollision(NPCVozilo, true, true)
        NetworkSetEntityInvisibleToNetwork(NPCVozilo, false)

        NPC = CreatePedInsideVehicle(NPCVozilo, 26, pedHash, -1, true, true)
        if not NPC or NPC == 0 or not DoesEntityExist(NPC) then
            local c = GetEntityCoords(NPCVozilo)
            NPC = CreatePed(26, pedHash, c.x, c.y, c.z + 1.0, GetEntityHeading(NPCVozilo), true, true)
            if NPC and NPC ~= 0 and DoesEntityExist(NPC) then
                SetPedIntoVehicle(NPC, NPCVozilo, -1)
            end
        end

        SetModelAsNoLongerNeeded(vehHash)
        SetModelAsNoLongerNeeded(pedHash)

        if not NPC or NPC == 0 or not DoesEntityExist(NPC) then
            obrisiNpcDoktora()
            return npcPozivNeuspjeh()
        end

        netDeadline = GetGameTimer() + 2500
        while not NetworkGetEntityIsNetworked(NPC) and GetGameTimer() < netDeadline do
            NetworkRegisterEntityAsNetworked(NPC)
            Wait(0)
        end

        local pedNetId = NetworkGetNetworkIdFromEntity(NPC)
        if pedNetId and pedNetId ~= 0 then
            SetNetworkIdCanMigrate(pedNetId, true)
            SetNetworkIdExistsOnAllMachines(pedNetId, true)
        end

        SetEntityAsMissionEntity(NPC, true, true)
        SetEntityVisible(NPC, true, false)
        ResetEntityAlpha(NPC)
        NetworkSetEntityInvisibleToNetwork(NPC, false)
        SetBlockingOfNonTemporaryEvents(NPC, true)
        SetPedFleeAttributes(NPC, 0, false)
        SetPedCombatAttributes(NPC, 17, true)
        SetPedKeepTask(NPC, true)
        SetPedCanBeDraggedOut(NPC, false)
        SetDriverAbility(NPC, 1.0)
        SetDriverAggressiveness(NPC, 0.0)
        SetEntityInvincible(NPC, false)
        SetPedCanBeTargetted(NPC, true)
        SetPedDiesWhenInjured(NPC, true)
        ClearEntityLastDamageEntity(NPC)
        SetEntityHealth(NPC, 200)
        SetPedSuffersCriticalHits(NPC, true)

        setupNpcBlip(NPCVozilo)
        TaskVehicleDriveToCoordLongrange(NPC, NPCVozilo, kordic.x, kordic.y, kordic.z, 38.0, 787004, 6.0)
        ESX.ShowNotification('Bolnicar je na putu.', 'inform')
        pokreniNpcDoktorLoop()
    end)
end

local function obradiPozivBolnice()
    if not MozePozvat then return end
    MozePozvat = false
    SendNUIMessage({ Bolnica = false })

    ESX.TriggerServerCallback('jamaica_bolnica>server>PosaljiPoziv', function(hitnaNaDuznosti)
        if hitnaNaDuznosti then
            if GetResourceState('jamaica-dispatch') == 'started' then
                exports['jamaica-dispatch']:PozivHitne()
            end
            ESX.ShowNotification('Poziv poslat hitnoj sluzbi na duznosti.', 'success')
            return
        end
        pozoviLokalnogBolnicara()
    end)
end

function CleanupBolnica()
    if Blip then
        RemoveBlip(Blip)
        Blip = nil
    end

    for index in pairs(Objekt) do
        ObrisiObjekt(index)
    end

    if LocalPlayer.state.Knockan or LocalPlayer.state.Mrtav then
        syncSmrt(false, false)
        ESX.SetPlayerData('dead', false)
    end

    Revivea = false
    Bandazira = false
    deathScreenActive = false
    zadnjaSmrtTick = 0
    zaustaviDeathTimer()
    oslobodiNpcPoziv()
    obrisiNpcDoktora()
    ESX.HideUI()
    SendNUIMessage({ Ekran = false, Bolnica = false })
end

local function NewLifeRule(Koordinate)
    if not Koordinate then return end

    for _, value in pairs(Jamaica.Koordinate.Respawn) do
        if type(value) == 'table' and value.Koordinate and #(Koordinate - value.Koordinate) <= 137.0 then
            return
        end
    end

    CreateThread(function()
        local pocetak = GetGameTimer()
        local upozorenja = 0
        TriggerServerEvent('jamaica_bolnica>server>NLRUpdate', true, Koordinate)

        while GetGameTimer() - pocetak < Jamaica.NLR.Vrijeme * 60000 do
            if #(GetEntityCoords(PlayerPedId()) - Koordinate) <= 100.0 then
                upozorenja += 1
                if upozorenja < Jamaica.NLR.Upozorenja then
                    ESX.ShowNotification(('Imas ~r~%s~s~/~r~%s ~s~upozorenja za ~r~New Life Rule~s~. Makni se ~r~sto prije ~s~od ove lokacije.'):format(
                        upozorenja, Jamaica.NLR.Upozorenja
                    ), 'error')
                    Wait(15000)
                elseif not LocalPlayer.state.Mrtav then
                    TriggerServerEvent('jamaica_markeri>server>PostaviMarkere', GetPlayerServerId(PlayerId()), Jamaica.NLR.Markeri, 'New Life Rule', 'Server')
                    TriggerServerEvent('jamaica_bolnica>server>NLRUpdate', false)
                    return
                end
            end
            Wait(1337)
        end

        TriggerServerEvent('jamaica_bolnica>server>NLRUpdate', false)
        ESX.ShowNotification('Vrijeme za ~r~New Life Rule ~s~je proslo.', 'success')
    end)
end

function Respawnaj(Koordinate, Heading, ObrisiInventory, ResetirajStatus, NLR)
    if not Koordinate or Heading == nil then return end

    ESX.HideUI()
    DoScreenFadeOut(500)
    Wait(500)

    if ObrisiInventory then
        TriggerServerEvent('jamaica_bolnica>server>ObrisiInventory')
        ESX.ShowNotification('~r~Respawnan/a ~s~si te si ~r~izgubio/la ~s~sve stvari.')
    end

    local nlrCoords = NLR and GetEntityCoords(PlayerPedId()) or nil
    local ped = PlayerPedId()

    SetEntityInvincible(ped, false)
    NetworkResurrectLocalPlayer(Koordinate.x, Koordinate.y, Koordinate.z, Heading, true, false)
    SetEntityHealth(ped, 200)
    ClearPedTasks(ped)
    ClearPedBloodDamage(ped)
    TriggerEvent('jamaica_mafije:odvezivanje')
    TriggerEvent('jamaica-sluzbe:client:unCuffTargetRevive')

    if ResetirajStatus then
        TriggerEvent('esx_basicneeds:resetStatus')
    end
    if nlrCoords then
        NewLifeRule(nlrCoords)
    end

    ESX.SetPlayerData('dead', false)
    TriggerEvent('playerSpawned')
    TriggerEvent('esx:onPlayerSpawn')
    TriggerServerEvent('esx:onPlayerSpawn')

    Pretrazen = false
    deathScreenActive = false
    zaustaviDeathTimer()
    syncSmrt(false, false)
    SendNUIMessage({ Ekran = false, Bolnica = false })
    DoScreenFadeIn(500)
end

local function pokreniDeathTimer()
    zaustaviDeathTimer()
    local token = deathTimerToken
    local nextTick = GetGameTimer() + 1000

    CreateThread(function()
        while token == deathTimerToken and LocalPlayer.state.Mrtav do
            if Sekunde <= 0 then
                SendNUIMessage({ Sekunde = 0 })
                return
            end

            local now = GetGameTimer()
            local waitMs = nextTick - now
            if waitMs > 0 then
                Wait(waitMs)
            else
                Wait(0)
            end

            if token ~= deathTimerToken or not LocalPlayer.state.Mrtav then
                return
            end

            nextTick = nextTick + 1000
            Sekunde = math.max(0, Sekunde - 1)
            SendNUIMessage({ Sekunde = Sekunde })
        end
    end)
end

local function pokreniDeathKontrole()
    CreateThread(function()
        local animacije = { 'dead_a', 'dead_b', 'dead_h' }
        local animacija = animacije[math.random(#animacije)]
        lib.requestAnimDict('dead')

        while LocalPlayer.state.Mrtav do
            DisableAllControlActions(0)
            for _, control in ipairs({ 1, 2, 38, 47, 74, 245 }) do
                EnableControlAction(0, control, true)
            end

            local ped = PlayerPedId()
            if not IsEntityPlayingAnim(ped, 'dead', animacija, 3) then
                TaskPlayAnim(ped, 'dead', animacija, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
            end

            if Pritisnuto(38) then
                if Sekunde <= 0 then
                    if LocalPlayer.state.VRHeist then
                        ESX.ShowNotification('Nije se moguce respawnati dok ste u ~r~VR-u~w~.')
                    else
                        local tacke = DobijRespawnTacke()
                        if #tacke <= 0 then
                            ESX.ShowNotification('Respawn lokacije nisu podesene.', 'error')
                        else
                            local spawn = tacke[math.random(#tacke)]
                            Respawnaj(spawn.Koordinate, spawn.Heading, true, true, true)
                            TriggerServerEvent('jamaica_vr>server>ManipulacijaMrtvih', false)
                            TriggerServerEvent('jamaica_bolnica>server>Log', 'Respawn',
                                ('**Igrač:** %s\n**Igračev Identifier:** %s\n**Igračev UID:** %s\n**Koordinate:** %s\n**Heading:** %s'):format(
                                    GetPlayerName(PlayerId()), BolnicaIdentifier(), BolnicaUID(), spawn.Koordinate, spawn.Heading
                                ))
                        end
                    end
                else
                    ESX.ShowNotification('~r~Ne mozes ~s~se jos ~r~respawnati~s~.', 'error')
                end
            elseif Pritisnuto(74) then
                obradiPozivBolnice()
            end

            Wait(0)
        end
    end)
end

local function ulaziUPunuSmrt()
    ProvjeraSmrti = false
    syncSmrt(true, false)
    deathScreenActive = true
    Sekunde = RESPAWN_SEC
    MozePozvat = true

    SendNUIMessage({ Ekran = true, Sekunde = Sekunde, Bolnica = MozePozvat })
    pokreniDeathTimer()

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    ClearPedTasksImmediately(ped)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z + 0.5, GetEntityHeading(ped), 2, false)
    SetEntityHealth(ped, 150)
    SetEntityInvincible(ped, true)

    pokreniDeathKontrole()
end

local function ulaziUKnock()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
    SetEntityHealth(ped, 100)
    SetEntityInvincible(ped, true)
    syncSmrt(false, true)

    SetTimeout(KNOCK_INVINC_MS, function()
        if LocalPlayer.state.Knockan then
            SetEntityInvincible(PlayerPedId(), false)
        end
    end)

    lib.requestAnimDict(KNOCK_ANIM.dict)
    TaskPlayAnim(ped, KNOCK_ANIM.dict, KNOCK_ANIM.name, 8.0, 8.0, -1, 1, 1.0, false, false, false)
    ESX.SetPlayerData('ped', ped)
    ESX.SetPlayerData('dead', false)
    TriggerEvent('esx:onPlayerSpawn')

    local prikazanaPoruka = false
    local selfRevive = false
    local preostalo = Jamaica.SelfRevive.Sekunde

    CreateThread(function()
        while preostalo > 0 and LocalPlayer.state.Knockan do
            Wait(1000)
            preostalo -= 1
        end
    end)

    CreateThread(function()
        while LocalPlayer.state.Knockan do
            ped = PlayerPedId()

            if IsPedDeadOrDying(ped, true) or IsPedFatallyInjured(ped) then
                return TriggerEvent('esx:onPlayerDeath')
            end

            if preostalo <= 0 and not selfRevive then
                SetEntityHealth(ped, 0)
                return TriggerEvent('esx:onPlayerDeath')
            end

            if not selfRevive then
                if not IsEntityPlayingAnim(ped, KNOCK_ANIM.dict, KNOCK_ANIM.name, 3) then
                    TaskPlayAnim(ped, KNOCK_ANIM.dict, KNOCK_ANIM.name, 8.0, 8.0, -1, 1, 1.0, false, false, false)
                end

                if not prikazanaPoruka then
                    prikazanaPoruka = true
                    ESX.TextUI('~r~Pritisnite [E] da iskoristite self-revive injekciju. \n Drzite [H] da iskrvarite.~s~', 'error')
                    ESX.ShowNotification(('Imate ~r~%s sekundi ~s~vremena prije nego sto ~r~iskrvarite~s~.'):format(preostalo), 'error')
                end

                if Drzan(34) then
                    SetEntityHeading(ped, GetEntityHeading(ped) + 1.37)
                elseif Drzan(35) then
                    SetEntityHeading(ped, GetEntityHeading(ped) - 1.37)
                elseif Pritisnuto(38) then
                    ESX.TriggerServerCallback('jamaica_bolnica>server>KolicinaStvari', function(kolicina)
                        if kolicina <= 0 then
                            return ESX.ShowNotification('Nemas ~r~self-revive injekciju ~s~kod sebe.', 'error')
                        end

                        selfRevive = true
                        prikazanaPoruka = false
                        ClearPedTasks(ped)
                        lib.requestAnimDict('combat@damage@writhe')
                        TaskPlayAnim(ped, 'combat@damage@writhe', 'writhe_loop', 8.0, 8.0, -1, 1, 1.0, false, false, false)

                        if lib.progressBar({
                            duration = 10000,
                            label = 'Konzumiras self-revive injekciju...',
                            canCancel = true,
                        }) then
                            ESX.TriggerServerCallback('jamaica_bolnica>server>ObrisiStvar', function(moze)
                                if not moze then
                                    return TriggerServerEvent('jamaica_bolnica>server>AntiCheat')
                                end
                                TriggerEvent('jamaica_bolnica>client>Revive', false, false)
                                TriggerServerEvent('jamaica_vr>server>ManipulacijaMrtvih', false)
                                TriggerServerEvent('jamaica_bolnica>server>Log', 'Self Revive',
                                    ('Igrac **%s** je iskoristio/la **self-revive injekciju**.'):format(GetPlayerName(PlayerId())))
                                ESX.ShowNotification('Iskoristio/la si ~r~self-revive injekciju~s~.', 'success')
                            end, 'selfrevive', 1)
                        else
                            ClearPedTasks(ped)
                            selfRevive = false
                            ESX.ShowNotification('Prekinuo/la si konzumiranje ~r~self-revive injekcije~s~.', 'error')
                        end
                    end, 'selfrevive')
                elseif Pritisnuto(74) then
                    Wait(5000)
                    if Drzan(74) then
                        SetEntityHealth(ped, 0)
                        TriggerEvent('esx:onPlayerDeath')
                    end
                end
            end

            Wait(0)
        end

        ESX.HideUI()
    end)
end

local PropTargetOpcije = {
    {
        label = 'Popravi Vozilo',
        icon = 'fa-solid fa-wrench',
        iconColor = 'red',
        distance = 5.0,
        groups = JOB_NAME,
        canInteract = function()
            return IsPedInAnyVehicle(PlayerPedId(), false)
        end,
        onSelect = function()
            screenFade(true)
            local vozilo = GetVehiclePedIsIn(PlayerPedId(), false)
            SetVehicleFixed(vozilo)
            SetVehicleDeformationFixed(vozilo)
            SetVehicleUndriveable(vozilo, false)
            SetVehicleEngineOn(vozilo, true, true, false)
            screenFade(false)
            ESX.ShowNotification('Popravio/la si ~r~vozilo~s~.', 'error')
        end,
    },
    {
        label = 'Očisti Vozilo',
        icon = 'fa-solid fa-soap',
        iconColor = 'red',
        distance = 5.0,
        groups = JOB_NAME,
        canInteract = function()
            return IsPedInAnyVehicle(PlayerPedId(), false)
        end,
        onSelect = function()
            screenFade(true)
            SetVehicleDirtLevel(GetVehiclePedIsIn(PlayerPedId(), false), 0.0)
            screenFade(false)
            ESX.ShowNotification('Očistio/la si ~r~vozilo~s~.', 'error')
        end,
    },
}

function KreirajObjekt(index, value)
    if not index or not value or Objekt[index] then return end

    local hash
    local entity

    if value.ModelPED then
        hash = joaat(value.ModelPED)
        if not IsModelInCdimage(hash) then return end
        lib.requestModel(hash)
        entity = CreatePed(4, hash, value.Koordinate.x, value.Koordinate.y, value.Koordinate.z - 1.0, value.Heading or 0.0, false, true)
        SetBlockingOfNonTemporaryEvents(entity, true)
    elseif value.Objekt then
        hash = joaat(value.Objekt)
        if not IsModelInCdimage(hash) then return end
        lib.requestModel(hash)
        entity = CreateObject(hash, value.Koordinate.x, value.Koordinate.y, value.Koordinate.z, false, true, false)
        if value.Heading then
            SetEntityHeading(entity, value.Heading + 180)
        end
    elseif value.Model then
        hash = joaat(value.Model)
        if not IsModelInCdimage(hash) then return end
        lib.requestModel(hash)
        entity = CreateObject(hash, value.Koordinate.x, value.Koordinate.y, value.Koordinate.z, false, true, false)
        PlaceObjectOnGroundProperly(entity)
        if value.Heading then
            SetEntityHeading(entity, value.Heading)
        end
        exports.ox_target:addLocalEntity(entity, value.Opcije or PropTargetOpcije)
    else
        return
    end

    SetEntityInvincible(entity, true)
    FreezeEntityPosition(entity, true)
    if value.Opcije and not value.Model then
        exports.ox_target:addLocalEntity(entity, value.Opcije)
    end

    SetModelAsNoLongerNeeded(hash)
    Objekt[index] = entity
end

function ObrisiObjekt(index)
    if not index or not Objekt[index] then return end

    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:removeLocalEntity(Objekt[index])
    end

    if IsEntityAPed(Objekt[index]) then
        DeletePed(Objekt[index])
    else
        DeleteEntity(Objekt[index])
    end

    Objekt[index] = nil
end

local function otvoriVozilaMenu()
    if #Jamaica.Vozila <= 0 then
        return ESX.ShowNotification('Trenutno, ~r~nema ~s~vozila.', 'error')
    end

    local elementi = {}
    for _, value in pairs(Jamaica.Vozila) do
        elementi[#elementi + 1] = { label = '🚑 | ' .. value.Label, Model = value.Model }
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'BolnickaVozila', {
        title = '🚑 | Bolnicka Vozila',
        align = 'right-center',
        elements = elementi,
    }, function(podatci, menu)
        local hash = joaat(podatci.current.Model)
        if not IsModelInCdimage(hash) then
            return ESX.ShowNotification('~r~' .. podatci.current.label .. ' ~s~ne postoji u ~r~assetima servera~s~.', 'error')
        end
        if not ESX.Game.IsSpawnPointClear(Jamaica.Koordinate.Vozila.Spawn.Koordinate, 2.7) then
            return ESX.ShowNotification('Mjesto za ~r~spawn ~s~je trenutno ~r~nedostupno~s~.', 'error')
        end

        menu.close()
        screenFade(true)
        ESX.Game.SpawnVehicle(podatci.current.Model, Jamaica.Koordinate.Vozila.Spawn.Koordinate, Jamaica.Koordinate.Vozila.Spawn.Heading, function(vehicle)
            if not vehicle or not DoesEntityExist(vehicle) then
                screenFade(false)
                return ESX.ShowNotification('Spawn vozila nije uspeo.', 'error')
            end

            Vozilo = vehicle
            SetEntityAsMissionEntity(vehicle, true, true)
            if Jamaica.Koordinate.Vozila.Nadogradnje then
                ESX.Game.SetVehicleProperties(vehicle, Jamaica.Koordinate.Vozila.Nadogradnje)
            end
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            screenFade(false)
            TriggerServerEvent('okokGarage:GiveKeys', GetVehicleNumberPlateText(vehicle))
            ESX.ShowNotification('Stvorio/la si ~r~' .. podatci.current.label .. '~s~.', 'success')
        end)
    end, function(_, menu)
        menu.close()
    end)
end

local function otvoriHelikopterMenu()
    if Helikopter then
        return ESX.ShowNotification('Vec imas ~r~kreiran ~s~neki ~r~helikopter~s~.', 'error')
    end
    if #Jamaica.Helikopteri <= 0 then
        return ESX.ShowNotification('Trenutno, ~r~nema ~s~helikoptera.', 'error')
    end

    local elementi = {}
    for _, value in pairs(Jamaica.Helikopteri) do
        elementi[#elementi + 1] = { label = '🚁 | ' .. value.Label, Model = value.Model }
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'BolnickiHelikopteri', {
        title = '🚁 | Bolnicki Helikopteri',
        align = 'right-center',
        elements = elementi,
    }, function(podatci, menu)
        local hash = joaat(podatci.current.Model)
        if not IsModelInCdimage(hash) then
            return ESX.ShowNotification('~r~' .. podatci.current.label .. ' ~s~ne postoji u ~r~assetima servera~s~.', 'error')
        end
        if not ESX.Game.IsSpawnPointClear(Jamaica.Koordinate.Helikopteri.Spawn.Koordinate, 2.7) then
            return ESX.ShowNotification('Mjesto za ~r~spawn ~s~je trenutno ~r~nedostupno~s~.', 'error')
        end

        menu.close()
        screenFade(true)
        ESX.Game.SpawnVehicle(podatci.current.Model, Jamaica.Koordinate.Helikopteri.Spawn.Koordinate, Jamaica.Koordinate.Helikopteri.Spawn.Heading, function(vehicle)
            if not vehicle or not DoesEntityExist(vehicle) then
                screenFade(false)
                return ESX.ShowNotification('Spawn helikoptera nije uspeo.', 'error')
            end

            Helikopter = vehicle
            SetEntityAsMissionEntity(vehicle, true, true)
            if Jamaica.Koordinate.Helikopteri.Nadogradnje then
                ESX.Game.SetVehicleProperties(vehicle, Jamaica.Koordinate.Helikopteri.Nadogradnje)
            end
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            screenFade(false)
            ESX.ShowNotification('Stvorio/la si ~r~' .. podatci.current.label .. '~s~.', 'success')
        end)
    end, function(_, menu)
        menu.close()
    end)
end

local function oziviSaAdrenalinom(targetId)
    if Revivea then
        return ESX.ShowNotification('Vec ~r~ozivljavas ~s~nekoga.', 'error')
    end

    ClearPedTasks(PlayerPedId())
    lib.requestAnimDict(CPR_ANIM.dict)
    TaskPlayAnim(PlayerPedId(), CPR_ANIM.dict, CPR_ANIM.name, 8.0, 8.0, -1, 1, 1.0, false, false, false)
    Revivea = true
    LocalPlayer.state:set('invBusy', true, true)

    if lib.progressBar({
        duration = 15000,
        label = 'Ozivljavas osobu...',
        canCancel = true,
    }) then
        ESX.TriggerServerCallback('jamaica_bolnica>server>ObrisiStvar', function(moze)
            if not moze then
                return TriggerServerEvent('jamaica_bolnica>server>AntiCheat')
            end
            ClearPedTasks(PlayerPedId())
            Revivea = false
            LocalPlayer.state:set('invBusy', false, true)
            TriggerServerEvent('jamaica_bolnica>server>Revive', targetId, ESX.PlayerData.job.name == JOB_NAME)
            TriggerServerEvent('jamaica_bolnica>server>Log', 'Adrenalin',
                ('**Igrač:** %s\n**Igračev Identifier:** %s\n**Igračev UID:** %s\n**Osobin Identifier:** %s\n**Osobin UID:** %s'):format(
                    GetPlayerName(PlayerId()), BolnicaIdentifier(), BolnicaUID(), BolnicaIdentifier(targetId), BolnicaUID(targetId)
                ))
            ESX.ShowNotification('~r~Ozivio/la ~s~si zeljenu ~r~osobu~s~.', 'success')
        end, 'adrenalin', 1)
    else
        ClearPedTasks(PlayerPedId())
        Revivea = false
        LocalPlayer.state:set('invBusy', false, true)
        ESX.ShowNotification('~r~Odustao/la ~s~si od ~r~ozivljavanja~s~.', 'success')
    end
end

CreateThread(function()
    Blip = AddBlipForCoord(Jamaica.Blip.Koordinate)
    SetBlipSprite(Blip, Jamaica.Blip.Sprite)
    SetBlipDisplay(Blip, Jamaica.Blip.Display)
    SetBlipAsShortRange(Blip, true)
    SetBlipColour(Blip, Jamaica.Blip.Boja)
    SetBlipScale(Blip, Jamaica.Blip.Velicina)
    AddTextEntry('Bolnica', Jamaica.Blip.Ime)
    BeginTextCommandSetBlipName('Bolnica')
    EndTextCommandSetBlipName(Blip)
end)

AddEventHandler('esx:playerLoaded', function()
    PrviSpawn = true
    ESX.TriggerServerCallback('jamaica_bolnica>server>ProvjeriNLR', function(nlr)
        if not nlr then return end
        NewLifeRule(nlr)
        ESX.ShowNotification(('[~r~j0leAC~s~] Od prethodnog logina si imao/la lokaciju gdje je aktivan ~r~New Life Rule~s~, vracen ti je i ponovno je aktivan ~r~%s ~s~minuta.'):format(
            Jamaica.NLR.Vrijeme
        ), 'error')
    end)
end)

AddEventHandler('esx:onPlayerSpawn', function()
    while not ESX.PlayerLoaded do Wait(500) end
    if not PrviSpawn then return end

    PrviSpawn = false
    ESX.TriggerServerCallback('jamaica_bolnica>server>ProvjeraSmrti', function(mrtav)
        if not mrtav then return end
        ProvjeraSmrti = true
        SetEntityHealth(PlayerPedId(), 0)
        ESX.ShowNotification('Umro/la si jer si bio/la ~r~mrtav/a ~s~kad si izasao/la sa ~r~servera~s~.')
    end)
end)

AddEventHandler('esx:onPlayerDeath', function()
    local tick = GetGameTimer()
    local knockan = LocalPlayer.state.Knockan == true

    if tick - zadnjaSmrtTick < DEATH_DEBOUNCE and not knockan and not ProvjeraSmrti then return end
    zadnjaSmrtTick = tick

    local puniMrtav = LocalPlayer.state.Mrtav and not knockan
    -- Vec na death screenu — ne pokreci drugi timer (inace ide -2s)
    if deathScreenActive and not ProvjeraSmrti then
        return DoScreenFadeIn(FADE_MS)
    end

    ESX.UI.Menu.CloseAll()
    ESX.HideUI()
    ESX.CloseContext()
    screenFade(true)

    if knockan or ProvjeraSmrti or puniMrtav then
        ulaziUPunuSmrt()
    elseif not knockan and not LocalPlayer.state.Mrtav then
        ulaziUKnock()
    end

    screenFade(false)
end)

RegisterNetEvent('jamaica_bolnica>client>Revive', function(obrisiInventory, resetirajStatus)
    local coords = GetEntityCoords(PlayerPedId())
    Respawnaj(vec3(coords.x, coords.y, coords.z - 1.0), GetEntityHeading(PlayerPedId()), obrisiInventory, resetirajStatus, false)
end)

RegisterNetEvent('jamaica_bolnica>client>ManipulisiHP', function(hp, ilegalniDoca)
    if ilegalniDoca then
        return SetEntityHealth(PlayerPedId(), hp)
    end

    if lib.progressBar({
        duration = 5000,
        label = 'Lijeci Vas Bolnicar',
        disable = { move = true, sprint = true, car = true },
        anim = { dict = 'anim@heists@narcotics@funding@gang_idle', clip = 'gang_chatting_idle01' },
    }) then
        FreezeEntityPosition(PlayerPedId(), false)
        local ped = PlayerPedId()
        SetEntityHealth(ped, GetEntityHealth(ped) + Jamaica.Izlijeci)
    end
end)

exports.ox_target:addGlobalPlayer({
    {
        distance = 1.5,
        label = 'Iskoristi Adrenalin',
        items = 'adrenalin',
        icon = 'fa-solid fa-syringe',
        iconColor = 'red',
        canInteract = function(entity)
            return targetState(GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))).Mrtav
        end,
        onSelect = function()
            local targetId = najbliziIgrac(1.7)
            if not targetId or not targetState(targetId).Mrtav then
                return ESX.ShowNotification('Igrac u tvojoj blizini ~r~nije mrtav~s~.', 'error')
            end
            oziviSaAdrenalinom(targetId)
        end,
    },
    {
        distance = 1.5,
        label = 'Izlijeci',
        items = 'bandage',
        icon = 'fa-solid fa-syringe',
        groups = JOB_NAME,
        iconColor = 'red',
        canInteract = function(entity)
            return not targetState(GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))).Mrtav
        end,
        onSelect = function()
            local targetId = najbliziIgrac(1.7)
            if not targetId then
                return ESX.ShowNotification('Nema igraca u blizini.', 'error')
            end

            TriggerServerEvent('jamaica_bolnica>server>ManipulisiHP', targetId, false)

            if lib.progressBar({
                duration = 5000,
                label = 'Lijecis osobu...',
                canCancel = true,
                disable = { move = true },
                anim = { dict = 'anim@heists@narcotics@funding@gang_idle', clip = 'gang_chatting_idle01' },
            }) then
                ESX.TriggerServerCallback('jamaica_bolnica>server>ObrisiStvar', function(moze)
                    if not moze then
                        return TriggerServerEvent('jamaica_bolnica>server>AntiCheat')
                    end
                    if ESX.PlayerData.job.name == JOB_NAME then
                        TriggerServerEvent('jamaica_bolnica>server>NaplatiBandazu', targetId)
                    end
                    ESX.ShowNotification('~r~Izlijecili~s~ ste osobu.')
                end, 'bandage', 1)
            else
                ESX.ShowNotification('~r~Odustali~s~ ste od lijecenja.')
            end
        end,
    },
    {
        label = 'Napisi Racun',
        icon = 'fa-solid fa-paperclip',
        distance = 1.5,
        iconColor = 'red',
        groups = JOB_NAME,
        canInteract = function()
            return not IsPedInAnyVehicle(PlayerPedId())
        end,
        onSelect = function(data)
            if not data then return end
            local racun = lib.inputDialog('Izdavanje Racuna', {
                { type = 'input', label = 'Naziv Racuna', description = 'Upisite naziv racuna koji izdajete.', required = true },
                { type = 'number', label = 'Novcani Iznos', description = 'Upisite novcani iznos racuna.', required = true },
            })
            if not racun or not racun[1] or not racun[2] then return end

            TriggerServerEvent('okokBilling:createInvoiceSociety', {
                authorPlayer = { source = GetPlayerServerId(PlayerId()) },
                receiverPlayer = { source = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)) },
                item = racun[1],
                price = racun[2],
                note = '',
            })
            ESX.ShowNotification('Uspjesno ste napisali racun osobi pored Vas.')
        end,
    },
})

CreateThread(function()
    local koordinate = Jamaica.Koordinate
    local propovi = koordinate.Propovi

    while not ESX.PlayerLoaded do Wait(500) end

    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local sleep = 1500
        local naPoslu = ESX.PlayerData.job and ESX.PlayerData.job.name == JOB_NAME

        if naPoslu then
            for index, value in pairs(koordinate) do
                if value.Koordinate then
                    if #(coords - value.Koordinate) <= 137.0 then
                        KreirajObjekt(index, value)
                    else
                        ObrisiObjekt(index)
                    end
                end
            end
        else
            for index in pairs(Objekt) do
                if type(index) ~= 'string' or not index:find('^prop_', 1) then
                    ObrisiObjekt(index)
                end
            end
        end

        if propovi then
            for index, value in ipairs(propovi) do
                local key = 'prop_' .. index
                if #(coords - value.Koordinate) <= 50.0 then
                    KreirajObjekt(key, value)
                elseif Objekt[key] then
                    ObrisiObjekt(key)
                end
            end
        end

        if GetEntityMaxHealth(ped) ~= 200 then
            SetEntityMaxHealth(ped, 200)
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    local vracanje = Jamaica.Koordinate.Vozila and Jamaica.Koordinate.Vozila.Vracanje
    if not vracanje then return end

    while true do
        local sleep = 1500

        if ESX.PlayerLoaded and ESX.PlayerData.job and ESX.PlayerData.job.name == JOB_NAME and IsPedInAnyVehicle(PlayerPedId(), false) then
            local coords = GetEntityCoords(PlayerPedId())
            local dist = #(coords - vracanje.Koordinate)

            if dist <= 50.0 then
                sleep = 0
                if dist <= 15.0 then
                    DrawMarker(1, vracanje.Koordinate.x, vracanje.Koordinate.y, vracanje.Koordinate.z - 0.98,
                        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 255, 180,
                        false, true, 2, false, false, false, false)
                end
                if dist <= 3.0 then
                    DrawText3D(vracanje.Koordinate.x, vracanje.Koordinate.y, vracanje.Koordinate.z + 1.0, '[E] Vrati vozilo u garazu')
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('jamaica_bolnica>client>ObrisiVozilo', 'Vozilo')
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

RegisterNetEvent('jamaica_bolnica>client>OtvoriMenu', function(tip)
    if ESX.PlayerData.job.name ~= JOB_NAME then
        return TriggerServerEvent('jamaica_bolnica>server>AntiCheat')
    end

    if tip == 'Vozila' then
        otvoriVozilaMenu()
    elseif tip == 'Sef' then
        exports.ox_inventory:openInventory('stash', 'Bolnica')
    elseif tip == 'Helikopteri' then
        otvoriHelikopterMenu()
    end
end)

RegisterNetEvent('jamaica_bolnica>client>ObrisiVozilo', function(tip)
    if ESX.PlayerData.job.name ~= JOB_NAME then
        return TriggerServerEvent('jamaica_bolnica>server>AntiCheat')
    end

    local coords = GetEntityCoords(PlayerPedId())

    if tip == 'Vozilo' then
        local vozilica = Vozilo
        if (not vozilica or not DoesEntityExist(vozilica)) and IsPedInAnyVehicle(PlayerPedId(), false) then
            vozilica = GetVehiclePedIsIn(PlayerPedId(), false)
        end
        if not vozilica or not DoesEntityExist(vozilica) then
            return ESX.ShowNotification('~r~Vozilo ~r~nije kreirano~s~.', 'error')
        end
        if #(coords - GetEntityCoords(vozilica)) > 37.0 then
            return ESX.ShowNotification('~r~Vozilo ~r~nije blizu~s~.', 'error')
        end

        local tablice = GetVehicleNumberPlateText(vozilica)
        screenFade(true)
        DeleteEntity(vozilica)
        Vozilo = nil
        screenFade(false)
        TriggerServerEvent('okokGarage:RemoveKeys', tablice)
        ESX.ShowNotification('~r~Vozilo ~s~je ~r~obrisano~s~.', 'success')
    elseif tip == 'Helikopter' then
        if not Helikopter then
            return ESX.ShowNotification('~r~Helikopter ~r~nije kreiran~s~.', 'error')
        end
        if not DoesEntityExist(Helikopter) then
            Helikopter = nil
            return ESX.ShowNotification('~r~Helikopter ~s~vise ~r~ne postoji~s~.', 'success')
        end
        if #(coords - GetEntityCoords(Helikopter)) > 69.0 then
            return ESX.ShowNotification('~r~Helikopter ~r~nije blizu~s~.', 'error')
        end

        screenFade(true)
        DeleteEntity(Helikopter)
        Helikopter = nil
        screenFade(false)
        ESX.ShowNotification('~r~Helikopter ~s~je ~r~obrisan~s~.', 'success')
    end
end)

RegisterNetEvent('jamaica_bolnica>client>ZavrsiPretrazivanje', function()
    if not LocalPlayer.state.Mrtav or Pretrazen or Sekunde <= 10 then return end
    Pretrazen = true
    Sekunde = 10
    SendNUIMessage({ Ekran = true, Sekunde = Sekunde, Bolnica = MozePozvat })
end)
