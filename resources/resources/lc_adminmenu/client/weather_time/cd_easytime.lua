local MODULE_NAME <const> = 'cd_easytime'
if not GetResourceState(MODULE_NAME):find('start') then return end

print('cd_easytime wrapper loaded')

---@class CdTimeWeatherData
---@field weather string | false
---@field hour number | false
---@field minute number | false
---@field freezeTime boolean
---@field blackOut boolean
---@field dynamic boolean
---@field tsunami boolean

---@class CdEasyTimeForceUpdateData
---@field weather string
---@field hours number
---@field mins number
---@field freeze boolean
---@field blackout boolean
---@field dynamic boolean
---@field tsunami boolean
---@field instantweather boolean
---@field instattime boolean

---@type CdTimeWeatherData
local easytime_state = {
    weather = false,
    hour = false,
    minute = false,
    freezeTime = false,
    blackOut = false,
    dynamic = false,
    tsunami = false
}

local function send_weather_data()
    SendNUIMessage({
        action = 'setWeatherData',
        data = easytime_state
    })
end

RegisterNUICallback('getWorldOptionsState', function(data, cb)
    if not easytime_state.weather then
        TriggerServerEvent('cd_easytime:SyncMe')
    end

    cb(easytime_state)
end)

RegisterNUICallback('setTime', function(data, cb)
    cb(true)

    local anythingChanged = false
    local payload = {
        hours = easytime_state.hour,
        mins = easytime_state.minute,
        freeze = nil,
        instanttime = true
    }

    if data.hour ~= easytime_state.hour then
        payload.hours = tonumber(data.hour)
        anythingChanged = true
    end

    if data.minute ~= easytime_state.minute then
        payload.mins = tonumber(data.minute)
        anythingChanged = true
    end

    if data.freezeTime ~= easytime_state.freezeTime then
        payload.freeze = data.freezeTime
        anythingChanged = true
    end

    if anythingChanged then
        TriggerServerEvent('cd_easytime:ForceUpdate', payload)
    end
end)

RegisterNUICallback('setWeather', function(data, cb)
    cb(true)

    local anythingChanged = false
    local payload = {
        weather = nil,
        dynamic = nil,
        tsunami = nil,
        blackout = nil,
        instantweather = false
    }

    if data.weather ~= easytime_state.weather then
        payload.weather = data.weather
        anythingChanged = true
    end

    if data.dynamic ~= easytime_state.dynamic then
        payload.dynamic = data.dynamic
        anythingChanged = true
    end

    if data.tsunami ~= easytime_state.tsunami then
        payload.tsunami = data.tsunami
        anythingChanged = true
    end

    if data.blackOut ~= easytime_state.blackOut then
        payload.blackout = data.blackOut
        anythingChanged = true
    end

    if anythingChanged then
        TriggerServerEvent('cd_easytime:ForceUpdate', payload)
    else
        dprint('no changes in weather options made')
    end
end)

RegisterNetEvent('cd_easytime:ForceUpdate')
AddEventHandler('cd_easytime:ForceUpdate', function(data)
    if not LocalAdminInstance then return end

    ---@cast data CdEasyTimeForceUpdateData
    if data.weather ~= nil then
        easytime_state.weather = data.weather
    end

    if data.hours ~= nil then
        easytime_state.hour = data.hours
    end

    if data.mins ~= nil then
        easytime_state.minute = data.mins
    end

    if data.freeze ~= nil then
        easytime_state.freezeTime = data.freeze
    end

    if data.blackout ~= nil then
        easytime_state.blackOut = data.blackout
    end

    if data.dynamic ~= nil then
        easytime_state.dynamic = data.dynamic
    end

    if data.tsunami ~= nil then
        easytime_state.tsunami = data.tsunami
    end

    send_weather_data()
end)

RegisterNetEvent('cd_easytime:SyncTime')
AddEventHandler('cd_easytime:SyncTime', function(data)
    if not LocalAdminInstance then return end

    if data.hours then
        easytime_state.hour = data.hours
    end

    if data.mins then
        easytime_state.minute = data.mins
    end

    if not easytime_state.weather then
        TriggerServerEvent('cd_easytime:SyncMe')
    end

    send_weather_data()
end)

RegisterNetEvent('cd_easytime:SyncWeather')
AddEventHandler('cd_easytime:SyncWeather', function(data)
    if not LocalAdminInstance then return end

    easytime_state.weather = data.weather
    send_weather_data()
end)

function GetWeatherProvider()
    return MODULE_NAME
end