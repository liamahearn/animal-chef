local LEFT = 1
local RIGHT = -1

function initChef(chefNum, xPos, yPos, sprWidth, sprHeight)

    return {

        sprite = love.graphics.newImage("assets/chefs/chef" .. chefNum .. ".png"),
        x = xPos,
        y = yPos,
        width = sprWidth,
        height = sprHeight,
        timer = 0,
        state = 0,
        direction = LEFT

    }
     
end

function drawChef()

    -- draw shadow
    love.graphics.draw(shadow, chef.x + chef.height/2 - 13.5, chef.y + (chef.width - 3))

    -- only performs bobbing VISUALLY, in moving states

    if(chef.direction == LEFT) then

        if(chef.state == 0) then
            love.graphics.draw(chef.sprite, chef.x, chef.y, 0, 1, 1)
        elseif(chef.state == 1) then
            love.graphics.draw(chef.sprite, chef.x, chef.y + (2.5 * math.sin((chef.x)/5)) + (2.5 * math.sin((chef.y)/5)), 0, 1, 1)        
        end

    else

        if(chef.state == 0) then
            love.graphics.draw(chef.sprite, chef.x + chef.width, chef.y, 0, -1, 1)
        elseif(chef.state == 1) then
            love.graphics.draw(chef.sprite, chef.x + chef.width, chef.y + (2.5 * math.sin((chef.x)/5)) + (2.5 * math.sin((chef.y)/5)), 0, -1, 1)        
        end

    end    

    drawHeldItem()

    if(debug == 1) then
        love.graphics.rectangle("line", chef.x, chef.y, chef.width, chef.height)
    end

end

function controlChef()

    inputList = {0, 0, 0, 0, 0, 0}

    if(love.keyboard.isDown("up", "down", "left", "right") or inputDpad({"up", "down", "left", "right"})) then

        chef.state = 1   -- state set to moving
        
        if(love.keyboard.isDown("up") or inputDpad({"up"})) then

            inputList[1] = 1

            if(not checkCollisions(chef.x, chef.y - 3, chef.width, chef.height)) then

                if(love.keyboard.isDown("left", "right") or inputDpad({"left", "right"})) then
                    chef.y = chef.y - 2
                else
                    chef.y = chef.y - 3
                end
            end

        end
        
        if(love.keyboard.isDown("down") or inputDpad({"down"})) then

            inputList[4] = 1

            if(not checkCollisions(chef.x,chef.y+3,chef.width,chef.height)) then

                if(love.keyboard.isDown("left", "right") or inputDpad({"left", "right"})) then
                    chef.y = chef.y + 2
                else
                    chef.y = chef.y + 3
                end

            end
        end

        if(love.keyboard.isDown("left") or inputDpad({"left"})) then

            inputList[2] = 1
            
            if(not checkCollisions(chef.x - 3,chef.y,chef.width,chef.height)) then

                chef.direction = LEFT

                if(love.keyboard.isDown("up", "down") or inputDpad({"up", "down"})) then
                    chef.x = chef.x - 2
                else
                    chef.x = chef.x - 3
                end

            end
        end

        if(love.keyboard.isDown("right") or inputDpad({"right"})) then

            inputList[3] = 1

            if(not checkCollisions(chef.x + 3,chef.y,chef.width,chef.height)) then    

                chef.direction = RIGHT

                if(love.keyboard.isDown("up", "down") or inputDpad({"up", "down"})) then
                    chef.x = chef.x + 2
                else
                    chef.x = chef.x + 3
                end

            end
        end

        checkWraparound()

    elseif((not love.keyboard.isDown("up", "down", "left", "right", "z", "x")) and (not inputDpad({"up", "down", "left", "right"}))) then

        chef.state = 0 -- state set to idle

    end

    if(love.keyboard.isDown("z", "x") or inputButton({'z', 'x'})) then

        if(love.keyboard.isDown('x') or inputButton({'x'})) then
            inputList[5] = 1
        end

        if(love.keyboard.isDown('z') or inputButton({'z'})) then
            inputList[6] = 1
        end

    end

    return inputList

end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end

function checkWraparound()

    if(chef.x > 576 + 60) then
        chef.x = - 60
    end

    if(chef.x < -60) then
        chef.x = 636
    end

    -- shhhh, secret!
    if(chef.y > 1084) then chef.y = -60 end
    if(chef.y < -60) then chef.y = 1084 end

end

function checkCollisions(x, y, w, h)

    collisionCode = 0

    for i = 1, #collisionZones do

        if(CheckCollision(x, y, w, h, collisionZones[i][1], collisionZones[i][2], collisionZones[i][3], collisionZones[i][4])) then 
            collisionCode = 1 
        end

    end

    return (collisionCode == 1)

end

function updateInteractions()

    for i = 1, #interactionZones do

        if(CheckCollision(chef.x, chef.y, chef.width, chef.height, interactionZones[i][1], interactionZones[i][2], interactionZones[i][3], interactionZones[i][4])) then 
            interactionZones[i][6] = 1
        else
            interactionZones[i][6] = 0
        end

    end

end

function inputDpad(strings)

    local base = false
    local index = 0
    local mouseDown = love.mouse.isDown(1)
    local x, y = love.mouse.getPosition()

    x = x / scaleFactor
    y = y / scaleFactor


    for key, str in pairs(strings) do

        if str == "up" then index = 1
        elseif str == "left" then index = 2
        elseif str == "right" then index = 3
        elseif str == "down" then index = 4
        end

        base = base or (mouseDown and mouseOverlap(x, y, touchRegions[index]))

    end 

    return base

end

function inputButton(strings)

    local base = false
    local index = 0
    local mouseDown = love.mouse.isDown(1)
    local x, y = love.mouse.getPosition()

    x = x / scaleFactor
    y = y / scaleFactor


    for key, str in pairs(strings) do

        if str == 'x' then index = 1
        elseif str == 'z' then index = 2
        end

        base = base or (mouseDown and mouseOverlap(x, y, buttonRegions[index]))

    end 

    return base

end

function holdingInteractions()


    -- if interact with trash, set holding ID to 0
    if(interactionZones[4][6] == 1 and arrowInputList[5] == 1) then
        held = 0
        return
    end    

    if(held == 0) then
        if(interactionZones[1][6] == 1 and arrowInputList[5] == 1) then
            held = 1
            return
        end  
        if(interactionZones[2][6] == 1 and arrowInputList[5] == 1) then
            held = 2
            return
        end  
        if(interactionZones[3][6] == 1 and arrowInputList[5] == 1) then
            held = 3
            return
        end  
    end


end

function drawHeldItem()

    if(held == 0) then return end
    if(held > 0 and held < 4) then
        if(held == 1) then
            love.graphics.draw(bananaOutline, chef.x + 3, chef.y - 22 + (2.5 * math.sin((chef.x)/5)) + (2.5 * math.sin((chef.y)/5)))
        end
        if(held == 2) then
            love.graphics.draw(blueberryOutline, chef.x + 3, chef.y - 22 + (2.5 * math.sin((chef.x)/5)) + (2.5 * math.sin((chef.y)/5)))
        end
        if(held == 3) then
            love.graphics.draw(strawberryOutline, chef.x + 3, chef.y - 22 + (2.5 * math.sin((chef.x)/5)) + (2.5 * math.sin((chef.y)/5)))
        end
    end



end

chef = initChef(1, 500, 500, 57, 60)