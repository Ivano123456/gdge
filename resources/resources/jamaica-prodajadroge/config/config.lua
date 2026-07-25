Config = {}

Config.TargetDistance = 4.0

Config.MoneyAccount = 'black_money'

Config.RejectChance = 30

Config.SellDuration = 5000
Config.AnimDict = 'mp_common'
Config.AnimClip = 'givetake1_a'

Config.Dispatch = {
    title = 'Prodaja droge',
    description = 'Prijavljen sumnjiv susret — moguca prodaja narkotika',
    jobs = { 'police', 'fib', 'doa', 'kgb', 'saj' },
    code = '10-35',
    blipTime = 2,
    blip = {
        sprite = 514,
        scale = 1.0,
        color = 1,
        text = 'Prodaja droge',
    },
}

Config.BlockedJobs = {
    ['police']   = true,
    ['fib']      = true,
    ['kgb']      = true,
    ['saj']      = true,
}

Config.BlacklistZones = {
    -- {
    --     name = 'Primer',
    --     coords = vector3(441.0, -981.0, 30.0),
    --     radius = 80.0,
    -- },
}

Config.Drugs = {
    cocaine = {
        item = 'cocaine',
        label = 'Kokain',
        icon = 'fas fa-snowflake',
        minAmount = 1,
        maxAmount = 3,
        priceMin = 800,
        priceMax = 1200,
    },
    joint = {
        item = 'joint',
        label = 'Joint',
        icon = 'fas fa-cannabis',
        minAmount = 1,
        maxAmount = 5,
        priceMin = 200,
        priceMax = 400,
    },
    meth = {
        item = 'meth',
        label = 'Meth',
        icon = 'fas fa-flask',
        minAmount = 1,
        maxAmount = 2,
        priceMin = 360,
        priceMax = 540,
    },
}

Config.Lang = {
    target_label = 'Prodaj drogu',
    menu_title = 'Prodaja droge',
    no_drugs = 'Nemate tu drogu kod sebe',
    job_blocked = 'Vas posao vam ne dopusta prodaju droge',
    blacklisted = 'Ovde ne mozete prodavati drogu',
    ped_busy = 'Ovom prolazniku ste vec prodavali drogu',
    rejected = 'Prolaznik vas je odbio i pozvao policiju!',
    sold = 'Prodali ste %dx %s za $%d prljavih',
    no_ped = 'Nema validnog prolaznika',
    cancelled = 'Prekinuli ste prodaju',
}

function Lang(key)
    return Config.Lang[key] or key
end

function Notify(msg, typ)
    lib.notify({
        title = 'Prodaja droge',
        description = msg,
        type = typ or 'inform',
        position = 'top',
    })
end
