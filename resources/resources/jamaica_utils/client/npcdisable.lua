local cfg = Config.NpcDisable

if not cfg or not cfg.enabled then
    return
end

CreateThread(function()
    if cfg.disableRandomCops then
        SetCreateRandomCops(false)
        SetCreateRandomCopsNotOnScenarios(false)
        SetCreateRandomCopsOnScenarios(false)
    end

    if cfg.disableGarbageTrucks then
        SetGarbageTrucks(false)
    end

    if cfg.disableRandomBoats then
        SetRandomBoats(false)
    end

    if cfg.disableDistantCopCars then
        DistantCopCarSirens(false)
    end

    if cfg.disableParkedVehicleGenerators then
        SetNumberOfParkedVehicles(0)
    end

    local spheres = cfg.spheres
    if spheres then
        for i = 1, #spheres do
            local s = spheres[i]
            AddPopMultiplierSphere(s.coords.x, s.coords.y, s.coords.z, s.radius, s.pedMult or 0.0, s.vehMult or 0.0)
        end
    end

    local areas = cfg.areas
    if areas then
        for i = 1, #areas do
            local a = areas[i]
            AddPopMultiplierArea(a.pos1.x, a.pos1.y, a.pos1.z, a.pos2.x, a.pos2.y, a.pos2.z, a.pedMult or 0.0, a.vehMult or 0.0)
        end
    end
end)

CreateThread(function()
    local pedDensity = cfg.pedDensity or 0.0
    local scenarioInterior = cfg.scenarioPedInterior or 0.0
    local scenarioExterior = cfg.scenarioPedExterior or 0.0
    local vehicleDensity = cfg.vehicleDensity or 0.0
    local randomVehicleDensity = cfg.randomVehicleDensity or 0.0
    local parkedVehicleDensity = cfg.parkedVehicleDensity or 0.0
    local pedBudget = cfg.pedPopulationBudget
    local vehBudget = cfg.vehiclePopulationBudget
    local usePedBudget = pedBudget ~= nil
    local useVehBudget = vehBudget ~= nil

    while true do
        SetPedDensityMultiplierThisFrame(pedDensity)
        SetScenarioPedDensityMultiplierThisFrame(scenarioInterior, scenarioExterior)
        SetVehicleDensityMultiplierThisFrame(vehicleDensity)
        SetRandomVehicleDensityMultiplierThisFrame(randomVehicleDensity)
        SetParkedVehicleDensityMultiplierThisFrame(parkedVehicleDensity)

        if usePedBudget then
            SetPedPopulationBudget(pedBudget)
        end

        if useVehBudget then
            SetVehiclePopulationBudget(vehBudget)
        end

        Wait(0)
    end
end)
