musics = {}
myPlaylists = {}
playlists = {}
current_volume = 0.1
current_music_id = 1

RegisterNUICallback('GetMyPlaylist', function(data, cb)
    cb({myPlaylists, 'myplaylist'})
end)

RegisterNUICallback('GetAllPlaylist', function(data, cb)
    cb({playlists, 'allplaylist'})
end)

RegisterNUICallback('PauseMusic', function()
    TriggerServerEvent('0r-carcontrol:ToggleMusic')
    SetVehicleRadioEnabled(GetVehiclePedIsIn(PlayerPedId()), true) 
end)

RegisterNUICallback('ResumeMusic', function()
    TriggerServerEvent('0r-carcontrol:ToggleMusic')
    SetVehicleRadioEnabled(GetVehiclePedIsIn(PlayerPedId()), false) 
end)

RegisterNetEvent('0r-carcontrol:refreshplaylist', function(data, name)
    myPlaylists = data

    SendNUIMessage({
        action = 'updatemyplaylist',
        data = myPlaylists,
        name = name
    })
end)

RegisterNetEvent('0r-carcontrol:refreshplaylist2', function(data)
    playlists = data
end)

RegisterNUICallback("MusicAction", function(data, cb)
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
        cb('ok')        
        return
    end
    if data.type == 'play' then
        current_music_id = tonumber(data.id)
        TriggerServerEvent('0r-carcontrol:playmusic', {
            url = data.url,
            name = data.name,
            isPaused = false,
            volume = 0.1,
            newTimeStamp = false,
        })
        SetVehicleRadioEnabled(Vehicle, false) 
        SetVehRadioStation(Vehicle, "OFF")
    end
 
    if data.type == 'pause' then
        TriggerServerEvent('0r-carcontrol:ToggleMusic')
        SetVehicleRadioEnabled(Vehicle, true) 
    end
    if data.type == 'volume' then
        current_volume = tonumber(data.payload)
        TriggerServerEvent('0r-carcontrol:setvolume', tonumber(data.payload))
    end
    if data.type == 'timestamp' then
        TriggerServerEvent('0r-carcontrol:SetTimeStamp', tonumber(data.payload))

    end
    cb('ok')
end)

RegisterNetEvent("0r-carcontrol:senksorizeet", function(data, src)
    musics[src] = data
end)

RegisterNetEvent("0r-carcontrol:senksorizeet2", function(data, src)
    if exports.xsound:soundExists('music-'..src) then
        exports.xsound:Destroy('music-'..src)     
    end    
    musics[src] = data
end)

function GetOpenWindows(vehicle)
    local open = false
    for i=0, 3 do
        local door = i
        if door == 2 then
            door = 3
        elseif door == 3 then
            door = 2
        end
        local isclosed = IsVehicleWindowIntact(vehicle,i)
        if not isclosed and GetIsDoorValid(vehicle, door) then
            open = true
        end
    end
    return open
end

CreateThread(function()
    while true do
        for src, data in pairs(musics) do
            if data then
                local player = GetPlayerFromServerId(src)
                if player ~= -1 then
                    local ped = GetPlayerPed(player)
                    local PlayerPed = PlayerPedId()
                    local vehicle = GetVehiclePedIsIn(ped)
                    
                    if vehicle and DoesEntityExist(vehicle) then
                        if not exports.xsound:soundExists('music-'..src) then
                            exports.xsound:PlayUrlPos('music-'..src, data.url, data.volume, GetEntityCoords(vehicle))
                            exports.xsound:setVolumeMax('music-'..src, 1.0)
                            local myVehicle = GetVehiclePedIsIn(PlayerPed)
                            if vehicle == myVehicle then
                                exports.xsound:setVolume('music-'..src, data.volume)
                            else
                                local count = 0

                                if  GetOpenWindows(vehicle) then
                                    count = 1/13
                                end
                                
                                local volume = ((data.volume/2) + count)
                                local distance = (#(GetEntityCoords(PlayerPed) - GetEntityCoords(vehicle))) / 50
                                exports.xsound:setVolume('music-'..src, volume-distance)
                            end

                        else                        
                            local url = exports.xsound:getLink('music-'..src)
                            
                            if url ~= data.url then
                                exports.xsound:Destroy('music-'..src)
                                exports.xsound:PlayUrlPos('music-'..src, data.url, data.volume, GetEntityCoords(vehicle))
                                exports.xsound:setVolumeMax('music-'..src, 1.0)       
                                if exports.xsound:isPaused('music-'..src) then
                                    exports.xsound:Resume('music-'..src)      
                                end                              
                            end
                            local myVehicle = GetVehiclePedIsIn(PlayerPed)
                            if vehicle == myVehicle then
                                exports.xsound:setVolume('music-'..src, data.volume)
                            else

                                local count = 0
                                if  GetOpenWindows(vehicle) then
                                    count = 1/13
                                end

                                local volume = ((data.volume/2) + count)
                                local distance = (#(GetEntityCoords(PlayerPed) - GetEntityCoords(vehicle))) / 50
                                exports.xsound:setVolume('music-'..src, volume-distance)
                            end
                        
                            exports.xsound:Position('music-'..src, GetEntityCoords(vehicle))
                            if data.isPaused  then
                                exports.xsound:Pause('music-'..src)
                            elseif not data.isPaused then
                                exports.xsound:Resume('music-'..src)
                            end
                      
                           
              
                            exports.xsound:Distance('music-'..src, 130)
                        end  
                    else
                        if exports.xsound:soundExists('music-'..src) then
                            exports.xsound:Destroy('music-'..src)     
                        end  
                    end
                end
            else
                if exports.xsound:soundExists('music-'..src) then
                    exports.xsound:Destroy('music-'..src)     
                end      
            end
        end
        Wait(350)
    end
end)

CreateThread(function()
    while true do
        local src = GetPlayerServerId(PlayerId()) 
        local cd = 2000
        if exports.xsound:soundExists('music-'..src) then
            local maxDuration = exports.xsound:getMaxDuration('music-'..src)
            local timeStamp = exports.xsound:getTimeStamp('music-'..src)
 

            if not exports.xsound:isPaused('music-'..src) then
                SendNUIMessage({
                    action = 'MusicTime',
                    payload = {
                        maxDuration = maxDuration,
                        timeStamp = timeStamp
                    }
                })
                if (maxDuration == math.ceil(timeStamp)+1 or maxDuration == math.ceil(timeStamp)+2 or maxDuration == math.ceil(timeStamp)) and maxDuration ~= 0 then
                    SendNUIMessage({
                        action = 'ChangeMusic'
                    })
                end
            end
       
            cd = 0
        end
        Wait(cd)
    end
end)

RegisterNetEvent("0r-carcontrol:SetTimeStamp", function(src, timestamp)
    if exports.xsound:soundExists('music-'..src) then
        exports.xsound:setTimeStamp('music-'..src, timestamp)
    end
end)

RegisterNUICallback("addtoplaylist", function(data)
    TriggerServerEvent("0r-carcontrol:addtoplaylist", data)
end)

RegisterNUICallback("DeleteMusic", function(data)
    TriggerServerEvent("0r-carcontrol:deletemusic", data.sqlid, data.url)
end)

RegisterNUICallback("ChangeMusic", function(data)
    if data.icon then
        if data.type == 'sag' then
            local id = tonumber(current_music_id)
            current_music_id += 1
            local music = myPlaylists[1]
            if myPlaylists[current_music_id] ~= nil then
                music = myPlaylists[current_music_id]
            else
                current_music_id = 1
                music = myPlaylists[1]
            end
    
            if music.name then
                SendNUIMessage({
                    action = 'UpdateName',
                    name = music.name
                })
                TriggerServerEvent("0r-carcontrol:changemusic", {
                    url = music.url,
                    name = music.name,
                    isPaused = false,
                    volume = current_volume,
                    newTimeStamp = false,
                })
            end
        elseif data.type == 'sol' then
            local id = tonumber(current_music_id)
            current_music_id -= 1
            local music = myPlaylists[1]
            if myPlaylists[current_music_id] ~= nil then
                music = myPlaylists[current_music_id]
            else
                current_music_id = #myPlaylists
                music = myPlaylists[#myPlaylists]
            end
    
            if music.name then
                SendNUIMessage({
                    action = 'UpdateName',
                    name = music.name
                })
                TriggerServerEvent("0r-carcontrol:changemusic", {
                    url = music.url,
                    name = music.name,
                    isPaused = false,
                    volume = current_volume,
                    newTimeStamp = false,
                })
            end
        end
    else
        local id = tonumber(current_music_id)
        current_music_id += 1
        local music
        if myPlaylists[current_music_id] ~= nil then
            music = myPlaylists[current_music_id]
        else
            current_music_id = 1
            music = myPlaylists[1]
        end

        SendNUIMessage({
            action = 'UpdateName',
            name = music.name
        })
        TriggerServerEvent("0r-carcontrol:changemusic", {
            url = music.url,
            name = music.name,
            isPaused = false,
            volume = current_volume,
            newTimeStamp = false,
        })
    end
end)
RegisterNetEvent("0r-carcontrol:DestroyMusic", function(src)
    if exports.xsound:soundExists('music-'..src) then
        exports.xsound:Destroy('music-'..src)     
    end    
end)