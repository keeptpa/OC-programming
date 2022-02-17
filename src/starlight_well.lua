local robot = require("robot")
local computer = require("computer")
local component = require("component")
local ic = component.inventory_controller
local generator = component.generator
local redstone = component.redstone

function init()
    print("Befor you input number, put astral egg on LEFT-TOP slot, mana egg on second, fuel on third.")
    print("and, fuelbox in front of, astral on top, mana back.")
    print("")
    print("Input the number of the light well(Just count liquid starlight well!)")
    print("total the well must be under 64!")
    length = tonumber(io.read())
end

function leftward()
    robot.turnLeft()
    robot.forward()
    robot.turnRight()
end

function empower()
    if(computer.energy()<=19000 and computer.energy()>=10000)
    then
        robot.select(3)
        generator.insert(1)

    elseif(computer.energy()<=10000)
    then
        computer.shutdown()
    end
end

function useegg()
    robot.select(1)
    ic.equip()
        for i=length,1,-1 do
        leftward()
        robot.use()
        end
    ic.equip()
    
    robot.select(2)
    ic.equip()
    robot.turnRight()
    robot.turnRight()
    for i=length,1,-1 do
        robot.use()
        leftward()
        end
    ic.equip()
    robot.turnRight()
    robot.turnRight()
end

function fillstack()
    robot.select(1)
    if(robot.count(1)~=64)
    then
        robot.suckUp(64-robot.count(1))
    end
    
    robot.select(2)
    if(robot.count(2)~=64)
    then
        robot.turnRight()
        robot.turnRight()
        robot.suck(64-robot.count(2))
        robot.turnRight()
        robot.turnRight()
    end
    
    robot.select(3)
    if(robot.count(3)~=64)
    then
        robot.suck(64-robot.count(3))
    end
end

init()
    while(true)
    do
        if(component.redstone.getInput(sides.bottom)>0)
        then
            useegg()
        end
        empower()
        fillstack()
        os.sleep(45)
       
    end
