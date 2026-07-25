local active = false
local fov = 40.0
local cam
local prop
local scaleformBin
local scaleformKeys
local showKeys = true

local ANIM_DICT = 'amb@world_human_binoculars@male@idle_a'
local PROP_MODEL = `prop_binoc_01`
local BONE_INDEX = 28422

local KEY_EXIT = 177
local KEY_HELP = 47

local FOV_MAX = 70.0
local FOV_MIN = 10.0
local ZOOM_SPEED = 10.0
local PAN_LR = 8.0
local PAN_UD = 8.0

local function notify(msg, ntype)
    lib.notify({ description = msg, type = ntype or 'error' })
end

local function hideHud()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    for _, id in ipairs({ 1, 2, 3, 4, 11, 12, 13, 15, 18, 19 }) do
        HideHudComponentThisFrame(id)
    end
end

local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) do
        if GetGameTimer() > timeout then return false end
        Wait(10)
    end
    return true
end

local function loadModel(model)
    if HasModelLoaded(model) then return true end
    RequestModel(model)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) do
        if GetGameTimer() > timeout then return false end
        Wait(10)
    end
    return true
end

local function loadScaleform(name)
    local sf = RequestScaleformMovie(name)
    local timeout = GetGameTimer() + 5000
    while not HasScaleformMovieLoaded(sf) do
        if GetGameTimer() > timeout then return nil end
        Wait(10)
    end
    return sf
end

local function buildKeyHints()
    local sf = loadScaleform('instructional_buttons')
    if not sf then return nil end

    local keys = {
        { key = KEY_EXIT, text = 'Izađi iz dvogleda' },
        { key = KEY_HELP, text = 'Prikaži/sakrij pomoć' },
    }

    PushScaleformMovieFunction(sf, 'CLEAR_ALL')
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(sf, 'SET_CLEAR_SPACE')
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    for i, btn in ipairs(keys) do
        PushScaleformMovieFunction(sf, 'SET_DATA_SLOT')
        PushScaleformMovieFunctionParameterInt(i - 1)
        ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, btn.key, true))
        BeginTextCommandScaleformString('STRING')
        AddTextComponentScaleform(btn.text)
        EndTextCommandScaleformString()
        PopScaleformMovieFunctionVoid()
    end

    PushScaleformMovieFunction(sf, 'DRAW_INSTRUCTIONAL_BUTTONS')
    PopScaleformMovieFunctionVoid()
    return sf
end

local function handleZoomAndRotation()
    local zoomValue = (1.0 / (FOV_MAX - FOV_MIN)) * (fov - FOV_MIN)
    local axisX = GetDisabledControlNormal(0, 220)
    local axisY = GetDisabledControlNormal(0, 221)
    local rot = GetCamRot(cam, 2)

    if axisX ~= 0.0 or axisY ~= 0.0 then
        local newZ = rot.z + axisX * -PAN_UD * (zoomValue + 0.1)
        local newX = math.max(math.min(20.0, rot.x + axisY * -PAN_LR * (zoomValue + 0.1)), -29.5)
        SetCamRot(cam, newX, 0.0, newZ, 2)
    end

    if IsControlJustPressed(0, 241) then
        fov = math.max(fov - ZOOM_SPEED, FOV_MIN)
    elseif IsControlJustPressed(0, 242) then
        fov = math.min(fov + ZOOM_SPEED, FOV_MAX)
    end

    local currentFov = GetCamFov(cam)
    if math.abs(fov - currentFov) >= 0.1 then
        SetCamFov(cam, currentFov + (fov - currentFov) * 0.05)
    else
        fov = currentFov
    end
end

local function cleanup()
    active = false
    showKeys = true
    fov = 40.0

    local ped = PlayerPedId()
    ClearPedTasks(ped)
    ClearTimecycleModifier()
    RenderScriptCams(false, false, 0, true, false)

    if cam then
        DestroyCam(cam, false)
        cam = nil
    end

    if prop and DoesEntityExist(prop) then
        DeleteEntity(prop)
        prop = nil
    end

    if scaleformBin then
        SetScaleformMovieAsNoLongerNeeded(scaleformBin)
        scaleformBin = nil
    end

    if scaleformKeys then
        SetScaleformMovieAsNoLongerNeeded(scaleformKeys)
        scaleformKeys = nil
    end

    if HasAnimDictLoaded(ANIM_DICT) then
        RemoveAnimDict(ANIM_DICT)
    end

    SetModelAsNoLongerNeeded(PROP_MODEL)
end

local function canUse()
    local ped = PlayerPedId()
    if active then return false, 'Već koristiš dvogled.' end
    if IsEntityDead(ped) then return false, 'Ne možeš koristiti dvogled u ovom stanju.' end
    if IsPedSittingInAnyVehicle(ped) then return false, 'Ne možeš koristiti dvogled iz vozila.' end
    return true
end

local function attachProp(ped)
    if not loadModel(PROP_MODEL) then return false end
    local coords = GetEntityCoords(ped, true)
    prop = CreateObject(PROP_MODEL, coords.x, coords.y, coords.z + 0.2, true, true, true)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, BONE_INDEX), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    return true
end

local function startBinoculars()
    local ped = PlayerPedId()

    if not loadAnimDict(ANIM_DICT) then
        notify('Animacija nije učitana.', 'error')
        return
    end

    if not attachProp(ped) then
        notify('Dvogled nije mogao da se prikaže.', 'error')
        RemoveAnimDict(ANIM_DICT)
        return
    end

    TaskPlayAnim(ped, ANIM_DICT, 'idle_c', 5.0, 5.0, -1, 51, 0, false, false, false)
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)

    scaleformBin = loadScaleform('BINOCULARS')
    scaleformKeys = buildKeyHints()
    if not scaleformBin then
        cleanup()
        notify('Dvogled nije mogao da se pokrene.', 'error')
        return
    end

    SetTimecycleModifier('default')
    SetTimecycleModifierStrength(0.3)

    cam = CreateCam('DEFAULT_SCRIPTED_FLY_CAMERA', true)
    AttachCamToEntity(cam, ped, 0.0, 0.0, 1.2, true)
    SetCamRot(cam, 0.0, 0.0, GetEntityHeading(ped))
    SetCamFov(cam, fov)
    RenderScriptCams(true, false, 0, true, false)

    PushScaleformMovieFunction(scaleformBin, 'SET_CAM_LOGO')
    PushScaleformMovieFunctionParameterInt(0)
    PopScaleformMovieFunctionVoid()

    active = true

    CreateThread(function()
        while active do
            ped = PlayerPedId()

            if IsEntityDead(ped) or IsPedSittingInAnyVehicle(ped) then
                break
            end

            if IsControlJustPressed(0, KEY_EXIT) then
                PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
                break
            end

            if IsControlJustPressed(0, KEY_HELP) then
                showKeys = not showKeys
                PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
            end

            handleZoomAndRotation()
            hideHud()

            DisableControlAction(0, 25, true)
            DisableControlAction(0, 44, true)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 24, true)
            DisablePlayerFiring(ped, true)

            DrawScaleformMovieFullscreen(scaleformBin, 255, 255, 255, 255)
            if showKeys and scaleformKeys then
                DrawScaleformMovieFullscreen(scaleformKeys, 255, 255, 255, 255)
            end

            Wait(0)
        end

        cleanup()
    end)
end

exports('koristiDvogled', function()
    local ok, msg = canUse()
    if not ok then
        notify(msg, 'error')
        return false
    end

    startBinoculars()
    return true
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    cleanup()
end)
