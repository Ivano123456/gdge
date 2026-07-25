local function closeMenu()
	SetNuiFocus(false, false)
	SendNUIMessage({ showPlayerMenu = false })
	TriggerServerEvent('jamaica-srecka:close')
end

RegisterNetEvent('jamaica-srecka:open', function(canWin)
	SetNuiFocus(true, true)
	SendNUIMessage({ showPlayerMenu = true, canWin = canWin == true })
end)

RegisterNetEvent('jamaica-srecka:showPrize', function(money)
	lib.notify({
		description = ('Osvojili ste $%s!'):format(money),
		type = 'success',
	})
end)

RegisterNUICallback('closeButton', function(_, cb)
	closeMenu()
	cb('ok')
end)

RegisterNUICallback('win', function(_, cb)
	TriggerServerEvent('jamaica-srecka:win')
	cb('ok')
end)
