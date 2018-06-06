# esx_criminalrecords

``Credits to jsfour, helped me alot.``

[REQUIREMENTS]
  
* ESX Jobs Support
  * es_extended
  * essentialmode
  * esx_policejob => https://github.com/ESX-Org/esx_policejob
  * pNotify => https://github.com/Nick78111/pNotify
  
[INSTALLATION]

1) CD in your resources/[esx] folder

2) Import ``qalle_brottsregister.sql`` in your database

3) Add this in your server.cfg :
``start esx_criminalrecords``

4) Add this into the policejob menu :

```lua
              {label = 'Brottsregister',      value = 'criminalrecords'},
```


```lua
              if data2.current.value == 'criminalrecords' then
                  ESX.TriggerServerCallback('esx_qalle_brottsregister:grab', function(crimes)

                    local elements = {}

                      table.insert(elements, {label = _U('add'), value = 'crime'})
                      table.insert(elements, {label = '----=' .. _U('crimes') .. '=----', value = 'spacer'})

                      for i=1, #crimes, 1 do
                        print('Namn: ' .. crimes[i].name  .. ' - ' .. crimes[i].crime .. ' - ' .. crimes[i].date)
                        table.insert(elements, {label = crimes[i].date .. ' - ' .. crimes[i].crime, value = crimes[i].crime, name = crimes[i].name})
                      end


                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'brottsregister',
                        {
                            title    = _U('criminalrecord'),
                            elements = elements
                        },
                        function(data2, menu2)

                        if data2.current.value == 'crime' then
                        ESX.UI.Menu.Open(
                      'dialog', GetCurrentResourceName(), 'brottsregister_second',
                      {
                        title = _U('crimes') .. '?'
                      },
                      function(data3, menu3)
                      local crime = (data3.value)
                      print(crime)

                      if crime == tonumber(data3.value) then
                        sendNotification(_U('action_no'), 'error', 2500)
                        menu3.close()               
                      else
                        TriggerServerEvent('esx_qalle_brottsregister:add', GetPlayerServerId(player), crime)
                        OpenPoliceActionsMenu()
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
                                title    = _U('remove'),
                                elements = {
                                    {label = _U('yes'), value = 'yes'},
                                    {label = _U('no'), value = 'no'}
                                }
                            },
                            function(data3, menu3)

                              if data3.current.value == 'yes' then
                          TriggerServerEvent('esx_qalle_brottsregister:remove', GetPlayerServerId(player), data2.current.value)
                          print('Tog bort: ' .. data2.current.value)
                          sendNotification('Lyckades!', 'success', 5000)
                          ESX.UI.Menu.CloseAll()
                          OpenPoliceActionsMenu()
                        else
                          ESX.UI.Menu.CloseAll()
                          OpenPoliceActionsMenu()
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
```

locales

```lua
    --brottsregister--
  ['criminalrecord'] = 'Brottsregister',
  ['add'] = 'Lägg till',
  ['crimes'] = 'Brott',
  ['action_no'] = 'Åtgärd omöjlig',
  ['remove'] = 'Ta Bort?',
  ['yes'] = 'Ja',
  ['no'] = 'Nej',
  ```