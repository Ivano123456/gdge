local Framework = exports['d3MBA-lib']:GetFrameworkObject()

PolyZoneTable = {}

function AddTargetShopPed()
    exports[Framework.Target]:AddTargetEntity(ShopPed, {
        options = {
            {
                icon = Config.TargetIcons["shop"],
                label = Config.TargetLabels["shop"],
                canInteract = function()
                    if IsPedOnFoot(PlayerPedId()) and IsInAction == false then return true end 
                end, 
                action = function()
                    TriggerEvent("d3MBA-moneyprint:client:OpenShopMenu")
                end,
            },
        },
        distance = 2.0
    })
end

function AddTargetBlueprintPed()
    exports[Framework.Target]:AddTargetEntity(BlueprintPed, {
        options = {
            {
                icon = Config.TargetIcons["shop"],
                label = Config.TargetLabels["blueprint_shop"],
                canInteract = function()
                    if IsPedOnFoot(PlayerPedId()) and IsInAction == false then return true end 
                end, 
                action = function()
                    TriggerEvent("d3MBA-moneyprint:client:OpenBlueprintShopMenu")
                end,
            },
        },
        distance = 2.0
    })
end

function AddTargetMicroscope(entity)
        exports[Framework.Target]:AddTargetEntity(entity, {
        options = {
            {
                icon = Config.TargetIcons["hand"],
                label = string.format(Config.TargetLabels["place"], string.lower(Config.Menu["printed_money_sheet"])),
                canInteract = function()
                    if IsInAction == false and microscopeSheetAdded == nil then return true end 
                end, 
                action = function()
                    TaskTurnPedToFaceEntity(PlayerPedId(), entity, 1000)
                    TriggerEvent("d3MBA-moneyprint:client:OpenMicroscopeMenu", entity)
                end,
            },
            {
                icon = Config.TargetIcons["stamp"],
                label = Config.TargetLabels["certify_money_sheet"],
                canInteract = function()
                    if IsInAction == false and microscopeSheetAdded ~= nil then return true end 
                end, 
                action = function()
                    TaskTurnPedToFaceEntity(PlayerPedId(), entity, 1000)
                    local randomNumber = math.random(Config.Microscope.Minigame.NumberOfRotations.Min, Config.Microscope.Minigame.NumberOfRotations.Max)
                    local randomSpeed = math.random(Config.Microscope.Minigame.Speed.Min, Config.Microscope.Minigame.Speed.Max)
                    microscopeMiniGame(randomNumber, randomSpeed)
                end,
            },
            {
                icon = Config.TargetIcons["hand"],
                label = string.format(Config.TargetLabels["pick_up"], string.lower(Config.Menu["printed_money_sheet"])),
                canInteract = function()
                    if IsInAction == false and microscopeSheetAdded ~= nil then return true end 
                end, 
                action = function()
                    TaskTurnPedToFaceEntity(PlayerPedId(), entity, 1000)
                    TriggerEvent("d3MBA-moneyprint:client:PickupPrintedMoneySheet", entity)
                end,
            },
            {
                icon = Config.TargetIcons["hand"],
                label = string.format(Config.TargetLabels["pick_up"], string.lower(Framework.GetItemLabel(Config.Items.Microscope))),
                canInteract = function()
                    if IsInAction == false and microscopeSheetAdded == nil then return true end 
                end, 
                action = function()
                    TaskTurnPedToFaceEntity(PlayerPedId(), entity, 1000)
                    TriggerEvent("d3MBA-moneyprint:client:PickUpObject", entity, Config.Items.Microscope)
                end,
            },
        },
        distance = 1.5
    }) 
end 

function AddTargetHackingLaptop(entity)
    exports[Framework.Target]:AddTargetEntity(entity, {
        options = {
            {
                icon = Config.TargetIcons["hacking"],
                label = Config.TargetLabels["start_hacking"],
                canInteract = function()
                    if IsInAction == false then return true end 
                end, 
                action = function()
                    TaskTurnPedToFaceEntity(PlayerPedId(), entity, 1000)
                    startHacking(entity)
                end,
            },
            {
                icon = Config.TargetIcons["hand"],
                label = string.format(Config.TargetLabels["pick_up"], string.lower(Framework.GetItemLabel(Config.Items.HackingLaptop))),
                canInteract = function()
                    if IsInAction == false then return true end 
                end, 
                action = function()
                    TaskTurnPedToFaceEntity(PlayerPedId(), entity, 1000)
                    TriggerEvent("d3MBA-moneyprint:client:PickUpObject", entity, Config.Items.HackingLaptop)
                end,
            },
        },
        distance = 1.5
    }) 
end

CreateThread(function() 
    exports[Framework.Target]:AddTargetModel(Config.Printer.Prop, {
        options = {
            {
                icon = Config.TargetIcons["search"],
                label = Config.TargetLabels["search_printer"],
                canInteract = function()
                    if IsInAction == false then return true end
                end, 
                action = function(entity)
                    TaskTurnPedToFaceEntity(PlayerPedId(), entity, 1000)
                    
                    local isSearched = IsPrinterSearched(entity)
                    if isSearched == false then  
                        TriggerEvent("d3MBA-moneyprint:client:SearchPrinter", entity)
                        IsInAction = true
                    else 
                        TriggerEvent('d3MBA-lib:sendNotification', Config.Notifications["printer_already_seached"], Framework.NotificationsSettings.Error, 5000)
                    end  
                end,
            },
        },
        distance = 1.5
    })
end)


function AddTargetPrinterMachine(coords, index, entity)
    local entityCoords = GetEntityCoords(entity)
    local entityHeading = GetEntityHeading(entity)
    local radHeading   = math.rad(entityHeading)

    local offset = vector3(1.2, 0.0, 0.7) 
    
    -- Rotate the offset around Z-axis by heading
    local rotatedOffset = vector3(
        offset.x * math.cos(radHeading) - offset.y * math.sin(radHeading),
        offset.x * math.sin(radHeading) + offset.y * math.cos(radHeading),
        offset.z
    )

    local finalCoords = entityCoords + rotatedOffset

    exports[Framework.Target]:AddCircleZone("LargePrintMachine_"..index, finalCoords, 1.5, {
            name = "LargePrintMachine_"..index,
            useZ = true,
            debugPoly = Config.DebugPolyZone
        }, 
        {
            options = {
                {
                    icon = Config.TargetIcons["large_print_machine"],
                    label = Config.TargetLabels["large_print_machine"],
                    canInteract = function()
                        return (IsPedOnFoot(PlayerPedId()) and IsInAction == false)
                    end,
                    action = function()
                        if MoneyPrinterMachines[index].printing.state == true then 
                            TriggerEvent('d3MBA-lib:sendNotification', string.format(Config.Notifications["printing"], MoneyPrinterMachines[index].printing.time), Framework.NotificationsSettings.Info, 5000)
                            return
                        end

                        if Framework.IsAnyPlayerNearby(entityCoords, 3.0) == false then
                            TriggerEvent("d3MBA-moneyprint:client:OpenMoneyPrinterMachineMenu", index)
                        else
                            TriggerEvent('d3MBA-lib:sendNotification', Config.Notifications["player_nearby"], Framework.NotificationsSettings.Error, 5000)
                        end
                    end,
                    job = Config.JobRequired,
                }
            },
            distance = 1.0
        }
    )

    table.insert(PolyZoneTable, "LargePrintMachine_"..index)
end



function AddTargetCuttingTable(coords, index, entity)
    local entityCoords = GetEntityCoords(entity)

    exports[Framework.Target]:AddCircleZone("CuttingTable_"..index, vector3(entityCoords.x, entityCoords.y, entityCoords.z + 0.5), 1.0, {
        name = "CuttingTable_"..index,
        useZ = true,
        debugPoly = Config.DebugPolyZone
    }, 
    {
        options = {
            {
                icon = Config.TargetIcons["cutting_table"],
                label = Config.TargetLabels["cutting_table"],
                canInteract = function()
                    return (IsPedOnFoot(PlayerPedId()) and IsInAction == false)
                end,
                action = function()
                    if Framework.IsAnyPlayerNearby(entityCoords, 2.0) == false then
                        TriggerEvent("d3MBA-moneyprint:client:OpenCuttingTableMenu", coords)
                    else
                        TriggerEvent('d3MBA-lib:sendNotification', Config.Notifications["player_nearby"], Framework.NotificationsSettings.Error, 5000)
                    end
                end,
                job = Config.JobRequired,
            },
        },
        distance = 1.0
    })

    table.insert(PolyZoneTable, "CuttingTable_"..index)
end
