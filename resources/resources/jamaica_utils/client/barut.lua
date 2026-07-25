local collecting = false

local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end

    local camCoords = GetGameplayCamCoords()
    local dist = #(camCoords - vector3(x, y, z))
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

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

local function collectBarut()
    if collecting or lib.progressActive() then return end

    local spot = Config.Barut
    if not spot then return end

    local ped = cache.ped or PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local target = vector3(spot.coords.x, spot.coords.y, spot.coords.z)

    if #(pedCoords - target) > (spot.interactDistance + 0.5) then return end

    collecting = true
    SetEntityHeading(ped, spot.coords.w or 0.0)

    local dict = 'mini@repair'
    local clip = 'fixing_a_player'
    lib.requestAnimDict(dict)
    TaskPlayAnim(ped, dict, clip, 8.0, -8.0, -1, 1, 0, false, false, false)

    local ok = lib.progressBar({
        duration = spot.duration or 5000,
        label = 'Sakupljas barut...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false,
        },
    })

    ClearPedTasks(ped)
    collecting = false

    if not ok then return end

    if #(GetEntityCoords(ped) - target) > (spot.interactDistance + 0.5) then
        lib.notify({ description = 'Predaleko si od tačke.', type = 'error' })
        return
    end

    lib.callback('jamaica_utils:barut:collect', false, function(success, message)
        if success then
            lib.notify({ description = 'Dobio si 1x barut.', type = 'success' })
        elseif message then
            lib.notify({ description = message, type = 'error' })
        end
    end)
end

CreateThread(function()
    local spot = Config.Barut
    if not spot or not spot.coords then return end

    local drawDist = spot.drawDistance or 15.0
    local interactDist = spot.interactDistance or 2.0
    local target = vector3(spot.coords.x, spot.coords.y, spot.coords.z)
    local size = vector3(1.5, 1.5, 1.0)

    while true do
        local sleep = 500
        local ped = cache.ped or PlayerPedId()
        local coords = GetEntityCoords(ped)
        local distance = #(coords - target)

        if distance < drawDist then
            sleep = 0
            DrawMarker(
                1,
                spot.coords.x, spot.coords.y, spot.coords.z - 0.98,
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                size.x, size.y, size.z,
                255, 255, 255, 180,
                false, true, 2, false, false, false, false
            )

            if distance <= interactDist and not collecting and not lib.progressActive() then
                DrawText3D(spot.coords.x, spot.coords.y, spot.coords.z + 1.0, '[E] Sakupljaj barut')

                if IsControlJustReleased(0, 38) then
                    collectBarut()
                end
            end
        end

        Wait(sleep)
    end
end)
