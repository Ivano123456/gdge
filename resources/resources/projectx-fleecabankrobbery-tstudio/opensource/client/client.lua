CurrentCops = 0
local zones = {}
fleecas = {"Legion", "RockfordHills", "Burton", "Alta", "GrandSenoraDesert", "BanhamCanyon"} -- Remove the bank location you want to disable from this table

if Config.Framework == "qb-core" or Config.Framework == "qbox" then
    local QBCore = exports["qb-core"]:GetCoreObject()

    function Notification(notification, notificationType, duration)
        if Config.Notification == "ox" then
            lib.notify({
                description = notification,
                type = notificationType,
                position = 'center-right',
            })
        else
            TriggerEvent('QBCore:Notify', notification, notificationType, duration)
        end
    end

    function HasItem(item)
        if Config.Inventory == "ox" then
            return exports.ox_inventory:GetItemCount(item) > 0
        elseif Config.Inventory == "origen" then
            return exports.origen_inventory:HasItem(item)

        elseif Config.Inventory == "tgiann" then
            return exports["tgiann-inventory"]:HasItem(item, 1)
        else
            return QBCore.Functions.HasItem(item)
        end
    end

    function Progressbar(name, label, duration, success, fail, icon)
        if Config.Progressbar == "ox" then
            if lib.progressCircle({
                duration = duration,
                position = 'bottom',
                useWhileDead = false,
                label = label,
                canCancel = false,
                disable = {car = true},
            }) then success() end
        else
            QBCore.Functions.Progressbar(name, label, duration, false, false, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            }, {}, {}, {}, success, fail, icon)
        end
    end

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        TriggerEvent('projectx-fleecabankrobbery:client:Logout')
    end)
elseif Config.Framework == "esx" then
    function Notification(notification, notificationType, duration)
        if Config.Notification == "ox" then
            lib.notify({
                description = notification,
                type = notificationType,
                position = 'center-right',
            })
        else
            TriggerEvent('esx:showNotification', notification, notificationType, duration)
        end
    end
    
    function HasItem(item)
        local p = promise.new()
        lib.callback('projectx-fleecabankrobbery:server:hasitem', false, function(name)
            p:resolve(name)
        end, item)
        return Citizen.Await(p)
    end
    
    function Progressbar(name, label, duration, success, fail, icon)
        if lib.progressCircle({
            duration = duration,
            position = 'bottom',
            useWhileDead = false,
            label = label,
            canCancel = false,
            disable = {car = true},
        }) then success() end
    end
    
    RegisterNetEvent('projectx-fleecabankrobbery:client:PdNotify', function(coords)
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 364)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 59)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Fleeca Bank Robbery")
        EndTextCommandSetBlipName(blip)
        SetTimeout(120000, function()
            RemoveBlip(blip)
        end)
    end)
    
    RegisterNetEvent('esx:onPlayerLogout', function()
        TriggerEvent('projectx-fleecabankrobbery:client:Logout')
    end)
else

end

function AlertDialog(header, content, size)
    local _ = lib.alertDialog({
        header = header,
        content = content,
        centered = true,
        size = size,
        cancel = true
    })
end

function CreateCircleZones(name, coords, size, event, icon, label, distance, param, param2, param3, param4)
    if not Config.WorldInteract then
        if Config.Target == "ox_target" then
            exports.ox_target:addSphereZone({
                name = name,
                coords = coords,
                radius = size,
                debug = Config.debug,
                drawSprite = true,
                options =
                {{
                    icon = icon,
                    label = label,
                    distance = distance,
                    onSelect = event,
                }}
            })
        else
            exports[Config.Target]:AddCircleZone(name, coords, size, {name = name, debugPoly = Config.debug, useZ=true},
                {
                options = {
                    {
                        name = name,
                        type = "client",
                        action = event,
                        icon = icon,
                        label = label,
                        coords = coords,
                    }
                },
                distance = distance
            })
        end
    else
        exports.interact:AddInteraction({
            coords = coords,
            distance = 3.0,
            interactDst = distance, -- optional
            id = name, -- needed for removing interactions
            name = name, -- optional
            options = {
                {
                    label = label,
                    action = function()
                        TriggerEvent(event, param, param2, param3, param4)
                    end,
                },
            }
        })
    end
end

function CircleZoneDestroy(name)
    if Config.WorldInteract then return exports.interact:RemoveInteraction(name) end
    if Config.Target == "ox_target" then exports.ox_target:removeZone(name) else exports[Config.Target]:RemoveZone(name) end
end

function drawTextUi(bool, text)
    if Config.Drawtext == "OX" then
        if bool then lib.showTextUI(text) else lib.hideTextUI() end
    elseif Config.Drawtext == "QB" then
        if bool then exports['qb-core']:DrawText(text) else exports['qb-core']:HideText() end
    elseif Config.Drawtext == "OLDQB" then
        if bool then exports['qb-drawtext']:DrawText(text) else exports['qb-drawtext']:HideText() end    
    end
end

function zoneDestroy(name)
    for k, v in pairs(zones) do
        if v.name == name then
            zones[k]:remove()
            table.remove(zones, k)
        end
    end
end

function zoneCreate(name, coords, size, rotation, onEnter, onExit)
    zones[#zones + 1] = lib.zones.box({
        name = name,
        coords = coords,
        size = size,
        rotation = rotation,
        debug = Config.debug,
        onEnter = onEnter,
        onExit = onExit,
    })
end

function OnEvidence(pos, chance)
    if math.random(1, 100) > chance or IsWearingHandshoes() then return end
    TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
end

function Stress(chance)
    TriggerServerEvent('hud:server:GainStress', chance)
end

function Dispatch()
    local coords = GetEntityCoords(PlayerPedId())
    local PoliceJobs = {}
    for k, v in pairs(Config.PoliceJobs) do table.insert(PoliceJobs, k) end
    if Config.Dispatch == "cd" then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = {'police'},
            coords = data.coords,
            title = '10-15 - Fleeca Bank Robbery',
            message = 'A '..data.sex..' robbing a bank at '..data.street,
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 431, 
                scale = 1.2, 
                colour = 3,
                flashes = false, 
                text = '911 - Fleeca Bank Robbery',
                time = 5,
                radius = 0,
            }
        })
    elseif Config.Dispatch == "origen" then
        TriggerServerEvent("SendAlert:police", {
            coords = coords,
            title = 'Fleeca Bank',
            type = 'GENERAL',
            message = 'A Fleeca Bank is being robbed',
            job = PoliceJobs,
        })
    elseif Config.Dispatch == "tk" then
        exports['tk_dispatch']:addCall({
            title = 'Fleeca Bank Robbery',
            code = '10-58',
            priority = 'Priority 3',
            showLocation = true,
            showGender = true,
            playSound = true,
            blip = {
                color = 3,
                sprite = 357,
                scale = 1.0,
            },
            jobs = PoliceJobs
        })
    elseif Config.Dispatch == "rcore" then
        local player_data = exports['rcore_dispatch']:GetPlayerData()
        local data = {
            code = '10-35 Fleeca Bank Robbery',
            default_priority = 'medium',
            coords = player_data.coords,
            job = PoliceJobs,
            text = 'Fleeca Bank Robbery!',
            type = 'alert',
            blip_time = 5,
            blip = {
                sprite = 272, 
                colour = 3,
                scale = 0.7,
                text = 'Fleeca Bank Robbery',
                flashes = false,
                radius = 0,
            }
        }
        TriggerServerEvent('rcore_dispatch:server:sendAlert', data)
    elseif Config.Dispatch == "outlaw" then
        local data = {displayCode = '211', description = 'Robbery', isImportant = 0, recipientList = PoliceJobs, length = '10000', infoM = 'fa-info-circle', info = 'Fleeca Bank Robbery'}
        local dispatchData = {dispatchData = data, caller = 'Alarm', coords = coords}
        TriggerEvent('wf-alerts:svNotify', dispatchData)
    elseif Config.Dispatch == "codem" then
        local Data = {
            type = 'Robbery',
            header = 'Robbery in progress',
            text = 'Fleeca Bank Robbery in progress',
            code = '10-54',
        }
        exports['codem-dispatch']:CustomDispatch(Data)

    elseif Config.Dispatch == "ps" then
        exports['ps-dispatch']:FleecaBankRobbery()

    elseif Config.Dispatch == "ps" then
        exports['ps-dispatch']:FleecaBankRobbery()
    elseif Config.Dispatch == "lb" then
        TriggerServerEvent('Shop:lb-tablet:Dispatch', {
            priority = 'high',
            code = '10-31',
            title = "Fleeca Bank Robbery",
            description = 'Fleeca Bank Robbery in progress',
            location = {label = "Fleeca Bank Robbery", coords = { x = coords.x, y = coords.y}},
            time = 100,
            image = 'https://www.alibirp.com/image/imgtransparant.png',
            job = PoliceJobs,
        })
    elseif Config.Dispatch == "redutzu" then
        TriggerServerEvent('redutzu-mdt:server:addDispatchToMDT', {code = '10-31', title = 'Fleeca Bank Robbery', gender = 'Male', duration = 100000, coords = coords})
    elseif Config.Dispatch == "l2s" then
        local playerData = exports['l2s-dispatch']:GetPlayerData()
        TriggerServerEvent('l2s-dispatch:server:AddNotification', {
            departments = {'police'},
            title = 'Fleeca Bank Robbery',
            message = 'Fleeca Bank Robbery in progress',
            coords = vec2(playerData.coords.x, playerData.coords.y),
            priority = 1,
            sound = 1,
            street = playerData.street,
            reply = playerData.source,
            anonymous = false,
            blip = {
                sprite = 52,
                colour = 1,
                scale = 1.0,
                text = '10-31 - Fleeca Bank Robbery',
            },
            info = {
                {icon = 'video', text = 'first'},
                {icon = 'person', text = playerData.sex},
            },
        })
    elseif Config.Dispatch == "sonoran" then
        local Zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
        local Street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
        TriggerServerEvent('projectx-fleecabankrobbery:server:Sonoran', Street, Zone)
    elseif Config.Dispatch == "jamaica" then
        local ulicaHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
        local ulicaIme = GetStreetNameFromHashKey(ulicaHash)
        exports['jamaica-dispatch']:KreirajPoziv({
            title = 'Poziv od strane civila',
            description = 'Pljacka Fleeca banke u toku.',
            posao = PoliceJobs,
            vremeBlipa = 2,
            coords = coords,
            ulica = ulicaIme,
            kod = '10-31',
            tip = 'SOS',
            blip = {
                sprite = 431,
                velicina = 1.2,
                text = 'Pljacka Fleeca banke',
                boja = 1,
            }
        })
    else
        if Config.Framework == "esx" then
            TriggerServerEvent('projectx-fleecabankrobbery:server:PdNotify')
            -- (ESX) Add your disptach script here if it's none of the above and remove the line above this one
        else
            -- (Qbcore) Add your disptach script here if it's none of the above
        end
    end
end

----- Client Side EXP Events (Only use this if Config.ServerSideEvents is false and your skill system has client sided functions)
RegisterNetEvent("projectx-fleecabankrobbery:client:AddExperience", function(exp)
    -- add exp function here and insert exp as a parameter
end)

function CheckExpLevel()
    -- Add "return" then add your check exp level function here
end

--------------------- Minigames ---------------------
------ You can return true to skip a minigame -------
-----------------------------------------------------

function FingerprintMinigame()
    local p = promise:new()
    if not MinigameCheck("utk_fingerprint") then p:resolve(false) return Citizen.Await(p) end
    TriggerEvent("utk_fingerprint:Start", 4, 6, 2, function(success)
        if Config.SkillSystem then
            if success then TriggerServerEvent('projectx-fleecabankrobbery:server:AddExperience', 1) end
        end
        p:resolve(success)
    end)
    return Citizen.Await(p)
end

function FuseboxMinigame()
    local p = promise.new()
    if not MinigameCheck("SN-Hacking") then p:resolve(false) return Citizen.Await(p) end
    local success = exports['SN-Hacking']:MemoryCards('hard')
    if Config.SkillSystem then
        if success then TriggerServerEvent('projectx-fleecabankrobbery:server:AddExperience', 1) end
    end
    p:resolve(success)
    return Citizen.Await(p)
end

function KeypadOneMinigame()
    local p = promise:new()
    if not MinigameCheck("simonsays") then p:resolve(false) return Citizen.Await(p) end
    local success = exports['simonsays']:StartSimonSays(5, 5)
    if Config.SkillSystem then
        if success then TriggerServerEvent('projectx-fleecabankrobbery:server:AddExperience', 1) end
    end
    p:resolve(success)
    return Citizen.Await(p)
end

function PrinterMinigame()
    local p = promise:new()
    if not MinigameCheck("lightsout") then p:resolve(false) return Citizen.Await(p) end
    local success = exports['lightsout']:StartLightsOut(4, 20)
    if Config.SkillSystem then
        if success then TriggerServerEvent('projectx-fleecabankrobbery:server:AddExperience', 1) end
    end
    p:resolve(success)
    return Citizen.Await(p)
end

function ElectricBoxMinigame()
    local p = promise.new()
    if not MinigameCheck("SN-Hacking") then p:resolve(false) return Citizen.Await(p) end
    local success = exports['SN-Hacking']:MemoryCards('medium')
    if Config.SkillSystem then
        if success then TriggerServerEvent('projectx-fleecabankrobbery:server:AddExperience', 1) end
    end
    p:resolve(success)
    return Citizen.Await(p)
end

function VaultMinigame()
    local p = promise:new()
    if not MinigameCheck("SN-Hacking") then p:resolve(false) return Citizen.Await(p) end
    local success = exports['SN-Hacking']:ColorPicker(5, 7000, 3000)
    if Config.SkillSystem then
        if success then TriggerServerEvent('projectx-fleecabankrobbery:server:AddExperience', 1) end
    end
    p:resolve(success)
    return Citizen.Await(p)
end

function JailDoorMinigame()
    local p = promise:new()
    if not MinigameCheck("SN-Hacking") then p:resolve(false) return Citizen.Await(p) end
    local success = exports['SN-Hacking']:ColorPicker(5, 7000, 3000)
    if Config.SkillSystem then
        if success then TriggerServerEvent('projectx-fleecabankrobbery:server:AddExperience', 1) end
    end
    p:resolve(success)
    return Citizen.Await(p)
end