local spawnedPeds = {}
local blipHandles = {}
local restoranPoints = {}
local restoranData = {}

local function notify(msg, ntype)
    lib.notify({ title = 'Restoran', description = msg, type = ntype or 'inform', position = 'right-center' })
end

local function deletePed(id)
    local entry = spawnedPeds[id]
    if not entry then return end
    if entry.ped and DoesEntityExist(entry.ped) then
        exports.ox_target:removeLocalEntity(entry.ped, {
            'jamaica_restoran_shop_' .. id,
            'jamaica_restoran_stock_' .. id,
        })
        SetEntityAsMissionEntity(entry.ped, false, true)
        DeleteEntity(entry.ped)
    end
    spawnedPeds[id] = nil
end

local function deleteBlip(id)
    local blip = blipHandles[id]
    if blip and DoesBlipExist(blip) then RemoveBlip(blip) end
    blipHandles[id] = nil
end

local function removeRestoranPoint(id)
    local point = restoranPoints[id]
    if not point then return end
    deletePed(id)
    point:remove()
    restoranPoints[id] = nil
end

local function hasPedCoords(ped)
    if not ped then return false end
    local x, y = tonumber(ped.x), tonumber(ped.y)
    if not x or not y then return false end
    return math.abs(x) > 0.01 or math.abs(y) > 0.01
end

local function isBlipEnabled(b)
    if not b then return true end
    local v = b.enabled
    if v == nil then return true end
    if v == false or v == 0 or v == '0' or v == 'false' then return false end
    return true
end

local function normalizeRestoran(r, id)
    if not r then return nil end
    local ped = r.ped or {}
    local blip = r.blip or {}
    return {
        id = tonumber(r.id) or tonumber(id) or id,
        label = r.label or 'Restoran',
        job = r.job,
        ped = {
            model = ped.model or Config.DefaultPedModel,
            x = tonumber(ped.x) or 0,
            y = tonumber(ped.y) or 0,
            z = tonumber(ped.z) or 0,
            h = tonumber(ped.h) or 0,
        },
        craftHrana = (r.craftHrana or r.craft) and {
            x = tonumber((r.craftHrana or r.craft).x) or 0,
            y = tonumber((r.craftHrana or r.craft).y) or 0,
            z = tonumber((r.craftHrana or r.craft).z) or 0,
        } or nil,
        craftPice = r.craftPice and {
            x = tonumber(r.craftPice.x) or 0,
            y = tonumber(r.craftPice.y) or 0,
            z = tonumber(r.craftPice.z) or 0,
        } or nil,
        blip = {
            enabled = isBlipEnabled(blip),
            sprite = math.floor(tonumber(blip.sprite) or 93),
            color = math.floor(tonumber(blip.color) or 1),
            scale = tonumber(blip.scale) or 0.7,
            label = blip.label or r.label or 'Restoran',
        },
    }
end

local function spawnPed(id, r)
    if spawnedPeds[id] and spawnedPeds[id].ped and DoesEntityExist(spawnedPeds[id].ped) then return end
    deletePed(id)
    if not hasPedCoords(r.ped) then return end

    local modelName = r.ped.model or Config.DefaultPedModel
    local model = joaat(modelName)
    if not IsModelInCdimage(model) then
        model = joaat(Config.DefaultPedModel or 's_m_y_barman_01')
    end

    local p = r.ped
    RequestCollisionAtCoord(p.x, p.y, p.z)
    if not lib.requestModel(model, 10000) then return end

    local ped = CreatePed(4, model, p.x, p.y, p.z - 1.0, p.h or 0.0, false, true)
    SetModelAsNoLongerNeeded(model)
    if not DoesEntityExist(ped) then return end

    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetPedCanRagdoll(ped, false)
    SetEntityAsMissionEntity(ped, true, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'jamaica_restoran_shop_' .. id,
            icon = 'fa-solid fa-utensils',
            label = ('Kupi — %s'):format(r.label or 'restoran'),
            onSelect = function()
                OpenRestoranShop(id)
            end,
        },
        {
            name = 'jamaica_restoran_stock_' .. id,
            icon = 'fa-solid fa-boxes-stacked',
            label = 'Ubaci zalihe',
            distance = 2.5,
            canInteract = function()
                if not r.job then return false end
                local job = ESX.PlayerData and ESX.PlayerData.job
                return job and job.name == r.job
            end,
            onSelect = function()
                OpenRestoranStockMenu(id)
            end,
        },
    })

    spawnedPeds[id] = { ped = ped }
end

local function createBlip(id, r)
    deleteBlip(id)
    local b = r.blip
    if not b or not isBlipEnabled(b) or not hasPedCoords(r.ped) then return end

    local p = r.ped
    local x, y, z = tonumber(p.x), tonumber(p.y), tonumber(p.z)
    if not x or not y or not z then return end

    local blip = AddBlipForCoord(x, y, z)
    if not blip or not DoesBlipExist(blip) then return end

    local sprite = math.floor(tonumber(b.sprite) or 93)
    local color = math.floor(tonumber(b.color) or 1)
    local scale = tonumber(b.scale) or 0.7
    local label = b.label or r.label or 'Restoran'
    local entry = ('jamaica_restoran_blip_%s'):format(tostring(id))

    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale + 0.0)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, Config.BlipShortRange ~= false)
    AddTextEntry(entry, label)
    BeginTextCommandSetBlipName(entry)
    EndTextCommandSetBlipName(blip)
    blipHandles[id] = blip
end

local function setupRestoranPoint(id, r)
    removeRestoranPoint(id)
    if not hasPedCoords(r.ped) then return end

    local p = r.ped
    restoranPoints[id] = lib.points.new({
        coords = vec3(p.x, p.y, p.z),
        distance = Config.PedSpawnDistance or 50.0,
        restoranId = id,
        restoran = r,
        onEnter = function(self)
            CreateThread(function()
                for _ = 1, 6 do
                    if not self.inside then return end
                    RequestCollisionAtCoord(self.coords.x, self.coords.y, self.coords.z)
                    Wait(500)
                    if not self.inside then return end
                    spawnPed(self.restoranId, self.restoran)
                    local entry = spawnedPeds[self.restoranId]
                    if entry and entry.ped and DoesEntityExist(entry.ped) then return end
                end
            end)
        end,
        onExit = function(self)
            deletePed(self.restoranId)
        end,
    })
end

local function refreshWorld()
    local activeIds = {}

    for id, r in pairs(restoranData) do
        local numId = tonumber(id) or id
        activeIds[numId] = true
        activeIds[tostring(numId)] = true
        setupRestoranPoint(numId, r)
        createBlip(numId, r)
    end

    for id in pairs(restoranPoints) do
        if not activeIds[id] and not activeIds[tostring(id)] then
            removeRestoranPoint(id)
            deleteBlip(id)
        end
    end

    for id in pairs(blipHandles) do
        if not activeIds[id] and not activeIds[tostring(id)] then
            deleteBlip(id)
        end
    end

    RebuildRestoranCraftZones(restoranData)
end

local lastSyncVer = -1

local function applyState(state, version, force)
    if not force and version and version <= lastSyncVer then return end
    if version then lastSyncVer = version end

    local normalized = {}
    for id, r in pairs(state or {}) do
        local entry = normalizeRestoran(r, id)
        if entry then
            normalized[tostring(entry.id)] = entry
        end
    end
    restoranData = normalized
    refreshWorld()
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('jamaica-restoran:syncWorld', function(state, version)
    applyState(state, version, true)
end)

AddStateBagChangeHandler('JamaicaRestoraniVer', 'global', function(_, _, value)
    if type(value) ~= 'number' or value <= lastSyncVer then return end
    applyState(GlobalState.JamaicaRestorani, value)
end)

AddStateBagChangeHandler('JamaicaRestorani', 'global', function(_, _, value)
    local ver = GlobalState.JamaicaRestoraniVer
    applyState(value, type(ver) == 'number' and ver or nil)
end)

CreateThread(function()
    Wait(1500)
    local state, version = lib.callback.await('jamaica-restoran:getWorldState', false)
    if state then applyState(state, version) end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for id in pairs(restoranPoints) do removeRestoranPoint(id) end
    for id in pairs(blipHandles) do deleteBlip(id) end
    ClearRestoranCraftZones()
end)

RegisterNetEvent('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)
