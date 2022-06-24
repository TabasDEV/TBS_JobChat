-----------------------------------------------------------------------------------------------------------------------------------

-- Players

local QBCore = exports['qb-core']:GetCoreObject()

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM players WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
		}
	else
		return nil
	end
end

-----------------------------------------------------------------------------------------------------------------------------------

-- Mechanic chat

RegisterServerEvent('tbs_jobChat:moto')
AddEventHandler('tbs_jobChat:moto', function(targetCoords, msg, streetName, emergency)
    local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(source)
	fal = xPlayer.getName(source)
	local messageFull
	if emergency == 'moto' then
		messageFull = {
			template = '<div style="padding: 8px; margin: 8px; background-color: rgba(128, 64, 0); border-radius: 25px;"><i class="fas fa-bell"style="font-size:15px"></i> [MOTO] : {0} | Location : {1} | {2}</font></i></b></div>',
        	args = {fal, streetName, msg}
		}
	end
	TriggerClientEvent('tbs_jobChat:motoMarker', -1, targetCoords, emergency)
	TriggerClientEvent('tbs_jobChat:motoEmergencySend', -1, messageFull)
end)
-----------------------------------------------------------------------------------------------------------------------------------