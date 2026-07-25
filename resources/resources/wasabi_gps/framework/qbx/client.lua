-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
if not GetResourceState("qbx_core"):find('start') then return end

---@type table<string, any>
local QBX = exports.qbx_core

---@type string
FRAMEWORK = 'qbx'

---@type boolean
PlayerLoaded = false

---@type string
local job = nil

---@type table<string, any>
local playerData = {}


AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    playerData = QBX.GetPlayerData()
    job = playerData.job.name
    PlayerLoaded = true
    TriggerEvent('wasabi_gps:playerLoaded')
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    playerData = QBX.GetPlayerData()
    job = playerData.job.name
    PlayerLoaded = true
    TriggerEvent('wasabi_gps:playerLoaded')
    TriggerServerEvent('wasabi_gps:playerLoaded')
end)

---@return string
function GetJob()
    return job
end

---@return boolean
function IsOnDuty()
    return playerData.job.onduty or false
end

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(jobData)
    if not jobData or not jobData.name then return end
    job = jobData.name
    playerData.job = jobData
end)
