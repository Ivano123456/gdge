-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if not GetResourceState("es_extended"):find('start') then return end

---@type table<string, any>
local ESX = exports.es_extended:getSharedObject()

---@type string
FRAMEWORK = 'esx'

---@type boolean
PlayerLoaded = false

---@type string
local job = nil

---@type table<string, any>
local playerData = {}

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    local xPlayer = ESX.GetPlayerData()
    job = xPlayer.job.name
    playerData = xPlayer
    PlayerLoaded = true
    TriggerEvent('wasabi_gps:playerLoaded')
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerLoaded = true
    job = xPlayer.job.name
    playerData = xPlayer
    TriggerEvent('wasabi_gps:playerLoaded')
    TriggerServerEvent('wasabi_gps:playerLoaded')
end)

---@return string
function GetJob()
    return job
end

---@return boolean
function IsOnDuty()
    if not job or job:sub(0, 3) == 'off' then return false end
    return true
end

RegisterNetEvent('esx:setJob', function(jobData)
    if not jobData or not jobData.name then return end
    job = jobData.name
    playerData.job = jobData
end)
