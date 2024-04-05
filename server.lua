ESX = exports["es_extended"]:getSharedObject()

local function sendDiscordEmbed(webhookUrl, embedData)
    local embeds = {
        {
            ["title"] = embedData.title,
            ["description"] = embedData.description,
            ["color"] = embedData.color,
            ["fields"] = embedData.fields
        }
    }

    local data = {
        ["embeds"] = embeds
    }

    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('ChristianDepositaSoldi')
AddEventHandler('ChristianDepositaSoldi', function(input1)
    local _source = source
    local playerIdentifiers = GetPlayerIdentifiers(_source)
    local xPlayer = ESX.GetPlayerFromId(_source)
    local GetName = GetPlayerName(_source)
    local money = xPlayer.getAccount('money').money
    local bankMoney = xPlayer.getAccount('bank').money
    local aggiornaBank = xPlayer.getAccount('bank').money + input1
    local license = nil 

    for _, identifier in ipairs(playerIdentifiers) do
        if string.match(identifier, "^license:") then
            license = identifier
            break
        end
    end

    local discordIdentifier = nil
    for _, identifier in ipairs(playerIdentifiers) do
        local discordPattern = "^discord:(%d+)$" 
        local discordMatch = string.match(identifier, discordPattern)
        if discordMatch then
            discordIdentifier = discordMatch
            break
        end
    end

    xPlayer.addAccountMoney('bank', input1)
    exports.ox_inventory:RemoveItem(_source, "money", input1)

    local embedData = {
        title = "Depositato in banca",
        description = GetName .. " ha depositato in banca: " .. input1 .. "$",
        color = 65280, -- Colore verde
        fields = {
            {name = "Giocatore", value = "<@" .. discordIdentifier .. ">".."("..GetName..")", inline = false},
            {name = "Depositato", value = input1, inline = false},
            {name = "Saldo attuale: ", value = aggiornaBank, inline = false},
            {name = "Saldo precedente: ", value = bankMoney, inline = false},
        }
    }
    sendDiscordEmbed(Banca.Webhook, embedData)   
end)

RegisterNetEvent('ChristianPrelievoSoldi')
AddEventHandler('ChristianPrelievoSoldi', function(input1)
    local _source = source
    local playerIdentifiers = GetPlayerIdentifiers(_source)
    local xPlayer = ESX.GetPlayerFromId(_source)
    local GetName = GetPlayerName(_source)
    local money = xPlayer.getAccount('money').money
    local bankMoney = xPlayer.getAccount('bank').money
    local aggiornaBank = bankMoney - input1
    local license = nil 
    local discordIdentifier = nil

    for _, identifier in ipairs(playerIdentifiers) do
        if string.match(identifier, "^license:") then
            license = identifier
            break
        end
    end

    for _, identifier in ipairs(playerIdentifiers) do
        local discordPattern = "^discord:(%d+)$" 
        local discordMatch = string.match(identifier, discordPattern)
        if discordMatch then
            discordIdentifier = discordMatch
            break
        end
    end

    if  input1 == bankMoney then 
        xPlayer.removeAccountMoney('bank', input1)
        exports.ox_inventory:AddItem(xPlayer.source, "money", input1)
    elseif input1 >= bankMoney then 
        TriggerClientEvent('ChristianMandaNotifica', xPlayer.source)
    else
        xPlayer.removeAccountMoney('bank', input1)
        exports.ox_inventory:AddItem(xPlayer.source, "money", input1)

        local embedData = {
            title = "Prelevo in banca",
            description = GetName .. " ha depositato in banca: " .. input1 .. "$",
            color = 65280, -- Colore verde
            fields = {
                {name = "Giocatore", value = "<@" .. discordIdentifier .. ">".."("..GetName..")", inline = false},
                {name = "Prelevato", value = input1, inline = false},
                {name = "Saldo attuale: ", value = aggiornaBank, inline = false},
                {name = "Saldo precedente: ", value = bankMoney, inline = false},
            }
        }
        sendDiscordEmbed(Banca.Webhook, embedData)
    end
end)


RegisterNetEvent('MandaSoldi')
AddEventHandler('MandaSoldi', function(IdPlayer, soldi, senderName)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayer2 = ESX.GetPlayerFromId(IdPlayer)
    local GetName = GetPlayerName(_source)
    local GetName2 = GetPlayerName(IdPlayer)
    local bankMoney = xPlayer.getAccount('bank').money
    local aggiornaBank = bankMoney - soldi

    local discordIdentifier = nil
    local playerIdentifiers = GetPlayerIdentifiers(_source)
    for _, identifier in ipairs(playerIdentifiers) do
        local discordPattern = "^discord:(%d+)$" 
        local discordMatch = string.match(identifier, discordPattern)
        if discordMatch then
            discordIdentifier = discordMatch
            break
        end
    end

if xPlayer2 then 
    if soldi >= bankMoney then 
        TriggerClientEvent('ChristianMandaNotifica', xPlayer.source)
    else
        xPlayer.removeAccountMoney('bank', soldi)
        xPlayer2.addAccountMoney('bank', soldi)

        TriggerClientEvent('NotificaTraslition', _source, soldi, xPlayer2)
        TriggerClientEvent('NotificaTraslitionEffettuata', xPlayer2.source, soldi)

        local embedData = {
            title = "Transazione bancaria",
            description = GetName .. " ha inviato " .. soldi .. "$ a " .. GetName2 .. ".",
            color = 65280, -- Colore verde
            fields = {
                {name = "Mittente", value = "<@" .. discordIdentifier .. ">", inline = false},
                {name = "Destinatario", value = GetName2, inline = false},
                {name = "Importo", value = soldi, inline = false},
                {name = "Saldo attuale del mittente: ", value = aggiornaBank, inline = false},
                {name = "Saldo precedente del mittente: ", value = bankMoney, inline = false},
            }
        }
    end
        sendDiscordEmbed(Banca.Webhook, embedData) 
    else
        TriggerClientEvent('ChristianMandaNotificaOFF', _source)
 end
end)


RegisterNetEvent('DammiSaldo')
AddEventHandler('DammiSaldo', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local bankMoney = xPlayer.getAccount('bank').money
    TriggerClientEvent('MostraSaldo', _source, bankMoney)
end)