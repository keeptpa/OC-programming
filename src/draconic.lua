local computer = require("computer")
local component = require("component")
local term = require("term")

--component.proxy(component.list("draconic")()).getReactorInfo()

function init()
if(component.list("draconic") ~= nil)
then
        print("Welcome, the power of draconic will serves you.")
        print("Draconic Reactor detected, initiating data.")
        reactor = component.proxy(component.list("draconic")())
::command::
    print("Give me a command to charge.(Y/n)")
    command1 = tostring(io.read())
    if(command1 == "Y")
    then
        charge()
    elseif (command1 == "n")
    then
        stopReactor()
    else
        print("You should follow the rule.")
        goto command
    end
    else
        computer.beep(600,0.2)
        computer.beep(600,0.2)
        print("Didn't detected any Draconic Reactor!")
    end
end

function readInfo()
reactorinfo = component.proxy(component.list("draconic")()).getReactorInfo()
--.
fieldDrain = reactorinfo["fieldDrainRate"] -- 约束力场消耗速率
fuelConversion = reactorinfo["fuelConversion"] -- 燃料转化值
fuelConversionRate = reactorinfo["fuelConversionRate"] -- 燃料转化率——我们需要混沌碎片么？
generation = reactorinfo["generationRate"] --龙堆发电量
failsafe = tostring(reactorinfo["failsafe"]) --失控保护：这玩意其实只能保证燃料烧光就停机，真失控了他跑得比你都快
status = reactorinfo["status"] -- 以直观感受描述反应堆状态
-- !
temp = reactorinfo["temperature"] --大约不需要解释
field = reactorinfo["fieldStrength"] --反应堆当前约束力场
maxfield = reactorinfo["maxFieldStrength"] -- 反应堆约束力场能达到的最大值
energy = reactorinfo["energySaturation"] --可理解为反应堆的能量缓存，不可过低，因此必须控制能量抽取速度
end

function charge()
reactor.chargeReactor()
    readInfo()
    local fieldrate = component.proxy(component.list("draconic")()).getReactorInfo()["fieldStrength"] / component.proxy(component.list("draconic")()).getReactorInfo()["maxFieldStrength"]
    while( fieldrate < 0.5 or temp < 2000)
    do
        readInfo()
        fieldrate = component.proxy(component.list("draconic")()).getReactorInfo()["fieldStrength"] / component.proxy(component.list("draconic")()).getReactorInfo()["maxFieldStrength"]
        term.clear()
        print("Warming up. Serves upcoming...")
        print("Field strength rate:" .. tostring(fieldrate))
        print("Temp: " .. tostring(temp))
        os.sleep(1)
    end
::commander::
    print("Charged. Give me a command to activate.(Y/n)")
    command = tostring(io.read())
    if(command == "Y")
    then
        activateReactor()
    elseif (command == "n")
    then
        stopReactor()
    else
        print("You should follow the rule.")
        goto commander
    end
end

function activateReactor()
    reactor.activateReactor()
    print("Your wish come true. Just wait for a minute")
    print("Redirecting to Reactor Maintaining System(RMS)....") -- 反应堆移交反应堆维护管理系统
end

function stopReactor()
reactor.stopReactor()
print("It's okay. Time will wait.")
end

function rms() -- 反应堆最重要的系统，监视、上报、闭环控制
    print("RMS inited. Now let us get everything in position.")
    if(temp <= 7500 and temp > 3000)-- 这其实是比较保守，并非最大的温度设置。
    then
        monitor() -- 上报
        print("Everything normal.")
    elseif (temp > 7500)
    then
    monitor()
    print("WARN: Getting hot, I'm trying decrease energy output.")
    --CONTROL FLUX GATE O HERE
    
    elseif(temp <= 3000 )
    then
    monitor()
    print("Ah, a bit cold. Increasing the energy output.")
    --CONTROL FLUX GATE O HERE
    
    elseif (component.proxy(component.list("draconic")()).getReactorInfo()["fieldStrength"] / component.proxy(component.list("draconic")()).getReactorInfo()["maxFieldStrength"] <= 0.2 )
    then
    computer.beep(1200,5)
    monitor()
    print("WARNING: Field dropping, I'm trying to increase energy input!")
    --CONTROL FLUX GATE I HERE
    stopReactor()
    end
    
end

function monitor()
term.clear()
    print("Field Drain: " .. tostring(fieldDrain))
    print("Fuel Conversion: " .. tostring(fuelConversion))
    print("Fuel Conversion Rate: " .. tostring(fuelConversionRate))
    print("RF producing: " .. tostring(generation))
    print("Failsafe: " .. tostring(failsafe))
    print("Status: " .. tostring(status))
-- !
    print("Temp: " .. tostring(temp))
    print("Field: " .. tostring(field))
    print("Field Max: " .. tostring(maxfield))
    print("Engergy: " .. tostring( energy))
end

init()
while(true)
do
readInfo()
term.clear()
rms()
os.sleep(1)
end
