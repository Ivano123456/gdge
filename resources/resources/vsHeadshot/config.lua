---@diagnostic disable: duplicate-set-field
Config = {}

--- Reset time in minutes after which the headshot counter resets
Config.ResetTime = 5

--- List of events that should reset the headshot counter (i.e. events that heal the player or kill the player)
Config.ResetEvents = {
    --ESX
    'esx:onPlayerDeath',
    'esx_ambulancejob:revive',

    --BaseEvents
    'baseevents:onPlayerKilled',
    'baseevents:onPlayerDied',
}

--- Function that kills a player (default: ApplyDamageToPed with 101 damage)
---@param entity number
Config.KillFunction = function(entity)
    ApplyDamageToPed(entity, 101, false)
end

---@class CtxEntry
---@field killer table
---@field victim table

---@class CtxTable
---@field esx CtxEntry
---@field qb CtxEntry

--- Function called when a player dies, triggered on client side (can be used for logging)
---@param killer number
---@param victim number
---@param weaponHash number
---@param ctx CtxTable
Config.ClientOnDeath = function(killer, victim, weaponHash, ctx)
end

--- Function called when a player dies, triggered on server side (can be used for logging)
---@param killer number
---@param victim number
---@param weaponHash number
---@param ctx CtxTable
Config.ServerOnDeath = function(killer, victim, weaponHash, ctx)
    local deathReason = "killed with a headshot"

    TriggerEvent('Prefech:playerDied',
        {
            type = 2,
            player_id = victim,
            player_2_id = killer,
            death_reason = deathReason,
            weapon = WeaponNames
                [weaponHash]
        }
    )
end

--- Enable/disable the SwitchHeadshot export function
Config.EnableExports = false

--- If true, makes every helmet one-shot (regardless of configuration)
Config.EveryOneshot = true

--- Enable to make helmets stronger than usual (buffed helmets)
Config.BuffingHelmets = false

--- Global hit limit for all helmets (-1 to disable)
Config.GlobalHitLimit = -1

--- Damage modifier to reduce overall damage of selected weapons (1.0 = 100% damage)
Config.DamageModifier = 1.0

--- Maximum distance at which shots can be one-shot (0/false/nil to disable)
Config.MaximumDistance = 0

--- Distance after which a shot only counts as half a headshot (0/false/nil to disable)
Config.DropoffDistance = 0

--- Percentage that the "damage" is reduced to (0.5 = a hit is worth 0.5 hits, 0.25 = a hit is worth 0.25 hits)
Config.DropoffPercentage = 0.5

--- Enable gender-specific helmet configurations
Config.UseGenderDifference = false

--- Helmet configuration for all players (default gta: https://wiki.rage.mp/index.php?title=Male_Hats)
Config.Helmet = {
    --example for helmet 10: [10] = 1,
}

--- Helmet configuration specifically for male players
Config.HelmetMale = {
    --example for helmet 10: [10] = 1,
}

--- Helmet configuration specifically for female players
Config.HelmetFemale = {
    --example for helmet 10: [10] = 1,
}

--- Blacklisted weapons that should not be detected by the system
Config.BlacklistedWeapons = {
    --example for "stungun": [911657153] = true,
}

--- Whitelisted damage types that should be detected (true = allow death from this damage type)
Config.WhitlistedDamage = {
    [1] = false,  --no damage (flare,snowball, petrolcan)
    [2] = false,  --melee
    [3] = true,   --bullet
    [5] = false,  --explosive (RPG, Railgun, grenade)
    [10] = false, --electric
    [14] = false, --water cannon(WEAPON_HIT_BY_WATER_CANNON)
}

--- Enable debug output
Config.Debug = false

--- Enable advanced debug output
Config.AdvancedDebug = false

-- Test command
Config.TestCommand = false -- Set to true to enable the test command
Config.TestCommandName = "testheadshot" -- Name of the test command