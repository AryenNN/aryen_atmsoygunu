--Develoer by AryenN#0005



local Keys = {["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

local playerCoords = GetEntityCoords(GetPlayerPed(-1))
local objectCoords = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

function LoadAnimationDictionary(animationD)
	while(not HasAnimDictLoaded(animationD)) do
		RequestAnimDict(animationD)
		Citizen.Wait(1)
	end
end

function Prop()
	tab = CreateObject(GetHashKey("prop_anim_cash_pile_01"), 0, 0, 0, true, true, true)
	AttachEntityToEntity(tab, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
end

function Animacja()
	local dict = "oddjobs@shop_robbery@rob_till"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	Citizen.Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "loop", 8.0, 8.0, -1, 1, 0, false, false, false)
end
--------------------
local Oczekiwanie = 0
local Kradne = 0
local procent = 60
local uciek = 0
local cooldown = 0
local powiadom = 0
--------------------
local infoPolicja = 25 -- kaç saniye kaldı polise bilgi vermeli
local czasCooldown = 120 * 1000 -- 90 = bu, bir sonraki soygundan önce soğuma süresinin geçen saniye sayısıdır
--------------------

function NaliczCooldown()
cooldown = 1
Citizen.Wait(czasCooldown)
cooldown = 0
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Oczekiwanie)

        local pedCoords = GetEntityCoords(PlayerPedId())
        local objectId = GetClosestObjectOfType(pedCoords, 2.5, GetHashKey("prop_atm_02"), false)
        local objectCoords = GetEntityCoords(objectId)
        local dist = Vdist(pedCoords.x, pedCoords.y, pedCoords.z, objectCoords.x, objectCoords.y, objectCoords.z)
		
		if dist <= 20.0 then
		Oczekiwanie = 0
		else
		Oczekiwanie = 500
		end
		
		if dist <= 1.5 and cooldown == 0 then
		DrawText3D(objectCoords.x, objectCoords.y, objectCoords.z,'~y~[G] ~r~basarak bankamatigi soy')
		end
		
        if DoesEntityExist(objectId) and IsControlJustPressed(0, Keys['G']) and cooldown == 0 then
			local playerCoords = GetEntityCoords(GetPlayerPed(-1))
			if Kradne == 0 then
			ESX.ShowNotification('~y~Bankamatik Soyuluyor.')
			Kradne = 1
			Animacja()
			Prop()
			for i=1, 3305, 1 do
				local pedCoords = GetEntityCoords(PlayerPedId())
				local dist = Vdist(pedCoords.x, pedCoords.y, pedCoords.z, objectCoords.x, objectCoords.y, objectCoords.z)
				if dist <= 2.0 then
				Citizen.Wait(5)
				local pedCoords = GetEntityCoords(GetPlayerPed(-1))
				procent = procent - 0.014
				DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 0.98, 'Kalan süre:~b~ '..math.floor(procent)..' sekund.')
					if powiadom == 0 and math.floor(procent) < infoPolicja then
					powiadom = 1
					PowiadomPsy()
					end
				else
				uciek = 1
				ESX.ShowNotification('~r~Uciekłeś, rabunek przerwany.')
				ESX.ShowNotification('~y~Następny bankomat możesz obrabować za 180 sekund.')
				end
			end
			Kradne = 0
			procent = 47
			ClearPedTasks(GetPlayerPed(-1))
				if uciek == 0 then
				TriggerServerEvent("tost:zgarnijsiano")
				end
			uciek = 0
			else
			ESX.ShowNotification('~r~Nie tak szybko.')
			end
			powiadom = 0
			NaliczCooldown()
        end
        
    end
end)

RegisterNetEvent('tost:infodlalspd')
AddEventHandler('tost:infodlalspd', function(x, y, z)	
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		local street = GetStreetNameAtCoord(x, y, z)
        local droga = GetStreetNameFromHashKey(street)
        ESX.ShowNotification('~r~Birisi atm soyuyor sokak ~y~'..droga..'!')
        PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", 0, 1)
        
		local blip = AddBlipForCoord(x, y, z)
		SetBlipSprite(blip, 161)
        SetBlipScale(blip, 1.2)
        SetBlipColour(blip, 75)
        SetBlipAlpha(blip, 180)
        SetBlipHighDetail(blip, true)
	    BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Rabunek bankomatu')
        EndTextCommandSetBlipName(blip)
        Citizen.Wait(30000)
        RemoveBlip(blip)
	end
end)

function PowiadomPsy()
	x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	playerX = tonumber(string.format("%.2f", x))
    playerY = tonumber(string.format("%.2f", y))
    playerZ = tonumber(string.format("%.2f", z))
	TriggerServerEvent('tost:zawiadompsy', playerX, playerY, playerZ)
	Citizen.Wait(500)
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end
