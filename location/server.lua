ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("location:pay"	,function(source, cb, price)

    xPlayer = ESX.GetPlayerFromId(source)   -- Récupération des fonctions du joueur
    local money = xPlayer.getMoney()        -- Récupération de l'argent du joueur
    
    if money < price then                    -- On vérifie que l'argent est bien dessous
        cb(false)                           -- On renvoi vers le client false pour refuser l'accès
    else                                    -- Dans le cas contraire
        xPlayer.removeMoney(price)           -- On retire la money du joueur
        cb(true)                            -- On renvoi vers le client true pour autoriser l'accès
    end
end)
