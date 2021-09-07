local InZone = {}
local interval = 1000

CreateThread(function()
    while true do
        Wait(interval)
        for _,v in pairs(Config.posBank) do
            local pPos = GetEntityCoords(PlayerPedId())
            local distance = Vdist(pPos.x, pPos.y, pPos.z, v.x, v.y, v.z)
            if distance <= 10.0 then
                interval = 0
                InZone[v.Zones] = true
                DrawMarker(2, v.x, v.y, v.z, 1.0, 0.0, 1.0, 5.0, 0.0, 0.0, 0.35, 0.35, 0.35, Config.marker.markerColor.r, Config.marker.markerColor.g, Config.marker.markerColor.b, Config.marker.markerColor.a, 5, 1, 2, 0, nil, nil, 0);
                if distance <= 1.5 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour accèder à la banque.")
                    if IsControlJustPressed(1, 51) then
                        FreezeEntityPosition(PlayerPedId(), true)
                        ESX.TriggerServerCallback('esx_bank:checkPlayerHasCreditCard', function(creditCard)
                            Config.hasCreditCard = creditCard
                         end)
                        ESX.TriggerServerCallback('esx_bank:checkAllCreditCard', function(creditcard)
                            acessBank = creditcard
                        end)
                        Wait(500)
                        if not acessBank then
                            notify("Accès", "~r~Vous avez trop de carte bancaires sur vous, vous devez en avoir 1 maximum sur vous.")
                            FreezeEntityPosition(PlayerPedId(), false)
                        else 
                            openBankMenu();
                            isMenuOpen = true
                        end
                    end
                end
            else
                if InZone[v.Zones] then
                    InZone[v.Zones] = false
                    isMenuOpen = false
                    interval = 1000
                end
            end
        end
    end
end)