function StartMiniGame()
    local minigameSet = Config.HiveGameplaySettings.HiveMiniGame
    if minigameSet == "ox" then
        local result = lib.skillCheck({'easy', 'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
        return result
    elseif minigameSet == "bagus" then
        local result = exports['lockpick']:startLockpick()
        return result
    elseif minigameSet == "ps-ui" then
        local returnvalue = false
        exports['ps-ui']:Circle(function(success)
            if success then
                returnvalue = true
            else
                returnvalue = false
            end
        end, 3, 20000)
        return returnvalue
    elseif minigameSet == "bl-progress" then
        local success = exports.bl_ui:Progress(3, 50)
        return success
    elseif minigameSet == "bl-keyspam" then
        local success = exports.bl_ui:KeySpam(3, 50)
        return success
    elseif minigameSet == "bl-circle" then
        local success = exports.bl_ui:CircleProgress(3, 50)
        return success
    elseif minigameSet == "bl-printlock" then
        local success = exports.bl_ui:PrintLock(3, {
            grid = 4,
            duration = 5000,
            target = 4
        })
        return success
    elseif minigameSet == "t3_lockpick" then
        local returnvalue = false
        local success = exports["t3_lockpick"]:startLockpick(1.0, 2, 5)
        if success then
            returnvalue = true
        else
            returnvalue = false
        end
        return returnvalue
    elseif minigameSet == "bit-unlock" then
        -- untested, I dont own this to test
        local returnvalue = nil
        TriggerEvent("bit-unlock:start", "lockpick", "easy", function(success)
            if success then
                returnvalue = true
            else
                returnvalue = false
            end
        end)
        while returnvalue == nil do
            Wait(0)
        end
        return returnvalue
    elseif minigameSet == "xmmx" then
        local success = exports.xmmx_circlesgame:StartCircleGame("medium", 50, "letters", "Test Game:")
        return success
    elseif minigameSet == "rainmadlockpick" then
        -- he doesnt list if a bool is returned on false and closed my ticket when I asked.
        local success = exports['rm_minigames']:timedLockpick(200)
        return success or false
    elseif minigameSet == "rainmadaction" then
        -- he doesnt list if a bool is returned on false and closed my ticket when I asked.
        local success = exports['rm_minigames']:timedAction(3)
        return success or false
    elseif minigameSet == "rainmadquick" then
        -- he doesnt list if a bool is returned on false and closed my ticket when I asked.
        local success = exports['rm_minigames']:quickTimeEvent("easy")
        return success or false
    elseif minigameSet == "rainmadmash" then
        -- he doesnt list if a bool is returned on false and closed my ticket when I asked.
        local success = exports['rm_minigames']:buttonMashing(5, 10)
        return success or false
    elseif minigameSet == "rainmadangled" then
        -- he doesnt list if a bool is returned on false and closed my ticket when I asked.
        local success = exports['rm_minigames']:angledLockpick("easy")
        return success or false
    else
        return true
    end
end

function FailedMinigame()
    local anim = Bridge.Utility.RequestAnimDict("missminuteman_1ig_2")
    if not anim then return end
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    SetEntityHealth(ped, health - 1)
    ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.5)
    TaskPlayAnim(ped, "missminuteman_1ig_2", "tasered_2", 8.0, -8, 5000, 1, 0, false, false, false)
    Wait(5000)
    StopGameplayCamShaking(true)
    Bridge.Notify.SendNotify(locale("Fails.Stung"), "error", 6000)
end

-- RegisterCommand("failedtest", function()
--     FailedMinigame()
-- end, false)