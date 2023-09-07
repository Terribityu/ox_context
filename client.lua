-- [[ Register Events ]] --
RegisterNetEvent("ox_context:record")
AddEventHandler("ox_context:record", function()
    StartRecording(1) -- https://docs.fivem.net/natives/?_0xC3AC2FFF9612AC81
    -- notify(Config.record)
end)

RegisterNetEvent("ox_context:saveclip")
AddEventHandler("ox_context:saveclip", function()
    StartRecording(0) -- https://docs.fivem.net/natives/?_0xC3AC2FFF9612AC81
    StopRecordingAndSaveClip() -- https://docs.fivem.net/natives/?_0x071A5197D6AFC8B3
    -- notify(Config.saveclip)
end)

RegisterNetEvent("ox_context:delclip")
AddEventHandler("ox_context:delclip", function()
    StopRecordingAndDiscardClip() -- https://docs.fivem.net/natives/?_0x88BB3507ED41A240
    -- notify(Config.delclip)
end)

RegisterNetEvent("ox_context:editor")
AddEventHandler("ox_context:editor", function()
    NetworkSessionLeaveSinglePlayer() -- https://docs.fivem.net/natives/?_0x3442775428FD2DAA
    ActivateRockstarEditor() -- https://docs.fivem.net/natives/?_0x49DA8145672B2725
    -- notify(Config.editor)
end)

RegisterNetEvent("ox_context:steal")
AddEventHandler("ox_context:steal", function()
    exports.ox_inventory:openNearbyInventory()
end)

RegisterCommand('openinteraction', function()
    if(lib.getOpenContextMenu() ~= nil) then
        lib.hideContext(onExit)
    else 
        checkPlayerStatus();
    end
end)

RegisterKeyMapping('openinteraction', 'Citizen Interaction Menu', 'keyboard', 'F3')

function checkPlayerStatus()

        local playerPed = GetPlayerPed(-1) -- Get the player's ped
        local x, y, z = table.unpack(GetEntityCoords(playerPed, false)) -- Get player's coordinates

        local nearbyPlayers = GetPlayersInRadius(x, y, z, 2.0) -- Adjust the radius as needed

        local isInVehicle = IsPedInAnyVehicle(playerPed, false)

        if isInVehicle then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local vehicleClass = GetVehicleClass(vehicle)
            
            -- You are in a vehicle
            lib.showContext('citizen_menu2')
        elseif #nearbyPlayers > 0 then
            -- There are close players nearby
            lib.showContext('citizen_menu')
        else
            -- You are neither in a vehicle nor close to any players
            lib.showContext('citizen_menu1')
        end
end

function GetPlayersInRadius(x, y, z, radius)
    local players = {}
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            local playerPed = GetPlayerPed(i)
            local playerCoords = GetEntityCoords(playerPed, false)
            local distance = GetDistanceBetweenCoords(x, y, z, playerCoords, true)
            if distance <= radius and i ~= PlayerId() then
                table.insert(players, i)
            end
        end
    end
    return players
end

-- Citizen Menu Nearby Player
lib.registerContext({
    id = 'citizen_menu',
    title = '🙍‍♂️ Citizen Menu',
    options = {
      {
        title = '🙅🏻‍♂️ Interaction Menu',
        description = 'Citizen Interaction',
        menu = 'interaction_menu'
      },
      {
        title = '😄 Emote Menu',
        description = 'Emote Menu',
        event = 'scully_emotemenu:toggleMenu'
      },
      {
        title = '🎥 Rockstar Editor',
        description = 'Rockstar Editor',
        menu = 'rockstar_editor'
      }
    }
  })

--   Citizen Menu Alone
lib.registerContext({
    id = 'citizen_menu1',
    title = '🙍‍♂️ Citizen Menu',
    options = {
      {
        title = '🙅🏻‍♂️ Show Identification',
        description = 'Show Identification',
        event = ''
      },
      {
        title = '😄 Emote Menu',
        description = 'Emote Menu',
        event = 'scully_emotemenu:toggleMenu'
      },
      {
        title = '🎥 Rockstar Editor',
        description = 'Rockstar Editor',
        menu = 'rockstar_editor'
      }
    }
  })

--   Citizen Menu While in Vehicle
lib.registerContext({
    id = 'citizen_menu2',
    title = '🙍‍♂️ Citizen Menu',
    options = {
      {
        title = '🙅🏻‍♂️ Show Identification',
        description = 'Show Identification',
        event = ''
      },
      {
        title = '🚘 Vehicle Menu',
        description = 'Vehicle Menu',
        event = 'ron-carmenu:openUI'
      },
      {
        title = '🎥 Rockstar Editor',
        description = 'Rockstar Editor',
        menu = 'rockstar_editor'
      }
    }
  })

--   Interaction Context Menu
  lib.registerContext({
    id = 'interaction_menu',
    title = '🙅🏻‍♂️ Interaction Menu',
    options = {
      {
        title = '🔪 Search Citizen',
        description = 'Search Citizen',
        event = 'ox_context:steal'
      },
      {
        title = '🔫 Take Hostage',
        description = 'Take Hostage',
        event = 'takehostage:triggerhostage'
      },
      {
        title = '💪🏼 Carry Menu',
        description = 'Carry Menu',
        menu = 'carry_menu'
      }
    }
  })

--   Rockstar Editor Menu
  lib.registerContext({
    id = 'rockstar_editor',
    title = '🎥 Rockstar Editor',
    options = {
      {
        title = '🎥 Open Editor',
        description = 'Open Rockstar Editor',
        event = 'ox_context:editor'
      },
      {
        title = '🔴 Start Recording',
        description = 'Start Recording',
        event = 'ox_context:record'
      },
      {
        title = '💾 Save Recording',
        description = 'Save Recording',
        event = 'ox_context:saveclip'
      },
      {
        title = ' 🗑  Delete Recording', 
        description = 'Delete Recording',
        event = 'ox_context:delclip'
      }
    }
  })

--   Carry Menu
lib.registerContext({
    id = 'carry_menu',
    title = '💪🏼 Carry Menu',
    options = {
      {
        title = '🏋🏼 Carry',
        description = 'Carry Player',
        event = 'CarryPeople:carryip'
      },
      {
        title = '🤸🏼 Piggyback',
        description = 'Carry player on your back',
        event = 'Piggyback:piggybackip'
      }
    }
  })

  lib.registerContext({
    id = 'police_documents_menu',
    title = '📑 Police Documents Menu',
    options = {
      {
        title = '🔫 Weapons Permit',
        description = 'Special gun permit provided by the police.',
        event = 'esx_documents:createnewdocument',
        args = 1
      },
      {
        title = '🚘 Student Driver Permit',
        description = 'Special student driver permit by the police.',
        event = 'esx_documents:createnewdocument',
        args = 2
      },
      {
        title = '👮🏻‍♂️ Police Clearance',
        description = 'Official clean, general purpose, citizen criminal record.',
        event = 'esx_documents:createnewdocument',
        args = 3
      }
    }
  })

  lib.registerContext({
    id = 'ambulance_documents_menu',
    title = '📑 Ambulance Documents Menu',
    options = {
      {
        title = '😷 Medical Report - Phatology',
        description = 'Official medical report provided by a pathologist.',
        event = 'esx_documents:createnewdocument',
        args = 1
      },
      {
        title = '😀 Medical Report - Psychology',
        description = 'Official medical report provided by a psychologist.',
        event = 'esx_documents:createnewdocument',
        args = 2
      },
      {
        title = '🤓 Medical Report - Eye Specialist',
        description = 'Official medical report provided by an eye specialist.',
        event = 'esx_documents:createnewdocument',
        args = 3
      }
    }
  })

  -- RegisterCommand('testcontext', function()
  --   lib.showContext('citizen_menu')
  -- end)