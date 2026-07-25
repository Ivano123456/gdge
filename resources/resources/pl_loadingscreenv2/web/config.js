/**
 * ============================================================
 *  Loading Screen — Configuration
 *  Edit everything here. No changes needed in other files.
 * ============================================================
 */

const CONFIG = {

  /* ----------------------------------------------------------
   *  SERVER IDENTITY
   * ---------------------------------------------------------- */
  server: {
    name:     'Jamaica Roleplay',
    tagline:  'Tvoja nova RP prica zapocinje ovde',
    subtitle: 'Najkvalitetnije RP iskustvo na Balkanu',
    logo:     'assets/logo.png',      // Set to '' to hide
  },

  /* ----------------------------------------------------------
   *  BACKGROUND VIDEO
   * ---------------------------------------------------------- */
  background: {
    video:          'assets/background.mp4',   // MP4 or WebM path
    fallbackColor:  '#080c14',                 // Shown if video fails
    overlayOpacity: 0.68,                      // 0 = transparent, 1 = black
  },

  /* ----------------------------------------------------------
   *  THEME COLORS
   *  All UI elements derive from these values automatically.
   * ---------------------------------------------------------- */
  theme: {
    primary:        '#22c55e',          // Green accent — buttons, bar, glows
    accent:         '#4ade80',          // Lighter green — gradients, highlights
    background:     '#080c14',          // Deep dark fallback
    textHighlight:  '#22c55e',          // Inline highlighted text color
    overlayTint:    'rgba(5,8,18,0.55)',// Extra darkening gradient layer
  },

  /* ----------------------------------------------------------
   *  MUSIC PLAYER
   * ---------------------------------------------------------- */
  music: {
    autoplay:      true,
    defaultVolume: 0.50,         // 0.0 – 1.0
    playlist: [
      {
        title:     'Batman',
        artist:    'Biba',
        src:       'assets/music/batman.mp3',
        thumbnail: 'assets/music/music1.png',            // Optional cover image path
      },
      {
        title:     'Guantanamo',
        artist:    'Cunami',
        src:       'assets/music/guantanamo.mp3',
        thumbnail: 'assets/music/music2.png',
      },
      {
        title:     'Oaza',
        artist:    '2soma x Drrrti',
        src:       'assets/music/oaza.mp3',
        thumbnail: 'assets/music/music2.png',
      },
    ],
  },

  /* ----------------------------------------------------------
   *  STAFF PANEL
   * ---------------------------------------------------------- */
  staff: {
    enabled: true,
    title:   'SERVER TEAM',
    members: [
      { name: 'Maxwell',   role: 'Vlasnik/Developer',       avatar: 'assets/avatars/maxwell.jfif'  },
      { name: 'Domy',   role: 'Suvlasnik', avatar: 'assets/avatars/domy.jfif'  },
      { name: 'Macak',   role: 'Suvlasnik',     avatar: 'assets/avatars/macak.jfif'    },
    ],
  },

  /* ----------------------------------------------------------
   *  SOCIAL LINKS
   *  platform: 'discord' | 'youtube' | 'instagram' | 'twitter'
   * ---------------------------------------------------------- */
  social: {
    links: [
      { platform: 'discord',   label: 'Discord',   url: 'https://discord.gg/jamaicarp'         },
      { platform: 'tiktok',   label: 'TikTok',   url: 'https://www.tiktok.com/@balkanjamaicarp'       },
    ],
  },

  /* ----------------------------------------------------------
   *  LOADING BAR
   * ---------------------------------------------------------- */
  loading: {
    text:         'Povezivanje sa serverom…',
    completeText: 'Dobrodošli na Jamaica Roleplay',
    showPercent:  true,
  },

  /* ----------------------------------------------------------
   *  SECTION TOGGLES
   *  Set false to completely hide a section.
   * ---------------------------------------------------------- */
  sections: {
    showLogo:     true,
    showStaff:    true,
    showMusic:    true,
    showSocial:   true,
    showControls: true,   // Set false to hide the Show Controls button entirely
  },

  /* ----------------------------------------------------------
   *  SERVER KEYBINDS
   *  Displayed in the controls panel when the player clicks
   *  "Show Controls". Add, remove, or reorder freely.
   * ---------------------------------------------------------- */
  controls: [
    { key: 'F2',  label: 'Inventory'   },
    { key: 'F1',   label: 'Telefon'       },
    { key: 'X',   label: 'Podizanje ruku'    },
    { key: 'F3',  label: 'Animacije'  },
    { key: 'F10',  label: 'Scoreboard'  },
    { key: 'R',   label: 'Reload'      },
    { key: 'K',   label: 'Gepek'       },
  ],

};
