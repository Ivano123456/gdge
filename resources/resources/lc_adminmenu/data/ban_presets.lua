local hour = 3600
local day = hour * 24
local week = day * 7
local month = week * 4

local durations = {
  {
    duration = -1,
    label = 'PERM'
  },
  {
    duration = hour,
    label = '1 Hour'
  },
  {
    duration = hour * 3,
    label = '3 Hours'
  },
  {
    duration = hour * 6,
    label = '6 Hours'
  },
  {
    duration = hour * 12,
    label = '12 Hours'
  },
  {
    duration = day,
    label = '1 Day'
  },
  {
    duration = day * 2,
    label = '2 Days'
  },
  {
    duration = day * 3,
    label = '3 Days'
  },
  {
    duration = day * 5,
    label = '5 Days'
  },
  {
    duration = week,
    label = '1 Week'
  },
  {
    duration = week * 2,
    label = '2 Weeks'
  },
  {
    duration = week * 3,
    label = '3 Weeks'
  },
  {
    duration = month,
    label = '1 Month'
  },
  {
    duration = month * 2,
    label = '2 Months'
  },
  {
    duration = month * 3,
    label = '3 Months'
  },
  {
    duration = month * 6,
    label = '6 Months'
  },
  {
    duration = day * 365,
    label = '1 Year'
  },
}

local presets = {
  {
    reason = 'Trolling',
    duration = week * 2
  },
  {
    reason = 'Combat log',
    duration = day * 3
  },
  {
    reason = 'Cop baiting',
    duration = day * 3,
  },
  {
    reason = 'Cheating',
    duration = -1
  },
  {
    reason = 'RDM',
    duration = month
  },
  {
    reason = 'VDM',
    duration = month
  },
  {
    reason = 'Stream Sniping',
    duration = week * 2
  }
}

return {
  durations = durations,
  presets = presets
}