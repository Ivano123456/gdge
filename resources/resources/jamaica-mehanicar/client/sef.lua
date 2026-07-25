local ESX = exports.es_extended:getSharedObject()

local sefProps = {}

local function getJob()
    return ESX.GetPlayerData().job
end

local function canAccessSef(cfg)
    local job = getJob()
    if not job or not Config.IsMechanicJob(job.name) then
        return false
    end
    local minGrade = (cfg and cfg.minGrade) or 0
    return (job.grade or 0) >= minGrade
end

function OpenMehanicarSef(cfg)
    if not cfg then return end

    if not canAccessSef(cfg) then
        lib.notify({
            title = 'Auto Umro',
            description = 'Nemate pristup sefu radnje.',
            type = 'error',
        })
        return
    end

    local input = lib.inputDialog(cfg.label or 'Sef', {
        {
            type = 'input',
            label = 'Lozinka',
            icon = 'fa-solid fa-unlock-keyhole',
            required = true,
            password = true,
        },
    })
    if not input or not input[1] then return end

    if input[1] ~= cfg.sifra then
        lib.notify({
            title = 'Auto Umro',
            description = 'Lozinka nije tacna!',
            type = 'error',
        })
        return
    end

    local job = getJob()
    local stashId = cfg.stashId or (job and job.name)
    exports.ox_inventory:openInventory('stash', stashId)
    lib.notify({
        title = 'Auto Umro',
        description = 'Lozinka je tacna, dobili ste pristup!',
        type = 'success',
    })
end

local function kreirajObjekat(data)
    if not data then return end

    local modelHash = type(data.model) == 'string' and GetHashKey(data.model) or data.model
    lib.requestModel(data.model)

    local c = data.coords
    local obj_prop = CreateObject(modelHash, vector3(c.x, c.y, c.z - 1), false, true)
    SetEntityHeading(obj_prop, c.w)
    FreezeEntityPosition(obj_prop, true)
    SetEntityInvincible(obj_prop, true)
    SetModelAsNoLongerNeeded(modelHash)

    sefProps[#sefProps + 1] = obj_prop
    return obj_prop
end

function CleanupMehanicarSefProp()
    for i = 1, #sefProps do
        local entity = sefProps[i]
        if entity and DoesEntityExist(entity) then
            DeleteObject(entity)
        end
    end
    sefProps = {}
end

CreateThread(function()
    local list = Config.Sefovi
    if not list then return end

    for i = 1, #list do
        local cfg = list[i]
        if cfg and cfg.coords and cfg.model then
            local sef = kreirajObjekat(cfg)
            exports.ox_target:addLocalEntity(sef, {
                {
                    name = ('jamaica_mehanicar_sef_%s'):format(i),
                    icon = 'fas fa-vault',
                    label = 'Otvori sef',
                    distance = 2.0,
                    canInteract = function()
                        return canAccessSef(cfg)
                    end,
                    onSelect = function()
                        OpenMehanicarSef(cfg)
                    end,
                },
            })
        end
    end
end)
