local heistOn = false
local spotsDone, spotBlips, spotPoints = {}, {}, {}
local pdVeh = nil
local pdLibPoints = {}
local playerIsCop = false

local yachtCenter = Config.YachtCenter
local spots = Config.SearchLocations
local spotCount = Config.SpotCount
local cancelDist = Config.CancelDist
local interactDist = Config.InteractDist
local title = _U('blipname')
local txtStart = _U('start_robbery')
local txtSearch = _U('search_robbery')
local txtSearching = _U('searching')
local txtSearchBlip = _U('search_blip')

local policeJobs = {}
for i = 1, #(Config.PoliceJobs or {}) do
    policeJobs[Config.PoliceJobs[i]] = true
end

local pdDefs = {
    {
        coords = Config.PoliceBoatMarker,
        sprite = 427,
        label = _U('pd_boat'),
        labelE = '[E] ' .. _U('pd_boat'),
        hash = Config.PoliceBoatHash,
        spawn = Config.PoliceBoatSpawn,
        heli = false,
    },
    {
        coords = Config.PoliceHeliMarker,
        sprite = 43,
        label = _U('pd_heli'),
        labelE = '[E] ' .. _U('pd_heli'),
        hash = Config.PoliceHeliHash,
        spawn = Config.PoliceHeliSpawn,
        heli = true,
    },
}

local function notify(ntype, desc, dur)
    lib.notify({
        title = title,
        description = desc,
        type = ntype,
        position = 'top-center',
        duration = dur or 4000,
    })
end

local function isCopJob()
    local job = ESX.PlayerData and ESX.PlayerData.job
    return job and policeJobs[job.name] == true
end

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(true)
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local function drawWhiteMarker(x, y, z)
    DrawMarker(1, x, y, z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 255, 180, false, true, 2, false, false, false, false)
end

local function createNamedBlip(coords, sprite, colour, scale, name)
    local b = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(b, sprite)
    SetBlipColour(b, colour)
    SetBlipScale(b, scale)
    SetBlipAsShortRange(b, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(name)
    EndTextCommandSetBlipName(b)
    return b
end

local function clearSpotBlips()
    for i, b in pairs(spotBlips) do
        if b and DoesBlipExist(b) then RemoveBlip(b) end
        spotBlips[i] = nil
    end
end

local function clearSpotPoints()
    for i, p in pairs(spotPoints) do
        if p then p:remove() end
        spotPoints[i] = nil
    end
end

local function resetHeist()
    heistOn = false
    spotsDone = {}
    clearSpotBlips()
    clearSpotPoints()
end

local function makeSpotBlips()
    clearSpotBlips()
    for i = 1, spotCount do
        if not spotsDone[i] then
            spotBlips[i] = createNamedBlip(spots[i], 1, 2, 0.7, txtSearchBlip)
        end
    end
end

local function crowdNearby()
    if not ESX.Game or not ESX.Game.GetClosestPlayer then
        return false
    end
    local target, dist = ESX.Game.GetClosestPlayer()
    return target ~= -1 and dist <= 3.5
end

local function tryBeginHeist()
    if crowdNearby() then
        return notify('error', _U('crowd'), 3000)
    end
    local ok = lib.callback.await('jamaica_jahta:tryBegin', false)
    if ok == false then
        notify('error', _U('start_failed'), 4000)
    end
end

local function searchSpot(i)
    local ped = cache.ped
    TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)
    local ok = lib.progressBar({
        duration = 10000,
        label = txtSearching,
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true },
    })
    ClearPedTasks(ped)
    if ok then
        TriggerServerEvent('jamaica_jahta:searchSpot', i)
    end
end

local function makeSpotPoints()
    clearSpotPoints()
    for i = 1, spotCount do
        local c = spots[i]
        local sx, sy, sz = c.x, c.y, c.z
        spotPoints[i] = lib.points.new({
            coords = c,
            distance = 20.0,
            nearby = function(self)
                if not heistOn or spotsDone[i] then return end
                drawWhiteMarker(sx, sy, sz)
                if self.currentDistance <= interactDist then
                    DrawText3D(sx, sy, sz + 1.0, txtSearch)
                    if IsControlJustReleased(0, 38) then
                        searchSpot(i)
                    end
                end
            end,
        })
    end
end

local function loadAndSpawn(def)
    if pdVeh and DoesEntityExist(pdVeh) then DeleteEntity(pdVeh) end
    local hash = def.hash
    if not IsModelInCdimage(hash) then return end
    lib.requestModel(hash, 5000)
    if not HasModelLoaded(hash) then return end
    local s = def.spawn
    local veh = CreateVehicle(hash, s.x, s.y, s.z, s.w, true, false)
    if not DoesEntityExist(veh) then
        SetModelAsNoLongerNeeded(hash)
        return
    end
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleFuelLevel(veh, 100.0)
    if def.heli then SetHeliBladesFullSpeed(veh) end
    SetModelAsNoLongerNeeded(hash)
    pdVeh = veh
    TaskWarpPedIntoVehicle(cache.ped, veh, -1)
    notify('success', _U('pd_ready'):format(def.label), 3000)
end

local function clearPdPoints()
    for i = 1, #pdLibPoints do
        local entry = pdLibPoints[i]
        if entry then
            if entry.point then entry.point:remove() end
            if entry.blip and DoesBlipExist(entry.blip) then RemoveBlip(entry.blip) end
        end
        pdLibPoints[i] = nil
    end
end

local function setupPdPoints()
    clearPdPoints()
    if not playerIsCop then return end

    for i = 1, #pdDefs do
        local def = pdDefs[i]
        local c = def.coords
        local mx, my, mz = c.x, c.y, c.z
        pdLibPoints[i] = {
            blip = createNamedBlip(c, def.sprite, 3, 0.8, def.label),
            point = lib.points.new({
                coords = c,
                distance = 30.0,
                nearby = function(self)
                    drawWhiteMarker(mx, my, mz)
                    if self.currentDistance <= interactDist then
                        DrawText3D(mx, my, mz + 1.0, def.labelE)
                        if IsControlJustReleased(0, 38) then
                            loadAndSpawn(def)
                        end
                    end
                end,
            }),
        }
    end
end

local function setCopState(state)
    local nextState = state and true or false
    if playerIsCop == nextState then return end
    playerIsCop = nextState
    setupPdPoints()
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    setCopState(isCopJob())
end)

RegisterNetEvent('esx:setJob', function(job)
    ESX.PlayerData.job = job
    setCopState(isCopJob())
end)

RegisterNetEvent('jamaica_jahta:notify', function(ntype, msg)
    notify(ntype, msg)
end)

RegisterNetEvent('jamaica_jahta:syncStart', function()
    heistOn = true
    spotsDone = {}
    makeSpotBlips()
    makeSpotPoints()
    notify('info', _U('robbery_started'), 5000)
end)

RegisterNetEvent('jamaica_jahta:spotDone', function(idx, done)
    spotsDone[idx] = true
    local b = spotBlips[idx]
    if b and DoesBlipExist(b) then
        RemoveBlip(b)
        spotBlips[idx] = nil
    end
    local p = spotPoints[idx]
    if p then
        p:remove()
        spotPoints[idx] = nil
    end
    local left = spotCount - done
    if left > 0 then notify('info', _U('spots_left'):format(left), 3000) end
end)

RegisterNetEvent('jamaica_jahta:finished', function()
    resetHeist()
    notify('success', _U('suitcase_found'), 5000)
end)

RegisterNetEvent('jamaica_jahta:abort', resetHeist)

createNamedBlip(yachtCenter, 455, 3, 0.8, title)

lib.points.new({
    coords = yachtCenter,
    distance = 30.0,
    nearby = function(self)
        if heistOn then return end
        local ax, ay, az = yachtCenter.x, yachtCenter.y, yachtCenter.z
        drawWhiteMarker(ax, ay, az)
        if self.currentDistance <= interactDist then
            DrawText3D(ax, ay, az + 1.0, txtStart)
            if IsControlJustReleased(0, 38) then
                tryBeginHeist()
            end
        end
    end,
})

lib.points.new({
    coords = yachtCenter,
    distance = cancelDist,
    onExit = function()
        if not heistOn then return end
        TriggerServerEvent('jamaica_jahta:leftZone')
        resetHeist()
        notify('error', _U('too_far'), 3500)
    end,
})

CreateThread(function()
    while not ESX.PlayerData or not ESX.PlayerData.job do
        Wait(1000)
    end
    setCopState(isCopJob())
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    clearSpotBlips()
    clearSpotPoints()
    clearPdPoints()
    if pdVeh and DoesEntityExist(pdVeh) then DeleteEntity(pdVeh) end
end)
