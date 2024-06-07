-- scripts.lua

-- Fonction pour afficher les coordonnées
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if displayCoords then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            DrawTxt(string.format("X: %.2f, Y: %.2f, Z: %.2f, H: %.2f", coords.x, coords.y, coords.z, heading), 0.5, 0.01)
        end
    end
end)

-- Fonction pour afficher les ID des entités
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if displayEntityIDs then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            for entity in EnumerateEntities() do
                local entityCoords = GetEntityCoords(entity)
                local distance = #(coords - entityCoords)
                if distance < 10.0 then
                    DrawTxt(string.format("ID: %d", NetworkGetNetworkIdFromEntity(entity)), entityCoords.x, entityCoords.y, entityCoords.z)
                end
            end
        end
    end
end)

-- Fonction pour gérer les logs en temps réel
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showLogs then
            -- Code pour afficher les logs en temps réel (à implémenter selon ton système de logs)
        end
    end
end)

-- Fonction pour activer/désactiver les collisions
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if noCollision then
            SetEntityCollision(PlayerPedId(), false, false)
        else
            SetEntityCollision(PlayerPedId(), true, true)
        end
    end
end)
