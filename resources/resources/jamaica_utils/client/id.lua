local idovi = false
local naDuznosti = false
local playerCache = {}
local pendingRequests = {}

CreateThread(function()
    Wait(500)
    naDuznosti = Player(cache.serverId).state.aduznost == true
end)

RegisterNetEvent('jamaica-utils:client:toggleId', function()
    idovi = not idovi
    ESX.ShowNotification(idovi and "ID-evi ukljuceni" or "ID-evi iskljuceni", true, true, false)
end)

RegisterNetEvent("jamaica-returnPlayerData", function(serverId, data)
    playerCache[serverId] = data
    pendingRequests[serverId] = nil
end)

local function DrawMultiText3D(coords, lines)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if not onScreen then return end

    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    local scale = (1 / dist) * 1.2
    if scale < 1.15 then scale = 0.35 end

    for i, text in ipairs(lines) do
        SetTextScale(scale, scale)
        SetTextFont(6)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextOutline()
        SetTextCentre(true)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(x, y + ((i - 1) * (0.055 * scale)))
    end
end

CreateThread(function()
    local myPlayerId = cache.playerId
    local myServerId = cache.serverId
    local myCoords = vector3(0, 0, 0)
    local maxDistanceSq = 900.0
    local lastUpdate = 0
    local lastStateCheck = 0
    local updateInterval = 100
    local stateCheckInterval = 500

    while true do
        local currentTime = GetGameTimer()

        if currentTime - lastStateCheck >= stateCheckInterval then
            naDuznosti = Player(cache.serverId).state.aduznost == true
            lastStateCheck = currentTime
        end

        if not idovi and not naDuznosti then
            Wait(2000)
        else
            if currentTime - lastUpdate >= updateInterval then
                myPlayerId = cache.playerId
                myServerId = cache.serverId
                myCoords = GetEntityCoords(cache.ped)
                lastUpdate = currentTime
            end

            local listaUUID = GlobalState.ListaUUID or {}
            local myUUID = listaUUID[tostring(myServerId)]
            local activePlayers = GetActivePlayers()

            for i = 1, #activePlayers do
                local id = activePlayers[i]
                if id ~= myPlayerId then
                    local serverId = GetPlayerServerId(id)
                    local uuid = listaUUID[tostring(serverId)]

                    if uuid and uuid ~= myUUID then
                        if not playerCache[serverId] and not pendingRequests[serverId] then
                            pendingRequests[serverId] = true
                            TriggerServerEvent("jamaica-requestPlayerData", serverId)
                        end

                        local pdata = playerCache[serverId]
                        if pdata then
                            local ped = GetPlayerPed(id)
                            local loc = GetEntityCoords(ped)
                            local dx = loc.x - myCoords.x
                            local dy = loc.y - myCoords.y
                            local dz = loc.z - myCoords.z

                            if (dx * dx + dy * dy + dz * dz) <= maxDistanceSq then
                                loc = vector3(loc.x, loc.y, loc.z + 1.05)
                                local health = math.max(0, GetEntityHealth(ped) - 100)
                                local armour = GetPedArmour(ped)
                                local talking = NetworkIsPlayerTalking(id)

                                local lines = {
                                    string.format("~w~%d | ~o~%s~w~ | ~c~UUID:~w~ %s", serverId, pdata.name, uuid),
                                    string.format("~g~HEALTH:~w~ [ ~g~%d~w~ ] | ~b~PANCIR:~w~ [ ~b~%d~w~ ]", health, armour),
                                    string.format("~y~%s~w~ - %s", pdata.job.label, pdata.job.grade_label),
                                }

                                if talking then
                                    lines[#lines + 1] = "~r~🎤"
                                end

                                DrawMultiText3D(loc, lines)
                            end
                        end
                    end
                end
            end

            Wait(0)
        end
    end
end)
