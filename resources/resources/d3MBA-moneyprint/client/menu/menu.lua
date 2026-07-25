local Framework = exports['d3MBA-lib']:GetFrameworkObject()

RegisterNetEvent("d3MBA-moneyprint:client:OpenShopMenu", function()
    TaskTurnPedToFaceEntity(PlayerPedId(), ShopPed, 1000)
    local ShopItems = nil 
    local menuHeaderOptions = {
        title = Config.Menu["shop_title"], 
        ox_title = Config.Menu["shop_title"] .. " " .. Config.Menu["menu"],  
    }

    local menuFooterOptions = {
        title = Config.Menu["exit"],
        icon = "fas fa-circle-xmark", 
    }

    local menuOptions = {}

    if Config.ShopPed.DynamicPrices.Use == true then 
        ShopItems = Framework.TriggerServerCallback("d3MBA-moneyprint:server:ReturnDynamicPrices")
    else
        ShopItems = Config.ShopPed.Items
    end 

    for i = 1, #ShopItems do  
        local itemImg = Framework.ConvertImageFormat(Framework.GetItemImg(ShopItems[i].ItemName), 40)
        table.insert(menuOptions,  {
            title = string.format(Config.Menu["buy_title"], Framework.GetItemLabel(ShopItems[i].ItemName)),
            context = string.format(Config.Menu["price_context"], ShopItems[i].Price),
            icon = itemImg,
            image = itemImg,
            event = "d3MBA-moneyprint:client:OpenShopInputMenu",
            args = {
                ItemName = ShopItems[i].ItemName,
                Price = ShopItems[i].Price,
            } 
        })
    end        

    TriggerEvent("d3MBA-lib:client:OpenMenu", Framework.Menu, menuHeaderOptions, menuOptions, menuFooterOptions)
end)


RegisterNetEvent("d3MBA-moneyprint:client:OpenBlueprintShopMenu", function()
    TaskTurnPedToFaceEntity(PlayerPedId(), BlueprintPed, 1000)
    local ShopItems = nil 
    local menuHeaderOptions = {
        title = Config.Menu["shop_title"], 
        ox_title = Config.Menu["shop_title"] .. " " .. Config.Menu["menu"],  
    }

    local menuFooterOptions = {
        title = Config.Menu["exit"],
        icon = "fas fa-circle-xmark", 
    }

    local menuOptions = {}

    if Config.BlueprintPed.DynamicPrices.Use == true then 
        ShopItems = Framework.TriggerServerCallback("d3MBA-moneyprint:server:ReturnDynamicPricesBlueprintPed")
    else
        ShopItems = Config.BlueprintPed.Items
    end 

    for i = 1, #ShopItems do  
        local itemImg = Framework.ConvertImageFormat(Framework.GetItemImg(ShopItems[i].ItemName), 40)
        table.insert(menuOptions,  {
            title = string.format(Config.Menu["buy_title"], Framework.GetItemLabel(ShopItems[i].ItemName)),
            context = string.format(Config.Menu["price_context"], ShopItems[i].Price),
            icon = itemImg,
            image = itemImg,
            event = "d3MBA-moneyprint:client:OpenBlueprintShopInputMenu",
            args = {
                ItemName = ShopItems[i].ItemName,
                Price = ShopItems[i].Price,
            } 
        })
    end        

    TriggerEvent("d3MBA-lib:client:OpenMenu", Framework.Menu, menuHeaderOptions, menuOptions, menuFooterOptions)
end)

RegisterNetEvent("d3MBA-moneyprint:client:OpenMoneyPrinterMachineMenu", function(index)
    local menuHeaderOptions = {
		title = Config.Menu["money_printer_title"],
		ox_title = Config.Menu["money_printer_title"] .. " " .. Config.Menu["menu"],
        context = string.format(Config.Menu["money_printer_context"], MoneyPrinterMachines[index].sheet, MoneyPrinterMachines[index].ink.black, MoneyPrinterMachines[index].ink.color),
		icon = "fas fa-print",
	}

	local menuFooterOptions = {
		title = Config.Menu["exit"],
		icon = "fas fa-circle-xmark",
	}

	local menuOptions = {}

    
    if MoneyPrinterMachines[index].printedMoneySheetItemName == nil then 
        table.insert(menuOptions, {
            title = Config.Menu["money_printer_machine_start_printing"],
            icon = "fas fa-print",
            event = "d3MBA-moneyprint:client:MoneyPrinterMachinePrint",
            args = index,
            disabled = not (MoneyPrinterMachines[index].sheet > 0 and MoneyPrinterMachines[index].ink.black > 0 and MoneyPrinterMachines[index].ink.color > 0),
        })
    else
        table.insert(menuOptions, {
            title = string.format(Config.Menu["money_printer_machine_takeout_printed_money_sheet"], string.lower(Framework.GetItemLabel(MoneyPrinterMachines[index].printedMoneySheetItemName))),
            icon = "fas fa-print",
            event = "d3MBA-moneyprint:client:TakeOutPrintedMoneySheet",
            args = index,
        })
    end 


    table.insert(menuOptions, {
		title = Config.Menu["money_printer_machine_add_ink"],
        icon = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.ColorInk), 45),
        image = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.ColorInk), 45),
		event = "d3MBA-moneyprint:client:MoneyPrinterMachineAddInkMenu",
        args = {
            index = index,
        }
	})


    table.insert(menuOptions, {
        title = Config.Menu["money_printer_machine_remove_ink"],
        icon = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.BlackInk), 45),
        image = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.BlackInk), 45),
        disabled = MoneyPrinterMachines[index].ink.black == 0 and MoneyPrinterMachines[index].ink.color == 0,
        event = "d3MBA-moneyprint:client:MoneyPrinterMachineRemoveInkMenu",
        args = { index = index }
    })


    table.insert(menuOptions, {
        title = Config.Menu["money_printer_machine_add_sheet"],
        icon = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.Sheet), 45),
        image = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.Sheet), 45),
        disabled = not (MoneyPrinterMachines[index].sheet == 0),
        event = "d3MBA-moneyprint:client:MoneyPrinterMachineAddSheet",
        args = index,
    })

    table.insert(menuOptions, {
        title = Config.Menu["money_printer_machine_remove_sheet"],
        icon = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.Sheet), 45),
        image = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.Sheet), 45),
        disabled = MoneyPrinterMachines[index].sheet == 0,
        event = "d3MBA-moneyprint:client:MoneyPrinterMachineRemoveSheet",
        args = index,
    })

	TriggerEvent("d3MBA-lib:client:OpenMenu", Framework.Menu, menuHeaderOptions, menuOptions, menuFooterOptions)
end)

RegisterNetEvent("d3MBA-moneyprint:client:MoneyPrinterMachineAddInkMenu", function(data)
    local menuHeaderOptions = {
		title = Config.Menu["money_printer_chose_ink_title"],
		ox_title = Config.Menu["money_printer_chose_ink_title"] .. " " .. Config.Menu["menu"],
		icon = "fas fa-tint",
        disabled = true,
	}

	local menuFooterOptions = {
		title = Config.Menu["back"],
        event = "d3MBA-moneyprint:client:OpenMoneyPrinterMachineMenu",
        args = data.index,
		icon = "fas fa-circle-arrow-left",
	}

	local menuOptions = {}

    table.insert(menuOptions, {
		title = Config.Menu["add_black_ink"],
        icon = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.BlackInk), 45),
        image = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.BlackInk), 45),
		event = "d3MBA-moneyprint:client:MoneyPrinterMachineAddInkInputMenu",
        args = {
            index = data.index,
            itemName = Config.Items.BlackInk,
        }
	})

    table.insert(menuOptions, {
        title = Config.Menu["add_color_ink"],
        icon = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.ColorInk), 45),
        image = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.ColorInk), 45),
        event = "d3MBA-moneyprint:client:MoneyPrinterMachineAddInkInputMenu",
        args = {
            index = data.index,
            itemName = Config.Items.ColorInk,
        }
    })
    

	TriggerEvent("d3MBA-lib:client:OpenMenu", Framework.Menu, menuHeaderOptions, menuOptions, menuFooterOptions)
end)


RegisterNetEvent("d3MBA-moneyprint:client:MoneyPrinterMachineRemoveInkMenu", function(data)
    local menuHeaderOptions = {
		title = Config.Menu["money_printer_chose_ink_title"],
		ox_title = Config.Menu["money_printer_chose_ink_title"] .. " " .. Config.Menu["menu"],
		icon = "fas fa-tint",
        disabled = true,
	}

	local menuFooterOptions = {
		title = Config.Menu["back"],
        event = "d3MBA-moneyprint:client:OpenMoneyPrinterMachineMenu",
        args = data.index,
		icon = "fas fa-circle-arrow-left",
	}

	local menuOptions = {}

    table.insert(menuOptions, {
		title = Config.Menu["remove_black_ink"],
        icon = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.BlackInk), 45),
        image = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.BlackInk), 45),
        disabled = MoneyPrinterMachines[data.index].ink.black == 0,
		event = "d3MBA-moneyprint:client:MoneyPrinterMachineRemoveInkInputMenu",
        args = {
            index = data.index,
            itemName = Config.Items.BlackInk,
        }
	})

    table.insert(menuOptions, {
        title = Config.Menu["remove_color_ink"],
        icon = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.ColorInk), 45),
        image = Framework.ConvertImageFormat(Framework.GetItemImg(Config.Items.ColorInk), 45),
        disabled = MoneyPrinterMachines[data.index].ink.color == 0,
        event = "d3MBA-moneyprint:client:MoneyPrinterMachineRemoveInkInputMenu",
        args = {
            index = data.index,
            itemName = Config.Items.ColorInk,
        }
    })
    
	TriggerEvent("d3MBA-lib:client:OpenMenu", Framework.Menu, menuHeaderOptions, menuOptions, menuFooterOptions)
end)

RegisterNetEvent("d3MBA-moneyprint:client:AddPrintedMoneySheet", function(index, itemName, action)
    local hasItem = Framework.TriggerServerCallback("d3MBA-lib:server:CheckIfPlayerHasItem", itemName, 1)
    Wait(50)
    if hasItem == false then
        TriggerEvent('d3MBA-lib:sendNotification', string.format(Config.Notifications['you_dont_have_item'], 1, string.lower(Framework.GetItemLabel(printedMoneySheet))), Framework.NotificationsSettings.Error, 5000)
        return
    end

    
    TriggerEvent("d3MBA-moneyprint:client:UpdateMoneyPrinterMachine", index, moneyPrinterMachine)
    TriggerEvent("d3MBA-moneyprint:client:OpenMoneyPrinterMachineMenu", index)
end)


RegisterNetEvent("d3MBA-moneyprint:client:OpenCuttingTableMenu", function(tableCoords)
	local menuHeaderOptions = {
		title = Config.Menu["cutting_table_title"],
		ox_title = Config.Menu["cutting_table_title"] .. " " .. Config.Menu["menu"],
		icon = "fas fa-cut",
	}

	local menuFooterOptions = {
		title = Config.Menu["exit"],
		icon = "fas fa-circle-xmark", 
	}

	local menuOptions = {}

	-- Gather all sheet items dynamically
	local printedSheets = {}
	local certifiedSheets = {}

	for key, itemName in pairs(Config.Items) do
		if string.find(itemName, "printed_money_sheet") then
			table.insert(printedSheets, itemName)
		elseif string.find(itemName, "certified_money_sheet") then
			table.insert(certifiedSheets, itemName)
		end
	end

	-- Combine all items for server callback
	local itemsToCheck = {}
	for _, item in ipairs(printedSheets) do itemsToCheck[item] = 1 end
	for _, item in ipairs(certifiedSheets) do itemsToCheck[item] = 1 end

	local hasItems = Framework.TriggerServerCallback("d3MBA-lib:server:CheckPlayerItemsTable", itemsToCheck)
	Wait(50)

	local hasAny = false

	-- Add certified sheets (clean money)
	for _, itemName in ipairs(certifiedSheets) do
		for _, result in ipairs(hasItems) do
			if result.ItemName == itemName and result.HasItem then
				hasAny = true
				local label = Framework.GetItemLabel(itemName)
				local image = Framework.ConvertImageFormat(Framework.GetItemImg(itemName), 45)

				table.insert(menuOptions, {
					title = label,
					icon = image,
					image = image,
					event = "d3MBA-moneyprint:client:CutMoneySheet",
					args = {
                        itemName = itemName,
                        coords = tableCoords,
                    }
				})
			end
		end
	end

	-- Add printed sheets (black money)
	for _, itemName in ipairs(printedSheets) do
		for _, result in ipairs(hasItems) do
			if result.ItemName == itemName and result.HasItem then
				hasAny = true
				local label = Framework.GetItemLabel(itemName)
				local image = Framework.ConvertImageFormat(Framework.GetItemImg(itemName), 45)

				table.insert(menuOptions, {
					title = label,
					icon = image,
					image = image,
					event = "d3MBA-moneyprint:client:CutMoneySheet",
					args = {
                        itemName = itemName,
                        coords = tableCoords,
                    }
				})
			end
		end
	end

	if not hasAny then
		TriggerEvent('d3MBA-lib:sendNotification', Config.Notifications["no_sheets"], Framework.NotificationsSettings.Error, 5000)
		return
	end

	TriggerEvent("d3MBA-lib:client:OpenMenu", Framework.Menu, menuHeaderOptions, menuOptions, menuFooterOptions)
end)


RegisterNetEvent("d3MBA-moneyprint:client:OpenMicroscopeMenu", function(microscopeCoords)
    local menuHeaderOptions = {
        title = Config.Menu["microscope_title"],
        ox_title = Config.Menu["microscope_title"] .. " " .. Config.Menu["menu"],
        icon = "fas fa-microscope",
    }

    local menuFooterOptions = {
        title = Config.Menu["exit"],
        icon = "fas fa-circle-xmark", 
    }

    local menuOptions = {}
    local printedSheets = {}

    for key, itemName in pairs(Config.Items) do
        if string.find(itemName, "printed_money_sheet") then
            table.insert(printedSheets, itemName)
        end
    end

    local itemsToCheck = {}
    for _, item in ipairs(printedSheets) do
        itemsToCheck[item] = 1
    end

    local hasItems = Framework.TriggerServerCallback("d3MBA-lib:server:CheckPlayerItemsTable", itemsToCheck)
    Wait(50)

    local hasAny = false

    for _, itemName in ipairs(printedSheets) do
        for _, result in ipairs(hasItems) do
            if result.ItemName == itemName and result.HasItem then
                hasAny = true
                local label = Framework.GetItemLabel(itemName)
                local image = Framework.ConvertImageFormat(Framework.GetItemImg(itemName), 45)

                table.insert(menuOptions, {
                    title = label,
                    icon = image,
                    image = image,
                    event = "d3MBA-moneyprint:client:PlacePrintedMoneySheetUnderMicroscope",
                    args = itemName,
                })
            end
        end
    end

    if not hasAny then
        TriggerEvent('d3MBA-lib:sendNotification', Config.Notifications["no_sheets_to_certify"], Framework.NotificationsSettings.Error, 5000)
        return
    end

    TriggerEvent("d3MBA-lib:client:OpenMenu", Framework.Menu, menuHeaderOptions, menuOptions, menuFooterOptions)
end)
