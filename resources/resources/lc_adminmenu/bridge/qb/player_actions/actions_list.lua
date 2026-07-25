---@diagnostic disable: redundant-return-value

---@class PlayerAction
---@diagnostic disable: duplicate-doc-field
---@field label string
---@field description? string
---@field permission? string
---@field args? PlayerActionArgument[]
---@field onClick fun(player, args)

---@class PlayerActionArgument
---@field label? string
---@field placeholder? string Only for "text" inputs
---@field type 'text' | 'number' | 'range'
---@field value? string | number Default value
---@field min? number
---@field max? number
---@field step? number Only for "range" inputs

---@type PlayerAction[]
local PlayerActions = {
  {
    label = 'Give Item',
    permission = 'give_item',
    args = {
      {
        label = 'Item name',
        placeholder = 'bread',
        type = 'text'
      },
      {
        label = 'Amount',
        type = 'range',
        value = 1,
        min = 1,
        max = 250
      }
    },
    onClick = function(player, args)
      if #args[1] == 0 then
        return false, 'Invalid item name'
      end

      if type(args[2]) ~= 'number' then
        return false, 'Invalid quantity'
      end

      local attempt_give_item = lib.callback.await('lc_admin:player_actions:qb_inv:attemptGiveItem', 100, tonumber(player.source), args[1], args[2])
      if not attempt_give_item then
        return false, 'Invalid item name'
      end

      return true
    end
  },
  {
    label = L('summon_player.trigger'),
    title = L('summon_player.trigger'),
    description = L('summon_player.confirmation'),
    permission = 'summon_player',
    args = {
      {
        label = 'Duration',
        type = 'range',
        value = 5,
        min = 0,
        max = 60,
        unit = 's'
      }
    },
    onClick = function (player, args)
      if type(args[1]) ~= 'number' then
        return false, 'Invalid duration'
      end

      TriggerServerEvent('lc_admin:requestSummonPlayer', player.source, args[1])
      return true
    end
  },
  {
    label = L('actions.revive'),
    permission = 'revive',
    onClick = function(player)
      TriggerServerEvent('lc_admin:player_actions:revive', player.source)
    end
  },
  {
    label = L('actions.heal'),
    onClick = function(player)
      TriggerServerEvent('lc_admin:player_actions:qb:heal', player.source)
    end
  },
  {
    label = L('actions.view_inv'),
    permission = 'view_inv',
    onClick = function(player)
      CloseAdminMenu()
      TriggerServerEvent('lc_admin:player_actions:qb_inv:viewInventory', player.source)
    end
  },
  {
    label = L('actions.clear_inv'),
    permission = 'clear_inventory',
    onClick = function(player)
      TriggerServerEvent('lc_admin:player_actions:qb_inv:clearInventory', player.source)
    end
  },
  {
    label = L('actions.set_routing_bucket'),
    permission = 'routing_buckets',
    description = L('actions.routing_bucket_description'),
    args = {
      {
        label = 'Bucket',
        type = 'number',
        value = 0,
        min = 0
      }
    },
    onClick = function(player, args)
      if type(args[1]) ~= 'number' then
        return false, 'Invalid bucket'
      end

      TriggerServerEvent('lc_admin:player_actions:qb:setBucket', player.source, args[1])
    end
  }
}

return PlayerActions