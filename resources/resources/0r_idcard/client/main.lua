CardOpen = false
gCreatedBadgeProp = nil
PData = {}
Peds = {}
DoScreenFadeIn(0)


-- CreateThread(function()
--     local sleep = 1000
    
--     while true do
--         Wait(sleep)

--         local shot = GetBase64(PlayerPedId())
--         PData.photo = shot.base64

--         if next(PData) == nil then
--             sleep = 1000
--         else
--             break
--         end
--     end
-- end)



CreateThread(function()
    local fakeCardPed = createPedOnCoord(Config.FakeCardPed.model, Config.FakeCardPed.coords.x, Config.FakeCardPed.coords.y, Config.FakeCardPed.coords.z, Config.FakeCardPed.coords.w)
    local GeneralCardPed = createPedOnCoord(Config.GeneralCardPed.model, Config.GeneralCardPed.coords.x, Config.GeneralCardPed.coords.y, Config.GeneralCardPed.coords.z, Config.GeneralCardPed.coords.w)
    local JobCardPed = createPedOnCoord(Config.JobCardPed.model, Config.JobCardPed.coords.x, Config.JobCardPed.coords.y, Config.JobCardPed.coords.z, Config.JobCardPed.coords.w)
    table.insert(Peds, fakeCardPed)
    table.insert(Peds, GeneralCardPed)
    table.insert(Peds, JobCardPed)

    if Config.InteractType == 'drawtext' then
        local sleep = 1000
        while true do
            Wait(sleep)

            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local dist2 = #(coords - vector3(Config.FakeCardPed.coords.x, Config.FakeCardPed.coords.y, Config.FakeCardPed.coords.z))
            local dist3 = #(coords - vector3(Config.GeneralCardPed.coords.x, Config.GeneralCardPed.coords.y, Config.GeneralCardPed.coords.z))
            local dist4 = #(coords - vector3(Config.JobCardPed.coords.x, Config.JobCardPed.coords.y, Config.JobCardPed.coords.z))
            if dist2 < 2 then
                sleep = 0
                DrawText3D("Press ~g~[E]~s~ to create a fake card", Config.FakeCardPed.coords.x, Config.FakeCardPed.coords.y, Config.FakeCardPed.coords.z + 1, 0.03, 0.03)
            
                if IsControlJustPressed(0, 38) then
                    lib.showContext('fake_id_card')
                end
            elseif dist3 < 2 then
                sleep = 0
                DrawText3D("Press ~g~[E]~s~ to create a General card", Config.GeneralCardPed.coords.x, Config.GeneralCardPed.coords.y, Config.GeneralCardPed.coords.z + 1, 0.03, 0.03)
            
                if IsControlJustPressed(0, 38) then
                    lib.showContext('general_card')
                end
            elseif dist4 < 2 then
                sleep = 0
                DrawText3D("Press ~g~[E]~s~ to create a Job card", Config.JobCardPed.coords.x, Config.JobCardPed.coords.y, Config.JobCardPed.coords.z + 1, 0.03, 0.03)
            
                if IsControlJustPressed(0, 38) then
                    if isJobAllowed(Config.Jobs) then 
                        lib.showContext('job_card')
                    end
                end
            else
                sleep = 1000
            end
        end
    elseif Config.InteractType == 'qb-target' then
        exports['qb-target']:AddTargetEntity(fakeCardPed, {
            options = {
                {
                    label = 'Create Fake Card',
                    icon = 'fas fa-tasks',
                    action = function()
                        lib.showContext('fake_id_card')
                    end
                }
            },
            distance = 2.0
        })
        exports['qb-target']:AddTargetEntity(GeneralCardPed, {
            options = {
                {
                    label = 'Create General Cards',
                    icon = 'fas fa-tasks',
                    action = function()
                        lib.showContext('general_card')
                    end
                }
            },
            distance = 2.0
        })
        exports['qb-target']:AddTargetEntity(JobCardPed, {
            options = {
                {
                    label = 'Create Job Cards',
                    icon = 'fas fa-tasks',
                    action = function()
                        lib.showContext('job_card')
                    end
                }
            },
            distance = 2.0
        })
    elseif Config.InteractType == 'ox_target' then
        exports.ox_target:addLocalEntity(fakeCardPed, {
			{
				name = 'fake_id_card',
				onSelect = function()
                    lib.showContext('fake_id_card')
				end,
				icon = 'fas fa-tasks',
				label = 'Kreiraj Laznu Licnu Kartu',
                distance = 2.0
			}
		})
        
        exports.ox_target:addLocalEntity(GeneralCardPed, {
			{
				name = 'general_card',
				onSelect = function()
                    lib.showContext('general_card')
				end,
				icon = 'fas fa-tasks',
				label = 'Kreiraj Opstu Licnu Kartu',
                distance = 2.0
			}
		})
        
        exports.ox_target:addLocalEntity(JobCardPed, {
			{
				name = 'job_card',
				onSelect = function()
                    lib.showContext('job_card')
				end,
				icon = 'fas fa-tasks',
				label = 'Kreiraj Sluzbenu Licnu Kartu',
                distance = 2.0
			}
		})
    end
end)

lib.registerContext({
    id = 'fake_id_card',
    title = 'Kreiraj Laznu Licnu Kartu',
    options = {
        {
            title = 'Kreiraj Laznu Licnu Kartu',
            description = 'Kreiraj laznu licnu kartu.',
            onSelect = function()
                local input = lib.inputDialog('Kreiraj Laznu Licnu Kartu', {
                    {type = 'input', label = 'Ime', description = 'Unesite ime koje ce biti prikazano na kartici', required = true, min = 2},
                    {type = 'input', label = 'Prezime', description = 'Unesite prezime koje ce biti prikazano na kartici', required = true, min = 2},
                    {type = 'date',  label = 'Datum Rodjenja', icon = {'far', 'calendar'}, default = true, required = true, format = "DD/MM/YYYY"},
                    {type = 'checkbox', label = 'Male'},
                    {type = 'checkbox', label = 'Female'},
                })

                if input then
                    local name = input[1]
                    local surname = input[2]
                    local birthdate = input[3]
                    local male = input[4]
                    local female = input[5]

                    if male and female then
                        Config.Notify("Mozes da izaberete samo jedan pol", "error")
                    elseif not male and not female then
                        Config.Notify("Morate da izaberete pol", "error")
                    else
                        local shot = GetBase64(PlayerPedId())
                        TriggerServerEvent("0r_idcard:server:createFakeCard", name, surname, "citizen", birthdate, male, female, shot, "citizen")
                    end
                end
            end,
        },
        {
            title = 'Kreiraj Sluzbenu Licnu Kartu',
            description = 'Kreiraj sluzbenu licnu kartu za svoju poziciju.',
            onSelect = function()
                local jobs = ""

                for k, v in pairs(Config.CardTypes) do
                    if k ~= "citizen" then
                        jobs = jobs .. k .. ", "
                    end	
                end

                local input = lib.inputDialog('Kreiraj Sluzbenu Licnu Kartu', {
                    {type = 'input', label = 'Ime', description = 'Unesite ime koje ce biti prikazano na kartici', required = true, min = 2},
                    {type = 'input', label = 'Prezime', description = 'Unesite prezime koje ce biti prikazano na kartici', required = true, min = 2},
                    {type = 'input', label = 'Job', description = 'Poslovi su ' .. jobs, required = true, min = 2},
                    {type = 'date',  label = 'Datum Rodjenja', icon = {'far', 'calendar'}, default = true, required = true, format = "DD/MM/YYYY"},
                    {type = 'checkbox', label = 'Male'},
                    {type = 'checkbox', label = 'Female'},
                })

                if input then
                    local name = input[1]
                    local surname = input[2]
                    local job = input[3]
                    local birthdate = input[4]
                    local male = input[5]
                    local female = input[6]

                    if not table_includes(Config.CardTypes, job) then
                        Config.Notify("This job is not available", "error")
                    elseif male and female then
                        Config.Notify("You can only select one gender", "error")
                    elseif not male and not female then
                        Config.Notify("You must select a gender", "error")
                    else
                        local shot = GetBase64(PlayerPedId())
                        TriggerServerEvent("0r_idcard:server:createFakeCard", name, surname, job, birthdate, male, female, shot, "job")
                    end
                end
            end,
        }
    }
})


lib.registerContext({
    id = 'general_card',
    title = 'Create General Cards',
    options = {
        {
            title = 'Kreiraj Opstu Licnu Kartu',
            description = 'Create ID Card',
            onSelect = function()
                local shot = GetBase64(PlayerPedId())
                TriggerServerEvent("0r_idcard:server:createCard", shot, "citizen")
            end,
        },
        {
            title = 'Podigni Vozacku Dozvolu',
            description = 'Da bi kreirao vozacku dozvolu, moras da polozis u auto skoli.',
            onSelect = function()
                local shot = GetBase64(PlayerPedId())
                TriggerServerEvent("0r_idcard:server:createCard", shot, "driver")
            end,
        },
        {
            title = 'Create Weapon License',
            description = 'Da bi kreirao dozvolu za oruzje, policija mora da ti izda dozvolu za oruzje.',
            onSelect = function()
                local shot = GetBase64(PlayerPedId())
                TriggerServerEvent("0r_idcard:server:createCard", shot, "weapon")
            end,
        }
    }
})

lib.registerContext({
    id = 'job_card',
    title = 'Kreiraj Sluzbenu Licnu Kartu',
    options = {
        {
            title = 'Kreiraj Sluzbenu Licnu Kartu',
            description = 'Kreiraj sluzbenu licnu kartu za svoju poziciju.',
            onSelect = function()
                local shot = GetBase64(PlayerPedId())
                TriggerServerEvent("0r_idcard:server:createCard", shot, "job")
            end,
        }
    }
})