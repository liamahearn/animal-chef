-- Serving States:
    -- 0: Unclaimed
    -- 1: Claimed, Arriving
    -- 2: Claimed, Waiting

-- servingStates is used to keep track of what is happening with the seat itself, whether open or in use
local servingStates = {0, 0, 0, 0}

function setServingState(seatNum, value)

    servingStates[seatNum] = value

end

-- servingOrders is used to keep track of what dish is being requested 
local servingOrders = {-1, -1, -1, -1}

function setServingOrder(seatNum, value)

    servingOrders[seatNum] = value

end

function getOrderFromSeat(seatNum)

    return servingOrders[seatNum]

end

function getOrdersLength() return #servingOrders end

function initServingTiles()

    local sT = {}

    if(map_ID == 1) then
        table.insert(sT, {love.graphics.newImage("assets/maps/map1/SERVING.png"), 0, 400})
    end

    -- Insert New Map Data Here


    if next(sT) == nil then
        love.event.quit();
    end

    return sT

end

function drawServingTiles(T)

    for k, t in pairs(T) do
        love.graphics.draw(t[1], t[2], t[3])
    end

end

function viewServingStates()

    for i = 1, #servingStates do
        if(servingStates[i] == 0) then
            sendCustomer(i)
            servingStates[i] = 1
        end
    end

end


function initMenuResources(map_ID)

    if(map_ID == 1) then
        table.insert(menuTable, {love.graphics.newImage("assets/menus/menu1/Taco.png")})
        table.insert(menuTable, {love.graphics.newImage("assets/menus/menu1/Cookie.png")})
        table.insert(menuTable, {love.graphics.newImage("assets/menus/menu1/FrenchFries.png")})
        table.insert(menuTable, {love.graphics.newImage("assets/menus/menu1/Ramen.png")})
    end

    -- Insert New Menu Data Here

    if next(menuTable) == nil then
        love.event.quit();
    end


end

