func = {}

func.addItem = function(src, name, amount, metadata)
    local PlayerData = bridge.framework.getPlayerData(src)
    exports["core_inventory"]:addItem(src, name, amount, metadata)
end

func.removeItem = function(src, name, amount)
    local PlayerData = bridge.framework.getPlayerData(src)
    exports["core_inventory"]:removeItem(src, name, amount)
end

func.hasItem = function(src, name)
    local PlayerData = bridge.framework.getPlayerData(src)
    local item = exports["core_inventory"]:getItem("content-"..PlayerData.identifier, type(name) == "string" and name or name.name)

    if not item or item.count == 0 then return nil end

    return {
        label = item.label,
        count = item.count,
        metadata = item.metadata
    }
end

func.getInventory = function(src)
    local inventory = exports['core_inventory']:getInventory(src)
    return inventory
end

return func