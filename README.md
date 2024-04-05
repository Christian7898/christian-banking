# christian-banking
Bank with ox_lib configurable with ox_target or gridsysten

<h1>Christian Banking </h1>

<p>For help write me on discord: christian0093 or join here: https://discord.gg/J8kna4F78y </p>

[Preview](https://www.youtube.com/watch?v=2VAC_qdY54g)

## Dipendenze:

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [gridsystem](https://github.com/Profex1999/gridsystem)


```Config.lua
Banca = {}

Banca.oxTarget = true

Banca.Marker = 'marker' -- ONLY IF Banca.oxTarget IS FALSE 

Banca.MSG = 'Clicca per aprire la banca' -- ONLY IF Banca.oxTarget IS FALSE 

Banca.Control = 'E'-- ONLY IF Banca.oxTarget IS FALSE 

Banca.MarkerType = -1-- ONLY IF Banca.oxTarget IS FALSE 


Banca.DurationProgress = 4000

Banca.Position = {
    {coords = vector3(-1212.9620, -330.9094, 37.7869), idBlip = 207, color = 2, nameBlip = 'Bank' }, -- FOR CHANCE BLIP GO TO THE SITE: https://docs.fivem.net/docs/game-references/blips/
    {coords = vector3(149.6093, -1040.6235, 29.3741),idBlip = 207, color = 2, nameBlip = 'Bank'},
    {coords = vector3(314.4630, -279.2312, 54.1708),idBlip = 207, color = 2, nameBlip = 'Bank'},
    {coords = vector3(-350.8557, -50.0222, 49.0426),idBlip = 207, color = 2, nameBlip = 'Bank'},
    {coords = vector3(-2962.6738, 483.0663, 15.7020),idBlip = 207, color = 2, nameBlip = 'Bank'},
    {coords = vector3(-113.1189, 6470.3525, 31.6267),idBlip = 207, color = 2, nameBlip = 'Bank'},
    {coords = vector3(247.4715, 223.2094, 106.2867),idBlip = 207, color = 2, nameBlip = 'Bank'},
}

Banca.Webhook = ''--INSERT YOUR WEBHOOK
```

