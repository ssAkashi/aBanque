function BankMenu()
    RMenu.Add('bank_menu', 'main_menu', RageUI.CreateMenu("BANQUE", "∑ Bienvenue dans votre banque."))
    RMenu.Add('bank_menu', 'infos', RageUI.CreateSubMenu(RMenu:Get('bank_menu', 'main_menu'), "BANQUE", "∑ Informations de votre banque."))
    RMenu:Get('bank_menu', 'main_menu'):SetRectangleBanner(Config.bannerMenuColor.r, Config.bannerMenuColor.g, Config.bannerMenuColor.b, Config.bannerMenuColor.opacity)
    RMenu:Get('bank_menu', 'infos'):SetRectangleBanner(Config.bannerMenuColor.r, Config.bannerMenuColor.g, Config.bannerMenuColor.b, Config.bannerMenuColor.opacity)
    RMenu:Get('bank_menu', 'main_menu').Closed = function()
        FreezeEntityPosition(PlayerPedId(), false)
        transactionClick = false
        isMenuOpen = false
    end
end

local historyTable = {}
local transactionClick = false
function openBankMenu()
    if isMenuOpen then
        isMenuOpen = false
    else
        isMenuOpen = true
        BankMenu();
        RageUI.Visible(RMenu:Get('bank_menu', 'main_menu'), true)
        createCard = false
        Citizen.CreateThread(function()
            while isMenuOpen do
                Wait(1)
                RageUI.IsVisible(RMenu:Get('bank_menu', 'main_menu'), true, true, true, function()
                    if Config.hasCreditCard then
                        RageUI.Separator("VOTRE BANQUE")
                        RageUI.ButtonWithStyle("Effectuer un dépôt", "Effectuez un dêpot d'argent sur votre banque.", {RightLabel = "→→"}, true, function(_,_,s)
                            if s then
                                local quantityInput = KeyboardInput("Quantité d'argent à déposer (ex : 1000) :", "", 50)
                                if quantityInput ~= nil then
                                    if tonumber(quantityInput) then
                                        TriggerServerEvent('esx_bank:putMoney', tonumber(quantityInput))
                                    else
                                        return notify("Dépôt", "~r~Merci de bien renseigner une somme à déposer dans votre banque !")
                                    end
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Effectuer un retrait", "Effectuez un retrait d'argent de votre banque.", {RightLabel = "→→"}, true, function(_,_,s)
                            if s then
                                local quantityTake = KeyboardInput("Quantité d'argent à retirer (ex : 2000) :", "", 50)
                                if quantityTake ~= nil then
                                    if tonumber(quantityTake) then
                                        TriggerServerEvent('esx_bank:takeMoney',  tonumber(quantityTake))
                                    else
                                        return notify("Dépôt", "~r~Merci de bien renseigner une somme à retirer de votre banque !")
                                    end
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Ma Banque", "Accèdez aux actions sur votre banque, et tout ce qu'elle contient.", {RightLabel = "→→"}, true, function(_,_,s)
                            if s then
                                checkAccountBankMoney();

                            end
                        end, RMenu:Get('bank_menu', 'infos'))
                    else
                        RageUI.Separator("BIENVENUE")
                        RageUI.Separator("~r~Aucune carte détectée")
                        RageUI.ButtonWithStyle("Créer ma carte", "Vous n'avez pas de carte bancaire ? Pas de problème, en un clic elle peut être crée.", {RightLabel = "→→"}, not createCard, function(_,_,s)
                            if s then
                                accountName = KeyboardInput("Entrez votre nom prénom pour votre compte :", "", 30)
                                if accountName ~= nil and accountName ~= "" then
                                    if tostring(accountName) then
                                        createCard = true
                                        notify("Compte", "Création de compte pour : ~b~"..accountName)
                                    else
                                        return notify("Compte", "~r~Le nom de compte renseigné est invalide !")
                                    end
                                end
                            end
                        end)
                        if createCard then
                            RageUI.PercentagePanel(Config.cardLoad, "Création du compte en cours (~b~"..math.floor(Config.cardLoad*100).."%~s~)", "", "", function(_, a_, percent)
                                if Config.cardLoad < 1.0 then
                                    Config.cardLoad = Config.cardLoad + 0.0006
                                else
                                    Config.cardLoad = 0
                                end
                            end)
                        end
                        if Config.cardLoad >= 1.0 then
                            TriggerServerEvent('esx_bank:addCreditCard', accountName)
                            Config.cardLoad = 0
                            Config.hasCreditCard = true
                        end
                    end
                end)

                RageUI.IsVisible(RMenu:Get('bank_menu', 'infos'), true, true, true, function()
                    if IsControlJustPressed(0, 194) then
                        transactionClick = false
                        RageUI.GoBack();
                    end
                    RageUI.Separator("Mon Solde : ~g~"..Config.bankMoney.."$")
                    RageUI.ButtonWithStyle("~r~Détruire la carte", "Actualiser les transactions liés à votre compte bancaire.", { RightLabel = "→→" }, true, function(_,_,s)
                        if s then
                            isMenuOpen = false
                            ESX.ShowNotification("Suppression en cours...")
                            Wait(3000)
                            FreezeEntityPosition(PlayerPedId(), false)
                            TriggerServerEvent('esx_bank:destroyCard')
                        end
                    end)
                    RageUI.Separator("↓ ~y~Historique des transactions~s~ ↓")
                    RageUI.ButtonWithStyle("Voir mes transactions", "Actualiser les transactions liés à votre compte bancaire.", { RightLabel = "→→" }, not transactionClick, function(_,_,s)
                        if s then
                            transactionClick = true
                            ESX.TriggerServerCallback('esx_bank:checkTransactionsHistory', function(history)
                                historyTable = history
                            end)
                        end
                    end)
                    if #historyTable < 1 then
                        RageUI.Separator("")
                        RageUI.Separator("~r~Aucune transaction trouvée")
                        RageUI.Separator("")
                    end
                    for i = 1, #historyTable,1 do
                        RageUI.ButtonWithStyle(historyTable[i].ingame, "Vous avez la date de transaction, et aussi si c'est un retrait ou un dépot.", {}, true, function(_,_,s)
                        end)
                    end
                end)
            end
        end)
    end
end