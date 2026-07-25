return {
    Debug = false,
    AutoRunSQL = true,
    TextUI = "auto",
    Notify = "auto",
    ProgressBar = "auto",
    UseTarget = false,

    ServerLogoURL = "https://r2.fivemanage.com/ATZ00IXjgOwoZjH5kxuUl/0resmon-logo.png",
    DefaultProfilePhoto = "https://r2.fivemanage.com/ATZ00IXjgOwoZjH5kxuUl/0resmon-logo.png",

    Interaction = {
        label = "[E]",
        id = 38
    },

    MoneySetting = {
        accountName = "bank"
    },

    Employer = {
        hash = `s_m_m_dockwork_01`,
        scenario = "WORLD_HUMAN_CLIPBOARD",
        coords = vec4(1239.88, -3257.23, 6.1, 274.77),
        blip = {
            sprite = 478,
            display = 4,
            scale = 0.8,
            color = 5,
            label = "[Posao] Viljuškarista"
        }
    },

    JobClothes = {
        male = {
            { type = 'component', componentId = 3, item = 0, texture = 0 },
            { type = 'component', componentId = 4, item = 102, texture = 0 },
            { type = 'component', componentId = 6, item = 25, texture = 0 },
            { type = 'component', componentId = 11, item = 472, texture = 0 },
            { type = 'component', componentId = 8, item = 181, texture = 0 },
        },
        female = {
        }
    },

    Overtime = {
        enabled = false,
        min = 22,
        max = 06,
        rewardMultiplier = 1.5
    },

    Tasks = {
        {
            id = 1,
            image = "forklift-2.png",
            name = "Standardna smena",
            description = "Vozi viljuškar i premesti palete na odgovarajuća mesta.",
            setting = {
                minLevel = 0,
                maxPlayer = 2,
                palletsNumber = 20
            },
            rewards = {
                xp = 100,
                money = 3000,
                items = {
                    { name = "scrap_metal", amount = 2 },
                    { name = "celicni_ostaci", amount = 1 },
                    { name = "plastika", amount = 1 },
                }
            }
        },
        {
            id = 2,
            image = "forklift-1.png",
            name = "Teška smena",
            description = "Vozi viljuškar i premesti palete na odgovarajuća mesta.",
            setting = {
                minLevel = 0,
                maxPlayer = 2,
                palletsNumber = 40
            },
            rewards = {
                xp = 100,
                money = 5500,
                items = {
                    { name = "scrap_metal", amount = 4 },
                    { name = "celicni_ostaci", amount = 3 },
                    { name = "srafovi", amount = 2 },
                    { name = "guma", amount = 1 },
                }
            }
        },
    }
}