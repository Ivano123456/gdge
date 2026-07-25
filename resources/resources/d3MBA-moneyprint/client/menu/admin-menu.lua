local Framework = exports['d3MBA-lib']:GetFrameworkObject()

local function isVlasnik()
    return Framework.TriggerServerCallback('d3MBA-moneyprint:server:IsVlasnik') == true
end

local function denyAdminAccess()
    TriggerEvent('d3MBA-lib:sendNotification', Config.Notifications['no_admin_permission'], Framework.NotificationsSettings.Error, 5000)
end

RegisterNetEvent('d3MBA-moneyprint:client:OpenAdminMenu', function(printersData, tablesData)
    if not isVlasnik() then
        return
    end

    local menuHeaderOptions = {
        title = Config.Menu["admin_menu_title"],
        ox_title = Config.Menu["admin_menu_title"],
        icon = "fas fa-user-shield",
    }

    local menuFooterOptions = {
        title = Config.Menu["exit"],
        icon = "fas fa-circle-xmark",
    }

    local menuOptions = {}

    table.insert(menuOptions, {
        title = Config.Menu["printer_machine"]:gsub("^%l", string.upper) .. Config.Menu["s"],
        icon = "fas fa-print",
        event = "d3MBA-moneyprint:client:OpenObjectListAdminMenu",
        context = Config.Menu["list_context"],
        args = {
            objectType = "printer_machine",
            printersData = printersData
        }
	})
    
    table.insert(menuOptions, {
        title = Config.Menu["cutting_table"]:gsub("^%l", string.upper) ..Config.Menu["s"],
        icon = "fas fa-cut",
        context = Config.Menu["list_context"],
        event = "d3MBA-moneyprint:client:OpenObjectListAdminMenu",
        args = {
            objectType = "cutting_table",
            tablesData = tablesData
        }
	})

    table.insert(menuOptions, {
        title = Config.Menu["create_new"] .. " " .. Config.Menu["printer_machine"],
        icon = "fas fa-print",
        event = "d3MBA-moneyprint:client:CreateNewObjectAdminMenu",
        context = string.format(Config.Menu["create_context"], Config.Menu["printer_machine"]),
        args = Config.PrintMachine.Prop
	})

    table.insert(menuOptions, {
        title = Config.Menu["create_new"] .. " " .. Config.Menu["cutting_table"],
        icon = "fas fa-cut",
        context = string.format(Config.Menu["create_context"], Config.Menu["cutting_table"]),
        event = "d3MBA-moneyprint:client:CreateNewObjectAdminMenu",
        args = Config.CuttingTable.Prop
	})

    TriggerEvent("d3MBA-lib:client:OpenMenu", Framework.Menu, menuHeaderOptions, menuOptions, menuFooterOptions)
end)


RegisterNetEvent('d3MBA-moneyprint:client:OpenObjectListAdminMenu', function(data)

    local menuOptions = {}

    local menuHeaderOptions = {
        title = Config.Menu[data.objectType]:gsub("^%l", string.upper) .. Config.Menu["s"],
        ox_title = Config.Menu[data.objectType]:gsub("^%l", string.upper) .. Config.Menu["s"],
    }

    local menuFooterOptions = {
        title = Config.Menu["back"],
        icon = "fas fa-circle-chevron-left",
        event = "d3MBA-moneyprint:client:GetAllObjects",
    }

    if data.objectType == "printer_machine" then
        for _, v in pairs(data.printersData) do  
            print(json.encode(v))
            print(v.id)
            table.insert(menuOptions, {
                title = string.format(Config.Menu["printer_machine"]:gsub("^%l", string.upper) .. " " .. Config.Menu["index"] .. ": %d", v.index),
                icon = "fas fa-print",
                context = string.format(Config.Menu["coords"] .. ": " .. "%.2f, %.2f, %.2f", v.x, v.y, v.z),
                event = "d3MBA-moneyprint:client:OpenObjectOptionsAdminMenu",
                args = {
                    coords = vector4(v.x, v.y, v.z, v.w),
                    index = v.index,
                    objectType = "printer_machine"
                }
            })
        end   
    elseif data.objectType == "cutting_table" then
        for _, v in pairs(data.tablesData) do  
            table.insert(menuOptions, {
                title = string.format(Config.Menu["cutting_table"]:gsub("^%l", string.upper) .. " " .. Config.Menu["index"] .. ": %d", v.index),
                icon = "fas fa-cut",
                context = string.format(Config.Menu["coords"] .. ": " .. "%.2f, %.2f, %.2f", v.x, v.y, v.z),
                event = "d3MBA-moneyprint:client:OpenObjectOptionsAdminMenu",
                args = {
                    coords = vector4(v.x, v.y, v.z, v.w),
                    index = v.index,
                    objectType = "cutting_table"
                }
            })
        end
    end

    
    TriggerEvent("d3MBA-lib:client:OpenMenu", Framework.Menu, menuHeaderOptions, menuOptions, menuFooterOptions)

end)


RegisterNetEvent('d3MBA-moneyprint:client:OpenObjectOptionsAdminMenu', function(data)
    local objectType = data.objectType
    if objectType ~= "printer_machine" and objectType ~= "cutting_table" then return end

    local eventName = nil
    if objectType == "printer_machine" then 
        eventName = "d3MBA-moneyprint:server:DeletePrinterByCoords"
    elseif objectType == "cutting_table" then
        eventName = "d3MBA-moneyprint:server:DeleteTableByCoords"
    end

    local menuHeaderOptions = {
        title = Config.Menu[data.objectType]:gsub("^%l", string.upper) .. " " ..Config.Menu["options"],
        ox_title = Config.Menu[data.objectType]:gsub("^%l", string.upper) .. " " ..Config.Menu["options"],
    }

    local menuOptions = {
        {
            title = Config.Menu["teleport"] .. " " .. Config.Menu[data.objectType],
            icon = "fas fa-map-marker-alt",
            event = "d3MBA-moneyprint:client:TeleportToObjectAdminMenu",
            args = data.coords
        },
        {
            title = Config.Menu["delete"] .. " " .. Config.Menu[data.objectType],
            icon = "fas fa-trash",
            event = eventName, 
            isServer = true,
            args = {
                coords = data.coords,
                index = data.index
            },
        },
    }

    table.insert(menuOptions, { title = string.format(Config.Menu["coords"] .. ": " .. "%.2f, %.2f, %.2f", data.coords.x, data.coords.y, data.coords.z), icon = "fas fa-map-marker-alt" })

    table.insert(menuOptions, 
        {
            title = Config.Menu["back"],
            icon = "fas fa-circle-chevron-left",
            event = "d3MBA-moneyprint:client:GetAllObjects",
        }
    )

    TriggerEvent("d3MBA-lib:client:OpenMenu", Framework.Menu, menuHeaderOptions, menuOptions, menuFooterOptions)
end)

RegisterNetEvent('d3MBA-moneyprint:client:TeleportToObjectAdminMenu', function(coords)
    local ped = PlayerPedId()
    SetEntityCoords(ped, coords.x, coords.y, coords.z + 1.5)
end)


AddEventHandler("d3MBA-moneyprint:client:CreateNewObjectAdminMenu", function(propModel)
    if isVlasnik() then
        PlaceObject(propModel)
    else
        denyAdminAccess()
    end
end)

AddEventHandler("d3MBA-moneyprint:client:GetAllObjects", function()
    if isVlasnik() then
        TriggerServerEvent("d3MBA-moneyprint:server:GetAllObjects", GetPlayerServerId(PlayerId()))
    else
        denyAdminAccess()
    end
end)