Config = {}

Config.SpectateCommand = 'spectate'
Config.OffSpectateCommand = 'spectateoff'

Config.AuthorizedGroups = {
	["admin"] = true,
	["owner"] = true,
}

Notify = function(message, type)
    if LocalPlayer then 
        lib.notify({
            title = 'Spectate',
            description = message,
            type = type,
            position = 'top'
        })
    else
        TriggerClientEvent('ox_lib:notify', -1, { type = type, title = 'Spectate', description = message, position = 'top' })
    end
end