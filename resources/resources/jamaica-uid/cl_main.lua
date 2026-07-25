GetUniqueId = function()
    local PId = GetPlayerServerId(PlayerId())
    local uid = GlobalState.ListaUUID[tostring(PId)]
    return uid 
end

exports('GetUniqueId', GetUniqueId)

getUUIDForRich = function()
    local uid = lib.callback.await('jamaica-uid:server:getUniqueId', false)
    return uid 
end

exports('getUUIDForRich', getUUIDForRich)

getUUIDBySource = function(PId)
    local uid = GlobalState.ListaUUID[tostring(PId)]
    return uid 
end

exports('getUUIDBySource', getUUIDBySource)

--[[RegisterNetEvent('esx:playerLoaded')
 AddEventHandler('esx:playerLoaded', function (xPlayer, skin)
    Wait(500)
    local uid = GetUniqueId()
    Wait(1000)
--[[    SendNUIMessage({
        akcija = 'setaj_uid',
        uid = uid
    })
end)

CreateThread(function()
    Wait(500)
    local uid = GetUniqueId()
    Wait(1000)
    SendNUIMessage({
        akcija = 'setaj_uid',
        uid = uid
    })
end)
]]
--[[local Intervals = {}

SetInterval = function(id, msec, callback, onclear)
    if not Intervals[id] and msec then
        Intervals[id] = msec
        CreateThread(function()
            repeat
                local interval = Intervals[id]
                Wait(interval)
                callback(interval)
            until interval == -1 and (onclear and onclear() or true)
            Intervals[id] = nil
        end)
    elseif msec then Intervals[id] = msec end
end

ClearInterval = function(id)
    if Intervals[id] then Intervals[id] = -1 end
end]]

statusbar = {
    ["zdravlje"] = 0,
    ["armor"] = 0,
    ["hrana"] = 100,
    ["zedj"] = 100,
    ['kiseonik'] = 0,
    ['pricanje'] = false 
}

getajPlayerInfo = function()
    local playerData = ESX.GetPlayerData()
    if not playerData or not playerData.job then return end 

    local jobName = playerData.job.label or "N/A"
    local jobGrade = playerData.job.grade_label or playerData.job.grade or "N/A"

    local bankMoney = 0
    if playerData.accounts then
        for _, account in pairs(playerData.accounts) do
            if account.name == 'bank' then
                bankMoney = account.money
                break
            end
        end
    end

    local cashMoney = exports.ox_inventory:Search('count', 'money') or 0
    local blackMoney = exports.ox_inventory:Search('count', 'black_money') or 0

    return {
        job = string.format("%s - %s", jobName, jobGrade),
        bank = bankMoney,
        cash = cashMoney,
        black = blackMoney
    }
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)

--[[    SendNUIMessage({
        akcija = 'upali_display'
    })]]

    local playerData = ESX.GetPlayerData()

--[[    if playerData and playerData.status then
        for _, status in ipairs(playerData.status) do
            if status.name == 'hunger' then
                statusbar['hrana'] = status.val
            elseif status.name == 'thirst' then
                statusbar['zedj'] = status.val
            end
        end
    end]]

    RemoveBlip(GetNorthRadarBlip())
    SetBlipAlpha(GetNorthRadarBlip(), 0)
    DisplayRadar(true)

    --LoadujDefault()

end)

AddEventHandler("onResourceStop", function(res)
    if GetCurrentResourceName() == res then
        --[[ClearInterval('updatuj_hud')
        ClearInterval('updatuj_stalno')
        ClearInterval('updatuj_zdravlje')]]
    end

--[[    local playerData = ESX.GetPlayerData()

    if playerData and playerData.status then
        for _, status in ipairs(playerData.status) do
            if status.name == 'hunger' then
                statusbar['hrana'] = status.val
            elseif status.name == 'thirst' then
                statusbar['zedj'] = status.val
            end
        end
    end
]]
end)

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then return end
    RemoveBlip(GetNorthRadarBlip())
    SetBlipAlpha(GetNorthRadarBlip(), 0)
    DisplayRadar(true)
end)

--[[CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(10)
    SetRadarBigmapEnabled(false, false)

    while true do
        Wait(100)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    while not HasScaleformMovieLoaded(minimap) do
        Wait(0)
    end

    SetMinimapComponentPosition("minimap", "L", "B", 0.0025, -0.030, 0.180, 0.188888)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0285, -0.056, 0.141, 0.159)
    SetMinimapComponentPosition("minimap_blur", "L", "B", -0.0145, -0.030, 0.300, 0.260)

    SetBlipAlpha(GetNorthRadarBlip(), 0)
    SetMinimapClipType(0)
end)]]

--[[AddEventHandler('esx_status:onTick', function(status)
    local hunger, thirst

    for i = 1, #status do
        if status[i].name == 'hunger' then
            hunger = status[i].percent
        elseif status[i].name == 'thirst' then
            thirst = status[i].percent
        end
    end

    statusbar['hrana'] = hunger or 0
    statusbar['zedj'] = thirst or 0
end)]]

--[[RegisterNetEvent('hud:client:UpdatujKontiunitet', function() 
    statusbar['armor'] = GetPedArmour(PlayerPedId())
    if IsEntityInWater(PlayerPedId()) then
        statusbar['kiseonik'] = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10
    else
        statusbar['kiseonik'] = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
    end
end)

RegisterNetEvent('hud:client:UpdatujZdravlje', function(noviHp)
    statusbar['zdravlje'] = noviHp
end)

LoadujDatu = function()
    local hrana = math.floor(statusbar['hrana'])
    local zedj = math.floor(statusbar['zedj'])

    if hrana >= 100 then 
        hrana = 100
    end

    if zedj >= 100 then 
        zedj = 100
    end
    
    SendNUIMessage({
        akcija = "update_status", 
        hunger = hrana,
        thirst = zedj,
        armor = math.floor(statusbar['armor']),
        health = math.floor(statusbar['zdravlje']),
        oxygen = math.floor(statusbar['kiseonik']), 
    })

    local info_board = getajPlayerInfo()
    if info_board then 

        SendNUIMessage({
            akcija = "update_info", 
            job = info_board.job,
            bank = info_board.bank,
            cash = info_board.cash,
            blackMoney = info_board.black, 
        })

        Wait(200)

        SendNUIMessage({
            akcija = 'setaj_id', 
            id = GetPlayerServerId(PlayerId())
        })

    end

end

LoadujDefault = function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(10)
    SetRadarBigmapEnabled(false, false)
    while true do
        Wait(100)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()	
    end
end]]

--[[CreateThread(function()

    SetInterval("updatuj_igrace", 1000, function()
        local trenutniIgrac, maxIgraca = lib.callback.await('jamaica-utils:server:getajBrojIgraca', false)
        SendNUIMessage({
            akcija = 'updatuj_broj_igraca',
            broj_igraca = trenutniIgrac .. '/' .. maxIgraca
        })
    end)

    SetInterval("updatuj_hud", 500, function()
        LoadujDatu()
    end)

    SetInterval("updatuj_stalno", 100, function()
        TriggerEvent("hud:client:UpdatujKontiunitet")
        Pricanje()
    end)

    SetInterval("updatuj_zdravlje", 1500, function()
        local ped = PlayerPedId()
        local trenutnoZdravlje = GetEntityHealth(ped)
        
        local realnoZdravlje = trenutnoZdravlje - 100
        if realnoZdravlje < 0 then realnoZdravlje = 0 end

        local maksimalnoZdravlje = 100.0

        local model = GetEntityModel(ped)
        if model == GetHashKey("mp_m_freemode_01") then
            maksimalnoZdravlje = 100.0
        elseif model == GetHashKey("mp_f_freemode_01") then
            maksimalnoZdravlje = 100.0
        end

        local procenatZdravlja = (realnoZdravlje / maksimalnoZdravlje) * 100.0

        if math.floor(procenatZdravlja) ~= math.floor(statusbar['zdravlje']) then
            local player = PlayerPedId()
            local health = (GetEntityHealth(player) - 100)
            TriggerEvent("hud:client:UpdatujZdravlje", math.floor(procenatZdravlja))
        end
    end)

end)]]

--[[Pricanje = function()
    SendNUIMessage({
        akcija = "update_status",
        mic = NetworkIsPlayerTalking(PlayerId())
    })
end

local getajGorivo = function(veh)
    local fuel = exports['okokGasStation']:GetFuel(veh)
    return fuel or 0 
end

lib.onCache('vehicle', function(current_veh)
    if IsPedInAnyVehicle(PlayerPedId(), true) then 
        SendNUIMessage({
            akcija = 'upali_carhud'
        })
    else
        SendNUIMessage({
            akcija = 'ugasi_carhud'
        })
    end
end)

CreateThread(function()
    while true do
        Wait(100) 
        local playerPed = PlayerPedId()
        local jelVozi = IsPedInAnyVehicle(playerPed, false)
        if jelVozi then 
            updatujVehicleInfo()
        end
    end
end)

local function konvertujRpm(rpm)
    local minRpm = 800  
    local maxRpm = 10000 
    return math.floor(minRpm + (rpm * (maxRpm - minRpm)))
end

updatujVehicleInfo = function()
    local brzina, gorivo, rpm, temperatura, ostecenje

    local vozilo = GetVehiclePedIsIn(PlayerPedId(), false)

    if vozilo and vozilo ~= 0 then 
        brzina = math.floor(GetEntitySpeed(vozilo) * 3.6)
        gorivo = math.floor(getajGorivo(vozilo) or 0)
        local rawRpm = GetVehicleCurrentRpm(vozilo) or 0
        rpm = konvertujRpm(rawRpm)
        temperatura = GetVehicleEngineTemperature(vozilo) or 90.0

        local motorHealth = GetVehicleEngineHealth(vozilo) / 10
        motor = math.floor(motorHealth) 
        if motor >= 100 then 
            motor = 100
        end
    else
        brzina, gorivo, rpm, temperatura, motor = 0, 0, 0, 0, 0
    end

    SendNUIMessage({
        akcija = 'updatuj_carhud',
        brzina = brzina,
        gorivo = gorivo,
        rpm = rpm,
        temperatura = math.floor(temperatura or 0),
        ostecenje = motor 
    })
end]]
