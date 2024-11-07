-- dpad = love.graphics.newImage("assets/controls/dPad.png")

-- dpadX = 36
-- dpadY = 832 
-- dpadW = 156

dpad = love.graphics.newImage("assets/controls/dPad4x.png")

dpadX = 30
dpadY = 780
dpadW = 208

-- topLeftx, topLefty, width, height

touchRegions = {

    {dpadX, dpadY, dpadW, dpadW/3}, -- top
    {dpadX, dpadY, dpadW/3, dpadW}, -- left
    {dpadX + dpadW * 2 / 3, dpadY, dpadW/3, dpadW}, -- right
    {dpadX, dpadY + dpadW * 2 / 3, dpadW, dpadW/3}, -- bottom

}

colorRegions = {

    {dpadX + dpadW * 0.365, dpadY + 6, dpadW*0.27, dpadW*0.29}, -- top
    {dpadX + 6, dpadY + dpadW * 0.365, dpadW*0.29, dpadW*0.27}, -- left
    {dpadX + dpadW * 2 / 3, dpadY + dpadW * 0.365, dpadW*0.29, dpadW*0.27}, -- right
    {dpadX + dpadW * 0.365, dpadY + dpadW * 2 / 3, dpadW*0.27, dpadW*0.29}, -- bottom

}

aButton = love.graphics.newImage("assets/controls/aButton4x.png")
bButton = love.graphics.newImage("assets/controls/bButton4x.png")

-- topLeftx, topLefty, width, height

aButtonX = 450
aButtonY = 805

bButtonX = 375
bButtonY = 900

buttonWidth = 72


buttonRegions = {

    {aButtonX - 10, aButtonY - 10, buttonWidth + 20, buttonWidth + 20}, -- A
    {bButtonX - 10, bButtonY - 10, buttonWidth + 20, buttonWidth + 20}  -- B

}

buttonFillRegions = {

    {aButtonX + 6, aButtonY + 6, buttonWidth - 12, buttonWidth - 12}, -- A
    {bButtonX + 6, bButtonY + 6, buttonWidth - 12, buttonWidth - 12}  -- B

}


function showTouchRegions(inputList)

    local arrows = inputList

    local mouseDown = love.mouse.isDown(1)
    local x, y = love.mouse.getPosition( )

    x = x / scaleFactor
    y = y / scaleFactor

    for i=1, #touchRegions do
    
        if (debug == 1) then
            love.graphics.rectangle('line', touchRegions[i][1], touchRegions[i][2], touchRegions[i][3], touchRegions[i][4])
        end

        if(mouseDown and mouseOverlap(x, y, touchRegions[i]) or arrows[i] == 1) then
            love.graphics.rectangle('fill', colorRegions[i][1], colorRegions[i][2], colorRegions[i][3], colorRegions[i][4])
        end

    end

    for i=1, #buttonRegions do
        
        if (debug == 1) then
            love.graphics.rectangle('line', buttonRegions[i][1], buttonRegions[i][2], buttonRegions[i][3], buttonRegions[i][4])
        end

        if(mouseDown and mouseOverlap(x, y, buttonRegions[i]) or arrows[i + 4] == 1) then
            love.graphics.rectangle('fill', buttonFillRegions[i][1], buttonFillRegions[i][2], buttonFillRegions[i][3], buttonFillRegions[i][4])
        end

    end

    if (debug == 1) then
        love.graphics.print("mouseX: "..tostring(x), 10, 20)
        love.graphics.print("mouseY: "..tostring(y), 10, 30)
    end

end

function mouseOverlap(mouseX, mouseY, region)

    return mouseX > region[1] and mouseX < region[1] + region[3] and mouseY > region[2] and mouseY < region[2] + region[4]

end

function displayDpad(inputList)

    showTouchRegions(inputList)
    love.graphics.draw(dpad, dpadX, dpadY)
    love.graphics.draw(aButton, aButtonX, aButtonY)
    love.graphics.draw(bButton, bButtonX, bButtonY)

end