local playerLoadouts = {}
local playerZones = {}

-- Function to check if player is in a zone
isPlayerInZone = function(playerId, zoneCoords, radius)
    local playerCoords = GetEntityCoords(GetPlayerPed(playerId))
    local distance = #(playerCoords - zoneCoords)
    return distance <= radius
end

-- Helper function to calculate the nearest point outside the zone's radius
getNearestPointOutsideZone = function(playerCoords, zoneCoords, radius)
    local direction = playerCoords - zoneCoords
    direction = direction / #direction
    local nearestPoint = zoneCoords + direction * (radius + 5.0) 
    return nearestPoint
end

-- Event to give a loadout to a player.
RegisterNetEvent('sd-redzones:server:addLoadout', function(zoneId)
    local src = source
    local zoneData = Config.Zones[zoneId]

    if zoneData and isPlayerInZone(src, zoneData.coords, zoneData.radius) then
        local identifier = GetIdentifier(src)
        playerLoadouts[identifier] = {}
        playerZones[src] = zoneId

        for _, item in ipairs(Config.LoadoutItems) do
            AddItem(src, item, 1)
            table.insert(playerLoadouts[identifier], item)
        end
    end
end)

-- Event to remove a loadout from a player.
RegisterNetEvent('sd-redzones:server:removeLoadout', function(zoneId, playerId)
    local src = playerId or source

    if playerZones[src] == zoneId then
        local identifier = GetIdentifier(src)
        local loadout = playerLoadouts[identifier]

        if loadout then
            for _, item in ipairs(loadout) do
                RemoveItem(src, item, 1)
            end

            playerLoadouts[identifier] = nil
            playerZones[src] = nil
        end
    end
end)

 -- Event to handle a player killing (Rewards etc.)
RegisterNetEvent('baseevents:onPlayerKilled', function(killerId, data)
    local victimId = source
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)

    if killerId and killerId ~= victimId then
        if playerZones[victimId] then
            TriggerEvent('sd-redzones:server:removeLoadout', playerZones[victimId], victimId)

            local rewardAmount = 0
            -- Standard reward calculation
            local minReward = Config.Rewards.Money[1]
            local maxReward = Config.Rewards.Money[2]
            rewardAmount = math.random(minReward, maxReward)

            -- Add reward to player
            AddMoney(killerId, 'cash', rewardAmount)

            print('Rewarding player')
            for zoneId, zoneData in ipairs(Config.Zones) do
                print('Checking zone')
                if isPlayerInZone(victimId, zoneData.coords, zoneData.radius) then
                    print('Player is in zone')
                    local nearestPoint = getNearestPointOutsideZone(playerCoords, zoneData.coords, zoneData.radius)
                    TriggerClientEvent('sd-redzones:client:handleDeath', victimId, nearestPoint)
        
                    break
                end
            end
        end
    end
end)

-- Event to handle player death
RegisterNetEvent('baseevents:onPlayerDied', function()
    local src = source
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    
    for zoneId, zoneData in ipairs(Config.Zones) do
        if isPlayerInZone(src, zoneData.coords, zoneData.radius) then
            local nearestPoint = getNearestPointOutsideZone(playerCoords, zoneData.coords, zoneData.radius)
            TriggerClientEvent('sd-redzones:client:handleDeath', src, nearestPoint)

            break
        end
    end
end)

-- Event to remove loadout in the case of player disconnect
AddEventHandler('playerDropped', function(reason)
    local playerId = source

    if playerZones[playerId] then
        TriggerEvent('sd-redzones:server:removeLoadout', playerZones[playerId], playerId)
    end
end)



