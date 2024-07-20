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

function drawMapTiles(T)

    for k, t in pairs(T) do

        love.graphics.draw(t[1], t[2], t[3])
        
    end

end

function drawStation1()

    love.graphics.draw(redStation, 70, 500)
    --love.graphics.rectangle("line", 0, 0, 200, 200)

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

    layers = {}

    -- insert code, then base y val
    table.insert(layers, {"red", 646})
    
    table.insert(layers, {"chef1", chef.y + chef.height})

    table.sort(layers, sortChefs)

end

-- Z-Sorting Logic
function sortChefs(c1, c2) 

    return c1[2] < c2[2]

end
