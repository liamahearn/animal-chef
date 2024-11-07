-- Map Assets
blenderStation = love.graphics.newImage("assets/maps/map1/STATIONS/LargeTableBase.png")
blenderStationOutline = love.graphics.newImage("assets/maps/map1/STATIONS/LargeTableBaseOutline.png")
blenderStates = {
    love.graphics.newImage("assets/maps/map1/STATIONS/Blender/Blender000.png"),
    love.graphics.newImage("assets/maps/map1/STATIONS/Blender/Blender001.png"),
    love.graphics.newImage("assets/maps/map1/STATIONS/Blender/Blender010.png"),
    love.graphics.newImage("assets/maps/map1/STATIONS/Blender/Blender100.png"),
    love.graphics.newImage("assets/maps/map1/STATIONS/Blender/Blender011.png"),
    love.graphics.newImage("assets/maps/map1/STATIONS/Blender/Blender110.png"),
    love.graphics.newImage("assets/maps/map1/STATIONS/Blender/Blender101.png"),
    love.graphics.newImage("assets/maps/map1/STATIONS/Blender/Blender111.png")
}

box = love.graphics.newImage("assets/maps/map1/STATIONS/Box.png")
openBox = love.graphics.newImage("assets/maps/map1/STATIONS/OpenBox.png")
trash = love.graphics.newImage("assets/maps/map1/STATIONS/TrashBox.png")
boxHighlight = love.graphics.newImage("assets/maps/map1/STATIONS/BoxHighlight.png")

bananaOutline = love.graphics.newImage("assets/menus/menu2/bananaOutline.png")
blueberryOutline = love.graphics.newImage("assets/menus/menu2/blueberryOutline.png")
strawberryOutline = love.graphics.newImage("assets/menus/menu2/strawberryOutline.png")

-- Returns Map Image Resources
function initMapImg()
    local mT = {}

    if(map_ID == 1) then
        table.insert(mT, {love.graphics.newImage("assets/maps/map1/BASE.png"), 0, 0})
        table.insert(mT, {love.graphics.newImage("assets/maps/map1/PATH.png"), 0, 256})
    end

    -- Insert New Map Data Here


    if next(mT) == nil then
        love.event.quit();
    end

    return mT

end

function initMapInteractionZones()
    -- x, y, w, h, id, state
    -- boxes
    addInteractionZone(53, 685, 80, 80, 1, 0) -- box 1, id = 1
    addInteractionZone(53 + 192, 685, 80, 80, 2, 0) -- box 2, id = 2
    addInteractionZone(53 + 192 + 192, 685, 80, 80, 3, 0) -- box 3, id = 3
    -- trash
    addInteractionZone(53 + 192 + 192, 500, 80, 80, 4, 0) -- trash, id = 4
    -- table
    addInteractionZone(50, 500, 115, 110, 5, 0) -- table, id = 5

end

function initMapCollisionZones()
    -- main fence
    addCollisionZone(-120, 390, 816, 20)

    -- bottom barrier
    addCollisionZone(-120, 1020, 620, 120)
    addCollisionZone(576, 1020, 300, 120)

    -- top barrier
    addCollisionZone(-120, -120, 620, 124)
    addCollisionZone(576, -120, 20, 340)

    -- island barriers
    addCollisionZone(400, 115, 200, 30)
    addCollisionZone(400, 0, 20, 150)
    addCollisionZone(420, 75, 45, 50)

    -- blender station
    addCollisionZone(78, 525, 82, 4)
    addCollisionZone(78, 530, 30, 50)

    -- boxes (spaced 192 apart)
    addCollisionZone(78, 710, 32, 4)
    addCollisionZone(270, 710, 32, 4)
    addCollisionZone(462, 710, 32, 4)

    -- trash
    addCollisionZone(462, 525, 32, 4)

end

function initSelectZones()

    addSelectZone()

end

function drawMapTiles(T)

    for k, t in pairs(T) do

        love.graphics.draw(t[1], t[2], t[3])
        
    end

end

function addCollisionZone(x, y, w, h)

    table.insert(collisionZones, {x, y, w, h})

end

function addInteractionZone(x, y, w, h, id)

    table.insert(interactionZones, {x, y, w, h, id})

end

function addSelectZone(x, y, w, h)
    
    table.insert(selectZones, {x, y, w, h})

end

function drawCollisionZones()

    for i = 1, #collisionZones do

        love.graphics.rectangle("line", collisionZones[i][1], collisionZones[i][2], collisionZones[i][3], collisionZones[i][4])

    end

    -- draw interactionZones too I guess

    for i = 1, #interactionZones do

        love.graphics.rectangle("line", interactionZones[i][1], interactionZones[i][2], interactionZones[i][3], interactionZones[i][4])

    end

end


function chefCounterLayering()

    local mapLayers = {}

    -- insert code, then base y val
    table.insert(mapLayers, {"station1", 550})
    
    table.insert(mapLayers, {"chef1", chef.y + chef.height})

    table.insert(mapLayers, {"box1", 748})
    table.insert(mapLayers, {"box2", 748})
    table.insert(mapLayers, {"box3", 748})

    table.insert(mapLayers, {"trash1", 548})

    table.sort(mapLayers, sortChefs)

    -- return layers in order
    return mapLayers

end

-- Z-Sorting Logic
function sortChefs(c1, c2) 

    return c1[2] < c2[2]

end

function drawStation1()

    if(interactionZones[5][6] == 1) then
        love.graphics.draw(blenderStationOutline, 70, 500)
    else    
        love.graphics.draw(blenderStation, 70, 500)
    end

    drawBlender()

end

function drawBlender()

    -- base state blender
    love.graphics.draw(blenderStates[1], 70, 500)

    -- highlight blender?

end

function drawBox(boxID)

    distanceConst = 192
    
    -- draw the highlight outline  and open box if applicable
    if(interactionZones[boxID][6] == 1) then
        -- draw the box, farther over depending on its ID
        love.graphics.draw(openBox, 70 + distanceConst * (boxID - 1), 700)
        love.graphics.draw(boxHighlight, 70 + distanceConst * (boxID - 1), 700)
    else
        -- draw the box, farther over depending on its ID
        love.graphics.draw(box, 70 + distanceConst * (boxID - 1), 700)
    end

end

function drawTrash()

    love.graphics.draw(trash, 454, 512)
    if(interactionZones[4][6] == 1) then
        love.graphics.draw(boxHighlight, 454, 512)
    end

end

function drawFloatingIngredients()

    alpha = 0.7

    love.graphics.setColor(255,255,255,alpha)

    if(interactionZones[1][6] == 1) then
        love.graphics.setColor(255,255,255,255)
    else
        love.graphics.setColor(255,255,255,alpha)
    end
    love.graphics.draw(bananaOutline, 70, 710 - 44 + 2*math.sin(timeLoop/10))
    
    
    if(interactionZones[2][6] == 1) then
        love.graphics.setColor(255,255,255,255)
    else
        love.graphics.setColor(255,255,255,alpha)
    end
    love.graphics.draw(blueberryOutline, 262, 710 - 44 + 2*math.sin((timeLoop + 15)/10))

    if(interactionZones[3][6] == 1) then
        love.graphics.setColor(255,255,255,255)
    else 
        love.graphics.setColor(255,255,255,alpha)
    end
    love.graphics.draw(strawberryOutline, 454, 710 - 44 + 2*math.sin((timeLoop + 30)/10))
    love.graphics.setColor(255,255,255,255)

end