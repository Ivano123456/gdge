local attachedProp = nil
local offset = vector3(0.0, 0.0, 0.0)
local rotation = vector3(0.0, 0.0, 0.0)
local bone = nil
local model = nil
local adjusting = false


--- Spawns and attaches a model to your ped with adjustable position/rotation.
--- Use arrow keys + numpad to fine-tune offset/rotation, E to print values, Backspace to cancel.
--- Usage '/attachprop prop_name'

-- RegisterCommand('attachprop', function(_, args)
--     model = args[1]

--     if args[2] then
--         bone = tonumber(args[2])
--     else
--         bone = 0xDEAD
--     end

--     if not bone then
--         print('Invalid bone id')
--         return
--     end

--     if attachedProp then
--         DeleteEntity(attachedProp)
--         attachedProp = nil
--     end

--     local ped = PlayerPedId()
--     local modelHash = joaat(model)
--     RequestModel(modelHash)
--     while not HasModelLoaded(modelHash) do
--         Wait(0)
--     end

--     local coords = GetEntityCoords(ped)
--     attachedProp = CreateObject(modelHash, coords.x, coords.y, coords.z, true, true, false)
--     AttachEntityToEntity(attachedProp, ped, GetPedBoneIndex(ped, bone), offset.x, offset.y, offset.z, rotation.x,
--         rotation.y, rotation.z, true, true, false, true, 2, true)
--     SetModelAsNoLongerNeeded(modelHash)
--     adjusting = true

--     Citizen.CreateThread(function()
--         print('Use arrows to adjust offset, numpad to adjust rotation, E to print, BACKSPACE to cancel')
--         while adjusting do
--             if not IsEntityPlayingAnim(ped, 'anim@heists@box_carry@', 'idle') then
--                 HELPERS.play_free_anim('anim@heists@box_carry@', 'idle')
--             end

--             Wait(0)

--             if IsControlPressed(0, 172) then offset = offset + vector3(0.0, 0.01, 0.0) end    -- Up
--             if IsControlPressed(0, 173) then offset = offset - vector3(0.0, 0.01, 0.0) end    -- Down
--             if IsControlPressed(0, 174) then offset = offset - vector3(0.01, 0.0, 0.0) end    -- Left
--             if IsControlPressed(0, 175) then offset = offset + vector3(0.01, 0.0, 0.0) end    -- Right
--             if IsControlPressed(0, 116) then offset = offset + vector3(0.0, 0.0, 0.01) end    -- Right
--             if IsControlPressed(0, 40) then offset = offset - vector3(0.0, 0.0, 0.01) end     -- Right

--             if IsControlPressed(0, 117) then rotation = rotation + vector3(1.0, 0.0, 0.0) end -- NumPad +
--             if IsControlPressed(0, 111) then rotation = rotation - vector3(1.0, 0.0, 0.0) end -- NumPad -
--             if IsControlPressed(0, 108) then rotation = rotation + vector3(0.0, 1.0, 0.0) end -- NumPad 2
--             if IsControlPressed(0, 110) then rotation = rotation - vector3(0.0, 1.0, 0.0) end -- NumPad 4
--             if IsControlPressed(0, 123) then rotation = rotation + vector3(0.0, 0.0, 1.0) end -- NumPad 6
--             if IsControlPressed(0, 118) then rotation = rotation - vector3(0.0, 0.0, 1.0) end -- NumPad 8

--             if IsControlJustPressed(0, 46) then
--                 print(('Offset: vector3(%.2f, %.2f, %.2f)'):format(offset.x, offset.y, offset.z))
--                 print(('Rotation: vector3(%.2f, %.2f, %.2f)'):format(rotation.x, rotation.y, rotation.z))
--             end

--             if IsControlJustPressed(0, 177) then
--                 adjusting = false
--                 DeleteEntity(attachedProp)
--                 attachedProp = nil
--                 print('Cancelled.')
--             end

--             AttachEntityToEntity(attachedProp, ped, GetPedBoneIndex(ped, bone), offset.x, offset.y, offset.z, rotation.x,
--                 rotation.y, rotation.z, true, true, false, true, 2, true)
--         end
--     end)
-- end)

--- Plays the carrying animation (anim@heists@box_carry@, idle) on your ped.
--- Usage '/panim'

-- RegisterCommand('panim', function()
--     local animDict = 'anim@heists@box_carry@'
--     local animName = "idle"

--     while not HasAnimDictLoaded(animDict) do
--         RequestAnimDict(animDict)
--         Wait(100)
--     end

--     local blendInSpeed = 8.0
--     local blendOutSpeed = 8.0
--     local duration = -1
--     local flag = 32 + 16 + 2
--     local playbackRate = 0.0
--     local lockX = false
--     local lockY = false
--     local lockZ = false
--     local ped = PlayerPedId()

--     TaskPlayAnim(ped, animDict, animName, blendInSpeed, blendOutSpeed, duration, flag, playbackRate, lockX, lockY, lockZ)

--     SetPedKeepTask(ped, true)

--     RemoveAnimDict(animDict)
-- end)

if Config.debug then
    local pool = GetGamePool('CObject')

    for k, object in pairs(pool) do
        SetEntityAsMissionEntity(object)
        DeleteEntity(object)
    end
end