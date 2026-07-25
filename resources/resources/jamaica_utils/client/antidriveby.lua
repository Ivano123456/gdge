local blockedControls = {
    24,
    25,
    68,
    69,
    70,
    91,
    92,
    114,
    257,
    331
}

local function setDriveByAllowed(allowed)
    SetPlayerCanDoDriveBy(PlayerId(), allowed)
end

local function syncDriveBy()
    setDriveByAllowed(not (cache.vehicle and cache.seat == -1))
end

lib.onCache('vehicle', syncDriveBy)
lib.onCache('seat', syncDriveBy)

CreateThread(function()
    while true do
        if cache.vehicle and cache.seat == -1 then
            setDriveByAllowed(false)

            if IsPedArmed(cache.ped, 6) then
                DisablePlayerFiring(cache.ped, true)

                for i = 1, #blockedControls do
                    DisableControlAction(0, blockedControls[i], true)
                end

                Wait(0)
            else
                Wait(100)
            end
        else
            setDriveByAllowed(true)
            Wait(500)
        end
    end
end)
