local Core
Framework = {}
local frameworkName = string.upper(Config.Framework)

------------------------------------------------------------------------------------------------------------

if frameworkName == "QB" then
    Core = exports['qb-core']:GetCoreObject()
elseif frameworkName == "ESX" then
    Core = exports['es_extended']:getSharedObject()
end

------------------------------------------------------------------------------------------------------------

function Framework.TriggerCallback(name, cb, ...)
    if frameworkName == "QB" then
        Core.Functions.TriggerCallback(name, cb,  ...)
    elseif frameworkName == "ESX" then
        Core.TriggerServerCallback(name, cb,  ...)
    elseif frameworkName == "QBOX" then
        lib.callback(name, false, cb, ...)
    end
end

------------------------------------------------------------------------------------------------------------

function Framework.Notify(text, texttype)
    if frameworkName == "QB" then
        Core.Functions.Notify(text, texttype)
    elseif frameworkName == "ESX" then
        Core.ShowNotification(text)
    elseif frameworkName == "QBOX" then
        exports.qbx_core:Notify(text, texttype)
    end
end

------------------------------------------------------------------------------------------------------------

function Framework.progressBar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    if frameworkName == "QB" then
        exports['progressbar']:Progress({
            name = name:lower(),
            duration = duration,
            label = label,
            useWhileDead = useWhileDead,
            canCancel = canCancel,
            controlDisables = disableControls,
            animation = animation,
            prop = prop,
            propTwo = propTwo,
        }, function(cancelled)
            if not cancelled then
                if onFinish then
                    onFinish()
                end
            else
                if onCancel then
                    onCancel()
                end
            end
        end)
    elseif frameworkName == "ESX" or frameworkName == "QBOX" then
        if lib.progressBar({
            duration = duration,
            label = label,
            useWhileDead = useWhileDead,
            canCancel = canCancel,
            disable = {
                car = disableControls.disableCarMovement,
            },
        }) then onFinish() else onCancel() end
    end
end

------------------------------------------------------------------------------------------------------------
