-- open -n -a love "/Users/liamahearn/Documents/LOVE2D/VersionControl/animal-chef"

require("customers")
require("chefs")
require("mapcollision")
require("menu")
require("controls")


function love.load() 
    map_ID = 1
    scaleFactor = 0.67
    
    love.window.setMode(576 * scaleFactor, 1024 * scaleFactor, {resizable=false})

    debug = 0

    availableDishes = 4

    cT = {}
    characterIndex = 1

    collisionZones = {}

    --mapTiles = initMapImg()
    mapTiles = initMapImg()

    customers = initCustomers()


    servingTiles = initServingTiles()

    -- Menu Table
    menuTable = {}

    -- Order Queue
    -- orderQueue = List.new()

    initMenuResources(map_ID)
    speechBubble = love.graphics.newImage("assets/menus/SpeechBubble.png")
    shadow = love.graphics.newImage("assets/effects/shadow1.png")

    collisionCode = 0

    arrowInputList = {0, 0, 0, 0, 0, 0}

    layers = {}

    initMapCollisionZones()

end

function love.update(dt)

    viewServingStates()

    updateCustomerPosition()

    arrowInputList = controlChef()

    layers = chefCounterLayering()

end

function love.draw()
    love.graphics.push()
    love.graphics.scale(scaleFactor, scaleFactor)

    drawMapTiles(mapTiles)

    drawCustomers(customers)

    -- drawDebugStates()

    drawServingTiles(servingTiles)


    -- draw order requests

    drawOrderRequests()

    -- draw chefs / stations

    drawLayers()

    displayDpad(arrowInputList)

    -- DEBUG: Draw Collision Zones and Display FPS
    if debug == 1 then 
        drawCollisionZones() 
        love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

    end

    love.graphics.pop()

end

-- FUNCTIONS

function drawLayers()

    for i = 1, #layers do

        if(layers[i][1] == "station1") then drawStation1() end
        if(layers[i][1] == "chef1") then drawChef() end
        if(layers[i][1] == "box1") then drawBox(1) end
        if(layers[i][1] == "box2") then drawBox(2) end
        if(layers[i][1] == "box3") then drawBox(3) end
        if(layers[i][1] == "trash1") then drawTrash() end

    end

end

