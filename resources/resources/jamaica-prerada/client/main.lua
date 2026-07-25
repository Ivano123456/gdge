local ESX = exports.es_extended:getSharedObject()

local uiOpen = false
local activeStation = nil
local spawnedProps = {}

local function notify(msg, ntype)
    lib.notify({ description = msg, type = ntype or 'inform' })
end

local function closeUi()
    if not uiOpen then return end
    uiOpen = false
    activeStation = nil
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

local function getRecipePayload(recipeId)
    local recipe = Config.Recipes[recipeId]
    if not recipe then return nil end

    return {
        id = recipe.id,
        label = recipe.label,
        icon = recipe.icon,
        input = recipe.input,
        output = recipe.output,
        duration = recipe.duration,
    }
end

local function openStation(stationId)
    if uiOpen or lib.progressActive() then return end

    local station = Config.Stations[stationId]
    if not station then return end

    local recipe = getRecipePayload(station.recipe)
    if not recipe then return end

    lib.callback('jamaica-prerada:getData', false, function(data)
        if not data then
            notify('Prerada trenutno nije dostupna.', 'error')
            return
        end

        activeStation = stationId
        uiOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'open',
            recipe = recipe,
            inputCount = data.inputCount or 0,
            maxCraft = data.maxCraft or 0,
        })
    end, stationId)
end

local function playCraftAnim(recipe)
    if not recipe or not recipe.anim then return true end

    return lib.progressBar({
        duration = recipe.duration,
        label = recipe.progressLabel,
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
        anim = recipe.anim,
    })
end

RegisterNUICallback('close', function(_, cb)
    closeUi()
    cb('ok')
end)

RegisterNUICallback('craft', function(data, cb)
    cb('ok')

    if not uiOpen or not activeStation then return end

    local stationId = activeStation
    local amount = 1

    closeUi()

    local recipe = Config.Recipes[Config.Stations[stationId].recipe]
    if not recipe then return end

    lib.callback('jamaica-prerada:canCraft', false, function(canCraft, message)
        if not canCraft then
            notify(message or 'Nemate dovoljno materijala.', 'error')
            return
        end

        if not playCraftAnim(recipe) then
            notify('Prekinuli ste preradu.', 'error')
            return
        end

        lib.callback('jamaica-prerada:craft', false, function(result)
            result = result or {}

            if result.ok then
                notify(result.message or 'Uspešno preradjeno!', 'success')
            elseif result.message then
                notify(result.message, 'error')
            end
        end, stationId, amount)
    end, stationId, amount)
end)

local function spawnStationProp(stationId, station)
    if spawnedProps[stationId] then return end

    local model = joaat(station.prop)
    if not lib.requestModel(model, 5000) then return end

    local c = station.coords
    local prop = CreateObject(model, c.x, c.y, c.z - 1.0, false, false, false)
    if not DoesEntityExist(prop) then
        SetModelAsNoLongerNeeded(model)
        return
    end

    SetEntityHeading(prop, c.w)
    PlaceObjectOnGroundProperly(prop)
    FreezeEntityPosition(prop, true)
    SetEntityAsMissionEntity(prop, true, true)
    SetModelAsNoLongerNeeded(model)

    spawnedProps[stationId] = prop

    exports.ox_target:addLocalEntity(prop, {
        {
            name = 'jamaica_prerada_' .. stationId,
            icon = station.targetIcon,
            label = station.targetLabel,
            distance = Config.TargetDistance,
            onSelect = function()
                openStation(stationId)
            end,
        },
    })
end

CreateThread(function()
    for stationId, station in pairs(Config.Stations) do
        spawnStationProp(stationId, station)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    closeUi()

    for stationId, prop in pairs(spawnedProps) do
        if prop and DoesEntityExist(prop) then
            exports.ox_target:removeLocalEntity(prop)
            DeleteEntity(prop)
        end
        spawnedProps[stationId] = nil
    end
end)
