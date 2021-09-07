ESX = nil
TriggerEvent(Config.getESX, function(lib) ESX = lib end)

playerCardNumber          = ""
playerCardName            = ""

function getNumberCardSource(sourceIdentifier)
    MySQL.Async.fetchAll('SELECT * FROM bank_account WHERE identifier = @identifier', { 
        ['@identifier'] = sourceIdentifier,
    }, function(result)
        for _,v in pairs(result) do
            playerCardNumber = v.cardnumber
            playerCardName   = v.cardname
        end
    end)
end

RegisterServerEvent('esx_bank:putMoney')
AddEventHandler('esx_bank:putMoney', function(quantity)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local pMoney  = xPlayer.getMoney()
    local pName = GetPlayerName(_src)
    if pMoney >= quantity then
        xPlayer.removeMoney(quantity)
        xPlayer.addAccountMoney('bank', quantity)
        TriggerClientEvent('esx:showAdvancedNotification', _src, 'Banque', 'Dépôt', "Vous venez de déposer ~g~"..quantity.."$ ~s~dans votre banque.", 'CHAR_BANK_FLEECA', 9)
        getNumberCardSource(xPlayer.identifier)
        Wait(10)
        MySQL.Async.execute('INSERT INTO bank_transactions (cardnumber,cardname,transactiontype,quantity,transactiondate,ingame) VALUES(@cardnumber,@cardname,@transactiontype,@quantity,@transactiondate,@ingame)', {
            ['cardnumber'] = playerCardNumber,
            ['cardname'] = playerCardName,
            ['transactiontype'] = "Dépôt",
            ['quantity'] = "+ "..quantity.." $",
            ['transactiondate'] = os.date("%d/%m/%Y | %X"),
            ['ingame'] = os.date("%d/%m/%Y | %X").." : ~g~+ "..quantity.."$"
        });
        if Config.bank.enableLog then
            Wait(5000)
            local w = {{ ["author"] = { ["name"] = "🪐 AKNX ORG", ["icon_url"] = "https://cdn.discordapp.com/attachments/785981508778590249/859426952062173204/aknx.png" }, ["thumbnail"] = { ["url"] = "https://cdn.discordapp.com/attachments/785981508778590249/859426952062173204/aknx.png" }, ["color"] = "10038562", ["title"] = Title, ["description"] = "**Banque | Dépôt**\nJoueur : "..pName.."\nId : ".._src.."\nQuantité : "..quantity.."$", ["footer"] = { ["text"] = "🪐 "..os.date("%d/%m/%Y | %X"), ["icon_url"] = nil }, } }
            PerformHttpRequest(Config.Webhooks.logLink, function(err, text, headers) end, 'POST', json.encode({username = Config.Webhooks.webhookName, embeds = w, avatar_url = "https://cdn.discordapp.com/attachments/785981508778590249/859426952062173204/aknx.png" }), { ['Content-Type'] = 'application/json' })
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _src, 'Banque', 'Dépôt', "~r~Action impossible, vous n'avez pas ~g~"..quantity.."$~r~ sur vous !", 'CHAR_BANK_FLEECA', 9)
    end
end)

RegisterServerEvent('esx_bank:takeMoney')
AddEventHandler('esx_bank:takeMoney', function(quantity)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local pName = GetPlayerName(_src)
    local pMoney  = xPlayer.getAccount('bank').money
    if pMoney >= quantity then
        xPlayer.removeAccountMoney('bank', quantity)
        xPlayer.addMoney(quantity)
        TriggerClientEvent('esx:showAdvancedNotification', _src, 'Banque', 'Retrait', "Vous venez de retirer ~g~"..quantity.."$ ~s~de votre banque.", 'CHAR_BANK_FLEECA', 9)
        getNumberCardSource(xPlayer.identifier)
        Wait(10)
        MySQL.Async.execute('INSERT INTO bank_transactions (cardnumber,cardname,transactiontype,quantity,transactiondate,ingame) VALUES(@cardnumber,@cardname,@transactiontype,@quantity,@transactiondate,@ingame)', {
            ['cardnumber'] = playerCardNumber,
            ['cardname'] = playerCardName,
            ['transactiontype'] = "Retrait",
            ['quantity'] = "- "..quantity.." $",
            ['transactiondate'] = os.date("%d/%m/%Y | %X"),
            ['ingame'] = os.date("%d/%m/%Y | %X").." : ~r~- "..quantity.."$"
        });
        if Config.bank.enableLog then
            Wait(5000)
            local w = {{ ["author"] = { ["name"] = "🪐 AKNX ORG", ["icon_url"] = "https://cdn.discordapp.com/attachments/785981508778590249/859426952062173204/aknx.png" }, ["thumbnail"] = { ["url"] = "https://cdn.discordapp.com/attachments/785981508778590249/859426952062173204/aknx.png" }, ["color"] = "10038562", ["title"] = Title, ["description"] = "**Banque | Retrait**\nJoueur : "..pName.."\nId : ".._src.."\nQuantité : "..quantity.."$", ["footer"] = { ["text"] = "🪐 "..os.date("%d/%m/%Y | %X"), ["icon_url"] = nil }, } }
            PerformHttpRequest(Config.Webhooks.logLink, function(err, text, headers) end, 'POST', json.encode({username = Config.Webhooks.webhookName, embeds = w, avatar_url = "https://cdn.discordapp.com/attachments/785981508778590249/859426952062173204/aknx.png" }), { ['Content-Type'] = 'application/json' })
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _src, 'Banque', 'Retrait', "~r~Action impossible, vous n'avez pas ~g~"..quantity.."$~r~ dans votre banque !", 'CHAR_BANK_FLEECA', 9)
    end
end)

RegisterServerEvent('esx_bank:addCreditCard')
AddEventHandler('esx_bank:addCreditCard', function(accountName)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local pName = GetPlayerName(_src)
    local cardNumber = "5413 "..math.random(1000,8000).." "..math.random(1000,8000).." "..math.random(1000,8000)
    MySQL.Async.execute('INSERT INTO bank_account (identifier,cardname,cardnumber,creationdate) VALUES(@identifier,@cardname,@cardnumber,@creationdate)', {
        ['identifier'] = xPlayer.identifier,
        ['cardname']   = accountName,
        ['cardnumber'] = cardNumber,
        ['creationdate'] = os.date("%d/%m/%Y | %X"),
    });
    xPlayer.addInventoryItem('cartebancaire', 1)
    TriggerClientEvent('esx:showAdvancedNotification', _src, 'Banque', 'Création de Compte', "Votre compte a été créé avec succès. ~s~Une carte bancaire vous a été donné, conservez-là.", 'CHAR_BANK_FLEECA', 9)
    TriggerClientEvent('esx:showAdvancedNotification', _src, 'Banque', 'Création de Compte', "Nom de compte : ~b~"..accountName.."\n~s~Numéro de carte : ~b~"..cardNumber, 'CHAR_BANK_FLEECA', 9)
    Wait(5000)
    if Config.bank.enableLog then
        Wait(5000)
        local w = {{ ["author"] = { ["name"] = "🪐 AKNX ORG", ["icon_url"] = "https://cdn.discordapp.com/attachments/785981508778590249/859426952062173204/aknx.png" }, ["thumbnail"] = { ["url"] = "https://cdn.discordapp.com/attachments/785981508778590249/859426952062173204/aknx.png" }, ["color"] = "10038562", ["title"] = Title, ["description"] = "**Banque | Création de carte**\nJoueur : "..pName.."\nId : ".._src.."\nNouvelle carte crée : "..cardNumber.."\nNom de la carte : "..accountName, ["footer"] = { ["text"] = "🪐 "..os.date("%d/%m/%Y | %X"), ["icon_url"] = nil }, } }
        PerformHttpRequest(Config.Webhooks.logLink, function(err, text, headers) end, 'POST', json.encode({username = Config.Webhooks.webhookName, embeds = w, avatar_url = "https://cdn.discordapp.com/attachments/785981508778590249/859426952062173204/aknx.png" }), { ['Content-Type'] = 'application/json' })
    end
end)

ESX.RegisterServerCallback('esx_bank:checkPlayerHasCreditCard', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local creditCard = xPlayer.getInventoryItem('cartebancaire').count
    local hasCreditCard = false
    if creditCard == 1 then
        hasCreditCard = true
    else
        hasCreditCard = false
    end
    cb(hasCreditCard)
end)

ESX.RegisterServerCallback('esx_bank:checkAllCreditCard', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local creditCard = xPlayer.getInventoryItem('cartebancaire').count
    local hasCreditCard = false
    if creditCard > 1 then
        hasCreditCard = false
    else
        hasCreditCard = true
    end 
    cb(hasCreditCard)
end)

ESX.RegisterServerCallback('esx_bank:getBankMoney', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local moneyBank = xPlayer.getAccount('bank').money
    cb(moneyBank)
end)

ESX.RegisterServerCallback('esx_bank:checkInformations', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    getNumberCardSource(xPlayer.identifier)
    Wait(10)
    MySQL.Async.fetchAll('SELECT * FROM bank_account WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier,
    }, function(result)
        local data = {
            cardName = result[1]['cardname']
        }
        cb(data)
    end)
end)

ESX.RegisterServerCallback('esx_bank:checkTransactionsHistory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    getNumberCardSource(xPlayer.identifier)
    Wait(10)
    MySQL.Async.fetchAll('SELECT * FROM bank_transactions WHERE cardnumber = @cardnumber', {
        ['cardnumber'] = playerCardNumber,
    }, function(result)
        cb(result)
    end)
end)

RegisterServerEvent('esx_bank:destroyCard')
AddEventHandler('esx_bank:destroyCard', function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local pName = GetPlayerName(_src)
    getNumberCardSource(xPlayer.identifier)
    TriggerClientEvent('esx:showAdvancedNotification', _src, 'Banque', 'Suppression de Compte', "Votre compte et votre carte ont été supprimés avec succès.", 'CHAR_BANK_FLEECA', 1)
    Wait(100)
    MySQL.Async.execute('DELETE FROM bank_account WHERE identifier = @identifier', {
        ['identifier'] = xPlayer.identifier
    })
    MySQL.Async.execute('DELETE FROM bank_transactions WHERE cardnumber = @cardnumber', {
        ['cardnumber'] = playerCardNumber
    })
    xPlayer.removeInventoryItem('cartebancaire', 1)
    if Config.bank.enableLog then
        Wait(5000)
        local w = {{ ["author"] = { ["name"] = "🪐 AKNX ORG", ["icon_url"] = "https://cdn.discordapp.com/attachments/785981508778590249/859426952062173204/aknx.png" }, ["thumbnail"] = { ["url"] = "https://cdn.discordapp.com/attachments/785981508778590249/859426952062173204/aknx.png" }, ["color"] = "10038562", ["title"] = Title, ["description"] = "**Banque | Destruction de carte**\nJoueur : "..pName.."\nId : ".._src.."\nNouvelle carte supprimmée : "..playerCardNumber, ["footer"] = { ["text"] = "🪐 "..os.date("%d/%m/%Y | %X"), ["icon_url"] = nil }, } }
        PerformHttpRequest(Config.Webhooks.logLink, function(err, text, headers) end, 'POST', json.encode({username = Config.Webhooks.webhookName, embeds = w, avatar_url = "https://cdn.discordapp.com/attachments/785981508778590249/859426952062173204/aknx.png" }), { ['Content-Type'] = 'application/json' })
    end
end)