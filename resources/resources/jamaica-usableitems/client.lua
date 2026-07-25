

RegisterNetEvent("updateClientDrugs")
AddEventHandler("updateClientDrugs", function(t)
    if t == 'health' then

        if lib.progressBar({
            duration = 3500,
            label = 'Koristis joint',
            useWhileDead = false,
            canCancel = false,
            anim = {
                dict = 'timetable@gardener@smoking_joint',
                clip = 'smoke_idle',
                flag = 49,
            },
            prop = {
                model = `p_cs_joint_02`,
                bone = 28422,
                pos = vec3(0.02, -0.01, 0.005),
                rot = vec3(60.0, 0.0, 100.0),
            },
        }) then 
            SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 25)
        end
        
    end
    if t == 'armor' then
        if lib.progressBar({
            duration = 2000,
            label = 'Koristis MDMU',
            useWhileDead = false,
            canCancel = false,
            anim = {
                dict = 'mp_player_intdrink',
                clip = 'loop_bottle'
            },
        }) then 
            SetPedArmour(PlayerPedId(), GetPedArmour(PlayerPedId()) + 15)
        end
    end
    if t == 'heroin' then
        if lib.progressBar({
            duration = 2000,
            label = 'Koristis heroin',
            useWhileDead = false,
            canCancel = false,
            anim = {
                dict = 'mp_player_intdrink',
                clip = 'loop_bottle'
            },
        }) then
            SetPedArmour(PlayerPedId(), GetPedArmour(PlayerPedId()) + 50)
        end
    end
end)

RegisterNetEvent("updateClientKokain")
AddEventHandler("updateClientKokain", function()
    if lib.progressBar({
        duration = 2000,
        label = 'Koristiš kokain',
        useWhileDead = false,
        canCancel = false,
        anim = {
            dict = 'mp_player_inteat@pnq',
            clip = 'loop'
        },
    }) then 
        SetPedArmour(PlayerPedId(), GetPedArmour(PlayerPedId()) + 25)
    end
end)

RegisterNetEvent('updateClientRollJoint')
AddEventHandler('updateClientRollJoint', function()
    if lib.progressBar({
        duration = 5000,
        label = 'Motas joint...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
        anim = {
            dict = 'anim@amb@business@weed@weed_sorting_seated@',
            clip = 'sorter_right_sort_v1_sorter02',
            flag = 49,
        },
    }) then
        TriggerServerEvent('jamaica-usableitems:rollJointDone')
    end
end)

