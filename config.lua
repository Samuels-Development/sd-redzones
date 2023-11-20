Config = {}

Config.Zones = {
    {
        coords = vector3(106.75, -1941.19, 20.8), radius = 100.0 -- Grove Street
    },
}

-- Define loadout items
Config.LoadoutItems = { "WEAPON_CARBINERIFLE", "WEAPON_PISTOL", --[[ 'ammo' ]]}

-- Define Items that will be awarded to the player when they enter the zone and kill another player.
Config.Rewards = {
    Money = {100, 500} -- This means the reward will be between 100 and 500
}

-- Names for the Core that'll be used to split ESX/QBCore Logic.
Config.CoreNames = {
    QBCore = 'qb-core', -- Edit, if you've renamed qb-core.
    ESX = 'es_extended', -- Edit, if you've renamed es_extended
}

-- Name that will check for to then use ox_inventory specific exports.
Config.InvName = {
    OX = 'ox_inventory' -- Edit if you've renamed ox_inventory
}

if GetResourceState(Config.CoreNames.QBCore) == 'started' then Framework = 'qb' elseif GetResourceState(Config.CoreNames.ESX) == 'started' then Framework = 'esx' end
invState = GetResourceState(Config.InvName.OX)