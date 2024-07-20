-- open -n -a love "/Users/liamahearn/Documents/LOVE2D/ProjectOrganize"

require("customers")
require("chefs")
require("mapcollision")
require("menu")
require("controls")


function love.load() 
    map_ID = 1
    scaleFactor = 0.67
    
    love.window.setMode(576 * scaleFactor, 1024 * scaleFactor, {resizable=false})

    debug = 1

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
    redStation = love.graphics.newImage("assets/maps/map1/STATIONS/RedStation.png")

    collisionCode = 0

    arrowInputList = {0, 0, 0, 0}

    layers = {}

    --inst. collision zones

        --main fence
        addCollisionZone(-120, 390, 576 + 240, 20)

        -- bottom barrier
        addCollisionZone(-120, 1020, 500 + 120, 120)
        addCollisionZone(576, 1020, 300, 120)
        
        -- top barrier
        addCollisionZone(-120, -120, 500 + 120, 120 + 4)
        addCollisionZone(576, -120, 20, 340)

        --island barriers
        addCollisionZone(400, 115, 200, 30)
        addCollisionZone(400, 0, 20, 150)
        addCollisionZone(420, 75, 45, 50)

        -- red station (1)
        addCollisionZone(78, 602, 130, 5)
        addCollisionZone(78, 512, 38, 90)

end

function love.update(dt)

    viewServingStates()

    updateCustomerPosition()

    arrowInputList = controlChef()

    chefCounterLayering()

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


    -- DEBUG: Draw Collision Zones
    if debug == 1 then drawCollisionZones() end


    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

    love.graphics.pop()

end

-- FUNCTIONS

function drawLayers()

    for i = 1, #layers do

        if(layers[i][1] == "red") then drawStation1() end
        if(layers[i][1] == "chef1") then drawChef() end

    end

end

