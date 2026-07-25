local stocic = {}
local trosenje = 10
local kutija
local zapalio = false
local kutijaZapaljena = false

local function ukloniTarget()
    exports.qtarget:RemoveZone('zona-vatromet-kutija')
end

local function ocistiVatromet()
    ukloniTarget()
    for i = 1, #stocic do
        if DoesEntityExist(stocic[i]) then
            DeleteObject(stocic[i])
        end
    end
    stocic = {}
    kutija = nil
    kutijaZapaljena = false
    zapalio = false
    trosenje = 10
end

AddEventHandler('onResourceStop', function(res)
    if GetCurrentResourceName() ~= res then return end
    ocistiVatromet()
end)

local function animacija(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(100)
        end
    end
    return animDict
end

pocniVatromet = function()
    if not DoesEntityExist(kutija) then
        local hash = GetHashKey('v_ind_cs_toolbox3')
        RequestModel(hash)
        while not HasModelLoaded(hash) do Wait(0) end
        local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 1.0)
        lib.notify({ description = 'Postavljate kutiju sa vatrometom', type = 'inform' })
        animacija('amb@medic@standing@kneel@base')
        animacija('anim@gangops@facility@servers@bodysearch@')
        TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@kneel@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
        TaskPlayAnim(PlayerPedId(), 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0, false, false, false)
        Wait(5000)
        ClearPedTasks(PlayerPedId())
        kutija = CreateObject(hash, vector3(pos.x, pos.y, pos.z), true, false)
        PlaceObjectOnGroundProperly(kutija)
        table.insert(stocic, kutija)
        TriggerServerEvent('jamaica-vatromet:oduzmiItem')
        Wait(50)
    end

    local coords = GetEntityCoords(kutija)
    exports.qtarget:AddBoxZone('zona-vatromet-kutija', vector3(coords.x, coords.y, coords.z - 1), 0.45, 0.35, {
        name = 'zona-vatromet-kutija',
        heading = 11.0,
        debugPoly = false,
        minZ = coords.z - 1,
        maxZ = coords.z + 2,
    }, {
        options = {
            {
                action = function()
                    if kutijaZapaljena then return end
                    if exports.ox_inventory:Search('count', 'upaljac') >= 1 then
                        lib.callback('jamaica-vatromet:proveriPaljenje', false, function(moze)
                            if moze then
                                kutijaZapaljena = true
                                ukloniTarget()
                                lib.notify({ description = 'Zapalili ste vatromet!', type = 'success' })
                                TriggerServerEvent('jamaica-vatromet:zoviKlijent', coords.x, coords.y, coords.z)
                            end
                        end)
                    else
                        lib.notify({ description = 'Nemate upaljač!', type = 'error' })
                    end
                end,
                label = 'Zapali vatromet',
            },
        },
        distance = 3.5,
    })
end

RegisterNetEvent('jamaica-vatromet:startujSync', function(posx, posy, posz, bool, whoLit)
    if bool ~= 'a' then return end

    local isOwner = whoLit == GetPlayerServerId(PlayerId())
    local pos_2 = vector3(posx, posy, posz)
    local delay = 800
    local asset1 = 'proj_indep_firework'
    RequestNamedPtfxAsset(asset1)
    while not HasNamedPtfxAssetLoaded(asset1) do
        Wait(1)
    end
    local asset2 = 'proj_indep_firework_v2'
    RequestNamedPtfxAsset(asset2)
    while not HasNamedPtfxAssetLoaded(asset2) do
        Wait(1)
    end
    local asset3 = 'scr_indep_fireworks'
    RequestNamedPtfxAsset(asset3)
    while not HasNamedPtfxAssetLoaded(asset3) do
        Wait(1)
    end

    if isOwner then
        zapalio = true
    end

    local remaining = isOwner and trosenje or 10
    while remaining > 0 do
        Wait(delay)
        UseParticleFxAssetNextCall(asset1)
        StartParticleFxNonLoopedAtCoord('scr_indep_firework_air_burst', pos_2[1] + math.random(-100, 100), pos_2[2] + math.random(-100, 100), pos_2[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false, false)

        Wait(delay)
        UseParticleFxAssetNextCall(asset2)
        StartParticleFxNonLoopedAtCoord('scr_firework_indep_spiral_burst_rwb', pos_2[1] + math.random(-200, 200), pos_2[2] + math.random(-200, 200), pos_2[3] + 25 + math.random(100, 200), 0.0, 0.0, 0.0, 5.0, false, false, false, false)

        Wait(delay)
        UseParticleFxAssetNextCall(asset2)
        StartParticleFxNonLoopedAtCoord('scr_firework_indep_repeat_burst_rwb', pos_2[1] + math.random(-100, 100), pos_2[2] + math.random(-100, 100), pos_2[3] + 25 + math.random(100, 200), 0.0, 0.0, 0.0, 5.0, false, false, false, false)

        Wait(delay)
        UseParticleFxAssetNextCall(asset3)
        StartParticleFxNonLoopedAtCoord('scr_indep_firework_starburst', pos_2[1] + math.random(-100, 100), pos_2[2] + math.random(-100, 100), pos_2[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false, false)

        Wait(delay)
        UseParticleFxAssetNextCall(asset3)
        StartParticleFxNonLoopedAtCoord('scr_indep_firework_shotburst', pos_2[1] + math.random(-100, 100), pos_2[2] + math.random(-100, 100), pos_2[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 5.0, false, false, false, false)

        Wait(delay)
        UseParticleFxAssetNextCall(asset3)
        StartParticleFxNonLoopedAtCoord('scr_indep_firework_fountain', pos_2[1], pos_2[2], pos_2[3], 0.0, 0.0, 0.0, 5.0, false, false, false, false)
        remaining = remaining - 1
        if isOwner then
            trosenje = remaining
        end
    end
end)

CreateThread(function()
    while true do
        if trosenje < 1 and zapalio then
            ocistiVatromet()
            lib.notify({ description = 'Vatromet se istrošio!', type = 'warning' })
        end
        Wait(500)
    end
end)
