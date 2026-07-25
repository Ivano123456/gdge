Strings = {
    ["press_buttom"] = 'Pritisni E i registruj. Cijena registracije je 5000$. Trajanje registracije je 7 dana.',
    ["press_button_insurance"] = 'Pritisni E za osiguranje vozila. Cijena osiguranja je 3000$. Trajanje osiguranja je 7 dana.',
    ["title_enter_reg"] = 'Molimo unesite registarske tablice',
    ["title_main_menu"] = 'Registracija i Osiguranje',
    ["menu_registration"] = 'Registracija vozila',
    ["menu_insurance"] = 'Osiguranje vozila',
    ["incorrect_value"] = 'Unijeli ste netočnu vrijednost!',
    ["no_vehicle_nearby"] = 'Nema vozila u blizini!',
    ["expiration_date"] = 'Datum isteka %s',
    ["registration_valid"] = 'Registracija je važeća! %s',
    ["vehicle_not_registered"] = 'Vozilo nije registrirano!',
    ["insurance_valid"] = 'Osiguranje je važeće! %s',
    ["vehicle_not_insured"] = 'Vozilo nije osigurano!',
    ["cooldown"] = 'Pričekajte 5 sekundi prije ponovne provjere registracije.',
    ["rented_vehicle"] = 'RENTANO VOZILO',

    ["registration_successful"] = 'Uspješna registracija vozila s tablicama %s',
    ["insurance_successful"] = 'Uspješno osiguranje vozila s tablicama %s',
    ["extend_registration"] = "Možete produžiti registraciju najranije 1 dan prije isteka",
    ["extend_insurance"] = "Možete produžiti osiguranje najranije 1 dan prije isteka",
    ["max_registration"] = "Maksimalno trajanje registracije je 14 dana. Dođite ponovno nakon isteka.",
    ["max_insurance"] = "Maksimalno trajanje osiguranja je 14 dana. Dođite ponovno nakon isteka.",
    ["no_money"] = 'Nemate dovoljno novca!',
    ["no_owner"] = 'Niste vlasnik ili niste unijeli ispravne tablice',
    ["cooldown_2"] = 'Pričekajte najmanje %s sekundi prije ponovnog korištenja usluge registracije',
}

setmetatable(Strings, {__index = function(self, key)
    return "Error: Missing translation for \""..key.."\""
end})
