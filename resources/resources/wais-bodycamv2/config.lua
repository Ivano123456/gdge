Config = {}
Config.Framework = {
    ["Framework"] = "esx", -- esx or qbcore
    ["ResourceName"] = "es_extended", -- es_extended or qb-core or your resource name
    ["NewCore"] = true, -- If you use the new core, set this to true ( esx or qb ). If you are using the old one, make it false and edit the event below according to yourself.
    ["SharedEvent"] = "esx:getSharedObject" -- Event name for old cores.
}

Config.Jobs = {
    ["police"] = {
        ["watch"] = vector3(-559.4770, -435.8681, 39.6325),
        ["text"] = "[E] Otvori meni kamera",
        ["distance"] = 3.0,
        ["useTarget"] = false, -- If you set this option to true, the coords, text and distance variables will be valid for target
        ["uiSettings"] = {
            ["color"] = "#6792FF", -- Color of the main color theme of the menu (base on a lighter or pastel shade of the selected color)
            ["title"] = "Policijska Uprava",
            ["subtitle"] = "Pregled kamera",
            ["videoUpload"] = {
                ["webhook"] = "https://discord.com/api/webhooks/xxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxx",
                ["fivemanage"] = false, -- https://www.fivemanage.com
                ["fivemanage_token"] = "", -- https://www.fivemanage.com
            }, -- api or webhook to forward when recordings are stopped 
            ["backgroundColor"] = "#090814", -- Background color of the menu (based on a more muted shade of the selected color)
            ["badgeSettings"] = {
                ["image"] = "pd-badge", -- the photo that will appear on the back when the camera is turned on
                ["darkerColor"] = "#152538",  --  the color of the badge that will appear on the back when the camera is turned on
                ["lighterColor"] = "#6792FF", --  the color of the badge that will appear on the back when the camera is turned on
                ["departmentName"] = "policijska uprava"
            }
        }
    },
}

Config.Audible = true -- If you do true, you will hear the sounds from the cameras you ring. If false, you will not hear the sound of the cameras.

Config.BadgeSettings = {
    ["scale"] = 0.8, -- I recommend using between 0.0 and 1. Default value 0.8
    ["position"] = "right", -- When the camera is turned on, the sign indicating that the camera is on is only "left" or "right"
    ["hideableKey"] = "H" -- This button hides or unhides the badge at the set location. The first time a player enters the server, the typed key takes effect. After the key is changed, it will only be active for first time users. If this key was previously registered in the person's system, it will not change with the new key.
}

Config.Records = {
    ["recordTime"] = 1 * 60 * 1000, -- Equals 1 minute. I recommend a maximum of 3 minutes. Depending on the user's internet speed, it may take longer to load or the clip may not load and disappear. 
    ["enableRecord"] = true, -- Limited to 1 minute bodycam screen recording. Please be aware that when the player opens the screen recording, an average of 20 to 30 fps is lost, so it is not recommended to open it.
    ["useSoftware"] = false, -- Not yet released. Takes screen recordings with a program developed by Ayazwai. Features: All sounds (World, Players and User), Maximum FPS.
    ["recordKey"] = "J" -- Recording can be closed and opened with the specified key.The first time a player enters the server, the typed key takes effect. After the key is changed, it will only be active for first time users. If this key was previously registered in the person's system, it will not change with the new key.
}

Config.Props = {
    ["attachBodycam"] = true, -- If True, the outfit you set will appear on the character.
    ["componentSettings"] = {
        -- componentId: PV_COMP_HEAD = 0, "HEAD" PV_COMP_BERD = 1, "BEARD" PV_COMP_HAIR = 2, "HAIR" PV_COMP_UPPR = 3, "UPPER" PV_COMP_LOWR = 4, "LOWER" PV_COMP_HAND = 5, "HAND" PV_COMP_FEET = 6, "FEET" PV_COMP_TEEF = 7, "TEETH" PV_COMP_ACCS = 8, "ACCESSORIES" PV_COMP_TASK = 9, "TASK" PV_COMP_DECL = 10, "DECL" PV_COMP_JBIB = 11, "JBIB"
        ["male"] = {
            ["componentId"] = 0, -- 0: Face 1: Mask 2: Hair 3: Torso 4: Leg 5: Parachute / bag 6: Shoes 7: Accessory 8: Undershirt 9: Kevlar 10: Badge 11: Torso 2 List of Component IDs
            ["drawableId"] = 0, -- he drawable id that is going to be set
            ["textureId"] = 0, -- he texture id of the drawable
        }, 
        ["female"] = {
            ["componentId"] = 0, -- 0: Face 1: Mask 2: Hair 3: Torso 4: Leg 5: Parachute / bag 6: Shoes 7: Accessory 8: Undershirt 9: Kevlar 10: Badge 11: Torso 2 List of Component IDs
            ["drawableId"] = 0, -- she drawable id that is going to be set
            ["textureId"] = 0, -- she texture id of the drawable
        }
    }
}

Config.Items = {
    ["bodycam"] = "bodycam",
    ["dashcam"] = "dashcam",
    ["qs_inventory"] = GetResourceState("qs-inventory") == "started" and true or false -- make true if using qs-inventory
}

Config.CamSettings = {
    ["dashcamFov"] = 80.0,
    ["bodycamFov"] = 80.0,
    ["bodycamPositions"] = {
        x = 0.05, 
        y = -0.025, 
        z = 0.1
    } -- xOffset, yOffset, zOffset
}

Config.Notifications = {
    ["no_vehicle"] = {
        ["text"] = "Nema vozila u blizini",
        ["type"] = "error"
    },
    ["not_found"] = {
        ["text"] = "Nije pronadjeno vozilo za pracenje",
        ["type"] = "error"
    },
    ["cant_watch_self"] = {
        ["text"] = "Ne mozes gledati samog sebe",
        ["type"] = "error"
    },
    ["bodycam_on"] = {
        ["text"] = "Body kamera je ukljucena",
        ["type"] = "success"
    },
    ["bodycam_off"] = {
        ["text"] = "Body kamera je iskljucena",
        ["type"] = "error"
    },
    ["record_start"] = {
        ["text"] = "Snimanje je zapoceto",
        ["type"] = "success"
    },
    ["record_stop"] = {
        ["text"] = "Snimanje je zaustavljeno",
        ["type"] = "error"
    },
    ["record_uploaded"] = {
        ["text"] = "Snimak je uploadovan",
        ["type"] = "success"
    },
    ["record_failed_load"] = {
        ["text"] = "Ucitavanje snimka nije uspelo",
        ["type"] = "error"
    },
    ["disconnected"] = {
        ["text"] = "Veza sa kamerom je prekinuta!",
        ["type"] = "error"
    },
    ["dashcam_added"] = {
        ["text"] = "Dash kamera je dodata",
        ["type"] = "success"
    },
    ["upload_started"] = {
        ["text"] = "Upload je zapocet",
        ["type"] = "info"
    },
    ["nui_not_ready"] = {
        ["text"] = "NUI nije spreman. Body kamera nece raditi",
        ["type"] = "error"
    }
}

Config.NotificationSystem = GetResourceState("es_extended") == "started" and "esx" or GetResourceState("qb-core") == "started" and "qbcore" or GetResourceState("okokNotify") == "started" and "okokNotify" or false
Config.SendNotifications = function(notif)
    local notify = Config.Notifications[notif]

    if Config.NotificationSystem == "qbcore" then
        TriggerEvent('QBCore:Notify', notify.text, notify.type, 2500)
    elseif Config.NotificationSystem == "esx" then
        TriggerEvent('esx:showNotification', notify.text)
    elseif Config.NotificationSystem == "okokNotify" then
        exports['okokNotify']:Alert('Body & Dash Kamera', notify.text, 2500, notify.type, true)
    end
end

Config.OpenUIs = function()
    -- You can reopen closed UIs from here with export or trigger again
end

Config.CloseUIs = function()
    -- You can close UIs that you do not want to appear on the screen with export or trigger here
end