-- PLEASE do not modify this file unless you know what you are doing!!!
-- It is well commented and easy to understand.
-- any questions please open a ticket on discord.

Config = Config or {}

-- Debug settings
Config.Debug = false -- Set to true to enable debug messages

-- Camera Surveillance System Configuration
Config.CameraSystem = {
    -- Camera placement settings
    MaxCamerasPerPlayer = 10,
    MaxDistanceFromPlayer = 15.0,
    
    -- Camera viewing settings
    CameraViewDistance = 50.0,
    CameraRotationSpeed = 0.7,
    CameraZoomSpeed = 0.5,
    
    -- Camera access permissions
    RequirePermission = true, -- Set to false to allow all players to access cameras
    AllowedJobs = {
        ['police'] = true
    },
    
    -- Camera UI settings
    ShowCameraInfo = true,
    ShowCoordinates = true,
    ShowTimestamp = true
}

-- Microphone Surveillance System Configuration
Config.MicrophoneSystem = {
    -- Microphone placement settings
    MaxMicrophonesPerPlayer = 5,
    PlacementDistance = 3.0,        -- Maximum distance to place microphone on target
    RequiredItem = 'nanospymic',    -- Item required in inventory to place microphone
    ConsumeItemOnPlacement = true,  -- Whether to remove item from inventory when placed
    
    -- Audio surveillance settings
    SurveillanceChannelBase = 5000, -- Base channel ID for surveillance (5000 + micId)
    ProximityRange = 15.0,          -- Range to detect nearby players around target
    AudioUpdateInterval = 5000,     -- OPTIMIZED: Increased from 1000ms to 5000ms (5 seconds)
    MaxSurveillanceTime = 60 * 60 * 1000, -- Maximum surveillance time per microphone (1 hour)
    
    -- One-way audio settings
    EnableOneWayAudio = true,       -- Enable one-way audio (targets can't hear spy)
    SpyCanHearTarget = true,        -- Spy can hear target and nearby players
    TargetCanHearSpy = false,       -- Target cannot hear spy (one-way surveillance)
    ProximityPlayersCanHearSpy = false, -- Nearby players cannot hear spy
    
    -- Microphone access permissions
    RequirePermission = false, -- Set to false for testing
    AllowedJobs = {
        ['police'] = true,
    },
    
    -- Audio quality settings
    UseSubmixEffects = true,        -- Apply audio effects to simulate surveillance quality
    SubmixVolume = 0.8,            -- Volume multiplier for surveillance audio
    
    -- UI stealth settings
    HideCallUIFromTargets = true,   -- Hide call UI from targets being spied on
    HideCallUIFromSpies = true,    -- Hide call UI from spies (set true for full stealth)
    
    -- UI settings
    ShowTargetInfo = true,          -- Show target player information in tablet
    ShowProximityPlayers = true,    -- Show list of nearby players being monitored
    ShowMicrophoneStatus = true,    -- Show microphone battery/status
    
    -- Automatic cleanup settings
    AutoCleanupOnDisconnect = true, -- Remove microphones when target disconnects
    CleanupDelay = 30000,          -- Delay before cleanup when target disconnects (ms)
    
    -- Target notification settings
    NotifyTargetOnTimerFailure = true, -- Notify target when spy timer runs out
    TargetNotificationMessage = 'Primetio si nekog ko se ponasa sumnjivo oko tebe...', -- Custom message for target
}

-- Camera types and their properties
Config.CameraTypes = {
    ['nano_spy_cam'] = {
        label = 'Nano Spy Kamera',
        model = 'nano_spy_cam',
        range = 30.0,
        quality = 'high',
        nightVision = true,
        thermalVision = false
    },
    ['prop_security_case_01'] = {
        label = 'Sigurnosna Kamera',
        model = 'prop_security_case_01',
        range = 20.0,
        quality = 'medium',
        nightVision = false,
        thermalVision = false
    }
}

-- Default camera settings
Config.DefaultCamera = {
    fov = 80.0,
    rotationSpeed = 0.7,
    zoomLevels = {0.5, 1.0, 2.0, 4.0},
    defaultZoom = 1.0
}

-- Camera controls
Config.CameraControls = {
    RotateUp = 32,      -- W
    RotateDown = 33,    -- S
    RotateLeft = 34,    -- A
    RotateRight = 35,   -- D
    ZoomIn = 241,       -- Scroll Up
    ZoomOut = 242,      -- Scroll Down
    SwitchCamera = 194, -- Backspace
    ExitCamera = 177    -- Escape
}

-- Object placement controls (for placing spy cameras)
-- Control IDs: https://docs.fivem.net/docs/game-references/controls/
-- Two modes: FOLLOW mode (object follows camera) and GIZMO mode (XYZ axis handles like object_gizmo)
Config.PlacementControls = {
    Place = 38,             -- E (confirm placement)
    Cancel = 177,           -- Backspace (cancel placement)
    RotateCW = 14,          -- Scroll Up (rotate clockwise) [follow mode]
    RotateCCW = 15,         -- Scroll Down (rotate counter-clockwise) [follow mode]
    DistanceModifier = 36,  -- Ctrl (hold + scroll to change distance) [follow mode]
    HeightUp = 44,          -- Q (raise object) [follow mode]
    HeightDown = 20,        -- Z (lower object) [follow mode]
    SnapGround = 19,        -- Alt (toggle ground snap) [follow mode]
    ToggleEditMode = 168,   -- F7 (switch between follow and gizmo mode)
}

-- Key labels for the placement HUD (what to display on screen)
-- Follow mode labels
Config.PlacementKeyLabels = {
    Place = "E",
    Cancel = "BACKSPACE",
    Rotate = "SCROLL",
    Distance = "CTRL + SCROLL",
    HeightUp = "Q",
    HeightDown = "Z",
    SnapGround = "ALT",
    ToggleEditMode = "F7",
    -- Gizmo mode labels (these are RegisterKeyMapping binds, changeable in FiveM settings)
    GizmoTranslate = "W",
    GizmoRotate = "R",
    GizmoLocal = "Q",
    GizmoGround = "ALT",
    GizmoCursor = "G",
}

-- Battery system configuration
Config.BatterySystem = {
    -- Enable/disable battery drain system
    Enabled = true,
    
    -- Real-time update settings
    RealTimeUpdates = true,         -- Send real-time battery updates to clients
    UpdateClientsInterval = 10000,  -- How often to update clients (in milliseconds) - 10 seconds
    
    -- Device types excluded from battery drain (set to true to exclude)
    ExcludedTypes = {
        ['gps'] = false,        -- GPS trackers use battery (set to true to disable)
        ['microphone'] = false,  -- Microphones don't use battery
        ['camera'] = false      -- Cameras use battery (set to true to disable)
    },
    
    -- Device-specific battery settings (all battery settings are defined per device type)
    DeviceSettings = {
        ['camera'] = {
            DrainAmount = 1,                    -- Battery drain per interval (percentage)
            DrainInterval = 15 * 60 * 1000,     -- 15 minutes
            LowBatteryThreshold = 20,           -- Warning threshold
            CriticalBatteryThreshold = 5        -- Critical threshold
        },
        ['gps'] = {
            DrainAmount = 2,                    -- GPS trackers drain 2% per interval
            DrainInterval = 5 * 60 * 1000,      -- 5 minutes
            LowBatteryThreshold = 15,           -- Warning threshold (lower for GPS)
            CriticalBatteryThreshold = 3        -- Critical threshold (lower for GPS)
        },
        ['microphone'] = {
            DrainAmount = 3,                    -- Microphones drain 3% per interval
            DrainInterval = 5 * 60 * 1000,      -- 5 minutes
            LowBatteryThreshold = 20,           -- Warning threshold
            CriticalBatteryThreshold = 5        -- Critical threshold
        }
    }
}

-- Time conversion reference (all values in milliseconds):
-- 1 second = 1 * 1000
-- 5 seconds = 5 * 1000  
-- 10 seconds = 10 * 1000
-- 30 seconds = 30 * 1000

-- 1 minute = 60 * 1000
-- 2 minutes = 2 * 60 * 1000
-- 5 minutes = 5 * 60 * 1000
-- 10 minutes = 10 * 60 * 1000
-- 15 minutes = 15 * 60 * 1000
-- 30 minutes = 30 * 60 * 1000

-- 1 hour = 60 * 60 * 1000
-- 2 hours = 2 * 60 * 60 * 1000
-- 3 hours = 3 * 60 * 60 * 1000
-- 6 hours = 6 * 60 * 60 * 1000
-- 12 hours = 12 * 60 * 60 * 1000
-- 24 hours = 24 * 60 * 60 * 1000

-- GPS driving update interval (milliseconds)
Config.GPSDrivingUpdateInterval = 10000 -- OPTIMIZED: Increased from 3000ms to 10000ms (10 seconds)

-- Jobs with full device access: can see and manage ALL gadgets (cameras, microphones, GPS) in the
-- tablet and on the map (including others' devices). Affects: tablet device list, GPS blips and
-- updates, camera list, microphone access, GPS remove/toggle. Set to false or remove a job to
-- disable (e.g. ['police'] = false to disable police from seeing any gadgets).
Config.JobsWithFullDeviceAccess = {
    ['police'] = false,
    ['sheriff'] = false,
    -- ['fbi'] = true,   -- Add other jobs as needed
}

-- Digiscanner Detection System Configuration
Config.DigiscannerSystem = {
    -- Enable/disable digiscanner system
    Enabled = true,
    
    -- Digiscanner item and model settings
    RequiredItem = 'digiscanner',           -- Item required in inventory to use digiscanner
    ScannerModel = 'w_am_digiscanner',      -- Model name for the digiscanner
    ScannerHash = 520317490,                -- Hash for the digiscanner model
    
    -- Attachment settings (for ped holding the scanner)
    AttachmentBone = 28422,                 -- Bone ID for attachment (right hand)
    AttachmentOffset = {                    -- Position offset for attachment
        x = 0.048,
        y = 0.078,
        z = 0.004
    },
    AttachmentRotation = {                  -- Rotation for attachment
        x = -81.6893,
        y = 2.5616,
        z = -15.7909
    },
    
    -- Detection settings
    MaxDetectionRange = 15.0,               -- Maximum range to detect spy devices (meters)
    MinDetectionRange = 0.0,                -- Minimum range for strongest signal
    UpdateInterval = 500,                   -- How often to check for devices (ms)
    
    -- Beeping settings
    BeepSoundName = 'BEEP_RED',             -- Sound name for beeping
    BeepSoundSet = 'TIMED_INTERACTION_SOUNDS', -- Sound set for beeping
    MaxBeepInterval = 2000,                 -- Slowest beep interval (ms) - far devices
    MinBeepInterval = 200,                  -- Fastest beep interval (ms) - close devices
    
    -- Visual feedback settings
    ShowDistanceText = true,                -- Show distance to nearest device
    ShowDeviceCount = true,                 -- Show number of devices detected
    ShowDeviceType = false,                 -- Show type of device detected (GPS/Mic/Camera)
    
    -- Battery settings
    BatteryDrainPerScan = 1,              -- Battery drain per scan cycle (percentage)
    BatteryDrainInterval = 5000,            -- How often to drain battery (ms)
    LowBatteryThreshold = 20,               -- Warning threshold for low battery
    
    -- Access permissions
    RequirePermission = false,              -- Set to true to restrict access
    AllowedJobs = {
        ['police'] = true
    },
    
    -- Detection chances (0.0 to 1.0)
    BaseDetectionChance = 1,
    JobBonuses = {
        ['police'] = 0.15
    },
    
    -- Device type detection settings
    DeviceDetection = {
        ['gps'] = {
            detectable = true,
            detectionChance = 1,          -- GPS devices are easier to detect
            label = 'GPS Tracker'
        },
        ['microphone'] = {
            detectable = true,
            detectionChance = 1,          -- Microphones are harder to detect
            label = 'Audio Uredjaj'
        },
        ['camera'] = {
            detectable = true,
            detectionChance = 0.8,          -- Cameras are moderately detectable
            label = 'Kamera'
        }
    },
    
    -- GPS Removal System Configuration
    GPSRemoval = {
        -- Enable/disable GPS removal functionality
        Enabled = true,
        
        -- Distance settings
        MaxRemovalDistance = 3.0,           -- Maximum distance to remove GPS (meters)
        MinRemovalDistance = 0,           -- Minimum distance for optimal removal
        
        -- Removal process settings
        RemovalTime = 4000,                 -- Time to remove GPS (ms) - 4 seconds
        ProgressBarText = 'Trazis GPS uredjaj...',
        
        -- Success rates by job
        RemovalSuccessRates = {
            ['police'] = 0.85,
            ['default'] = 0.70
        },
        
        -- Failure consequences
        FailureChance = {
            ['damage_vehicle'] = 0.2,       -- 20% chance to damage vehicle on failure
            ['alert_owner'] = 0.3,          -- 30% chance to alert GPS owner on failure
            ['break_scanner'] = 0.1         -- 10% chance to temporarily break scanner
        },
        
        -- Notification settings
        SuccessMessage = 'GPS uredjaj uspesno uklonjen!',
        FailureMessage = 'Nije uspelo ukloniti GPS uredjaj...',
        
        -- Item rewards
        GiveRemovedGPS = true,              -- Give player the GPS item when removed
        GPSItemName = 'nanospygps',         -- Item name to give (should match your items)
        
        -- Cooldown settings
        RemovalCooldown = 2000,             -- Cooldown between removal attempts (ms)
        FailureCooldown = 5000              -- Longer cooldown after failure (ms)
    },
    
    -- Microphone Removal System Configuration
    MicrophoneRemoval = {
        -- Enable/disable microphone removal functionality
        Enabled = true,
        
        -- Distance settings
        MaxRemovalDistance = 1.0,           -- Maximum distance to remove microphone (meters)
        MinRemovalDistance = 0,           -- Minimum distance for optimal removal
        
        -- Removal process settings
        RemovalTime = 3000,                 -- Time to remove microphone (ms) - 3 seconds
        ProgressBarText = 'Trazis audio uredjaj...',
        
        -- Success rates by job
        RemovalSuccessRates = {
            ['police'] = 0.90,              -- Police have very good success rate
            ['sheriff'] = 0.90,
            ['mechanic'] = 0.75,            -- Mechanics are decent
            ['detective'] = 0.95,           -- Detectives are excellent
            ['security'] = 0.85,
            ['default'] = 1              -- Default success rate for other jobs
        },
        
        -- Failure consequences
        FailureChance = {
            ['alert_owner'] = 0.4,          -- 40% chance to alert microphone owner on failure
            ['break_scanner'] = 0.15        -- 15% chance to temporarily break scanner
        },
        
        -- Notification settings
        SuccessMessage = 'Audio uredjaj uspesno uklonjen!',
        FailureMessage = 'Nije uspelo ukloniti audio uredjaj...',
        
        -- Item rewards
        GiveRemovedMicrophone = true,       -- Give player the microphone item when removed
        MicrophoneItemName = 'nanospymic',  -- Item name to give (should match your items)
        
        -- Cooldown settings
        RemovalCooldown = 2000,             -- Cooldown between removal attempts (ms)
        FailureCooldown = 5000              -- Longer cooldown after failure (ms)
    }
}

-- Low Battery Notification System
Config.LowBatteryNotifications = {
    -- Enable/disable low battery notifications for targets
    Enabled = true,
    
    -- Notification settings
    NotificationInterval = 5 * 60 * 1000,   -- How often to send notifications (5 minutes)
    NotificationChance = 0.3,               -- Chance to send notification each interval (30%)
    
    -- Notification messages for different devices
    Messages = {
        ['gps'] = {
            'Motor vozila zvuci malo grubo danas.',
            'Kontrolna ploca vozila svetli nekad.',
            'Primetio si da GPS na telefonu ne radi.',
            'Radio vozila ima neke smetnje.',
            'Vozilo se cini da treba da se popravi.'
        },
        ['microphone'] = {
            'Primetio si mali zvuk iz telefona.',
            'Cini se da je pozadinska smetnja kada razgovaraj.',
            'Glas se drugačiji u ovoj sobi.',
            'Primetio si mali zvuk.',
            'Primetio si mali zvuk.'
        },
        ['camera'] = {
            'Imas neugodan osećaj o ovom mestu.',
            'Nesto se zadire u oči za trenutak.',
            'Primetio si malo svetlosti koja se odbija od nečega.',
            'Primetio si malo svetlosti koja se odbija od nečega.',
            'Primetio si malo svetlosti koja se odbija od nečega.'
        }
    },
    
    -- Target notification settings
    ShowNotificationToTarget = true,        -- Show notifications to the target
    NotificationDuration = 3000,            -- How long to show notification (ms)
    NotificationType = 'primary',           -- Type of notification (primary, warning, error)
    
    -- Battery thresholds for notifications
    BatteryThresholds = {
        low = 25,                           -- Start sending notifications at 25% battery
        critical = 10                       -- More frequent notifications at 10% battery
    }
}

-- Locale: "en" | "zh" | "ja" | "fr" | "pt" | "es"
Config.Locale = "en"

Config.Translations = {
    en = {
        -- Camera
        invalid_camera_data = "Neispravna kamera podataka",
        camera_controls_hint = "WASD = Rotiraj | Backspace = Izlaz",
        camera_controls_esc = "WASD: Rotiraj Kamera | ESC = Izlaz",
        no_cameras = "Nema kamera dostupnih",
        camera_saved = "Kamera sacuvana u nadzornu sistem",
        camera_removed = "Kamera uklonjena iz nadzorne sisteme",
        already_viewing_camera = "Vec gledas kamera!",
        camera_view_closed = "Pogled kamera zatvoren",
        already_placing_camera = "Vec postavljas kamera!",
        camera_placed = "Nano spy camera uspesno postavljena!",
        camera_placement_cancelled = "Postavljanje kamera otkazano",
        camera_too_far = "Kamera je predaleko! Postavljanje otkazano.",
        camera_failed_create = "Nije uspelo kreirati kamera!",
        camera_failed_save = "Nije uspelo sacuvati kamera u database!",
        use_placer = "Postavi kamera i klikni da postavis!",
        placer_help = "~INPUT_CELLPHONE_SELECT~ Postavi | ~INPUT_CELLPHONE_CANCEL~ Otkazi | Scroll: Rotiraj | Ctrl+Scroll: Distance | Q/Z: Height | Alt: Snap Ground",
        spy_camera_destroyed = "Kamera uništena!",
        destroy_spy_camera = "Uništi Kamera",
        collected_cameras = "Skupljene %s spy kamera(e)",
        no_cameras_nearby = "Nema spy kamera u blizini da se skupi",
        camera_corrupted = "Kamera podataka je oštećena!",
        camera_offline = "Kamera je offline!",
        camera_not_found = "Kamera nije pronađena!",
        -- Tablet UI
        device_network = "DEVICE NETWORK",
        cameras = "CAMERAS",
        microphones = "MICROPHONES",
        gps_trackers = "GPS TRACKERS",
        search_placeholder = "Search devices, IDs, or player names...",
        filters = "FILTERS",
        clear_all = "CLEAR ALL",
        status_filter = "STATUS FILTER",
        device_type = "DEVICE TYPE",
        battery_level = "BATTERY LEVEL",
        all_status = "All Status",
        online = "Online",
        offline = "Offline",
        warning = "Warning",
        error = "Error",
        all_types = "All Types",
        all_levels = "All Levels",
        low_battery = "Low (≤30%%)",
        medium_battery = "Medium (31-70%%)",
        high_battery = "High (>70%%)",
        spy_cam = "SPY CAM",
        audio_monitor = "AUDIO MONITOR",
        gps_tracker = "GPS TRACKER",
        access_camera = "ACCESS_CAMERA",
        live_feed = "LIVE FEED",
        connected = "CONNECTED",
        battery = "Battery",
        nano_spy_init = "Nano spy system initialized",
        close = "Close",
        power_off = "POWER OFF",
        -- Microphone
        mic_placement_init = "Surveillance microphone placement initiated...",
        mic_no_target = "Error: No target specified for microphone placement!",
        mic_exited = "Exited without placing device",
        mission_failed_timer = "Mission failed! Timer ran out - target was alerted!",
        mission_failed_alerted = "Mission failed! Target was alerted!",
        mission_failed_timer_short = "Mission failed! Timer ran out!",
        place_spy_mic = "Place Spy Microphone",
        remove_surv_mic = "Remove Surveillance Microphone",
        mic_removal_triggered = "Microphone removal action triggered",
        mic_no_longer_detected = "Microphone no longer detected",
        mic_need_item = "You need a %s to place a surveillance microphone!",
        mic_invalid_target = "Invalid target entity!",
        mic_target_gone = "Target entity no longer exists!",
        mic_unable_id = "Unable to identify target player!",
        mic_no_found = "No microphone found on target!",
        mic_already_placing = "You are already placing a microphone!",
        mic_target_far = "Target is too far away!",
        mic_placing = "Initiating microphone placement...",
        mic_placed = "Surveillance microphone placed successfully!",
        mic_active = "Surveillance audio active - monitoring target",
        mic_stopped = "Surveillance audio stopped",
        mic_removed = "Surveillance microphone removed",
        mic_battery_critical = "Microphone %s battery critical: %s%%",
        mic_battery_low = "Microphone %s battery low: %s%%",
        mic_battery_depleted = "Microphone %s battery depleted - surveillance stopped",
        -- GPS
        already_placing_gps = "You are already placing a GPS tracker!",
        no_vehicle_nearby = "No vehicle nearby to place GPS tracker!",
        no_license_plate = "Vehicle has no license plate!",
        installing_gps = "Installing GPS tracker...",
        gps_marked_map = "GPS tracker location marked on map for 30 seconds",
        gps_removal_triggered = "GPS removal action triggered",
        gps_no_longer_detected = "GPS tracker no longer detected",
        gps_removal_cancelled = "GPS removal cancelled",
        gps_depleted_offline = "GPS tracker battery depleted - device offline",
        -- Digiscanner
        digiscanner_activated = "Digiscanner activated",
        digiscanner_deactivated = "Digiscanner deactivated",
        digiscanner_deactivated_vehicle = "Digiscanner deactivated - entered vehicle",
        digiscanner_battery_depleted = "Digiscanner battery depleted!",
        digiscanner_battery_low = "Digiscanner battery low: %s%%",
        progress_bar_unavailable = "Progress bar system not available",
        removing_gps = "Removing GPS Tracker",
        damaged_vehicle = "You damaged the vehicle while searching!",
        scanner_malfunctioned = "Your digiscanner malfunctioned!",
        scanner_malfunction_removal = "Your scanner malfunctioned during the removal attempt!",
        scanner_working_again = "Scanner is working again",
        mic_removal_cancelled = "Microphone removal cancelled",
        remove_gps_tracker = "Remove GPS Tracker",
        removing_surv_mic = "Removing surveillance microphone...",
        -- Dashboard & tablet UI (full)
        tab_device_network = "DEVICE NETWORK",
        tab_device_network_desc = "Spy equipment overview",
        tab_proximity_radar = "PROXIMITY RADAR",
        tab_proximity_radar_desc = "Distance-based device mapping",
        tab_device_control = "DEVICE CONTROL",
        tab_device_control_desc = "Live feeds and device management",
        brand_nano = "NANO",
        brand_spy_system = "SPY SYSTEM",
        status_connected = "STATUS: CONNECTED",
        system_label = "SYSTEM",
        network_label = "NETWORK",
        secure_label = "SECURE",
        power_label = "POWER",
        alerts_label = "ALERTS",
        system_alerts = "SYSTEM ALERTS",
        all_systems_nominal = "ALL SYSTEMS NOMINAL",
        no_active_alerts = "No active alerts detected",
        devices_online = "DEVICES ONLINE",
        warnings_count = "WARNINGS",
        errors_count = "ERRORS",
        active_tab = "ACTIVE TAB",
        selected_label = "SELECTED",
        nano_os_build = "NANO-OS v2.1.4 | BUILD 2024.03.15",
        control_tab = "CONTROL",
        config_tab = "CONFIG",
        edit_camera_name = "Edit camera name",
        save_name = "Save name",
        cancel = "Cancel",
        select_device = "Select a device...",
        loading_device_settings = "Loading device settings...",
        battery_upper = "BATTERY",
        critical_battery = "CRITICAL",
        pwr_core = "PWR_CORE",
        status_online_dot = "ONLINE",
        status_offline_dot = "OFFLINE",
        enable_gps = "ENABLE GPS",
        shutdown_gps = "SHUTDOWN GPS",
        shutdown_sys = "SHUTDOWN SYS",
        boot_system = "BOOT SYSTEM",
        core_state = "CORE_STATE",
        operational = "OPERATIONAL",
        dormant = "DORMANT",
        uptime = "UPTIME",
        critical_battery_full = "CRITICAL BATTERY",
        surveillance_label = "SURVEILLANCE",
        active_dot = "ACTIVE",
        one_way = "ONE-WAY",
        target_label = "TARGET",
        unknown_target = "Unknown Target",
        status_available = "Available",
        stop_surveillance = "STOP SURVEILLANCE",
        start_surveillance = "START SURVEILLANCE",
        proximity_monitoring = "PROXIMITY MONITORING",
        realtime_spy_stream = "Real-time spy stream",
        streaming = "STREAMING",
        audio_stream = "AUDIO STREAM",
        sample_rate = "Sample Rate: 48kHz | 16-bit",
        codec_info = "Codec: AAC | Bitrate: 320 kbps",
        noise_reduction = "Noise Reduction: Active",
        gps_tracking = "GPS TRACKING",
        latitude = "LATITUDE",
        longitude = "LONGITUDE",
        altitude = "ALTITUDE",
        locate_on_map = "LOCATE ON MAP",
        accuracy_info = "Accuracy: ±1.2m | Satellites: 12",
        update_rate_info = "Update Rate: 3-5s | Vehicle Tracking",
        vehicle_label = "Vehicle",
        device_configuration = "DEVICE CONFIGURATION",
        device_name = "DEVICE NAME",
        device_id = "DEVICE ID",
        device_type_label = "DEVICE TYPE",
        minimap_blip = "MINIMAP BLIP",
        blip_visible = "Blip visible on minimap",
        blip_hidden = "Blip hidden from minimap",
        coordinates = "COORDINATES",
        player_id = "PLAYER ID",
        select_placeholder = "Select...",
        live_spy_monitoring = "Live spy equipment monitoring",
        id_label = "ID",
        player_label = "Player",
        model_label = "Model",
        location_label = "Location",
        est_time_left = "EST. TIME LEFT",
        last_activity = "Last Activity",
        just_now = "just now",
        time_m_ago = "%sm ago",
        time_h_ago = "%sh ago",
        time_d_ago = "%sd ago",
        no_devices_found = "NO DEVICES FOUND",
        no_devices_match = "No devices match your current filter criteria",
        low_battery_warning = "LOW BATTERY WARNING",
        tactical_map = "TACTICAL MAP",
        map_label = "MAP",
        devices_active = "DEVICES ACTIVE",
        coverage_area = "COVERAGE AREA",
        satellite_view = "SATELLITE VIEW",
        live_tracking = "LIVE TRACKING",
        map_controls = "MAP CONTROLS",
        distance_rings = "DISTANCE RINGS",
        fivem_coordinates = "FIVEM COORDINATES",
        device_types = "DEVICE TYPES",
        cameras_label = "CAMERAS",
        microphones_label = "MICROPHONES",
        gps_trackers_label = "GPS TRACKERS",
        device_status = "DEVICE STATUS",
        static_label = "STATIC",
        mobile_label = "MOBILE",
        proximity_analysis = "PROXIMITY ANALYSIS",
        target_info = "TARGET INFO",
        auth_title = "NANO SPY SYSTEM",
        auth_subtitle = "Advanced Spy Network Control System",
        biometric_auth = "BIOMETRIC AUTHENTICATION",
        touch_to_authenticate = "Place your finger on the sensor to authenticate...",
        authenticating = "Authenticating...",
        auth_success = "Authentication successful. Connecting to network...",
        secure = "SECURE",
        encrypted = "ENCRYPTED",
        active = "ACTIVE",
        monitored = "MONITORED",
        live_audio = "LIVE",
        offline_audio = "OFFLINE",
        complete = "COMPLETE",
        biometric_match = "Biometric match confirmed",
        establishing_connection = "Establishing secure connection...",
        scanning_biometric = "Scanning biometric authentication data...",
    },
    zh = {
        invalid_camera_data = "无效的摄像头数据",
        camera_controls_hint = "WASD = 旋转 | 退格 = 退出",
        camera_controls_esc = "WASD: 旋转摄像头 | ESC: 退出",
        no_cameras = "没有可用的摄像头",
        camera_saved = "摄像头已保存到监控系统",
        camera_removed = "摄像头已从监控系统移除",
        already_viewing_camera = "已在查看摄像头！",
        camera_view_closed = "摄像头视图已关闭",
        already_placing_camera = "您正在放置间谍摄像头！",
        camera_placed = "纳米间谍摄像头放置成功！",
        camera_placement_cancelled = "间谍摄像头放置已取消",
        camera_too_far = "摄像头距离太远！放置已取消。",
        camera_failed_create = "创建间谍摄像头失败！",
        camera_failed_save = "保存摄像头到数据库失败！",
        use_placer = "调整间谍摄像头位置，点击放置！",
        placer_help = "~INPUT_CELLPHONE_SELECT~ 放置 | ~INPUT_CELLPHONE_CANCEL~ 取消 | 滚轮: 旋转 | Ctrl+滚轮: 距离 | Q/Z: 高度 | Alt: 贴地",
        spy_camera_destroyed = "间谍摄像头已销毁！",
        destroy_spy_camera = "销毁间谍摄像头",
        collected_cameras = "已回收 %s 个间谍摄像头",
        no_cameras_nearby = "附近没有可回收的间谍摄像头",
        camera_corrupted = "摄像头数据损坏！",
        camera_offline = "摄像头已离线！",
        camera_not_found = "未找到摄像头！",
        device_network = "设备网络",
        cameras = "摄像头",
        microphones = "麦克风",
        gps_trackers = "GPS追踪器",
        search_placeholder = "搜索设备、ID 或玩家名称...",
        filters = "筛选",
        clear_all = "清除全部",
        status_filter = "状态筛选",
        device_type = "设备类型",
        battery_level = "电量等级",
        all_status = "全部状态",
        online = "在线",
        offline = "离线",
        warning = "警告",
        error = "错误",
        all_types = "全部类型",
        all_levels = "全部等级",
        low_battery = "低 (≤30%%)",
        medium_battery = "中 (31-70%%)",
        high_battery = "高 (>70%%)",
        spy_cam = "间谍摄像",
        audio_monitor = "音频监控",
        gps_tracker = "GPS追踪",
        access_camera = "访问摄像头",
        live_feed = "实时画面",
        connected = "已连接",
        battery = "电量",
        nano_spy_init = "纳米间谍系统已初始化",
        close = "关闭",
        power_off = "关机",
        mic_placement_init = "监控麦克风放置已启动...",
        mic_no_target = "错误：未指定麦克风放置目标！",
        mic_exited = "未放置设备即退出",
        mission_failed_timer = "任务失败！时间到 - 目标已被警告！",
        mission_failed_alerted = "任务失败！目标已被警告！",
        mission_failed_timer_short = "任务失败！时间到！",
        place_spy_mic = "放置间谍麦克风",
        remove_surv_mic = "移除监控麦克风",
        mic_removal_triggered = "已触发麦克风移除",
        mic_no_longer_detected = "未再检测到麦克风",
        mic_need_item = "您需要 %s 才能放置监控麦克风！",
        mic_invalid_target = "无效的目标实体！",
        mic_target_gone = "目标实体已不存在！",
        mic_unable_id = "无法识别目标玩家！",
        mic_no_found = "目标身上未找到麦克风！",
        mic_already_placing = "您正在放置麦克风！",
        mic_target_far = "目标距离太远！",
        mic_placing = "正在启动麦克风放置...",
        mic_placed = "监控麦克风放置成功！",
        mic_active = "监控音频已激活 - 正在监听目标",
        mic_stopped = "监控音频已停止",
        mic_removed = "监控麦克风已移除",
        mic_battery_critical = "麦克风 %s 电量严重不足：%s%%",
        mic_battery_low = "麦克风 %s 电量低：%s%%",
        mic_battery_depleted = "麦克风 %s 电量耗尽 - 监控已停止",
        already_placing_gps = "您正在放置 GPS 追踪器！",
        no_vehicle_nearby = "附近没有可放置 GPS 追踪器的车辆！",
        no_license_plate = "车辆没有车牌！",
        installing_gps = "正在安装 GPS 追踪器...",
        gps_marked_map = "GPS 追踪器位置已在地图上标记 30 秒",
        gps_removal_triggered = "已触发 GPS 移除",
        gps_no_longer_detected = "未再检测到 GPS 追踪器",
        gps_removal_cancelled = "GPS 移除已取消",
        gps_depleted_offline = "GPS 追踪器电量耗尽 - 设备离线",
        digiscanner_activated = "数码扫描仪已激活",
        digiscanner_deactivated = "数码扫描仪已关闭",
        digiscanner_deactivated_vehicle = "数码扫描仪已关闭 - 已进入车辆",
        digiscanner_battery_depleted = "数码扫描仪电量耗尽！",
        digiscanner_battery_low = "数码扫描仪电量低：%s%%",
        progress_bar_unavailable = "进度条系统不可用",
        removing_gps = "移除 GPS 追踪器",
        damaged_vehicle = "您在搜索时损坏了车辆！",
        scanner_malfunctioned = "您的数码扫描仪发生故障！",
        scanner_malfunction_removal = "移除过程中扫描仪发生故障！",
        scanner_working_again = "扫描仪已恢复正常",
        mic_removal_cancelled = "麦克风移除已取消",
        remove_gps_tracker = "移除 GPS 追踪器",
        removing_surv_mic = "正在移除监控麦克风...",
        tab_device_network = "设备网络",
        tab_device_network_desc = "间谍设备总览",
        tab_proximity_radar = "近距离雷达",
        tab_proximity_radar_desc = "基于距离的设备映射",
        tab_device_control = "设备控制",
        tab_device_control_desc = "实时画面与设备管理",
        brand_nano = "纳米",
        brand_spy_system = "间谍系统",
        status_connected = "状态：已连接",
        system_label = "系统",
        network_label = "网络",
        secure_label = "安全",
        power_label = "电源",
        alerts_label = "警报",
        system_alerts = "系统警报",
        all_systems_nominal = "系统正常",
        no_active_alerts = "暂无活动警报",
        devices_online = "在线设备",
        warnings_count = "警告",
        errors_count = "错误",
        active_tab = "当前标签",
        selected_label = "已选",
        nano_os_build = "NANO-OS v2.1.4 | 构建 2024.03.15",
        control_tab = "控制",
        config_tab = "配置",
        edit_camera_name = "编辑摄像头名称",
        save_name = "保存名称",
        cancel = "取消",
        select_device = "请选择设备...",
        loading_device_settings = "正在加载设备设置...",
        battery_upper = "电量",
        critical_battery = "严重",
        pwr_core = "电源核心",
        status_online_dot = "在线",
        status_offline_dot = "离线",
        enable_gps = "启用 GPS",
        shutdown_gps = "关闭 GPS",
        shutdown_sys = "关闭系统",
        boot_system = "启动系统",
        core_state = "核心状态",
        operational = "运行中",
        dormant = "休眠",
        uptime = "运行时间",
        critical_battery_full = "电量严重不足",
        surveillance_label = "监控",
        active_dot = "活动中",
        one_way = "单向",
        target_label = "目标",
        unknown_target = "未知目标",
        status_available = "可用",
        stop_surveillance = "停止监控",
        start_surveillance = "开始监控",
        proximity_monitoring = "近距离监控",
        realtime_spy_stream = "实时间谍流",
        streaming = "直播中",
        audio_stream = "音频流",
        sample_rate = "采样率：48kHz | 16位",
        codec_info = "编解码：AAC | 比特率：320 kbps",
        noise_reduction = "降噪：开启",
        gps_tracking = "GPS 追踪",
        latitude = "纬度",
        longitude = "经度",
        altitude = "海拔",
        locate_on_map = "在地图上定位",
        accuracy_info = "精度：±1.2m | 卫星：12",
        update_rate_info = "更新率：3-5秒 | 车辆追踪",
        vehicle_label = "车辆",
        device_configuration = "设备配置",
        device_name = "设备名称",
        device_id = "设备 ID",
        device_type_label = "设备类型",
        minimap_blip = "小地图标记",
        blip_visible = "小地图上显示标记",
        blip_hidden = "小地图上隐藏标记",
        coordinates = "坐标",
        player_id = "玩家 ID",
        select_placeholder = "选择...",
        live_spy_monitoring = "实时间谍设备监控",
        id_label = "ID",
        player_label = "玩家",
        model_label = "型号",
        location_label = "位置",
        est_time_left = "预计剩余时间",
        last_activity = "最后活动",
        just_now = "刚刚",
        time_m_ago = "%s分钟前",
        time_h_ago = "%s小时前",
        time_d_ago = "%s天前",
        no_devices_found = "未找到设备",
        no_devices_match = "没有符合当前筛选条件的设备",
        low_battery_warning = "电量不足警告",
        tactical_map = "战术地图",
        map_label = "地图",
        devices_active = "活动设备",
        coverage_area = "覆盖范围",
        satellite_view = "卫星视图",
        live_tracking = "实时追踪",
        map_controls = "地图控制",
        distance_rings = "距离环",
        fivem_coordinates = "FIVEM 坐标",
        device_types = "设备类型",
        cameras_label = "摄像头",
        microphones_label = "麦克风",
        gps_trackers_label = "GPS 追踪器",
        device_status = "设备状态",
        static_label = "静态",
        mobile_label = "移动",
        proximity_analysis = "近距离分析",
        target_info = "目标信息",
        auth_title = "纳米间谍系统",
        auth_subtitle = "高级间谍网络控制系统",
        biometric_auth = "生物识别认证",
        touch_to_authenticate = "请将手指放在传感器上以认证...",
        authenticating = "认证中...",
        auth_success = "认证成功。正在连接网络...",
        secure = "安全",
        encrypted = "加密",
        active = "活动",
        monitored = "已监控",
        live_audio = "直播",
        offline_audio = "离线",
        complete = "完成",
        biometric_match = "生物识别匹配确认",
        establishing_connection = "正在建立安全连接...",
        scanning_biometric = "正在扫描生物识别数据...",
    },
    ja = {
        invalid_camera_data = "無効なカメラデータ",
        camera_controls_hint = "WASD = 回転 | バックスペース = 終了",
        camera_controls_esc = "WASD: カメラ回転 | ESC: 終了",
        no_cameras = "利用可能なカメラがありません",
        camera_saved = "カメラを監視システムに保存しました",
        camera_removed = "カメラを監視システムから削除しました",
        already_viewing_camera = "既にカメラを表示中です！",
        camera_view_closed = "カメラ表示を閉じました",
        already_placing_camera = "既にスパイカメラを設置中です！",
        camera_placed = "ナノスパイカメラの設置に成功しました！",
        camera_placement_cancelled = "スパイカメラの設置をキャンセルしました",
        camera_too_far = "カメラが遠すぎます！設置をキャンセルしました。",
        camera_failed_create = "スパイカメラの作成に失敗しました！",
        camera_failed_save = "データベースへのカメラ保存に失敗しました！",
        use_placer = "スパイカメラの位置を決めてクリックで設置！",
        placer_help = "~INPUT_CELLPHONE_SELECT~ 設置 | ~INPUT_CELLPHONE_CANCEL~ キャンセル | スクロール: 回転 | Ctrl+スクロール: 距離 | Q/Z: 高さ | Alt: 地面固定",
        spy_camera_destroyed = "スパイカメラを破壊しました！",
        destroy_spy_camera = "スパイカメラを破壊",
        collected_cameras = "スパイカメラを %s 台回収しました",
        no_cameras_nearby = "回収できるスパイカメラが近くにありません",
        camera_corrupted = "カメラデータが破損しています！",
        camera_offline = "カメラはオフラインです！",
        camera_not_found = "カメラが見つかりません！",
        device_network = "デバイスネットワーク",
        cameras = "カメラ",
        microphones = "マイク",
        gps_trackers = "GPSトラッカー",
        search_placeholder = "デバイス、ID、プレイヤー名で検索...",
        filters = "フィルター",
        clear_all = "すべてクリア",
        status_filter = "ステータスフィルター",
        device_type = "デバイスタイプ",
        battery_level = "バッテリーレベル",
        all_status = "すべてのステータス",
        online = "オンライン",
        offline = "オフライン",
        warning = "警告",
        error = "エラー",
        all_types = "すべてのタイプ",
        all_levels = "すべてのレベル",
        low_battery = "低 (≤30%%)",
        medium_battery = "中 (31-70%%)",
        high_battery = "高 (>70%%)",
        spy_cam = "スパイカメラ",
        audio_monitor = "オーディオモニター",
        gps_tracker = "GPSトラッカー",
        access_camera = "カメラにアクセス",
        live_feed = "ライブフィード",
        connected = "接続済み",
        battery = "バッテリー",
        nano_spy_init = "ナノスパイシステムを初期化しました",
        close = "閉じる",
        power_off = "電源オフ",
        mic_placement_init = "監視マイクの設置を開始しました...",
        mic_no_target = "エラー：マイク設置のターゲットが指定されていません！",
        mic_exited = "デバイスを設置せずに終了しました",
        mission_failed_timer = "ミッション失敗！時間切れ - ターゲットに警告されました！",
        mission_failed_alerted = "ミッション失敗！ターゲットに警告されました！",
        mission_failed_timer_short = "ミッション失敗！時間切れ！",
        place_spy_mic = "スパイマイクを設置",
        remove_surv_mic = "監視マイクを削除",
        mic_removal_triggered = "マイク削除を実行しました",
        mic_no_longer_detected = "マイクが検出されなくなりました",
        mic_need_item = "監視マイクを設置するには %s が必要です！",
        mic_invalid_target = "無効なターゲットです！",
        mic_target_gone = "ターゲットが存在しなくなりました！",
        mic_unable_id = "ターゲットのプレイヤーを特定できません！",
        mic_no_found = "ターゲットにマイクが見つかりません！",
        mic_already_placing = "既にマイクを設置中です！",
        mic_target_far = "ターゲットが遠すぎます！",
        mic_placing = "マイク設置を開始しています...",
        mic_placed = "監視マイクの設置に成功しました！",
        mic_active = "監視オーディオ稼働中 - ターゲットを監視しています",
        mic_stopped = "監視オーディオを停止しました",
        mic_removed = "監視マイクを削除しました",
        mic_battery_critical = "マイク %s バッテリー危機：%s%%",
        mic_battery_low = "マイク %s バッテリー低下：%s%%",
        mic_battery_depleted = "マイク %s バッテリー切れ - 監視を停止しました",
        already_placing_gps = "既にGPSトラッカーを設置中です！",
        no_vehicle_nearby = "GPSトラッカーを設置する車両が近くにありません！",
        no_license_plate = "車両にナンバープレートがありません！",
        installing_gps = "GPSトラッカーを設置しています...",
        gps_marked_map = "GPSトラッカーの位置を地図に30秒間表示しました",
        gps_removal_triggered = "GPS削除を実行しました",
        gps_no_longer_detected = "GPSトラッカーが検出されなくなりました",
        gps_removal_cancelled = "GPS削除をキャンセルしました",
        gps_depleted_offline = "GPSトラッカーのバッテリー切れ - オフライン",
        digiscanner_activated = "デジスキャナーを起動しました",
        digiscanner_deactivated = "デジスキャナーを停止しました",
        digiscanner_deactivated_vehicle = "デジスキャナーを停止しました - 車両に乗車",
        digiscanner_battery_depleted = "デジスキャナーのバッテリー切れ！",
        digiscanner_battery_low = "デジスキャナーのバッテリー低下：%s%%",
        progress_bar_unavailable = "プログレスバーシステムが利用できません",
        removing_gps = "GPSトラッカーを削除中",
        damaged_vehicle = "検索中に車両を損傷させました！",
        scanner_malfunctioned = "デジスキャナーが故障しました！",
        scanner_malfunction_removal = "削除中にスキャナーが故障しました！",
        scanner_working_again = "スキャナーが復旧しました",
        mic_removal_cancelled = "マイク削除をキャンセルしました",
        remove_gps_tracker = "GPSトラッカーを削除",
        removing_surv_mic = "監視マイクを削除中...",
        tab_device_network = "デバイスネットワーク",
        tab_device_network_desc = "スパイ機器概要",
        tab_proximity_radar = "近接レーダー",
        tab_proximity_radar_desc = "距離ベースのデバイスマッピング",
        tab_device_control = "デバイス制御",
        tab_device_control_desc = "ライブ配信とデバイス管理",
        brand_nano = "ナノ",
        brand_spy_system = "スパイシステム",
        status_connected = "ステータス：接続済み",
        system_label = "システム",
        network_label = "ネットワーク",
        secure_label = "セキュア",
        power_label = "電源",
        alerts_label = "アラート",
        system_alerts = "システムアラート",
        all_systems_nominal = "全システム正常",
        no_active_alerts = "アクティブなアラートはありません",
        devices_online = "オンラインデバイス",
        warnings_count = "警告",
        errors_count = "エラー",
        active_tab = "アクティブタブ",
        selected_label = "選択中",
        nano_os_build = "NANO-OS v2.1.4 | ビルド 2024.03.15",
        control_tab = "制御",
        config_tab = "設定",
        edit_camera_name = "カメラ名を編集",
        save_name = "名前を保存",
        cancel = "キャンセル",
        select_device = "デバイスを選択...",
        loading_device_settings = "デバイス設定を読み込み中...",
        battery_upper = "バッテリー",
        critical_battery = "危機",
        pwr_core = "電源コア",
        status_online_dot = "オンライン",
        status_offline_dot = "オフライン",
        enable_gps = "GPS有効",
        shutdown_gps = "GPSシャットダウン",
        shutdown_sys = "システムシャットダウン",
        boot_system = "システム起動",
        core_state = "コア状態",
        operational = "稼働中",
        dormant = "休止",
        uptime = "稼働時間",
        critical_battery_full = "バッテリー危機",
        surveillance_label = "監視",
        active_dot = "アクティブ",
        one_way = "一方向",
        target_label = "ターゲット",
        unknown_target = "不明なターゲット",
        status_available = "利用可能",
        stop_surveillance = "監視停止",
        start_surveillance = "監視開始",
        proximity_monitoring = "近接監視",
        realtime_spy_stream = "リアルタイムスパイストリーム",
        streaming = "ストリーミング中",
        audio_stream = "オーディオストリーム",
        sample_rate = "サンプルレート：48kHz | 16bit",
        codec_info = "コーデック：AAC | ビットレート：320 kbps",
        noise_reduction = "ノイズリダクション：有効",
        gps_tracking = "GPS追跡",
        latitude = "緯度",
        longitude = "経度",
        altitude = "高度",
        locate_on_map = "地図で表示",
        accuracy_info = "精度：±1.2m | 衛星：12",
        update_rate_info = "更新率：3-5秒 | 車両追跡",
        vehicle_label = "車両",
        device_configuration = "デバイス設定",
        device_name = "デバイス名",
        device_id = "デバイスID",
        device_type_label = "デバイスタイプ",
        minimap_blip = "ミニマップマーカー",
        blip_visible = "ミニマップに表示",
        blip_hidden = "ミニマップで非表示",
        coordinates = "座標",
        player_id = "プレイヤーID",
        select_placeholder = "選択...",
        live_spy_monitoring = "ライブスパイ機器監視",
        id_label = "ID",
        player_label = "プレイヤー",
        model_label = "モデル",
        location_label = "位置",
        est_time_left = "推定残り時間",
        last_activity = "最終活動",
        just_now = "たった今",
        time_m_ago = "%s分前",
        time_h_ago = "%s時間前",
        time_d_ago = "%s日前",
        no_devices_found = "デバイスが見つかりません",
        no_devices_match = "現在のフィルターに一致するデバイスがありません",
        low_battery_warning = "バッテリー低下警告",
        tactical_map = "戦術",
        map_label = "マップ",
        devices_active = "アクティブデバイス",
        coverage_area = "カバー範囲",
        satellite_view = "衛星ビュー",
        live_tracking = "ライブ追跡",
        map_controls = "マップ操作",
        distance_rings = "距離リング",
        fivem_coordinates = "FIVEM座標",
        device_types = "デバイスタイプ",
        cameras_label = "カメラ",
        microphones_label = "マイク",
        gps_trackers_label = "GPSトラッカー",
        device_status = "デバイス状態",
        static_label = "静的",
        mobile_label = "移動",
        proximity_analysis = "近接分析",
        target_info = "ターゲット情報",
        auth_title = "ナノスパイシステム",
        auth_subtitle = "高度スパイネットワーク制御システム",
        biometric_auth = "生体認証",
        touch_to_authenticate = "センサーに指を置いて認証してください...",
        authenticating = "認証中...",
        auth_success = "認証成功。ネットワークに接続中...",
        secure = "セキュア",
        encrypted = "暗号化",
        active = "アクティブ",
        monitored = "監視中",
        live_audio = "ライブ",
        offline_audio = "オフライン",
        complete = "完了",
        biometric_match = "生体認証一致を確認しました",
        establishing_connection = "セキュア接続を確立しています...",
        scanning_biometric = "生体認証データをスキャン中...",
    },
    fr = {
        invalid_camera_data = "Données de caméra invalides",
        camera_controls_hint = "WASD = Tourner | Retour = Quitter",
        camera_controls_esc = "WASD : Tourner la caméra | ESC : Quitter",
        no_cameras = "Aucune caméra disponible",
        camera_saved = "Caméra enregistrée dans le système de surveillance",
        camera_removed = "Caméra retirée du système de surveillance",
        already_viewing_camera = "Vous regardez déjà une caméra !",
        camera_view_closed = "Vue caméra fermée",
        already_placing_camera = "Vous placez déjà une caméra espion !",
        camera_placed = "Caméra espion nano placée avec succès !",
        camera_placement_cancelled = "Placement de la caméra espion annulé",
        camera_too_far = "Caméra trop éloignée ! Placement annulé.",
        camera_failed_create = "Échec de la création de la caméra espion !",
        camera_failed_save = "Échec de l'enregistrement de la caméra en base !",
        use_placer = "Positionnez la caméra espion et cliquez pour placer !",
        placer_help = "~INPUT_CELLPHONE_SELECT~ Placer | ~INPUT_CELLPHONE_CANCEL~ Annuler | Molette: Rotation | Ctrl+Molette: Distance | Q/Z: Hauteur | Alt: Sol",
        spy_camera_destroyed = "Caméra espion détruite !",
        destroy_spy_camera = "Détruire la caméra espion",
        collected_cameras = "%s caméra(s) espion récupérée(s)",
        no_cameras_nearby = "Aucune caméra espion à récupérer à proximité",
        camera_corrupted = "Données de caméra corrompues !",
        camera_offline = "Caméra hors ligne !",
        camera_not_found = "Caméra introuvable !",
        device_network = "RÉSEAU D'APPAREILS",
        cameras = "CAMÉRAS",
        microphones = "MICROPHONES",
        gps_trackers = "GPS",
        search_placeholder = "Rechercher appareils, ID ou noms...",
        filters = "FILTRES",
        clear_all = "TOUT EFFACER",
        status_filter = "FILTRE STATUT",
        device_type = "TYPE D'APPAREIL",
        battery_level = "NIVEAU BATTERIE",
        all_status = "Tous les statuts",
        online = "En ligne",
        offline = "Hors ligne",
        warning = "Avertissement",
        error = "Erreur",
        all_types = "Tous les types",
        all_levels = "Tous les niveaux",
        low_battery = "Faible (≤30%%)",
        medium_battery = "Moyen (31-70%%)",
        high_battery = "Élevé (>70%%)",
        spy_cam = "CAMÉRA ESPION",
        audio_monitor = "AUDIO",
        gps_tracker = "GPS",
        access_camera = "ACCÉDER À LA CAMÉRA",
        live_feed = "DIRECT",
        connected = "CONNECTÉ",
        battery = "Batterie",
        nano_spy_init = "Système nano espion initialisé",
        close = "Fermer",
        power_off = "ARRÊTER",
        mic_placement_init = "Placement du micro de surveillance en cours...",
        mic_no_target = "Erreur : Aucune cible pour le micro !",
        mic_exited = "Sorti sans placer d'appareil",
        mission_failed_timer = "Échec ! Temps écoulé - cible alertée !",
        mission_failed_alerted = "Échec ! La cible a été alertée !",
        mission_failed_timer_short = "Échec ! Temps écoulé !",
        place_spy_mic = "Placer micro espion",
        remove_surv_mic = "Retirer le micro de surveillance",
        mic_removal_triggered = "Retrait du micro déclenché",
        mic_no_longer_detected = "Micro non détecté",
        mic_need_item = "Il vous faut %s pour placer un micro de surveillance !",
        mic_invalid_target = "Cible invalide !",
        mic_target_gone = "La cible n'existe plus !",
        mic_unable_id = "Impossible d'identifier le joueur cible !",
        mic_no_found = "Aucun micro sur la cible !",
        mic_already_placing = "Vous placez déjà un micro !",
        mic_target_far = "Cible trop éloignée !",
        mic_placing = "Placement du micro en cours...",
        mic_placed = "Micro de surveillance placé avec succès !",
        mic_active = "Audio de surveillance actif - écoute de la cible",
        mic_stopped = "Audio de surveillance arrêté",
        mic_removed = "Micro de surveillance retiré",
        mic_battery_critical = "Micro %s batterie critique : %s%%",
        mic_battery_low = "Micro %s batterie faible : %s%%",
        mic_battery_depleted = "Micro %s batterie épuisée - surveillance arrêtée",
        already_placing_gps = "Vous placez déjà un traceur GPS !",
        no_vehicle_nearby = "Aucun véhicule à proximité pour le GPS !",
        no_license_plate = "Le véhicule n'a pas de plaque !",
        installing_gps = "Installation du traceur GPS...",
        gps_marked_map = "Position GPS marquée sur la carte pendant 30 s",
        gps_removal_triggered = "Retrait GPS déclenché",
        gps_no_longer_detected = "Traceur GPS non détecté",
        gps_removal_cancelled = "Retrait GPS annulé",
        gps_depleted_offline = "Batterie GPS épuisée - appareil hors ligne",
        digiscanner_activated = "Digiscanner activé",
        digiscanner_deactivated = "Digiscanner désactivé",
        digiscanner_deactivated_vehicle = "Digiscanner désactivé - véhicule",
        digiscanner_battery_depleted = "Batterie digiscanner épuisée !",
        digiscanner_battery_low = "Batterie digiscanner faible : %s%%",
        progress_bar_unavailable = "Barre de progression indisponible",
        removing_gps = "Retrait du traceur GPS",
        damaged_vehicle = "Vous avez endommagé le véhicule en cherchant !",
        scanner_malfunctioned = "Votre digiscanner a dysfonctionné !",
        scanner_malfunction_removal = "Le scanner a dysfonctionné pendant le retrait !",
        scanner_working_again = "Le scanner refonctionne",
        mic_removal_cancelled = "Retrait du micro annulé",
        remove_gps_tracker = "Retirer le traceur GPS",
        removing_surv_mic = "Retrait du micro de surveillance...",
        tab_device_network = "RÉSEAU D'APPAREILS",
        tab_device_network_desc = "Aperçu des équipements espion",
        tab_proximity_radar = "RADAR DE PROXIMITÉ",
        tab_proximity_radar_desc = "Cartographie par distance",
        tab_device_control = "CONTRÔLE D'APPAREILS",
        tab_device_control_desc = "Flux en direct et gestion",
        brand_nano = "NANO",
        brand_spy_system = "SYSTÈME ESPION",
        status_connected = "STATUT : CONNECTÉ",
        system_label = "SYSTÈME",
        network_label = "RÉSEAU",
        secure_label = "SÉCURISÉ",
        power_label = "ALIMENTATION",
        alerts_label = "ALERTES",
        system_alerts = "ALERTES SYSTÈME",
        all_systems_nominal = "TOUS SYSTÈMES NOMINAUX",
        no_active_alerts = "Aucune alerte active",
        devices_online = "APPAREILS EN LIGNE",
        warnings_count = "AVERTISSEMENTS",
        errors_count = "ERREURS",
        active_tab = "ONGLET ACTIF",
        selected_label = "SÉLECTIONNÉ",
        nano_os_build = "NANO-OS v2.1.4 | BUILD 2024.03.15",
        control_tab = "CONTRÔLE",
        config_tab = "CONFIG",
        edit_camera_name = "Modifier le nom de la caméra",
        save_name = "Enregistrer le nom",
        cancel = "Annuler",
        select_device = "Sélectionner un appareil...",
        loading_device_settings = "Chargement des paramètres...",
        battery_upper = "BATTERIE",
        critical_battery = "CRITIQUE",
        pwr_core = "ALIM_CORE",
        status_online_dot = "EN LIGNE",
        status_offline_dot = "HORS LIGNE",
        enable_gps = "ACTIVER GPS",
        shutdown_gps = "COUPER GPS",
        shutdown_sys = "ARRÊTER SYSTÈME",
        boot_system = "DÉMARRER SYSTÈME",
        core_state = "ÉTAT_CORE",
        operational = "OPÉRATIONNEL",
        dormant = "VEILLE",
        uptime = "UPTIME",
        critical_battery_full = "BATTERIE CRITIQUE",
        surveillance_label = "SURVEILLANCE",
        active_dot = "ACTIF",
        one_way = "UNIDIRECTIONNEL",
        target_label = "CIBLE",
        unknown_target = "Cible inconnue",
        status_available = "Disponible",
        stop_surveillance = "ARRÊTER SURVEILLANCE",
        start_surveillance = "DÉMARRER SURVEILLANCE",
        proximity_monitoring = "SURVEILLANCE DE PROXIMITÉ",
        realtime_spy_stream = "Flux espion en temps réel",
        streaming = "EN DIRECT",
        audio_stream = "FLUX AUDIO",
        sample_rate = "Échantillon : 48 kHz | 16 bits",
        codec_info = "Codec : AAC | Débit : 320 kbps",
        noise_reduction = "Réduction du bruit : active",
        gps_tracking = "SUIVI GPS",
        latitude = "LATITUDE",
        longitude = "LONGITUDE",
        altitude = "ALTITUDE",
        locate_on_map = "LOCALISER SUR LA CARTE",
        accuracy_info = "Précision : ±1,2 m | Satellites : 12",
        update_rate_info = "Mise à jour : 3-5 s | Suivi véhicule",
        vehicle_label = "Véhicule",
        device_configuration = "CONFIGURATION APPAREIL",
        device_name = "NOM APPAREIL",
        device_id = "ID APPAREIL",
        device_type_label = "TYPE D'APPAREIL",
        minimap_blip = "MARQUEUR MINICARTE",
        blip_visible = "Marqueur visible sur la minicarte",
        blip_hidden = "Marqueur masqué sur la minicarte",
        coordinates = "COORDONNÉES",
        player_id = "ID JOUEUR",
        select_placeholder = "Choisir...",
        live_spy_monitoring = "Surveillance des équipements espion en direct",
        id_label = "ID",
        player_label = "Joueur",
        model_label = "Modèle",
        location_label = "Position",
        est_time_left = "TEMPS RESTANT EST.",
        last_activity = "Dernière activité",
        just_now = "à l'instant",
        time_m_ago = "il y a %s min",
        time_h_ago = "il y a %s h",
        time_d_ago = "il y a %s j",
        no_devices_found = "AUCUN APPAREIL",
        no_devices_match = "Aucun appareil ne correspond aux filtres",
        low_battery_warning = "BATTERIE FAIBLE",
        tactical_map = "CARTE",
        map_label = "TACTIQUE",
        devices_active = "APPAREILS ACTIFS",
        coverage_area = "ZONE COUVERTE",
        satellite_view = "VUE SATELLITE",
        live_tracking = "SUIVI EN DIRECT",
        map_controls = "CONTRÔLES CARTE",
        distance_rings = "CERCLES DE DISTANCE",
        fivem_coordinates = "COORDONNÉES FIVEM",
        device_types = "TYPES D'APPAREILS",
        cameras_label = "CAMÉRAS",
        microphones_label = "MICROPHONES",
        gps_trackers_label = "GPS",
        device_status = "STATUT APPAREIL",
        static_label = "STATIQUE",
        mobile_label = "MOBILE",
        proximity_analysis = "ANALYSE DE PROXIMITÉ",
        target_info = "INFO CIBLE",
        auth_title = "SYSTÈME ESPION NANO",
        auth_subtitle = "Système de contrôle réseau espion avancé",
        biometric_auth = "AUTHENTIFICATION BIOMÉTRIQUE",
        touch_to_authenticate = "Placez votre doigt sur le capteur...",
        authenticating = "Authentification...",
        auth_success = "Authentification réussie. Connexion au réseau...",
        secure = "SÉCURISÉ",
        encrypted = "CHIFFRÉ",
        active = "ACTIF",
        monitored = "SURVEILLÉ",
        live_audio = "LIVE",
        offline_audio = "HORS LIGNE",
        complete = "TERMINÉ",
        biometric_match = "Correspondance biométrique confirmée",
        establishing_connection = "Établissement de la connexion sécurisée...",
        scanning_biometric = "Numérisation des données biométriques...",
    },
    pt = {
        invalid_camera_data = "Dados de câmera inválidos",
        camera_controls_hint = "WASD = Girar | Backspace = Sair",
        camera_controls_esc = "WASD: Girar câmera | ESC: Sair",
        no_cameras = "Nenhuma câmera disponível",
        camera_saved = "Câmera salva no sistema de vigilância",
        camera_removed = "Câmera removida do sistema de vigilância",
        already_viewing_camera = "Você já está visualizando uma câmera!",
        camera_view_closed = "Visualização da câmera fechada",
        already_placing_camera = "Você já está colocando uma câmera espiã!",
        camera_placed = "Câmera espiã nano colocada com sucesso!",
        camera_placement_cancelled = "Colocação da câmera espiã cancelada",
        camera_too_far = "Câmera muito longe! Colocação cancelada.",
        camera_failed_create = "Falha ao criar câmera espiã!",
        camera_failed_save = "Falha ao salvar câmera no banco de dados!",
        use_placer = "Posicione a câmera espiã e clique para colocar!",
        placer_help = "~INPUT_CELLPHONE_SELECT~ Colocar | ~INPUT_CELLPHONE_CANCEL~ Cancelar | Scroll: Rotação | Ctrl+Scroll: Distância | Q/Z: Altura | Alt: Chão",
        spy_camera_destroyed = "Câmera espiã destruída!",
        destroy_spy_camera = "Destruir câmera espiã",
        collected_cameras = "%s câmera(s) espiã(ns) recolhida(s)",
        no_cameras_nearby = "Nenhuma câmera espiã por perto para recolher",
        camera_corrupted = "Dados da câmera corrompidos!",
        camera_offline = "Câmera offline!",
        camera_not_found = "Câmera não encontrada!",
        device_network = "REDE DE DISPOSITIVOS",
        cameras = "CÂMERAS",
        microphones = "MICROFONES",
        gps_trackers = "RASTREADORES GPS",
        search_placeholder = "Pesquisar dispositivos, IDs ou nomes...",
        filters = "FILTROS",
        clear_all = "LIMPAR TUDO",
        status_filter = "FILTRO DE STATUS",
        device_type = "TIPO DE DISPOSITIVO",
        battery_level = "NÍVEL DA BATERIA",
        all_status = "Todos os status",
        online = "Online",
        offline = "Offline",
        warning = "Aviso",
        error = "Erro",
        all_types = "Todos os tipos",
        all_levels = "Todos os níveis",
        low_battery = "Baixo (≤30%%)",
        medium_battery = "Médio (31-70%%)",
        high_battery = "Alto (>70%%)",
        spy_cam = "CÂMERA ESPIÃ",
        audio_monitor = "MONITOR DE ÁUDIO",
        gps_tracker = "RASTREADOR GPS",
        access_camera = "ACESSAR CÂMERA",
        live_feed = "AO VIVO",
        connected = "CONECTADO",
        battery = "Bateria",
        nano_spy_init = "Sistema nano espião inicializado",
        close = "Fechar",
        power_off = "DESLIGAR",
        mic_placement_init = "Colocação do microfone de vigilância iniciada...",
        mic_no_target = "Erro: Nenhum alvo especificado para o microfone!",
        mic_exited = "Saiu sem colocar dispositivo",
        mission_failed_timer = "Missão falhou! Tempo esgotado - alvo alertado!",
        mission_failed_alerted = "Missão falhou! Alvo foi alertado!",
        mission_failed_timer_short = "Missão falhou! Tempo esgotado!",
        place_spy_mic = "Colocar microfone espião",
        remove_surv_mic = "Remover microfone de vigilância",
        mic_removal_triggered = "Remoção do microfone acionada",
        mic_no_longer_detected = "Microfone não mais detectado",
        mic_need_item = "Você precisa de %s para colocar um microfone de vigilância!",
        mic_invalid_target = "Alvo inválido!",
        mic_target_gone = "Alvo não existe mais!",
        mic_unable_id = "Não foi possível identificar o jogador alvo!",
        mic_no_found = "Nenhum microfone encontrado no alvo!",
        mic_already_placing = "Você já está colocando um microfone!",
        mic_target_far = "Alvo muito longe!",
        mic_placing = "Iniciando colocação do microfone...",
        mic_placed = "Microfone de vigilância colocado com sucesso!",
        mic_active = "Áudio de vigilância ativo - monitorando alvo",
        mic_stopped = "Áudio de vigilância parado",
        mic_removed = "Microfone de vigilância removido",
        mic_battery_critical = "Microfone %s bateria crítica: %s%%",
        mic_battery_low = "Microfone %s bateria baixa: %s%%",
        mic_battery_depleted = "Microfone %s bateria esgotada - vigilância parada",
        already_placing_gps = "Você já está colocando um rastreador GPS!",
        no_vehicle_nearby = "Nenhum veículo por perto para colocar rastreador GPS!",
        no_license_plate = "O veículo não tem placa!",
        installing_gps = "Instalando rastreador GPS...",
        gps_marked_map = "Local do rastreador GPS marcado no mapa por 30 segundos",
        gps_removal_triggered = "Remoção do GPS acionada",
        gps_no_longer_detected = "Rastreador GPS não mais detectado",
        gps_removal_cancelled = "Remoção do GPS cancelada",
        gps_depleted_offline = "Bateria do rastreador GPS esgotada - dispositivo offline",
        digiscanner_activated = "Digiscanner ativado",
        digiscanner_deactivated = "Digiscanner desativado",
        digiscanner_deactivated_vehicle = "Digiscanner desativado - entrou no veículo",
        digiscanner_battery_depleted = "Bateria do digiscanner esgotada!",
        digiscanner_battery_low = "Bateria do digiscanner baixa: %s%%",
        progress_bar_unavailable = "Sistema de barra de progresso indisponível",
        removing_gps = "Removendo rastreador GPS",
        damaged_vehicle = "Você danificou o veículo ao procurar!",
        scanner_malfunctioned = "Seu digiscanner apresentou defeito!",
        scanner_malfunction_removal = "O scanner apresentou defeito durante a remoção!",
        scanner_working_again = "Scanner funcionando novamente",
        mic_removal_cancelled = "Remoção do microfone cancelada",
        remove_gps_tracker = "Remover rastreador GPS",
        removing_surv_mic = "Removendo microfone de vigilância...",
        tab_device_network = "REDE DE DISPOSITIVOS",
        tab_device_network_desc = "Visão geral dos equipamentos espiões",
        tab_proximity_radar = "RADAR DE PROXIMIDADE",
        tab_proximity_radar_desc = "Mapeamento por distância",
        tab_device_control = "CONTROLE DE DISPOSITIVOS",
        tab_device_control_desc = "Transmissão ao vivo e gestão",
        brand_nano = "NANO",
        brand_spy_system = "SISTEMA ESPIÃO",
        status_connected = "STATUS: CONECTADO",
        system_label = "SISTEMA",
        network_label = "REDE",
        secure_label = "SEGURO",
        power_label = "ENERGIA",
        alerts_label = "ALERTAS",
        system_alerts = "ALERTAS DO SISTEMA",
        all_systems_nominal = "TODOS OS SISTEMAS NORMAIS",
        no_active_alerts = "Nenhum alerta ativo",
        devices_online = "DISPOSITIVOS ONLINE",
        warnings_count = "AVISOS",
        errors_count = "ERROS",
        active_tab = "ABA ATIVA",
        selected_label = "SELECIONADO",
        nano_os_build = "NANO-OS v2.1.4 | BUILD 2024.03.15",
        control_tab = "CONTROLE",
        config_tab = "CONFIG",
        edit_camera_name = "Editar nome da câmera",
        save_name = "Salvar nome",
        cancel = "Cancelar",
        select_device = "Selecione um dispositivo...",
        loading_device_settings = "Carregando configurações...",
        battery_upper = "BATERIA",
        critical_battery = "CRÍTICO",
        pwr_core = "NÚCLEO_PWR",
        status_online_dot = "ONLINE",
        status_offline_dot = "OFFLINE",
        enable_gps = "ATIVAR GPS",
        shutdown_gps = "DESLIGAR GPS",
        shutdown_sys = "DESLIGAR SISTEMA",
        boot_system = "INICIAR SISTEMA",
        core_state = "ESTADO_NÚCLEO",
        operational = "OPERACIONAL",
        dormant = "INATIVO",
        uptime = "UPTIME",
        critical_battery_full = "BATERIA CRÍTICA",
        surveillance_label = "VIGILÂNCIA",
        active_dot = "ATIVO",
        one_way = "UNIDIRECIONAL",
        target_label = "ALVO",
        unknown_target = "Alvo desconhecido",
        status_available = "Disponível",
        stop_surveillance = "PARAR VIGILÂNCIA",
        start_surveillance = "INICIAR VIGILÂNCIA",
        proximity_monitoring = "MONITORAMENTO DE PROXIMIDADE",
        realtime_spy_stream = "Transmissão espiã em tempo real",
        streaming = "TRANSMITINDO",
        audio_stream = "TRANSMISSÃO DE ÁUDIO",
        sample_rate = "Taxa: 48 kHz | 16 bits",
        codec_info = "Codec: AAC | Taxa: 320 kbps",
        noise_reduction = "Redução de ruído: ativa",
        gps_tracking = "RASTREAMENTO GPS",
        latitude = "LATITUDE",
        longitude = "LONGITUDE",
        altitude = "ALTITUDE",
        locate_on_map = "LOCALIZAR NO MAPA",
        accuracy_info = "Precisão: ±1,2 m | Satélites: 12",
        update_rate_info = "Atualização: 3-5 s | Rastreamento de veículo",
        vehicle_label = "Veículo",
        device_configuration = "CONFIGURAÇÃO DO DISPOSITIVO",
        device_name = "NOME DO DISPOSITIVO",
        device_id = "ID DO DISPOSITIVO",
        device_type_label = "TIPO DE DISPOSITIVO",
        minimap_blip = "MARCADOR NO MINIMAPA",
        blip_visible = "Marcador visível no minimapa",
        blip_hidden = "Marcador oculto no minimapa",
        coordinates = "COORDENADAS",
        player_id = "ID DO JOGADOR",
        select_placeholder = "Selecionar...",
        live_spy_monitoring = "Monitoramento ao vivo de equipamentos espiões",
        id_label = "ID",
        player_label = "Jogador",
        model_label = "Modelo",
        location_label = "Localização",
        est_time_left = "TEMPO RESTANTE EST.",
        last_activity = "Última atividade",
        just_now = "agora mesmo",
        time_m_ago = "há %s min",
        time_h_ago = "há %s h",
        time_d_ago = "há %s dias",
        no_devices_found = "NENHUM DISPOSITIVO",
        no_devices_match = "Nenhum dispositivo corresponde aos filtros",
        low_battery_warning = "BATERIA BAIXA",
        tactical_map = "MAPA TÁTICO",
        map_label = "MAPA",
        devices_active = "DISPOSITIVOS ATIVOS",
        coverage_area = "ÁREA DE COBERTURA",
        satellite_view = "VISTA SATÉLITE",
        live_tracking = "RASTREAMENTO AO VIVO",
        map_controls = "CONTROLES DO MAPA",
        distance_rings = "ANÉIS DE DISTÂNCIA",
        fivem_coordinates = "COORDENADAS FIVEM",
        device_types = "TIPOS DE DISPOSITIVOS",
        cameras_label = "CÂMERAS",
        microphones_label = "MICROFONES",
        gps_trackers_label = "RASTREADORES GPS",
        device_status = "STATUS DO DISPOSITIVO",
        static_label = "ESTÁTICO",
        mobile_label = "MÓVEL",
        proximity_analysis = "ANÁLISE DE PROXIMIDADE",
        target_info = "INFO DO ALVO",
        auth_title = "SISTEMA NANO ESPIÃO",
        auth_subtitle = "Sistema avançado de controle de rede espiã",
        biometric_auth = "AUTENTICAÇÃO BIOMÉTRICA",
        touch_to_authenticate = "Coloque o dedo no sensor para autenticar...",
        authenticating = "Autenticando...",
        auth_success = "Autenticação bem-sucedida. Conectando à rede...",
        secure = "SEGURO",
        encrypted = "CRIPTOGRAFADO",
        active = "ATIVO",
        monitored = "MONITORADO",
        live_audio = "AO VIVO",
        offline_audio = "OFFLINE",
        complete = "COMPLETO",
        biometric_match = "Correspondência biométrica confirmada",
        establishing_connection = "Estabelecendo conexão segura...",
        scanning_biometric = "Digitalizando dados biométricos...",
    },
    es = {
        invalid_camera_data = "Datos de cámara no válidos",
        camera_controls_hint = "WASD = Girar | Retroceso = Salir",
        camera_controls_esc = "WASD: Girar cámara | ESC: Salir",
        no_cameras = "No hay cámaras disponibles",
        camera_saved = "Cámara guardada en el sistema de vigilancia",
        camera_removed = "Cámara eliminada del sistema de vigilancia",
        already_viewing_camera = "¡Ya estás viendo una cámara!",
        camera_view_closed = "Vista de cámara cerrada",
        already_placing_camera = "¡Ya estás colocando una cámara espía!",
        camera_placed = "¡Cámara espía nano colocada con éxito!",
        camera_placement_cancelled = "Colocación de cámara espía cancelada",
        camera_too_far = "¡La cámara está muy lejos! Colocación cancelada.",
        camera_failed_create = "¡Error al crear la cámara espía!",
        camera_failed_save = "¡Error al guardar la cámara en la base de datos!",
        use_placer = "¡Posiciona la cámara espía y haz clic para colocar!",
        placer_help = "~INPUT_CELLPHONE_SELECT~ Colocar | ~INPUT_CELLPHONE_CANCEL~ Cancelar | Scroll: Rotar | Ctrl+Scroll: Distancia | Q/Z: Altura | Alt: Suelo",
        spy_camera_destroyed = "¡Cámara espía destruida!",
        destroy_spy_camera = "Destruir cámara espía",
        collected_cameras = "%s cámara(s) espía(s) recuperada(s)",
        no_cameras_nearby = "No hay cámaras espía cerca para recuperar",
        camera_corrupted = "¡Datos de cámara corruptos!",
        camera_offline = "¡Cámara desconectada!",
        camera_not_found = "¡Cámara no encontrada!",
        device_network = "RED DE DISPOSITIVOS",
        cameras = "CÁMARAS",
        microphones = "MICRÓFONOS",
        gps_trackers = "RASTREADORES GPS",
        search_placeholder = "Buscar dispositivos, ID o nombres de jugadores...",
        filters = "FILTROS",
        clear_all = "BORRAR TODO",
        status_filter = "FILTRO DE ESTADO",
        device_type = "TIPO DE DISPOSITIVO",
        battery_level = "NIVEL DE BATERÍA",
        all_status = "Todos los estados",
        online = "En línea",
        offline = "Desconectado",
        warning = "Advertencia",
        error = "Error",
        all_types = "Todos los tipos",
        all_levels = "Todos los niveles",
        low_battery = "Bajo (≤30%%)",
        medium_battery = "Medio (31-70%%)",
        high_battery = "Alto (>70%%)",
        spy_cam = "CÁMARA ESPÍA",
        audio_monitor = "MONITOR DE AUDIO",
        gps_tracker = "RASTREADOR GPS",
        access_camera = "ACCEDER A CÁMARA",
        live_feed = "EN VIVO",
        connected = "CONECTADO",
        battery = "Batería",
        nano_spy_init = "Sistema nano espía inicializado",
        close = "Cerrar",
        power_off = "APAGAR",
        mic_placement_init = "Colocación de micrófono de vigilancia iniciada...",
        mic_no_target = "¡Error: No se especificó objetivo para el micrófono!",
        mic_exited = "Saliste sin colocar el dispositivo",
        mission_failed_timer = "¡Misión fallida! Se acabó el tiempo - ¡el objetivo fue alertado!",
        mission_failed_alerted = "¡Misión fallida! ¡El objetivo fue alertado!",
        mission_failed_timer_short = "¡Misión fallida! ¡Se acabó el tiempo!",
        place_spy_mic = "Colocar micrófono espía",
        remove_surv_mic = "Quitar micrófono de vigilancia",
        mic_removal_triggered = "Acción de quitar micrófono activada",
        mic_no_longer_detected = "Micrófono ya no detectado",
        mic_need_item = "¡Necesitas %s para colocar un micrófono de vigilancia!",
        mic_invalid_target = "¡Objetivo no válido!",
        mic_target_gone = "¡El objetivo ya no existe!",
        mic_unable_id = "¡No se pudo identificar al jugador objetivo!",
        mic_no_found = "¡No se encontró micrófono en el objetivo!",
        mic_already_placing = "¡Ya estás colocando un micrófono!",
        mic_target_far = "¡El objetivo está muy lejos!",
        mic_placing = "Iniciando colocación del micrófono...",
        mic_placed = "¡Micrófono de vigilancia colocado con éxito!",
        mic_active = "Audio de vigilancia activo - monitoreando objetivo",
        mic_stopped = "Audio de vigilancia detenido",
        mic_removed = "Micrófono de vigilancia quitado",
        mic_battery_critical = "Micrófono %s batería crítica: %s%%",
        mic_battery_low = "Micrófono %s batería baja: %s%%",
        mic_battery_depleted = "Micrófono %s batería agotada - vigilancia detenida",
        already_placing_gps = "¡Ya estás colocando un rastreador GPS!",
        no_vehicle_nearby = "¡No hay vehículos cerca para colocar el rastreador GPS!",
        no_license_plate = "¡El vehículo no tiene matrícula!",
        installing_gps = "Instalando rastreador GPS...",
        gps_marked_map = "Ubicación del rastreador GPS marcada en el mapa por 30 segundos",
        gps_removal_triggered = "Quitar GPS activado",
        gps_no_longer_detected = "Rastreador GPS ya no detectado",
        gps_removal_cancelled = "Quitar GPS cancelado",
        gps_depleted_offline = "Batería del rastreador GPS agotada - dispositivo desconectado",
        digiscanner_activated = "Digiscanner activado",
        digiscanner_deactivated = "Digiscanner desactivado",
        digiscanner_deactivated_vehicle = "Digiscanner desactivado - entraste en vehículo",
        digiscanner_battery_depleted = "¡Batería del digiscanner agotada!",
        digiscanner_battery_low = "Batería del digiscanner baja: %s%%",
        progress_bar_unavailable = "Sistema de barra de progreso no disponible",
        removing_gps = "Quitando rastreador GPS",
        damaged_vehicle = "¡Dañaste el vehículo mientras buscabas!",
        scanner_malfunctioned = "¡Tu digiscanner falló!",
        scanner_malfunction_removal = "¡El escáner falló durante el intento de quitar!",
        scanner_working_again = "El escáner vuelve a funcionar",
        mic_removal_cancelled = "Quitar micrófono cancelado",
        remove_gps_tracker = "Quitar rastreador GPS",
        removing_surv_mic = "Quitando micrófono de vigilancia...",
        tab_device_network = "RED DE DISPOSITIVOS",
        tab_device_network_desc = "Resumen de equipos espía",
        tab_proximity_radar = "RADAR DE PROXIMIDAD",
        tab_proximity_radar_desc = "Mapa por distancia",
        tab_device_control = "CONTROL DE DISPOSITIVOS",
        tab_device_control_desc = "Transmisión en vivo y gestión",
        brand_nano = "NANO",
        brand_spy_system = "SISTEMA ESPÍA",
        status_connected = "ESTADO: CONECTADO",
        system_label = "SISTEMA",
        network_label = "RED",
        secure_label = "SEGURO",
        power_label = "ENERGÍA",
        alerts_label = "ALERTAS",
        system_alerts = "ALERTAS DEL SISTEMA",
        all_systems_nominal = "TODOS LOS SISTEMAS NOMINALES",
        no_active_alerts = "No hay alertas activas",
        devices_online = "DISPOSITIVOS EN LÍNEA",
        warnings_count = "ADVERTENCIAS",
        errors_count = "ERRORES",
        active_tab = "PESTAÑA ACTIVA",
        selected_label = "SELECCIONADO",
        nano_os_build = "NANO-OS v2.1.4 | BUILD 2024.03.15",
        control_tab = "CONTROL",
        config_tab = "CONFIG",
        edit_camera_name = "Editar nombre de cámara",
        save_name = "Guardar nombre",
        cancel = "Cancelar",
        select_device = "Selecciona un dispositivo...",
        loading_device_settings = "Cargando configuración...",
        battery_upper = "BATERÍA",
        critical_battery = "CRÍTICO",
        pwr_core = "NÚCLEO_PWR",
        status_online_dot = "EN LÍNEA",
        status_offline_dot = "DESCONECTADO",
        enable_gps = "ACTIVAR GPS",
        shutdown_gps = "APAGAR GPS",
        shutdown_sys = "APAGAR SISTEMA",
        boot_system = "INICIAR SISTEMA",
        core_state = "ESTADO_NÚCLEO",
        operational = "OPERATIVO",
        dormant = "INACTIVO",
        uptime = "UPTIME",
        critical_battery_full = "BATERÍA CRÍTICA",
        surveillance_label = "VIGILANCIA",
        active_dot = "ACTIVO",
        one_way = "UNIDIRECCIONAL",
        target_label = "OBJETIVO",
        unknown_target = "Objetivo desconocido",
        status_available = "Disponible",
        stop_surveillance = "DETENER VIGILANCIA",
        start_surveillance = "INICIAR VIGILANCIA",
        proximity_monitoring = "VIGILANCIA DE PROXIMIDAD",
        realtime_spy_stream = "Transmisión espía en tiempo real",
        streaming = "TRANSMITIENDO",
        audio_stream = "TRANSMISIÓN DE AUDIO",
        sample_rate = "Frecuencia: 48 kHz | 16 bits",
        codec_info = "Códec: AAC | Tasa: 320 kbps",
        noise_reduction = "Reducción de ruido: activa",
        gps_tracking = "RASTREO GPS",
        latitude = "LATITUD",
        longitude = "LONGITUD",
        altitude = "ALTITUD",
        locate_on_map = "UBICAR EN MAPA",
        accuracy_info = "Precisión: ±1,2 m | Satélites: 12",
        update_rate_info = "Actualización: 3-5 s | Rastreo de vehículo",
        vehicle_label = "Vehículo",
        device_configuration = "CONFIGURACIÓN DEL DISPOSITIVO",
        device_name = "NOMBRE DEL DISPOSITIVO",
        device_id = "ID DEL DISPOSITIVO",
        device_type_label = "TIPO DE DISPOSITIVO",
        minimap_blip = "MARCADOR EN MINIMAPA",
        blip_visible = "Marcador visible en minimapa",
        blip_hidden = "Marcador oculto en minimapa",
        coordinates = "COORDENADAS",
        player_id = "ID DE JUGADOR",
        select_placeholder = "Seleccionar...",
        live_spy_monitoring = "Monitorización en vivo de equipos espía",
        id_label = "ID",
        player_label = "Jugador",
        model_label = "Modelo",
        location_label = "Ubicación",
        est_time_left = "TIEMPO REST. EST.",
        last_activity = "Última actividad",
        just_now = "ahora mismo",
        time_m_ago = "hace %s min",
        time_h_ago = "hace %s h",
        time_d_ago = "hace %s días",
        no_devices_found = "NINGÚN DISPOSITIVO",
        no_devices_match = "Ningún dispositivo coincide con los filtros",
        low_battery_warning = "BATERÍA BAJA",
        tactical_map = "MAPA TÁCTICO",
        map_label = "MAPA",
        devices_active = "DISPOSITIVOS ACTIVOS",
        coverage_area = "ÁREA CUBIERTA",
        satellite_view = "VISTA SATÉLITE",
        live_tracking = "RASTREO EN VIVO",
        map_controls = "CONTROLES DEL MAPA",
        distance_rings = "ANILLOS DE DISTANCIA",
        fivem_coordinates = "COORDENADAS FIVEM",
        device_types = "TIPOS DE DISPOSITIVOS",
        cameras_label = "CÁMARAS",
        microphones_label = "MICRÓFONOS",
        gps_trackers_label = "RASTREADORES GPS",
        device_status = "ESTADO DEL DISPOSITIVO",
        static_label = "ESTÁTICO",
        mobile_label = "MÓVIL",
        proximity_analysis = "ANÁLISIS DE PROXIMIDAD",
        target_info = "INFO DEL OBJETIVO",
        auth_title = "SISTEMA NANO ESPÍA",
        auth_subtitle = "Sistema avanzado de control de red espía",
        biometric_auth = "AUTENTICACIÓN BIOMÉTRICA",
        touch_to_authenticate = "Coloca el dedo en el sensor para autenticar...",
        authenticating = "Autenticando...",
        auth_success = "Autenticación correcta. Conectando a la red...",
        secure = "SEGURO",
        encrypted = "CIFRADO",
        active = "ACTIVO",
        monitored = "VIGILADO",
        live_audio = "EN VIVO",
        offline_audio = "DESCONECTADO",
        complete = "COMPLETO",
        biometric_match = "Coincidencia biométrica confirmada",
        establishing_connection = "Estableciendo conexión segura...",
        scanning_biometric = "Escaneando datos biométricos...",
    },
}

function Config.L(key, ...)
    local loc = Config.Locale or "en"
    local t = Config.Translations and Config.Translations[loc]
    local s = (t and t[key]) or key
    if select("#", ...) > 0 then
        return string.format(s, ...)
    end
    return s
end
