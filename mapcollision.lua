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
trash = love.graphics.newImage("assets/maps/map1/STATIONS/TrashBox.png")

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

function initMapCollisionZones()
    -- main fence
    addCollisionZone(-120, 390, 576 + 240, 20)

    -- bottom barrier
    addCollisionZone(-120, 1020, 500 + 120, 120)
    addCollisionZone(576, 1020, 300, 120)

    -- top barrier
    addCollisionZone(-120, -120, 500 + 120, 120 + 4)
    addCollisionZone(576, -120, 20, 340)

    -- island barriers
    addCollisionZone(400, 115, 200, 30)
    addCollisionZone(400, 0, 20, 150)
    addCollisionZone(420, 75, 45, 50)

    -- blender station
    addCollisionZone(78, 525, 82, 4)
    addCollisionZone(78, 530, 30, 50)

    -- boxes
    addCollisionZone(78, 710, 32, 4)
    addCollisionZone(78 + 192, 710, 32, 4)
    addCollisionZone(78 + 192 + 192, 710, 32, 4)

    -- trash
    addCollisionZone(78 + 192 + 192, 525, 32, 4)

end

function drawMapTiles(T)

    for k, t in pairs(T) do

        love.graphics.draw(t[1], t[2], t[3])
        
    end

end

function addCollisionZone(x, y, w, h)

    table.insert(collisionZones, {x, y, w, h})

end

function drawCollisionZones()

    for i = 1, #collisionZones do

        love.graphics.rectangle("line", collisionZones[i][1], collisionZones[i][2], collisionZones[i][3], collisionZones[i][4])

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

    love.graphics.draw(blenderStation, 70, 500)

end

function drawBox(boxID)

    distanceConst = 192
    love.graphics.draw(box, 70 + distanceConst * (boxID - 1), 700)

end

function drawTrash()

    love.graphics.draw(trash, 70 + 192 + 192, 512)

end