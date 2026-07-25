local targetSystem = "qtarget"

if Config.Framework == "QBCore" then
    targetSystem = "qb-target"
end

-- OX_Target have a backward compability to qtarget
if GetResourceState("ox_target") ~= "missing" then
    targetSystem = "qtarget"
end

local pedsToSpawn<const> = {
    {
        model = `a_m_y_mexthug_01`,
        coords = vector4(-424.18, -1728.82, 18.81, 86.95),
        targetOptions = {
            {
                event = "17mov_Scrapyard:OpenMainMenu",
                icon = "fa-solid fa-handshake-simple",
                label = _L("Target:OpenMenu"),
                job = Config.RequiredJob ~= "none" and Config.RequiredJob or nil,
                canInteract = function(entity)
                    return #(GetEntityCoords(PlayerPedId()) - vec3(Config.Locations.JobMenu.Coords[1].x, Config.Locations.JobMenu.Coords[1].y, Config.Locations.JobMenu.Coords[1].z)) < 5.0
                end
            },
        }
    },
    {
        model = `s_m_m_gardener_01`,
        coords = vector4(-464.6682, -1740.1742, 15.7633, 77.8737),
        targetOptions = {
            {
                event = "17mov_Scrapyard:OpenForkliftMenu",
                icon = "fa-solid fa-handshake-simple",
                label = _L("Target:RentForklift"),
                job = Config.RequiredJob ~= "none" and Config.RequiredJob or nil,
                canInteract = function(entity)
                    return OnDuty
                end
            },
        }
    },
}

function SpawnPeds()
    for i = 1, #pedsToSpawn do
        if DoesEntityExist(pedsToSpawn[i].ped) then
            goto continue
        end

        local ped = Core.SpawnPed(pedsToSpawn[i].model, pedsToSpawn[i].coords, false, true)

        if not ped then
            Core.Print(("Failed to spawn ped: %s"):format(pedsToSpawn[i].model))
            goto continue
        end

        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)

        exports[targetSystem]:AddTargetEntity(ped, {
            options = pedsToSpawn[i].targetOptions,
            distance = 2.5,
        })

        pedsToSpawn[i].ped = ped

        ::continue::
    end
end

function DeletePeds()
    for i = 1, #pedsToSpawn do
        if DoesEntityExist(pedsToSpawn[i].ped) then
            DeletePed(pedsToSpawn[i].ped)
            pedsToSpawn[i].ped = nil
        end
    end
end

RegisterNetEvent("17mov_Scrapyard:OpenMainMenu", function()
    OpenDutyMenu()
end)

RegisterNetEvent("17mov_Scrapyard:OpenForkliftMenu", function()
    OpenPanel("RentForklift")
end)
