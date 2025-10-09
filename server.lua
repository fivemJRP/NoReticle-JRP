--[[
    NoReticle Script - Server Side
    Made by JGN Development Team for JRP Server
    ACE Permission: noreticle.bypass
]]

-- Cache for player permissions (optimization)
local playerBypassCache = {}

-- Function to check and set bypass permission
local function CheckPlayerBypass(playerId)
    local hasPermission = IsPlayerAceAllowed(playerId, 'noreticle.bypass')
    playerBypassCache[playerId] = hasPermission
    TriggerClientEvent('noreticle:setBypass', playerId, hasPermission)
    
    if hasPermission then
        print(string.format('^2[JRP NoReticle]^7 Player %s [%d] has reticle bypass enabled.', GetPlayerName(playerId), playerId))
    else
        print(string.format('^1[JRP NoReticle]^7 Player %s [%d] reticle disabled.', GetPlayerName(playerId), playerId))
    end
    
    return hasPermission
end

-- Handle permission check from client
RegisterNetEvent('noreticle:checkPermission', function()
    local src = source
    if not src or src == 0 then return end
    
    CheckPlayerBypass(src)
end)

-- Handle player joining (optimized)
AddEventHandler('playerJoining', function()
    local src = source
    
    -- Small delay to ensure player is fully loaded
    CreateThread(function()
        Wait(2000)
        if GetPlayerName(src) then
            CheckPlayerBypass(src)
        end
    end)
end)

-- Clear cache when player drops
AddEventHandler('playerDropped', function()
    local src = source
    if playerBypassCache[src] then
        playerBypassCache[src] = nil
        print(string.format('^3[JRP NoReticle]^7 Cleared cache for player %d', src))
    end
end)

-- Refresh command for admins to update permissions (optimized)
RegisterCommand('refreshreticle', function(source, args)
    if source == 0 then
        -- Console command
        local count = 0
        for _, playerId in ipairs(GetPlayers()) do
            local id = tonumber(playerId)
            if id then
                CheckPlayerBypass(id)
                count = count + 1
            end
        end
        print(string.format('^2[JRP NoReticle]^7 Refreshed reticle permissions for %d players.', count))
    else
        -- Player command (requires admin permission)
        if IsPlayerAceAllowed(source, 'command.refreshreticle') then
            local count = 0
            for _, playerId in ipairs(GetPlayers()) do
                local id = tonumber(playerId)
                if id then
                    CheckPlayerBypass(id)
                    count = count + 1
                end
            end
            TriggerClientEvent('chat:addMessage', source, {
                color = {0, 255, 0},
                multiline = true,
                args = {"JRP NoReticle", string.format("Refreshed permissions for %d players.", count)}
            })
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"JRP NoReticle", "You don't have permission to use this command."}
            })
        end
    end
end, false)

-- Console output on resource start
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print('^2==================================^7')
        print('^2JRP NoReticle Script^7')
        print('^3Made by JGN Development Team^7')
        print('^2==================================^7')
    end
end)
