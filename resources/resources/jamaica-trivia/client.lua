local function showTriviaUI(question, amount, duration)
    SendNUIMessage({
        type = 'showTrivia',
        question = question,
        reward = ('$%s'):format(amount),
        time = duration,
        sound = Config.NotificationSoundFile or 'trivia.mp3'
    })
end

local function hideTriviaUI()
    SendNUIMessage({
        type = 'hideTrivia'
    })
end

RegisterNetEvent('jamaica-trivia:client:startRound', function(question, amount, duration)
    showTriviaUI(question, amount, duration)
end)

RegisterNetEvent('jamaica-trivia:client:endRound', function()
    hideTriviaUI()
end)

AddEventHandler('onClientResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        hideTriviaUI()
    end
end)
