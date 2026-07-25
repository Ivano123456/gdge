CurrentMultiplayerData = {}

RegisterNetEvent(Event('client:receiveMultiplayerTeamInvite'), function(inviteData)
    Debug('info', '[client:receiveMultiplayerTeamInvite] Received invite from %s to team %s', inviteData.inviter, inviteData.teamId)
    local alert = lib.alertDialog({
        header = locale('alert.multiplayer_invite.title'),
        content = locale('alert.multiplayer_invite.content', inviteData.inviter),
        labels = {
            confirm = locale('alert.multiplayer_invite.accept_button'),
            cancel = locale('alert.multiplayer_invite.decline_button'),
        },
        centered = true,
        cancel = true
    })

    if alert == 'confirm' then
        Debug('success', '[client:receiveMultiplayerTeamInvite] Accepted invite to team %s', inviteData.teamId)
        TriggerServerEvent(Event('server:acceptMultiplayerTeamInvite'), inviteData)
    else
        Debug('info', '[client:receiveMultiplayerTeamInvite] Declined invite to team %s', inviteData.teamId)
        TriggerServerEvent(Event('server:declineMultiplayerTeamInvite'), inviteData)
    end
end)

RegisterNetEvent(Event('client:updateMultiplayerTeamData'), function(multiplayerData)
    Debug('info', '[client:updateMultiplayerTeamData] Updating team data')
    CurrentMultiplayerData = multiplayerData or {}

    if multiplayerData and next(multiplayerData) ~= nil then
        if multiplayerData.members and next(multiplayerData.members) ~= nil then
            Debug('success', '[client:updateMultiplayerTeamData] Team has %d members', #multiplayerData.members)
            NuiMessage('multiplayer/update-players', multiplayerData.members)
        end
    end
end)

RegisterNetEvent(Event('client:stopMultiplayerTask'), function(teamId, wasTaskStarted, stoppingBucketId)
    HelpText.HideHelpText()
    Debug('info', '[client:stopMultiplayerTask] Stopping multiplayer task for team %s (wasTaskStarted: %s, bucketId: %s)', tostring(teamId), tostring(wasTaskStarted), tostring(stoppingBucketId))

    if stoppingBucketId and CurrentMultiplayerData and CurrentMultiplayerData.settings and CurrentMultiplayerData.settings.task then
        local currentBucketId = CurrentMultiplayerData.settings.task.bucketId
        if currentBucketId and currentBucketId ~= stoppingBucketId then
            Debug('warning', '[client:stopMultiplayerTask] Ignoring stale stop event (current bucket: %s, stopping bucket: %s)', tostring(currentBucketId), tostring(stoppingBucketId))
            return
        end
    end

    local shouldTeleport = wasTaskStarted

    if wasTaskStarted == nil then
        shouldTeleport = CurrentMultiplayerData 
            and next(CurrentMultiplayerData) 
            and CurrentMultiplayerData.settings 
            and CurrentMultiplayerData.settings.task 
            and CurrentMultiplayerData.settings.task.started
    end

    local vehiclesToCleanup = CurrentMultiplayerData and CurrentMultiplayerData.settings and CurrentMultiplayerData.settings.vehicles
    if CleanupTaskEntities then
        CleanupTaskEntities(vehiclesToCleanup)
    end

    if shouldTeleport then
        Debug('info', '[client:stopMultiplayerTask] Teleporting player to exit location')
        DoScreenFadeOut(1000)
        while not IsScreenFadedOut() do
            Wait(100)
        end

        SetEntityCoords(PlayerPedId(), 1244.85, -3247.3, 5.03, false, false, false, true)
        SetEntityHeading(PlayerPedId(), 254.57)

        NuiMessage('task/toggle-info', {
            show = false,
        })

        local bucketTeamId = teamId or (CurrentMultiplayerData and CurrentMultiplayerData.teamId)
        if bucketTeamId then
            TriggerServerEvent(Event('server:setRoutingBucket'), bucketTeamId, false)
        end

        DoScreenFadeIn(1000)
    end

    if CurrentMultiplayerData and CurrentMultiplayerData.settings and CurrentMultiplayerData.settings.task then
        CurrentMultiplayerData.settings.task.started = false
    end
end)