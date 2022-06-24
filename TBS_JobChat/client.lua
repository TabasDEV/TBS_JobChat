-----------------------------------------------------------------------------------------------------------------------------------

-- Players

QBCore = nil

local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end

	while QBCore.Functions.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = QBCore.Functions.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		PlayerData = QBCore.Functions.GetPlayerData()
	end
end)







-- Mechanic Command

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/moto', '�Env�a una alerta a los mec�nicos de Sons Motors con /moto! ', {
    { name="Complaint", help="¡Escriba aquí su Problema!" }
})
end)

msg = nil
RegisterCommand('moto', function(source, args, rawCommand)
	TriggerEvent("chatMessage"," [Sons Motors] ", {230, 115, 0},   "Se ha avisado a los mecanicos, en breve te atenderan." )

	msg = table.concat(args, " ")

	PedPosition		= GetEntityCoords(GetPlayerPed(-1))
	
    local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
    local playerCoords = GetEntityCoords(PlayerPedId())
		streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		streetName = GetStreetNameFromHashKey(streetName)
	local msg = rawCommand:sub(5)
	local emergency = 'moto'
    TriggerServerEvent('tbs_jobChat:moto',{
        x = QBCore.Functions.MathRound(playerCoords.x, 1),
        y = QBCore.Functions.MathRound(playerCoords.y, 1),
        z = QBCore.Functions.MathRound(playerCoords.z, 1)
	}, msg, streetName, emergency)
end, false)

-----------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------

-- Mechanic Emergency

RegisterNetEvent('tbs_jobChat:motoEmergencySend')
AddEventHandler('tbs_jobChat:motoEmergencySend', function(messageFull)
    	PlayerData = QBCore.Functions.GetPlayerData()
	if PlayerData.job.name == 'mechanic2' then
		TriggerEvent('chat:addMessage', messageFull)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------

-- Mechanic Emergency Alert

RegisterNetEvent('tbs_jobChat:motoEmergencySend')
AddEventHandler('tbs_jobChat:motoEmergencySend', function(messageFull)
	PlayerData = QBCore.Functions.GetPlayerData()
	if PlayerData.job.name == 'mechanic2' then
		SetNotificationTextEntry("STRINGS");
		AddTextComponentString(normalString);
		SetNotificationMessage("CHAR_CARSITE3", "CHAR_CARSITE3", true, 8, "~y~Mec�nico avisado~s~", "Ubicaci�n GPS enviada");
		DrawNotification(false, true);
	end
end)


-- Marker Mechanic

RegisterNetEvent('tbs_jobChat:motoMarker')
AddEventHandler('tbs_jobChat:motoMarker', function(targetCoords, type)
    PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name == 'mechanic2' then
		local alpha = 250
		local call = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
		
		SetBlipSprite (call, 480)
		SetBlipDisplay(call, 4)
		SetBlipScale  (call, 1.6)
        SetBlipAsShortRange(call, true)
        SetBlipAlpha(call, alpha)

        SetBlipHighDetail(call, true)
		SetBlipAsShortRange(call, true)

		if type == 'moto' then
			SetBlipColour (call, 64)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString('Ayuda mecanico!')
			EndTextCommandSetBlipName(call)
		end

		while alpha ~= 0 do
			Citizen.Wait(100 * 4)
			alpha = alpha - 1
			SetBlipAlpha(call, alpha)

			if alpha == 0 then
				RemoveBlip(call)
				return
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------
