local zones = {}

-- Create zones
CreateThread(function()
    for zoneId, zoneData in ipairs(Config.Zones) do
        local zone = lib.zones.sphere({
            coords = zoneData.coords,
            radius = zoneData.radius,
            debug = true,
            onEnter = function(self)
                TriggerServerEvent('sd-redzones:server:addLoadout', zoneId)
            end,
            onExit = function(self)
                TriggerServerEvent('sd-redzones:server:removeLoadout', zoneId)
            end
        })

        -- Blip Creation
        local blip = AddBlipForRadius(zoneData.coords.x, zoneData.coords.y, zoneData.coords.z, zoneData.radius + 450.0)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, 80)

        table.insert(zones, zone)
    end
end)

-- Event to handle player death
RegisterNetEvent('sd-redzones:client:handleDeath', function(nearestPoint)
    local player = PlayerPedId()
    DoScreenFadeOut(1000)
    Wait(1000)

    SetEntityCoords(PlayerPedId(), nearestPoint.x, nearestPoint.y, nearestPoint.z)

    Wait(2500) -- Wait for the player to be teleported

    SetEntityMaxHealth(player, 200)
    SetEntityHealth(player, 200)
    ClearPedBloodDamage(player)
    SetPlayerSprint(PlayerId(), true)

    -- qb-ambulancejob specific events to revive player
    TriggerEvent('hospital:client:Revive')

    DoScreenFadeIn(1000)

end)