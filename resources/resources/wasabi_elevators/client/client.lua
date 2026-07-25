local ESX = exports.es_extended:getSharedObject()
local PlayerData = {}

local function refreshPlayerData()
    PlayerData = ESX.GetPlayerData() or {}
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer or {}
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
end)

local function hasFloorAccess(floorData)
    if not floorData.groups then
        return true
    end

    local jobName = PlayerData.job and PlayerData.job.name
    if not jobName then
        return false
    end

    for i = 1, #floorData.groups do
        if jobName == floorData.groups[i] then
            return true
        end
    end

    return false
end

local function goToFloor(elevator, floor)
    local floorData = Config.Elevators[elevator][floor]
    if not floorData then return end

    local coords = floorData.coords
    local heading = floorData.heading or 0.0
    local ped = cache.ped

    DoScreenFadeOut(1500)
    while not IsScreenFadedOut() do
        Wait(10)
    end

    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    while not HasCollisionLoadedAroundEntity(ped) do
        Wait(0)
    end

    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
    SetEntityHeading(ped, heading)
    Wait(3000)
    DoScreenFadeIn(1500)
end

local function openElevatorMenu(elevator, currentFloor)
    local elevatorData = Config.Elevators[elevator]
    if not elevatorData then return end

    local options = {}

    local floorIds = {}

    for floorId in pairs(elevatorData) do
        floorIds[#floorIds + 1] = floorId
    end

    table.sort(floorIds, function(a, b)
        return a < b
    end)

    for i = 1, #floorIds do
        local floorId = floorIds[i]
        local floorData = elevatorData[floorId]
        if floorId == currentFloor then
            options[#options + 1] = {
                title = floorData.title .. ' (Trenutni)',
                description = floorData.description,
                disabled = true,
            }
        elseif hasFloorAccess(floorData) then
            options[#options + 1] = {
                title = floorData.title,
                description = floorData.description,
                onSelect = function()
                    goToFloor(elevator, floorId)
                end,
            }
        else
            options[#options + 1] = {
                title = floorData.title,
                description = floorData.description,
                onSelect = function()
                    lib.notify({
                        title = 'Lift',
                        description = 'Nemate pristup ovom spratu',
                        type = 'error',
                    })
                end,
            }
        end
    end

    lib.registerContext({
        id = 'wasabi_elevator_menu',
        title = 'Lift',
        options = options,
    })

    lib.showContext('wasabi_elevator_menu')
end

CreateThread(function()
    while GetResourceState('ox_target') ~= 'started' do
        Wait(200)
    end

    while not ESX.IsPlayerLoaded() do
        Wait(200)
    end

    refreshPlayerData()

    for elevatorId, floors in pairs(Config.Elevators) do
        for floorId, floorData in pairs(floors) do
            local targetSize = floorData.target or {}
            local width = targetSize.width or 2.5
            local length = targetSize.length or 2.5

            exports.ox_target:addBoxZone({
                name = ('wasabi_elevator:%s:%s'):format(elevatorId, floorId),
                coords = floorData.coords,
                size = vec3(width, length, 3.0),
                rotation = floorData.heading or 0.0,
                debug = false,
                options = {
                    {
                        name = ('wasabi_elevator_%s_%s'):format(elevatorId, floorId),
                        icon = 'fa-solid fa-elevator',
                        label = 'Koristi lift',
                        distance = 2.5,
                        onSelect = function()
                            openElevatorMenu(elevatorId, floorId)
                        end,
                    },
                },
            })
        end
    end
end)
