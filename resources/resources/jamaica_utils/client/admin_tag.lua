local currentAdminPlayers = {}
local visibleAdmins = {}
local playerId = cache.playerId

local labelCache = {}
local function getLabel(adminData)
    local cacheKey = adminData.source .. (adminData.group or adminData.permission or '')
    if labelCache[cacheKey] then
        return labelCache[cacheKey]
    end
    
    local groupLabel = Config.GroupLabels[adminData.group]
    if not groupLabel then return end
    local label = ' ~w~[ ' .. groupLabel .. ' ~w~] ' .. GetPlayerName(GetPlayerFromServerId(adminData.source))
    
    labelCache[cacheKey] = label
    return label
end

RegisterNetEvent('relisoft_tag:set_admins')
AddEventHandler('relisoft_tag:set_admins', function(admins)
    currentAdminPlayers = admins or {}
    labelCache = {}
    
    for id in pairs(visibleAdmins) do
        if not admins or admins[id] == nil then
            visibleAdmins[id] = nil
        end
    end
end)

CreateThread(function()
    Wait(2000)
    ESX.TriggerServerCallback('relisoft_tag:getAdminsPlayers', function(admins)
        currentAdminPlayers = admins or {}
        labelCache = {}
        visibleAdmins = {}
    end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    ESX.TriggerServerCallback('relisoft_tag:getAdminsPlayers', function(admins)
        currentAdminPlayers = admins or {}
        labelCache = {}
        visibleAdmins = {}
    end)
end)

local camCoordsCache = vector3(0, 0, 0)
local fovCache = 0
local camCacheTime = 0

local function draw3DText(pos, text, options)
    options = options or {}
    local color = options.color or { r = 255, g = 255, b = 255, a = 255 }
    local scaleOption = options.size or 0.8

    local currentTime = GetGameTimer()
    if currentTime - camCacheTime > 50 then
        camCoordsCache = GetGameplayCamCoords()
        fovCache = GetGameplayCamFov()
        camCacheTime = currentTime
    end

    local dist = #(camCoordsCache - pos)
    if dist > Config.SeeDistance then return end
    
    local scale = (scaleOption / dist) * 2
    local fov = (1 / fovCache) * 100
    local scaleMultiplier = scale * fov
    
    SetDrawOrigin(pos.x, pos.y, pos.z + 0.2, 0)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.0 * scaleMultiplier, 0.65 * scaleMultiplier)
    SetTextColour(color.r, color.g, color.b, color.a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

CreateThread(function()
    while true do
        Wait(Config.NearCheckWait)
        local playerPed = PlayerPedId()
        local pedCoords = GetEntityCoords(playerPed)
        local seeDistanceSq = Config.SeeDistance * Config.SeeDistance
        
        for k, v in pairs(currentAdminPlayers) do
            if v and v.source then
                local playerServerID = GetPlayerFromServerId(v.source)
                if playerServerID ~= -1 then
                    local adminPed = GetPlayerPed(playerServerID)
                    if adminPed and adminPed ~= 0 then
                        local adminCoords = GetEntityCoords(adminPed)
                        local distanceSq = #(adminCoords - pedCoords) ^ 2
                        
                        if distanceSq < seeDistanceSq then
                            visibleAdmins[v.source] = v
                        else
                            visibleAdmins[v.source] = nil
                        end
                    else
                        visibleAdmins[v.source] = nil
                    end
                else
                    visibleAdmins[v.source] = nil
                end
            end
        end
    end
end)

CreateThread(function()
    local playerServerId = GetPlayerServerId(playerId)
    
    while true do
        local hasVisibleAdmins = next(visibleAdmins) ~= nil
        
        if hasVisibleAdmins then
            Wait(0)
            
            for k, v in pairs(visibleAdmins) do
                if v and v.source then
                    local playerServerID = GetPlayerFromServerId(v.source)
                    if playerServerID ~= -1 then
                        local adminPed = GetPlayerPed(playerServerID)
                        if adminPed and adminPed ~= 0 and IsEntityVisible(adminPed) then
                            local adminCoords = GetEntityCoords(adminPed)
                            local pos = vector3(adminCoords.x, adminCoords.y, adminCoords.z + Config.ZOffset)
                            
                            if v.source ~= playerServerId or Config.SeeOwnLabel then
                                local label = getLabel(v)
                                if label then
                                    draw3DText(pos, label, {
                                        size = Config.TextSize
                                    })
                                end
                            end
                        end
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)
