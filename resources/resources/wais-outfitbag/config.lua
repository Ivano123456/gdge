Config = {}
Config.Framework = {
    ["Framework"] = "esx", -- auto, esx, qbcore or qbox
    ["ResourceName"] = "es_extended", -- auto, es_extended or qb-core or your resource name. If you using qbx you should write qb-core
    ["SharedEvent"] = "" -- Event name for old cores.
}

Config.Language = "en" -- ar, cz, ro, it, fr, de, tr
Config.ShowDebug = false -- Show debug messages
Config.PreviewPed = true -- When you hover over an outfit, it creates a copy of your character and displays it on your screen wearing that outfit.
Config.CanSaveSkin = false -- The status of the outfit being worn. If the player uses /reloadskin or logs out and back in, they will regain the outfits they were wearing from their bag.

Config.Inventory = {
    ["item"] = "outfit_bag",
    -- [[ 🟢 Inventory detections, to work automatically compatible with some inventories. 🟢 ]]
    ["qs"] = GetResourceState("qs-inventory"):find("start") and true or false,
    ["qb"] = GetResourceState("qb-inventory"):find("start") and true or false,
    ["ps"] = GetResourceState("ps-inventory"):find("start") and true or false,
    ["ox"] = GetResourceState("ox_inventory"):find("start") and true or false,
    ["codem"] = GetResourceState("codem-inventory"):find("start") and true or false,
    ["jaksam"] = GetResourceState("jaksam_inventory"):find("start") and true or false,
}

Config.Bag = {
    ["prop"] = "reh_prop_reh_bag_outfit_01a", -- This is a prop model to be placed on the floor when using a garment bag. You can find models like this on this page: https://forge.plebmasters.de/objects
    ["distance"] = 5.0, -- The maximum distance the user can be from the bag. If the user is farther than this value, the bag will automatically disappear from the screen.
    ["remove_distance"] = 7.0, -- The maximum distance the person placing the item on the ground can move away from the bag. If this distance is exceeded, the bag will be automatically deleted.
    ["max_outfits"] = 10, -- Maximum number of clothes that can be registered in the clothing bag. I recommend setting the maximum value to 10. With numbers like 20 or 25, the payload size in one clothing bag will increase slightly, so a statebag-related timeout situation may occur.
    ["drawable"] = {
        -- If the clothing bag is on the player, it defines a bag outfit for the user. The bag appears on their back.
        --[[
            ⚠️⚠️⚠️
            If the player has a bag behind them, the clothing bag will not be visible. The player's bag will not change.
            Because the player has a bag based on their own combination or preference. Changing the bag with Force is illogical.
        ]]

        ["use"] = false, -- If you select `true`, the bag you specified will appear behind the user. 
        ["male"] = {
            -- drawableId: The number of the clothing bag.
            -- textureId: The color, texture, type of the clothing bag.
            ["componentId"] = 5,
            ["drawableId"] = 44,
            ["textureId"] = 0
        },
        ["female"] = {
            -- drawableId: The number of the clothing bag.
            -- textureId: The color, texture, type of the clothing bag.
            ["componentId"] = 5,
            ["drawableId"] = 44,
            ["textureId"] = 0
        }
    },
    ["using"] = {
        ["spawn_offsets"] = vector4(0.75, 0.0, 0.0, 180.0), -- Offset when spawning the bag prop
        ["animations"] = {
            ["put"] = {
                -- Animation when placing the bag
                dict = "amb@medic@standing@tendtodead@idle_a",
                clip = "idle_a",
                flag = 0,
                duration = 3000
            },
            ["take"] = {
                -- Animation when picking up the bag
                dict = "amb@medic@standing@tendtodead@idle_a",
                clip = "idle_b",
                flag = 0,
                duration = 3000
            }
        },
    }
}   

Config.SaveableVariations = {
    --[[
        💡💡💡
        The category of clothing items to be registered is listed here when registering clothing. 
        In FiveM, the clothing system is divided into Components and Props. More details are available below.
    ]]

    ["components"] = {
        --[[
            ["component name"] = componentId,
            You can find component names and their IDs on the page below:
            0: Face 
            1: Mask 
            2: Hair 
            3: Torso 
            4: Leg 
            5: Parachute / bag 
            6: Shoes 
            7: Accessory 
            8: Undershirt 
            9: Kevlar 
            10: Badge 
            11: Torso 2

            PV_COMP_HEAD = 0, // "HEAD"
            PV_COMP_BERD = 1, // "BEARD"
            PV_COMP_HAIR = 2, // "HAIR"
            PV_COMP_UPPR = 3, // "UPPER"
            PV_COMP_LOWR = 4, // "LOWER"
            PV_COMP_HAND = 5, // "HAND"
            PV_COMP_FEET = 6, // "FEET"
            PV_COMP_TEEF = 7, // "TEETH"
            PV_COMP_ACCS = 8, // "ACCESSORIES"
            PV_COMP_TASK = 9, // "TASK"
            PV_COMP_DECL = 10, // "DECL"
            PV_COMP_JBIB = 11, // "JBIB"
        ]]

        ["mask"] = 1,
        ["neck"] = 7,
        ["arms"] = 3,
        ["t-shirt"] = 8,
        ["vest"] = 9,
        ["badge"] = 10,
        ["torso2"] = 11,
        ["bag"] = 5,
        ["pants"] = 4,
        ["shoes"] = 6
    },

    ["props"] = {
        --[[
            ["prop name"] = propId,
            You can find prop names and their IDs on the page below:
            0: Hat 
            1: Glasses 
            2: Ear 
            6: Watch 
            7: Bracelet

            ANCHOR_HEAD = 0, // "p_head"
            ANCHOR_EYES = 1, // "p_eyes"
            ANCHOR_EARS = 2, // "p_ears"
            ANCHOR_MOUTH = 3, // "p_mouth"
            ANCHOR_LEFT_HAND = 4, // "p_lhand"
            ANCHOR_RIGHT_HAND = 5, // "p_rhand"
            ANCHOR_LEFT_WRIST = 6, // "p_lwrist"
            ANCHOR_RIGHT_WRIST = 7, // "p_rwrist"
            ANCHOR_HIP = 8, // "p_lhip"
            ANCHOR_LEFT_FOOT = 9, // "p_lfoot"
            ANCHOR_RIGHT_FOOT = 10, // "p_rfoot"
            ANCHOR_PH_L_HAND = 11, // "ph_lhand"
            ANCHOR_PH_R_HAND = 12, // "ph_rhand"
            NUM_ANCHORS = 13,
        ]]

        ["hat"] = 0,
        ["glasses"] = 1,
        ["ear"] = 2,
        ["watch"] = 6,
        ["bracelet"] = 7
    }
}

Config.Animations = {
    ["all_body"] = {
        ["dict"] = "mp_safehouseshower@male@",
        ["clip"] = "male_shower_towel_dry_to_get_dressed",
        ["flag"] = 0,
        ["duration"] = 3000,
    },
    ["ear"] = {
        ["dict"] = "mp_cp_stolen_tut",
        ["clip"] = "b_think",
        ["flag"] = 51,
        ["duration"] = 900
    },
    ["neck"] = {
        ["dict"] = "clothingtie",
        ["clip"] = "try_tie_positive_a",
        ["flag"] = 51,
        ["duration"] = 2100
    },
    ["watch"] = {
        ["dict"] = "nmt_3_rcm-10",
        ["clip"] = "cs_nigel_dual-10",
        ["flag"] = 51,
        ["duration"] = 1200
    },
    ["bracelet"] = {
        ["dict"] = "nmt_3_rcm-10",
        ["clip"] = "cs_nigel_dual-10",
        ["flag"] = 51,
        ["duration"] = 1200
    },
    ["vest"] = {
        ["dict"] = "clothingtie",
        ["clip"] = "try_tie_negative_a",
        ["flag"] = 51,
        ["duration"] = 1200
    },
    ["torso2"] = {
        ["dict"] = "clothingtie",
        ["clip"] = "try_tie_negative_a",
        ["flag"] = 51,
        ["duration"] = 1500
    },
    ["pants"] = {
        ["dict"] = "re@construction",
        ["clip"] = "out_of_breath",
        ["flag"] = 51,
        ["duration"] = 1300
    },
    ["gloves"] = {
        ["dict"] = "nmt_3_rcm-10",
        ["clip"] = "cs_nigel_dual-10",
        ["flag"] = 51,
        ["duration"] = 1200
    },
    ["hat"] = {
        ["dict"] = "mp_masks@standard_car@ds@",
        ["clip"] = "put_on_mask",
        ["flag"] = 51,
        ["duration"] = 600
    },
    ["shoes"] = {
        ["dict"] = "random@domestic",
        ["clip"] = "pickup_low",
        ["flag"] = 0,
        ["duration"] = 1200
    },
    ["mask"] = {
        ["dict"] = "mp_masks@standard_car@ds@",
        ["clip"] = "put_on_mask",
        ["flag"] = 51,
        ["duration"] = 800
    },
    ["hair"] = {
        ["dict"] = "clothingtie",
        ["clip"] = "check_out_a",
        ["flag"] = 51,
        ["duration"] = 2000
    },
    ["bag"] = {
        ["dict"] = "anim@heists@ornate_bank@grab_cash",
        ["clip"] = "intro",
        ["flag"] = 51,
        ["duration"] = 1600
    },
    ["glasses"] = {
        ["dict"] = "clothingspecs",
        ["clip"] = "put_on",
        ["flag"] = 51,
        ["duration"] = 5300
    }
}

Config.Debug = function(...)
    if Config.ShowDebug then
        print(...)
    end
end

Config.SaveClothing = function(outfit)
    local ped, playerId = PlayerPedId(), GetPlayerServerId(PlayerId())
    local model = GetEntityModel(ped)
    local modelName = model == joaat("mp_m_freemode_01") and "mp_m_freemode_01" or "mp_f_freemode_01"

    if GetResourceState("17mov_CharacterSystem"):find("start") then
        Config.Notification("Error", "17mov Character System save skin is not supported yet", "error", 5000)
    elseif GetResourceState("rcore_clothing"):find("start") then
        TriggerEvent('rcore_clothing:saveCurrentSkin')
    elseif GetResourceState("qb-clothing"):find("start") then
        TriggerServerEvent("qb-clothing:saveSkin", model, outfit)
    elseif GetResourceState("esx_skin"):find("start") or GetResourceState('codem-appearance'):find("start") then
        local migratedOutfits = {}
        for k, v in pairs(outfit) do
            if k == "mask" then
                migratedOutfits["mask_1"] = v.dId
                migratedOutfits["mask_2"] = v.tId
            elseif k == "neck" then
                migratedOutfits["chain_1"] = v.dId
                migratedOutfits["chain_2"] = v.tId
            elseif k == "arms" then 
                migratedOutfits["arms"] = v.dId
                migratedOutfits["arms_2"] = v.tId
            elseif k == "t-shirt" then
                migratedOutfits["tshirt_1"] = v.dId
                migratedOutfits["tshirt_2"] = v.tId
            elseif k == "vest" then
                migratedOutfits["bproof_1"] = v.dId
                migratedOutfits["bproof_2"] = v.tId
            elseif k == "badge" then
                migratedOutfits["decals_1"] = v.dId
                migratedOutfits["decals_2"] = v.tId
            elseif k == "torso2" then
                migratedOutfits["torso_1"] = v.dId
                migratedOutfits["torso_2"] = v.tId
            elseif k == "bag" then
                if Config.Bag.drawable.use and Config.Bag.drawable.male.drawableId == v.dId then
                    migratedOutfits["bags_1"] = 0
                    migratedOutfits["bags_2"] = 0
                else
                    migratedOutfits["bags_1"] = v.dId
                    migratedOutfits["bags_2"] = v.tId
                end
            elseif k == "pants" then
                migratedOutfits["pants_1"] = v.dId
                migratedOutfits["pants_2"] = v.tId
            elseif k == "shoes" then
                migratedOutfits["shoes_1"] = v.dId
                migratedOutfits["shoes_2"] = v.tId
            elseif k == "hat" then
                migratedOutfits["helmet_1"] = v.dId
                migratedOutfits["helmet_2"] = v.tId
            elseif k == "glasses" then
                migratedOutfits["glasses_1"] = v.dId
                migratedOutfits["glasses_2"] = v.tId
            elseif k == "ear" then
                migratedOutfits["ears_1"] = v.dId
                migratedOutfits["ears_2"] = v.tId
            elseif k == "watch" then
                migratedOutfits["watches_1"] = v.dId
                migratedOutfits["watches_2"] = v.tId
            elseif k == "bracelet" then
                migratedOutfits["bracelets_1"] = v.dId
                migratedOutfits["bracelets_2"] = v.tId
            end
        end

        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerEvent('skinchanger:loadClothes', skin, migratedOutfits)

            Wait(500)
            TriggerEvent('esx_skin:save', skin)
        end)
    elseif GetResourceState('illenium-appearance'):find("start") then
        local appearance = exports['illenium-appearance']:getPedAppearance(ped)
        TriggerServerEvent("illenium-appearance:server:saveAppearance", appearance)
    elseif GetResourceState('fivem-appearance'):find("start") then
        Config.Notification("Error", "fivem-appearance save skin is not supported yet", "error", 5000)
    elseif GetResourceState("bl_appearance"):find("start") then
        Wait(500)
        local appearance = exports.bl_appearance:GetPedAppearance(ped)
        TriggerServerEvent('bl_appearance:server:saveAppearance', playerId, appearance, true)
    elseif GetResourceState("tgiann-clothing"):find("start") then
        Config.Notification("Error", "TGIANN Clothing is not supported yet", "error", 5000)
    elseif GetResourceState("0r-clothing"):find("start") then
        exports['0r-clothing']:saveCurrentSkin()
    end
end

Config.Notification = function(title, text, type, time)
    title = title or "Outfit Bag"
    time = time or 5000

    if Config.Framework.Framework == "qbcore" then
        TriggerEvent('QBCore:Notify', text, type, time)
    elseif Config.Framework.Framework == "esx" or Config.Framework.Framework == "qbox" then
        lib.notify({
            title = title,
            type = type,
            duration = time,
            description = text,
            iconAnimation = "beatFade",
            position = "right-top"
        })
    elseif GetResourceState("okokNotify"):find("start") then
        exports['okokNotify']:Alert(title, text, time, type, true)
    end
end

Config.HideUIs = function()
    -- Scripts or maps to be hidden when the menu is opened.
end

Config.ShowUIs = function()
    -- Scripts or maps to be shown when the menu is closed.
end