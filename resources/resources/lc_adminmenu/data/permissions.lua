---@class Permission
---@field label string
---@field name string
---@field linked_ace_permission? string | string[]

---@type Permission[]
return {
  {
    label = 'Spectate',
    name = 'spectate'
  },
  {
    label = 'Summon player',
    name = 'summon_player'
  },
  {
    label = 'Kick',
    name = 'kick',
    linked_ace_permission = {
      'command.kick'
    }
  },
  {
    label = 'Player Notes',
    name = 'player_notes'
  },
  {
    label = 'Revive',
    name = 'revive',
    linked_ace_permission = {
      'command.revive',
      'command.heal',
    }
  },
  {
    label = 'Teleport',
    name = 'teleport',
    linked_ace_permission = {
      'command.goto',
      'command.bring',
      'command.freeze',
      'command.unfreeze'
    }
  },
  {
    label = 'Give Item',
    name = 'give_item',
    linked_ace_permission = {
      'command.giveitem',
      'command.setitem'
    }
  },
  {
    label = 'Clear inventory',
    name = 'clear_inventory',
    linked_ace_permission = {
      'command.clearinv',
      'command.clearevidence',
      'command.takeinv',
      'command.returninv',
      'command.restoreinv',
    }
  },
  {
    label = 'Routing Buckets',
    name = 'routing_buckets'
  },
  {
    label = 'Banning',
    name = 'ban_add'
  },
  {
    label = 'Unbanning',
    name = 'ban_delete'
  },
  {
    label = 'Licenses edit',
    name = 'licenses_edit'
  },
  {
    label = 'Editing trust score',
    name = 'trust_score_edit'
  },
  {
    label = 'Resetting trust score',
    name = 'trust_score_reset'
  },
  {
    label = 'Character details edit',
    name = 'character_edit'
  },
  {
    label = 'Accounts edit',
    name = 'accounts_edit'
  },
  {
    label = 'Adding vehicles',
    name = 'vehicle_add'
  },
  {
    label = 'Deleting vehicles',
    name = 'vehicle_delete'
  },
  {
    label = 'Announcements',
    name = 'announcements'
  },
  {
    label = 'Weather Management',
    name = 'weather_management',
    linked_ace_permission = {
      'command.weather',
      'command.time',
      'command.timescale',
      'command.noon',
      'command.morning',
      'command.evening',
      'command.night',
      'command.freezetime',
      'easytime.staff'
    }
  },
  {
    label = 'Start/Stop Resources',
    name = 'start_stop_resources',
    linked_ace_permission = {
      'command.start',
      'command.stop',
      'command.restart',
      'command.ensure',
      'command.refresh'
    }
  },
  {
    label = 'Administrators management',
    name = 'management'
  },
  -- small menu
  -- player options
  {
    label = 'Set Health/Armor',
    name = 'set_health_armor'
  },
  {
    label = 'Player Names',
    name = 'player_names'
  },
  {
    label = 'ESP',
    name = 'esp'
  },
  {
    label = 'NoClip',
    name = 'noclip'
  },
  {
    label = 'Freecam',
    name = 'freecam'
  },
  {
    label = 'Invisibility',
    name = 'invisibility'
  },
  {
    label = 'GodMode',
    name = 'godmode'
  },
  {
    label = 'Set Ped',
    name = 'set_ped'
  },
  -- vehicle options
  {
    label = 'Spawn/Delete Vehicle',
    name = 'vehicle_spawn_delete',
    linked_ace_permission = {
      'command.car',
      'command.dv',
      'command.cardel',
    }
  },
  {
    label = 'Repair Vehicle',
    name = 'vehicle_repair',
    linked_ace_permission = {
      'command.fix',
      'command.repair'
    }
  },
  {
    label = 'Change Plate',
    name = 'vehicle_change_plate'
  },
  {
    label = 'Max Tuning',
    name = 'vehicle_max_tuning'
  }
}