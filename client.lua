ESX = exports["es_extended"]:getSharedObject()
if Banca.oxTarget then 
    Citizen.CreateThread(function()
        for k,v in ipairs(Banca.Position) do 
             exports.ox_target:addSphereZone({
                 coords =  v.coords,
                 radius = 0.9,
                 debug = false,
                 drawSprite = false,
                 options = {
                     {
                         icon = 'fa-solid fa-bank',
                         label = 'Bank',
                         onSelect = function(data)
                             TriggerEvent('ChristianBanca')
                         end
                     }
                 }
             })         

        end
    end)
else 
    Citizen.CreateThread(function()
        for k,v in pairs(Banca.Position) do 
            TriggerEvent('gridsystem:registerMarker', {
                name = 'banche'..k,
                pos = v.coords,
                scale = vector3(0.8, 0.8, 0.8),
                texture = Banca.Marker,
                msg = Banca.MSG,
                control = Banca.Control,
                type = Banca.MarkerType,
                color = { r = 130, g = 120, b = 110 },
                action = function(source)
                    TriggerEvent('ChristianBanca')
                end
            })
        end
    end)
end

RegisterNetEvent('ChristianBanca')
AddEventHandler('ChristianBanca', function()
    local input = lib.inputDialog('Banca', {
      {type = 'checkbox', label = 'Deposito'}, 
      {type = 'checkbox', label = 'Prelievo'}, 
      {type = 'checkbox', label = 'Invia soldi'},
      {type = 'checkbox', label = 'Saldo'}
    })
 
    if not input then return end

    if input[1] and input[2] and input[3] or input[1] and input[2] or input[1] and input[3] or input[2] and input[3] or input[3] and input[4] then 
        lib.notify({
            title = 'Banca',
            description = 'Devi selezionare solo un\'opzione',
            type = 'error'
        })
    elseif input[1] then 
        TriggerEvent('ChristianDepositaSoldiClient')
    elseif input[2] then 
        TriggerEvent('ChristianPrelevaSoldi')
    elseif input[3] then 
        TriggerEvent('ChristianMandatraslazione')
    elseif input[4] then 
        TriggerEvent('ChristianSaldo')
    elseif input[1] == false and input[2] == false and input[3] == false then 
        lib.notify({
            title = 'Banca',
            description = 'Devi selezionare un\'opzione',
            type = 'error'
        })
    end
end)

RegisterNetEvent('ChristianDepositaSoldiClient')
AddEventHandler('ChristianDepositaSoldiClient', function()
    local count = exports.ox_inventory:Search('count', 'money')
    local input = lib.inputDialog('Banca: Deposito', {
        {type = 'number', label = 'Inserisci l\'importo da depositare'} 
    })
    
    if not input then return end
    
    local input1 = tonumber(input[1])

    if input1 > count then 
        lib.notify({
            title = 'Banca',
            description = 'Non hai abbastanza soldi',
            type = 'error'
        })
    else 
        TriggerServerEvent('ChristianDepositaSoldi', input1)
    end
end)

RegisterNetEvent('ChristianPrelevaSoldi')
AddEventHandler('ChristianPrelevaSoldi', function()
    local input = lib.inputDialog('Banca: Prelievo', {
        {type = 'number', label = 'Inserisci l\'importo da prelevare'} 
         })
         local input1 = tonumber(input[1])
         TriggerServerEvent('ChristianPrelievoSoldi', input1)
end)

RegisterNetEvent('ChristianSaldo')
AddEventHandler('ChristianSaldo', function()
    TriggerServerEvent('DammiSaldo')
end)

RegisterNetEvent('MostraSaldo')
AddEventHandler('MostraSaldo', function(bankMoney)
    local alert = lib.alertDialog({
        header = 'Banca',
        content = 'Il tuo saldo è: $' .. bankMoney,
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Conferma',
            cancel = 'Chiudi'
        }
    })
end)

RegisterNetEvent('ChristianMandatraslazione')
AddEventHandler('ChristianMandatraslazione', function(bankMoney)
    local input = lib.inputDialog('Banca: Manda Soldi', {
        {type = 'number', label = 'Inserisci l\'ID del giocatore a cui vuoi inviare dei soldi'},
        {type = 'number', label = 'Inserisci l\'importo:'}
    })

    local IdPlayer = input[1] 
    local soldi = input[2]
    TriggerServerEvent('MandaSoldi', IdPlayer, soldi)
end)

RegisterNetEvent('ChristianMandaNotifica')
AddEventHandler('ChristianMandaNotifica', function()
    lib.notify({
        title = 'Banca',
        description = 'Non hai abbastanza soldi in banca!',
        type = 'error'
    })
end)

RegisterNetEvent('NotificaTraslition')
AddEventHandler('NotificaTraslition', function(soldi)
    local playerino = GetPlayerName(PlayerId(xPlayer2))
    lib.notify({
        title = 'Banca',
        duration = 5000,
        description = 'Hai trasferito : '..soldi..'$ a: '.. playerino,
        type = 'success'
    })
end)

RegisterNetEvent('NotificaTraslitionEffettuata')
AddEventHandler('NotificaTraslitionEffettuata', function(soldi)
    lib.notify({
        title = 'Banca',
        duration = 5000,
        description = 'Hai ricevuto: '..soldi.."$",
        type = 'success'
    })
end)

RegisterNetEvent('ChristianMandaNotificaOFF')
AddEventHandler('ChristianMandaNotificaOFF', function()
    lib.notify({
        title = 'Banca',
        duration = 5000,
        description = 'Nessun giocatore con questo id',
        type = 'error'
    })
end)

for k,v in ipairs(Banca.Position) do
    blip = AddBlipForCoord(v.coords)
    SetBlipSprite(blip, v.idBlip) 
    SetBlipColour(blip, v.color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(v.nameBlip)
    EndTextCommandSetBlipName(blip)
end