

Config.ProgressBar = {
    -- Change progress bar text here for every action.
    PickingUp = "Podizanje %s...", -- %s = item label
    Packaging = "Pakovanje...",
    Placing = "Postavljanje %s...", -- %s = item label
    ExtractingInk = "Ekstrakcija mastila...",
    SearchingPrinter = "Pretraga štampača...",
    Adding = "Dodavanje %s...", -- %s = item label
    Removing = "Uklanjanje %s...", -- %s = item label
    TakingOut = "Izvlačenje %s...", -- %s = item label
    Cutting = "Sečenje lista novca...", -- %s = item label
}


Config.Notifications = {
    -- ["name" - don't change this] = set text that will be displayed in notification.
    ["something_went_wrong"] = "Nešto je pošlo po zlu!",
    ["invalid_amount"] = "Neispravna količina!",
    ["you_dont_have_enough_money"] = "Nemate dovoljno novca - %s$",
    ["bought_item"] = "Kupili ste %sx %s za $%s", -- %s = amount, %s = item label, %s = price
    ["you_dont_have_item"] = "Nemate %sx %s", -- %s = amount
    ["missing_following_items"] = "Nedostaju vam sledeći predmeti: %s", -- %s = List of missing items
    ["player_nearby"] = "Igrač je u blizini. Pomaknite se!",

    ["extracted_ink_black"] = "Izdvojili ste %x jedinica crnog mastila.",
    ["extracted_ink_color"] = "Izdvojili ste %x jedinica kolor mastila.",
    ["no_ink_found"] = "Mastilo nije pronađeno!",

    ["already_placed"] = "%s je već postavljen!", -- %s = item label

    ["printer_already_seached"] = "Već pretraženo",

    ["added_to_printer"] = "Dodato %s u štampač",
    ["removed_from_printer"] = "Uklonjeno %s %sx sa mašine za štampanje.",
    ["no_valid_recipe"] = "Nije pronađen validan recept za ovu kombinaciju mastila!",
    ["printing"] = "Štampanje... Preostalo vreme: %s sekundi.", -- %s = time remaining variable
    ["success_print"] = "Uspeh! Odštampali ste list od %s$!", -- %s = amount, %s = item label

    ["object_nearby"] = "Isti tip objekta je već u blizini!",

    ["max_amount"] = "Dostignuta maksimalna količina mastila (%s)",

    ["printer_has_sheet"] = "U štampaču se nalazi list!",
    ["printer_no_sheet"] = "U štampaču nema lista!",

    ["blueprint_info"] = "%s$: %sx %s", -- %s = bill value, %s = amount of ink, %s ink type

    ["you_failed_minigame"] = "Niste uspeli!",
    ["you_passed_minigame"] = "Uspešno!",

    ["no_sheets_to_certify"] = "Nemate listove novca za overu!",
    ["money_sheet_removed"] = "Odštampani list uklonjen — niste prošli minigru!",

    ["no_sheets"] = "Nemate listove novca za obradu!",

    ["blueprint_hack_success"] = "Dobili ste kolor šablon (novčanica od $%s)!",
    ["no_admin_permission"] = "Samo vlasnik može koristiti ovu komandu.",

}

Config.RotationInstructions = "Pritisnite ~o~ARROW LEFT ~s~/~o~ ARROW RIGHT~s~ za rotaciju objekta, ~g~E~s~ za postavljanje, ~r~G~s~ za otkazivanje"


Config.Menu = {
    ["refresh_menu_context"] = "Kliknite za osvežavanje menija",
    ["refresh_menu"] = "Osveži",
    ["shop_title"] = "Prodavnica",
    ["instant_sell_title"] = "Brza prodaja",
    ["instant_sell_context"] = "Meni brze prodaje",
    ["menu"] = "meni",
    ["exit"] = "Izlaz",
    ["back"] = "Nazad",
    ["buy_title"] = "Kupovina - %s",
    ["price_context"] = "Cena: $%s",
    ["off"] = "isključeno",
    ["on"] = "uključeno",
    ["yes"] = "Da",
    ["no"] = "Ne",
    ["add"] = "Dodaj",
    ["none"] = "Nema",

    ["dispatch_center"] = "Dispečerski centar",
    ["find_customers_title"] = "Pronađi kupce",
    ["find_customers_context"] = "Kliknite da pronađete kupce.",
    ["see_order_details_title"] = "Prikaži detalje porudžbine",
    ["see_order_details_context"] = "Kliknite da prikažete detalje porudžbine.",
    ["tips_for_selling_title"] = "Saveti za prodaju proizvoda",
    ["tips_for_selling_context"] = "Kliknite za savete o prodaji proizvoda.",
    ["order_details_title"] = "Detalji porudžbine",
    ["order_title"] = "Porudžbina",
    ["item_format"] = "%s - %sx", -- %s = item name, %s = amount
    ["customer_distance"] = "Kupac je udaljen %s metara od vas.", -- %s = meters variable
    ["total_price"] = "Ukupna cena: %s$", -- %s = price
    ["tips_title"] = "Saveti za prodaju proizvoda",
    ["tips_ox_title"] = "Saveti",
    ["sell_directly_title"] = "Prodaj direktno, uštedi vreme",
    ["sell_directly_context"] = "Prodajte proizvode direktno firmi za bržu, ali manju zaradu.",
    ["deliver_title"] = "Dostavi za više novca",
    ["deliver_context"] = "Dostavite proizvode kupcima za više novca, ali traje duže.",

    ["crushing_grapes_title"] = "Gnječenje grožđa",
    ["blending_grapes_title"] = "Mešanje grožđa",
    ["start_blending"] = "Započni mešanje - %s",

    ["barrel_fermentation_title"] = "Fermentacija u bačvi",
    ["barrel_fermentation_title_ox"] = "Proces fermentacije",
    ["barrel_fermentation_context_fill_bottle"] = "Broj boca za punjenje: %s",
    ["add_grapes"] = "Dodaj grožđe",
    ["add_grapes_to_barrel"] = "Dodaj grožđe u bačvu",
    ["add_more_item"] = "Dodaj još %s",
    ["start_fermentation"] = "Započni fermentaciju",
    ["fill_bottles"] = "Napuni boce",
    ["refresh"] = "Osveži",
    ["time_remaining"] = "Preostalo vreme: %s",

    ["select_order_size_title"] = "Veličina porudžbine",
    ["select_order_size_ox_title"] = "Izaberite veličinu porudžbine",
    ["small_order_title"] = "Mala porudžbina",
    ["small_order_context"] = "Ovaj tip porudžbine je idealan ako planirate da radite sami. Potrebno je manje predmeta u porudžbini!",
    ["large_order_title"] = "Velika porudžbina",
    ["large_order_context"] = "Ovaj tip porudžbine je idealan ako planirate da radite u timu. Potrebno je više predmeta u porudžbini!",


    ["sell_label"] = "Prodaj - %s", -- %s = item label
    ["price_context"] = "Cena: $%s", -- %s = price variable
    ["start_packaging_title"] = "Započni pakovanje porudžbine",
    ["total_price_title"] = "Ukupna cena: %s$", -- %s = total price variable


    ["money_printer_title"] = "Mašina za štampanje novca",
    ["money_printer_context"] = "List: %sx, Crno mastilo: %sx, Kolor mastilo: %sx", -- %s = sheet, %s = black ink, %s = color ink
    ["money_printer_machine_add_sheet"] = "Dodaj list",
    ["money_printer_machine_remove_sheet"] = "Ukloni list",
    ["money_printer_machine_add_ink"] = "Dodaj mastilo",
    ["money_printer_machine_remove_ink"] = "Ukloni mastilo",
    ["money_printer_chose_ink_title"] = "Izaberite tip mastila",
    ["add_black_ink"] = "Dodaj crno mastilo",
    ["add_color_ink"] = "Dodaj kolor mastilo",
    ["remove_black_ink"] = "Ukloni crno mastilo",
    ["remove_color_ink"] = "Ukloni kolor mastilo",

    ["money_printer_machine_start_printing"] = "Započni štampanje",
    ["money_printer_machine_takeout_printed_money_sheet"] = "Izvadi %s",

    ["printed_money_sheet"] = "Odštampani list novca",

    ["microscope_title"] = "Mikroskop",

    ["cutting_table_title"] = "Sto za sečenje",

    -- Admin menu
    ["admin_menu_title"] = "Admin meni — štampač novca",
    ["create_new"] = "Kreiraj novi",
    ["cutting_table"] = "sto za sečenje",
    ["printer_machine"] = "mašina za štampanje",
    ["s"] = " — lista",
    ["teleport"] = "Teleportuj se do",
    ["delete"] = "Obriši",
    ["index"] = "Indeks",
    ["list"] = "lista",
    ["coords"] = "Koordinate",
    ["options"] = "Opcije",
    ["list_context"] = "Kliknite da vidite listu objekata.",
    ["create_context"] = "Kliknite da kreirate novi %s objekat."

 }

Config.InputMenu = {
    ["buy_enter_amount"] = "Unesite količinu %s za kupovinu.", -- %s = item label
    ["enter_amount"] = "Unesite količinu %s za dodavanje.", -- %s = item label
    ["amount"] = "Količina?",
}

Config.TargetLabels = {
    -- ["name" - don't change this] = set text that will be displayed in target menu.
    ["shop"] = "Otvori prodavnicu",
    ["pick_up"] = "Podigni %s", -- %s = item label
    ["place"] = "Postavi %s", -- %s = item label
    ["blueprint_shop"] = "Trgovac šablonima",
    ["search_printer"] = "Pretraži štampač",
    ["large_print_machine"] = "Mašina za štampanje novca",
    ["certify_money_sheet"] = "Overi list novca",
    ["start_hacking"] = "Započni hakovanje",
    ["cutting_table"] = "Iseci odštampani list novca",
}

Config.TargetIcons = {
    -- ["name" - don't change this] = set icon that will be displayed target menu.
    ["hand"] = "fas fa-hand",
    ["dollar"] = "fas fa-dollar",
    ["shop"] = "fas fa-shopping-cart",
    ["search"] = "fas fa-search",
    ["large_print_machine"] = "fas fa-print",
    ["place"] = "fas fa-hand-paper",
    ["stamp"] = "fas fa-stamp",
    ["hacking"] = "fas fa-laptop-code",
    ["cutting_table"] = "fas fa-cut",
}
