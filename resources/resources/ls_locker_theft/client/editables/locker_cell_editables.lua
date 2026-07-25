function Locker_cell:add_door_interact()
    local offset = vector3(0, 0, 0)
    local message = L('3d_break_door_prompt')
    local target_message = L('target_break_door_prompt')
    local input = Keys[Config.inputs.break_in.key]

    local function InteractCallback()
        if not PoliceCheck() then
            return
        end
        
        Wait(math.random(10, 20))
        if self.state.is_busy then
            return
        end

        local input_amount = math.random(Config.sequence.min, Config.sequence.max)

        self:position_player()
        local stop_play_func = self:open_cell_animation()
        local coords = GetEntityCoords(self.door_entity)

        if Config.dispatch.enabled and Config.should_alert_dispatch.on_opening_lockers.enabled then
            if HELPERS.roll_chance(Config.should_alert_dispatch.on_opening_lockers.chance) then
                SendDispatchAlert()
            end
        end

        self:trigger('set_busy', true)
        local success = exports['kq_link']:SequenceMinigame(coords, input_amount, false, L('minigame_title'),
            L('minigame_info'))
        stop_play_func()
        self:trigger('set_busy', false)

        if Config.items.force_open.enabled then
            TriggerServerEvent('ls_locker_theft:server:remove_player_item', Config.items.force_open.name)
        end

        if success then
            if Config.particles.enable then
                local particles = Config.particles
                local min, max = GetModelDimensions(GetEntityModel(self.door_entity))
                local particle_z = 0.1

                if min and max then
                    particle_z = (max.z - min.z) / 2
                end

                local particle_coords = HELPERS.get_offset_from_heading(coords, GetEntityHeading(self.door_entity),
                    vector3(-0.5, 0, particle_z))

                HELPERS.play_particle(particles.particle_asset, particles.particle_name, particle_coords,
                    particles.particle_play_length, particles.scale)
            end

            self:trigger('open')
        else
            if Config.should_alert_dispatch.on_fail_to_open.enabled then
                if HELPERS.roll_chance(Config.should_alert_dispatch.on_fail_to_open.chance) then
                    SendDispatchAlert()
                end
            end
        end
    end

    local function CanInteract()
        if Config.hacking_minigame_only then
            return false
        end

        if Config.items.force_open.enabled then
            local item_count = exports['kq_link']:GetItemCount(Config.items.force_open.name)
            
            if item_count <= 0 then
                return false
            end
        end


        return not self.state.is_open and not self.state.is_busy and not IS_CARRYING and not IS_LOOTING
    end

    exports['kq_link']:AddInteractionEntity(self.door_entity, offset, message, target_message, input,
        InteractCallback, CanInteract)
end

function Locker_cell:add_loot_interact()
    local message = L('3d_loot_prompt')
    message = message:format(Config.inputs.loot.key)

    local target_message = L('target_loot_prompt')
    local input = 46
    local coords = GetEntityCoords(self.loot_entity)
    local entity_model = GetEntityModel(self.door_entity)

    local has_loaded = HELPERS.load_model(entity_model)
    local scale = nil
    
    if has_loaded then
        local min, max = GetModelDimensions(entity_model)
        scale = vector3(max.x - min.x, max.y - min.y, max.z - min.z)
    else
        scale = vector3(1, 1, 0.5)
    end

    local rotation = GetEntityRotation(self.door_entity, 2)

    local function LootInteractCallback()
        if not PoliceCheck() then
            return
        end

        Wait(math.random(10, 20))

        if self.state.is_busy then
            return
        end

        self:trigger('set_busy', true)
        local kill_anim, wait_time = self:take_loot_animation()
        self:loot_progress_bar()
        kill_anim()
        self:carry_thread()

        self:trigger('loot_cell')
        self:trigger('set_busy', false)
    end

    local function CanInteract()
        return self.state.loot and not IS_CARRYING
    end

    self.loot_interaction = exports['kq_link']:AddInteractionZone(coords, rotation, scale, message, target_message, input,
        LootInteractCallback, CanInteract)
end
