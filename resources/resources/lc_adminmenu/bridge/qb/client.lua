local Bridge = {
  GetOwnedVehicleLabel = function(data)
    local model = GetHashKey(data.vehicle)
    return GetLabelText(GetDisplayNameFromVehicleModel(model))
  end,
  SuccessNotify = function(title, description, id)
    local data = {
      position = 'top',
      style = {
          width = 'fit-content',
          backgroundColor = '#000000',
          borderRadius = '0.5rem',
          color = '#ffffff',
          ['.description'] = {
            color = '#cccccc'
          }
      },
      icon = 'check',
      iconColor = '#3fad00'
    }
    data.title = title or nil
    data.description = description or nil
    data.id = id or nil

    lib.notify(data)
  end,
  InfoNotify = function(title, description, id)
    local data = {
      position = 'top',
      style = {
          width = 'fit-content',
          backgroundColor = '#000000',
          borderRadius = '0.5rem',
          color = '#ffffff',
          ['.description'] = {
            color = '#cccccc'
          }
      },
      icon = 'info',
      iconColor = '#4287f5'
    }
    data.title = title or nil
    data.description = description or nil
    data.id = id or nil

    lib.notify(data)
  end,
  FailNotify = function(title, description, id)
    local data = {
      position = 'top',
      style = {
          width = 'fit-content',
          backgroundColor = '#000000',
          borderRadius = '0.5rem',
          color = '#ffffff',
          ['.description'] = {
            color = '#cccccc'
          }
      },
      icon = 'ban',
      iconColor = '#C53030'
    }
    data.title = title or nil
    data.description = description or nil
    data.id = id or nil

    lib.notify(data)
  end
}

return Bridge