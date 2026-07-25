local _E = Bridge.E
local _S = nil
local _B, _K, _P, _F, _L, _targetAdded = nil, nil, nil, false, false, false
local _X = nil
local _lootZone = nil
local _dst, _cap

local function _lm(m)
    if not m or not IsModelValid(m) then return false end
    if HasModelLoaded(m) then return true end
    RequestModel(m)
    local t = GetGameTimer() + 5000
    while not HasModelLoaded(m) do
        if GetGameTimer() > t then return false end
        Wait(50)
    end
    return true
end

local function _de(e)
    if e and DoesEntityExist(e) then DeleteEntity(e) end
end

local function _cp()
    if _X then StopParticleFxLooped(_X, false) _X = nil end
end

local function _cb()
    if _B and DoesBlipExist(_B) then RemoveBlip(_B) end
    _B = nil
end

local function _rt()
    if _targetAdded and _K and DoesEntityExist(_K) then
        exports.ox_target:removeLocalEntity(_K, 'jamaica_drop_capture')
    end
    _targetAdded = false
end

local function _rLoot()
    if _lootZone then
        exports.ox_target:removeZone(_lootZone)
        _lootZone = nil
    end
end

local function _sLoot(c, dropId)
    _rLoot()
    if not c or not dropId then return end
    _lootZone = exports.ox_target:addBoxZone({
        name = 'jamaica_drop_loot',
        coords = vec3(c.x, c.y, c.z),
        size = vec3(2.8, 2.8, 2.5),
        rotation = 0,
        options = {
            {
                name = 'jamaica_drop_loot_open',
                icon = 'fas fa-box-open',
                label = 'Otvori Supply Drop',
                distance = 3.0,
                onSelect = function()
                    exports.ox_inventory:openInventory('drop', dropId)
                end,
            },
        },
    })
end

local function _nearDrop()
    if not _S or _S.claimed or _S.phase ~= 'landed' or _L then return false end
    return _dst() <= (ClientConfig.InteractRadius or 2.8)
end

local function _at()
    if _targetAdded or not _K or not DoesEntityExist(_K) then return end
    if not _S or _S.claimed or _S.phase ~= 'landed' or _L then return end
    _targetAdded = true
    exports.ox_target:addLocalEntity(_K, {
        {
            name = 'jamaica_drop_capture',
            icon = 'fas fa-parachute-box',
            label = 'Preuzmi Supply Drop',
            distance = ClientConfig.InteractRadius or 2.8,
            canInteract = function()
                return _nearDrop()
            end,
            onSelect = function()
                _cap()
            end,
        },
    })
end

local function _waitAt(n)
    if _targetAdded or not _K or not DoesEntityExist(_K) then return end
    if _S and _S.phase == 'landed' and not _S.claimed then
        _at()
        return
    end
    if (n or 0) < 40 then
        SetTimeout(500, function()
            _waitAt((n or 0) + 1)
        end)
    end
end

local function _cw()
    _rt()
    _de(_K) _de(_P) _K, _P = nil, nil _cp()
end

local function _fc()
    _F, _L = false, false
    _S = nil
    _cb()
    _rLoot()
    _cw()
end

local function _ps()
    CreateThread(function()
        PlaySoundFrontend(-1, 'CHECKPOINT_PERFECT', 'HUD_MINI_GAME_SOUNDSET', true)
        Wait(120)
        PlaySoundFrontend(-1, 'CHECKPOINT_NORMAL', 'HUD_MINI_GAME_SOUNDSET', true)
    end)
end

local function _sm(c)
    _cp()
    RequestNamedPtfxAsset('core')
    local t = GetGameTimer() + 5000
    while not HasNamedPtfxAssetLoaded('core') do
        if GetGameTimer() > t then return end
        Wait(50)
    end
    UseParticleFxAssetNextCall('core')
    _X = StartParticleFxLoopedAtCoord('exp_grd_flare', c.x, c.y, c.z + 0.35, 0.0, 0.0, 0.0, 1.2, false, false, false, false)
end

local function _bl(c, tl)
    _cb()
    _B = AddBlipForCoord(c.x, c.y, c.z)
    SetBlipSprite(_B, ClientConfig.BlipSprite or 94)
    SetBlipColour(_B, ClientConfig.BlipColor or 1)
    SetBlipScale(_B, ClientConfig.BlipScale or 1.15)
    SetBlipAsShortRange(_B, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(('Supply Drop [%s]'):format(tl or 'Drop'))
    EndTextCommandSetBlipName(_B)
    SetBlipFlashes(_B, true)
end

local function _ap(c, p)
    if not c or not p then return end
    AttachEntityToEntity(p, c, 0, 0.0, 0.0, 3.85, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
end

local function _sg(c)
    _cw()
    if not _lm(ClientConfig.CrateModel) then return end
    _K = CreateObject(ClientConfig.CrateModel, c.x, c.y, c.z - 1.0, false, false, false)
    SetEntityHeading(_K, math.random(0, 359) + 0.0)
    PlaceObjectOnGroundProperly(_K)
    FreezeEntityPosition(_K, true)
    SetEntityInvincible(_K, true)
    _sm(c)
    _waitAt(0)
end

local function _rf(c)
    if _F then return end
    _F = true
    local cm, pm = ClientConfig.CrateModel, ClientConfig.ParachuteModel
    if not _lm(cm) or not _lm(pm) then _sg(c) _F = false return end
    local sz = c.z + (ClientConfig.FallHeight or 280.0)
    _K = CreateObject(cm, c.x, c.y, sz, false, false, false)
    _P = CreateObject(pm, c.x, c.y, sz + 3.85, false, false, false)
    SetEntityInvincible(_K, true)
    SetEntityInvincible(_P, true)
    _ap(_K, _P)
    local dur = math.max(1000, ClientConfig.FallDurationMs or 14000)
    local st = GetGameTimer()
    CreateThread(function()
        while _F and _K and DoesEntityExist(_K) do
            local el = GetGameTimer() - st
            local pr = math.min(1.0, el / dur)
            local ez = 1.0 - ((1.0 - pr) * (1.0 - pr))
            local z = sz - ((sz - c.z) * ez)
            SetEntityCoords(_K, c.x, c.y, z, false, false, false, false)
            if pr >= 1.0 then break end
            Wait(0)
        end
        _F = false
        _de(_P) _P = nil
        if _K and DoesEntityExist(_K) then
            SetEntityCoords(_K, c.x, c.y, c.z - 1.0, false, false, false, false)
            PlaceObjectOnGroundProperly(_K)
            FreezeEntityPosition(_K, true)
            _sm(c)
            _waitAt(0)
            PlaySoundFrontend(-1, 'CHECKPOINT_UNDER_THE_BRIDGE', 'HUD_MINI_GAME_SOUNDSET', true)
        end
    end)
end

function _dst()
    if not _S then return 99999.0 end
    return #(GetEntityCoords(cache.ped) - _S.coords)
end

function _cap()
    if _L or not _nearDrop() then return end
    local ok, err = lib.callback.await(_E.reqCap, false)
    if not ok then
        if err then lib.notify({ description = err, type = 'error' }) end
        return
    end
    _L = true
    local done = lib.progressBar({
        duration = ClientConfig.CaptureDurationMs or 30000,
        label = 'Osiguravate supply drop...',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true, mouse = false },
        anim = { dict = 'anim@gangops@facility@servers@bodysearch@', clip = 'player_search', flag = 49 },
    })
    if not done or IsEntityDead(cache.ped) then
        TriggerServerEvent(_E.abort, IsEntityDead(cache.ped) and 'dead' or 'cancelled')
        _L = false
        return
    end
    if _dst() > (ClientConfig.CaptureRadius or 8.0) then
        TriggerServerEvent(_E.abort, 'too_far')
        lib.notify({ description = 'Odlazili ste predaleko — capture prekinut.', type = 'error' })
        _L = false
        return
    end
    local suc, msg = lib.callback.await(_E.cmpCap, false)
    _L = false
    if suc then
        lib.notify({ description = 'Supply drop osiguran! Uzmite loot iz sanduka.', type = 'success' })
    elseif msg then
        lib.notify({ description = msg, type = 'error' })
    end
end

RegisterNetEvent(_E.sync, function(d)
    if not d then _fc() return end
    local nw = not _S or _S.token ~= d.token
    _S = d
    if d.claimed then
        _cb()
        _rt()
        _de(_P)
        _de(_K)
        _K, _P = nil, nil
        _cp()
        if d.dropId then
            _sLoot(d.coords, d.dropId)
        end
        return
    end
    if nw then
        _ps()
        _bl(d.coords, d.tierLabel)
        if d.phase == 'falling' then _rf(d.coords) else _sg(d.coords) end
    elseif d.phase == 'landed' and not _K then
        _sg(d.coords)
    elseif d.phase == 'landed' and _K and not _targetAdded then
        _at()
    end
end)

RegisterNetEvent(_E.clear, function()
    _fc()
end)

RegisterNetEvent(_E.capStart, function(src, pn, ol)
    if src == cache.serverId then return end
    if _dst() <= (ClientConfig.EffectsDrawDistance or 450.0) then
        lib.notify({ description = ('%s (%s) preuzima supply drop!'):format(pn, ol), type = 'warning', duration = 7000 })
    end
end)

RegisterNetEvent(_E.capCancel, function(rs)
    if not _L then return end
    _L = false
    lib.cancelProgress()
    local msg = 'Capture prekinut.'
    if rs == 'contested' then msg = 'Neko drugi je preuzeo capture!'
    elseif rs == 'dead' then msg = 'Umrla si — capture prekinut.' end
    lib.notify({ description = msg, type = 'error' })
end)

CreateThread(function()
    local cfg = lib.callback.await(_E.getCfg, false)
    if cfg then
        if cfg.captureRadius then ClientConfig.CaptureRadius = cfg.captureRadius end
        if cfg.interactRadius then ClientConfig.InteractRadius = cfg.interactRadius end
        if cfg.captureDurationMs then ClientConfig.CaptureDurationMs = cfg.captureDurationMs end
        if cfg.fallDurationMs then ClientConfig.FallDurationMs = cfg.fallDurationMs end
    end
end)

AddEventHandler('onResourceStop', function(rn)
    if rn ~= GetCurrentResourceName() then return end
    _fc()
end)

AddEventHandler('onClientResourceStart', function(rn)
    if rn ~= GetCurrentResourceName() then return end
    TriggerEvent('chat:addSuggestion', '/forcedrop', 'Pokreni supply drop odmah (staff)')
    TriggerEvent('chat:addSuggestion', '/canceldrop', 'Otkazi aktivni supply drop (staff)')
    TriggerEvent('chat:addSuggestion', '/dropinfo', 'Info o aktivnom supply dropu (staff)')
end)
