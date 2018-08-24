# esx_criminalrecords

``Credits to jsfour, helped me alot.``

[REQUIREMENTS]
  
* ESX Support
  * esx_policejob => https://github.com/ESX-Org/esx_policejob
  
[INSTALLATION]

1) CD in your resources/[esx] folder

2) Import ``qalle_brottsregister.sql`` in your database

3) Add this in your server.cfg :
``start esx_criminalrecords``

4) Add this into the esx_policejob menu :

```lua
              {label = 'Criminalrecord',      value = 'criminalrecords'},
```


```lua
	elseif action == 'criminalrecords' then
		TriggerEvent('esx_criminalrecords:open')
```

then remove this from client.lua in esx_criminalrecords

```lua
Citizen.CreateThread(function()
  	while true do 
  		Citizen.Wait(0)
    	if IsControlJustReleased(0, Keys['F5']) then
      		local closestPlayer, distance = ESX.Game.GetClosestPlayer()
  			if distance ~= -1 and distance <= 3 then
  				if PlayerData.job.name == 'police' then
    				OpenCriminalRecords(closestPlayer)
    			end
  			else
     			ESX.ShowNotification('No players nearby')
  			end
    	end
  	end
end)
```
