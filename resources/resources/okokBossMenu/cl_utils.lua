ESX = exports.es_extended:getSharedObject()

RegisterNetEvent(Config.EventPrefix..":notification")
AddEventHandler(Config.EventPrefix..":notification", function(title, text, time, type)
    if Config.UseOkokNotify then
        exports['okokNotify']:Alert(title, text, time, type)
    else
        ESX.ShowNotification(text)
    end
end)

function TextUI(text, color, side, coords)
	if Config.UseOkokTextUI then
		if text ~= nil then
			exports['okokTextUI']:Open(text, color, side)
		else
			exports['okokTextUI']:Close()
		end
	else
		if text ~= nil then
			ESX.TextUI(text)
		else
			ESX.HideUI()
		end
	end
end

function openStorage(job)
	if Config.InventorySystem == "ox-inventory" then
		local stash = { id = 'boss_'..job, label = job..' Boss Locker', slots = 50, weight = 100000 }
		TriggerServerEvent(Config.EventPrefix..':createOxStash', stash)
		Wait(250)
		exports.ox_inventory:openInventory('stash', 'boss_'..job)
	elseif Config.InventorySystem == "qs-inventory" then
		TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'boss_' .. job, { maxweight = 4000000, slots = 25 })
		TriggerEvent('inventory:client:SetCurrentStash', 'boss_' .. job)
	else
		-- Add your trigger here
	end
end

function openClothingMenu()
	if Config.ClothingSystem == "esx_skin" then
		TriggerEvent('esx_skin:openSaveableMenu')
	elseif Config.ClothingSystem == "illenium-appearance" then
		TriggerEvent('illenium-appearance:client:openOutfitMenu')
	else
		-- Add your trigger here
	end
end

function playerOnDuty(job)
	setPlayerDuty(true, job)
end

function playerOffDuty(job)
	setPlayerDuty(false, job)
end

function setPlayerDuty(status, job)
	if Config.UseOffDutyPrefix then TriggerServerEvent(Config.EventPrefix..':setJob', status, job) end
end

function drawMarker(coords)
	DrawMarker(Config.MarkerID, coords, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, Config.MarkerColors.r, Config.MarkerColors.g, Config.MarkerColors.b, Config.MarkerColors.a, 0, 0, 2, 1, 0, 0, 0)                         
end