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
      TriggerServerEvent('lc_admin:requestHealPlayer', player.source)
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

      TriggerServerEvent('lc_admin:player_actions:standalone:setBucket', player.source, args[1])
    end
  }
}

return PlayerActions