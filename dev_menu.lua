-- dev_menu.lua

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Devkit", "By Astrxw")
_menuPool:Add(mainMenu)

-- Variables pour gérer l'affichage
local displayCoords = false
local displayEntityIDs = false
local isMenuOpen = false
local isPlacingProp = false
local isDeletingProp = false
local currentProp = nil

local props = {
    {label = "Banc", model = "prop_bench_01a"},
    {label = "Chaise", model = "prop_chair_02"},
    {label = "Table", model = "prop_table_03"},
    {label = "Poubelle", model = "prop_bin_05a"},
    {label = "Lampadaire", model = "prop_streetlight_01"},
    {label = "Borne incendie", model = "prop_fire_hydrant_2"},
    {label = "Vélo", model = "prop_bicycle_01"},
    {label = "Panneau stop", model = "prop_sign_road_01a"},
    {label = "Arbre", model = "prop_tree_birch_01"},
    {label = "Buisson", model = "prop_bush_01a"},
    {label = "Boîte aux lettres", model = "prop_mailbox_01a"},
    {label = "Cône de signalisation", model = "prop_roadcone02a"},
    {label = "Grille-pain", model = "prop_toaster_01"},
    {label = "Micro-ondes", model = "prop_micro_01"},
    {label = "Frigo", model = "prop_fridge_01"},
    {label = "Machine à café", model = "prop_coffee_mac_02"},
    {label = "Bouteille d'eau", model = "prop_ld_flow_bottle"},
    {label = "Caisse", model = "prop_box_wood05a"},
    {label = "Télévision", model = "prop_tv_03"},
    {label = "Ordinateur portable", model = "prop_laptop_01a"},
    {label = "Sac de sport", model = "prop_duffel_bag_01"},
    {label = "Barbecue", model = "prop_bbq_5"},
    {label = "Piano", model = "prop_piano_01"},
    {label = "Statue", model = "prop_statue_01"},
    {label = "Fusée de feu d'artifice", model = "prop_firework_03"},
    {label = "Générateur", model = "prop_generator_01a"},
    {label = "Caisse en bois", model = "prop_box_wood02a"},
    {label = "Palette", model = "prop_pallet_02a"},
    {label = "Jardinière", model = "prop_fountain2"},
    {label = "Horloge", model = "prop_big_clock_01"},
    {label = "Lit", model = "prop_bed_02"},
    {label = "Canapé", model = "prop_couch_01"},
    {label = "Étagère", model = "prop_bookshelf_02"},
    {label = "Coffre-fort", model = "prop_ld_int_safe_01"},
    {label = "Comptoir", model = "prop_till_01"},
    {label = "Barrière", model = "prop_barrier_work06a"},
    {label = "Chariot de supermarché", model = "prop_cs_shopping_bag"},
    {label = "Caméra de surveillance", model = "prop_cctv_pole_01a"},
    {label = "Climatiseur", model = "prop_aircon_m_01"},
    {label = "Rouleau compresseur", model = "prop_cs_rub_binbag_01"},
    {label = "Sculpture de glace", model = "prop_ice_cube_01"},
    {label = "Borne d'incendie", model = "prop_fire_hydrant_1"},
    {label = "Tuyau d'arrosage", model = "prop_hose_2"},
    {label = "Caisse en plastique", model = "prop_bin_01a"},
    {label = "Conteneur", model = "prop_container_01a"},
    {label = "Clôture en bois", model = "prop_fncwood_16e"},
    {label = "Tente de camping", model = "prop_skid_tent_01"},
    {label = "Tronc d'arbre", model = "prop_tree_log_01"},
    {label = "Lanterne", model = "prop_lantern_03"},
    {label = "Feu de camp", model = "prop_campfire_01"},
    {label = "Banc de parc", model = "prop_park_bench_01"},
}
local playerName = GetPlayerName(PlayerId())
local playerId = GetPlayerServerId(PlayerId())

local headerItem = NativeUI.CreateItem("Nom : " .. playerName .. " | ID : " .. playerId, "")
headerItem:Enabled(false)
mainMenu:AddItem(headerItem)

function ResetCursorLocation()
    SetCursorLocation(0.5, 0.5)
end
function DrawMenuHeaderText(text, x, y)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end


-- Fonction pour dessiner du texte à l'écran en rouge en haut à gauche
function DrawCoords()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    local text = string.format("X: %.2f, Y: %.2f, Z: %.2f, H: %.2f", coords.x, coords.y, coords.z, heading)

    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.4, 0.4)
    SetTextColour(255, 0, 0, 255) -- Couleur rouge
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.015, 0.015) -- Position en haut à gauche
end

-- Fonction pour afficher les ID des entités proches au-dessus de chaque entité
function DrawEntityIDs()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local function DrawText3D(x, y, z, text)
        local onScreen, _x, _y = World3dToScreen2d(x, y, z)
        if onScreen then
            SetTextScale(0.35, 0.35)
            SetTextFont(4)
            SetTextProportional(1)
            SetTextColour(255, 0, 0, 255)
            SetTextEntry("STRING")
            SetTextCentre(1)
            AddTextComponentString(text)
            DrawText(_x, _y)
            local factor = (string.len(text)) / 370
            DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 150)
        end
    end

    for _, entity in ipairs(GetGamePool('CObject')) do
        local entityCoords = GetEntityCoords(entity)
        if #(playerCoords - entityCoords) < 5.0 then
            if NetworkGetEntityIsNetworked(entity) then -- Vérifier si l'entité est réseau
                local entityID = NetworkGetNetworkIdFromEntity(entity)
                if entityID ~= 0 then -- Vérifier que l'entité a un réseau ID
                    DrawText3D(entityCoords.x, entityCoords.y, entityCoords.z + 1.0, tostring(entityID))
                end
            end
        end
    end

    for _, entity in ipairs(GetGamePool('CVehicle')) do
        local entityCoords = GetEntityCoords(entity)
        if #(playerCoords - entityCoords) < 5.0 then
            if NetworkGetEntityIsNetworked(entity) then -- Vérifier si l'entité est réseau
                local entityID = NetworkGetNetworkIdFromEntity(entity)
                if entityID ~= 0 then -- Vérifier que l'entité a un réseau ID
                    DrawText3D(entityCoords.x, entityCoords.y, entityCoords.z + 1.0, tostring(entityID))
                end
            end
        end
    end

    for _, entity in ipairs(GetGamePool('CPed')) do
        local entityCoords = GetEntityCoords(entity)
        if #(playerCoords - entityCoords) < 5.0 then
            if NetworkGetEntityIsNetworked(entity) then -- Vérifier si l'entité est réseau
                local entityID = NetworkGetNetworkIdFromEntity(entity)
                if entityID ~= 0 then -- Vérifier que l'entité a un réseau ID
                    DrawText3D(entityCoords.x, entityCoords.y, entityCoords.z + 1.0, tostring(entityID))
                end
            end
        end
    end
end

-- Fonction pour dessiner du texte à l'écran
function DrawTxt(text, x, y)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.4, 0.4)
    SetTextColour(255, 0, 0, 255) -- Couleur rouge
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function AddMenuDebugOptions(menu)
    local coordsItem = NativeUI.CreateCheckboxItem("Afficher les coordonnées", displayCoords, "Afficher les coordonnées X, Y, Z et l'orientation du joueur.")
    menu:AddItem(coordsItem)
    coordsItem.CheckboxEvent = function(sender, item, checked)
        if item == coordsItem then
            displayCoords = checked
            ShowNotification("~r~Coordonnées affichées: ~b~" .. tostring(displayCoords))
        end
    end

    local entityIDsItem = NativeUI.CreateCheckboxItem("Afficher les ID des entités", displayEntityIDs, "Voir les ID des entités proches (joueurs, véhicules, objets).")
    menu:AddItem(entityIDsItem)
    entityIDsItem.CheckboxEvent = function(sender, item, checked)
        if item == entityIDsItem then
            displayEntityIDs = checked
            ShowNotification("~r~ID des entités affichés: ~b~" .. tostring(displayEntityIDs))
        end
    end
end

function AddTimeMenu(menu)
    local timeMenu = _menuPool:AddSubMenu(menu, "Temps", "Modifier le temps et la météo")

    timeMenu.OnMenuClosed = function(menu)
        ResetCursorLocation()
    end

    local morning = NativeUI.CreateItem("Matin", "Définir le temps sur le matin.")
    timeMenu:AddItem(morning)
    morning.Activated = function(sender, item)
        if item == morning then
            ExecuteCommand("time 9 0 0")
            ShowNotification("~g~Le temps a été défini sur le matin.")
        end
    end

    local afternoon = NativeUI.CreateItem("Après-midi", "Définir le temps sur l'après-midi.")
    timeMenu:AddItem(afternoon)
    afternoon.Activated = function(sender, item)
        if item == afternoon then
            ExecuteCommand("time 14 0 0")
            ShowNotification("~g~Le temps a été défini sur l'après-midi.")
        end
    end

    local evening = NativeUI.CreateItem("Soir", "Définir le temps sur le soir.")
    timeMenu:AddItem(evening)
    evening.Activated = function(sender, item)
        if item == evening then
            ExecuteCommand("time 19 0 0")
            ShowNotification("~g~Le temps a été défini sur le soir.")
        end
    end

    local night = NativeUI.CreateItem("Nuit", "Définir le temps sur la nuit.")
    timeMenu:AddItem(night)
    night.Activated = function(sender, item)
        if item == night then
            ExecuteCommand("time 23 0 0")
            ShowNotification("~g~Le temps a été défini sur la nuit.")
        end
    end

    local clear = NativeUI.CreateItem("Dégagé", "Définir la météo sur dégagé.")
    timeMenu:AddItem(clear)
    clear.Activated = function(sender, item)
        if item == clear then
            ExecuteCommand("weather clear")
            ShowNotification("~g~La météo a été définie sur dégagé.")
        end
    end

    local rain = NativeUI.CreateItem("Pluie", "Définir la météo sur pluie.")
    timeMenu:AddItem(rain)
    rain.Activated = function(sender, item)
        if item == rain then
            ExecuteCommand("weather rain")
            ShowNotification("~g~La météo a été définie sur pluie.")
        end
    end

    local thunder = NativeUI.CreateItem("Orage", "Définir la météo sur orage.")
    timeMenu:AddItem(thunder)
    thunder.Activated = function(sender, item)
        if item == thunder then
            ExecuteCommand("weather thunder")
            ShowNotification("~g~La météo a été définie sur orage.")
        end
    end

    local foggy = NativeUI.CreateItem("Brumeux", "Définir la météo sur brumeux.")
    timeMenu:AddItem(foggy)
    foggy.Activated = function(sender, item)
        if item == foggy then
            ExecuteCommand("weather foggy")
            ShowNotification("~g~La météo a été définie sur brumeux.")
        end
    end
end


function AddBlipsBuilderMenu(menu)
    local blipsMenu = _menuPool:AddSubMenu(menu, "Blips Builder", "Créer et gérer des blips")

    blipsMenu.OnMenuClosed = function(menu)
        ResetCursorLocation()
    end

    local blips = {}

    local blipName = "Blip"
    local blipType = 1
    local blipSize = 1.0
    local blipColor = 1
    local blipDisplay = 4
    local blipShortRange = true
    local saveToDB = false

    local nameItem = NativeUI.CreateItem("Nom du Blip", "Définir le nom du blip")
    nameItem:RightLabel(blipName)
    blipsMenu:AddItem(nameItem)
    nameItem.Activated = function(sender, item)
        if item == nameItem then
            AddTextEntry('FMMC_KEY_TIP1', "Entrez le nom du blip :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                blipName = GetOnscreenKeyboardResult()
                nameItem:RightLabel(blipName)
                ShowNotification("Nom du blip défini sur : ~g~" .. blipName)
            end
        end
    end

    local typeItem = NativeUI.CreateItem("Type de Blip", "Définir le type du blip")
    typeItem:RightLabel(tostring(blipType))
    blipsMenu:AddItem(typeItem)
    typeItem.Activated = function(sender, item)
        if item == typeItem then
            AddTextEntry('FMMC_KEY_TIP1', "Entrez le type du blip (numérique) :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                local result = tonumber(GetOnscreenKeyboardResult())
                if result then
                    blipType = result
                    typeItem:RightLabel(tostring(blipType))
                    ShowNotification("Type du blip défini sur : ~g~" .. blipType)
                else
                    ShowNotification("~r~Entrée invalide. Veuillez entrer un nombre.")
                end
            end
        end
    end

    local sizeItem = NativeUI.CreateItem("Taille du Blip", "Définir la taille du blip")
    sizeItem:RightLabel(tostring(blipSize))
    blipsMenu:AddItem(sizeItem)
    sizeItem.Activated = function(sender, item)
        if item == sizeItem then
            AddTextEntry('FMMC_KEY_TIP1', "Entrez la taille du blip (numérique) :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                local result = tonumber(GetOnscreenKeyboardResult())
                if result then
                    blipSize = result
                    sizeItem:RightLabel(tostring(blipSize))
                    ShowNotification("Taille du blip définie sur : ~g~" .. blipSize)
                else
                    ShowNotification("~r~Entrée invalide. Veuillez entrer un nombre.")
                end
            end
        end
    end

    local colorItem = NativeUI.CreateItem("Couleur du Blip", "Définir la couleur du blip")
    colorItem:RightLabel(tostring(blipColor))
    blipsMenu:AddItem(colorItem)
    colorItem.Activated = function(sender, item)
        if item == colorItem then
            AddTextEntry('FMMC_KEY_TIP1', "Entrez la couleur du blip (numérique) :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                local result = tonumber(GetOnscreenKeyboardResult())
                if result then
                    blipColor = result
                    colorItem:RightLabel(tostring(blipColor))
                    ShowNotification("Couleur du blip définie sur : ~g~" .. blipColor)
                else
                    ShowNotification("~r~Entrée invalide. Veuillez entrer un nombre.")
                end
            end
        end
    end

    local displayItem = NativeUI.CreateItem("Affichage du Blip", "Définir l'affichage du blip")
    displayItem:RightLabel(tostring(blipDisplay))
    blipsMenu:AddItem(displayItem)
    displayItem.Activated = function(sender, item)
        if item == displayItem then
            AddTextEntry('FMMC_KEY_TIP1', "Entrez l'affichage du blip (numérique) :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                local result = tonumber(GetOnscreenKeyboardResult())
                if result then
                    blipDisplay = result
                    displayItem:RightLabel(tostring(blipDisplay))
                    ShowNotification("Affichage du blip défini sur : ~g~" .. blipDisplay)
                else
                    ShowNotification("~r~Entrée invalide. Veuillez entrer un nombre.")
                end
            end
        end
    end

    local shortRangeItem = NativeUI.CreateCheckboxItem("Visibilité de proximité", blipShortRange, "Définir si le blip est visible uniquement de près")
    blipsMenu:AddItem(shortRangeItem)
    shortRangeItem.CheckboxEvent = function(sender, item, checked)
        if item == shortRangeItem then
            blipShortRange = checked
            ShowNotification("Visibilité de proximité : ~g~" .. tostring(blipShortRange))
        end
    end

    local saveItem = NativeUI.CreateCheckboxItem("Enregistrer dans la BDD", saveToDB, "Enregistrer ce blip dans la base de données")
    blipsMenu:AddItem(saveItem)
    saveItem.CheckboxEvent = function(sender, item, checked)
        if item == saveItem then
            saveToDB = checked
            ShowNotification("Enregistrement dans la BDD : ~g~" .. tostring(saveToDB))
        end
    end

    local addBlipItem = NativeUI.CreateItem("Ajouter un blip", "Ajouter un nouveau blip sur la carte à votre position actuelle")
    blipsMenu:AddItem(addBlipItem)
    addBlipItem.Activated = function(sender, item)
        if item == addBlipItem then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local blip = AddBlipForCoord(playerCoords.x, playerCoords.y, playerCoords.z)
            SetBlipSprite(blip, blipType)
            SetBlipDisplay(blip, blipDisplay)
            SetBlipScale(blip, blipSize)
            SetBlipColour(blip, blipColor)
            SetBlipAsShortRange(blip, blipShortRange)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipName)
            EndTextCommandSetBlipName(blip)
            table.insert(blips, blip)
            ShowNotification("~g~Blip ajouté à votre position.")

            if saveToDB then
                TriggerServerEvent('saveBlipToDB', blipName, blipType, blipSize, blipColor, blipDisplay, blipShortRange, playerCoords.x, playerCoords.y, playerCoords.z)
                ShowNotification("~g~Blip enregistré dans la base de données.")
            end
        end
    end

    local deleteBlipsItem = NativeUI.CreateItem("Supprimer tous les blips", "Supprimer tous les blips créés")
    blipsMenu:AddItem(deleteBlipsItem)
    deleteBlipsItem.Activated = function(sender, item)
        if item == deleteBlipsItem then
            for _, blip in ipairs(blips) do
                RemoveBlip(blip)
            end
            blips = {}
            ShowNotification("~r~Tous les blips ont été supprimés.")
        end
    end
end



function AddPropsBuilderMenu(menu)
    local propsMenu = _menuPool:AddSubMenu(menu, "Props Builder", "Gérer et créer des props.")

    propsMenu.OnMenuClosed = function(menu)
        ResetCursorLocation()
    end

    -- Ajouter un item pour le mode suppression
    local deletePropItem = NativeUI.CreateItem("Mode Suppression de Props", "Supprimez les props existants")
    deletePropItem:SetLeftBadge(BadgeStyle.Alert)  -- Utiliser un badge d'alerte à gauche pour indiquer la suppression
    propsMenu:AddItem(deletePropItem)
    
    deletePropItem.Activated = function(sender, item)
        if item == deletePropItem then
            isDeletingProp = not isDeletingProp
            if isDeletingProp then
                ShowNotification("~r~Mode suppression activé. Sélectionnez un prop et appuyez sur E pour le supprimer.")
            else
                ShowNotification("~g~Mode suppression désactivé.")
            end
            propsMenu:Visible(false)
            mainMenu:Visible(false)
            SetNuiFocus(false, false)
        end
    end

    for _, prop in ipairs(props) do
        local propItem = NativeUI.CreateItem(prop.label, "Spawn " .. prop.label)
        propsMenu:AddItem(propItem)
        propItem.Activated = function(sender, item)
            if item == propItem then
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local propHash = GetHashKey(prop.model)

                RequestModel(propHash)
                while not HasModelLoaded(propHash) do
                    Citizen.Wait(1)
                end

                currentProp = CreateObject(propHash, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
                SetEntityAlpha(currentProp, 150, false) -- Rendre l'objet semi-transparent
                PlaceObjectOnGroundProperly(currentProp)
                SetModelAsNoLongerNeeded(propHash)

                isPlacingProp = true
                ShowNotification("~g~" .. prop.label .. " en mode placement. Appuyez sur ~b~E~g~ pour placer.")

                -- Fermer le menu
                propsMenu:Visible(false)
                mainMenu:Visible(false)
                SetNuiFocus(false, false)

                -- Réinitialiser le curseur
                ResetCursorLocation()

                -- Afficher les notifications de contrôle
                ShowNotification("Utilisez les flèches pour déplacer et les touches 4 et 6 pour tourner le prop :\nFlèche gauche - Gauche\nFlèche droite - Droite\nFlèche haut - Avant\nFlèche bas - Arrière\nNum 8 - Monter\nNum 5 - Descendre\n4 - Rotation gauche\n6 - Rotation droite")
            end
        end
    end
end

-- Ajout de la fonction AddVehicleManagementMenu avec réinitialisation du curseur et options supplémentaires

function AddVehicleManagementMenu(menu)
    local vehicleMenu = _menuPool:AddSubMenu(menu, "Gestion de Véhicule", "Options pour gérer les véhicules")

    vehicleMenu.OnMenuClosed = function(menu)
        ResetCursorLocation()
    end

    -- Réparation et nettoyage
    local repairVehicle = NativeUI.CreateItem("Réparer le véhicule", "Répare le véhicule actuel")
    vehicleMenu:AddItem(repairVehicle)
    repairVehicle.Activated = function(sender, item)
        if item == repairVehicle then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle then
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                ShowNotification("~g~Véhicule réparé.")
            else
                ShowNotification("~r~Vous n'êtes pas dans un véhicule.")
            end
        end
    end

    local cleanVehicle = NativeUI.CreateItem("Nettoyer le véhicule", "Nettoie le véhicule actuel")
    vehicleMenu:AddItem(cleanVehicle)
    cleanVehicle.Activated = function(sender, item)
        if item == cleanVehicle then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle then
                SetVehicleDirtLevel(vehicle, 0)
                ShowNotification("~g~Véhicule nettoyé.")
            else
                ShowNotification("~r~Vous n'êtes pas dans un véhicule.")
            end
        end
    end

    local deleteVehicle = NativeUI.CreateItem("Supprimer le véhicule", "Supprime le véhicule actuel")
    vehicleMenu:AddItem(deleteVehicle)
    deleteVehicle.Activated = function(sender, item)
        if item == deleteVehicle then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle then
                SetEntityAsMissionEntity(vehicle, true, true)
                DeleteVehicle(vehicle)
                ShowNotification("~r~Véhicule supprimé.")
            else
                ShowNotification("~r~Vous n'êtes pas dans un véhicule.")
            end
        end
    end

    vehicleMenu:AddItem(NativeUI.CreateItem("---------", "")) -- Séparateur

    -- Spawner et Téléportation
    local spawnVehicle = NativeUI.CreateItem("Spawner un véhicule", "Spawner un véhicule par modèle")
    vehicleMenu:AddItem(spawnVehicle)
    spawnVehicle.Activated = function(sender, item)
        if item == spawnVehicle then
            AddTextEntry('FMMC_KEY_TIP1', "Entrez le nom du modèle de véhicule :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                local modelName = GetOnscreenKeyboardResult()
                if IsModelInCdimage(modelName) and IsModelAVehicle(modelName) then
                    RequestModel(modelName)
                    while not HasModelLoaded(modelName) do
                        Citizen.Wait(0)
                    end
                    local playerPed = PlayerPedId()
                    local coords = GetEntityCoords(playerPed)
                    local vehicle = CreateVehicle(modelName, coords.x, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
                    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                    SetModelAsNoLongerNeeded(modelName)
                    ShowNotification("~g~Véhicule spawné : " .. modelName)
                else
                    ShowNotification("~r~Modèle de véhicule invalide.")
                end
            end
        end
    end

    local teleportItem = NativeUI.CreateItem("Téléporter le véhicule", "Téléporter le véhicule à une position spécifique")
    vehicleMenu:AddItem(teleportItem)
    teleportItem.Activated = function(sender, item)
        if item == teleportItem then
            AddTextEntry('FMMC_KEY_TIP1', "Entrez les coordonnées X :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 10)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            local x = tonumber(GetOnscreenKeyboardResult())

            AddTextEntry('FMMC_KEY_TIP2', "Entrez les coordonnées Y :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP2", "", "", "", "", "", 10)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            local y = tonumber(GetOnscreenKeyboardResult())

            AddTextEntry('FMMC_KEY_TIP3', "Entrez les coordonnées Z :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP3", "", "", "", "", "", 10)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            local z = tonumber(GetOnscreenKeyboardResult())

            if x and y and z then
                local playerPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                if vehicle then
                    SetEntityCoords(vehicle, x, y, z, false, false, false, true)
                    ShowNotification("~g~Véhicule téléporté.")
                else
                    ShowNotification("~r~Vous n'êtes pas dans un véhicule.")
                end
            else
                ShowNotification("~r~Entrée invalide.")
            end
        end
    end

    vehicleMenu:AddItem(NativeUI.CreateItem("---------", "")) -- Séparateur

    -- Modifications et Améliorations
    local maxSpeedItem = NativeUI.CreateItem("Changer la vitesse maximale", "Définir une nouvelle vitesse maximale pour le véhicule actuel")
    vehicleMenu:AddItem(maxSpeedItem)
    maxSpeedItem.Activated = function(sender, item)
        if item == maxSpeedItem then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle then
                AddTextEntry('FMMC_KEY_TIP1', "Entrez la nouvelle vitesse maximale (en m/s) :")
                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 10)
                while UpdateOnscreenKeyboard() == 0 do
                    Citizen.Wait(0)
                end
                local maxSpeed = tonumber(GetOnscreenKeyboardResult())
                if maxSpeed then
                    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel', maxSpeed)
                    ShowNotification("~g~Vitesse maximale définie à : " .. maxSpeed .. " m/s")
                else
                    ShowNotification("~r~Entrée invalide.")
                end
            else
                ShowNotification("~r~Vous n'êtes pas dans un véhicule.")
            end
        end
    end

    local invincibilityItem = NativeUI.CreateCheckboxItem("Invincibilité du véhicule", false, "Activer/Désactiver l'invincibilité du véhicule")
    vehicleMenu:AddItem(invincibilityItem)
    invincibilityItem.CheckboxEvent = function(sender, item, checked)
        if item == invincibilityItem then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle then
                SetEntityInvincible(vehicle, checked)
                SetVehicleCanBeVisiblyDamaged(vehicle, not checked)
                ShowNotification("~g~Invincibilité du véhicule : " .. (checked and "Activée" or "Désactivée"))
            else
                ShowNotification("~r~Vous n'êtes pas dans un véhicule.")
            end
        end
    end

    local tuningOptions = {"Moteur", "Freins", "Transmission", "Suspension", "Armure"}
    for i, option in ipairs(tuningOptions) do
        local tuneItem = NativeUI.CreateItem("Améliorer " .. option, "Améliorer le " .. option:lower() .. " du véhicule")
        vehicleMenu:AddItem(tuneItem)
        tuneItem.Activated = function(sender, item)
            if item == tuneItem then
                local playerPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                if vehicle then
                    SetVehicleModKit(vehicle, 0)
                    SetVehicleMod(vehicle, i - 1, GetNumVehicleMods(vehicle, i - 1) - 1, false)
                    ShowNotification("~g~" .. option .. " amélioré.")
                else
                    ShowNotification("~r~Vous n'êtes pas dans un véhicule.")
                end
            end
        end
    end

    local fuelVehicle = NativeUI.CreateItem("Remplir le réservoir", "Remplir le réservoir d'essence du véhicule")
    vehicleMenu:AddItem(fuelVehicle)
    fuelVehicle.Activated = function(sender, item)
        if item == fuelVehicle then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle then
                SetVehicleFuelLevel(vehicle, 100.0)
                ShowNotification("~g~Réservoir rempli.")
            else
                ShowNotification("~r~Vous n'êtes pas dans un véhicule.")
            end
        end
    end

    local tintedWindowsItem = NativeUI.CreateCheckboxItem("Fenêtres teintées", false, "Activer/Désactiver les fenêtres teintées")
    vehicleMenu:AddItem(tintedWindowsItem)
    tintedWindowsItem.CheckboxEvent = function(sender, item, checked)
        if item == tintedWindowsItem then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle then
                if checked then
                    SetVehicleWindowTint(vehicle, 1)
                else
                    SetVehicleWindowTint(vehicle, 0)
                end
                ShowNotification("~g~Fenêtres teintées : " .. (checked and "Activées" or "Désactivées"))
            else
                ShowNotification("~r~Vous n'êtes pas dans un véhicule.")
            end
        end
    end

    local changeEngineSoundItem = NativeUI.CreateItem("Changer le son du moteur", "Changer le son du moteur du véhicule")
    vehicleMenu:AddItem(changeEngineSoundItem)
    changeEngineSoundItem.Activated = function(sender, item)
        if item == changeEngineSoundItem then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle then
                AddTextEntry('FMMC_KEY_TIP1', "Entrez le son du moteur :")
                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20)
                while UpdateOnscreenKeyboard() == 0 do
                    Citizen.Wait(0)
                end
                local engineSound = GetOnscreenKeyboardResult()
                if engineSound then
                    ForceVehicleEngineAudio(vehicle, engineSound)
                    ShowNotification("~g~Son du moteur changé en : " .. engineSound)
                else
                    ShowNotification("~r~Entrée invalide.")
                end
            else
                ShowNotification("~r~Vous n'êtes pas dans un véhicule.")
            end
        end
    end
end

function AddPersonalManagementMenu(menu)
    local personalMenu = _menuPool:AddSubMenu(menu, "Gestion Personnelle", "Options pour gérer votre personnage")

    personalMenu.OnMenuClosed = function(menu)
        ResetCursorLocation()
    end

    -- Options de santé
    local healPlayer = NativeUI.CreateItem("Se soigner", "Restaure la santé et l'armure au maximum")
    personalMenu:AddItem(healPlayer)
    healPlayer.Activated = function(sender, item)
        if item == healPlayer then
            local playerPed = PlayerPedId()
            SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
            SetPedArmour(playerPed, 100)
            ShowNotification("~g~Vous êtes soigné.")
        end
    end

    local setHealthItem = NativeUI.CreateItem("Définir la santé", "Définir un niveau de santé spécifique")
    personalMenu:AddItem(setHealthItem)
    setHealthItem.Activated = function(sender, item)
        if item == setHealthItem then
            AddTextEntry('FMMC_KEY_TIP1', "Entrez le niveau de santé (0-200) :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 3)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            local health = tonumber(GetOnscreenKeyboardResult())
            if health then
                local playerPed = PlayerPedId()
                SetEntityHealth(playerPed, health)
                ShowNotification("~g~Niveau de santé défini à : " .. health)
            else
                ShowNotification("~r~Entrée invalide.")
            end
        end
    end

    personalMenu:AddItem(NativeUI.CreateItem("---------", "")) -- Séparateur

    -- Options de gestion des armes
    local giveWeaponItem = NativeUI.CreateItem("Donner une arme", "Donner une arme spécifique")
    personalMenu:AddItem(giveWeaponItem)
    giveWeaponItem.Activated = function(sender, item)
        if item == giveWeaponItem then
            AddTextEntry('FMMC_KEY_TIP1', "Entrez le nom de l'arme :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            local weaponName = GetOnscreenKeyboardResult()
            if weaponName then
                local playerPed = PlayerPedId()
                GiveWeaponToPed(playerPed, GetHashKey(weaponName), 999, false, false)
                ShowNotification("~g~Arme donnée : " .. weaponName)
            else
                ShowNotification("~r~Entrée invalide.")
            end
        end
    end

    local removeWeaponsItem = NativeUI.CreateItem("Enlever toutes les armes", "Retirer toutes les armes de votre inventaire")
    personalMenu:AddItem(removeWeaponsItem)
    removeWeaponsItem.Activated = function(sender, item)
        if item == removeWeaponsItem then
            local playerPed = PlayerPedId()
            RemoveAllPedWeapons(playerPed, true)
            ShowNotification("~g~Toutes les armes ont été retirées.")
        end
    end

    personalMenu:AddItem(NativeUI.CreateItem("---------", "")) -- Séparateur

    -- Options de téléportation
    local teleportToWaypoint = NativeUI.CreateItem("Téléporter au point de cheminement", "Téléporte votre personnage au point de cheminement sur la carte")
    personalMenu:AddItem(teleportToWaypoint)
    teleportToWaypoint.Activated = function(sender, item)
        if item == teleportToWaypoint then
            local waypointHandle = GetFirstBlipInfoId(8)
            if DoesBlipExist(waypointHandle) then
                local coords = GetBlipInfoIdCoord(waypointHandle)
                local playerPed = PlayerPedId()
                SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
                ShowNotification("~g~Téléporté au point de cheminement.")
            else
                ShowNotification("~r~Aucun point de cheminement trouvé.")
            end
        end
    end

    local teleportToCoordsItem = NativeUI.CreateItem("Téléporter aux coordonnées", "Téléporter votre personnage à des coordonnées spécifiques")
    personalMenu:AddItem(teleportToCoordsItem)
    teleportToCoordsItem.Activated = function(sender, item)
        if item == teleportToCoordsItem then
            AddTextEntry('FMMC_KEY_TIP1', "Entrez les coordonnées X :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 10)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            local x = tonumber(GetOnscreenKeyboardResult())

            AddTextEntry('FMMC_KEY_TIP2', "Entrez les coordonnées Y :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP2", "", "", "", "", "", 10)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            local y = tonumber(GetOnscreenKeyboardResult())

            AddTextEntry('FMMC_KEY_TIP3', "Entrez les coordonnées Z :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP3", "", "", "", "", "", 10)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            local z = tonumber(GetOnscreenKeyboardResult())

            if x and y and z then
                local playerPed = PlayerPedId()
                SetEntityCoords(playerPed, x, y, z, false, false, false, true)
                ShowNotification("~g~Téléporté aux coordonnées.")
            else
                ShowNotification("~r~Entrée invalide.")
            end
        end
    end

    personalMenu:AddItem(NativeUI.CreateItem("---------", "")) -- Séparateur

    -- Options diverses
    local changeModelItem = NativeUI.CreateItem("Changer de modèle", "Changer l'apparence de votre personnage")
    personalMenu:AddItem(changeModelItem)
    changeModelItem.Activated = function(sender, item)
        if item == changeModelItem then
            AddTextEntry('FMMC_KEY_TIP1', "Entrez le nom du modèle :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            local modelName = GetOnscreenKeyboardResult()
            if modelName then
                local modelHash = GetHashKey(modelName)
                if IsModelInCdimage(modelHash) and IsModelValid(modelHash) then
                    RequestModel(modelHash)
                    while not HasModelLoaded(modelHash) do
                        Citizen.Wait(0)
                    end
                    SetPlayerModel(PlayerId(), modelHash)
                    SetModelAsNoLongerNeeded(modelHash)
                    ShowNotification("~g~Modèle changé en : " .. modelName)
                else
                    ShowNotification("~r~Modèle invalide.")
                end
            else
                ShowNotification("~r~Entrée invalide.")
            end
        end
    end

    local setArmorItem = NativeUI.CreateItem("Définir l'armure", "Définir un niveau d'armure spécifique")
    personalMenu:AddItem(setArmorItem)
    setArmorItem.Activated = function(sender, item)
        if item == setArmorItem then
            AddTextEntry('FMMC_KEY_TIP1', "Entrez le niveau d'armure (0-100) :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 3)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            local armor = tonumber(GetOnscreenKeyboardResult())
            if armor then
                local playerPed = PlayerPedId()
                SetPedArmour(playerPed, armor)
                ShowNotification("~g~Niveau d'armure défini à : " .. armor)
            else
                ShowNotification("~r~Entrée invalide.")
            end
        end
    end

    local addAccessoryItem = NativeUI.CreateItem("Ajouter un accessoire", "Ajouter un accessoire spécifique")
    personalMenu:AddItem(addAccessoryItem)
    addAccessoryItem.Activated = function(sender, item)
        if item == addAccessoryItem then
            AddTextEntry('FMMC_KEY_TIP1', "Entrez le type d'accessoire (e.g., chapeau, lunettes) :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            local accessoryType = GetOnscreenKeyboardResult()

            AddTextEntry('FMMC_KEY_TIP2', "Entrez le modèle de l'accessoire :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP2", "", "", "", "", "", 20)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            local accessoryModel = GetOnscreenKeyboardResult()

            if accessoryType and accessoryModel then
                local playerPed = PlayerPedId()
                -- Assumer que le type d'accessoire correspond à un component ID. Besoin d'une logique spécifique ici.
                SetPedPropIndex(playerPed, accessoryType, accessoryModel, 0, true)
                ShowNotification("~g~Accessoire ajouté : " .. accessoryModel)
            else
                ShowNotification("~r~Entrée invalide.")
            end
        end
    end

    local setWantedLevelItem = NativeUI.CreateItem("Définir le niveau de recherche", "Définir un niveau de recherche spécifique")
    personalMenu:AddItem(setWantedLevelItem)
    setWantedLevelItem.Activated = function(sender, item)
        if item == setWantedLevelItem then
            AddTextEntry('FMMC_KEY_TIP1', "Entrez le niveau de recherche (0-5) :")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 1)
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(0)
            end
            local wantedLevel = tonumber(GetOnscreenKeyboardResult())
            if wantedLevel and wantedLevel >= 0 and wantedLevel <= 5 then
                SetPlayerWantedLevel(PlayerId(), wantedLevel, false)
                SetPlayerWantedLevelNow(PlayerId(), false)
                ShowNotification("~g~Niveau de recherche défini à : " .. wantedLevel)
            else
                ShowNotification("~r~Entrée invalide.")
            end
        end
    end

    -- Autres options utiles
    local increaseSpeedItem = NativeUI.CreateItem("Augmenter la vitesse de déplacement", "Augmente la vitesse de déplacement du personnage")
    personalMenu:AddItem(increaseSpeedItem)
    increaseSpeedItem.Activated = function(sender, item)
        if item == increaseSpeedItem then
            local playerPed = PlayerPedId()
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.5)
            ShowNotification("~g~Vitesse de déplacement augmentée.")
        end
    end

    local resetSpeedItem = NativeUI.CreateItem("Réinitialiser la vitesse de déplacement", "Réinitialise la vitesse de déplacement du personnage")
    personalMenu:AddItem(resetSpeedItem)
    resetSpeedItem.Activated = function(sender, item)
        if item == resetSpeedItem then
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
            ShowNotification("~g~Vitesse de déplacement réinitialisée.")
        end
    end

    local toggleInvisibilityItem = NativeUI.CreateCheckboxItem("Invisibilité", false, "Activer/Désactiver l'invisibilité")
    personalMenu:AddItem(toggleInvisibilityItem)
    toggleInvisibilityItem.CheckboxEvent = function(sender, item, checked)
        local playerPed = PlayerPedId()
        SetEntityVisible(playerPed, not checked, false)
        ShowNotification("~g~Invisibilité : " .. (checked and "Activée" or "Désactivée"))
    end

    local superJumpItem = NativeUI.CreateCheckboxItem("Super Saut", false, "Activer/Désactiver le super saut")
    personalMenu:AddItem(superJumpItem)
    superJumpItem.CheckboxEvent = function(sender, item, checked)
        SetSuperJumpThisFrame(PlayerId())
        ShowNotification("~g~Super Saut : " .. (checked and "Activé" or "Désactivé"))
    end
end

-- Appel de la fonction AddPersonalManagementMenu pour ajouter le sous-menu au menu principal







AddMenuDebugOptions(mainMenu)
AddPersonalManagementMenu(mainMenu)
AddVehicleManagementMenu(mainMenu)
AddTimeMenu(mainMenu)
AddPropsBuilderMenu(mainMenu)
AddBlipsBuilderMenu(mainMenu) 
_menuPool:RefreshIndex()



RegisterNetEvent('dev_menu:init')
AddEventHandler('dev_menu:init', function()
    Citizen.CreateThread(function()
        local selectedProp = nil

        while true do
            Citizen.Wait(0)
            _menuPool:ProcessMenus()
            if IsControlJustReleased(0, 289) then -- Ouvrir le menu avec la touche F2 (289)
                mainMenu:Visible(not mainMenu:Visible())
                isMenuOpen = mainMenu:Visible()
                if isMenuOpen then
                    SetNuiFocus(true, true)
                    ResetCursorLocation() -- Réinitialiser la position du curseur pour éviter tout problème
                else
                    SetNuiFocus(false, false)
                end
            end

            if displayCoords then
                DrawCoords()
            end

            if displayEntityIDs then
                DrawEntityIDs()
            end

            if isPlacingProp and currentProp then
                local propCoords = GetEntityCoords(currentProp)
                FreezeEntityPosition(currentProp, true)

                -- Déplacer avec les flèches
                if IsControlPressed(0, 174) then -- Flèche gauche
                    SetEntityCoordsNoOffset(currentProp, propCoords.x - 0.1, propCoords.y, propCoords.z, true, true, true)
                end
                if IsControlPressed(0, 175) then -- Flèche droite
                    SetEntityCoordsNoOffset(currentProp, propCoords.x + 0.1, propCoords.y, propCoords.z, true, true, true)
                end
                if IsControlPressed(0, 172) then -- Flèche haut
                    SetEntityCoordsNoOffset(currentProp, propCoords.x, propCoords.y + 0.1, propCoords.z, true, true, true)
                end
                if IsControlPressed(0, 173) then -- Flèche bas
                    SetEntityCoordsNoOffset(currentProp, propCoords.x, propCoords.y - 0.1, propCoords.z, true, true, true)
                end
                if IsControlPressed(0, 111) then -- Num 8
                    SetEntityCoordsNoOffset(currentProp, propCoords.x, propCoords.y, propCoords.z + 0.1, true, true, true)
                end
                if IsControlPressed(0, 110) then -- Num 5
                    SetEntityCoordsNoOffset(currentProp, propCoords.x, propCoords.y, propCoords.z - 0.1, true, true, true)
                end
                if IsControlPressed(0, 108) then -- Num 4
                    SetEntityHeading(currentProp, GetEntityHeading(currentProp) - 1)
                end
                if IsControlPressed(0, 109) then -- Num 6
                    SetEntityHeading(currentProp, GetEntityHeading(currentProp) + 1)
                end

                -- Placer le prop
                if IsControlJustReleased(0, 38) then -- E key
                    SetEntityAlpha(currentProp, 255, false)
                    FreezeEntityPosition(currentProp, false)
                    isPlacingProp = false
                    ShowNotification("~g~Prop placé.")
                end
            end

            if isDeletingProp then
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local closestProp, closestPropDist = GetClosestObjectOfType(playerCoords, 5.0, 0, false, false, false), 5.0

                for _, obj in ipairs(GetGamePool('CObject')) do
                    local objCoords = GetEntityCoords(obj)
                    local dist = #(playerCoords - objCoords)
                    if dist < closestPropDist then
                        closestProp = obj
                        closestPropDist = dist
                    end
                end

                if DoesEntityExist(closestProp) then
                    local propCoords = GetEntityCoords(closestProp)
                    DrawMarker(20, propCoords.x, propCoords.y, propCoords.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 200, false, true, 2, nil, nil, false)
                    selectedProp = closestProp
                else
                    selectedProp = nil
                end

                if IsControlJustReleased(0, 38) and selectedProp then
                    -- Utilisation de SetEntityAsMissionEntity et DeleteEntity pour une suppression plus robuste
                    SetEntityAsMissionEntity(selectedProp, true, true)
                    DeleteEntity(selectedProp)
                    if not DoesEntityExist(selectedProp) then
                        ShowNotification("~r~Prop supprimé.")
                    else
                        ShowNotification("~r~Échec de la suppression du prop.")
                    end
                    selectedProp = nil
                end
            end
        end
    end)
end)
