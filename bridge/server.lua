-- Check if the 'es_extended' resource is started
if Framework == 'esx' then
    print('^2es_extended Recognized.^7')
    
    -- Get the shared object from the 'es_extended' resource
    ESX = exports[Config.CoreNames.ESX]:getSharedObject()

elseif Framework == 'qb' then
    print('^2qb-core Recognized.^7')
    
    -- Get the core object from the qb-core resource
    QBCore = exports[Config.CoreNames.QBCore]:GetCoreObject()

else
    print('^1No supported framework detected. Ensure either es_extended or qb-core is running.^7')
    return
end

-- GetPlayer: Returns the player object for a given player source
GetPlayer = function(source)
    if Framework == 'esx' then
        return ESX.GetPlayerFromId(source)
    elseif Framework == 'qb' then
        print('Player', source)
        return QBCore.Functions.GetPlayer(source)
    end
end

-- Define a function to get the (citizen) ID of a player
GetIdentifier = function(source, identifierType)
    local player = GetPlayer(source)
    if player then
        if Framework == 'esx' then
            return player.identifier
        elseif Framework == 'qb' then
            return player.PlayerData.citizenid
        end
    end
end

-- Define a function to add an item to a player's inventory
AddItem = function(source, item, count, slot, metadata)
    local player = GetPlayer(source)

    if invState == 'started' then
        -- Call the 'AddItem' function from the 'ox_inventory' resource if it is started
        return exports[Config.InvName.OX]:AddItem(source, item, count, metadata, slot)
    else
        -- Check which framework is in use
        if Framework == 'esx' then
            -- Call the 'addInventoryItem' functiAon from the 'es_extended' resource if 'ox_inventory' is not started
            return player.addInventoryItem(item, count, metadata, slot)
        elseif Framework == 'qb' then
            -- Standard AddItem if 'ox_inventory' isn't started
            player.Functions.AddItem(item, count, slot, metadata)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'add', count)
        end
    end
end

-- Define a function to remove an item from a player's inventory
RemoveItem = function(source, item, count, slot, metadata)
    local player = GetPlayer(source)

    if invState == 'started' then
        -- Call the 'RemoveItem' function from the 'ox_inventory' resource if it is started
        return exports[Config.InvName.OX]:RemoveItem(source, item, count, metadata, slot)
    else
        -- Check which framework is in use
        if Framework == 'esx' then
            -- Call the 'removeInventoryItem' function from the 'es_extended' resource if 'ox_inventory' is not started
            return player.removeInventoryItem(item, count, metadata, slot)
        elseif Framework == 'qb' then
            -- Standard RemoveItem if 'ox_inventory' isn't started
            player.Functions.RemoveItem(item, count, slot, metadata)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove", count)
        end
    end
end

-- Define a function to convert MoneyType to framework specific variant if needed
ConvertMoneyType = function(moneyType)
    if moneyType == 'money' and Framework == 'qb' then
        moneyType = 'cash'
    elseif moneyType == 'cash' and Framework == 'esx' then
        moneyType = 'money'
    end

    return moneyType
end

-- Define a function to add money to a player's account
AddMoney = function(source, moneyType, amount)

    local player = GetPlayer(source)
    moneyType = ConvertMoneyType(moneyType)
    
    if player then
        if Framework == 'esx' then
            player.addAccountMoney(moneyType, amount)
        elseif Framework == 'qb' then
            player.Functions.AddMoney(moneyType, amount)
        end
    end
end

