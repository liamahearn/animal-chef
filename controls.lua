dpad = love.graphics.newImage("assets/controls/dPad.png")

--dpadX = 36
--dpadY = 832 

dpadX = 36
dpadY = 832 

-- topLeftx, topLefty, width, height

touchRegions = {

    {dpadX, dpadY, 156, 52}, -- top
    {dpadX, dpadY, 52, 156}, -- left
    {dpadX + 105, dpadY, 52, 156}, -- right
    {dpadX, dpadY + 105, 156, 52}, -- bottom

}

colorRegions = {

    {dpadX + 57, dpadY + 6, 42, 45}, -- top
    {dpadX + 6, dpadY + 57, 45, 42}, -- left
    {dpadX + 105, dpadY + 57, 45, 42}, -- right
    {dpadX + 57, dpadY + 106, 42, 45}, -- bottom

}

function showTouchRegions(inputList)

    local arrows = inputList

    local mouseDown = love.mouse.isDown(1)
    local x, y = love.mouse.getPosition( )

    x = x / scaleFactor
    y = y / scaleFactor

    for i=1, #touchRegions do
        love.graphics.rectangle('line', touchRegions[i][1], touchRegions[i][2], touchRegions[i][3], touchRegions[i][4])
        
        if(mouseDown and mouseOverlap(x, y, touchRegions[i]) or arrows[i] == 1) then
            love.graphics.rectangle('fill', colorRegions[i][1], colorRegions[i][2], colorRegions[i][3], colorRegions[i][4])
        end

    end

    love.graphics.print("mouseX: "..tostring(x), 10, 20)
    love.graphics.print("mouseY: "..tostring(y), 10, 30)

end

function mouseOverlap(mouseX, mouseY, region)

    return mouseX > region[1] and mouseX < region[1] + region[3] and mouseY > region[2] and mouseY < region[2] + region[4]

end

function displayDpad(inputList)

    showTouchRegions(inputList)
    love.graphics.draw(dpad, dpadX, dpadY)

end