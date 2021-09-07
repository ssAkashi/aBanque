Config = {
    getESX = 'esx:getSharedObject', -- votre trigger esx
    bannerMenuColor = {r = 0, g = 0, b = 0, opacity = 255}, -- couleur rgb du menu (bannière)
    posBank = {
        {
            Zones = "Zones1",
            x = 150.266,   y = -1040.203, z = 29.374
        },
        {
            Zones = "Zones2",
            x = -1212.980, y = -330.841,  z = 37.787
        },
        {
            Zones = "Zones3",
            x = -2962.582, y = 482.627,   z = 15.703
        },
        {
            Zones = "Zones4",
            x = -112.202,  y = 6469.295,  z = 31.626
        },
        {
            Zones = "Zones5",
            x = 314.187,   y = -278.621,  z = 54.170
        },
        {
            Zones = "Zones6",
            x = -351.534,  y = -49.529,   z = 49.042
        },
        {
            Zones = "Zones7",
            x = 241.727,   y = 220.706,   z = 106.286
        },
        {
            Zones = "Zones8",
            x = 1175.064,  y =2706.643,   z = 38.094
        },
    },
    posBlip = {
        { x = 150.266,   y = -1040.203, z = 29.374,  blipSprite = 277, colorBlip = 2, blipName = "Banque", blipScale = 0.9},
        { x = -1212.980, y = -330.841,  z = 37.787,  blipSprite = 277, colorBlip = 2, blipName = "Banque", blipScale = 0.9},
        { x = -2962.582, y = 482.627,   z = 15.703,  blipSprite = 277, colorBlip = 2, blipName = "Banque", blipScale = 0.9},
        { x = -112.202,  y = 6469.295,  z = 31.626,  blipSprite = 277, colorBlip = 2, blipName = "Banque", blipScale = 0.9},
        { x = 314.187,   y = -278.621,  z = 54.170,  blipSprite = 277, colorBlip = 2, blipName = "Banque", blipScale = 0.9},
        { x = -351.534,  y = -49.529,   z = 49.042,  blipSprite = 277, colorBlip = 2, blipName = "Banque", blipScale = 0.9},
        { x = 241.727,   y = 220.706,   z = 106.286, blipSprite = 277, colorBlip = 2, blipName = "Banque", blipScale = 0.9},
        { x = 1175.064,  y =2706.643,   z = 38.094,  blipSprite = 277, colorBlip = 2, blipName = "Banque", blipScale = 0.9},
    },
    posPed = {
        {x = 149.308, y = -1042.304, z = 28.368, heading = 340.044, pedModel = "ig_bankman"},
    },
    marker = {
        markerColor = {r = 255, g = 0, b = 0, a = 255}
    },
    bank = {
        enableLog = true,
        playerName = "", -- dont touch
    },
    -- dont touch
    bankMoney = 0,
    hasCreditCard = false,
    cardLoad = 0.0,
}