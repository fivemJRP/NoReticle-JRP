--[[
    NoReticle Script
    Made by JGN Development Team for JRP Server
    Optimized with latest FiveM natives
    Fix: preserve sniper/marksman scopes while removing normal reticle
]]

local hasReticleBypass = false

-- Scoped weapons list (extend with any addon hashes you use)
local SCOPED_WEAPONS = {
    [`WEAPON_SNIPERRIFLE`] = true,
    [`WEAPON_HEAVYSNIPER`] = true,
    [`WEAPON_HEAVYSNIPER_MK2`] = true,
    [`WEAPON_MARKSMANRIFLE`] = true,
    [`WEAPON_MARKSMANRIFLE_MK2`] = true,
    [`WEAPON_PRECISIONRIFLE`] = true, -- GTAO precision rifle
}

local playerPed = PlayerPedId()

-- Update player ped cache when it changes
CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        Wait(5000) -- Update every 5 seconds (optimized)
    end
end)

local function isScopedWeapon(weaponHash)
    return SCOPED_WEAPONS[weaponHash] == true
end

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

-- Main loop: hide normal reticle, but allow scopes when aiming a scoped weapon
CreateThread(function()
    while true do
        if not hasReticleBypass then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)

            -- Are we in a scoped aim state? (covers 1st-person scope cam and free-aim)
            local aiming = IsPlayerFreeAiming(PlayerId()) or IsAimCamActive() or IsFirstPersonAimCamActive()
            local usingScopedAim = aiming and isScopedWeapon(weapon)

            if not usingScopedAim then
                -- Hide normal HUD bits when not in a sniper/marksman scope
                -- 14 = Weapon Icon/Crosshair cluster; 19 = Weapon Wheel Stats
                HideHudComponentThisFrame(14)
                if IsPedArmed(ped, 6) or IsPedArmed(ped, 7) then
                    HideHudComponentThisFrame(19)
                end
            end

            -- Tight loop so HUD stays hidden reliably
            Wait(0)
        else
            -- Sleep longer when bypass is active
            Wait(500)
        end
    end
end)

-- Optional: lightweight ped cache (not strictly necessary anymore)
CreateThread(function()
    while true do
        -- If you keep other per-5s logic, do it here
        Wait(5000)
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
