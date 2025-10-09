--[[
    NoReticle Script
    Made by JGN Development Team for JRP Server
    Optimized with latest FiveM natives
]]

local hasReticleBypass = false
local playerPed = PlayerPedId()

-- Update player ped cache when it changes
CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        Wait(5000) -- Update every 5 seconds (optimized)
    end
end)

-- Request reticle bypass status from server
RegisterNetEvent('noreticle:setBypass', function(status)
    hasReticleBypass = status
    if status then
        print('^2[JRP NoReticle]^7 Reticle bypass enabled.')
    else
        print('^1[JRP NoReticle]^7 Reticle disabled.')
    end
end)

-- Check bypass status on resource start
CreateThread(function()
    Wait(1000)
    TriggerServerEvent('noreticle:checkPermission')
end)

-- Optimized main thread to hide reticle
CreateThread(function()
    while true do
        if not hasReticleBypass then
            local sleep = 0
            
            -- Hide HUD components for reticle (more efficient method)
            HideHudComponentThisFrame(14) -- Weapon Icon
            HideHudComponentThisFrame(19) -- Weapon Wheel Stats
            
            -- Check if player is armed and hide reticle
            if IsPedArmed(playerPed, 7) then
                -- Use native to disable reticle efficiently
                SetPedConfigFlag(playerPed, 78, true) -- Disable reticle flag
                DisplaySniperScopeThisFrame()
            end
            
            Wait(sleep)
        else
            Wait(500) -- Sleep longer when bypass is active (optimization)
        end
    end
end)

-- Command to check bypass status
RegisterCommand('checkreticle', function()
    if hasReticleBypass then
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"JRP NoReticle", "You have reticle bypass enabled."}
        })
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"JRP NoReticle", "Reticle is currently disabled."}
        })
    end
end, false)
