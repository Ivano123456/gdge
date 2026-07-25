---@diagnostic disable: missing-parameter
local cache = {}
local textUI = {}
local lisice = {}
local salterCooldown = {}
local propoivys
local wasDead = false
local jelVezan = false
local playerInVehicle = false
local loadedModels = {}
local loadedAnimDicts = {}
local trackedOrgVehicle = nil

local function getJobVozilaConfig(jobName)
    local cfg = GetSluzbaConfig(jobName)
    return cfg and cfg.vozila
end

local function getOrgVehicleFuelLevel(vehicle)
    if GetResourceState('okokGasStation') == 'started' then
        return exports['okokGasStation']:GetFuel(vehicle)
    end
    return GetVehicleFuelLevel(vehicle)
end

local function setOrgVehicleFuelLevel(vehicle, percent)
    if GetResourceState('okokGasStation') == 'started' then
        exports['okokGasStation']:SetFuel(vehicle, percent)
        return
    end
    SetVehicleFuelLevel(vehicle, percent + 0.0)
end

local function collectOrgVehicleProps(vehicle)
    SetVehicleAutoRepairDisabled(vehicle, true)
    Wait(50)

    local props = ESX.Game.GetVehicleProperties(vehicle)
    SetVehicleAutoRepairDisabled(vehicle, false)
    if not props then return nil end

    props.plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
    props.fuelLevel = getOrgVehicleFuelLevel(vehicle)
    return props
end

local function applyOrgVehicleProps(vehicle, props, plate)
    if type(props) == 'table' and next(props) then
        ESX.Game.SetVehicleProperties(vehicle, props)
    end
    if plate and plate ~= '' then
        SetVehicleNumberPlateText(vehicle, plate)
    end
    setOrgVehicleFuelLevel(vehicle, (props and props.fuelLevel) or 100.0)
end

local function storeOrgVehicleToGarage(plate, vehicleId, vehicleProps, onDone)
    ESX.TriggerServerCallback('jamaica-sluzbe:storeOrgVehicle', function(success, message)
        if onDone then onDone(success, message) end
    end, plate, vehicleId, vehicleProps)
end

local function clearOrgVehicleTrack()
    trackedOrgVehicle = nil
end

local function trackOrgVehicle(vehicle, data)
    if not vehicle or not data or not data.plate or data.plate == '' then return end
    clearOrgVehicleTrack()
    trackedOrgVehicle = {
        entity = vehicle,
        id = data.id,
        plate = data.plate,
    }

    CreateThread(function()
        local track = trackedOrgVehicle
        if not track then return end

        while trackedOrgVehicle == track do
            Wait(2500)
            if not DoesEntityExist(track.entity) then
                TriggerServerEvent('okokGarage:removeKeys', GetPlayerServerId(PlayerId()), track.plate)
                TriggerServerEvent('jamaica-sluzbe:impoundOrgVehicle', track.plate, track.id)
                clearOrgVehicleTrack()
                break
            end
        end
    end)
end

RegisterNetEvent('jamaica-sluzbe:client:clearOrgVehicleTrack', function()
    clearOrgVehicleTrack()
end)

local Resetuj = function()
    for i = 1, #cache do
        if cache[i].pedovi and DoesEntityExist(cache[i].pedovi) then
            DeletePed(cache[i].pedovi)
        end
        if cache[i].vozila and DoesEntityExist(cache[i].vozila) then
            DeleteEntity(cache[i].vozila)
        end
        if cache[i].objekti and DoesEntityExist(cache[i].objekti) then
            DeleteObject(cache[i].objekti)
        end
        if cache[i].blipovi then
            RemoveBlip(cache[i].blipovi)
        end
    end
    cache = {}
    
    for i = 1, #lisice do
        if lisice[i] and DoesEntityExist(lisice[i]) then
            DeleteObject(lisice[i])
        end
    end
    lisice = {}
    
    for model, _ in pairs(loadedModels) do
        SetModelAsNoLongerNeeded(model)
    end
    loadedModels = {}
    
    for dict, _ in pairs(loadedAnimDicts) do
        RemoveAnimDict(dict)
    end
    loadedAnimDicts = {}
end

AddEventHandler("onResourceStop", function(res)
    if GetCurrentResourceName() == res then
        if ESX and ESX.UI and ESX.UI.Menu then
            ESX.UI.Menu.CloseAll()
        end
        Resetuj()
    end
end)

local kreirajBlipove = function(data, label) 
    if not data then return end 

    local blip = AddBlipForCoord(data.coords)

    SetBlipSprite(blip, data.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, data.velicina)
    SetBlipColour(blip, data.boja)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)

    cache[#cache + 1] = {
        blipovi = blip,
    }
end

local kreirajPeda = function(data)
    if not data then return end 

    local modelHash = type(data.model) == "string" and GetHashKey(data.model) or data.model
    lib.requestModel(data.model)
    loadedModels[modelHash] = true
    
    local ped = CreatePed(4, modelHash, vector3(data.coords.x, data.coords.y, data.coords.z - 1), data.coords.w, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetModelAsNoLongerNeeded(modelHash)

    cache[#cache + 1] = {
        pedovi = ped,
    }

    return ped
end

local kreireajObjekat = function(data) 
    if not data then return end 
    local modelHash = type(data.model) == "string" and GetHashKey(data.model) or data.model
    lib.requestModel(data.model)
    loadedModels[modelHash] = true
    
    local obj_prop = CreateObject(modelHash, vector3(data.coords.x, data.coords.y, data.coords.z -1), false, true)
    SetEntityHeading(obj_prop, data.coords.w)
    FreezeEntityPosition(obj_prop, true) 
    SetEntityInvincible(obj_prop, true)
    SetModelAsNoLongerNeeded(modelHash)

    cache[#cache + 1] = {
        objekti = obj_prop,
    }

    return obj_prop
end

CreateThread(function()

    for k, v in pairs(Podesavanja) do 

        if v['blip'] and v['blip']['aktiviraj'] then 
            kreirajBlipove(v['blip'], v['label'])
        end

        if v['sef'] then
            local sef = kreireajObjekat(v['sef'])
            local sefOptions = {
                {
                    label = "Pristupi Sefu",
                    icon = "fa-solid fa-vault",
                    action = function(entity)
                        local input = lib.inputDialog('Sef | '..v['label'], {
                            {type = 'input', label = 'Lozinka', icon = 'fa-solid fa-unlock-keyhole', required = true, password = true},
                        })
                        if not input then return end 
                        local sifra = input[1] 
                        if sifra == v['sef']['sifra'] then 
                            exports.ox_inventory:openInventory('stash', ESX.GetPlayerData().job.name)
                            ESX.ShowNotification("Lozinka je tacna, dobili ste pristup!")
                        else
                            ESX.ShowNotification("Lozinka nije tacna!")
                        end
                    end,
                    canInteract = function(entity, distance, data)
                        return ESX.GetPlayerData().job.name == v['posao'] and JeNaDuznosti()
                    end
                }
            }
            exports.qtarget:AddTargetEntity(sef, {
                options = sefOptions,
                distance = 3
            })
        end

        if v['evidence'] then
            local pd_dokazi = kreirajPeda(v['evidence'])
            local dokaziOptions = {
                {
                    label = "Dokazi",
                    icon = "fa-solid fa-receipt",
                    action = function()
                        local input = lib.inputDialog('Evidencioni Sistem | '..v['label'], {
                            {type = 'input', label = 'Broj Dokaza', icon = 'fa-solid fa-receipt', required = true, password = true},
                        })
                        if not input then return end 
                        local id = input[1]
                        local dokaz = exports.ox_inventory:openInventory('stash', id)
                        if dokaz then 
                            ESX.ShowNotification("Pristupili ste dokazu #"..id)
                        else
                            ESX.ShowNotification("Dokaz pod ovim evidencionim brojem ne postoji!")
                        end
                    end,
                    canInteract = function()
                        return ESX.GetPlayerData().job.name == v['posao'] and JeNaDuznosti()
                    end
                },
                {
                    label = "Novi Dokaz",
                    icon = "fa-solid fa-square-plus",
                    action = function()
                        local playerData = ESX.GetPlayerData()
                        if playerData.job.grade ~= 9 then
                            ESX.ShowNotification("Samo čin 9 može kreirati novi dokaz!", "error")
                            return
                        end
                        
                        local input = lib.inputDialog('Kreiraj Dokaz | '..v['label'], {
                            {type = 'input', label = 'Broj Dokaza', icon = 'fa-solid fa-receipt', required = true, password = true},
                            {type = 'input', label = 'Kilaza', icon = 'fa-solid fa-weight-hanging', required = true, password = true},
                            {type = 'input', label = 'Slotovi', icon = 'fa-solid fa-hashtag', required = true, password = true},
                        })
                        if not input then return end 

                        local id = input[1]
                        local kilaza = tonumber(input[2]) * 1000
                        local slotovi = tonumber(input[3])
                    
                        if kilaza > 0 then 
                            if slotovi > 0 then 
                                TriggerServerEvent("jamaica-sluzbe:RegistrujDokaz", id, kilaza, slotovi)
                                ESX.ShowNotification("Sacekajte da se dokazni stash registruje 2,3 sekunde..")
                                Wait(3000)
                                exports.ox_inventory:openInventory('stash', id)
                            else
                                ESX.ShowNotification("Slotovi moraju biti veci od 0!")
                            end
                        else
                            ESX.ShowNotification("Kilaza mora biti veca od 0!")
                        end
                    end,
                    canInteract = function()
                        local playerData = ESX.GetPlayerData()
                        return playerData.job.name == v['posao'] and playerData.job.grade == 9 and JeNaDuznosti()
                    end
                }
            }
            exports.qtarget:AddTargetEntity(pd_dokazi, {
                options = dokaziOptions,
                distance = 3
            })
        end

        if v['helikopter'] then
            local heli_ped = kreirajPeda(v['helikopter'])
            local heliOptions = {
                {
                    label = "Helikopter Garaza",
                    icon = "fa-solid fa-helicopter",
                    action = function()
                        TriggerEvent("jamaica-sluzbe:client:ListaHeli", v['helikopter']['vozila'])
                    end,
                    canInteract = function()
                        return ESX.GetPlayerData().job.name == v['posao'] and JeNaDuznosti()
                    end
                }
            }
            exports.qtarget:AddTargetEntity(heli_ped, {
                options = heliOptions,
                distance = 3
            })
        end

        if v['oruzarnica'] then
            local ammo_ped = kreirajPeda(v['oruzarnica'])
            local ammoOptions = {
                {
                    label = "Zaduzi Oruzje",
                    icon = "fa-solid fa-shield-halved",
                    action = function()
                        exports.ox_inventory:openInventory('shop', { type = 'jamaica_sluzbe_' .. v['posao'] })
                    end,
                    canInteract = function()
                        return ESX.GetPlayerData().job.name == v['posao'] and JeNaDuznosti()
                    end
                }
            }
            exports.qtarget:AddTargetEntity(ammo_ped, {
                options = ammoOptions,
                distance = 3
            })
        end

        if v['salter'] then
            local posao = v['posao']
            local orgLabel = v['label']
            local salter = kreirajPeda({
                model = "s_f_y_cop_01",
                coords = v['salter']
            })
            local salterOptions = {
                {
                    label = "Pozovi sluzbenike na salter",
                    icon = "fa-solid fa-phone-volume",
                    action = function()
                        local mozel_pozvati = lib.callback.await('jamaica-sluzbe:pozoviSluzbenikeNaSalter', false, posao)
                        if not mozel_pozvati then return end

                        if salterCooldown[posao] then
                            ESX.ShowNotification("Vec ste pozvali, sacekajte malo.")
                            return
                        end

                        ESX.ShowNotification("Poziv je upucen svim sluzbenicima")

                        exports['jamaica-dispatch']:SluzbeSalter(posao, orgLabel)

                        salterCooldown[posao] = true

                        SetTimeout(120000, function()
                            salterCooldown[posao] = false
                        end)
                    end
                }
            }
            exports.qtarget:AddTargetEntity(salter, {
                options = salterOptions,
                distance = 3
            })
        end

        if v['vozila'] then
            local garazapedic = kreirajPeda(v['vozila'])
            local garazaOptions = {
                {
                    label = "Garaza organizacije",
                    icon = "fa-solid fa-warehouse",
                    action = function()
                        OpenSluzbeVehicleShopNUI()
                    end,
                    canInteract = function()
                        return ESX.GetPlayerData().job.name == v['posao'] and JeNaDuznosti()
                    end
                }
            }
            exports.qtarget:AddTargetEntity(garazapedic, {
                options = garazaOptions,
                distance = 3
            })
        end

    end   
end)

local playerData = {}

local function syncPlayerData()
    if not ESX or not ESX.GetPlayerData then return end
    local data = ESX.GetPlayerData()
    if data and data.job then
        playerData = data
    end
end

RegisterNetEvent('esx:playerLoaded', function()
    syncPlayerData()
end)

RegisterNetEvent('esx:setJob', function(job)
    syncPlayerData()
    if playerData then
        playerData.job = job
    end
end)

CreateThread(function()
    while not ESX or not ESX.IsPlayerLoaded or not ESX.IsPlayerLoaded() do Wait(200) end
    syncPlayerData()
end)

AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    CreateThread(function()
        while not ESX or not ESX.IsPlayerLoaded or not ESX.IsPlayerLoaded() do Wait(200) end
        syncPlayerData()
    end)
end)

local textUI = {}

local function disableRestrainedControls()
    DisableControlAction(0, 1, true)
    DisableControlAction(0, 2, true)
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 25, true)
    DisableControlAction(0, 263, true)
    DisableControlAction(0, 45, true)
    DisableControlAction(0, 22, true)
    DisableControlAction(0, 44, true)
    DisableControlAction(0, 37, true)
    DisableControlAction(0, 23, true)
    DisableControlAction(0, 288, true)
    DisableControlAction(0, 289, true)
    DisableControlAction(0, 170, true)
    DisableControlAction(0, 167, true)
    DisableControlAction(0, 0, true)
    DisableControlAction(0, 26, true)
    DisableControlAction(0, 73, true)
    DisableControlAction(2, 199, true)
    DisableControlAction(0, 59, true)
    DisableControlAction(0, 71, true)
    DisableControlAction(0, 72, true)
    DisableControlAction(0, 21, true)
    DisableControlAction(2, 36, true)
    DisableControlAction(0, 47, true)
    DisableControlAction(0, 264, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
    DisableControlAction(0, 143, true)
    DisableControlAction(0, 75, true)
    DisableControlAction(27, 75, true)
end

CreateThread(function()
    local ZONE_NEAR = 50.0

    local function minDistToZones(coords, cfg, inVehicle, inHeli)
        local minDist = 9999.0

        local function consider(pos)
            if not pos then return end
            local d = #(coords - pos)
            if d < minDist then minDist = d end
        end

        if cfg['ormarici'] and cfg['ormarici'].coords then
            for i = 1, #cfg['ormarici'].coords do
                consider(cfg['ormarici'].coords[i])
            end
        end

        if cfg['skladiste'] then
            consider(cfg['skladiste'].coords)
        end

        if inVehicle and cfg['vozila'] then
            consider(cfg['vozila'].parkPoint)
            consider(cfg['vozila'].repairPoint)
        end

        if inHeli and cfg['helikopter'] and cfg['helikopter']['parkiraj'] then
            local p = cfg['helikopter']['parkiraj']
            consider(vector3(p.x, p.y, p.z))
        end

        return minDist
    end

    while true do
        if jelVezan or wasDead then
            disableRestrainedControls()
            Wait(0)
        else
            local sleep = 2500
            local jobName = playerData and playerData.job and playerData.job.name
            local cfg = jobName and GetSluzbaConfig(jobName)

            if cfg then
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                local inVehicle = IsPedInAnyVehicle(ped, true)
                local inHeli = IsPedInAnyHeli(ped)
                local minDist = minDistToZones(coords, cfg, inVehicle, inHeli)

                if minDist > ZONE_NEAR then
                    textUI["ormarici" .. jobName] = nil
                    textUI["skladiste" .. jobName] = nil
                    sleep = 2500
                else
                local drawMarkers = false
                local interactZone = false
                local nearZone = false

                if cfg['ormarici'] and cfg['ormarici'].coords then
                    local closestOrmar = 999.0
                    for i = 1, #cfg['ormarici'].coords do
                        local pos = cfg['ormarici'].coords[i]
                        local dist = #(coords - pos)
                        if dist < closestOrmar then closestOrmar = dist end
                        if dist < 50.0 then nearZone = true end
                        if dist < 15.0 then
                            drawMarkers = true
                            DrawMarker(2, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.15, 0.15, 0.15, 204, 153, 0, 230, false, false, 0, true, nil, nil, false)
                        end
                    end
                    if closestOrmar < 1.0 and JeNaDuznosti() then
                        interactZone = true
                        if not textUI["ormarici" .. jobName] then
                            ESX.ShowHelpNotification('Pritisnite ~INPUT_CONTEXT~ da pristupite ormaricu')
                            textUI["ormarici" .. jobName] = true
                        end
                        if IsControlJustReleased(0, 38) then
                            if ProveriDuznost() then
                                exports.ox_inventory:openInventory('stash', "priv-ormaric-" .. jobName)
                            end
                        end
                    elseif textUI["ormarici" .. jobName] then
                        textUI["ormarici" .. jobName] = nil
                    end
                end

                if cfg['skladiste'] then
                    local skladPos = cfg['skladiste'].coords
                    local skladDist = #(coords - skladPos)
                    if skladDist < 50.0 then nearZone = true end
                    if skladDist < 15.0 then
                        drawMarkers = true
                        DrawMarker(2, skladPos.x, skladPos.y, skladPos.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.15, 0.15, 0.15, 59, 130, 246, 230, false, false, 0, true, nil, nil, false)
                    end
                    if skladDist < 1.0 and JeNaDuznosti() then
                        interactZone = true
                        if not textUI["skladiste" .. jobName] then
                            ESX.ShowHelpNotification('Pritisnite ~INPUT_CONTEXT~ da pristupite skladistu')
                            textUI["skladiste" .. jobName] = true
                        end
                        if IsControlJustReleased(0, 38) then
                            if ProveriDuznost() then
                                exports.ox_inventory:openInventory('stash', "skladiste-" .. jobName)
                            end
                        end
                    elseif textUI["skladiste" .. jobName] then
                        textUI["skladiste" .. jobName] = nil
                    end
                end

                if inVehicle and cfg['vozila'] then
                    if cfg['vozila'].parkPoint then
                        local parkCoords = cfg['vozila'].parkPoint
                        local distanca = #(coords - parkCoords)
                        if distanca < 50.0 then nearZone = true end
                        if distanca < 15.0 then
                            drawMarkers = true
                            DrawMarker(1, parkCoords.x, parkCoords.y, parkCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
                        end
                        if distanca < 3.0 and JeNaDuznosti() then
                            interactZone = true
                            ESX.Game.Utils.DrawText3D(parkCoords, '[E] Parkiraj u garazu organizacije', 0.6)
                            if IsControlJustReleased(0, 38) and ProveriDuznost() then
                                local vehicle = GetVehiclePedIsIn(ped, false)
                                local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
                                local vehicleId = trackedOrgVehicle and trackedOrgVehicle.id
                                local vehicleProps = collectOrgVehicleProps(vehicle)
                                TaskLeaveVehicle(ped, vehicle, 0)
                                Wait(1200)
                                storeOrgVehicleToGarage(plate, vehicleId, vehicleProps, function(success, message)
                                    if not success then
                                        ESX.ShowNotification(message or 'Parkiranje nije uspelo.', 'error')
                                        return
                                    end
                                    clearOrgVehicleTrack()
                                    if DoesEntityExist(vehicle) then
                                        SetVehicleEngineOn(vehicle, false, false, true)
                                        SetEntityAsMissionEntity(vehicle, true, true)
                                        DeleteVehicle(vehicle)
                                    end
                                end)
                            end
                        end
                    end

                    if cfg['vozila'].repairPoint then
                        local rep = cfg['vozila'].repairPoint
                        local dist = #(coords - rep)
                        if dist < 50.0 then nearZone = true end
                        if dist < 15.0 then
                            drawMarkers = true
                            DrawMarker(2, rep.x, rep.y, rep.z + 1.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 200, 0, 150, false, true, 2, false, nil, nil, false)
                        end
                        if dist < 2.0 and JeNaDuznosti() then
                            interactZone = true
                            ESX.Game.Utils.DrawText3D(rep, "[E] Popravi Vozilo", 0.5)
                            if IsControlJustReleased(0, 38) and ProveriDuznost() then
                                local closestVehicle = GetVehiclePedIsIn(ped, true)
                                if not closestVehicle or closestVehicle == 0 or not DoesEntityExist(closestVehicle) then
                                    ESX.ShowNotification('Nema vozila u blizini.')
                                else
                                    local percent = math.floor(GetVehicleEngineHealth(closestVehicle) / 10)
                                    if percent >= 100 then
                                        ESX.ShowNotification('Vozilo je vec potpuno popravljeno (100%).')
                                    elseif GetResourceState('jamaica-mehanicar') ~= 'started' then
                                        ESX.ShowNotification('Servis popravke trenutno nije dostupan.')
                                    else
                                        exports['jamaica-mehanicar']:startMechanicRepair(closestVehicle)
                                    end
                                end
                            end
                        end
                    end
                end

                if inHeli and cfg['helikopter'] and cfg['helikopter']['parkiraj'] then
                    local park_coords = cfg['helikopter']['parkiraj']
                    local dist = #(coords - vector3(park_coords.x, park_coords.y, park_coords.z))
                    if dist < 50.0 then nearZone = true end
                    if dist < 5.0 and JeNaDuznosti() then
                        interactZone = true
                        ESX.ShowHelpNotification('Pritisnite ~INPUT_CONTEXT~ da parkirate helikopter', true)
                        if IsControlJustReleased(0, 38) and ProveriDuznost() then
                            local vehicle = GetVehiclePedIsIn(ped, false)
                            TaskLeaveVehicle(ped, vehicle)
                            Wait(1000)
                            SetVehicleEngineOn(vehicle, false, false, true)
                            SetEntityAsMissionEntity(vehicle, true, true)
                            Wait(1000)
                            DeleteVehicle(vehicle)
                            ESX.ShowNotification('Uspesno ste parkirali helikopter u garazu.')
                        end
                    end
                end

                if drawMarkers then
                    sleep = 0
                elseif interactZone then
                    sleep = 100
                elseif nearZone then
                    sleep = 500
                else
                    sleep = 1500
                end
                end
            end

            Wait(sleep)
        end
    end
end)

RegisterNetEvent("jamaica-sluzbe:client:ListaHeli", function(data)
  if not ProveriDuznost() then return end
  local tabela = {}
  for k, v in pairs(data) do 
      tabela[#tabela + 1] = {
          title = v.label,
          description = "Klikom na strelicu izvadi vozilo.",
          icon = 'fa-solid fa-helicopter',
          event = "jamaica-sluzbe:client:SpawnujHeli",
          args = { model  = v.model, coords = v.coords, label = v.label },
          arrow = true,
      }
  end
  lib.registerContext({
      id = 'list_heli',
      title = "Helikopter Garaza",
      options = tabela
  })
  lib.showContext('list_heli')
end)

RegisterNetEvent("jamaica-sluzbe:client:SpawnujHeli", function(data)
    if not ProveriDuznost() then return end
    if not IsModelInCdimage(data.model) or not IsModelValid(data.model) then
        ESX.ShowNotification("Model nije validan!")
        return
    end

    local isSpawnPointClear = ESX.Game.IsSpawnPointClear(vector3(data.coords.x, data.coords.y, data.coords.z), 5.0)
    if not isSpawnPointClear then
        ESX.ShowNotification("Spawn mesto je zauzeto!")
        return
    end

    ESX.Game.SpawnVehicle(data.model, vector3(data.coords.x, data.coords.y, data.coords.z), data.coords.w, function(veh)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)

        SetEntityAsMissionEntity(veh, true, true)

        SetVehicleLivery(veh, 0)

        SetVehicleModKit(veh, 0)
        SetVehicleMod(veh, 48, 0, false) 

        ESX.ShowNotification("Helikopter je uspešno spawnovan!")
    end)
end)


local dobar_posao = function()
    local pData = ESX.GetPlayerData()
    return pData and pData.job and GetSluzbaConfig(pData.job.name) ~= nil
end

local function isJobMenuBlockedInSafeZone()
    return GetResourceState('jamaica-safezone') == 'started'
        and exports['jamaica-safezone']:BlockJobMenu()
end

local function sluzbeAkcija(action)
    if not dobar_posao() or not ProveriDuznost() then return end
    if isJobMenuBlockedInSafeZone() then return end
    TriggerEvent('jamaica-sluzbe:f6Action', action)
end

RegisterKeyMapping("+interakcije", "Interakcije Mnei", "keyboard", "F6")

RegisterCommand("+interakcije", function()
    if not dobar_posao() or not ProveriDuznost() then return end
    OpenSluzbeF6Menu()
end)

RegisterCommand("-interakcije", function()
    
end)

RegisterKeyMapping('pretraziPd', 'Policija Pretrazi', 'keyboard', '')
RegisterCommand('pretraziPd', function()
    sluzbeAkcija('pretrazi')
end)

RegisterKeyMapping('veziLice', 'Policija Vezi', 'keyboard', '')
RegisterCommand('veziLice', function()
    sluzbeAkcija('vezilice')
end)

RegisterKeyMapping('vuciLice', 'Policija Vuci/Prestani Vuci', 'keyboard', '')
RegisterCommand('vuciLice', function()
    sluzbeAkcija('vuci')
end)

RegisterKeyMapping('odveziLice', 'Policija Odvezi', 'keyboard', '')
RegisterCommand('odveziLice', function()
    sluzbeAkcija('odvezi')
end)

RegisterKeyMapping('staviVozilo', 'Policija Stavi u Vozilo', 'keyboard', '')
RegisterCommand('staviVozilo', function()
    sluzbeAkcija('staviUVozilo')
end)

RegisterKeyMapping('izvadiIzVozila', 'Policija Izvadi iz Vozilo', 'keyboard', '')
RegisterCommand('izvadiIzVozila', function()
    sluzbeAkcija('izvadi')
end)

RegisterCommand('dajdozvolu', function()
    if not dobar_posao() or not ProveriDuznost() then return end

    local playerData = ESX.GetPlayerData()
    if playerData.job.name ~= 'police' then
        ESX.ShowNotification('Nemas ovlasti za izdavanje dozvola.', 'error')
        return
    end
    if playerData.job.grade < 11 then
        ESX.ShowNotification('Nemas ovlasti za izdavanje dozvola.', 'error')
        return
    end

    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer == -1 or closestDistance > 3.0 then
        ESX.ShowNotification('Nema igraca u blizini.', 'error')
        return
    end

    TriggerServerEvent('jamaica-sluzbe:server:dajzvolu', GetPlayerServerId(closestPlayer))
end, false)

RegisterKeyMapping('obijDozvolu', 'Policija Obij Vozilo', 'keyboard', '')
RegisterCommand('obijDozvolu', function()
    sluzbeAkcija('obij')
end)

AddEventHandler("jamaica-sluzbe:client:PretraziINV", function(args)
    if not ProveriDuznost() then return end
    local playerPed = PlayerPedId()
    local alpha = GetEntityAlpha(playerPed)
    local invisible = not IsEntityVisible(playerPed)
    local transparent = alpha < 200

    if invisible or transparent then
        ESX.ShowNotification("Ne mozes pretrazivati dok si nevidljiv ili providan.")
        return
    end

    local plyId = args[1]
    local targetPed = args[2]
    local targetState = Player(plyId).state
    local mrtav = (targetState.Mrtav == true and targetState.Knockan ~= true)
        or IsPedFatallyInjured(targetPed)
        or IsEntityPlayingAnim(targetPed, 'dead', 'dead_a', 3)
        or IsEntityPlayingAnim(targetPed, 'dead', 'dead_b', 3)
        or IsEntityPlayingAnim(targetPed, 'dead', 'dead_h', 3)

    local function otvoriPretragu()
        TriggerServerEvent('jamaica-sluzbe:server:obavestenjePretrage', plyId)
        exports.ox_inventory:openInventory('player', plyId)
    end

    if IsEntityPlayingAnim(targetPed, 'missminuteman_1ig_2', 'handsup_base', 3) then 
        otvoriPretragu()
    elseif (GlobalState.cuffedPlayers and GlobalState.cuffedPlayers[plyId]) or (GlobalState.GangcuffedPlayers and GlobalState.GangcuffedPlayers[plyId]) then
        otvoriPretragu()
    elseif mrtav then 
        otvoriPretragu()
    else
        ESX.ShowNotification("Lice koje se pretrazuje mora imati podignute ruke")
    end
end)

function LoadAnimDict(dict)
    if loadedAnimDicts[dict] then
        return
    end
    
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(10)
    end
    loadedAnimDicts[dict] = true
end

local SectionAnimation = 'mp_arrest_paired'
local AnimationCop     = 'cop_p2_back_left'   
local AnimationCrook   = 'crook_p2_back_left' 

RegisterNetEvent('jamaica-sluzbe:client:arrested')
AddEventHandler('jamaica-sluzbe:client:arrested', function(target)

    local playerPed = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

    LoadAnimDict(SectionAnimation)

    AttachEntityToEntity(PlayerPedId(), targetPed, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20,
        false)
    TaskPlayAnim(playerPed, SectionAnimation, AnimationCrook, 8.0, -8.0, 5500, 33, 0, false, false, false)


    Wait(950)
    DetachEntity(PlayerPedId(), true, false)
end)

RegisterNetEvent('jamaica-sluzbe:client:arrest')
AddEventHandler('jamaica-sluzbe:client:arrest', function()
    local playerPed = PlayerPedId()

    LoadAnimDict(SectionAnimation)

    TaskPlayAnim(playerPed, SectionAnimation, AnimationCop, 8.0, -8.0, 5500, 33, 0, false, false, false)

    Wait(3000)

end)

RegisterNetEvent('jamaica-sluzbe:client:cuffTarget')
AddEventHandler('jamaica-sluzbe:client:cuffTarget', function()
    local lokacija = GetEntityCoords(PlayerPedId())
    local playerPed = PlayerPedId()
    LoadAnimDict('mp_arresting')
    TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
    SetEnableHandcuffs(playerPed, true)
    DisablePlayerFiring(playerPed, true)
    SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
    SetPedCanPlayGestureAnims(playerPed, false)
    DisplayRadar(false)
    propoivys = CreateObject(GetHashKey('p_cs_cuffs_02_s'), lokacija.x, lokacija.y, lokacija.z, true, true, true)
    AttachEntityToEntity(propoivys, playerPed, GetPedBoneIndex(playerPed, 60309), -0.055, 0.06, 0.04, 265.0, 155.0, 80.0,true, true, false, true, 0, true)
    lisice[#lisice + 1] = propoivys
    jelVezan = true
    FreezeEntityPosition(PlayerPedId(), true)
    local success = lib.skillCheck({'easy', 'medium', {areaSize = 60, speedMultiplier = 1}, 'hard'}, {'e', 'e', 'e', 'e'})
    if success then 
        TriggerEvent('jamaica-sluzbe:client:unCuffTargetRevive')
        ESX.ShowNotification('Uspesno si se odvezao, bezi!')
    else
        ESX.ShowNotification('Nisi uspeo da se odvezes.')
    end
end)

vezan = function()
    return jelVezan
end

exports('vezan', vezan)

RegisterNetEvent('jamaica-sluzbe:client:unCuff')
AddEventHandler('jamaica-sluzbe:client:unCuff', function()
    Wait(250)
    LoadAnimDict('mp_arresting')
    TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
    Wait(5500)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('jamaica-sluzbe:client:unCuffTarget')
AddEventHandler('jamaica-sluzbe:client:unCuffTarget', function(playerheading, playercoords, playerlocation)
    local playerPed = PlayerPedId()
    DisplayRadar(true)
    local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(PlayerPedId(), x, y, z)
	SetEntityHeading(PlayerPedId(), playerheading)
	Wait(250)
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Wait(5500)
	ClearPedTasks(PlayerPedId())
    ClearPedSecondaryTask(playerPed)
    SetEnableHandcuffs(playerPed, false)
    DisablePlayerFiring(playerPed, false)
    SetPedCanPlayGestureAnims(playerPed, true)
    FreezeEntityPosition(playerPed, false)
    DeleteObject(propoivys)
    jelVezan = false
    wasDead = false
    playerInVehicle = false
    Wait(500)  
    ExecuteCommand("propfix")
end)

RegisterNetEvent('jamaica-sluzbe:client:unCuffTargetRevive')
AddEventHandler('jamaica-sluzbe:client:unCuffTargetRevive', function()
    local playerPed = PlayerPedId()
    DisplayRadar(true)
	ClearPedTasks(PlayerPedId())
    ClearPedSecondaryTask(playerPed)
    SetEnableHandcuffs(playerPed, false)
    DisablePlayerFiring(playerPed, false)
    SetPedCanPlayGestureAnims(playerPed, true)
    FreezeEntityPosition(playerPed, false)
    DeleteObject(propoivys)
    jelVezan = false
    wasDead = false
    playerInVehicle = false
    TriggerServerEvent('jamaica-sluzbe:server:izbacisaliste')
end)

AddEventHandler("jamaica-sluzbe:client:odvezujga", function()
    if not ProveriDuznost() then return end
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        igracHeading = GetEntityHeading(PlayerPedId())
        igracLokacija = GetEntityForwardVector(PlayerPedId())
        igracKoordinate = GetEntityCoords(PlayerPedId()) 
        TriggerServerEvent("jamaica-sluzbe:server:interactions:uncuff",  GetPlayerServerId(closestPlayer), igracHeading, igracKoordinate, igracLokacija)
    end
end)

RegisterNetEvent('jamaica-sluzbe:client:staviUVozilo')
AddEventHandler('jamaica-sluzbe:client:staviUVozilo', function()
    local igrac = PlayerPedId()

    if IsEntityDead(igrac) then
        local Position = GetEntityCoords(igrac)
        local heading = GetEntityHeading(igrac)
        NetworkResurrectLocalPlayer(Position.x, Position.y, Position.z, heading, true, false)
        SetPlayerInvincible(igrac, false)
        ClearPedBloodDamage(igrac)
        wasDead = true
        FreezeEntityPosition(PlayerPedId(), true)
        playerInVehicle = false
    else
        if not jelVezan then 
            return 
        end
        wasDead = false
        FreezeEntityPosition(PlayerPedId(), false)
        playerInVehicle = false
    end
    
    local vozilo = ESX.Game.GetClosestVehicle()
    
    if vozilo and DoesEntityExist(vozilo) then
        local max = GetVehicleMaxNumberOfPassengers(vozilo)
        local slobodno = nil

        for i = max - 1, 0, -1 do
            if IsVehicleSeatFree(vozilo, i) then
                slobodno = i
                break
            end
        end

        if slobodno ~= nil then
            TaskWarpPedIntoVehicle(igrac, vozilo, slobodno)
            playerInVehicle = true
        else
            ESX.ShowNotification('Nema slobodnih mesta u vozilu!')
        end
    else
        ESX.ShowNotification('Nema vozila u blizini!')
    end
end)

RegisterNetEvent('jamaica-sluzbe:client:staviVanVozila')
AddEventHandler('jamaica-sluzbe:client:staviVanVozila', function()
    local playerPed = PlayerPedId()
    if IsPedSittingInAnyVehicle(playerPed) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        TaskLeaveVehicle(playerPed, vehicle, 16)
        
        Wait(500)
        
        if wasDead and playerInVehicle then
            SetEntityHealth(playerPed, 0)
            wasDead = false
            FreezeEntityPosition(PlayerPedId(), false)
            playerInVehicle = false
        end
        
        FreezeEntityPosition(playerPed, false)
    end
end)

RegisterNetEvent("jamaica-sluzbe:client:izvadiNewVozila", function()
    if not ProveriDuznost() then return end
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('jamaica-sluzbe:server:staviVanVozila', GetPlayerServerId(closestPlayer))
    end
end)

RegisterNetEvent('jamaica-sluzbe:client:spawnOrgVehicle', function(data)
    if not ProveriDuznost() then return end
    if not data or not data.model or not data.plate then return end

    local pData = ESX.GetPlayerData()
    if not pData or not pData.job then return end

    local vozilaCfg = getJobVozilaConfig(pData.job.name)
    if not vozilaCfg or not vozilaCfg.spawnPoint then
        ESX.ShowNotification('Nema spawn lokacija za garazu.', 'error')
        storeOrgVehicleToGarage(data.plate, data.id, nil)
        return
    end

    local spawnCoords = nil
    for i = 1, #vozilaCfg.spawnPoint do
        local coords = vozilaCfg.spawnPoint[i]
        if ESX.Game.IsSpawnPointClear(vector3(coords.x, coords.y, coords.z), 3.0) then
            spawnCoords = coords
            break
        end
    end

    if not spawnCoords then
        ESX.ShowNotification('Sva spawn mesta su zauzeta.', 'error')
        storeOrgVehicleToGarage(data.plate, data.id, nil)
        return
    end

    ESX.Game.SpawnVehicle(data.model, vector3(spawnCoords.x, spawnCoords.y, spawnCoords.z), spawnCoords.w, function(vehicle)
        applyOrgVehicleProps(vehicle, data.props, data.plate)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        trackOrgVehicle(vehicle, data)
        TriggerServerEvent('okokGarage:GiveKeys', GetVehicleNumberPlateText(vehicle))

        ESX.ShowNotification(('Vozilo %s izvuceno (%s).'):format(data.label or data.model, data.plate))
    end)
end)

