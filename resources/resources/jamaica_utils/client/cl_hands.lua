CreateThread(function()
    local nightstick = joaat('WEAPON_NIGHTSTICK')
    local unarmed = joaat('WEAPON_UNARMED')
    while true do
        SetWeaponDamageModifier(nightstick, 0.5)
        SetWeaponDamageModifier(unarmed, 0.2)
        Wait(1000)
    end
end)
