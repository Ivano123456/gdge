Bridge = exports.community_bridge:Bridge()
BlackListedZones = {}
IdsTable = {}

function locale(message, ...)
    return Bridge.Language.Locale(message, ...)
end

function TrimCoords(coords)
    return {
        x = tonumber(string.format("%.4f", coords.x)),
        y = tonumber(string.format("%.4f", coords.y)),
        z = tonumber(string.format("%.4f", coords.z)),
        w = tonumber(string.format("%.4f", coords.w or 0))
    }
end

function GenerateRandomString(prefix, table)
    local randString = Bridge.Ids.RandomLower(table, 13)
    local upper = string.upper(randString)
    local joined = prefix..upper
    IdsTable[joined] = true
    return joined
end

function RegisterBlackListZone()
    local blackListZonesData = Config.BlackListZones
    for k, v in pairs(blackListZonesData) do
        local zone = lib.zones.poly({
            name = k,
            points = v,
            thickness = 150
        })
        BlackListedZones[k] = zone
    end
end

if not IsDuplicityVersion() then
    ZonesLoadedClient = false
    ActiveHives = {}
    HiveShops = {}

    function PercentageToColor(percentage)
        if percentage >= 75 then
            return "green"
        elseif percentage >= 50 then
            return "yellow"
        elseif percentage >= 25 then
            return "orange"
        else
            return "red"
        end
    end

    RegisterNetEvent('community_bridge:Client:OnPlayerUnload', function()
        CleanupHivesAndPoints()
    end)

    AddEventHandler('onResourceStop', function(resourceName)
        if resourceName ~= GetCurrentResourceName() then return end
        CleanupHivesAndPoints()
    end)

    AddEventHandler('onResourceStart', function(resourceName)
        if resourceName ~= GetCurrentResourceName() then return end
        if ZonesLoadedClient then return end
        RegisterBlackListZone()
        ZonesLoadedClient = true
    end)

    function CleanupHivesAndPoints()
        for k, _ in pairs(ActiveHives) do
            Prop.destroyById(k)
        end
        for k, _ in pairs(HiveShops) do
            Shop.destroyById(k)
        end
    end
end

function DebugInfo(message)
    if not Config.Utility.Debug then return end
    Bridge.Prints.Debug(message)
end

if not IsDuplicityVersion() then return end

function VerifyNotBlackListed(coords)
    for _, v in pairs(BlackListedZones) do
        if v:contains(coords) then return false end
    end
    return true
end

function RegisterUsableItems()
    Bridge.Framework.RegisterUsableItem("beehive", function(src, itemData)
        local _src = src
        local propCoords, propHeading = Bridge.Callback.Trigger('MrNewbBeeKeeping:GetHivePlacement', _src, Config.BeeKeepingModels.HiveModel)
        if not propCoords then return false, Bridge.Notify.SendNotify(_src, locale("HivePlacement.CouldNotPlaceHive"), "error", 6000) end
        if not VerifyNotBlackListed(propCoords) then return false, Bridge.Notify.SendNotify(_src, locale("HivePlacement.BlacklistedZone"), "error", 6000) end
        if Beehives.IsAtPersonalLimit(_src) then return false, Bridge.Notify.SendNotify(_src, locale("HivePlacement.MaxOwnedHivesReached"), "error", 6000) end
        local hiveId = GenerateRandomString("Hive-", IdsTable)
        local repackCoords = vector4(propCoords.x, propCoords.y, propCoords.z, propHeading)
        Beehives.CreateHive(_src, hiveId, repackCoords, itemData)
        Bridge.Inventory.RemoveItem(_src, "beehive", 1, itemData.slot, nil)
    end)
end

RegisterNetEvent('community_bridge:Server:OnPlayerLoaded', function(src)
    local _src = src
    TriggerClientEvent('MrNewbBeeKeeping:Client:InitializePlayerData', _src, Beehives.StoredHives)
end)