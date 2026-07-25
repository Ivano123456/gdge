function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

local menuReady = false
local menuActive = false
local nuiReady = false
local RES2 = {}

-- Build a self-contained payload for shared/eemotes requests so the receiver
-- never has to look the dict/name/options up in its own RES2 table. This fixes
-- cross-language pairings (sender + receiver on different language files) and
-- custom emotes that omit imageId / targetImageId fields.
-- Declared up here (not next to its callers) because local functions are only
-- visible after their declaration, and this is called from NUI callbacks
-- registered much earlier in the file than the shared-anim handlers.
local function embedSyncedRequestEntries(animData, category)
    animData.senderEntry = {
        [1] = animData[1],
        [2] = animData[2],
        [3] = animData[3],
        AnimationOptions = animData.AnimationOptions,
    }
    local targetTbl
    if category == "shared" then
        targetTbl = RES2.Shared
    elseif category == "eemotes" then
        targetTbl = RES2.EEmotes
    end
    local targetKey = animData[4]
    local targetEntry = targetTbl and targetKey and targetTbl[targetKey]
    if targetEntry then
        animData.receiverEntry = {
            [1] = targetEntry[1],
            [2] = targetEntry[2],
            [3] = targetEntry[3],
            AnimationOptions = targetEntry.AnimationOptions,
        }
    end
end

local data = {}
local categories = {}
local setDataState = false
local currentAnimData = {}
local pedProps = {}
local playerHasProp = false
local isInAnimation = false
local lastPlayedAnimType = nil
local positioningAnim = false
local handsUp = false
local PtfxNotif = false
local PtfxPrompt = false
local PtfxWait = 500
local PtfxCanHold = false
local PtfxNoProp = false
local AnimationThreadStatus = false
local animPosUsed = false
local animPosOldCoords = nil
local myClone = nil
local syncedTarget = 0
local PlayerParticles = {}
local langData = {}
local groupState = {
    enabled = Config.AnimationGroups and Config.AnimationGroups.Enable == true,
    inGroup = false,
    isOwner = false,
    owner = nil,
    maxPlayers = Config.AnimationGroups and Config.AnimationGroups.MaxPlayers or 5,
    members = {}
}
local groupCurrentAnim = nil
local groupInviteSelectActive = false
local groupInviteSelectToken = 0
local groupInviteSelectPlayers = {}
local groupInviteReceiveActive = false
local groupInviteReceiveToken = 0
local groupInviteReceiveOwner = nil
local groupAnimationRunning = false
local groupStopEventMuted = false

local groupPlayableCategories = {
    general = true,
    extra = true,
    propemotes = true,
    dances = true,
    placedemotes = true,
    animalemotes = true,
    gang = true
}
local groupFallbackTexts = {
    group = "Group",
    group_invite = "Invite Player",
    group_disabled = "Group animation system is disabled.",
    group_created = "Group created.",
    group_disbanded = "Group disbanded.",
    group_joined = "You joined the group.",
    group_left = "You left the group.",
    group_kicked = "Player removed from group.",
    group_you_were_kicked = "You were removed from the group.",
    group_already_in_group = "You are already in a group.",
    group_target_already_in_group = "That player is already in a group.",
    group_full = "Group is full.",
    group_only_owner = "Only the group owner can do this.",
    group_no_group = "You are not in a group.",
    group_no_invite = "There is no active group invite.",
    group_db_not_ready = "Group database is not ready.",
    group_invite_sent = "Group invite sent.",
    group_invite_select = "Choose a player to invite. Cancel",
    group_invite_received = "Group invite. Accept",
    group_invite_cancelled = "Group invite cancelled.",
    group_no_active_anim = "Play an animation first.",
    group_no_members = "There are no group members.",
    group_no_near_members = "No group members are close enough.",
    group_stop = "Stop Group Animation",
    no_players_nearby = "No players nearby.",
    request_timed_out = "Request timed out."
}

local function getGroupConfig()
    return Config.AnimationGroups or {}
end

local function isGroupFeatureEnabled()
    local cfg = getGroupConfig()
    return cfg.Enable == true
end

local function getGroupInviteDistance()
    local cfg = getGroupConfig()
    return tonumber(cfg.InviteDistance) or 5.0
end

local function getGroupInviteTimeout()
    local cfg = getGroupConfig()
    return tonumber(cfg.InviteTimeout) or 15000
end

local function getGroupPlayDistance()
    local cfg = getGroupConfig()
    return tonumber(cfg.PlayDistance) or 10.0
end

local function groupText(key, fallback)
    if langData and langData.notifications and langData.notifications[key] then
        return langData.notifications[key]
    end
    if langData and langData.menu and langData.menu[key] then
        return langData.menu[key]
    end
    return groupFallbackTexts[key] or fallback or key
end

local function isGroupPlayableCategory(category)
    return groupPlayableCategories[category] == true
end

local function getGroupCategoryLabel(category)
    if langData and langData.categories and langData.categories[category] then
        return langData.categories[category]
    end
    return category
end

local function getGroupAnimData(id, category)
    for _, anim in pairs(data) do
        if anim.category == category and (anim.name == id or anim.imageId == id) then
            return anim
        end
    end
    return nil
end

local function getGroupAnimLabel(id, category)
    local anim = getGroupAnimData(id, category)
    if anim then return anim.label end
    return id
end

local function sendGroupStateToNui()
    SendNUIMessage({action = "updateGroup", group = groupState})
end

local function setGroupCurrentAnimation(id, category)
    if not isGroupPlayableCategory(category) or not id then return end
    local anim = getGroupAnimData(tostring(id), category)
    groupCurrentAnim = {
        id = tostring(id),
        imageId = anim and tostring(anim.imageId or anim.name) or tostring(id),
        category = category,
        label = getGroupAnimLabel(tostring(id), category),
        categoryLabel = getGroupCategoryLabel(category)
    }
    SendNUIMessage({action = "updateGroupActiveAnim", anim = groupCurrentAnim})
end

local function clearGroupCurrentAnimation()
    groupCurrentAnim = nil
    SendNUIMessage({action = "updateGroupActiveAnim", anim = nil})
end

local function setGroupAnimationRunning(state)
    groupAnimationRunning = state == true
    SendNUIMessage({action = "updateGroupAnimationRunning", running = groupAnimationRunning})
end

local function getCurrentGroupAnimation()
    if groupCurrentAnim then return groupCurrentAnim end
    if currentAnimData and currentAnimData[#currentAnimData] and isGroupPlayableCategory(currentAnimData[#currentAnimData].category) then
        local anim = getGroupAnimData(tostring(currentAnimData[#currentAnimData].id), currentAnimData[#currentAnimData].category)
        return {
            id = tostring(currentAnimData[#currentAnimData].id),
            imageId = anim and tostring(anim.imageId or anim.name) or tostring(currentAnimData[#currentAnimData].id),
            category = currentAnimData[#currentAnimData].category
        }
    end
    return nil
end

local function clearGroupInviteSelection()
    for _, id in pairs(groupInviteSelectPlayers) do
        Delete3DTextUIOnPlayer("0resmon-animmenu-group-invite-player-" .. id)
    end
    groupInviteSelectPlayers = {}
    if groupInviteSelectActive then
        HideTextUI()
    end
    groupInviteSelectActive = false
end

local function clearGroupInviteReceive(sendDecline)
    if groupInviteReceiveOwner then
        Delete3DTextUIOnPlayer("0resmon-animmenu-group-invite-owner-" .. groupInviteReceiveOwner)
        if sendDecline then
            TriggerServerEvent('0resmon-animmenu:groupDeclineInvite:server', groupInviteReceiveOwner)
        end
    end
    if groupInviteReceiveActive then
        HideTextUI()
    end
    groupInviteReceiveActive = false
    groupInviteReceiveOwner = nil
end

local function startGroupInviteSelection()
    if not isGroupFeatureEnabled() then return Notify(groupText("group_disabled", "Group animation system is disabled."), 7500, "error") end
    if not groupState.inGroup or not groupState.isOwner then return Notify(groupText("group_only_owner", "Only the group owner can do this."), 7500, "error") end

    local memberMap = {}
    for _, member in pairs(groupState.members or {}) do
        memberMap[tonumber(member.id)] = true
    end

    local nearby = GetPlayersInArea(GetEntityCoords(PlayerPedId()), getGroupInviteDistance())
    local invitePlayers = {}
    for _, id in pairs(nearby) do
        if not memberMap[tonumber(id)] then
            invitePlayers[#invitePlayers + 1] = id
        end
    end

    if not next(invitePlayers) then
        return Notify(groupText("no_players_nearby", "No players nearby."), 7500, "error")
    end

    closeMenu()
    clearGroupInviteSelection()
    groupInviteSelectActive = true
    groupInviteSelectToken = groupInviteSelectToken + 1
    local token = groupInviteSelectToken
    groupInviteSelectPlayers = invitePlayers
    ShowTextUI(groupText("group_invite_select", "Choose a player to invite. Cancel"), "ESC")

    for _, id in pairs(groupInviteSelectPlayers) do
        Create3DTextUIOnPlayer("0resmon-animmenu-group-invite-player-" .. id, {
            id = id,
            displayDist = getGroupInviteDistance(),
            interactDist = 1.3,
            enableKeyClick = true,
            keyNum = 38,
            key = "E",
            text = groupText("group_invite", "Invite Player"),
            theme = "green",
            triggerData = {
                triggerName = "0resmon-animmenu:groupSelectInviteTarget:client",
                args = {id = id}
            }
        })
    end

    Citizen.CreateThread(function()
        while groupInviteSelectActive and groupInviteSelectToken == token do
            Citizen.Wait(0)
            if IsControlPressed(0, 322) then
                Notify(groupText("group_invite_cancelled", "Group invite cancelled."), 7500, "error")
                clearGroupInviteSelection()
                break
            end
        end
    end)

    Citizen.SetTimeout(getGroupInviteTimeout(), function()
        if groupInviteSelectActive and groupInviteSelectToken == token then
            clearGroupInviteSelection()
        end
    end)
end

local function startGroupAnimationForMembers()
    if not isGroupFeatureEnabled() then return Notify(groupText("group_disabled", "Group animation system is disabled."), 7500, "error") end
    if not groupState.inGroup or not groupState.isOwner then return Notify(groupText("group_only_owner", "Only the group owner can do this."), 7500, "error") end
    if groupAnimationRunning then
        TriggerServerEvent('0resmon-animmenu:groupStopAnim:server')
        return
    end
    local anim = getCurrentGroupAnimation()
    if not anim then return Notify(groupText("group_no_active_anim", "Play an animation first."), 7500, "error") end
    TriggerServerEvent('0resmon-animmenu:groupSyncAnim:server', anim)
end

local function stopLocalGroupAnimation()
    groupStopEventMuted = true
    if isInAnimation then
        cancelEmote("groupStop")
    else
        currentAnimData = {}
        clearGroupCurrentAnimation()
    end
    groupStopEventMuted = false
    setGroupAnimationRunning(false)
end

local function stopGroupAnimationForMembers()
    if not isGroupFeatureEnabled() then return Notify(groupText("group_disabled", "Group animation system is disabled."), 7500, "error") end
    if not groupState.inGroup or not groupState.isOwner then return Notify(groupText("group_only_owner", "Only the group owner can do this."), 7500, "error") end
    TriggerServerEvent('0resmon-animmenu:groupStopAnim:server')
    if groupAnimationRunning then
        stopLocalGroupAnimation()
    end
end

RegisterNetEvent('0r-animmenu:streamMissing:client', function()
    Notify("0r-animmenu: Stream folder is missing! Custom animations will not work.", 10000, "error")
end)

Citizen.CreateThread(function()
    setDataFunc()
end)

function setDataFunc()
    categories = {}
    data = {}
    local lastReady = false
    local id = 0
    while RES == nil do Citizen.Wait(0) end
    local startTime = GetGameTimer()
    while not nuiReady do
        Citizen.Wait(0) 
        if GetGameTimer() - startTime > 5000 then
            break
        end
    end
    while not CoreReady do 
        Citizen.Wait(100)
        if GetGameTimer() - startTime > 5000 then
            break
        end
    end
    while not next(GetPlayerData()) do
        Citizen.Wait(100)
        if GetGameTimer() - startTime > 5000 then
            break
        end
    end
    print("Table is ready.")
    local animList = RES["EN"]
    local animList2 = RES["EN"].Customs
    local lang = GetResourceKvpString('0ranimmenuv2lang')
    if not lang then lang = Config.Language end
    for k, v in pairs(Config.Languages) do
        if v.tableName == lang then
            animList = RES[v.tableName]
            animList2 = RES[v.tableName].Customs
            break
        end
    end
    if not animList then
        for k, v in pairs(Config.Languages) do
            if RES[v.tableName] then
                animList = RES[v.tableName]
                animList2 = RES[v.tableName].Customs
                break
            end
        end
    end
    -- General
    RES2.General = {}
    if Config.Categories.General then
        if animList.General then
            for k, v in pairs(animList.General) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "general",
                        imageId = imageId
                    })
                    RES2.General[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
        if animList2.General then
            for k, v in pairs(animList2.General) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "general",
                        imageId = imageId
                    })
                    RES2.General[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
    end
    -- Extra
    RES2.Extra = {}
    if Config.Categories.Extra then
        if animList.Extra then
            for k, v in pairs(animList.Extra) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "extra",
                        imageId = imageId
                    })
                end
                RES2.Extra[string.lower(k):gsub(" ", "")] = v
            end
        end
        if animList2.Extra then
            for k, v in pairs(animList2.Extra) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "extra",
                        imageId = imageId
                    })
                end
                RES2.Extra[string.lower(k):gsub(" ", "")] = v
            end
        end
    end
    -- Expressions
    RES2.Expressions = {}
    if Config.Categories.Expressions then
        if animList.Expressions then
            for k, v in pairs(animList.Expressions) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[2],
                        category = "expressions",
                        imageId = imageId
                    })
                    RES2.Expressions[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
        if animList2.Expressions then
            for k, v in pairs(animList2.Expressions) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[2],
                        category = "expressions",
                        imageId = imageId
                    })
                    RES2.Expressions[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
    end
    -- Dances
    RES2.Dances = {}
    if Config.Categories.Dances then
        if animList.Dances then
            for k, v in pairs(animList.Dances) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "dances",
                        imageId = imageId
                    })
                    RES2.Dances[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
        if animList2.Dances then
            for k, v in pairs(animList2.Dances) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "dances",
                        imageId = imageId
                    })
                    RES2.Dances[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
    end
    -- Walks
    RES2.Walks = {}
    if Config.Categories.Walks then
        if animList.Walks then
            for k, v in pairs(animList.Walks) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[2],
                        category = "walks",
                        imageId = imageId
                    })
                    RES2.Walks[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
        if animList2.Walks then
            for k, v in pairs(animList2.Walks) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[2],
                        category = "walks",
                        imageId = imageId
                    })
                    RES2.Walks[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
    end
    -- Placed Emotes
    RES2.PlacedEmotes = {}
    if Config.Categories.PlacedEmotes then
        if animList.PlacedEmotes then
            for k, v in pairs(animList.PlacedEmotes) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "placedemotes",
                        imageId = imageId
                    })
                    RES2.PlacedEmotes[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
        if animList2.PlacedEmotes then
            for k, v in pairs(animList2.PlacedEmotes) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "placedemotes",
                        imageId = imageId
                    })
                    RES2.PlacedEmotes[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
    end
    -- Synced Emotes
    RES2.Shared = {}
    RES2.SharedByImageId = {}
    if Config.Categories.Shared then
        if animList.Shared then
            for k, v in pairs(animList.Shared) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "shared",
                        imageId = imageId
                    })
                    RES2.Shared[string.lower(k):gsub(" ", "")] = v
                    RES2.SharedByImageId[imageId] = v
                end
            end
        end
        if animList2.Shared then
            for k, v in pairs(animList2.Shared) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "shared",
                        imageId = imageId
                    })
                    RES2.Shared[string.lower(k):gsub(" ", "")] = v
                    RES2.SharedByImageId[imageId] = v
                end
            end
        end
    end
    -- E Emotes
    RES2.EEmotes = {}
    if Config.Categories.EEmotes then
        if animList.EEmotes then
            for k, v in pairs(animList.EEmotes) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "eemotes",
                        imageId = imageId
                    })
                    RES2.EEmotes[string.lower(k):gsub(" ", "")] = v
                    RES2.SharedByImageId[imageId] = v
                end
            end
        end
        if animList2.EEmotes then
            for k, v in pairs(animList2.EEmotes) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "eemotes",
                        imageId = imageId
                    })
                    RES2.EEmotes[string.lower(k):gsub(" ", "")] = v
                    RES2.SharedByImageId[imageId] = v
                end
            end
        end
    end
    -- Prop Emotes
    RES2.PropEmotes = {}
    if Config.Categories.PropEmotes then
        if animList.PropEmotes then
            for k, v in pairs(animList.PropEmotes) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "propemotes",
                        imageId = imageId
                    })
                    RES2.PropEmotes[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
        if animList2.PropEmotes then
            for k, v in pairs(animList2.PropEmotes) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "propemotes",
                        imageId = imageId
                    })
                    RES2.PropEmotes[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
    end
    -- Animal Emotes
    RES2.AnimalEmotes = {}
    if Config.Categories.AnimalEmotes then
        if animList.AnimalEmotes then
            for k, v in pairs(animList.AnimalEmotes) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "animalemotes",
                        imageId = imageId
                    })
                    RES2.AnimalEmotes[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
        if animList2.AnimalEmotes then
            for k, v in pairs(animList2.AnimalEmotes) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "animalemotes",
                        imageId = imageId
                    })
                    RES2.AnimalEmotes[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
    end
    -- Gang
    RES2.Gang = {}
    if Config.Categories.Gang then
        if animList.Gang then
            for k, v in pairs(animList.Gang) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "gang",
                        imageId = imageId
                    })
                    RES2.Gang[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
        if animList2.Gang then
            for k, v in pairs(animList2.Gang) do
                local imageId = v.imageId or string.lower(k):gsub(" ", "")
                if not isInBlacklist(imageId) then
                    id = id + 1
                    table.insert(data, {
                        id = id,
                        name = string.lower(k):gsub(" ", ""),
                        label = v[3],
                        category = "gang",
                        imageId = imageId
                    })
                    RES2.Gang[string.lower(k):gsub(" ", "")] = v
                end
            end
        end
    end
    -- Categories
    langData = getLangData()
    -- All
    table.insert(categories, {
        name = "all",
        label = langData.categories.all,
        icon = "mdi_human-male",
        number = #data,
    })
    -- Favorites
    favoriteAnimations = {}
    local kvp = GetResourceKvpString('0ranimmenufavoritesv2')
    if kvp then favoriteAnimations = json.decode(kvp) end
    for k, v in pairs(favoriteAnimations) do
        local name = getAnimNameFromImageId(v.imageId, v.category)
        if name then
            v.name = name
        end
        local label = getAnimLabelFromImageId(v.imageId, v.category)
        if label then
            v.label = label
        end
    end
    table.insert(categories, {
        name = "favorites",
        label = langData.categories.favorites,
        icon = "handball",
        number = tablelength(favoriteAnimations)
    })
    -- Animation Groups
    if isGroupFeatureEnabled() then
        table.insert(categories, {
            name = "group",
            label = (langData.categories and langData.categories.group) or "Group",
            icon = "mdi_human-edit",
            number = 0,
            isGroup = true
        })
    end
    -- General
    if Config.Categories.General then
        table.insert(categories, {
            name = "general",
            label = langData.categories.general,
            icon = "map_unisex",
            number = tablelength(RES2.General)
        })
    end
    -- Extra
    if Config.Categories.Extra then
        table.insert(categories, {
            name = "extra",
            label = langData.categories.extra,
            icon = "map_unisex",
            number = tablelength(RES2.Extra)
        })
    end
    -- Dances
    if Config.Categories.Dances then
        table.insert(categories, {
            name = "dances",
            label = langData.categories.dances,
            icon = "mdi_human-female-dance",
            number = tablelength(RES2.Dances)
        })
    end
    -- Expressions
    if Config.Categories.Expressions then
        table.insert(categories, {
            name = "expressions",
            label = langData.categories.expressions,
            icon = "ri_emotion-sad-line",
            number = tablelength(RES2.Expressions)
        })
    end
    -- Walks
    if Config.Categories.Walks then
        table.insert(categories, {
            name = "walks",
            label = langData.categories.walks,
            icon = "mdi_walk",
            number = tablelength(RES2.Walks)
        })
    end
    -- Placed Emotes
    if Config.Categories.PlacedEmotes then
        table.insert(categories, {
            name = "placedemotes",
            label = langData.categories.placedemotes,
            icon = "meditation",
            number = tablelength(RES2.PlacedEmotes)
        })
    end
    -- Synced Emotes
    if Config.Categories.Shared then
        table.insert(categories, {
            name = "shared",
            label = langData.categories.syncedemotes,
            icon = "mdi_human-edit",
            number = tablelength(RES2.Shared)
        })
    end
    -- E Emotes
    if Config.Categories.EEmotes then
        table.insert(categories, {
            name = "eemotes",
            label = langData.categories.eemotes,
            icon = "mdi_human-edit",
            number = tablelength(RES2.EEmotes)
        })
    end
    -- Prop Emotes
    if Config.Categories.PropEmotes then
        table.insert(categories, {
            name = "propemotes",
            label = langData.categories.propemotes,
            icon = "mdi_gymnastics",
            number = tablelength(RES2.PropEmotes)
        })
    end
    -- Animal Emotes
    if Config.Categories.AnimalEmotes then
        table.insert(categories, {
            name = "animalemotes",
            label = langData.categories.animalemotes,
            icon = "horse-human",
            number = tablelength(RES2.AnimalEmotes)
        })
    end
    -- Gang
    if Config.Categories.Gang then
        table.insert(categories, {
            name = "gang",
            label = langData.categories.gang,
            icon = "map_unisex",
            number = tablelength(RES2.Gang)
        })
    end
    quickAnimations = {}
    local kvp2 = GetResourceKvpString('0ranimmenuquicksv2_new2')
    if kvp2 then
        local quicks = json.decode(kvp2)
        for k, v in pairs(quicks) do
            table.insert(quickAnimations, {
                slot = tonumber(v.slot),
                category = v.category,
                imageId = v.imageId,
                label = getAnimLabelFromImageId(v.imageId, v.category),
                key = v.key
            })
        end
    end
    lastReady = true
    -- table.sort(data, function(a,b) return a.label < b.label end)
    local order = {
        general = 1,
        propemotes = 2
    }
    table.sort(data, function(a, b)
        local aOrder = order[a.category] or 99
        local bOrder = order[b.category] or 99

        if aOrder == bOrder then
            return a.category < b.category
        else
            return aOrder < bOrder
        end
    end)
    while not lastReady do Citizen.Wait(0) end
    print("Menu ready.")
    menuReady = true
    Citizen.Wait(500)
    setQuickKeys()
    SendNUIMessage({action = "setData", sender = "0RES", themeCategories = Config.Themes, quickPrimaryKey = Config.QuickPrimaryKey, quickAnimationsState = Config.QuickAnimationsState, categories = categories, animations = data, favs = favoriteAnimations, quicks = quickAnimations, translations = langData.menu, languages = Config.Languages, gangEmoteProps = Config.GangEmoteProps, group = groupState, groupAnimationRunning = groupAnimationRunning})
    if isGroupFeatureEnabled() then
        TriggerServerEvent('0resmon-animmenu:groupRequestState:server')
    end
end

function isInBlacklist(name)
    for k, v in pairs(Config.Blacklist) do
        if v == name then
            return true
        end
    end
    return false
end

RegisterNUICallback('nuiReady', function()
    nuiReady = true
end)

if Config.MenuKey.KeyMapping.Enable then
    RegisterKeyMapping(Config.MenuKey.Command, "Opens anim menu", "keyboard", Config.MenuKey.KeyMapping.Key)
else
    Citizen.CreateThread(function() while true do Citizen.Wait(0) if IsControlJustReleased(0, Config.MenuKey.NormalKey.Key) then openMenu() end end end)
end

RegisterCommand(Config.MenuKey.Command, function() openMenu() end)
exports('openMenu', function() return openMenu() end)
function openMenu()
    TriggerServerEvent('0r-animmenu:checkStream:server')
    if isGroupFeatureEnabled() then
        TriggerServerEvent('0resmon-animmenu:groupRequestState:server')
    end
    if menuReady then
        if not Config.CanOpenMenu(GetPlayerServerId(PlayerId())) then return end
        if not setDataState then
            local kvp = GetResourceKvpString('0ranimmenufavoritesv2')
            if kvp then favoriteAnimations = json.decode(kvp) end
            for k, v in pairs(favoriteAnimations) do
                local name = getAnimNameFromImageId(v.imageId, v.category)
                if name then
                    v.name = name
                end
                local label = getAnimLabelFromImageId(v.imageId, v.category)
                if label then
                    v.label = label
                end
            end
            quickAnimations = {}
            local kvp2 = GetResourceKvpString('0ranimmenuquicksv2_new2')
            if kvp2 then
                local quicks = json.decode(kvp2)
                for k, v in pairs(quicks) do
                    table.insert(quickAnimations, {
                        slot = tonumber(v.slot),
                        category = v.category,
                        imageId = v.imageId,
                        label = getAnimLabelFromImageId(v.imageId, v.category),
                        key = v.key
                    })
                end
            end
            langData = getLangData()
            SendNUIMessage({action = "setData", sender = "0RES", themeCategories = Config.Themes, defaultQuickKeys = Config.DefaultQuickKeys, categories = categories, animations = data, favs = favoriteAnimations, quicks = quickAnimations, translations = langData.menu, languages = Config.Languages, quickKeys = Config.QuickKeys, group = groupState, groupAnimationRunning = groupAnimationRunning})
            while not setDataState do Citizen.Wait(1000) end
        end
        if requestActive then return end
        if DoesEntityExist(myClone) then return end
        menuActive = true
        SetNuiFocus(menuActive, menuActive)
        if Config.AllowMovement then
            SetNuiFocusKeepInput(menuActive)
            Citizen.CreateThread(function()
                while menuActive do
                    Citizen.Wait(1)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                    DisableControlAction(0, 1, true)
                    DisableControlAction(0, 2, true)
                    DisableControlAction(0, 200, true)
                    HideHudComponentThisFrame(2) -- HUD_WEAPON_ICON
                    HideHudComponentThisFrame(7) -- HUD_CASH
                    HideHudComponentThisFrame(9) -- HUD_WEAPON_WHEEL
                    HideHudComponentThisFrame(20) -- HUD_WEAPON_STAT
                    HideHudComponentThisFrame(22) -- HUD_WEAPON_WHEEL_STATS
                    DisableControlAction(0, 37, true)  -- INPUT_SELECT_WEAPON (TAB tuşu)
                    DisableControlAction(0, 14, true)  -- SCROLL DOWN
                    DisableControlAction(0, 15, true)  -- SCROLL UP
                    DisablePlayerFiring(PlayerPedId(), true)
                end
            end)
        else
            Citizen.CreateThread(function()
                while menuActive do
                    Citizen.Wait(1)
                    -- DisableControlAction(0, 24, true)
                    -- DisableControlAction(0, 25, true)
                    -- DisableControlAction(0, 1, true)
                    -- DisableControlAction(0, 2, true)
                    -- DisableControlAction(0, 200, true)
                    HideHudComponentThisFrame(2) -- HUD_WEAPON_ICON
                    HideHudComponentThisFrame(7) -- HUD_CASH
                    HideHudComponentThisFrame(9) -- HUD_WEAPON_WHEEL
                    HideHudComponentThisFrame(20) -- HUD_WEAPON_STAT
                    HideHudComponentThisFrame(22) -- HUD_WEAPON_WHEEL_STATS
                    DisableControlAction(0, 37, true)  -- INPUT_SELECT_WEAPON (TAB tuşu)
                    DisableControlAction(0, 14, true)  -- SCROLL DOWN
                    DisableControlAction(0, 15, true)  -- SCROLL UP
                    -- DisablePlayerFiring(PlayerPedId(), true)
                end
            end)
        end
        SendNUIMessage({action = "menu", state = menuActive})
    end
end
RegisterNetEvent('0r-animmenu:openMenu:client', openMenu)

exports('closeMenu', function() return closeMenu() end)
function closeMenu()
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({action = "menu", state = false})
    menuActive = false
end
RegisterNetEvent('0r-animmenu:closeMenu:client', closeMenu)

RegisterNUICallback('callback', function(data)
    if data.action == "playSound" then
        PlaySound(-1, data.sound, data.type, 0, 0, 1)
    elseif data.action == "setLanguage" then
        SetResourceKvp("0ranimmenuv2lang", data.language)
    elseif data.action == "enableGangPropMenu" then
        if menuActive then
            SendNUIMessage({action = "menu", state = false})
            menuActive = false
        end
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        if Config.GangEmotePropMenu == "ox_lib" and GetResourceState("ox_lib") == "started" then
            gangPropsMenu()
        elseif Config.GangEmotePropMenu == "qb-menu" and GetResourceState("qb-menu") == "started" then
            gangPropsMenu()
        else
            SetNuiFocus(true, true)
            SendNUIMessage({action = "enableGangPropMenu"})
            SetNuiFocusKeepInput(true)
        end
    elseif data.action == "addGangProp" then
        attachPropToHand(
            data.objName,
            data.hand,
            data.pos,
            data.rot,
            data.bone
        )
    elseif data.action == "removeGangProp" then
        removePropFromHand(data.hand)
    elseif data.action == "resetState" then
        setDataState = false
        setDataFunc()
        openMenu()
    elseif data.action == "close" then
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        menuActive = false
    elseif data.action == "disableMovement" then
        if Config.AllowMovement then
            SetNuiFocusKeepInput(false)
        end
    elseif data.action == "enableMovement" then
        if Config.AllowMovement then
            SetNuiFocusKeepInput(true)
        end
    elseif data.action == "dataReady" then
        setDataState = true
        print("Datas ready.")
    elseif data.action == "saveFavAnims" then
        SetResourceKvp("0ranimmenufavoritesv2", json.encode(data.favoriteAnimations))
    elseif data.action == "saveQuickAnims" then
        quickAnimations = {}
        local quickAnimationsTable = {}
        for k, v in pairs(data.quickAnimations) do
            local entry = {
                slot = tonumber(v.slot),
                category = v.category,
                imageId = v.imageId,
                label = getAnimLabelFromImageId(v.imageId, v.category),
                key = v.key
            }
            table.insert(quickAnimations, entry)
            table.insert(quickAnimationsTable, {
                slot = tonumber(v.slot),
                category = v.category,
                imageId = v.imageId,
                key = v.key
            })
        end
        SetResourceKvp("0ranimmenuquicksv2_new2", json.encode(quickAnimationsTable))
        Citizen.Wait(250)
        setQuickKeys()
    elseif data.action == "keybindSaved" then
        for k, v in pairs(quickAnimations) do
            if v.key == data.key then
                return Notify(langData.notifications.same_keybind, 7500, "error")
            end
            if tonumber(v.slot) == tonumber(data.slot) then
                v.key = data.key
            end
        end
        local quickAnimationsTable = {}
        for k, v in pairs(quickAnimations) do
            table.insert(quickAnimationsTable, {
                slot = tonumber(v.slot),
                category = v.category,
                imageId = v.imageId,
                key = v.key
            })
        end
        SetResourceKvp("0ranimmenuquicksv2_new2", json.encode(quickAnimationsTable))
        Citizen.Wait(250)
        setQuickKeys()
        SendNUIMessage({action = "updateQuicks", quicks = quickAnimations})
    elseif data.action == "notify" then
        Notify(data.title .. ": " .. data.message, 5000, "error")
    elseif data.action == "createGroup" then
        TriggerServerEvent('0resmon-animmenu:groupCreate:server')
    elseif data.action == "inviteGroupPlayer" then
        startGroupInviteSelection()
    elseif data.action == "leaveGroup" then
        TriggerServerEvent('0resmon-animmenu:groupLeave:server')
    elseif data.action == "disbandGroup" then
        TriggerServerEvent('0resmon-animmenu:groupDisband:server')
    elseif data.action == "kickGroupMember" then
        TriggerServerEvent('0resmon-animmenu:groupKick:server', data.target)
    elseif data.action == "startGroupAnimation" then
        startGroupAnimationForMembers()
    elseif data.action == "stopGroupAnimation" then
        stopGroupAnimationForMembers()
    elseif data.action == "playAnim" then
        if data.pType == "quicks" then
            local name = getAnimNameFromImageId(data.id)
            if name then data.id = name end
        end
        removeAllPropsGang()
        local inVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
        if not Config.AllowedInCars and inVehicle == 1 then
            return
        end
        if IsEntityInAir(PlayerPedId()) then
            return
        end
        if not Config.CanOpenMenu(GetPlayerServerId(PlayerId())) then return end
        if data.category == "propemotes" then
            if propEmoteTimeout then return end
            propEmoteTimeout = true
            SendNUIMessage({action = "propTimeout", state = true})
            Citizen.SetTimeout(Config.PropTimeout, function()
                propEmoteTimeout = false
                SendNUIMessage({action = "propTimeout", state = false})
            end)
        end
        if currentAnimData and next(currentAnimData) then
            for k, v in pairs(currentAnimData) do
                if v.id == data.id then
                    return cancelEmote("0resmon")
                end
            end
        end
        local tables = {
            ["general"] = {name = "General", dict = 1, anim = 2},
            ["extra"] = {name = "Extra", dict = 1, anim = 2},
            ["propemotes"] = {name = "PropEmotes", dict = 1, anim = 2},
            ["dances"] = {name = "Dances", dict = 1, anim = 2},
            ["expressions"] = {name = "Expressions", dict = 1},
            ["walks"] = {name = "Walks", dict = 1},
            ["placedemotes"] = {name = "PlacedEmotes", dict = 1, anim = 2},
            ["shared"] = {name = "Shared", targetName = 4, dict = 1, anim = 2},
            ["eemotes"] = {name = "EEmotes", targetName = 4, dict = 1, anim = 2},
            ["animalemotes"] = {name = "AnimalEmotes", dict = 1, anim = 2},
            ["gang"] = {name = "Gang", dict = 1, anim = 2}
        }
        local tableData = tables[data.category]
        local animData = RES2[tableData.name][data.id]
        lastPlayedAnimType = nil
        if animData == nil then return print("Anim doesn't exist: " .. tableData.name .. "(" .. data.category .. ")") end
        local cAnimData = {animData = animData, category = data.category, id = data.id}
        if data.category == "animalemotes" then
            local isPedAnimal = false
            local myPed = GetEntityModel(PlayerPedId())
            for k, v in pairs(Config.AnimalPeds) do
                if myPed == GetHashKey(v) then
                    isPedAnimal = true
                end
            end
            Citizen.Wait(500)
            if not isPedAnimal then
                return Notify(langData.notifications.just_animals, 7500, "error")
            end
        end
        setGroupCurrentAnimation(data.id, data.category)
        if data.category == "general" or data.category == "propemotes" or data.category == "animalemotes" or data.category == "extra" or data.category == "gang" then
            lastPlayedAnimType = data.category
            isInAnimation = true
            local heading = GetEntityHeading(PlayerPedId())
            if animData.AnimationOptions and animData.AnimationOptions.Scenario or animData[1] == "Scenario" then
                if inVehicle then return end
                ClearPedTasks(PlayerPedId())
                TaskStartScenarioInPlace(PlayerPedId(), animData[2], 0, true)
                cleanScenarioObjects(false)
                table.insert(currentAnimData, cAnimData)
            else
                if not loadAnim(animData[tableData.dict]) then return end
                table.insert(currentAnimData, cAnimData)
                local movementType = 1 -- Default movement type
                if animData.AnimationOptions then
                    if animData.AnimationOptions.onFootFlag then
                        movementType = animData.AnimationOptions.onFootFlag
                    elseif animData.AnimationOptions.EmoteMoving then
                        movementType = 51
                    elseif animData.AnimationOptions.EmoteLoop then
                        movementType = 1
                    elseif animData.AnimationOptions.EmoteStuck then
                        movementType = 50
                    end
                else
                    if inVehicle == 1 then
                        movementType = 51
                    end
                end
                if inVehicle == 1 then
                    movementType = 51
                end
                local animationDuration = -1
                if animData.AnimationOptions and (animData.AnimationOptions.Duration or animData.AnimationOptions.EmoteDuration) then
                    animationDuration = animData.AnimationOptions.Duration or animData.AnimationOptions.EmoteDuration
                end
                if animData.AnimationOptions and animData.AnimationOptions.PtfxAsset then
                    PtfxAsset = animData.AnimationOptions.PtfxAsset
                    PtfxName = animData.AnimationOptions.PtfxName
                    if animData.AnimationOptions.PtfxNoProp then
                        PtfxNoProp = animData.AnimationOptions.PtfxNoProp
                    else
                        PtfxNoProp = false
                    end
                    Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, PtfxScale = table.unpack(animData.AnimationOptions.PtfxPlacement)
                    PtfxBone = animData.AnimationOptions.PtfxBone
                    PtfxColor = animData.AnimationOptions.PtfxColor
                    PtfxInfo = animData.AnimationOptions.PtfxInfo
                    PtfxWait = animData.AnimationOptions.PtfxWait
                    PtfxCanHold = animData.AnimationOptions.PtfxCanHold
                    PtfxNotif = false
                    PtfxPrompt = true
                    RunAnimationThread()
                    TriggerServerEvent("0resmon-animmenu:ptfxSync:server", PtfxAsset, PtfxName, vector3(Ptfx1, Ptfx2, Ptfx3), vector3(Ptfx4, Ptfx5, Ptfx6), PtfxBone, PtfxScale, PtfxColor)
                else
                    PtfxPrompt = false
                end
                TaskPlayAnim(PlayerPedId(), animData[tableData.dict], animData[tableData.anim], 5.0, 5.0, animationDuration, movementType, 0, false, false, false)
                RemoveAnimDict(animData[tableData.dict])
                if animData.AnimationOptions and animData.AnimationOptions.Prop then
                    local propName = animData.AnimationOptions.Prop
                    local propBone = animData.AnimationOptions.PropBone
                    local propPl1, propPl2, propPl3, propPl4, propPl5, propPl6 = table.unpack(animData.AnimationOptions.PropPlacement)
                    if animData.AnimationOptions.Prop2 then
                        secondPropName = animData.AnimationOptions.Prop2
                        secondPropBone = animData.AnimationOptions.Prop2Bone
                        secondPropPl1, secondPropPl2, secondPropPl3, secondPropPl4, secondPropPl5, secondPropPl6 = table.unpack(animData.AnimationOptions.Prop2Placement)
                        secondPropEmote = true
                    else
                        secondPropEmote = false
                    end
                    if animData.AnimationOptions.SecondProp then
                        secondPropName = animData.AnimationOptions.SecondProp
                        secondPropBone = animData.AnimationOptions.SecondPropBone
                        secondPropPl1, secondPropPl2, secondPropPl3, secondPropPl4, secondPropPl5, secondPropPl6 = table.unpack(animData.AnimationOptions.SecondPropPlacement)
                        secondPropEmote = true
                    else
                        secondPropEmote = false
                    end
                    if not addPropToPed(propName, propBone, propPl1, propPl2, propPl3, propPl4, propPl5, propPl6, nil) then return end
                    if secondPropEmote then
                        if not addPropToPed(secondPropName, secondPropBone, secondPropPl1, secondPropPl2, secondPropPl3, secondPropPl4, secondPropPl5, secondPropPl6, nil) then
                            destroyAllPedProps()
                            return
                        end
                    end
                    if animData.AnimationOptions.PtfxAsset and not PtfxNoProp then
                        TriggerServerEvent("0resmon-animmenu:ptfxSyncProp:server", ObjToNet(prop))
                    end
                end
                if data.category == "gang" and animData.AnimationOptions and animData.AnimationOptions.fixHeading then
                    while not IsEntityPlayingAnim(PlayerPedId(), animData[tableData.dict], animData[tableData.anim], movementType) do Citizen.Wait(0) end
                    SetEntityHeading(PlayerPedId(), heading + 180.0)
                    SendNUIMessage({action = "openGangInfoMenu", state = true})
                elseif data.category == "gang" then
                    SendNUIMessage({action = "openGangInfoMenu", state = true})
                end
            end
        elseif data.category == "dances" then
            if not loadAnim(animData[tableData.dict]) then return end
            table.insert(currentAnimData, cAnimData)
            local movementType = 1
            local animationDuration = -1
            if inVehicle == 1 then
                movementType = 51
            end
            TaskPlayAnim(PlayerPedId(), animData[tableData.dict], animData[tableData.anim], 5.0, 5.0, animationDuration, movementType, 0, false, false, false)
            RemoveAnimDict(animData[tableData.dict])
            isInAnimation = true
            if animData.AnimationOptions and animData.AnimationOptions.Prop then
                local propName = animData.AnimationOptions.Prop
                local propBone = animData.AnimationOptions.PropBone
                local propPl1, propPl2, propPl3, propPl4, propPl5, propPl6 = table.unpack(animData.AnimationOptions.PropPlacement)
                if animData.AnimationOptions.Prop2 then
                    secondPropName = animData.AnimationOptions.Prop2
                    secondPropBone = animData.AnimationOptions.Prop2Bone
                    secondPropPl1, secondPropPl2, secondPropPl3, secondPropPl4, secondPropPl5, secondPropPl6 = table.unpack(animData.AnimationOptions.Prop2Placement)
                    secondPropEmote = true
                else
                    secondPropEmote = false
                end
                if animData.AnimationOptions.SecondProp then
                    secondPropName = animData.AnimationOptions.SecondProp
                    secondPropBone = animData.AnimationOptions.SecondPropBone
                    secondPropPl1, secondPropPl2, secondPropPl3, secondPropPl4, secondPropPl5, secondPropPl6 = table.unpack(animData.AnimationOptions.SecondPropPlacement)
                    secondPropEmote = true
                else
                    secondPropEmote = false
                end
                if not addPropToPed(propName, propBone, propPl1, propPl2, propPl3, propPl4, propPl5, propPl6, nil) then return end
                if secondPropEmote then
                    if not addPropToPed(secondPropName, secondPropBone, secondPropPl1, secondPropPl2, secondPropPl3, secondPropPl4, secondPropPl5, secondPropPl6, nil) then
                        destroyAllPedProps()
                        return
                    end
                end
                if animData.AnimationOptions.PtfxAsset and not PtfxNoProp then
                    TriggerServerEvent("0resmon-animmenu:ptfxSyncProp:server", ObjToNet(prop))
                end
            end
        elseif data.category == "expressions" then
            local expression = animData[tableData.dict]
            ClearFacialIdleAnimOverride(PlayerPedId())
            SetFacialIdleAnimOverride(PlayerPedId(), expression, 0)
            SetResourceKvp("0ranimmenuv2expression", expression)
        elseif data.category == "walks" then
            local walk = animData[tableData.dict]
            local name = data.id
            walkSet = name
            ResetPedMovementClipset(PlayerPedId(), 1.0)
            ResetPedWeaponMovementClipset(PlayerPedId())
            ResetPedStrafeClipset(PlayerPedId())
            RequestAnimSet(walk)
            while not HasAnimSetLoaded(walk) do Citizen.Wait(1) end
            SetPedMovementClipset(PlayerPedId(), walk, 0.2)
            RemoveAnimSet(walk)
            TriggerCallback('0r-animmenu:GetPlayerCid:server', function(cid)
                if cid then
                    SetResourceKvp("0ranimmenuv2walk" .. cid, walk)
                    SetResourceKvp("0ranimmenuv2walkname" .. cid, walkSet)
                else
                    SetResourceKvp("0ranimmenuv2walk", walk)
                    SetResourceKvp("0ranimmenuv2walkname", walkSet)
                end
            end)
        elseif data.category == "placedemotes" then
            if Config.UseOldVersionPlacing then
                if DoesEntityExist(myClone) then return end
                if inVehicle then return end
                local hit, coords, entity = RayCastGamePlayCamera(Config.MaxDistanceForAnimPos)
                if hit and (IsEntityAVehicle(entity) or IsThisModelAHeli(entityModel) or IsThisModelAPlane(entityModel)) then
                    return
                end
                if menuActive then
                    SendNUIMessage({action = "menu", state = false})
                    menuActive = false
                end
                SendNUIMessage({action = "openInfoMenu", state = true})
                myClone = ClonePed(PlayerPedId(), false, false, true)
                FreezeEntityPosition(myClone, true)
                SetEntityHeading(myClone, GetEntityHeading(PlayerPedId()))
                PlaceObjectOnGroundProperly(myClone)
                SetBlockingOfNonTemporaryEvents(myClone, true)
                SetEntityCollision(myClone, false, false)
                SetEntityAlpha(myClone, 200, false)
                animPosOldCoords = GetEntityCoords(PlayerPedId())
                if not loadAnim(animData[tableData.dict]) then return end
                local movementType = 1 -- Default movement type
                local animationDuration = -1
                TaskPlayAnim(myClone, animData[tableData.dict], animData[tableData.anim], 5.0, 5.0, animationDuration, movementType, 0, false, false, false)
                if Config.PlayPlacedAnimOnPlayerPed then
                    TaskPlayAnim(PlayerPedId(), animData[tableData.dict], animData[tableData.anim], 5.0, 5.0, animationDuration, movementType, 0, false, false, false)
                end
                RemoveAnimDict(animData[tableData.dict])
                SetNuiFocus(true, false)
                SetNuiFocusKeepInput(true)
                positioningAnim = true
                local disableControlActions2 = {20, 36}
                local setAnim = true
                local myCoords = GetEntityCoords(PlayerPedId())
                myCoordsZ = myCoords.z
                local cloneCoordsM = GetEntityCoords(myClone)
                local cloneHeadingM = GetEntityHeading(myClone)
                while positioningAnim do
                    for _, key in pairs(disableControlActions2) do
                        DisableControlAction(0, key, true)
                    end
                    DisablePlayerFiring(PlayerId(), true)
                    cloneCoords = GetEntityCoords(myClone)
                    local hit, coords, entity = RayCastGamePlayCamera(Config.MaxDistanceForAnimPos)
                    if hit and setAnim then
                        SetEntityCoords(myClone, coords.x, coords.y, myCoordsZ)
                    end
                    if IsControlPressed(0, 20) or IsDisabledControlPressed(0, 20) then
                        myCoordsZ = coords.z
                    end
                    if IsControlPressed(0, 14) then -- Rotate Left
                        if IsControlPressed(0, 36) or IsDisabledControlPressed(0, 36) then
                            SetEntityHeading(myClone, GetEntityHeading(myClone) - 5)
                        else
                            SetEntityHeading(myClone, GetEntityHeading(myClone) - 10)
                        end
                    end
                    if IsControlPressed(0, 15) then -- Rotate Right
                        if IsControlPressed(0, 36) or IsDisabledControlPressed(0, 36) then
                            SetEntityHeading(myClone, GetEntityHeading(myClone) + 5)
                        else
                            SetEntityHeading(myClone, GetEntityHeading(myClone) + 10)
                        end
                    end
                    if IsControlPressed(1, 27) then -- Up Arrow
                        setAnim = false
                        local distance = #(cloneCoords - myCoords)
                        if Config.MaxDistanceForAnimPos >= Round(distance) then
                            local myClonePos = GetEntityCoords(myClone)
                            if IsControlPressed(0, 36) or IsDisabledControlPressed(0, 36) then
                                myCoordsZ = myCoordsZ + 0.001
                            else
                                myCoordsZ = myCoordsZ + 0.05
                            end
                            SetEntityCoords(myClone, myClonePos.x, myClonePos.y, myCoordsZ)
                        else
                            SetEntityCoords(myClone, myCoords.x, myCoords.y, myCoordsZ)
                        end
                    end
                    if IsControlPressed(1, 173) then -- Down Arrow
                        setAnim = false
                        local distance = #(cloneCoords - myCoords)
                        if Config.MaxDistanceForAnimPos >= Round(distance) then
                            local myClonePos = GetEntityCoords(myClone)
                            if IsControlPressed(0, 36) or IsDisabledControlPressed(0, 36) then
                                myCoordsZ = myCoordsZ - 0.001
                            else
                                myCoordsZ = myCoordsZ - 0.05
                            end
                            SetEntityCoords(myClone, myClonePos.x, myClonePos.y, myCoordsZ)
                        else
                            SetEntityCoords(myClone, myCoords.x, myCoords.y, myCoordsZ)
                        end
                    end
                    if IsControlPressed(0, 38) then -- Confirm 
                        SetNuiFocus(false, false)
                        SetNuiFocusKeepInput(false)
                        SendNUIMessage({action = "openInfoMenu", state = false})
                        cloneCoords = GetEntityCoords(myClone)
                        cloneHeading = GetEntityHeading(myClone)
                        TaskGoStraightToCoord(PlayerPedId(), cloneCoords.x, cloneCoords.y, cloneCoords.z, 1.0, -1, cloneHeading, -1)
                        DeletePed(myClone)
                        positioningAnim = false
                        lastPlayedAnimType = "posAnim"
                        taskActive = true
                    end
                    if IsControlPressed(0, 322) then -- ESC
                        setAnim = false
                        SetNuiFocus(false, false)
                        SetNuiFocusKeepInput(false)
                        SendNUIMessage({action = "openInfoMenu", state = false})
                        DeletePed(myClone)
                        positioningAnim = false
                        taskActive = false
                    end
                    setAnim = true
                    Citizen.Wait(0)
                end
                Citizen.SetTimeout(7500, function()
                    if taskActive then
                        FreezeEntityPosition(PlayerPedId(), true)
                        Citizen.Wait(250)
                        --SetEntityCollision(PlayerPedId(), false, false)
                        SetEntityVisible(PlayerPedId(), false, 0)
                        ClearPedTasks(PlayerPedId())
                        ClearPedSecondaryTask(PlayerPedId())
                        SetEntityCoordsNoOffset(PlayerPedId(), cloneCoords.x, cloneCoords.y, myCoordsZ + 1.0, true, true, true)
                        SetEntityHeading(PlayerPedId(), cloneHeading)
                        taskActive = false
                        Citizen.Wait(500)
                        SetEntityVisible(PlayerPedId(), true, 0)
                    end
                end)
                while taskActive do
                    Citizen.Wait(0)
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local distance = #(myCoords - cloneCoords)
                    if distance <= 1.5 then
                        FreezeEntityPosition(PlayerPedId(), true)
                        Citizen.Wait(250)
                        --SetEntityCollision(PlayerPedId(), false, false)
                        SetEntityVisible(PlayerPedId(), false, 0)
                        ClearPedTasks(PlayerPedId())
                        ClearPedSecondaryTask(PlayerPedId())
                        SetEntityCoordsNoOffset(PlayerPedId(), cloneCoords.x, cloneCoords.y, myCoordsZ + 1.0, true, true, true)
                        SetEntityHeading(PlayerPedId(), cloneHeading)
                        taskActive = false
                        positioningAnim = false
                        Citizen.Wait(500)
                        SetEntityVisible(PlayerPedId(), true, 0)
                        local movementType = 1 -- Default movement type
                        local animationDuration = -1
                        if not loadAnim(animData[tableData.dict]) then return end
                        TaskPlayAnim(PlayerPedId(), animData[tableData.dict], animData[tableData.anim], 5.0, 5.0, animationDuration, movementType, 0, false, false, false)
                        RemoveAnimDict(animData[tableData.dict])
                        isInAnimation = true
                        taskActive = false
                        break
                    end
                end
            else
                table.insert(currentAnimData, cAnimData)
                if not Config.AnimPos.Enable then
                    if currentAnimData and currentAnimData[#currentAnimData] and currentAnimData[#currentAnimData].category and currentAnimData[#currentAnimData].id then
                        ExecuteCommand('e ' .. currentAnimData[#currentAnimData].id)
                    end
                    return
                end
                if isCamActive then return end
                if DoesEntityExist(myClone) then return end
                if inVehicle then return end
                if menuActive then
                    SendNUIMessage({action = "menu", state = false})
                    menuActive = false
                end
                SendNUIMessage({action = "openInfoMenu", state = true})
                myClone = ClonePed(PlayerPedId(), false, false, true)
                FreezeEntityPosition(myClone, true)
                SetEntityHeading(myClone, GetEntityHeading(PlayerPedId()))
                PlaceObjectOnGroundProperly(myClone)
                SetBlockingOfNonTemporaryEvents(myClone, true)
                SetEntityAlpha(myClone, 200, false)
                SetEntityAsMissionEntity(myClone, true, true)
                SetNuiFocus(true, false)
                SetNuiFocusKeepInput(true)
                positioningAnim = true
                local disableControlActions2 = {20, 21}
                local setAnim = true
                myCoords = GetEntityCoords(PlayerPedId())
                myCoordsZ = myCoords.z
                myCoordsZ2 = myCoords.z
                local cloneCoordsM = GetEntityCoords(myClone)
                cloneHeadingM = GetEntityHeading(myClone)
                TriggerServerEvent('0resmon-animmenu:setPedAlpha:server', GetPlayerServerId(PlayerId()), 200)
                local newCoords = GetEntityCoords(PlayerPedId())
                animPosOldCoords = GetEntityCoords(PlayerPedId())
                -- Command
                local tables = {
                    ["general"] = {name = "General", dict = 1, anim = 2},
                    ["extra"] = {name = "Extra", dict = 1, anim = 2},
                    ["propemotes"] = {name = "PropEmotes", dict = 1, anim = 2},
                    ["dances"] = {name = "Dances", dict = 1, anim = 2},
                    ["expressions"] = {name = "Expressions", dict = 2},
                    ["walks"] = {name = "Walks", dict = 1},
                    ["placedemotes"] = {name = "PlacedEmotes", dict = 1, anim = 2},
                    ["shared"] = {name = "Shared", targetName = 4, dict = 1, anim = 2},
                    ["eemotes"] = {name = "EEmotes", targetName = 4, dict = 1, anim = 2},
                    ["animalemotes"] = {name = "AnimalEmotes", dict = 1, anim = 2}
                }
                local groundZ = 0.0
                local success, foundZ = GetGroundZFor_3dCoord(newCoords.x, newCoords.y, newCoords.z, groundZ, false)
                if foundZ > 0.0 then
                    foundZ = foundZ - 1.0
                end
                local myAnim = currentAnimData[#currentAnimData]
                if myAnim and myAnim.category and myAnim.id then
                    ExecuteCommand('eclone ' .. myAnim.id)
                    if Config.PlayPlacedAnimOnPlayerPed then
                        ExecuteCommand('e ' .. myAnim.id)
                    end
                end
                animPosUsed = false
                while positioningAnim do
                    SetGameplayCamFollowPedThisUpdate(myClone)
                    newCoords = GetEntityCoords(myClone)
                    --SetEntityCoords(PlayerPedId(), newCoords.x, newCoords.y, newCoords.z - 1.0)
                    for _, key in pairs(disableControlActions2) do
                        DisableControlAction(0, key, true)
                    end
                    DisablePlayerFiring(PlayerId(), true)
                    if IsControlPressed(0, 20) or IsDisabledControlPressed(0, 20) then
                        myCoordsZ = myCoords.z
                        -- SendNUIMessage({action = "usingKey", key = "z"})
                    end
                    if IsControlPressed(0, 14) then -- Rotate Left
                        if IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21) then
                            -- SendNUIMessage({action = "usingKey", key = "shift"})
                            SetEntityHeading(myClone, GetEntityHeading(myClone) - 2.5)
                        else
                            SetEntityHeading(myClone, GetEntityHeading(myClone) - 5.0)
                        end
                        -- SendNUIMessage({action = "usingKey", key = "mouse"})
                    end
                    if IsControlPressed(0, 15) then -- Rotate Right
                        if IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21) then
                            -- SendNUIMessage({action = "usingKey", key = "shift"})
                            SetEntityHeading(myClone, GetEntityHeading(myClone) + 2.5)
                        else
                            SetEntityHeading(myClone, GetEntityHeading(myClone) + 5.0)
                        end
                        -- SendNUIMessage({action = "usingKey", key = "mouse"})
                    end
                    if IsControlPressed(0, 32) then -- W
                        -- SendNUIMessage({action = "usingKey", key = "w"})
                        local distance = #(newCoords - myCoords)
                        if Config.AnimPos.MaxDistance >= Round(distance) then
                            if IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21) then
                                -- SendNUIMessage({action = "usingKey", key = "shift"})
                                local offset = GetOffsetFromEntityInWorldCoords(myClone, 0.0, 0.025, 0.0)
                                SetEntityCoords(myClone, offset.x, offset.y, myCoordsZ)
                            else
                                local offset = GetOffsetFromEntityInWorldCoords(myClone, 0.0, 0.05, 0.0)
                                SetEntityCoords(myClone, offset.x, offset.y, myCoordsZ)
                            end
                        else
                            SetEntityCoords(myClone, myCoords.x, myCoords.y, myCoordsZ)
                        end
                    end
                    if IsControlPressed(0, 34) then -- A
                        -- SendNUIMessage({action = "usingKey", key = "a"})
                        local distance = #(newCoords - myCoords)
                        if Config.AnimPos.MaxDistance >= Round(distance) then
                            if IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21) then
                                -- SendNUIMessage({action = "usingKey", key = "shift"})
                                local offset = GetOffsetFromEntityInWorldCoords(myClone, -0.025, 0.0, 0.0)
                                SetEntityCoords(myClone, offset.x, offset.y, myCoordsZ)
                            else
                                local offset = GetOffsetFromEntityInWorldCoords(myClone, -0.05, 0.0, 0.0)
                                SetEntityCoords(myClone, offset.x, offset.y, myCoordsZ)
                            end
                        else
                            SetEntityCoords(myClone, myCoords.x, myCoords.y, myCoordsZ)
                        end
                    end
                    if IsControlPressed(0, 33) then -- S
                        -- SendNUIMessage({action = "usingKey", key = "s"})
                        local distance = #(newCoords - myCoords)
                        if Config.AnimPos.MaxDistance >= Round(distance) then
                            if IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21) then
                                -- SendNUIMessage({action = "usingKey", key = "shift"})
                                local offset = GetOffsetFromEntityInWorldCoords(myClone, 0.0, -0.025, 0.0)
                                SetEntityCoords(myClone, offset.x, offset.y, myCoordsZ)
                            else
                                local offset = GetOffsetFromEntityInWorldCoords(myClone, 0.0, -0.05, 0.0)
                                SetEntityCoords(myClone, offset.x, offset.y, myCoordsZ)
                            end
                        else
                            SetEntityCoords(myClone, myCoords.x, myCoords.y, myCoordsZ)
                        end
                    end
                    if IsControlPressed(0, 30) then -- D
                        -- SendNUIMessage({action = "usingKey", key = "d"})
                        local distance = #(newCoords - myCoords)
                        if Config.AnimPos.MaxDistance >= Round(distance) then
                            if IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21) then
                                -- SendNUIMessage({action = "usingKey", key = "shift"})
                                local offset = GetOffsetFromEntityInWorldCoords(myClone, 0.025, 0.0, 0.0)
                                SetEntityCoords(myClone, offset.x, offset.y, myCoordsZ)
                            else
                                local offset = GetOffsetFromEntityInWorldCoords(myClone, 0.05, 0.0, 0.0)
                                SetEntityCoords(myClone, offset.x, offset.y, myCoordsZ)
                            end
                        else
                            SetEntityCoords(myClone, myCoords.x, myCoords.y, myCoordsZ)
                        end
                    end
                    if IsControlPressed(0, 27) then -- Arrow Up
                        -- SendNUIMessage({action = "usingKey", key = "arrowup"})
                        local distance = #(newCoords - myCoords)
                        if Config.AnimPos.MaxHeightDistance >= Round(distance) then
                            if IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21) then
                                -- SendNUIMessage({action = "usingKey", key = "shift"})
                                myCoordsZ = myCoordsZ + 0.001
                            else
                                myCoordsZ = myCoordsZ + 0.025
                            end
                            SetEntityCoords(myClone, newCoords.x, newCoords.y, myCoordsZ)
                        else
                            myCoordsZ = myCoordsZ2
                            SetEntityCoords(myClone, myCoords.x, myCoords.y, myCoordsZ2)
                        end
                    end
                    if IsControlPressed(0, 173) then -- Arrow Down
                        -- SendNUIMessage({action = "usingKey", key = "arrowdown"})
                        local distance = #(newCoords - myCoords)
                        if Config.AnimPos.MaxDistance >= Round(distance) and myCoordsZ >= foundZ then
                            if IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21) then
                                -- SendNUIMessage({action = "usingKey", key = "shift"})
                                myCoordsZ = myCoordsZ - 0.001
                            else
                                myCoordsZ = myCoordsZ - 0.025
                            end
                            SetEntityCoords(myClone, newCoords.x, newCoords.y, myCoordsZ)
                        else
                            myCoordsZ = myCoordsZ2
                            SetEntityCoords(myClone, myCoords.x, myCoords.y, myCoordsZ2)
                        end
                    end
                    --PlaceObjectOnGroundProperly(myClone)
                    if IsControlPressed(0, 38) then -- Confirm E
                        SetNuiFocus(false, false)
                        SetNuiFocusKeepInput(false)
                        SendNUIMessage({action = "openInfoMenu", state = false})
                        ExecuteCommand('e ' .. myAnim.id)
                        Citizen.Wait(500)
                        FreezeEntityPosition(PlayerPedId(), true)
                        SetEntityCollision(PlayerPedId(), false, false)
                        SetEntityVisible(PlayerPedId(), false, 0)
                        ClearPedTasks(PlayerPedId())
                        ClearPedSecondaryTask(PlayerPedId())
                        cloneCoords = GetEntityCoords(myClone)
                        SetEntityCoordsNoOffset(PlayerPedId(), cloneCoords.x, cloneCoords.y, cloneCoords.z, true, true, true)
                        SetEntityHeading(PlayerPedId(), GetEntityHeading(myClone))
                        Citizen.Wait(250)
                        SetNuiFocus(false, false)
                        SetNuiFocusKeepInput(false)
                        SendNUIMessage({action = "openInfoMenu", state = false})
                        Citizen.Wait(250)
                        DeletePed(myClone)
                        positioningAnim = false
                        SetEntityVisible(PlayerPedId(), true, 0)
                        animPosUsed = true
                    end
                    if IsControlPressed(0, 322) then -- ESC
                        setAnim = false
                        SetNuiFocus(false, false)
                        SetNuiFocusKeepInput(false)
                        SendNUIMessage({action = "openInfoMenu", state = false})
                        DeletePed(myClone)
                        positioningAnim = false
                        SetEntityCoords(PlayerPedId(), myCoords.x, myCoords.y, myCoords.z - 1.0)
                        SetEntityHeading(PlayerPedId(), cloneHeadingM)
                    end
                    setAnim = true
                    SetEntityLocallyInvisible(PlayerPedId())
                    Citizen.Wait(0)
                end
                SetEntityLocallyVisible(PlayerPedId())
                TriggerServerEvent('0resmon-animmenu:setPedAlpha:server', GetPlayerServerId(PlayerId()), 255)
            end
        elseif data.category == "shared" or data.category == "eemotes" then
            if requestActive then return end
            if inVehicle then return end
            nearbyPlayers = GetPlayersInArea(GetEntityCoords(PlayerPedId()), 5.0)
            if next(nearbyPlayers) ~= nil and next(nearbyPlayers) then
                menuActive = false
                SetNuiFocusKeepInput(false)
                SetNuiFocus(false, false)
                SendNUIMessage({action = "menu", state = false})
                requestActive = true
                ShowTextUI(langData.notifications.waiting_for_a_decision, "ESC")
                animData.type = data.category
                animData.animNumber = data.id
                animData.targetAnimName = animData[4] or nil
                -- Universal imageId data (language-independent)
                animData.senderImageId = animData.imageId
                animData.targetImageId2 = animData.targetImageId
                embedSyncedRequestEntries(animData, data.category)
                for _, id in pairs(nearbyPlayers) do
                    Create3DTextUIOnPlayer("0resmon-animmenu-request-players-" .. id, {
                        id = id,
                        displayDist = 5.0,
                        interactDist = 1.3,
                        enableKeyClick = true, -- If true when you near it and click key it will trigger the event that you write inside triggerData
                        keyNum = 38,
                        key = "E",
                        text = animData[3] .. "?",
                        theme = "green", -- or red
                        triggerData = {
                            triggerName = "0resmon-animmenu:sendAnimRequest:client",
                            args = {data = animData, id = id}
                        }
                    })
                end
                Citizen.CreateThread(function()
                    while requestActive do
                        Citizen.Wait(0)
                        if IsControlPressed(0, 322) then
                            Notify(langData.notifications.request_cancelled, 7500, "error")
                            requestActive = false
                            currentAnimData = {}
                            HideTextUI()
                            for _, id in pairs(nearbyPlayers) do
                                Delete3DTextUIOnPlayer("0resmon-animmenu-request-players-" .. id)
                            end
                            break
                        end
                    end
                end)
                Citizen.SetTimeout(7500, function()
                    if next(nearbyPlayers) ~= nil and next(nearbyPlayers) and requestActive then
                        Notify(langData.notifications.request_timed_out, 7500, "error")
                        requestActive = false
                        currentAnimData = {}
                        HideTextUI()
                        for _, id in pairs(nearbyPlayers) do
                            Delete3DTextUIOnPlayer("0resmon-animmenu-request-players-" .. id)
                        end
                    end
                end)
            else
                Notify(langData.notifications.no_players_nearby, 7500, "error")
            end
        end
    end
end)

local props = {right = nil, left = nil}
local propsByHand = {right = nil, left = nil}
function attachPropToHand(propModel, hand, pos, rot, pbone)
    local ped = PlayerPedId()
    local bone = pbone or (hand == "right") and 57005 or 18905
    RequestModel(propModel)
    while not HasModelLoaded(propModel) do
        Wait(0)
    end
    if props[hand] and DoesEntityExist(props[hand]) then
        DeleteEntity(props[hand])
        props[hand] = nil
    end
    local obj = CreateObject(propModel, 0.0, 0.0, 0.0, true, true, false)
    AttachEntityToEntity(
        obj,
        ped,
        GetPedBoneIndex(ped, bone),
        pos[1] + 0.0, pos[2] + 0.0, pos[3] + 0.0,
        rot[1] + 0.0, rot[2] + 0.0, rot[3] + 0.0,
        true, true, false, true, 1, true
    )
    SetModelAsNoLongerNeeded(propModel)
    props[hand] = obj
    propsByHand[hand] = propModel
    SendNUIMessage({
        action = "updatePropCheckbox",
        hand = hand,
        objName = propModel
    })
end

function removePropFromHand(hand)
    if props[hand] and DoesEntityExist(props[hand]) then
        DeleteEntity(props[hand])
        props[hand] = nil
        propsByHand[hand] = nil
    end
end

function removeAllPropsGang()
    for hand, obj in pairs(props) do
        if obj and DoesEntityExist(obj) then
            DeleteEntity(obj)
            props[hand] = nil
            propsByHand[hand] = nil
        end
    end
    SendNUIMessage({action = "resetGangProps"})
    if Config.GangEmotePropMenu == "ox_lib" and GetResourceState("ox_lib") == "started" then
        exports["ox_lib"]:hideContext('prop_menu')
    elseif Config.GangEmotePropMenu == "qb-menu" and GetResourceState("qb-menu") == "started" then
        exports['qb-menu']:closeMenu()
    else
        SendNUIMessage({action = "closeGangPropMenu"})
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    cancelEmote("0resmon")
    destroyAllPedProps()
    Config.HandsupEnableControls()
    DetachEntity(PlayerPedId(), false, false)
    FreezeEntityPosition(PlayerPedId(), false)
    if DoesEntityExist(myClone) then DeletePed(myClone) end
    SetEntityCollision(PlayerPedId(), true, true)
    removeAllPropsGang()
end)

AddEventHandler('gameEventTriggered', function(event, data)
    if event == 'CEventNetworkEntityDamage' then
        local victim, attacker, victimDied, weapon = data[1], data[2], data[4], data[7]
		if not IsEntityAPed(victim) then return end
        if victimDied and NetworkGetPlayerIndexFromPed(victim) == PlayerId() and IsEntityDead(PlayerPedId()) then
            handsUp = false
            Config.HandsupEnableControls()
            ClearPedTasks(PlayerPedId())
            if menuActive then
                cancelEmote("0resmon")
                SetNuiFocus(false, false)
                SetNuiFocusKeepInput(false)
                SendNUIMessage({action = "menu", state = false})
                menuActive = false
            else
                cancelEmote("0res")
                if DoesEntityExist(myClone) then DeletePed(myClone) end
                SetNuiFocus(false, false)
                SetNuiFocusKeepInput(false)
                SendNUIMessage({action = "openInfoMenu", state = false})
                DeletePed(myClone)
                positioningAnim = false
                TriggerServerEvent('0resmon-animmenu:setPedAlpha:server', GetPlayerServerId(PlayerId()), 255)
                SetEntityLocallyVisible(PlayerPedId())
            end
		end
	end
end)

Citizen.CreateThread(function()
    while not next(langData) do Citizen.Wait(500) end
    -- Pointing
    if Config.Pointing.Enable then
        if Config.Pointing.KeyMapping.Enable then
            RegisterCommand('pointanim', function(source, args, raw) pointAnim() end, false)
            RegisterKeyMapping("pointanim", langData.keybinds.toggle_point_description, "keyboard", Config.Pointing.KeyMapping.Key)
        else
            Citizen.CreateThread(function() while true do Citizen.Wait(0) if IsControlJustReleased(0, Config.Pointing.NormalKey.Key) then pointAnim() end end end)
        end
        local pointAnimActive = false
        function startPointing()
            local ped = PlayerPedId()
            RequestAnimDict("anim@mp_point")
            while not HasAnimDictLoaded("anim@mp_point") do
                Wait(10)
            end
            SetPedCurrentWeaponVisible(ped, 0, true, true, true)
            SetPedConfigFlag(ped, 36, 1)
            TaskMoveNetworkByName(ped, 'task_mp_pointing', 0.5, false, 'anim@mp_point', 24)
            RemoveAnimDict("anim@mp_point")
        end
        function stopPointing()
            local ped = PlayerPedId()
            if not IsPedInjured(ped) then
                RequestTaskMoveNetworkStateTransition(ped, 'Stop')
                ClearPedSecondaryTask(ped)
                if not IsPedInAnyVehicle(ped, 1) then
                    SetPedCurrentWeaponVisible(ped, 1, true, true, true)
                end
                SetPedConfigFlag(ped, 36, false)
            end
        end
        function pointAnim()
            local ped = PlayerPedId()
            if not IsPedInAnyVehicle(ped, false) then
                pointAnimActive = not pointAnimActive
                if pointAnimActive then startPointing() else stopPointing() end
                while pointAnimActive do
                    local camPitch = GetGameplayCamRelativePitch()
                    local camHeading = GetGameplayCamRelativeHeading()
                    local cosCamHeading = Cos(camHeading)
                    local sinCamHeading = Sin(camHeading)
                    camPitch = math.max(-70.0, math.min(42.0, camPitch))
                    camPitch = (camPitch + 70.0) / 112.0
                    camHeading = math.max(-180.0, math.min(180.0, camHeading))
                    camHeading = (camHeading + 180.0) / 360.0
                    local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                    local ray = StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7)
                    local _, blocked = GetRaycastResult(ray)
                    SetTaskMoveNetworkSignalFloat(ped, "Pitch", camPitch)
                    SetTaskMoveNetworkSignalFloat(ped, "Heading", camHeading * -1.0 + 1.0)
                    SetTaskMoveNetworkSignalBool(ped, "isBlocked", blocked)
                    SetTaskMoveNetworkSignalBool(ped, "isFirstPerson", GetCamViewModeForContext(GetCamActiveViewModeContext()) == 4)
                    Wait(0)
                end
            end
        end
    end
    -- Crouch
    if Config.Crouching.Enable then
        local isCrouching = false
        exports("IsPlayerCrouched", function() return isCrouching end)
        function loadAnimSet(anim)
            if HasAnimSetLoaded(anim) then return end
            RequestAnimSet(anim)
            while not HasAnimSetLoaded(anim) do
                Wait(10)
            end
        end
        function resetAnimSet()
            local ped = PlayerPedId()
            ResetPedMovementClipset(ped, 1.0)
            ResetPedWeaponMovementClipset(ped)
            ResetPedStrafeClipset(ped)
            TriggerCallback('0r-animmenu:GetPlayerCid:server', function(cid)
                if cid then
                    local walk = GetResourceKvpString("0ranimmenuv2walk" .. cid)
                    if walk ~= nil then
                        walkSet = walk
                    end
                    if walkSet ~= 'default' then
                        loadAnimSet(walkSet)
                        SetPedMovementClipset(ped, walkSet, 1.0)
                        RemoveAnimSet(walkSet)
                    end
                else
                    local walk = GetResourceKvpString("0ranimmenuv2walk")
                    if walk ~= nil then
                        walkSet = walk
                    end
                    if walkSet ~= 'default' then
                        loadAnimSet(walkSet)
                        SetPedMovementClipset(ped, walkSet, 1.0)
                        RemoveAnimSet(walkSet)
                    end
                end
            end)
        end
        if Config.Crouching.UseLeftCTRL then
            Citizen.CreateThread(function()
                local sleep
                while true do
                    sleep = 1000
                    local ped = PlayerPedId()
                    DisableControlAction(0, 36, true)
                    if not IsPedSittingInAnyVehicle(ped) and not IsPedFalling(ped) and not IsPedSwimming(ped) and not IsPedSwimmingUnderWater(ped) and not IsPauseMenuActive() then
                        sleep = 0
                        if IsDisabledControlJustReleased(2, 36) then
                            if isCrouching then
                                ClearPedTasks(ped)
                                resetAnimSet()
                                SetPedStealthMovement(ped, false, 'DEFAULT_ACTION')
                                isCrouching = false
                            else
                                --resetAnimSet()
                                --ClearPedTasks(ped)
                                loadAnimSet('move_ped_crouched')
                                SetPedMovementClipset(ped, 'move_ped_crouched', 1.0)
                                SetPedStrafeClipset(ped, 'move_ped_crouched_strafing')
                                isCrouching = true
                            end
                        end
                    end
                    Citizen.Wait(0)
                end
            end)
        elseif Config.Crouching.KeyMapping.Enable then
            RegisterCommand('crouch', function(source, args, raw)
                local ped = PlayerPedId()
                if isCrouching then
                    ClearPedTasks(ped)
                    resetAnimSet()
                    SetPedStealthMovement(ped, false, 'DEFAULT_ACTION')
                    isCrouching = false
                else
                    --resetAnimSet()
                    --ClearPedTasks(ped)
                    loadAnimSet('move_ped_crouched')
                    SetPedMovementClipset(ped, 'move_ped_crouched', 1.0)
                    SetPedStrafeClipset(ped, 'move_ped_crouched_strafing')
                    isCrouching = true
                end
            end, false)
            RegisterKeyMapping("crouch", 'Crouch', "keyboard", Config.Crouching.KeyMapping.Key)
        end
    end
    -- Ragdoll
    if Config.Ragdoll.Enable then
        local ragdoled = false
        if Config.Ragdoll.KeyMapping.Enable then
            RegisterCommand('ragdoll', function(source, args, raw)
                if checkCanPedRagdoll() then
                    if not IsEntityDead(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), false) then 
                        ragdoled = not ragdoled
                        while ragdoled do 
                            Citizen.Wait(0)
                            if ragdoled then
                                SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
                            end
                        end
                    end
                else
                    Notify('Ragdoll is disabled.', 7500, "error")
                end
            end, false)
            RegisterKeyMapping("ragdoll", langData.keybinds.ragdoll_description, "keyboard", Config.Ragdoll.KeyMapping.Key)
        else
            Citizen.CreateThread(function() 
                while true do 
                    Citizen.Wait(0) 
                    if checkCanPedRagdoll() then
                        ragdoled = not ragdoled
                        if ragdoled then
                            SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
                        end
                    else
                        Notify('Ragdoll is disabled.', 7500, "error")
                    end
                end 
            end)
        end
    end
end)

function checkCanPedRagdoll()
    if Config.Ragdoll.ByPassCanRagdoll then SetPedCanRagdoll(PlayerPedId(), true) return true end
    return CanPedRagdoll(PlayerPedId())
end

function loadAnim(dict)
    if not DoesAnimDictExist(dict) then print("Anim dict doesn't exist.") return false end
    local timeout = 2000
    while not HasAnimDictLoaded(dict) and timeout > 0 do
        RequestAnimDict(dict)
        Wait(5)
        timeout = timeout - 5
    end
    if timeout == 0 then
        print("Loading anim dict " .. dict .. " timed out")
        return false
    else
        return true
    end
end

function RunAnimationThread()
    local playerId = PlayerPedId()
    if AnimationThreadStatus then return end
    AnimationThreadStatus = true
    CreateThread(function()
        local sleep
        while AnimationThreadStatus and (isInAnimation or PtfxPrompt) do
            sleep = 500
            if isInAnimation then
                sleep = 0
                if IsPlayerAiming(playerId) then
                    cancelEmote("0res")
                end
                DisableControlAction(2, 140, true)
                DisableControlAction(2, 141, true)
                DisableControlAction(2, 142, true)
            end
            if PtfxPrompt then
                sleep = 0
                if not PtfxNotif then
                    SimpleNotify(PtfxInfo)
                    PtfxNotif = true
                end
                if IsControlPressed(0, 47) then
                    PtfxStart()
                    Citizen.Wait(PtfxWait)
                    if PtfxCanHold then
                        while IsControlPressed(0, 47) and isInAnimation and AnimationThreadStatus do
                            Citizen.Wait(5)
                        end
                    end
                    PtfxStop()
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end

function SimpleNotify(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(true, true)
end

function IsPlayerAiming(player)
    return (IsPlayerFreeAiming(player) or IsAimCamActive() or IsAimCamThirdPersonActive()) and tonumber(GetSelectedPedWeapon(player)) ~= tonumber(GetHashKey("WEAPON_UNARMED"))
end

function PtfxThis(asset)
    while not HasNamedPtfxAssetLoaded(asset) do
        RequestNamedPtfxAsset(asset)
        Wait(10)
    end
    UseParticleFxAsset(asset)
end

function PtfxStart()
    LocalPlayer.state:set('ptfx', true, true)
end

function PtfxStop()
    LocalPlayer.state:set('ptfx', false, true)
end

AddStateBagChangeHandler('ptfx', nil, function(bagName, key, value, _unused, replicated)
    local plyId = tonumber(bagName:gsub('player:', ''), 10)
    if (PlayerParticles[plyId] and value) or (not PlayerParticles[plyId] and not value) then return end
    local ply = GetPlayerFromServerId(plyId)
    if ply == 0 then return end
    local plyPed = GetPlayerPed(ply)
    if not DoesEntityExist(plyPed) then return end
    local stateBag = Player(plyId).state
    if value then
        local asset = stateBag.ptfxAsset
        local name = stateBag.ptfxName
        local offset = stateBag.ptfxOffset
        local rot = stateBag.ptfxRot
        local boneIndex = stateBag.ptfxBone and GetPedBoneIndex(plyPed, stateBag.ptfxBone) or GetEntityBoneIndexByName(name, "VFX")
        local scale = stateBag.ptfxScale or 1
        local color = stateBag.ptfxColor
        local propNet = stateBag.ptfxPropNet
        local entityTarget = plyPed
        if propNet then
            local propObj = NetToObj(propNet)
            if DoesEntityExist(propObj) then
                entityTarget = propObj
            end
        end
        PtfxThis(asset)
        PlayerParticles[plyId] = StartNetworkedParticleFxLoopedOnEntityBone(name, entityTarget, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, boneIndex, scale + 0.0, false, false, false)
        if color then
            if color[1] and type(color[1]) == 'table' then
                local randomIndex = math.random(1, #color)
                color = color[randomIndex]
            end
            SetParticleFxLoopedAlpha(PlayerParticles[plyId], color.A)
            SetParticleFxLoopedColour(PlayerParticles[plyId], color.R / 255, color.G / 255, color.B / 255, false)
        end
    else
        StopParticleFxLooped(PlayerParticles[plyId], false)
        RemoveNamedPtfxAsset(stateBag.ptfxAsset)
        PlayerParticles[plyId] = nil
    end
end)

function addPropToPed(prop1, bone, off1, off2, off3, rot1, rot2, rot3, textureVariation, ped)
    if not ped then ped = PlayerPedId() end
    local Player = ped
    local x, y, z = table.unpack(GetEntityCoords(Player))
    if not IsModelValid(prop1) then return false end
    if not HasModelLoaded(prop1) then 
        while not HasModelLoaded(joaat(prop1)) do
            RequestModel(joaat(prop1))
            Citizen.Wait(10)
        end
    end
    prop = CreateObject(joaat(prop1), x, y, z + 0.2, true, true, true)
    if textureVariation ~= nil then
        SetObjectTextureVariation(prop, textureVariation)
    end
    AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    table.insert(pedProps, prop)
    playerHasProp = true
    SetModelAsNoLongerNeeded(prop1)
    return true
end

function destroyAllPedProps()
    for _, v in pairs(pedProps) do DeleteEntity(v) v = nil end
    playerHasProp = false
end

Citizen.CreateThread(function()
    if Config.UseSameKeyForCancelAndHandsUp then
        RegisterCommand(Config.HandsUp.Command, function(source, args, raw) cancelEmote() end, false)
        if Config.HandsUp.Enable then
            if Config.HandsUp.KeyMapping.Enable then
                RegisterKeyMapping(Config.HandsUp.Command, "Cancel current emote and hands up", "keyboard", Config.HandsUp.KeyMapping.Key)
            else
                Citizen.CreateThread(function() while true do Citizen.Wait(0) if IsControlJustReleased(0, Config.HandsUp.NormalKey.Key) then cancelEmote() end end end)
            end
        end
    else
        -- Cancel Emote
        RegisterCommand(Config.CancelEmote.Command, function(source, args, raw) cancelEmote("0resmon") end, false)
        if Config.CancelEmote.Enable then
            if Config.CancelEmote.KeyMapping.Enable then
                RegisterKeyMapping(Config.CancelEmote.Command, "Cancel current emote", "keyboard", Config.CancelEmote.KeyMapping.Key)
            else
                Citizen.CreateThread(function() while true do Citizen.Wait(0) if IsControlJustReleased(0, Config.CancelEmote.NormalKey.Key) then cancelEmote("0resmon") end end end)
            end
        end
        -- Hands Up
        RegisterCommand(Config.HandsUp.Command, function(source, args, raw) cancelEmote() end, false)
        if Config.HandsUp.Enable then
            if Config.HandsUp.KeyMapping.Enable then
                RegisterKeyMapping(Config.HandsUp.Command, "Cancel current emote and hands up", "keyboard", Config.HandsUp.KeyMapping.Key)
            else
                Citizen.CreateThread(function() while true do Citizen.Wait(0) if IsControlJustReleased(0, Config.HandsUp.NormalKey.Key) then cancelEmote() end end end)
            end
        end
    end
end)

function cancelEmote(hu)
    local shouldStopGroupAnimation = groupAnimationRunning and groupState.isOwner and not groupStopEventMuted
    if isInAnimation then
        currentAnimData = {}
        clearGroupCurrentAnimation()
        isInAnimation = false
        ClearPedTasks(PlayerPedId())
        cleanScenarioObjects(false)
        local inVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
        if not inVehicle then
            ClearPedTasksImmediately(PlayerPedId())
            ClearPedSecondaryTask(PlayerPedId())
            ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 2.0, 0)
        end
        if playerHasProp then
            for _, v in pairs(pedProps) do DeleteEntity(v) v = nil end
            playerHasProp = false
        end
        if lastPlayedAnimType == "posAnim" or animPosUsed then
            FreezeEntityPosition(PlayerPedId(), false)
            SetEntityCollision(PlayerPedId(), true, true)
            animPosUsed = false
            if animPosOldCoords and Config.TeleportBackAfterPlacedCancelled then
                SetEntityCoords(PlayerPedId(), animPosOldCoords.x, animPosOldCoords.y, animPosOldCoords.z)
            end
        end
        if lastPlayedAnimType == "synced" then
            if IsEntityPositionFrozen(PlayerPedId()) then
                FreezeEntityPosition(PlayerPedId(), false)
            end
            if GetEntityCollisionDisabled(PlayerPedId()) then
                SetEntityCollision(PlayerPedId(), true, true)
            end
            local targetPed
            if syncedTarget then
                targetPed = GetPlayerPed(GetPlayerFromServerId(syncedTarget))
                TriggerServerEvent('0resmon-animmenu:cancelEmote:server', syncedTarget)
            end
            if IsEntityAttachedToAnyPed(PlayerPedId()) or (targetPed and IsEntityAttachedToEntity(PlayerPedId(), targetPed)) then
                DetachEntity(PlayerPedId(), false, false)
            end
        end
        if lastPlayedAnimType == "gang" then
            removeAllPropsGang()
            SendNUIMessage({action = "openGangInfoMenu", state = false})
        end
        lastPlayedAnimType = nil
        AnimationThreadStatus = false
        PtfxNotif = false
        PtfxPrompt = false
        if groupAnimationRunning and not groupStopEventMuted then
            setGroupAnimationRunning(false)
        end
        if shouldStopGroupAnimation then
            TriggerServerEvent('0resmon-animmenu:groupStopAnim:server')
        end
    else
        if groupAnimationRunning and not groupStopEventMuted then
            clearGroupCurrentAnimation()
            setGroupAnimationRunning(false)
            if shouldStopGroupAnimation then
                TriggerServerEvent('0resmon-animmenu:groupStopAnim:server')
            end
            if hu then return end
        end
        if not hu then
            if Config.CanHandsup() and Config.HandsUp.Enable then
                if not HasAnimDictLoaded('missminuteman_1ig_2') then
                    RequestAnimDict('missminuteman_1ig_2')
                    while not HasAnimDictLoaded('missminuteman_1ig_2') do
                        Citizen.Wait(10)
                    end
                end
                handsUp = not handsUp
                if handsUp then
                    Config.HandsupDisableControls()
                    TaskPlayAnim(PlayerPedId(), 'missminuteman_1ig_2', 'handsup_base', 8.0, 8.0, -1, 50, 0, false, false, false)
                else
                    Config.HandsupEnableControls()
                    ClearPedTasks(PlayerPedId())
                end
            end
        end
    end
end

local scenarioObjects = {
    `p_amb_coffeecup_01`,
    `p_amb_joint_01`,
    `p_cs_ciggy_01`,
    `p_cs_ciggy_01b_s`,
    `p_cs_clipboard`,
    `prop_curl_bar_01`,
    `p_cs_joint_01`,
    `p_cs_joint_02`,
    `prop_acc_guitar_01`,
    `prop_amb_ciggy_01`,
    `prop_amb_phone`,
    `prop_beggers_sign_01`,
    `prop_beggers_sign_02`,
    `prop_beggers_sign_03`,
    `prop_beggers_sign_04`,
    `prop_bongos_01`,
    `prop_cigar_01`,
    `prop_cigar_02`,
    `prop_cigar_03`,
    `prop_cs_beer_bot_40oz_02`,
    `prop_cs_paper_cup`,
    `prop_cs_trowel`,
    `prop_fib_clipboard`,
    `prop_fish_slice_01`,
    `prop_fishing_rod_01`,
    `prop_fishing_rod_02`,
    `prop_notepad_02`,
    `prop_parking_wand_01`,
    `prop_rag_01`,
    `prop_scn_police_torch`,
    `prop_sh_cigar_01`,
    `prop_sh_joint_01`,
    `prop_tool_broom`,
    `prop_tool_hammer`,
    `prop_tool_jackham`,
    `prop_tennis_rack_01`,
    `prop_weld_torch`,
    `w_me_gclub`,
    `p_amb_clipboard_01`
}

function cleanScenarioObjects(isClone)
    local ped = isClone and ClonedPed or PlayerPedId()
    local playerCoords = GetEntityCoords(ped)
    for i = 1, #scenarioObjects do
        local deleteScenarioObject = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 1.0, scenarioObjects[i], false, true, true)
        if DoesEntityExist(deleteScenarioObject) then
            SetEntityAsMissionEntity(deleteScenarioObject, false, false)
            DeleteObject(deleteScenarioObject)
        end
    end
end

Citizen.CreateThread(function()
    local startTime = GetGameTimer()
    while not CoreReady do 
        Citizen.Wait(100)
        if GetGameTimer() - startTime > 5000 then
            break
        end
    end
    while not next(GetPlayerData()) do
        Citizen.Wait(100)
        if GetGameTimer() - startTime > 5000 then
            break
        end
    end
    applyWalkAndExpression()
end)

Citizen.CreateThread(function()
    while not CoreReady do Citizen.Wait(1000) end
    if CoreName == "es_extended" then
        RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
            applyWalkAndExpression()
        end)
    elseif CoreName == "qb-core" or CoreName == "qbx_core" then
        while not next(GetPlayerData()) do Citizen.Wait(0) end
        RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
            applyWalkAndExpression()
        end)
    end
end)

function applyWalkAndExpression()
    TriggerCallback('0r-animmenu:GetPlayerCid:server', function(cid)
        if cid then
            local walk = GetResourceKvpString("0ranimmenuv2walk" .. cid)
            local walkName = GetResourceKvpString("0ranimmenuv2walkname" .. cid)
            if walk ~= nil then
                Citizen.Wait(2500)
                RequestAnimSet(walk)
                while not HasAnimSetLoaded(walk) do Citizen.Wait(1) end
                SetPedMovementClipset(PlayerPedId(), walk, 0.2)
                -- RemoveAnimSet(walk)
                walkSet = walkName
            end
            local expression = GetResourceKvpString("0ranimmenuv2expression")
            if expression ~= nil then
                Citizen.Wait(2500)
                SetFacialIdleAnimOverride(PlayerPedId(), expression, 0)
            end
        else
            local walk = GetResourceKvpString("0ranimmenuv2walk")
            local walkName = GetResourceKvpString("0ranimmenuv2walkname")
            if walk ~= nil then
                Citizen.Wait(2500)
                RequestAnimSet(walk)
                while not HasAnimSetLoaded(walk) do Citizen.Wait(1) end
                SetPedMovementClipset(PlayerPedId(), walk, 0.2)
                -- RemoveAnimSet(walk)
                walkSet = walkName
            end
            local expression = GetResourceKvpString("0ranimmenuv2expression")
            if expression ~= nil then
                Citizen.Wait(2500)
                SetFacialIdleAnimOverride(PlayerPedId(), expression, 0)
            end
        end
    end)
end

RegisterCommand('eclone', function(source, args, raw) EmoteCommandStart(source, args, raw, "clone") end, false) -- Don't delete, edit, use
RegisterCommand('e', function(source, args, raw) EmoteCommandStart(source, args, raw) end, false)
RegisterCommand('emote', function(source, args, raw) EmoteCommandStart(source, args, raw) end, false)

function EmoteCommandStart(source, args, raw, type)
    if #args > 0 then
        if isInAnimation and type ~= "clone" then
            cancelEmote("0res")
        end
        local name = string.lower(args[1])
        if name == "c" then
            if isInAnimation then
                cancelEmote("0res")
            else
                Notify(langData.notifications.no_emote_to_cancel, 7500, "error")
            end
            return
        end
        Citizen.Wait(500)
        if RES2.General[name] ~= nil then
            OnEmotePlay(name, "general", type)
            return
        elseif RES2.Dances[name] ~= nil then
            OnEmotePlay(name, "dances", type)
            return
        elseif RES2.Expressions[name] ~= nil then
            OnEmotePlay(name, "expressions", type)
            return
        elseif RES2.Walks[name] ~= nil then
            OnEmotePlay(name, "walks", type)
            return
        elseif RES2.PlacedEmotes[name] ~= nil then
            OnEmotePlay(name, "placedemotes", type)
            return
        elseif RES2.PropEmotes[name] ~= nil then
            OnEmotePlay(name, "propemotes", type)
            return
        elseif RES2.Shared[name] ~= nil then
            OnEmotePlay(name, "shared", type)
            return
        elseif RES2.EEmotes[name] ~= nil then
            OnEmotePlay(name, "eemotes", type)
            return
        elseif RES2.Gang[name] ~= nil then
            OnEmotePlay(name, "gang", type)
            return
        else
            Notify(name .. " is not a valid emote.", 7500, "error")
        end
    end
end

function OnEmotePlay(name, category, type)
    if type == "quicks" then
        local name2 = getAnimNameFromImageId(name)
        if name2 then name = name2 end
    end
    removeAllPropsGang()
    local ped = PlayerPedId()
    if type == "clone" then ped = myClone end
    if not Config.CanOpenMenu(GetPlayerServerId(PlayerId())) then return end
    if IsEntityInAir(ped) then
        return
    end
    if category == "propemotes" then
        if propEmoteTimeout then return end
        propEmoteTimeout = true
        SendNUIMessage({action = "propTimeout", state = true})
        Citizen.SetTimeout(Config.PropTimeout, function()
            propEmoteTimeout = false
            SendNUIMessage({action = "propTimeout", state = false})
        end)
    end
    if type ~= "clone" then
        cancelEmote("0res")
    end
    if currentAnimData and next(currentAnimData) then
        for k, v in pairs(currentAnimData) do
            if v.id == name then
                cancelEmote("0res")
            end
        end
    end
    local tables = {
        ["general"] = {name = "General", dict = 1, anim = 2},
        ["extra"] = {name = "Extra", dict = 1, anim = 2},
        ["propemotes"] = {name = "PropEmotes", dict = 1, anim = 2},
        ["dances"] = {name = "Dances", dict = 1, anim = 2},
        ["expressions"] = {name = "Expressions", dict = 2},
        ["walks"] = {name = "Walks", dict = 1},
        ["placedemotes"] = {name = "PlacedEmotes", dict = 1, anim = 2},
        ["shared"] = {name = "Shared", targetName = 4, dict = 1, anim = 2},
        ["eemotes"] = {name = "EEmotes", targetName = 4, dict = 1, anim = 2},
        ["animalemotes"] = {name = "AnimalEmotes", dict = 1, anim = 2},
        ["gang"] = {name = "Gang", dict = 1, anim = 2},
    }
    local tableData = tables[category]
    local animData = RES2[tableData.name][name]
    local inVehicle = IsPedInAnyVehicle(ped, true)
    lastPlayedAnimType = nil
    if animData == nil then return print("Anim doesn't exist: " .. tableData.name .. "(" .. category .. ")") end
    local cAnimData = {animData = animData, category = category, id = name}
    -- if type ~= "clone" then
    --     table.insert(currentAnimData, cAnimData)
    -- end
    if category == "animalemotes" then
        local isPedAnimal = false
        local myPed = GetEntityModel(ped)
        for k, v in pairs(Config.AnimalPeds) do
            if myPed == GetHashKey(v) then
                isPedAnimal = true
            end
        end
        Citizen.Wait(500)
        if not isPedAnimal then
            return Notify(langData.notifications.just_animals, 7500, "error")
        end
    end
    if type ~= "clone" then
        setGroupCurrentAnimation(name, category)
    end
    if category == "general" or category == "propemotes" or category == "animalemotes" or category == "extra" or category == "gang" then
        lastPlayedAnimType = category
        local heading = GetEntityHeading(PlayerPedId())
        isInAnimation = true
        if animData.AnimationOptions and animData.AnimationOptions.Scenario or animData[1] == "Scenario" then
            if inVehicle then return end
            ClearPedTasks(ped)
            TaskStartScenarioInPlace(ped, animData[2], 0, true)
            cleanScenarioObjects(false)
            table.insert(currentAnimData, cAnimData)
        else
            if not loadAnim(animData[tableData.dict]) then return end
            table.insert(currentAnimData, cAnimData)
            local movementType = 1 -- Default movement type
            if animData.AnimationOptions then
                if animData.AnimationOptions.onFootFlag then
                    movementType = animData.AnimationOptions.onFootFlag
                elseif animData.AnimationOptions.EmoteMoving then
                    movementType = 51
                elseif animData.AnimationOptions.EmoteLoop then
                    movementType = 1
                elseif animData.AnimationOptions.EmoteStuck then
                    movementType = 50
                end
            else
                if inVehicle == 1 then
                    movementType = 51
                end
            end
            if inVehicle == 1 then
                movementType = 51
            end
            local animationDuration = -1
            if animData.AnimationOptions and (animData.AnimationOptions.Duration or animData.AnimationOptions.EmoteDuration) then
                animationDuration = animData.AnimationOptions.Duration or animData.AnimationOptions.EmoteDuration
            end
            if animData.AnimationOptions and animData.AnimationOptions.PtfxAsset then
                PtfxAsset = animData.AnimationOptions.PtfxAsset
                PtfxName = animData.AnimationOptions.PtfxName
                if animData.AnimationOptions.PtfxNoProp then
                    PtfxNoProp = animData.AnimationOptions.PtfxNoProp
                else
                    PtfxNoProp = false
                end
                Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, PtfxScale = table.unpack(animData.AnimationOptions.PtfxPlacement)
                PtfxBone = animData.AnimationOptions.PtfxBone
                PtfxColor = animData.AnimationOptions.PtfxColor
                PtfxInfo = animData.AnimationOptions.PtfxInfo
                PtfxWait = animData.AnimationOptions.PtfxWait
                PtfxCanHold = animData.AnimationOptions.PtfxCanHold
                PtfxNotif = false
                PtfxPrompt = true
                RunAnimationThread()
                TriggerServerEvent("0resmon-animmenu:ptfxSync:server", PtfxAsset, PtfxName, vector3(Ptfx1, Ptfx2, Ptfx3), vector3(Ptfx4, Ptfx5, Ptfx6), PtfxBone, PtfxScale, PtfxColor)
            else
                PtfxPrompt = false
            end
            TaskPlayAnim(ped, animData[tableData.dict], animData[tableData.anim], 5.0, 5.0, animationDuration, movementType, 0, false, false, false)
            RemoveAnimDict(animData[tableData.dict])
            if animData.AnimationOptions and animData.AnimationOptions.Prop then
                local propName = animData.AnimationOptions.Prop
                local propBone = animData.AnimationOptions.PropBone
                local propPl1, propPl2, propPl3, propPl4, propPl5, propPl6 = table.unpack(animData.AnimationOptions.PropPlacement)
                if animData.AnimationOptions.Prop2 then
                    secondPropName = animData.AnimationOptions.Prop2
                    secondPropBone = animData.AnimationOptions.Prop2Bone
                    secondPropPl1, secondPropPl2, secondPropPl3, secondPropPl4, secondPropPl5, secondPropPl6 = table.unpack(animData.AnimationOptions.Prop2Placement)
                    secondPropEmote = true
                else
                    secondPropEmote = false
                end
                if animData.AnimationOptions.SecondProp then
                    secondPropName = animData.AnimationOptions.SecondProp
                    secondPropBone = animData.AnimationOptions.SecondPropBone
                    secondPropPl1, secondPropPl2, secondPropPl3, secondPropPl4, secondPropPl5, secondPropPl6 = table.unpack(animData.AnimationOptions.SecondPropPlacement)
                    secondPropEmote = true
                else
                    secondPropEmote = false
                end
                if not addPropToPed(propName, propBone, propPl1, propPl2, propPl3, propPl4, propPl5, propPl6, nil) then return end
                if secondPropEmote then
                    if not addPropToPed(secondPropName, secondPropBone, secondPropPl1, secondPropPl2, secondPropPl3, secondPropPl4, secondPropPl5, secondPropPl6, nil) then
                        destroyAllPedProps()
                        return
                    end
                end
                if animData.AnimationOptions.PtfxAsset and not PtfxNoProp then
                    TriggerServerEvent("0resmon-animmenu:ptfxSyncProp:server", ObjToNet(prop))
                end
            end
            if category == "gang" and animData.AnimationOptions and animData.AnimationOptions.fixHeading then
                while not IsEntityPlayingAnim(PlayerPedId(), animData[tableData.dict], animData[tableData.anim], movementType) do Citizen.Wait(0) end
                SetEntityHeading(PlayerPedId(), heading + 180.0)
                SendNUIMessage({action = "openGangInfoMenu", state = true})
            elseif category == "gang" then
                SendNUIMessage({action = "openGangInfoMenu", state = true})
            end
        end
    elseif category == "dances" then
        if not loadAnim(animData[tableData.dict]) then return end
        table.insert(currentAnimData, cAnimData)
        local movementType = 1
        local animationDuration = -1
        TaskPlayAnim(ped, animData[tableData.dict], animData[tableData.anim], 5.0, 5.0, animationDuration, movementType, 0, false, false, false)
        RemoveAnimDict(animData[tableData.dict])
        isInAnimation = true
        if animData.AnimationOptions and animData.AnimationOptions.Prop then
            local propName = animData.AnimationOptions.Prop
            local propBone = animData.AnimationOptions.PropBone
            local propPl1, propPl2, propPl3, propPl4, propPl5, propPl6 = table.unpack(animData.AnimationOptions.PropPlacement)
            if animData.AnimationOptions.Prop2 then
                secondPropName = animData.AnimationOptions.Prop2
                secondPropBone = animData.AnimationOptions.Prop2Bone
                secondPropPl1, secondPropPl2, secondPropPl3, secondPropPl4, secondPropPl5, secondPropPl6 = table.unpack(animData.AnimationOptions.Prop2Placement)
                secondPropEmote = true
            else
                secondPropEmote = false
            end
            if animData.AnimationOptions.SecondProp then
                secondPropName = animData.AnimationOptions.SecondProp
                secondPropBone = animData.AnimationOptions.SecondPropBone
                secondPropPl1, secondPropPl2, secondPropPl3, secondPropPl4, secondPropPl5, secondPropPl6 = table.unpack(animData.AnimationOptions.SecondPropPlacement)
                secondPropEmote = true
            else
                secondPropEmote = false
            end
            if not addPropToPed(propName, propBone, propPl1, propPl2, propPl3, propPl4, propPl5, propPl6, nil) then return end
            if secondPropEmote then
                if not addPropToPed(secondPropName, secondPropBone, secondPropPl1, secondPropPl2, secondPropPl3, secondPropPl4, secondPropPl5, secondPropPl6, nil) then
                    destroyAllPedProps()
                    return
                end
            end
            if animData.AnimationOptions.PtfxAsset and not PtfxNoProp then
                TriggerServerEvent("0resmon-animmenu:ptfxSyncProp:server", ObjToNet(prop))
            end
        end
    elseif category == "expressions" then
        local expression = animData[tableData.dict]
        ClearFacialIdleAnimOverride(PlayerPedId())
        SetFacialIdleAnimOverride(PlayerPedId(), expression, 0)
        SetResourceKvp("0ranimmenuv2expression", expression)
    elseif category == "walks" then
        local walk = animData[tableData.dict]
        local name = animData[tableData.aname]
        walkSet = name
        ResetPedMovementClipset(ped, 1.0)
        ResetPedWeaponMovementClipset(ped)
        ResetPedStrafeClipset(ped)
        RequestAnimSet(walk)
        while not HasAnimSetLoaded(walk) do Citizen.Wait(1) end
        SetPedMovementClipset(ped, walk, 0.2)
        RemoveAnimSet(walk)
        TriggerCallback('0r-animmenu:GetPlayerCid:server', function(cid)
            if cid then
                SetResourceKvp("0ranimmenuv2walk" .. cid, walk)
                SetResourceKvp("0ranimmenuv2walkname" .. cid, walkSet)
            else
                SetResourceKvp("0ranimmenuv2walk", walk)
                SetResourceKvp("0ranimmenuv2walkname", walkSet)
            end
        end)
    elseif category == "placedemotes" then
        lastPlayedAnimType = "posAnim"
        isInAnimation = true
        if inVehicle then return end
        if not loadAnim(animData[tableData.dict]) then return end
        table.insert(currentAnimData, cAnimData)
        local movementType = 1 -- Default movement type
        local animationDuration = -1
        TaskPlayAnim(ped, animData[tableData.dict], animData[tableData.anim], 5.0, 5.0, animationDuration, movementType, 0, false, false, false)
        RemoveAnimDict(animData[tableData.dict])
    elseif category == "shared" or category == "eemotes" then
        if requestActive then return end
        if inVehicle then return end
        nearbyPlayers = GetPlayersInArea(GetEntityCoords(PlayerPedId()), 5.0)
        if next(nearbyPlayers) ~= nil and next(nearbyPlayers) then
            menuActive = false
            SetNuiFocusKeepInput(false)
            SetNuiFocus(false, false)
            SendNUIMessage({action = "menu", state = false})
            requestActive = true
            ShowTextUI(langData.notifications.waiting_for_a_decision, "ESC")
            animData.type = category
            animData.animNumber = name
            animData.targetAnimName = animData[4] or nil
            -- Universal imageId data (language-independent)
            animData.senderImageId = animData.imageId
            animData.targetImageId2 = animData.targetImageId
            embedSyncedRequestEntries(animData, category)
            for _, id in pairs(nearbyPlayers) do
                Create3DTextUIOnPlayer("0resmon-animmenu-request-players-" .. id, {
                    id = id,
                    displayDist = 5.0,
                    interactDist = 1.3,
                    enableKeyClick = true, -- If true when you near it and click key it will trigger the event that you write inside triggerData
                    keyNum = 38,
                    key = "E",
                    text = animData[3] .. "?",
                    theme = "green", -- or red
                    triggerData = {
                        triggerName = "0resmon-animmenu:sendAnimRequest:client",
                        args = {data = animData, id = id}
                    }
                })
            end
            Citizen.CreateThread(function()
                while requestActive do
                    Citizen.Wait(0)
                    if IsControlPressed(0, 322) then
                        Notify(langData.notifications.request_cancelled, 7500, "error")
                        requestActive = false
                        currentAnimData = {}
                        HideTextUI()
                        for _, id in pairs(nearbyPlayers) do
                            Delete3DTextUIOnPlayer("0resmon-animmenu-request-players-" .. id)
                        end
                        break
                    end
                end
            end)
            Citizen.SetTimeout(7500, function()
                if next(nearbyPlayers) ~= nil and next(nearbyPlayers) and requestActive then
                    Notify(langData.notifications.request_timed_out, 7500, "error")
                    requestActive = false
                    currentAnimData = {}
                    HideTextUI()
                    for _, id in pairs(nearbyPlayers) do
                        Delete3DTextUIOnPlayer("0resmon-animmenu-request-players-" .. id)
                    end
                end
            end)
        else
            Notify(langData.notifications.no_players_nearby, 7500, "error")
        end
    end
end

RegisterNetEvent('0r-animmenu:EmoteCommandStart:client', function(data)
    if type(data) == "string" then
        EmoteCommandStart(nil, {data, nil}, nil)
    else
        EmoteCommandStart(nil, {data[1], nil}, nil)
    end
end)

RegisterNetEvent('animations:client:EmoteCommandStart', function(data)
    if type(data) == "string" then
        EmoteCommandStart(nil, {data, nil}, nil)
    else
        EmoteCommandStart(nil, {data[1], nil}, nil)
    end
end)

exports("EmoteCommandStart", function(emoteName) EmoteCommandStart(nil, {emoteName, nil}, nil) end)
exports("EmoteCancel", cancelEmote("0res"))
exports('IsPlayerInAnim', function() return isInAnimation end)

RegisterCommand('resetquicks', function()
    SetResourceKvp("0ranimmenuquicksv2_new2", json.encode({}))
    SendNUIMessage({action = "resetQuicks"})
end)

function setQuickKeys()
    for i = 1, 7 do
        for k, v in pairs(quickAnimations) do
            if tonumber(v.slot) == i then
                if v.key and string.match(v.key, "NUM") then
                    local keyLoop = false
                    RegisterCommand('quickanim', function(source, args, raw)
                        if not keyLoop then
                            keyLoop = true
                            Citizen.CreateThread(function()
                                while keyLoop do
                                    Citizen.Wait(0)
                                    if IsControlPressed(0, Config.NumKeys[1].Key) or IsDisabledControlPressed(0, Config.NumKeys[1].Key) then -- 1
                                        local anim = getQuickAnimOnSlot(1) 
                                        if anim then
                                            OnEmotePlay(anim.name, anim.category)
                                        else
                                            Config.Notify(string.format(langData.notifications.quick_slot_empty, 1), 7500, "error")
                                        end
                                        keyLoop = false
                                        break
                                    end
                                    if IsControlPressed(0, Config.NumKeys[2].Key) or IsDisabledControlPressed(0, Config.NumKeys[2].Key) then -- 2
                                        local anim = getQuickAnimOnSlot(2) 
                                        if anim then
                                            OnEmotePlay(anim.name, anim.category)
                                        else
                                            Config.Notify(string.format(langData.notifications.quick_slot_empty, 2), 7500, "error")
                                        end
                                        keyLoop = false
                                        break
                                    end
                                    if IsControlPressed(0, Config.NumKeys[3].Key) or IsDisabledControlPressed(0, Config.NumKeys[3].Key) then -- 3
                                        local anim = getQuickAnimOnSlot(3) 
                                        if anim then
                                            OnEmotePlay(anim.name, anim.category)
                                        else
                                            Config.Notify(string.format(langData.notifications.quick_slot_empty, 3), 7500, "error")
                                        end
                                        keyLoop = false
                                        break
                                    end
                                    if IsControlPressed(0, Config.NumKeys[4].Key) or IsDisabledControlPressed(0, Config.NumKeys[4].Key) then -- 4
                                        local anim = getQuickAnimOnSlot(4) 
                                        if anim then
                                            OnEmotePlay(anim.name, anim.category)
                                        else
                                            Config.Notify(string.format(langData.notifications.quick_slot_empty, 4), 7500, "error")
                                        end
                                        keyLoop = false
                                        break
                                    end
                                    if IsControlPressed(0, Config.NumKeys[5].Key) or IsDisabledControlPressed(0, Config.NumKeys[5].Key) then -- 5
                                        local anim = getQuickAnimOnSlot(5) 
                                        if anim then
                                            OnEmotePlay(anim.name, anim.category)
                                        else
                                            Config.Notify(string.format(langData.notifications.quick_slot_empty, 5), 7500, "error")
                                        end
                                        keyLoop = false
                                        break
                                    end
                                    if IsControlPressed(0, Config.NumKeys[6].Key) or IsDisabledControlPressed(0, Config.NumKeys[6].Key) then -- 6
                                        local anim = getQuickAnimOnSlot(6) 
                                        if anim then
                                            OnEmotePlay(anim.name, anim.category)
                                        else
                                            Config.Notify(string.format(langData.notifications.quick_slot_empty, 6), 7500, "error")
                                        end
                                        keyLoop = false
                                        break
                                    end
                                    if IsControlPressed(0, Config.NumKeys[7].Key) or IsDisabledControlPressed(0, Config.NumKeys[7].Key) then -- 7
                                        local anim = getQuickAnimOnSlot(7)
                                        if anim then
                                            OnEmotePlay(anim.name, anim.category)
                                        else
                                            Config.Notify(string.format(langData.notifications.quick_slot_empty, 7), 7500, "error")
                                        end
                                        keyLoop = false
                                        break
                                    end
                                end
                            end)
                            Citizen.Wait(1000)
                            keyLoop = false
                        end
                    end, false)
                    RegisterKeyMapping("quickanim", 'Play quick emote', "keyboard", Config.QuickPrimaryKey)
                elseif v.key then
                    RegisterKeyMapping('animquickslot-' .. i .. '-' .. v.key, "Plays quick emote.", "keyboard", '')
                    RegisterKeyMapping('animquickslot-' .. i .. '-' .. v.key, "Plays quick emote.", "keyboard", v.key)
                    RegisterCommand('animquickslot-' .. i .. '-' .. v.key, function()
                        local anim = getQuickAnimOnSlot(i) 
                        if anim then
                            OnEmotePlay(anim.imageId, anim.category, "quicks")
                        end
                    end)
                end
            end
        end
    end
end

function getQuickAnimOnSlot(slot)
    for k, v in pairs(quickAnimations) do
        if tonumber(v.slot) == slot then
            return v
        end
    end
    return nil
end

RegisterNetEvent('0resmon-animmenu:groupState:client', function(state)
    groupState = state or groupState
    if not groupState.inGroup then
        setGroupAnimationRunning(false)
    end
    sendGroupStateToNui()
end)

RegisterNetEvent('0resmon-animmenu:groupNotify:client', function(message, notifyType)
    Notify(groupText(message, message), 7500, notifyType or "error")
end)

RegisterNetEvent('0resmon-animmenu:groupSelectInviteTarget:client', function(data)
    if not groupInviteSelectActive then return end
    local target = data and data.id
    if not target then return end
    clearGroupInviteSelection()
    TriggerServerEvent('0resmon-animmenu:groupInvite:server', target)
end)

RegisterNetEvent('0resmon-animmenu:groupInviteReceived:client', function(data)
    if not data or not data.owner then return end
    clearGroupInviteReceive(false)
    groupInviteReceiveActive = true
    groupInviteReceiveOwner = tonumber(data.owner)
    groupInviteReceiveToken = groupInviteReceiveToken + 1
    local token = groupInviteReceiveToken
    local timeout = tonumber(data.timeout) or getGroupInviteTimeout()
    ShowTextUI(groupText("group_invite_received", "Group invite. Accept"), "ESC")
    Create3DTextUIOnPlayer("0resmon-animmenu-group-invite-owner-" .. groupInviteReceiveOwner, {
        id = groupInviteReceiveOwner,
        displayDist = getGroupInviteDistance(),
        interactDist = 1.3,
        enableKeyClick = true,
        keyNum = 38,
        key = "E",
        text = groupText("group_invite_received", "Group invite. Accept"),
        theme = "green",
        triggerData = {
            triggerName = "0resmon-animmenu:groupAcceptInvite:client",
            args = {owner = groupInviteReceiveOwner}
        }
    })

    Citizen.CreateThread(function()
        while groupInviteReceiveActive and groupInviteReceiveToken == token do
            Citizen.Wait(0)
            if IsControlPressed(0, 322) then
                Notify(groupText("group_invite_cancelled", "Group invite cancelled."), 7500, "error")
                clearGroupInviteReceive(true)
                break
            end
        end
    end)

    Citizen.SetTimeout(timeout, function()
        if groupInviteReceiveActive and groupInviteReceiveToken == token then
            Notify(groupText("request_timed_out", "Request timed out."), 7500, "error")
            clearGroupInviteReceive(true)
        end
    end)
end)

RegisterNetEvent('0resmon-animmenu:groupAcceptInvite:client', function(data)
    if not groupInviteReceiveActive then return end
    local owner = data and data.owner
    if not owner then return end
    clearGroupInviteReceive(false)
    TriggerServerEvent('0resmon-animmenu:groupAcceptInvite:server', owner)
end)

local function resolveGroupAnimationId(data)
    if not data then return nil end
    if data.imageId then
        local name = getAnimNameFromImageId(data.imageId, data.category)
        if name then return name end
    end
    return data.id
end

local function preloadGroupAnimation(data)
    local tables = {
        ["general"] = {name = "General", dict = 1},
        ["extra"] = {name = "Extra", dict = 1},
        ["propemotes"] = {name = "PropEmotes", dict = 1},
        ["dances"] = {name = "Dances", dict = 1},
        ["placedemotes"] = {name = "PlacedEmotes", dict = 1},
        ["animalemotes"] = {name = "AnimalEmotes", dict = 1},
        ["gang"] = {name = "Gang", dict = 1}
    }
    local tableData = tables[data.category]
    if not tableData or not RES2[tableData.name] then return end
    local animId = resolveGroupAnimationId(data)
    local animData = animId and RES2[tableData.name][animId]
    if not animData then return end
    if animData.AnimationOptions and animData.AnimationOptions.Scenario or animData[1] == "Scenario" then
        return true
    end
    return loadAnim(animData[tableData.dict])
end

RegisterNetEvent('0resmon-animmenu:groupPrepareAnim:client', function(data)
    if not data or not data.sessionId then return end
    preloadGroupAnimation(data)
    TriggerServerEvent('0resmon-animmenu:groupAnimReady:server', data.sessionId)
end)

RegisterNetEvent('0resmon-animmenu:groupStartAnim:client', function(data)
    local animId = resolveGroupAnimationId(data)
    if not animId then return end
    groupStopEventMuted = true
    OnEmotePlay(animId, data.category, "group")
    groupStopEventMuted = false
    setGroupAnimationRunning(isInAnimation)
end)

RegisterNetEvent('0resmon-animmenu:groupStopAnim:client', function()
    stopLocalGroupAnimation()
end)

RegisterNetEvent('0resmon-animmenu:groupPlayAnim:client', function(data)
    TriggerEvent('0resmon-animmenu:groupStartAnim:client', data)
end)

RegisterNetEvent('0resmon-animmenu:setPedAlpha:server', function(id, alpha)
    local targetPlayer = GetPlayerFromServerId(id)
    if targetPlayer == -1 then return end
    local ped = GetPlayerPed(targetPlayer)
    if DoesEntityExist(ped) then
        SetEntityAlpha(ped, alpha, false)
    end
end)

RegisterNetEvent('0resmon-animmenu:sendAnimRequest:client', function(data)
    data.target = GetPlayerServerId(PlayerId())
    if next(nearbyPlayers) ~= nil and next(nearbyPlayers) and requestActive then
        requestActive = false
        HideTextUI()
        for _, id in pairs(nearbyPlayers) do
            Delete3DTextUIOnPlayer("0resmon-animmenu-request-players-" .. id)
        end
    end
    TriggerServerEvent('0resmon-animmenu:sendAnimRequest:server', data)
end)

local requestReceiveActive = false
RegisterNetEvent('0resmon-animmenu:receiveAnimRequest:client', function(data)
    requestReceiveActive = true
    ShowTextUI(langData.notifications.waiting_for_a_decision, "ESC")
    Create3DTextUIOnPlayer("0resmon-animmenu-request-player-" .. data.target, {
        id = data.target,
        displayDist = 5.0,
        interactDist = 1.3,
        enableKeyClick = true, -- If true when you near it and click key it will trigger the event that you write inside triggerData
        keyNum = 38,
        key = "E",
        text = (RES2.SharedByImageId[data.data.senderImageId] and RES2.SharedByImageId[data.data.senderImageId][3] or data.data[3]) .. "?",
        theme = "green", -- or red
        triggerData = {
            triggerName = "0resmon-animmenu:playAnimTogetherReceiver:client",
            args = {data = data}
        }
    })
    Citizen.CreateThread(function()
        while requestReceiveActive do
            Citizen.Wait(0)
            if IsControlPressed(0, 322) then
                Notify(langData.notifications.request_cancelled, 7500, "error")
                requestReceiveActive = false
                HideTextUI()
                Delete3DTextUIOnPlayer("0resmon-animmenu-request-player-" .. data.target)
                TriggerServerEvent('0resmon-animmenu:requstCanelledNotif:server', data.target)
                break
            end
        end
    end)
    Citizen.SetTimeout(7500, function()
        if requestReceiveActive then
            requestReceiveActive = false
            HideTextUI()
            Delete3DTextUIOnPlayer("0resmon-animmenu-request-player-" .. data.target)
            Notify(langData.notifications.request_timed_out, 7500, "error")
        end
    end)
end)

local syncedAnimDictLoaded = false
RegisterNetEvent('0resmon-animmenu:animDictLoaded:client', function()
    syncedAnimDictLoaded = true
end)

local syncedStartGo = false
RegisterNetEvent('0resmon-animmenu:syncStartGo:client', function()
    syncedStartGo = true
end)

local function waitForSyncStartGo(timeoutMs)
    local waitStart = GetGameTimer()
    while not syncedStartGo and (GetGameTimer() - waitStart) < (timeoutMs or 3000) do
        Citizen.Wait(0)
    end
    syncedStartGo = false
end

RegisterNetEvent('0resmon-animmenu:playAnimTogetherReceiver:client', function(data)
    requestReceiveActive = false
    requestActive = false
    lastPlayedAnimType = "synced"
    syncedTarget = data.data.target
    if data.target then
        syncedTarget = data.target
    end
    HideTextUI()
    Delete3DTextUIOnPlayer("0resmon-animmenu-request-player-" .. data.data.target)
    local inVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
    if inVehicle then return end
    syncedStartGo = false
    TriggerServerEvent('0resmon-animmenu:playAnimTogetherSender:server', data)
    -- Anim Opt.
    local targetPed = GetPlayerPed(GetPlayerFromServerId(syncedTarget))
    local animData = {}
    if data.data.data then 
        animData = data.data.data
    elseif data.data then
        animData = data.data
    end
    -- Anim
    -- Prefer the embedded entry from the sender's payload (works across
    -- languages and for custom emotes without imageId). Fall back to local
    -- RES2 lookup for backwards compatibility.
    local d = data.data.data or data.data
    local receiverEntry = d.receiverEntry
    if not receiverEntry or not receiverEntry[1] then
        receiverEntry = RES2.SharedByImageId[d.targetImageId2] or RES2["Shared"][d.targetAnimName] or RES2["EEmotes"][d.targetAnimName] or {}
    end
    local animDict = receiverEntry[1]
    local animName = receiverEntry[2]
    local animOptions = receiverEntry.AnimationOptions
    if not loadAnim(animDict) then return end
    local movementType = 1
    if animOptions then
        if animOptions.onFootFlag then
            movementType = animOptions.onFootFlag
        elseif animOptions.EmoteMoving then
            movementType = 51
        elseif animOptions.EmoteLoop then
            movementType = 1
        elseif animOptions.EmoteStuck then
            movementType = 50
        end
        -- if movementType ~= Config.AnimFlagNumbers.Moving then
        --     FreezeEntityPosition(PlayerPedId(), true)
        -- end
    end
    -- if receiver then
    --     if receiver.AnimationOptions then
    --         if receiver.AnimationOptions.Attachto then
    --             AttachEntityToEntity(
    --                 PlayerPedId(),
    --                 targetPed,
    --                 GetPedBoneIndex(targetPed, receiver.AnimationOptions.bone or -1),
    --                 receiver.AnimationOptions.xPos or 0.0,
    --                 receiver.AnimationOptions.yPos or 0.0,
    --                 receiver.AnimationOptions.zPos or 0.0,
    --                 receiver.AnimationOptions.xRot or 0.0,
    --                 receiver.AnimationOptions.yRot or 0.0,
    --                 receiver.AnimationOptions.zRot or 0.0,
    --                 false,
    --                 false,
    --                 false,
    --                 true,
    --                 1,
    --                 true
    --             )
    --             -- SetEntityCollision(PlayerPedId(), false, false)
    --         end
    --     end
    -- end
    local animationDuration = -1
    TriggerServerEvent('0resmon-animmenu:syncStartReady:server', syncedTarget)
    waitForSyncStartGo(3000)
    TaskPlayAnim(PlayerPedId(), animDict, animName, 5.0, 5.0, animationDuration, movementType, 0, false, false, false)
    RemoveAnimDict(animDict)
    isInAnimation = true
    syncedAnimDictLoaded = false
    if animOptions and (animOptions.Duration or animOptions.EmoteDuration) then
        local duration = animOptions.Duration or animOptions.EmoteDuration
        Citizen.Wait(duration)
        if IsEntityPositionFrozen(PlayerPedId()) then
            FreezeEntityPosition(PlayerPedId(), false)
        end
        if GetEntityCollisionDisabled(PlayerPedId()) then
            SetEntityCollision(PlayerPedId(), true, true)
        end
        TriggerServerEvent('0resmon-animmenu:cancelEmote:server', syncedTarget)
        if IsEntityAttachedToAnyPed(PlayerPedId()) or IsEntityAttachedToEntity(PlayerPedId(), targetPed) then
            DetachEntity(PlayerPedId(), false, false)
        end
    end
end)

RegisterNetEvent('0resmon-animmenu:playAnimTogetherSender:client', function(data)
    requestReceiveActive = false
    requestActive = false
    lastPlayedAnimType = "synced"
    syncedTarget = data.data.id
    if data.id then
        syncedTarget = data.id
    end
    local inVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
    if inVehicle then return end
    syncedStartGo = false
    local targetPed = GetPlayerPed(GetPlayerFromServerId(syncedTarget))
    -- Prefer the embedded entries from the request payload, so language
    -- mismatch or missing imageId fields can't break the lookup.
    local d = data.data.data or data.data
    local senderEntry = d.senderEntry
    if not senderEntry or not senderEntry[1] then
        senderEntry = RES2.SharedByImageId[d.senderImageId] or RES2["Shared"][d.animNumber] or RES2["EEmotes"][d.animNumber] or {}
    end
    local animDict = senderEntry[1]
    local animName = senderEntry[2]
    local animOptions = senderEntry.AnimationOptions
    if not loadAnim(animDict) then return end
    -- Target (receiver's animation) - only options/offsets are needed locally
    local receiverEntry = d.receiverEntry
    if not receiverEntry or not receiverEntry[1] then
        receiverEntry = RES2.SharedByImageId[d.targetImageId2] or RES2["Shared"][d.targetAnimName] or RES2["EEmotes"][d.targetAnimName] or {}
    end
    local targetAnimData = {}
    local receiverAnimOptions = receiverEntry and receiverEntry.AnimationOptions
    if receiverAnimOptions then
        targetAnimData = receiverAnimOptions
    end
    local movementType = 1
    if animOptions then
        if animOptions.onFootFlag then
            movementType = animOptions.onFootFlag
        elseif animOptions.EmoteMoving then
            movementType = 51
        elseif animOptions.EmoteLoop then
            movementType = 1
        elseif animOptions.EmoteStuck then
            movementType = 50
        end
        if animOptions.Attachto then
            -- Pos
            if animOptions.pos and animOptions.pos.x then animOptions.xPos = animOptions.pos.x end
            if animOptions.pos and animOptions.pos.y then animOptions.yPos = animOptions.pos.y end
            if animOptions.pos and animOptions.pos.z then animOptions.zPos = animOptions.pos.z end
            -- Rot
            if animOptions.rot and animOptions.rot.x then animOptions.xRot = animOptions.rot.x end
            if animOptions.rot and animOptions.rot.y then animOptions.yRot = animOptions.rot.y end
            if animOptions.rot and animOptions.rot.z then animOptions.zRot = animOptions.rot.z end
            AttachEntityToEntity(
                PlayerPedId(),
                targetPed,
                GetPedBoneIndex(targetPed, animOptions.bone or -1),
                animOptions.xPos or 0.0,
                animOptions.yPos or 0.0,
                animOptions.zPos or 0.0,
                animOptions.xRot or 0.0,
                animOptions.yRot or 0.0,
                animOptions.zRot or 0.0,
                false,
                false,
                false,
                true,
                1,
                true
            )
        else
            if targetAnimData then
                if targetAnimData.Attachto then
                    TriggerServerEvent('0r-animmenu:attachPeds:server', syncedTarget, GetPlayerServerId(PlayerId()), targetAnimData)
                    -- AttachEntityToEntity(
                    --     PlayerPedId(),
                    --     targetPed,
                    --     GetPedBoneIndex(targetPed, targetAnimData.bone or -1),
                    --     targetAnimData.xPos or 0.0,
                    --     targetAnimData.yPos or 0.0,
                    --     targetAnimData.zPos or 0.0,
                    --     targetAnimData.xRot or 0.0,
                    --     targetAnimData.yRot or 0.0,
                    --     targetAnimData.zRot or 0.0,
                    --     false,
                    --     false,
                    --     false,
                    --     true,
                    --     1,
                    --     true
                    -- )
                end
            end
        end
    else
        if targetAnimData then
            if targetAnimData.Attachto then
                TriggerServerEvent('0r-animmenu:attachPeds:server', syncedTarget, GetPlayerServerId(PlayerId()), targetAnimData)
                -- AttachEntityToEntity(
                --     PlayerPedId(),
                --     targetPed,
                --     GetPedBoneIndex(targetPed, targetAnimData.bone or -1),
                --     targetAnimData.xPos or 0.0,
                --     targetAnimData.yPos or 0.0,
                --     targetAnimData.zPos or 0.0,
                --     targetAnimData.xRot or 0.0,
                --     targetAnimData.yRot or 0.0,
                --     targetAnimData.zRot or 0.0,
                --     false,
                --     false,
                --     false,
                --     true,
                --     1,
                --     true
                -- )
            end
        end
    end
    local heading = GetEntityHeading(targetPed)
    local syncOffsetSide = (animOptions?.SyncOffsetSide or targetAnimData?.SyncOffsetSide or 0) + 0.0
    local syncOffsetFront = (animOptions?.SyncOffsetFront or targetAnimData?.SyncOffsetFront or 0) + 0.0
    local syncOffsetHeight = (animOptions?.SyncOffsetHeight or targetAnimData?.SyncOffsetHeight or 0) + 0.0
    local syncOffsetHeading = (animOptions?.SyncOffsetHeading or targetAnimData?.SyncOffsetHeading or 180) + 0.0
    local coords = GetOffsetFromEntityInWorldCoords(targetPed, syncOffsetSide, syncOffsetFront, syncOffsetHeight)
    SetEntityHeading(PlayerPedId(), heading - syncOffsetHeading)
    SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z)
    cancelEmote("0res")
    local animationDuration = -1
    TriggerServerEvent('0resmon-animmenu:syncStartReady:server', syncedTarget)
    waitForSyncStartGo(3000)
    TaskPlayAnim(PlayerPedId(), animDict, animName, 5.0, 5.0, animationDuration, movementType, 0, false, false, false)
    RemoveAnimDict(animDict)
    isInAnimation = true
    syncedAnimDictLoaded = false
    if animOptions and (animOptions.Duration or animOptions.EmoteDuration) then
        local duration = animOptions.Duration or animOptions.EmoteDuration
        Citizen.Wait(duration)
        if IsEntityPositionFrozen(PlayerPedId()) then
            FreezeEntityPosition(PlayerPedId(), false)
        end
        if GetEntityCollisionDisabled(PlayerPedId()) then
            SetEntityCollision(PlayerPedId(), true, true)
        end
        TriggerServerEvent('0resmon-animmenu:cancelEmote:server', syncedTarget)
        if IsEntityAttachedToAnyPed(PlayerPedId()) or IsEntityAttachedToEntity(PlayerPedId(), targetPed) then
            DetachEntity(PlayerPedId(), false, false)
        end
    end
end)

RegisterNetEvent('0r-animmenu:attachPeds:client', function(targetId, targetAnimData)
    local myPed = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    if targetAnimData.pos and targetAnimData.pos.x then targetAnimData.xPos = targetAnimData.pos.x end
    if targetAnimData.pos and targetAnimData.pos.y then targetAnimData.yPos = targetAnimData.pos.y end
    if targetAnimData.pos and targetAnimData.pos.z then targetAnimData.zPos = targetAnimData.pos.z end
    -- Rot
    if targetAnimData.rot and targetAnimData.rot.x then targetAnimData.xRot = targetAnimData.rot.x end
    if targetAnimData.rot and targetAnimData.rot.y then targetAnimData.yRot = targetAnimData.rot.y end
    if targetAnimData.rot and targetAnimData.rot.z then targetAnimData.zRot = targetAnimData.rot.z end
    AttachEntityToEntity(
        myPed,
        targetPed,
        GetPedBoneIndex(targetPed, targetAnimData.bone or -1),
        targetAnimData.xPos or 0.0,
        targetAnimData.yPos or 0.0,
        targetAnimData.zPos or 0.0,
        targetAnimData.xRot or 0.0,
        targetAnimData.yRot or 0.0,
        targetAnimData.zRot or 0.0,
        false,
        false,
        false,
        true,
        1,
        true
    )
end)

RegisterNetEvent('0resmon-animmenu:cancelEmote:client', function()
    cancelEmote("0res")
end)

function GetPlayers(onlyOtherPlayers, returnKeyValue, returnPeds)
    local players, myPlayer = {}, PlayerId()
    local active = GetActivePlayers()
    for i = 1, #active do
        local currentPlayer = active[i]
        local ped = GetPlayerPed(currentPlayer)
        if DoesEntityExist(ped) and ((onlyOtherPlayers and currentPlayer ~= myPlayer) or not onlyOtherPlayers) then
            if returnKeyValue then
                players[currentPlayer] = {entity = ped, id = GetPlayerServerId(currentPlayer)}
            else
                players[#players + 1] = returnPeds and ped or currentPlayer
            end
        end
    end
    return players
end

function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
    local nearbyEntities = {}
    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        local playerPed = PlayerPedId()
        coords = GetEntityCoords(playerPed)
    end
    for k, v in pairs(entities) do
        local distance = #(coords - GetEntityCoords(v.entity))
        if distance <= maxDistance then
            nearbyEntities[#nearbyEntities + 1] = v.id
        end
    end
    return nearbyEntities
end

function GetPlayersInArea(coords, maxDistance)
    return EnumerateEntitiesWithinDistance(GetPlayers(true, true), true, coords, maxDistance)
end

RegisterNetEvent('0r-animmenu:getAnimationList:client', function()
    TriggerEvent('0r-anim-image-recorder:setAnimationList:client', RES2)
    TriggerEvent('0r-anim-gif-recorder:setAnimationList:client', RES2)
end)

-- function gangPropsMenu()
--     if GetResourceState("ox_lib") == "started" then
--         local options = {}
--         for _, prop in ipairs(Config.GangEmoteProps) do
--             table.insert(options, {
--                 title = prop.label .. " (Right Hand)",
--                 description = "Attach " .. prop.label .. " to right hand",
--                 onSelect = function()
--                     attachPropToHand(
--                         prop.objName,
--                         "right",
--                         prop.handOffsets.rightHand.pos,
--                         prop.handOffsets.rightHand.rot
--                     )
--                 end
--             })
--             table.insert(options, {
--                 title = prop.label .. " (Left Hand)",
--                 description = "Attach " .. prop.label .. " to left hand",
--                 onSelect = function()
--                     attachPropToHand(
--                         prop.objName,
--                         "left",
--                         prop.handOffsets.leftHand.pos,
--                         prop.handOffsets.leftHand.rot
--                     )
--                 end
--             })
--         end
--         exports["ox_lib"]:registerContext({
--             id = 'prop_menu',
--             title = 'Prop Options',
--             options = options
--         })
--         exports["ox_lib"]:showContext('prop_menu')
--     elseif GetResourceState("qb-menu") == "started" then
--         local menu = {
--             {
--                 header = "Prop Options",
--                 isMenuHeader = true
--             }
--         }
--         for _, prop in ipairs(Config.GangEmoteProps) do
--             table.insert(menu, {
--                 header = prop.label .. " (Right Hand)",
--                 txt = "Attach " .. prop.label .. " to right hand",
--                 action = function()
--                     attachPropToHand(
--                         prop.objName,
--                         "right",
--                         prop.handOffsets.rightHand.pos,
--                         prop.handOffsets.rightHand.rot
--                     )
--                 end
--             })
--             table.insert(menu, {
--                 header = prop.label .. " (Left Hand)",
--                 txt = "Attach " .. prop.label .. " to left hand",
--                 action = function()
--                     attachPropToHand(
--                         prop.objName,
--                         "left",
--                         prop.handOffsets.leftHand.pos,
--                         prop.handOffsets.leftHand.rot
--                     )
--                 end
--             })
--         end
--         exports['qb-menu']:openMenu(menu)
--     end
-- end

RegisterKeyMapping(Config.GangEmotePropMenuCommand, "Opens gang anim prop menu", "keyboard", Config.GangEmotePropMenuKey)
RegisterCommand(Config.GangEmotePropMenuCommand, function()
    if lastPlayedAnimType == "gang" then
        gangPropsMenu()
    end
end)

RegisterKeyMapping(Config.GangEmotePropMenuInfoCommand, "Opens gang anim prop info menu", "keyboard", Config.GangEmotePropMenuInfoKey)
RegisterCommand(Config.GangEmotePropMenuInfoCommand, function()
    if lastPlayedAnimType == "gang" then
        SendNUIMessage({action = "openGangInfoMenu", state = nil})
    end
end)

function gangPropsMenu()
    if GetResourceState("ox_lib") == "started" then
        exports.ox_lib:registerContext({
            id = 'prop_menu',
            title = 'Prop Options',
            options = {
                {
                    title = "Right Hand",
                    description = "Show right hand props",
                    onSelect = function()
                        local rightOptions = {}
                        for _, prop in ipairs(Config.GangEmoteProps) do
                            table.insert(rightOptions, {
                                title = prop.label,
                                description = "Attach " .. prop.label .. " to right hand",
                                onSelect = function()
                                    attachPropToHand(
                                        prop.objName,
                                        "right",
                                        prop.handOffsets.rightHand.pos,
                                        prop.handOffsets.rightHand.rot
                                    )
                                    exports.ox_lib:showContext('prop_menu_right')
                                end
                            })
                        end

                        exports.ox_lib:registerContext({
                            id = 'prop_menu_right',
                            title = 'Right Hand Props',
                            menu = 'prop_menu',
                            options = rightOptions
                        })
                        exports.ox_lib:showContext('prop_menu_right')
                    end
                },
                {
                    title = "Left Hand",
                    description = "Show left hand props",
                    onSelect = function()
                        local leftOptions = {}
                        for _, prop in ipairs(Config.GangEmoteProps) do
                            table.insert(leftOptions, {
                                title = prop.label,
                                description = "Attach " .. prop.label .. " to left hand",
                                onSelect = function()
                                    attachPropToHand(
                                        prop.objName,
                                        "left",
                                        prop.handOffsets.leftHand.pos,
                                        prop.handOffsets.leftHand.rot
                                    )
                                    exports.ox_lib:showContext('prop_menu_left')
                                end
                            })
                        end

                        exports.ox_lib:registerContext({
                            id = 'prop_menu_left',
                            title = 'Left Hand Props',
                            menu = 'prop_menu',
                            options = leftOptions
                        })
                        exports.ox_lib:showContext('prop_menu_left')
                    end
                }
            }
        })

        exports.ox_lib:showContext('prop_menu')
    elseif GetResourceState("qb-menu") == "started" then
        local mainMenu = {
            {
                header = "Prop Options",
                isMenuHeader = true
            },
            {
                header = "Right Hand",
                txt = "Show all right-hand props",
                params = {
                    event = "showRightHandProps"
                }
            },
            {
                header = "Left Hand",
                txt = "Show all left-hand props",
                params = {
                    event = "showLeftHandProps"
                }
            }
        }
        exports['qb-menu']:openMenu(mainMenu)
        RegisterNetEvent("showRightHandProps", function()
            local menu = {
                { header = "Right Hand Props", isMenuHeader = true }
            }
            for _, prop in ipairs(Config.GangEmoteProps) do
                table.insert(menu, {
                    header = prop.label,
                    txt = "Attach " .. prop.label .. " to right hand",
                    params = { event = "attachPropRight", args = prop }
                })
            end
            exports['qb-menu']:openMenu(menu)
        end)
        RegisterNetEvent("showLeftHandProps", function()
            local menu = {
                { header = "Left Hand Props", isMenuHeader = true }
            }
            for _, prop in ipairs(Config.GangEmoteProps) do
                table.insert(menu, {
                    header = prop.label,
                    txt = "Attach " .. prop.label .. " to left hand",
                    params = { event = "attachPropLeft", args = prop }
                })
            end
            exports['qb-menu']:openMenu(menu)
        end)
        RegisterNetEvent("attachPropRight", function(prop)
            attachPropToHand(
                prop.objName,
                "right",
                prop.handOffsets.rightHand.pos,
                prop.handOffsets.rightHand.rot
            )
        end)
        RegisterNetEvent("attachPropLeft", function(prop)
            attachPropToHand(
                prop.objName,
                "left",
                prop.handOffsets.leftHand.pos,
                prop.handOffsets.leftHand.rot
            )
        end)
    end
end

-- function isAreaClear(ped, distance)
--     local pedCoords = GetEntityCoords(ped)
--     local directions = {
--         GetEntityForwardVector(ped),
--         GetEntityForwardVector(ped) * -1.0,
--         vector3(GetEntityForwardVector(ped).y, -GetEntityForwardVector(ped).x, 0.0),
--         vector3(-GetEntityForwardVector(ped).y, GetEntityForwardVector(ped).x, 0.0)
--     }
--     for _, dir in ipairs(directions) do
--         local startPos = pedCoords + vector3(0.0, 0.0, 0.5)
--         local endPos = startPos + (dir * distance)
--         local rayHandle = StartShapeTestRay(startPos.x, startPos.y, startPos.z, endPos.x, endPos.y, endPos.z, -1, ped, 0)
--         local _, hit, _, _, _ = GetShapeTestResult(rayHandle)
--         if hit then
--             return false
--         end
--     end
--     return true
-- end

exports('getHandsup', function() return handsUp end)

local function exportHandler(exportName, func)
    AddEventHandler(('__cfx_export_qb-smallresources_%s'):format(exportName), function(setCB)
        setCB(func)
    end)
end

exportHandler('getHandsup', function()
    return handsUp
end)

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination ={x = cameraCoord.x + direction.x * distance, y = cameraCoord.y + direction.y * distance, z = cameraCoord.z + direction.z * distance}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestSweptSphere(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 0.2, 339, PlayerPedId(), 4))
	return b, c, e
end

function RotationToDirection(rotation)
    local adjustedRotation = {x = (math.pi / 180) * rotation.x, y = (math.pi / 180) * rotation.y, z = (math.pi / 180) * rotation.z}
    local direction = {x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), z = math.sin(adjustedRotation.x)}
    return direction
end

function Round(value, numDecimalPlaces)
    if not numDecimalPlaces then return math.floor(value + 0.5) end
    local power = 10 ^ numDecimalPlaces
    return math.floor((value * power) + 0.5) / (power)
end

function getLangData()
    local lang = GetResourceKvpString('0ranimmenuv2lang')
    if not lang then lang = Config.Language end
    local langData = Config["Translation" .. lang]
    if not langData then langData = Config["Translation" .. Config.Language] end
    return langData
end

function getAnimLabelFromImageId(imageId, category)
    local fallback = nil
    for k, v in pairs(data) do
        if v.imageId == imageId then
            if category and v.category == category then
                return v.label
            end
            if not fallback then
                fallback = v.label
            end
        end
    end
    return fallback or "Unknown"
end

function getAnimNameFromImageId(imageId, category)
    local fallback = nil
    for k, v in pairs(data) do
        if v.imageId == imageId then
            if category and v.category == category then
                return v.name
            end
            if not fallback then
                fallback = v.name
            end
        end
    end
    return fallback or "Unknown"
end
