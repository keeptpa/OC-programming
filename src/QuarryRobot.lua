local ro = require("robot")
local co = require("computer")
local component = require("component")
local inv = component.inventory_controller

function powerc()
     power = co.energy() / co.maxEnergy()
    return power
end

function init()
    print("Please input the robots' sea level now")
    sea_level = tonumber(io.read())
    --Init left-hand system
    x=0
    y=0
    z=0
    direction= 0
    --  > = 1 and v = 2 , the robot's working route is like a letter M ,so it has only 3 face direction, one of em is no need to adjust.
    print("Please input the quarry's length you like")
    length = tonumber(io.read())
end

function back_home(temp)
    local x,y,z,direction
    x = temp[1]
    y = temp[2]
    z = temp[3]
    direction = temp[4]
    --First of all ,turn to right direction.
    while(direction ~=0)
        do
        ro.turnLeft()
        direction = direction-1
    end
    -- And, go back to home.
    while (x~=0 or y~=0 or z~=0)
        do
        while(y~=0)
            do
            ro.up()
            y = y-1
            end
        ro.turnLeft()
        while(x~=0)
            do
            ro.forward()
            x = x-1
            end
        ro.turnRight()
        while(z~=0)
            do
            ro.back()
            z = z-1
            end
    end
    ro.back() --back to base position
     
    ro.select(1)
    inv.equip()
    ro.dropDown()
    inv.equip()
end

function back_work(temp)
    local x,y,z,direction
    x = temp[1]
    y = temp[2]
    z = temp[3]
    direction = temp[4]
    ro.select(1)
          while(ro.suckDown()==false)
          do
               ro.suckDown()
               os.sleep(5)
          end
    inv.equip()
     
    ro.forward()
    while (x~=0 or y~=0 or z~=0)
    do
        ro.turnRight()
        while(x~=0)
        do
            ro.forward()
            x = x-1
        end
        ro.turnLeft()
        while(z~=0)
        do
            ro.forward()
            z = z-1
        end
        while(y~=0)
        do
            ro.down()
            y = y-1
        end
    end
        while(direction~=0)
        do
            ro.turnRight()
            direction=direction-1
        end
end

function empty()
    local slot = 1
    while (ro.count(ro.inventorySize())~=0)
        do
        ro.select(slot)
        ro.dropUp()
        slot = slot+1
    end
    slot = 1
    ro.select(slot)
end

function check()
    local temp ={}
    temp[1] = x
    temp[2] = y
    temp[3] = z
    temp[4] = direction
    if (powerc() <= 0.2 or ro.count(ro.inventorySize()) >= 1)
        then
        back_home(temp)
        while(ro.count(ro.inventorySize()) >= 1)
            do
            empty()
        end
        while(powerc() <= 0.9)
            do
            os.sleep(5)
            end
        os.sleep(10)
        back_work(temp)
    end
end

function back00()
    while(direction~=0)
        do
        ro.turnLeft()
        direction=direction-1
    end

    while(z~=0)
        do
        ro.back()
        z=z-1
    end

    ro.turnLeft()
    while(x~=0)
        do
        ro.forward()
        x=x-1
    end
    ro.turnRight()
    ro.down()
    y=y+1
end

function quarry()
    local i = 0
    while(x~=length or y~=length or z~=sea_level-10)
    do
        while(i<length-1)
        do
            check()
            ro.swingDown()
            i=i+1
            ro.forward()
            z=z+1
        end

        ro.swingDown()
        i=0
        -----
        if(x==length-1)
        then
            back00()
            break
        end

    ro.turnRight()
    direction=direction+1
    ro.forward()
    x=x+1
    ro.turnRight()
    direction=direction+1
    while(i<length-1)
    do
    check()
    ro.swingDown()
    i=i+1
    ro.forward()
    z=z-1
    end


    ro.swingDown()
    i=0
        if(x==length-1)
        then
            back00()
            break
        end

        if(y==sea_level-10)
        then
            break
        end
    -----
    ro.turnLeft()
    direction=direction-1
        ro.forward()
        x=x+1
        ro.turnLeft()
        direction=direction-1
        end

end


init()
ro.forward()
while(y~=sea_level-10)
    do
    quarry()
end
local temp = {}
temp[1] = x
temp[2] = y
temp[3] = z
temp[4] = direction
back_home(temp)
