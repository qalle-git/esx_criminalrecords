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

RegisterNetEvent('esx_criminalrecords:open')
AddEventHandler('esx_criminalrecords:open', function()
    OpenCriminalRecords()
end)

-----------------------------------------------------------
--== PUT THIS WHOLE CODE INTO POLICEJOB IN THE F6 MENU ==--
-----------------------------------------------------------

function OpenCriminalRecords(closestPlayer)
    ESX.TriggerServerCallback('esx_qalle_brottsregister:grab', function(crimes)

        local elements = {}

        table.insert(elements, {label = 'Add Crime To Player', value = 'crime'})
        table.insert(elements, {label = '----= Crimes =----', value = 'spacer'})

        for i=1, #crimes, 1 do
            table.insert(elements, {label = crimes[i].date .. ' - ' .. crimes[i].crime, value = crimes[i].crime, name = crimes[i].name})
        end


        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'brottsregister',
            {
                title    = 'Criminalrecord',
                elements = elements
            },
        function(data2, menu2)

            if data2.current.value == 'crime' then
                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'brottsregister_second',
                    {
                        title = 'Crime?'
                    },
                function(data3, menu3)
                    local crime = (data3.value)

                    if crime == tonumber(data3.value) then
                        ESX.ShowNotification('Action Impossible')
                        menu3.close()               
                    else
                        menu2.close()
                        menu3.close()
                        TriggerServerEvent('esx_qalle_brottsregister:add', GetPlayerServerId(closestPlayer), crime)
                        ESX.ShowNotification('Added to register!')
                        Citizen.Wait(100)
                        OpenCriminalRecords(closestPlayer)
                    end

                end,
            function(data3, menu3)
                menu3.close()
            end)
        else
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'remove_confirmation',
                    {
                    title    = 'Remove?',
                    elements = {
                        {label = 'Yes', value = 'yes'},
                        {label = 'No', value = 'no'}
                    }
                },
            function(data3, menu3)

                if data3.current.value == 'yes' then
                    menu2.close()
                    menu3.close()
                    TriggerServerEvent('esx_qalle_brottsregister:remove', GetPlayerServerId(closestPlayer), data2.current.value)
                    ESX.ShowNotification('Removed!')
                    Citizen.Wait(100)
                    OpenCriminalRecords(closestPlayer)
                else
                    menu3.close()
                end                         

                end,
            function(data3, menu3)
                menu3.close()
            end)                 
        end

        end,
        function(data2, menu2)
            menu2.close()
        end)

    end, GetPlayerServerId(closestPlayer))
end

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(5)
        if IsControlJustReleased(0, Keys['F5']) then
            if PlayerData.job.name == 'police' then
                local closestPlayer, distance = ESX.Game.GetClosestPlayer()
                if distance ~= -1 and distance <= 3 then
                    OpenCriminalRecords(closestPlayer)
                else
                    ESX.ShowNotification('No players nearby')
                end
            end
        end
    end
end)
