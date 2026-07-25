return {
  -- ADMIN PANEL
  panel_open_command = 'admin',
  panel_open_key = 'DELETE',

  -- SMALL MENU
  small_menu_open_command = { 'sm', 'smallmenu' },
  small_menu_open_key = 'END',

  -- LOCALE
  locale = 'en', -- you can create your own translation file by creating json file in locale folder
  time_language_subtag = 'en', -- https://en.wikipedia.org/wiki/IETF_language_tag#List_of_common_primary_language_subtags

  -- REPORTS
  use_report_system = false,
  report_command = { 'report', 'ticket' },
  max_allowed_reports = 10,
  delete_reports_after = 3600 * 24 * 14,  -- 3600 * 24 * 14 -> Reports will be deleted after 14 days
                                          -- "restart" -> Reports will be deleted after each server restart
                                          -- false -> Reports will be kept forever

  -- SPECTATE
  spectate_command = { 'spectate' },

  -- ANNOUNCEMENTS
  announcement_position = 'bottom-right', -- possible values: bottom-left, bottom-center, bottom-right, center-left, center-right, top-left, top-center, top-right

  -- MISC
  plate_pattern = 'AA1A11AA', -- https://overextended.dev/ox_lib/Modules/String/Shared#stringrandom
  high_balance_warning = 1000000, -- If player have more than this amount, warning will be shown

  -- ADMIN UI
  open_player_profile_key = 'g',

  noclip_key = 'f11', -- If you don't want to assign it to any key, you can just set it to nil
  noclip_command = { 'nc', 'noclip' }, -- Same with command - If you don't want command for noclip, just set it to nil
  noclip_controls = {
    FORWARD = 32, -- W
    BACKWARD = 33, -- S
    UP = 44, -- Q
    DOWN = 20 -- Z
  },

  freecam_key = 'f10',
  freecam_command = { 'fc', 'freecam' },

  ---@param seed string Player's global identifier
  ---@return string Avatar URL
  default_avatar = function(seed)
    -- https://www.dicebear.com/styles/
    return 'https://api.dicebear.com/9.x/bottts/png?seed='..seed..'&eyes=bulging,dizzy,eva,frame1,frame2,happy,robocop,roundFrame01,roundFrame02,shade01&texture=circuits,dirty01,dirty02,dots,grunge01,grunge02&top=antenna,antennaCrooked,bulb01,glowingBulb01,glowingBulb02,horns,radar'
  end,

  -- You don't need to touch these fields:)
  frameworks = {
    esx = 'es_extended',
    qb = 'qb-core',
    qbx = 'qbx_core'
  },

  debug = false
}