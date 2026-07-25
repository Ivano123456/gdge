Locales = {
    hr = {
        blipname = 'Pljacka Jahte',
        start_robbery = '[E] Zapocni pljacku',
        search_robbery = '[E] Pretrazi',
        searching = 'Pretrazujes...',
        search_blip = 'Pretraga',
        suitcase_found = 'Jahta je potpuno opljackana!',
        robbed_recent = 'Jahta je vec u pljacki ili nedavno opljackana.',
        police = 'Nema dovoljno policije.',
        cooldown = 'Jahta je nedavno opljackana. Pricekajte.',
        robbery_started = 'Pljacka je zapocela! Pretrazite oznacene lokacije.',
        pd_alert = 'Pljacka jahte u tijeku — reagirajte na lokaciju.',
        too_far = 'Predaleko od jahte — pljacka prekinuta.',
        too_far_start = 'Niste dovoljno blizu mjesta za pocetak.',
        crowd = 'Uklonite ljude u blizini.',
        cant_rob = 'Policija ne moze pokrenuti pljacku.',
        start_failed = 'Pljacka nije mogla biti pokrenuta.',
        spots_left = 'Preostalo lokacija: %s',
        pd_boat = 'Policijski brod',
        pd_heli = 'Policijski helikopter',
        pd_ready = '%s spreman.',
    },
}

function _U(key)
    local L = Locales[Config.Locale]
    return (L and L[key]) or key
end
