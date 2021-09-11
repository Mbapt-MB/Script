ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local menu = RageUI.CreateMenu("Location véhicule", "Actions")
menu.Closed = function()
    ESX.ShowNotification("~b~Vous avez fermer le menu~s~") 
end


Citizen.CreateThread(function()
    local distance = GetDistanceBetweenCoords(pos, dest, true)
    local pos = GetEntityCoords(PlayerPedId())
    local ped 
    local coord
    local dest = vector3(-511.80, -256.39, 35.61)
    local blip = AddBlipForCoord(dest)
    SetBlipColour(blip , 59)
    SetBlipSprite(blip , 77 )
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Location de véhicule")
    EndTextCommandSetBlipName(blip)

    while true do
        local interval = 1
        local pos  = GetEntityCoords(PlayerPedId())
        local dest = vector3(-511.80, -256.39, 35.61)
        local distance = GetDistanceBetweenCoords(pos, dest, true)

        if distance > 30 then
            interval = 200
        else
            interval = 1
            DrawMarker(22, -511.80, -256.39, 35.61 +1.3 ,0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 252, 186, 3, 255, 55555, false, true, 2, false, false, false, false)
            if distance < 1 then
                AddTextEntry("HELP", "Appuyer sur ~INPUT_CONTEXT~ pour acceder a cette zone")
                DisplayHelpTextThisFrame("Help", false)
                if IsControlJustPressed(1, 51) then
                    RageUI.Visible(menu, true) 
                end

            end
        end

        Citizen.Wait(interval)
    end 
end)

Citizen.CreateThread(function()
    local hash = GetHashKey("a_f_m_beach_01")
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", "a_f_m_beach_01", -511.80, -256.39, 34.61, 0.0, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    Wait(20)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
end)

Citizen.CreateThread(function()
    --creationvehicule("sultan")
    while true do

        RageUI.IsVisible(menu,function()
            
            RageUI.Button("~g~✔Panto $2000", "Ce bouton fait apparaitre une voiture", {RightBadge = RageUI.BadgeStyle.Car}, true, {
                onSelected = function()
                    
                    ESX.TriggerServerCallback("location:pay", function(able) --able = capable                             
                        if not able then
                            ESX.ShowNotification("~r~Vous n'avez pas l'argent necessaire~s~") 
                        else
                            creationvehicule("panto", function(vehicle)
                                print("Affichage du véhicule après appel :")
                                print(vehicle)
                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)  
                                RageUI.CloseAll()
                                ESX.ShowNotification("~b~Votre véhicule a bien etait livre, bonne route~s~") 
                            end)
                        end
                    end, 2000)
                end
            } )
            RageUI.Button("~g~✔Fagio$1000", "Ce bouton fait apparaitre une voiture", {RightBadge = RageUI.BadgeStyle.Car}, true, {
                onSelected = function()
                    
                    ESX.TriggerServerCallback("location:pay", function(able) --able = capable                             
                        if not able then
                            ESX.ShowNotification("~r~Vous n'avez pas l'argent necessaire~s~") 
                        else
                            creationvehicule("sultan", function(vehicle)
                                print("Affichage du véhicule après appel :")
                                print(vehicle)
                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)  
                                RageUI.CloseAll()
                                ESX.ShowNotification("~b~Votre véhicule a bien etait livre, bonne route~s~") 
                            end)
                        end
                    end, 1000)
                end
            } )

        end)

        Citizen.Wait(0)
    end
    
end)

function creationvehicule(vehicle, callback)

    Citizen.CreateThread(function()
        modelHash = GetHashKey(vehicle)

        if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
            
            RequestModel(modelHash)

            while not HasModelLoaded(modelHash) do
                Citizen.Wait(1)
            end
        end

        local coords = vector3(-511.80, -256.39, 35.61)
        local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, 208.25, true, false)
        local networkId = NetworkGetNetworkIdFromEntity(vehicle)
        local timeout = 0

        SetNetworkIdCanMigrate(networkId, true)
        SetEntityAsMissionEntity(vehicle, true, false)
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetVehRadioStation(vehicle, 'OFF')
        SetModelAsNoLongerNeeded(model)
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)

        while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
            Citizen.Wait(0)
            timeout = timeout + 1
        end
        
        if callback then
            callback(vehicle)
        end
    end)
end
