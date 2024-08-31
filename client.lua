local Data = {
    spectating = false,
    player = false,
    lastCoords = false,
}

RegisterNetEvent('atlanta-spectate:openMenu')
AddEventHandler('atlanta-spectate:openMenu', function()
    TriggerServerEvent('atlanta-spectate:getPlayerList')
end)

RegisterNetEvent('atlanta-spectate:sendPlayerList')
AddEventHandler('atlanta-spectate:sendPlayerList', function(players, playerCount)
    SendNUIMessage({
        type = "openMenu",
        players = players,
        playerCount = playerCount
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("spectatePlayer", function(data)
    if data.player then
        startSpectating(data.player)
    end
end)

startSpectating = function(playerData)
    if Data.spectating then
        return
    end

    local localPed = PlayerPedId()
    Data.lastCoords = GetEntityCoords(localPed)
    
    local playerId = tonumber(playerData.id)

    if playerId == GetPlayerServerId(PlayerId()) then
        Notify('You can\'t spectate yourself', 'error')
        return
    end

    Data.player = playerId

    TriggerServerEvent('atlanta-spectate:requestPlayerCoords', playerId)

    local function onReceivePlayerCoords(coords)


        if not coords then
            stopSpectating()
            return
        end

        local ped = PlayerPedId()
        local targetId = GetPlayerFromServerId(Data.player)
        local targetped = GetPlayerPed(targetId)

        DoScreenFadeOut(250)
        Wait(250) 

        RequestCollisionAtCoord(coords)
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, false)
        Wait(1000)
        SetEntityCoords(ped, coords - vector3(0, 0, 10))

        DoScreenFadeIn(250)
        Wait(250)

        if DoesEntityExist(targetped) then
            NetworkSetInSpectatorMode(true, targetped)
            Data.spectating = true
            SendNUIMessage({ type = "spectateStart" })
        else
            stopSpectating()
            Notify("Target player does not exist.", 'error')
        end
    end

    RegisterNetEvent('atlanta-spectate:receivePlayerCoords')
    AddEventHandler('atlanta-spectate:receivePlayerCoords', onReceivePlayerCoords)

    closeMenu()
end


stopSpectating = function()
    if not Data.spectating then
        return
    end

    local ped = PlayerPedId()

    if Data.lastCoords then
        DoScreenFadeOut(250)
        Wait(250) 

        RequestCollisionAtCoord(Data.lastCoords)
        NetworkSetInSpectatorMode(false, ped)
        FreezeEntityPosition(ped, false)
        SetEntityCoords(ped, Data.lastCoords)
        SetLocalPlayerAsGhost(true)
        Wait(1000) 

        DoScreenFadeIn(250)
        Wait(250)

        SetEntityVisible(ped, true)
        Wait(2500) 
        SetLocalPlayerAsGhost(false)
    end

    Data.player = false
    Data.spectating = false
    Data.lastCoords = false

    SendNUIMessage({ type = "spectateStop" })
end

RegisterNUICallback("stopSpectating", function()
    stopSpectating()
end)

closeMenu = function()
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "closeMenu" })
end

RegisterNUICallback("closeMenu", function()
    closeMenu()
end)

RegisterCommand(Config.OffSpectateCommand, function()
    if Data.spectating then
        stopSpectating()
    else
        Notify('You are not spectating anyone', 'error')
    end
end, false)
