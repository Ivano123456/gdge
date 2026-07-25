function Locker_unit_client:add_hack_interact()
    local message = L('3d_hack_prompt')
    message = message:format(Config.inputs.hack.key)

    local target_message = L('target_hack_prompt')
    local input = 46 -- E
    local coords = GetEntityCoords(self.entity) + vector3(0, 0, 1)
    local rotation = GetEntityRotation(self.entity, 2)
    local scale = vector3(0.8, 0.8, 0.8)

    local function InteractCallback()
        if not PoliceCheck() then
            return
        end

        self:trigger('set_being_hacked', true)

        local success = OnHackStart(self.entity)

        self:trigger('set_being_hacked', false)

        if Config.items.hacking.enabled then
            TriggerServerEvent('ls_locker_theft:server:remove_player_item', Config.items.hacking.name)
        end

        if success then
            self:trigger('set_is_hacked')
        else
            self:trigger('set_hack_failed')
        end
    end

    local function CanInteract()
        if Config.items.hacking.enabled then
            local item_count = exports['kq_link']:GetItemCount(Config.items.hacking.name)

            if item_count <= 0 then
                return false
            end
        end
        return not self.state.is_being_hacked and not self.state.is_hacked and self.state.can_hack and not IS_CARRYING
    end

    self.hack_interaction = exports['kq_link']:AddInteractionZone(coords, rotation, scale, message, target_message, input,
        InteractCallback, CanInteract)
end
