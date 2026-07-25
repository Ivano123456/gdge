base = {}
base.resource = GetCurrentResourceName()
base.SQLName = 'tw_garbage'
--- @param event string
--- @return string
function _event(event)
    return base.resource .. ':' .. event
end

function GetCore()
    local object = nil
    local Framework = Config.Framework

    -- Standalone framework bypass
    if Config.Framework == "standalone" then
        object = {
            name = "standalone",
            version = "1.0.0"
        }
        print("^2[tw-garbagev2]^7 Standalone mode enabled - No framework required")
        return object, Framework
    end

    if Config.Framework == "oldesx" then
        local counter = 0
        while not object do
            TriggerEvent('esx:getSharedObject', function(obj) object = obj end)
            counter = counter + 1
            if counter == 3 then
                break
            end
            Citizen.Wait(1000)
        end
        if not object then
            print(
                _event(
                    '::Framework is not selected in the config correctly if you\'re sure it\'s correct please check your events to get framework object'))
        end
    end

    if Config.Framework == "esx" then
        local counter = 0
        local status = pcall(function()
            exports['es_extended']:getSharedObject()
        end)
        if status then
            while not object do
                object = exports['es_extended']:getSharedObject()
                counter = counter + 1
                if counter == 3 then
                    break
                end
                Citizen.Wait(1000)
            end
        end
        if not object then
            print(
                _event(
                    '::Framework is not selected in the config correctly if you\'re sure it\'s correct please check your events to get framework object'))
        end
    end

    if Config.Framework == "qb" then
        local counter = 0
        local status = pcall(function()
            exports["qb-core"]:GetCoreObject()
        end)
        if status then
            while not object do
                object = exports["qb-core"]:GetCoreObject()
                counter = counter + 1
                if counter == 3 then
                    break
                end
                Citizen.Wait(1000)
            end
        end
        if not object then
            print(
                _event(
                    '::Framework is not selected in the config correctly if you\'re sure it\'s correct please check your events to get framework object'))
        end
    end

    if Config.Framework == "oldqb" then
        local counter = 0

        while not object do
            counter = counter + 1
            TriggerEvent('QBCore:GetObject', function(obj) object = obj end)
            if counter == 3 then
                break
            end
            Citizen.Wait(1000)
        end
        if not object then
            print(
                _event(
                    '::Framework is not selected in the config correctly if you\'re sure it\'s correct please check your events to get framework object'))
        end
    end

    if Config.Framework == "vrp" then
        -- Different vRP forks load at different times and the @vrp/lib include
        -- order is not guaranteed, so we retry indefinitely (with a soft warning
        -- after a while) instead of giving up after 3 tries.
        local Proxy = nil
        local attempts = 0

        while not object do
            if not Proxy then
                pcall(function() Proxy = module("vrp", "lib/Proxy") end)
            end
            if Proxy then
                local ok, iface = pcall(function() return Proxy.getInterface("vRP") end)
                if ok and iface then
                    object = iface
                    break
                end
            end
            -- Final fallback for forks that expose a global vRP table directly
            if type(vRP) == "table" then
                object = vRP
                break
            end

            attempts = attempts + 1
            if attempts == 10 then
                print(
                    "^3[tw-garbagev2]^7 vRP interface still not available after 10s — make sure '@vrp/lib/utils.lua' is in fxmanifest and the vrp resource is started.")
            end
            Citizen.Wait(1000)
        end

        -- vRP2 detection: vRP2 (ImagicTheCat OOP rewrite) returns a Base
        -- extension from Proxy.getInterface, NOT the flat vRP1 API. It has no
        -- getUserId/giveMoney/getUserIdentity functions. This script targets
        -- vRP1-family forks only — fail loud and disable rather than crash
        -- with confusing nil-call errors deep in helpers.
        if object then
            local hasV1Api = pcall(function() return type(object.getUserId) end)
            if not hasV1Api or type(object.getUserId) ~= "function" then
                print("^1[tw-garbagev2]^7 ============================================================")
                print("^1[tw-garbagev2]^7 vRP2 (or unsupported vRP fork) detected.")
                print("^1[tw-garbagev2]^7 This script supports vRP1-family forks only")
                print("^1[tw-garbagev2]^7 (MM1212/vRP-1, Infinity, vrp-br, ImagicTheCat vRP1).")
                print("^1[tw-garbagev2]^7 vRP2 uses a User-object API and is not compatible.")
                print("^1[tw-garbagev2]^7 Disabling tw-garbagev2 to avoid runtime errors.")
                print("^1[tw-garbagev2]^7 ============================================================")
                Config.Framework = "unsupported"
                object = nil
            end
        end
    end

    return object, Framework
end

function base.deepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[base.deepCopy(orig_key)] = base.deepCopy(orig_value)
        end
        setmetatable(copy, base.deepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
