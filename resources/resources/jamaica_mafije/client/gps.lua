-- Blipovi clanova organizacije (F6 ukljuci/iskljuci) — po mafiji: Config.Mafije[naziv].BlipIgraca = true
local showBlips = false
local blips = {}
local blipRequestBlocked = false
local gpsRefreshThread = nil

local function getPlayerJobName()
    local pData = ESX and ESX.GetPlayerData and ESX.GetPlayerData()
    return pData and pData.job and pData.job.name
end

function HasOrgBlipIgraca(jobName)
    if not jobName then jobName = getPlayerJobName() end
    if not jobName then return false end
    local org = Config.Mafije[jobName]
    return org ~= nil and org.BlipIgraca == true
end

-- Kompatibilnost sa starim pozivima
function CanUseGps()
    return HasOrgBlipIgraca()
end

function GpsDeniedNotify()
    if MafiaNotify then
        MafiaNotify('Vasa organizacija nema ukljucene blipove clanova (BlipIgraca = false u configu).', 'warning')
    else
        ESX.ShowNotification('Vasa organizacija nema ukljucene blipove clanova.')
    end
end

local function createMemberBlip(coords, name)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 1)
    SetBlipScale(blip, 0.85)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(name or 'Clan')
    EndTextCommandSetBlipName(blip)
    PulseBlip(blip)
    blips[#blips + 1] = blip
end

local function removeAllMemberBlips()
    for i = 1, #blips do
        if DoesBlipExist(blips[i]) then
            RemoveBlip(blips[i])
        end
    end
    blips = {}
end

local function stopGpsRefresh()
    showBlips = false
    removeAllMemberBlips()
    blipRequestBlocked = false
    gpsRefreshThread = nil
end

local function startGpsRefresh()
    if gpsRefreshThread then return end
    gpsRefreshThread = CreateThread(function()
        local interval = Config.OrgBlipClientRefreshMs or 3000
        while showBlips do
            TriggerServerEvent('jamaica_mafije:requestOrgBlips')
            Wait(interval)
        end
        gpsRefreshThread = nil
    end)
end

function flashBlips()
    if not HasOrgBlipIgraca() then
        GpsDeniedNotify()
        return
    end
    if blipRequestBlocked and showBlips then
        if MafiaNotify then
            MafiaNotify('Imate vec upaljene blipove na mapi, sacekajte dok se ucitaju', 'warning')
        end
        return
    end
    blipRequestBlocked = true
    showBlips = true
    startGpsRefresh()
    TriggerServerEvent('jamaica_mafije:requestOrgBlips')
    if MafiaNotify then
        MafiaNotify('Upalili ste blipove clanova organizacije!', 'success')
    end
end

function flashBlipsOff()
    if not showBlips then
        if MafiaNotify then
            MafiaNotify('Niste ni upalili blipove na mapi!', 'warning')
        end
        return
    end
    stopGpsRefresh()
    if MafiaNotify then
        MafiaNotify('Ugasili ste blipove clanova organizacije!', 'info')
    end
end

RegisterNetEvent('jamaica_mafije:syncOrgBlips')
AddEventHandler('jamaica_mafije:syncOrgBlips', function(blipsList)
    if not showBlips or not HasOrgBlipIgraca() then return end
    removeAllMemberBlips()
    if not blipsList then return end
    for i = 1, #blipsList do
        local entry = blipsList[i]
        if entry.coords then
            createMemberBlip(entry.coords, entry.name)
        end
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if not HasOrgBlipIgraca(job.name) then
        stopGpsRefresh()
    end
end)

-- Baza organizacije na mapi
local orgBaseBlip = nil

function createOrgBaseBlip()
    if orgBaseBlip then
        RemoveBlip(orgBaseBlip)
        orgBaseBlip = nil
    end
    local pData = ESX and ESX.GetPlayerData and ESX.GetPlayerData()
    if not pData or not pData.job or not Config.Mafije[pData.job.name] then return end

    local orgConfig = Config.Mafije[pData.job.name]
    local blipCoords = nil
    if orgConfig.Vehicles and orgConfig.Vehicles[1] then
        blipCoords = orgConfig.Vehicles[1]
    end

    if blipCoords then
        orgBaseBlip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z)
        SetBlipSprite(orgBaseBlip, 40)
        SetBlipDisplay(orgBaseBlip, 4)
        SetBlipScale(orgBaseBlip, 0.8)
        SetBlipColour(orgBaseBlip, 2)
        SetBlipAsShortRange(orgBaseBlip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(pData.job.label or pData.job.name)
        EndTextCommandSetBlipName(orgBaseBlip)
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        stopGpsRefresh()
        if orgBaseBlip then
            RemoveBlip(orgBaseBlip)
            orgBaseBlip = nil
        end
    end
end)
