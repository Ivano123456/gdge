local Config <const> = require "config.main"
NuiLoaded = false

--- CheckNui()
--- @return nil
--- @description Waits until the NUI is fully loaded before proceeding.
local function CheckNui()
    while not NuiLoaded do
        Wait(100)
    end
end

--- NuiMessage(action, payload)
--- @param action string The action to be sent to the NUI.
--- @param payload table The payload data to be sent with the action.
--- @return nil
--- @description Sends a message to the NUI with the specified action and payload after ensuring the
function NuiMessage(action, payload)
    CheckNui()
    SendNUIMessage({
        action = action,
        payload = payload
    })
end

local function GetWebLocales()
    local path = 'locales/' .. GetConvar('ox:locale', 'en') .. '.json'
    local file = LoadResourceFile(GetCurrentResourceName(), path)

    if not file then
        file = LoadResourceFile(GetCurrentResourceName(), 'locales/en.json')
        print(('Locale file "%s" not found, falling back to default "en".'):format(GetConvar('ox:locale', 'en')))
        return {}
    end

    if not file or file == '' then
        error('Locale file is empty or not found')
        return {}
    end

    local success, content = pcall(json.decode, file)
    if not success then
        error(('Failed to decode JSON from locale file: %s'):format(content))
        return {}
    end

    if not content['web'] then
        error('Missing "web" section in locale file')
        return {}
    end

    return content['web']
end

--- FetchNui()
--- @return nil
--- @description Continuously checks if the NUI is loaded by sending a message every 2 seconds until a response is received.
function FetchNui()
    while not NuiLoaded do
        if NetworkIsSessionStarted() then
            SendNUIMessage({
                action = 'nui/check',
            })
        end
        Wait(2000)
    end

    NuiMessage('nui/set-config', {
        headerImage = Config.ServerLogoURL,
        tasks = Config.Tasks,
    })

    NuiMessage('nui/set-language', {
        language = GetWebLocales()
    })
end

function GetMultiplayerData()
    if CurrentMultiplayerData and next(CurrentMultiplayerData) then
        return CurrentMultiplayerData
    end

    local data = lib.callback.await(Event('callback:getMultiplayerData'))
    if data and next(data) then
        CurrentMultiplayerData = data
        return data
    end

    local newTeam = lib.callback.await(Event('callback:createMultiplayerTeam'))
    if newTeam and next(newTeam) then
        CurrentMultiplayerData = newTeam
        return newTeam
    end

    Debug('error', 'Failed to retrieve multiplayer data for player')
    return {}
end

function InitEmployer()
    if not Config.Employer then return end

    if not HasModelLoaded(Config.Employer.hash) then
        lib.requestModel(Config.Employer.hash, 10000)
    end

    local employer = CreatePed(4, Config.Employer.hash, Config.Employer.coords.x, Config.Employer.coords.y, Config.Employer.coords.z, Config.Employer.coords.w, false, true)
    TaskStartScenarioInPlace(employer, Config.Employer.scenario, 0, true)
    SetEntityAsMissionEntity(employer, true, true)
    SetEntityInvincible(employer, true)
    SetBlockingOfNonTemporaryEvents(employer, true)
    FreezeEntityPosition(employer, true)

    local blip = AddBlipForCoord(Config.Employer.coords.x, Config.Employer.coords.y, Config.Employer.coords.z)
    SetBlipSprite(blip, Config.Employer.blip.sprite)
    SetBlipDisplay(blip, Config.Employer.blip.display)
    SetBlipScale(blip, Config.Employer.blip.scale)
    SetBlipColour(blip, Config.Employer.blip.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.Employer.blip.label)
    EndTextCommandSetBlipName(blip)

    return employer, blip
end

function InitEmployerTarget()
    if not EmployerPed then return end
    if not Target then return end

    Target.AddLocalEntity(EmployerPed, {
        {
            label = locale('employer.interaction_label'),
            name = 'employer_menu',
            icon = 'fa-solid fa-briefcase',
            action = function()
                local teamData = GetMultiplayerData()

                if not teamData or not next(teamData) then
                    Debug('error', 'No multiplayer data found for player')
                    return
                end

                NuiMessage('multiplayer/update-players', teamData.members)

                NuiMessage('nui/toggle', {
                    show = true,
                })
                SetNuiFocus(true, true)
            end,
            canInteract = function()
                return true
            end,
            distance = 2.5,
        }
    })
end

function InitEmployerPoint()
    if not EmployerPed then return end

    local point = lib.points.new({
        coords = GetEntityCoords(EmployerPed),
        distance = 2.5,
    })

    function point:onEnter()
        HelpText.ShowHelpText(Config.Interaction.label .. " " .. locale('employer.interaction_label'), 'left-center')
    end

    function point:onExit()
        HelpText.HideHelpText()
    end

    function point:nearby()
        if self.currentDistance < 2.5 and IsControlJustReleased(0, Config.Interaction.id) then
            local teamData = GetMultiplayerData()

            if not teamData or not next(teamData) then
                Debug('error', 'No multiplayer data found for player')
                return
            end

            NuiMessage('multiplayer/update-players', teamData.members)

            NuiMessage('nui/toggle', {
                show = true,
            })
            SetNuiFocus(true, true)
        end
    end
end