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

end

function controlChef()

    inputList = {0, 0, 0, 0}

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

function inputDpad(strings)

    local base = false
    local index = 0
    local mouseDown = love.mouse.isDown(1)
    local x, y = love.mouse.getPosition()

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

chef = initChef(1, 500, 500, 57, 60)