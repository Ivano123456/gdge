local carry = {
    InProgress = false,
    targetSrc = -1,
    type = "",
    personCarrying = {
        animDict = "missfinale_c2mcs_1",
        anim = "fin_c2_mcs_1_camman",
        flag = 49,
    },
    personCarried = {
        animDict = "nm",
        anim = "firemans_carry",
        attachX = 0.27,
        attachY = 0.15,
        attachZ = 0.63,
        flag = 33,
    },
    underwaterAnim = {
        animDict = "move_swimming",
        anim = "idle",
        flag = 51,
    }
}

local function drawNativeNotification(text)
    TriggerEvent('esx:showNotification', text)
end

local function GetClosestPlayer(radius)
    local radiusSq = radius * radius
    local players = GetActivePlayers()
    local closestDistanceSq = radiusSq + 1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local px, py, pz = table.unpack(GetEntityCoords(playerPed))

    for i = 1, #players do
        local playerId = players[i]
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local tx, ty, tz = table.unpack(GetEntityCoords(targetPed))
            local dx, dy, dz = tx - px, ty - py, tz - pz
            local distSq = dx * dx + dy * dy + dz * dz
            if distSq < closestDistanceSq then
                closestPlayer = playerId
                closestDistanceSq = distSq
            end
        end
    end

    if closestPlayer ~= -1 then
        return closestPlayer
    end
end

local function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end        
    end
    return animDict
end

RegisterCommand("carry",function(source, args)
    if not carry.InProgress then
        local playerPed = PlayerPedId()
        local state = LocalPlayer.state

        if state.Mrtav or state.Knockan or IsPedFatallyInjured(playerPed) or IsEntityDead(playerPed) then
            drawNativeNotification('Ne mozes carry dok si mrtav!')
            return
        end

        local closestPlayer = GetClosestPlayer(3)
        if closestPlayer then
            local targetSrc = GetPlayerServerId(closestPlayer)
            if targetSrc ~= -1 then
                carry.InProgress = true
                carry.targetSrc = targetSrc
                TriggerServerEvent("CarryPeople:sync",targetSrc)
                
                if IsPedSwimming(playerPed) or IsPedSwimmingUnderWater(playerPed) then
                    ensureAnimDict(carry.underwaterAnim.animDict)
                else
                    ensureAnimDict(carry.personCarrying.animDict)
                end
                
                carry.type = "carrying"
            else
                drawNativeNotification("Nema nikoga u vasoj blizini!")
            end
        else
            drawNativeNotification("Nema nikoga u vasoj blizini!")
        end
    else
        carry.InProgress = false
        ClearPedSecondaryTask(PlayerPedId())
        DetachEntity(PlayerPedId(), true, false)
        TriggerServerEvent("CarryPeople:stop",carry.targetSrc)
        carry.targetSrc = 0
    end
end,false)

RegisterNetEvent("CarryPeople:syncTarget")
AddEventHandler("CarryPeople:syncTarget", function(targetSrc)
    local playerPed = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
    
    carry.InProgress = true
    
    if IsPedSwimming(playerPed) or IsPedSwimmingUnderWater(playerPed) then
        ensureAnimDict(carry.underwaterAnim.animDict)
    else
        ensureAnimDict(carry.personCarried.animDict)
    end
    
    AttachEntityToEntity(playerPed, targetPed, 0, carry.personCarried.attachX, carry.personCarried.attachY, carry.personCarried.attachZ, 0.5, 0.5, 180, false, false, false, false, 2, false)
    carry.type = "beingcarried"
end)

RegisterNetEvent("CarryPeople:cl_stop")
AddEventHandler("CarryPeople:cl_stop", function()
    carry.InProgress = false
    ClearPedSecondaryTask(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
end)

CreateThread(function()
    while true do
        local sleep = 500
        if carry.InProgress then
            sleep = 0
            local playerPed = PlayerPedId()
            local isUnderwater = IsPedSwimming(playerPed) or IsPedSwimmingUnderWater(playerPed)
            
            if carry.type == "beingcarried" then
                if isUnderwater then
                    if not IsEntityPlayingAnim(playerPed, carry.underwaterAnim.animDict, carry.underwaterAnim.anim, 3) then
                        TaskPlayAnim(playerPed, carry.underwaterAnim.animDict, carry.underwaterAnim.anim, 8.0, -8.0, 100000, carry.underwaterAnim.flag, 0, false, false, false)
                    end
                else
                    if not IsEntityPlayingAnim(playerPed, carry.personCarried.animDict, carry.personCarried.anim, 3) then
                        TaskPlayAnim(playerPed, carry.personCarried.animDict, carry.personCarried.anim, 8.0, -8.0, 100000, carry.personCarried.flag, 0, false, false, false)
                    end
                end
            elseif carry.type == "carrying" then
                if isUnderwater then
                    if not IsEntityPlayingAnim(playerPed, carry.underwaterAnim.animDict, carry.underwaterAnim.anim, 3) then
                        TaskPlayAnim(playerPed, carry.underwaterAnim.animDict, carry.underwaterAnim.anim, 8.0, -8.0, 100000, carry.underwaterAnim.flag, 0, false, false, false)
                    end
                else
                    if not IsEntityPlayingAnim(playerPed, carry.personCarrying.animDict, carry.personCarrying.anim, 3) then
                        TaskPlayAnim(playerPed, carry.personCarrying.animDict, carry.personCarrying.anim, 8.0, -8.0, 100000, carry.personCarrying.flag, 0, false, false, false)
                    end
                end
            end
        end
        Wait(sleep)
    end
end)