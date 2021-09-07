ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.getESX, function(lib) ESX = lib end)
		Wait(10)
	end
end)

function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", inputText, "", "", "", maxLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(1.0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        return result
    else
        Wait(500)
        return nil
    end
end

function notify(title, msg)
    return ESX.ShowAdvancedNotification('Banque', title, msg, 'CHAR_BANK_FLEECA', 9);
end

function checkAccountBankMoney()
    ESX.TriggerServerCallback('esx_bank:getBankMoney', function(bankMoney) 
        Config.bankMoney = bankMoney
    end)
    ESX.TriggerServerCallback('esx_bank:checkInformations', function(data)
        Config.bank.playerName = data.cardName
    end)
end

---@PARAMS --> BLIPS
CreateThread(function()
    for _,blip in pairs(Config.posBlip) do
        local blips = AddBlipForCoord(blip.x, blip.y, blip.z)
        SetBlipSprite(blips, blip.blipSprite)
        SetBlipColour(blips, blip.colorBlip)
        SetBlipScale(blips, blip.blipScale)
        SetBlipAsShortRange(blips, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blip.blipName)
        EndTextCommandSetBlipName(blips)
    end
end)

---@PARAMS --> PED
CreateThread(function()
    for _,ped in pairs(Config.posPed) do
        RequestModel(ped.pedModel)
        while not HasModelLoaded(ped.pedModel) do Wait(10) end
        RequestAnimDict("mini@strip_club@idles@bouncer@base")
        while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do Wait(10) end
        local npc = CreatePed(4, ped.pedModel, ped.x, ped.y, ped.z, ped.pedModel, false, true)
        SetEntityHeading(npc, ped.heading)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        TaskPlayAnim(npc, "mini@strip_club@idles@bouncer@base", "base", 8.0, 0.0, -1, 1, 0, 0, 0, 0);
    end
end)