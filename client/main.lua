local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}


--- esx
ESX                           = nil
local PlayerData              = {}

Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
 	PlayerData = ESX.GetPlayerData()
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

-----------------------------------------------------------
--== PUT THIS WHOLE CODE INTO POLICEJOB IN THE F6 MENU ==--
-----------------------------------------------------------
function openCriminalRecords(player)
  local player, distance = ESX.Game.GetClosestPlayer()
  ESX.TriggerServerCallback('esx_qalle_brottsregister:grab', function(crimes)

      local elements = {}

        table.insert(elements, {label = 'Lägg till brott', value = 'crime'})
        table.insert(elements, {label = '----= Brott =----', value = 'spacer'})

        for i=1, #crimes, 1 do
          print('Namn: ' .. crimes[i].name  .. ' - ' .. crimes[i].crime .. ' - ' .. crimes[i].date)
          table.insert(elements, {label = crimes[i].date .. ' - ' .. crimes[i].crime, value = crimes[i].crime, name = crimes[i].name})
        end


      ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'brottsregister',
          {
              title    = 'Brottsregister',
              elements = elements
          },
          function(data2, menu2)

          if data2.current.value == 'crime' then
          ESX.UI.Menu.Open(
        'dialog', GetCurrentResourceName(), 'brottsregister_second',
        {
          title = 'Brott?'
        },
        function(data3, menu3)
        local crime = (data3.value)
        print(crime)

        if crime == tonumber(data3.value) then
          sendNotification('Åtgärd omöjlig', 'error', 2500)
          menu3.close()               
        else
            openMenu()
          TriggerServerEvent('esx_qalle_brottsregister:add', GetPlayerServerId(player), crime)
        end

          end,
          function(data3, menu3)
            menu3.close()
          end
        )
        else
          ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'remove_confirmation',
              {
                  title    = 'Ta Bort?',
                  elements = {
                      {label = 'Ja', value = 'yes'},
                      {label = 'Nej', value = 'no'}
                  }
              },
              function(data3, menu3)

                if data3.current.value == 'yes' then
            TriggerServerEvent('esx_qalle_brottsregister:remove', GetPlayerServerId(player), data2.current.value)
            print('Tog bort: ' .. data2.current.value)
            sendNotification('Lyckades!', 'success', 5000)
            ESX.UI.Menu.CloseAll()
            openMenu()
          else
            ESX.UI.Menu.CloseAll()
            openMenu()
          end                         

              end,
              function(data3, menu3)
          menu3.close()
        end
          )                 
          end

          end,
          function(data2, menu2)
      menu2.close()
    end
      )
  end, GetPlayerServerId(player))
end

Citizen.CreateThread(function()
  while true do Citizen.Wait(0)
    if IsControlJustReleased(0, Keys['F5']) then
      local player, distance = ESX.Game.GetClosestPlayer()
      if distance ~= -1 and distance <= 3 then
        openCriminalRecords(player)
      else
        sendNotification('not close enough', 'error', 5000)
      end
    end
  end
end)

--notification
function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "records",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end