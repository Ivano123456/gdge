IS_CARRYING = false
CURRENT_PROP = nil
IS_LOOTING = false
local CARRY_ANIM_DICT = 'anim@heists@box_carry@'
local CARRY_ANIM_NAME = 'idle'

local function StartCarryingAnimation()
    HELPERS.play_free_anim(CARRY_ANIM_DICT, CARRY_ANIM_NAME)
end

local function StopCarryingAnimation()
    local ped = PlayerPedId()
    if IsEntityPlayingAnim(ped, CARRY_ANIM_DICT, CARRY_ANIM_NAME, 3) then
        StopAnimTask(ped, CARRY_ANIM_DICT, CARRY_ANIM_NAME, 3.0)
    end
end

local function LimitPlayerMovement()
    DisableControlAction(0, 22, true)  -- Jump / vault
    DisableControlAction(0, 44, true)  -- Cover / vault
    DisableControlAction(0, 140, true) -- Melee attack
    DisableControlAction(0, 141, true) -- Melee alternate
    DisableControlAction(0, 142, true) -- Melee block
    DisableControlAction(0, 24, true)  -- Attack
    DisableControlAction(0, 25, true)  -- Aim
    DisableControlAction(0, 37, true)  -- Weapon wheel
end

local function DropProp()
    if not CURRENT_PROP then return end

    local ped = PlayerPedId()
    DetachEntity(CURRENT_PROP, true, true)

    IS_CARRYING = false
    CURRENT_PROP = nil
end

local function SetPropLooted()
    TriggerServerEvent(GetCurrentResourceName() .. ':server:set_looted', ObjToNet(CURRENT_PROP), nil)
    SetObjectAsNoLongerNeeded(CURRENT_PROP)
    DropProp()
    IS_CARRYING = false
end

local function LootProp()
    if not CURRENT_PROP or not GetEntityArchetypeName(CURRENT_PROP) then
        return
    end
    IS_LOOTING = true
    ClearPedTasks(PlayerPedId())
    DetachEntity(CURRENT_PROP, true, true)
    PerformItemLooting(CURRENT_PROP)
    IS_LOOTING = false
    
    if CURRENT_PROP then SetPropLooted() end
end

local function PickUpProp(entity)
    if IS_CARRYING or not entity then return end

    local ped = PlayerPedId()
    local entity_model = GetEntityArchetypeName(entity)

    IS_CARRYING = true
    CURRENT_PROP = entity

    HELPERS.attach_prop(entity, entity_model, ped)

    StartCarryingAnimation()
    Citizen.CreateThread(function()
        local loot_key = Config.inputs.loot.key
        local drop_key = Config.inputs.drop.key

        local carry_prompt = L('carry_prompt')
        carry_prompt = string.format(carry_prompt, Config.inputs.loot.control, Config.inputs.drop.control)

        while IS_CARRYING do
            HELPERS.input_message(carry_prompt)
            Wait(1)
            SetPlayerMayNotEnterAnyVehicle(ped)
            LimitPlayerMovement()

            if IsControlJustReleased(0, Keys[loot_key]) then
                LootProp()
                break
            end

            if IsControlJustReleased(0, Keys[drop_key]) then
                DropProp()
                break
            end
        end

        StopCarryingAnimation()
        ClearPedTasks(ped)
    end)
end

local function CreateNetworkedLootProp(loot_prop_model, loot)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    CURRENT_PROP = HELPERS.spawn_networked_object(loot_prop_model, coords)
    HELPERS.attach_prop(CURRENT_PROP, loot_prop_model, ped)
    local prop_net_id_string = tostring(ObjToNet(CURRENT_PROP))
    local prop_net_id_hashed = Hasher.encodeString(prop_net_id_string)
    TriggerServerEvent(GetCurrentResourceName() .. ':server:set_loot_state', prop_net_id_hashed, loot)
end

local function AddLootInteraction(entity)
    local offset = vector3(0, 0, 0)
    local function InteractCallback()
        PickUpProp(entity)
    end

    local function CanInteract()
        return not IS_CARRYING and Entity(entity).state.ls_postal_loot and not IS_LOOTING
    end

    return exports['kq_link']:AddInteractionEntity(entity, offset, L('3d_pickup_prompt'), L('target_pickup_prompt'),
        Keys[Config.inputs.pick_up.key], InteractCallback, CanInteract)
end

function CarryThread(loot, loot_prop_model)
    CreateNetworkedLootProp(loot_prop_model, loot)
    PickUpProp(CURRENT_PROP)
end

---HELPERS
function PerformItemLooting(object)
    local playerPed = PlayerPedId()
    local duration = Config.loot_times.large * 1000

    if IsPedInAnyVehicle(playerPed) or IsPedRagdoll(playerPed) or IsEntityDead(playerPed) then
        return false
    end

    RotateTillFree()
    local object_coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.5, 0.0)
    SetEntityCoords(object, object_coords.x, object_coords.y, object_coords.z)
    PlaceObjectOnGroundProperly(object)
    FreezeEntityPosition(object, true)

    HELPERS.play_looting_anim()
    FreezeEntityPosition(playerPed, true)

    exports.kq_link:ProgressBar(GetEntityCoords(object), duration, 1)

    FreezeEntityPosition(playerPed, false)
    FreezeEntityPosition(object, false)
    ClearPedTasks(playerPed)

    return true, object
end

local function IsForwardAreaFree()
    local playerPed = PlayerPedId()
    local startCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.3, 0.0)
    local offsetCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.15, -0.2)

    ---@diagnostic disable-next-line: param-type-mismatch
    local ray = StartShapeTestSweptSphere(startCoords, offsetCoords, 0.5, 4294967295, playerPed, 1)
    local result, hit, endCoords, normal, entity = GetShapeTestResult(ray)

    return not hit or hit == 0
end

function RotateTillFree()
    local playerPed = PlayerPedId()
    local timeout = 8

    while timeout > 0 and not IsForwardAreaFree() do
        timeout = timeout - 1
        SetEntityHeading(playerPed, GetEntityHeading(playerPed) + 45.0)
    end
end

local tracked_entities = {}

Citizen.CreateThread(function()
    while true do
        Wait(5000)

        local playerPed = PlayerPedId()
        local p_coords = GetEntityCoords(playerPed)
        local px, py = p_coords.x, p_coords.y
        local maxDistSq = 100.0

        local all_objects = GetGamePool('CObject')

        local chunk_size = 50
        local total = #all_objects

        for i = 1, total, chunk_size do
            local end_idx = math.min(i + chunk_size - 1, total)

            for j = i, end_idx do
                local entity = all_objects[j]

                if not DoesEntityExist(entity) then
                    if tracked_entities[entity] then
                        tracked_entities[entity]:Delete()
                        tracked_entities[entity] = nil
                    end
                    goto continue
                end

                local entity_coords = GetEntityCoords(entity)
                local dx = px - entity_coords.x
                local dy = py - entity_coords.y
                local distSq = dx * dx + dy * dy

                if distSq < maxDistSq then
                    local state = Entity(entity).state
                    local loot_state = state.ls_postal_loot

                    if loot_state and not tracked_entities[entity] then
                        local interaction = AddLootInteraction(entity)
                        tracked_entities[entity] = interaction
                    elseif not loot_state and tracked_entities[entity] then
                        tracked_entities[entity]:Delete()
                        tracked_entities[entity] = nil
                    end
                elseif tracked_entities[entity] then
                    tracked_entities[entity]:Delete()
                    tracked_entities[entity] = nil
                end

                ::continue::
            end

            if i + chunk_size < total then
                Wait(0)
            end
        end
    end
end)
