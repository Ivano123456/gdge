if Config.Framework == 'esx' then
  ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'qb' then
  QBCore = exports['qb-core']:GetCoreObject()
  function qbShowHelpNotif(str)
      SetTextComponentFormat("STRING")
      AddTextComponentString(str)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)
  end
elseif Config.Framework == 'vrp' then
  function vRPShowHelpNotif(str)
      SetTextComponentFormat("STRING")
      AddTextComponentString(str)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)
  end
  function Notif(str)
      SetTextFont(1)
      SetNotificationTextEntry('STRING')
      AddTextComponentSubstringPlayerName(str)
      DrawNotification(false, true)
  end
elseif Config.Framework == 'detect' then
  if GetResourceState("es_extended") == 'started' then
      ESX = exports['es_extended']:getSharedObject()
      Config.Framework = 'esx'
  elseif GetResourceState("qb-core") == 'started' then
      QBCore = exports['qb-core']:GetCoreObject()
      Config.Framework = 'qb'
      function qbShowHelpNotif(str)
          SetTextComponentFormat("STRING")
          AddTextComponentString(str)
          DisplayHelpTextFromStringLabel(0, 0, 1, -1)
      end
  elseif GetResourceState("vrp") == 'started' then
      function vRPShowHelpNotif(str)
          SetTextComponentFormat("STRING")
          AddTextComponentString(str)
          DisplayHelpTextFromStringLabel(0, 0, 1, -1)
      end
      function Notif(str)
          SetTextFont(1)
          SetNotificationTextEntry('STRING')
          AddTextComponentSubstringPlayerName(str)
          DrawNotification(false, true)
      end
      Config.Framework = 'vrp'
  end
elseif Config.Framework == 'custom' then

end
  
Notify = function(text)
    if Config.Framework == 'esx' then
        ESX.ShowNotification(text)
    elseif Config.Framework == 'qb' then
        QBCore.Functions.Notify(text)
    elseif Config.Framework == 'vrp' then
        Notif(text)
    end
end
  
HelpNotify = function(text)
    if Config.Framework == 'esx' then
        ESX.ShowHelpNotification(text)
    elseif Config.Framework == 'qb' then
        exports['qb-core']:DrawText(text)
    elseif Config.Framework == 'vrp' then
        vRPShowHelpNotif(text)
    end
end
  
ProggressBar = function(text, time)
    if GetResourceState("rprogress") == "started" then
        exports.rprogress:Start(text, time)
    end
end

ShowHud = function()
    -- enter your hud export
    if GetResourceState("JustHud") == "started" then
        exports.JustHud:ToggleHud(true)
    end
    DisplayRadar(true)
end

HideHud = function()
    -- enter your hud export
    if GetResourceState("JustHud") == "started" then
        exports.JustHud:ToggleHud(false)
    end
    DisplayRadar(false)
end