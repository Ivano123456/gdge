ESX = exports['es_extended']:getSharedObject()

local pedDisplaying = {}
local displayTime = 8000
local displayRadius = 25.0
local renderActive = false
local htmlCache = ''

local HEAD_BONE = 0x2e28

local STYLE_BASE = 'text-shadow:1px 0 5px #000,-1px 0 0 #000,0 -1px 0 #000,0 1px 5px #000;-webkit-transform:translate(-50%,0);max-width:100%;position:fixed;text-align:center;color:#fff;background:rgba(18,18,18,.5);border-radius:3px;font-family:Segoe UI,system-ui,sans-serif;font-size:20px;'

local function escapeHtml(text)
    return text:gsub('&', '&amp;'):gsub('<', '&lt;'):gsub('>', '&gt;'):gsub('"', '&quot;')
end

local function buildLabel(x, y, msg, typ)
    local colorStyle = typ == 'do' and 'opacity:1;color:rgba(0,255,251,1)' or 'opacity:1'
    return ('<p style="left:%.2f%%;top:%.2f%%;%s"><b style="%s">⠀%s⠀</b></p>'):format(
        x * 100, y * 100, STYLE_BASE, colorStyle, escapeHtml(msg)
    )
end

local function buildHtml(myPlayer, myCoords, now)
    local parts = {}
    local count = 0

    for playerId, data in pairs(pedDisplaying) do
        if data.time <= now then
            pedDisplaying[playerId] = nil
        else
            local player = GetPlayerFromServerId(playerId)
            if player ~= -1 and NetworkIsPlayerActive(player) then
                local sourcePed = GetPlayerPed(player)
                if player == myPlayer or #(GetEntityCoords(sourcePed) - myCoords) < displayRadius then
                    local pedCoords = GetPedBoneCoords(sourcePed, HEAD_BONE, 0.0, 0.0, 0.0)
                    local offsetZ = data.type == 'do' and 1.1 or 0.35
                    local onScreen, x, y = GetHudScreenPositionFromWorldPosition(pedCoords.x, pedCoords.y, pedCoords.z + offsetZ)
                    if not onScreen then
                        count = count + 1
                        parts[count] = buildLabel(x, y, data.msg, data.type)
                    end
                end
            end
        end
    end

    return count > 0 and table.concat(parts) or ''
end

local function pushHtml(html)
    if html == htmlCache then return end
    htmlCache = html
    SendNUIMessage({ type = 'txt', html = html })
end

local function startRenderLoop()
    if renderActive then return end
    renderActive = true

    CreateThread(function()
        while next(pedDisplaying) do
            local myPlayer = PlayerId()
            local myCoords = GetEntityCoords(PlayerPedId())
            local now = GetGameTimer()

            pushHtml(buildHtml(myPlayer, myCoords, now))
            Wait(0)
        end

        pushHtml('')
        renderActive = false
    end)
end

RegisterNetEvent('bb-3dme:client:triggerDisplay', function(playerId, message, typ)
    if IsPedDeadOrDying(PlayerPedId(), true) then
        ESX.ShowNotification('Ne mozete pisati, mrtvi ste!')
        return
    end

    pedDisplaying[tonumber(playerId)] = {
        type = typ,
        msg = message,
        time = GetGameTimer() + displayTime,
    }

    startRenderLoop()
end)
