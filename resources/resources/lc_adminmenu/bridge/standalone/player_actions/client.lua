return function ()
  -- you can register events for your custom player actions here
  RegisterNetEvent('lc_admin:client:player_actions:heal', function()
    SetEntityHealth(cache.ped, GetEntityMaxHealth(cache.ped))
  end)

  RegisterNetEvent('lc_admin:client:player_actions:revivePlayer', function()
    local coords = GetEntityCoords(cache.ped)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, 0.0, 0, false)
  end)
end