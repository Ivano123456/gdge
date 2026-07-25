---@class MenuItemData
---@field id string
---@field label string
---@field type 'submenu' | 'action' | 'args' | 'toggle'
---@field toggleValue? boolean
---@field subItems? MenuItemData[]
---@field args? ArgumentsModalSchema

---@class ArgumentsModalFieldOption
---@field label string
---@field value string|number

---@class ArgumentsModalField
---@field label string
---@field description? string
---@field type 'number'|'text'|'range'|'select'|'checkbox'|'toggle'|'player'|'coords'
---@field value? string|number|boolean
---@field min? number
---@field max? number
---@field step? number
---@field unit? string
---@field select_options? ArgumentsModalFieldOption[]

---@class ArgumentsModalOptions
---@field dontDisableNuiFocusOnClose? boolean
---@field dontCloseOnSubmit? boolean

---@class ArgumentsModalSchema
---@field title string
---@field description? string
---@field fields ArgumentsModalField[]
---@field onSubmit? fun(values: any)
---@field options? ArgumentsModalOptions

local SharedConfig <const> = require 'config_shared'
local ACTIONS <const> = require 'data.small_menu_actions'
local Bridge <const> = require 'bridge.import'

local small_menu_state = false
local lastUpPress = 0
local lastDownPress = 0
local SCROLL_DELAY = 150  -- 500ms = 2 times per second

local GetGameTimer <const> = GetGameTimer
local IsDisabledControlJustPressed <const> = IsDisabledControlJustPressed
local IsDisabledControlPressed <const> = IsDisabledControlPressed
local IsDisabledControlJustReleased <const> = IsDisabledControlJustReleased
local DisableControlAction <const> = DisableControlAction

local function BuildSmallMenuSchema()
    local function build_player_options()
        local subItems = {
            { id = 'revive', label = 'Revive', type = 'action', permission = 'revive' },
            { id = 'noclip', label = 'NoClip', type = 'toggle', permission = 'noclip' },
            { id = 'freecam', label = 'FreeCam', type = 'toggle', permission = 'freecam' },
            { id = 'player_names', label = 'Player Names', type = 'toggle', permission = 'player_names' },
            { id = 'admin_crosshair', label = 'Admin Crosshair', type = 'toggle' },
            { id = 'esp', label = 'ESP', type = 'toggle', permission = 'esp' },
            { id = 'invisibility', label = 'Invisibility', type = 'toggle', permission = 'invisibility' },
            { id = 'godmode', label = 'GodMode', type = 'toggle', permission = 'godmode' },
            {
                id = 'set_health',
                label = 'Set Health',
                type = 'args',
                permission = 'set_health_armor',
                args = {
                    title = 'Set Health',
                    fields = {
                        { label = 'Health', type = 'number', value = 100, min = 0, max = 100, step = 1 },
                    }
                }
            },
            {
                id = 'set_armor',
                label = 'Set Armor',
                type = 'args',
                permission = 'set_health_armor',
                args = {
                    title = 'Set Armor',
                    fields = {
                        { label = 'Armor', type = 'number', value = 100, min = 0, max = 100, step = 1 }
                    }
                }
            },
            {
                id = 'set_ped',
                label = 'Set Ped',
                type = 'args',
                permission = 'set_ped',
                args = {
                    title = 'Set Ped',
                    fields = {
                        { type = 'ped' },
                    }
                }
            },
        }
        local item = {
            id = 'player',
            label = 'Player Options',
            type = 'submenu',
            subItems = subItems
        }

        return item
    end

    local function build_vehicle_options()
        local subItems = {
            {
                id = 'spawn_vehicle', label = 'Spawn Vehicle', type = 'args',
                permission = 'vehicle_spawn_delete',
                args = {
                    title = 'Spawn Vehicle',
                    fields = {
                        { label = 'Vehicle', type = 'text' }
                    }
                }
            },
            { id = 'repair_vehicle', label = 'Repair Vehicle', type = 'action', permission = 'vehicle_repair' },
            { id = 'wash_vehicle', label = 'Wash Vehicle', type = 'action', permission = 'vehicle_repair' },
            {
                id = 'set_dirt_level', label = 'Set Dirt Level', type = 'args', permission = 'vehicle_repair',
                args = {
                    title = 'Set Dirt Level',
                    fields = {
                        { label = 'Dirt Level', type = 'range', min = 0, max = 10, value = 5, step = 1 }
                    }
                }
            },
            {
                id = 'delete_vehicle', label = 'Delete Vehicle', type = 'args', permission = 'vehicle_spawn_delete',
                args = {
                    title = 'Are you sure?',
                    description = 'Do you really want to delete this vehicle?',
                    fields = {}
                },
            },
            {
                id = 'change_plate', label = 'Change Plate', type = 'args', permission = 'vehicle_change_plate',
                args = {
                    title = 'Change Plate',
                    fields = {
                        { label = 'Plate', type = 'text', max = 8 }
                    }
                }

            },
            { id = 'max_tuning', label = 'Max Tuning', type = 'action', permission = 'vehicle_max_tuning' }
        }
        local item = {
            id = 'vehicle',
            label = 'Vehicle Options',
            type = 'submenu',
            subItems = subItems
        }

        return item
    end

    local function build_teleport_options()
        ---@type MenuItemData[]
        local subItems = {
            {
                id = 'teleport_to_marker',
                label = 'Teleport to Marker',
                type = 'action',
                permission = 'teleport'
            },
            {
                id = 'teleport_to_coords',
                label = 'Teleport to Coords',
                type = 'args',
                permission = 'teleport',
                args = {
                    title = 'Teleport to Coords',
                    fields = {
                        { label = 'Coords', type = 'coords' }
                    }
                }
            },
            {
                id = 'teleport_to_player',
                label = 'Teleport to Player',
                type = 'args',
                permission = 'teleport',
                args = {
                    title = 'Teleport to Player',
                    fields = {
                        { label = 'Player', type = 'player' }
                    }
                }
            }
        }
        local item = {
            id = 'teleport',
            label = 'Teleport Options',
            type = 'submenu',
            subItems = subItems
        }

        return item
    end

    local player_options = build_player_options()
    local vehicle_options = build_vehicle_options()
    local teleport_options = build_teleport_options()

    ---@type MenuItemData[]
    local menu_schema = {}

    menu_schema[#menu_schema+1] = player_options
    menu_schema[#menu_schema+1] = vehicle_options
    menu_schema[#menu_schema+1] = teleport_options

    return menu_schema
end

local function arrow_up()
    SendNUIMessage({
        action = 'smallMenuControlSent',
        data = 'arrowUp'
    })
end

local function arrow_down()
    SendNUIMessage({
        action = 'smallMenuControlSent',
        data = 'arrowDown'
    })
end

local function select()
    SendNUIMessage({
        action = 'smallMenuControlSent',
        data = 'select'
    })
end

local function back()
    SendNUIMessage({
        action = 'smallMenuControlSent',
        data = 'back'
    })
end

---@param options? { dontChangeNuiFocus?: boolean }
function OpenSmallMenu(options)
    if not HasPermission(nil, true) then
        Bridge.FailNotify(L('notifications.access_denied.title'), L('notifications.access_denied.description'), 'access_denied')
        return
    end
    if small_menu_state then return end

    options = options or {}
    if not options.dontChangeNuiFocus then
        SetNuiFocus(true, true)
        SetNuiFocus(false, false)
    end

    small_menu_state = true
    SendNUIMessage({
        action = 'setSmallMenuState',
        data = {
            isOpen = true,
            menuSchema = BuildSmallMenuSchema()
        }
    })

    CreateThread(function()
        while small_menu_state do
            local currentTime = GetGameTimer()
            Wait(0)

            DisableControlAction(0, 200, true) -- Escape - Block Pause Menu

            DisableControlAction(0, 24, true) -- Block Mouse left
            DisableControlAction(0, 25, true) -- Block Mouse Right

            if IsDisabledControlJustPressed(0, 15) or IsDisabledControlJustPressed(0, 172) or (IsDisabledControlPressed(0, 172) and currentTime - lastUpPress >= SCROLL_DELAY) then
                arrow_up()
                lastUpPress = currentTime
            end

            if IsDisabledControlJustPressed(0, 14) or IsDisabledControlJustPressed(0, 173) or (IsDisabledControlPressed(0, 173) and currentTime - lastDownPress >= SCROLL_DELAY) then
                arrow_down()
                lastDownPress = currentTime
            end

            if IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 201) then
                select()
            elseif IsDisabledControlJustPressed(0, 25) or IsDisabledControlJustPressed(0, 194) then
                back()
            elseif IsDisabledControlJustReleased(0, 200) then
                CloseSmallMenu()
            end
        end
    end)
end

function CloseSmallMenu()
    small_menu_state = false
    SendNUIMessage({
        action = 'setSmallMenuState',
        data = {
            isOpen = false
        }
    })
end

function IsSmallMenuOpen()
    return small_menu_state
end

function SmallMenuSelect()
    if not small_menu_state then return end
    select()
end

RegisterNUICallback('setNuiFocus', function(hasFocus, cb)
    SetNuiFocus(hasFocus, hasFocus)
    cb('ok')
end)

RegisterNUICallback('closeSmallMenu', function(_, cb)
    CloseSmallMenu()
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('setSmallMenuState', function(data, cb)
    cb(1)
    if type(data) == 'boolean' then
        if data then
            OpenSmallMenu({
                dontChangeNuiFocus = true
            })
        else
            CloseSmallMenu()
        end
    end
end)

-- Menu Actions
RegisterNUICallback('menuAction', function(data, cb)
    local action = data.id
    local value = data.value

    if ACTIONS[action] then
        ACTIONS[action](value)
    end

    cb('ok')
end)

if SharedConfig.small_menu_open_command then
    RegisterCommandList(SharedConfig.small_menu_open_command, function(source, args)
        if IsAdminPanelVisible() then
            OpenSmallMenu({
                dontChangeNuiFocus = true
            })
        else
            OpenSmallMenu()
        end
    end)
end

if SharedConfig.small_menu_open_key then
    lib.addKeybind({
        name = 'small_menu',
        description = 'Open small menu',
        defaultKey = SharedConfig.small_menu_open_key,
        onPressed = function()
            if IsAdminPanelVisible() then
                OpenSmallMenu({
                    dontChangeNuiFocus = true
                })
            else
                OpenSmallMenu()
            end
        end
    })
end