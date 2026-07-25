Config = {}

Config.MechanicJobs = {
    'autoumro',
    'autofuseraj',
}

local mechanicJobLookup = {}
for i = 1, #Config.MechanicJobs do
    mechanicJobLookup[Config.MechanicJobs[i]] = true
end

function Config.IsMechanicJob(jobName)
    return jobName ~= nil and mechanicJobLookup[jobName] == true
end

Config.MaxVehicleDistance = 5.0

Config.CleanDuration = 5000

Config.MenuKey = 'F6'

Config.Sefovi = {
    {
        coords = vec4(1072.7438, -882.7156, 55.6627, 291.9901),
        model = 'sf_prop_v_43_safe_s_bk_01a',
        sifra = '1207',
        stashId = 'autoumro',
        slotovi = 150,
        tezina = 500,
        label = 'Auto Umro | Sef',
        minGrade = 0,
    },
    {
        coords = vec4(123.2090, 325.4239, 112.1258, 199.6386),
        model = 'sf_prop_v_43_safe_s_bk_01a',
        sifra = '0810',
        stashId = 'pranjenovca',
        slotovi = 150,
        tezina = 500,
        label = 'Pranje Novca | Sef',
        minGrade = 0,
    },
    {
        coords = vec4(-993.5329, -1502.4679, 5.7874, 303.7260),
        model = 'sf_prop_v_43_safe_s_bk_01a',
        sifra = '0810',
        stashId = 'autoumro_autosalon',
        slotovi = 150,
        tezina = 500,
        label = 'Auto Salon | Sef',
        minGrade = 0,
    },
    {
        coords = vec4(-349.6110, -1326.7432, 31.4548, 359.9774),
        model = 'sf_prop_v_43_safe_s_bk_01a',
        sifra = '0810',
        stashId = 'autofuseraj_autosalon',
        slotovi = 150,
        tezina = 500,
        label = 'Auto Fuseraj | Sef',
        minGrade = 0,
    },
}
