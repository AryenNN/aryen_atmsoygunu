--Script Yazar AryenN#0005

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('tost:zgarnijsiano')
AddEventHandler('tost:zgarnijsiano', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local Ilosc = math.random(3500,7500) --Yazar kasa için 500 ila 1800$ arasında olası ocak
	TriggerClientEvent('esx:showNotification', source, '~y~Atmeden çıkan para ~g~'..Ilosc..'$~y~ .')
	TriggerClientEvent('esx:showNotification', source, '~y~Başka Atm soymak için 180 saniye beklemelisin.')
    xPlayer.addMoney(Ilosc)
	Wait(500)
end)


RegisterServerEvent('tost:zawiadompsy')
AddEventHandler('tost:zawiadompsy', function(x, y, z) 
    TriggerClientEvent('tost:infodlalspd', -1, x, y, z)
end)
