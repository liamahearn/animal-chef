local cT = {}

function initCustomers()

    cT = {}

    cStartX = -80
    cStartY = 300

    -- URL(1), xPos(2), yPos(3), width(4), height(5), timer(6), state(7), targetSeat(8)
    -- State:
        -- 0: Unselected
        -- 1: Heading to stand
        -- 2: Waiting at stand
        -- 3: Leaving stand

    table.insert(cT, {love.graphics.newImage("assets/customers/Poebus.png"), cStartX, cStartY+0.1, 51, 57, 0, 0, -1})
    table.insert(cT, {love.graphics.newImage("assets/customers/Darla.png"), cStartX, cStartY+0.2, 66, 60, 0, 0, -1})
    table.insert(cT, {love.graphics.newImage("assets/customers/Leia.png"), cStartX, cStartY+0.3, 63, 54, 0, 0, -1})
    table.insert(cT, {love.graphics.newImage("assets/customers/Zoro.png"), cStartX, cStartY+0.4, 51, 57, 0, 0, -1})
    table.insert(cT, {love.graphics.newImage("assets/customers/Benny.png"), cStartX, cStartY-0.4, 51, 57, 0, 0, -1})
    table.insert(cT, {love.graphics.newImage("assets/customers/FrankieDog.png"), cStartX, cStartY-0.3, 54, 63, 0, 0, -1})
    table.insert(cT, {love.graphics.newImage("assets/customers/BigMac.png"), cStartX, cStartY-0.2, 51, 57, 0, 0, -1})
    table.insert(cT, {love.graphics.newImage("assets/customers/Foebus.png"), cStartX, cStartY-0.1, 51, 57, 0, 0, -1})

    if next(cT) == nil then
        love.event.quit();
    end

    return cT

end



function updateCustomerPosition()

    for i = 1, #cT do
        local customer = cT[i]

        -- customer state (i.e. waiting)
        local cState = customer[7]

        -- customer's seat index
        local cIndex = customer[8]

        -- If customer approaching seat and x position matches seat position
        if(cState == 1 and customer[2] >= 192 + 48 * (cIndex-1)) then 
            -- Update user state to "arrived"
            cState = 2
            -- Set state of seat to "customer arrived, waiting for order"
            setServingState(cIndex, 2)
            -- should make an order here!
            -- pick from dishes 1 to "availableDishes"

            dishInfo = orderDish(cIndex)

            -- TESTING PURPOSES: ORDER FILLED
            
                if customer[6] > math.random(100, 250) then
                    cState = customerLeaves(i)
                end

            -- TESTING SECTION ENDED

            -- always increment the timer for each customer
            customer[6] = customer[6] + 1

        end
         
        -- DEBUG SECTION BEGIN
        if cState == 2 then
        
            if customer[6] > math.random(250, 450) then
                cState = customerLeaves(i)
                customer[6] = 0
            end

            customer[6] = customer[6] + 1

        end
        --DEBUG SECTION END



        -- If customer state is arriving or leaving, move horizontally
        if cState == 1 or cState == 3 then
            customer[2] = customer[2] + 2
            --customer[3] = customer[3] + (1 * math.sin(customer[2]/5.0))
        end

        -- Move diagonally down to table
        if cState == 1 and customer[2] >= 138 + 48 * (cIndex-1) then

            customer[3] = customer[3] + 1.4    
            customer[2] = customer[2] - 0.6

        end

        -- Move diagonally away from city
        if cState == 3 and customer[3] > cStartY then
            
            customer[3] = customer[3] - 1.4 
            customer[2] = customer[2] - 0.6   

        end

        -- if customer position exceeds screen, place back on left side
        if(customer[2] > 576) then

            customer[2] = cStartX
            cState = 0

        end 

        customer[7] = cState

    end



end

function customerLeaves(customerIndex)

    local customer = cT[customerIndex]

    -- set state to "Leaving Stand"
    customer[7] = 3

    -- set their seat to "available"
    local openSeat = customer[8]
    setServingState(openSeat, 0)

    -- set their dish request to complete

    setServingOrder(openSeat, -1)

    -- set target seat to None
    customer[8] = -1

    -- return state to be updated properly!
    return customer[7]

end

function orderDish(seatIndex) 

    local dishNum = math.random(1, availableDishes)
    setServingOrder(seatIndex, dishNum)

end

function drawOrderRequests()

    for i = 1, getOrdersLength() do

        local requestedDish = getOrderFromSeat(i)
        
        -- if an order is present, draw the item above the customer's head!
        if requestedDish ~= -1 then
            
            love.graphics.draw(menuTable[requestedDish][1], 192 + 48 * (i-1), 303)
            -- love.graphics.draw(speechBubble, 3 + 192 + 48 * (i-1), 303 + 48)

        end

    end

end

function sendCustomer(seatIndex)

    -- Obtains a customer to be sent out from left side of screen
    local customer = getAvailableCustomer(seatIndex)
    customer[7] = 1

end

function getAvailableCustomer(seatIndex)

    if(characterIndex == (#cT + 1)) then characterIndex = 1 end
    
    local loopCount = 0

    while(cT[characterIndex][7] ~= 0 and loopCount < #cT) do
        characterIndex = characterIndex + 1
        if characterIndex == (#cT + 1) then characterIndex = 1 end

        -- avoid infinite loop
        loopCount = loopCount + 1
        
    end

    cT[characterIndex][8] = seatIndex

    return cT[characterIndex]

end

function drawCustomers(T)

    table.sort(T, sortCustomers)

    for k, t in pairs(T) do
        -- only performs bobbing VISUALLY, in moving states
        if(t[7] == 2) then
            love.graphics.draw(t[1], t[2], t[3])
        else
            love.graphics.draw(t[1], t[2], t[3] + (2.5 * math.sin(t[2]/5.0)))
        end

        if(t[2] > 600) then t[2] = -70 end
    end

end

-- Z-Sorting Logic
function sortCustomers(c1, c2) 

    return c1[3] < c2[3]

end
