
Framework = nil
CoreExportName = nil
ESX, QBCore, QBX = nil, nil, nil
local Shared = require 'shared.main'

lib.locale('hr')

function getajFramework()
    local stateESX = GetResourceState(Shared.FrameworkNames.esx)
    local stateQBOX = GetResourceState(Shared.FrameworkNames.qbox)
    local stateQB = GetResourceState(Shared.FrameworkNames.qb)

    if stateESX ~= 'missing' and stateESX ~= 'stopped' then
        Framework = 'esx'
        CoreExportName = Shared.FrameworkNames.esx
        return
    end

    if stateQBOX ~= 'missing' and stateQBOX ~= 'stopped' then
        Framework = 'qbx'
        CoreExportName = Shared.FrameworkNames.qbox
        return
    end

    if stateQB ~= 'missing' and stateQB ~= 'stopped' then
        Framework = 'qb'
        CoreExportName = Shared.FrameworkNames.qb
    end
end

local function initFramework()
    getajFramework()

    if Framework == 'esx' then
        local ok, obj = pcall(function()
            return exports[CoreExportName]:getSharedObject()
        end)
        if ok then ESX = obj end
    elseif Framework == 'qbx' then
        local ok, obj = pcall(function()
            return exports[CoreExportName]:GetCoreObject()
        end)
        if ok then QBX = obj end
    elseif Framework == 'qb' then
        local ok, obj = pcall(function()
            return exports[CoreExportName]:GetCoreObject()
        end)
        if ok then QBCore = obj end
    end
end

-- Odmah pokušaj; ako core još nije ready, retry
initFramework()
CreateThread(function()
    local tries = 0
    while not ESX and not QBCore and not QBX and tries < 50 do
        Wait(200)
        tries = tries + 1
        Framework = nil
        initFramework()
    end
end)