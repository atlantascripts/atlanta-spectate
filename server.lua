RegisterCommand(Config.SpectateCommand, function(source, args, rawCommand)
    local player = ESX.GetPlayerFromId(source)
    if player and Config.AuthorizedGroups[player.getGroup()] then
        TriggerClientEvent('atlanta-spectate:openMenu', source)
    else
        Notify('You do not have permission to open the menu.', 'error')
    end
end, false)

getPlayerData = function(serverId)
    local xPlayer = ESX.GetPlayerFromId(serverId)
    if not xPlayer then
        return nil
    end

    local job = xPlayer.getJob()
    local accounts = xPlayer.getAccounts()

    local cash = "-"
    local bank = "-"

    for _, account in pairs(accounts) do
        if account.name == 'money' then
            cash = account.money
        elseif account.name == 'bank' then
            bank = account.money
        end
    end

    return {
        id = serverId,
        name = GetPlayerName(serverId) or "Unknown",
        icName = xPlayer.getName() or "Unknown",
        group = xPlayer.getGroup() or "Unknown",
        job = job.label .. " - " .. job.grade_label,
        cash = cash .. "$",
        bank = bank .. "$"
    }
end

RegisterServerEvent('atlanta-spectate:getPlayerList')
AddEventHandler('atlanta-spectate:getPlayerList', function()
    local players = {}
    local playerCount = 0

    for _, serverId in pairs(GetPlayers()) do
        local playerData = getPlayerData(serverId)
        if playerData then
            playerCount = playerCount + 1
            table.insert(players, playerData)
        end
    end

    TriggerClientEvent('atlanta-spectate:sendPlayerList', source, players, playerCount)
end)

RegisterServerEvent('atlanta-spectate:requestPlayerCoords')
AddEventHandler('atlanta-spectate:requestPlayerCoords', function(serverId)
    local targetPed = GetPlayerPed(serverId)

    if DoesEntityExist(targetPed) then
        TriggerClientEvent('atlanta-spectate:receivePlayerCoords', source, GetEntityCoords(targetPed))
    else
        TriggerClientEvent('atlanta-spectate:receivePlayerCoords', source, false)
    end
end)
