Config = {
    FlashbangRadius = 15.0,
    StunDuration = 5000,
    FlashAffectsNPCs = false,
    CookTime = 3000, -- milliseconds
    FlashIntensity = 1.0 -- from 0.1 (light) to 1.0 (full)
}

Config.AntiFlashMasks = {
    [36] = true, -- example: ID of mask model
    [52] = true, -- add as many as needed
}

Config.MaskProtectionStrength = 'partial' -- options: 'none', 'partial', 'full'

Config.MultiFlashbang = {
    enabled = true,
}
