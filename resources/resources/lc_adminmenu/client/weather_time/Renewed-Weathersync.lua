local MODULE_NAME <const> = 'Renewed-Weathersync'
if not GetResourceState(MODULE_NAME):find('start') then return end

print(MODULE_NAME .. ' wrapper loaded')

local globalState = GlobalState

---@class RenewedTimeWeatherData
---@field weather string | false
---@field hour number | false
---@field minute number | false
---@field freezeTime boolean
---@field blackOut boolean
---@field timeScale number | false

---@type RenewedTimeWeatherData
local renewed_weather_state = {
    weather = false,
    hour = false,
    minute = false,
    freezeTime = false,
    blackOut = false,
    timeScale = false
}

local function send_weather_data()
    SendNUIMessage({
        action = 'setWeatherData',
        data = renewed_weather_state
    })
end

local function refresh_weather_state()
    local timeState = globalState.currentTime

    if globalState.weather ~= nil then
        renewed_weather_state.weather = globalState.weather.weather or '---'
    end

    if timeState.hour ~= nil then
        renewed_weather_state.hour = timeState.hour
    end

    if timeState.minute ~= nil then
        renewed_weather_state.minute = timeState.minute
    end

    if globalState.freezeTime ~= nil then
        renewed_weather_state.freezeTime = globalState.freezeTime
    end

    if globalState.blackOut ~= nil then
        renewed_weather_state.blackOut = globalState.blackOut
    end

    if globalState.timeScale ~= nil then
        renewed_weather_state.timeScale = globalState.timeScale
    end

    send_weather_data()
end

RegisterNUICallback('getWorldOptionsState', function(data, cb)
    refresh_weather_state()
    cb(renewed_weather_state)
end)

RegisterNUICallback('getWeatherAndTime', function(_, cb)
    local timeState = globalState.currentTime
    cb({
        weather = globalState.weather.weather or '---',
        hour = timeState.hour or 0,
        minute = timeState.minute or 0,
        freezeTime = globalState.freezeTime or false,
        blackOut = globalState.blackOut or false,
        timeScale = globalState.timeScale or 4000
    })
end)

RegisterNUICallback('setWeather', function(data, cb)
    if not isWeatherValid(data.weather) then return cb(false) end
    TriggerServerEvent('lc_admin:weather:Renewed-Weathersync:setWeatherAndBlackOut', data)
    local result = lib.callback.await('Renewed-Weathersync:server:setWeatherType', false, 1, data.weather)
    if result then return cb(true) else return cb(false) end
end)

---@param data { hour: number, minute: number, timeScale: number, freezeTime: boolean }
RegisterNUICallback('setTime', function(data, cb)
    if not isTimeValid(data) then print('Time is not valid') return cb(false) end
    local result = lib.callback.await('lc_admin:weather:Renewed-Weathersync:setTime', false, data)
    if result then print('Time set successfully') return cb(true) else print('Time set failed') return cb(false) end
end)

function GetWeatherProvider()
    return MODULE_NAME
end