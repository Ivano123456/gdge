local Framework = exports['d3MBA-lib']:GetFrameworkObject()

-- Shop input menu
RegisterNetEvent("d3MBA-moneyprint:client:OpenShopInputMenu", function(data)
    local ItemLabel = Framework.GetItemLabel(data.ItemName)
    local InputAmount = nil   
    
    -- ox_lib
    if Framework.InputMenu == "ox_lib" then
        local dialog = Framework.OpenInputMenu("ox_lib", string.format(Config.InputMenu["buy_enter_amount"], string.lower(ItemLabel)), {
            { type = "slider", label = Config.InputMenu["amount"], default = 1, min = 1},
        })

        if dialog == nil then return end

        InputAmount = dialog[1] 
    end

    -- qb-input
    if Framework.InputMenu == "qb-input" then
        local dialog = Framework.OpenInputMenu("qb-input", string.format(Config.InputMenu["buy_enter_amount"], string.lower(ItemLabel)), {
        {
            text = Config.InputMenu["amount"],
            name = "amount",
            type = "number",
        },
    })

    if dialog == nil then return end

    InputAmount = dialog.amount 
    end 

    -- nh-input
    if Framework.InputMenu == "nh-input" then
        local dialog, amount = Framework.OpenInputMenu("nh-input", string.format(Config.InputMenu["buy_enter_amount"], string.lower(ItemLabel)), {Config.InputMenu["amount"]})

        if amount == nil then return end

        InputAmount = amount 
    end 

    InputAmount = tonumber(InputAmount) 
    InputAmount = math.floor(InputAmount)
    -- Input menu end
    if InputAmount ~= nil then 
        if InputAmount >= 1 then 
            local data = {
                ItemName = data.ItemName,
                Amount = InputAmount,
                Price = data.Price,
            }
            TriggerServerEvent("d3MBA-moneyprint:server:ShopBuyItem", data)
        else
            TriggerEvent("d3MBA-lib:sendNotification", Config.Notifications["invalid_amount"], Framework.NotificationsSettings.Error, 5000)
        end 
    end 
end)

RegisterNetEvent("d3MBA-moneyprint:client:OpenBlueprintShopInputMenu", function(data)
    local ItemLabel = Framework.GetItemLabel(data.ItemName)
    local InputAmount = nil   
    
    -- ox_lib
    if Framework.InputMenu == "ox_lib" then
        local dialog = Framework.OpenInputMenu("ox_lib", string.format(Config.InputMenu["buy_enter_amount"], string.lower(ItemLabel)), {
            { type = "slider", label = Config.InputMenu["amount"], default = 1, min = 1},
        })

        if dialog == nil then return end

        InputAmount = dialog[1] 
    end

    -- qb-input
    if Framework.InputMenu == "qb-input" then
        local dialog = Framework.OpenInputMenu("qb-input", string.format(Config.InputMenu["buy_enter_amount"], string.lower(ItemLabel)), {
        {
            text = Config.InputMenu["amount"],
            name = "amount",
            type = "number",
        },
    })

    if dialog == nil then return end

    InputAmount = dialog.amount 
    end 

    -- nh-input
    if Framework.InputMenu == "nh-input" then
        local dialog, amount = Framework.OpenInputMenu("nh-input", string.format(Config.InputMenu["buy_enter_amount"], string.lower(ItemLabel)), {Config.InputMenu["amount"]})

        if amount == nil then return end

        InputAmount = amount 
    end 

    InputAmount = tonumber(InputAmount) 
    InputAmount = math.floor(InputAmount)
    -- Input menu end
    if InputAmount ~= nil then 
        if InputAmount >= 1 then 
            local data = {
                ItemName = data.ItemName,
                Amount = InputAmount,
                Price = data.Price,
            }
            TriggerServerEvent("d3MBA-moneyprint:server:ShopBuyBlueprintItem", data)
        else
            TriggerEvent("d3MBA-lib:sendNotification", Config.Notifications["invalid_amount"], Framework.NotificationsSettings.Error, 5000)
        end 
    end 
end)


RegisterNetEvent("d3MBA-moneyprint:client:MoneyPrinterMachineAddInkInputMenu", function(data)
    local ItemLabel = Framework.GetItemLabel(data.itemName)
    local InputAmount = nil   
    local maxValue = nil

    local currentInkAmount = 0 

    if data.itemName == Config.Items.BlackInk then 
        maxValue = blackInkMaxValue
        currentInkAmount = MoneyPrinterMachines[data.index].ink.black

    elseif data.itemName == Config.Items.ColorInk then 
        maxValue = colorInkMaxValue
        currentInkAmount = MoneyPrinterMachines[data.index].ink.color
    else
        print("Error: Unknown ink type | MoneyPrinterMachineAddInkInputMenu")
        return 
    end
    
    -- ox_lib
    if Framework.InputMenu == "ox_lib" then
        local dialog = Framework.OpenInputMenu("ox_lib", string.format(Config.InputMenu["enter_amount"], string.lower(ItemLabel)), {
            { type = "slider", label = Config.InputMenu["amount"], default = 1, min = 1, max = maxValue},
        })

        if dialog == nil then return end

        InputAmount = dialog[1] 
    end

    -- qb-input
    if Framework.InputMenu == "qb-input" then
        local dialog = Framework.OpenInputMenu("qb-input", string.format(Config.InputMenu["enter_amount"], string.lower(ItemLabel)), {
        {
            text = Config.InputMenu["amount"],
            name = "amount",
            type = "number",
        },
    })

    if dialog == nil then return end

    InputAmount = dialog.amount 
    end 

    -- nh-input
    if Framework.InputMenu == "nh-input" then
        local dialog, amount = Framework.OpenInputMenu("nh-input", string.format(Config.InputMenu["enter_amount"], string.lower(ItemLabel)), {Config.InputMenu["amount"]})

        if amount == nil then return end

        InputAmount = amount 
    end 

    InputAmount = tonumber(InputAmount) 
    InputAmount = math.floor(InputAmount)
    -- Input menu end
    if InputAmount ~= nil then 
        if InputAmount >= 1 then 
            if (InputAmount + currentInkAmount) > maxValue then 
                TriggerEvent("d3MBA-lib:sendNotification", string.format(Config.Notifications["max_amount"], maxValue), Framework.NotificationsSettings.Error, 5000)
                return 
            end
            local data = {
                index = data.index,
                itemName = data.itemName,
                amount = InputAmount
            }
            TriggerEvent("d3MBA-moneyprint:client:MoneyPrinterMachineAddInk", data)
        else
            TriggerEvent("d3MBA-lib:sendNotification", Config.Notifications["invalid_amount"], Framework.NotificationsSettings.Error, 5000)
        end 
    end 
end)


RegisterNetEvent("d3MBA-moneyprint:client:MoneyPrinterMachineRemoveInkInputMenu", function(data)
    local ItemLabel = Framework.GetItemLabel(data.itemName)
    local InputAmount = nil   

    local currentInkAmount = 0 

    if data.itemName == Config.Items.BlackInk then 
        currentInkAmount = MoneyPrinterMachines[data.index].ink.black
        if currentInkAmount == 0 then return end 
    elseif data.itemName == Config.Items.ColorInk then 
        currentInkAmount = MoneyPrinterMachines[data.index].ink.color
        if currentInkAmount == 0 then return end 
    else
        print("Error: Unknown ink type | MoneyPrinterMachineRemoveInkInputMenu")
        return 
    end
    
    -- ox_lib
    if Framework.InputMenu == "ox_lib" then
        local dialog = Framework.OpenInputMenu("ox_lib", string.format(Config.InputMenu["enter_amount"], string.lower(ItemLabel)), {
            { type = "slider", label = Config.InputMenu["amount"], default = 1, min = 1, max = currentInkAmount},
        })

        if dialog == nil then return end

        InputAmount = dialog[1] 
    end

    -- qb-input
    if Framework.InputMenu == "qb-input" then
        local dialog = Framework.OpenInputMenu("qb-input", string.format(Config.InputMenu["enter_amount"], string.lower(ItemLabel)), {
        {
            text = Config.InputMenu["amount"],
            name = "amount",
            type = "number",
        },
    })

    if dialog == nil then return end

    InputAmount = dialog.amount 
    end 

    -- nh-input
    if Framework.InputMenu == "nh-input" then
        local dialog, amount = Framework.OpenInputMenu("nh-input", string.format(Config.InputMenu["enter_amount"], string.lower(ItemLabel)), {Config.InputMenu["amount"]})

        if amount == nil then return end

        InputAmount = amount 
    end 

    InputAmount = tonumber(InputAmount) 
    InputAmount = math.floor(InputAmount)
    -- Input menu end
    if InputAmount ~= nil then 
        if InputAmount >= 1 then 
            local data = {
                index = data.index,
                itemName = data.itemName,
                amount = InputAmount
            }
            TriggerEvent("d3MBA-moneyprint:client:MoneyPrinterMachineRemoveInk", data)
        else
            TriggerEvent("d3MBA-lib:sendNotification", Config.Notifications["invalid_amount"], Framework.NotificationsSettings.Error, 5000)
        end 
    end 
end)

