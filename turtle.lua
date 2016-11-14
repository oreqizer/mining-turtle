--README
        -- This turtle tunneling program is based on fixed default points (DP), from where all the actions (mirror-tunnel walls, tunnels, returns to chest, transitions to next tunnel etc.) are executed. These points are ALWAYS at the beginning of the tunnel, aimed alongside its entrance, away from the chest where it starts from.
 
        -- START POSITION (SP): make sure the turtle is placed next to a chest, away from the chest. This is where all its valuable findings will be stored, otherwise they will simply be thrown away. The turtle starts digging when it reaches a block, to allow for continuous tunnel chaining.
        -- Always check if all the required materials are in the correct slots of the turtle before start, or it may either: run out of fuel, stone, torches, not filter items you want or filter items you do NOT want it to filter.
 
        -- This program uses base variables multiple times, so I will list them here, with some lesser ones being noted later when they are used:
                -- x, y, z: coordinates of the tunnel's width, height and depth
                -- a, b, c: help display the current position of how far away from the respective coordinate's beginning the turtle is currently located ('a' can get its value reversed, as it is used for both from left to right, and right to left operations)
                -- tunnels: how many tunnels the user requested
                -- done: how many tunnels were fully dug
                -- orient: orientation of the tunnels (all right, all left or both sides evenly)
                -- back: distance of the current DP from the SP
                -- wallSide: which wall opposite of a tunnel is being built
                -- walls: whether to build walls or not
                -- torch: whether to place torches or not
                -- off: offset, how far did the turtle travel before reaching the first block, where it starts digging
        -- I have created multiple lesser functions to help the user experience and give the turtle a lot more autonomy. They may seem inferior, but trust me, they saved me a LOT of time and nerves. The functions are always named according to what they do, it should be pretty obvious. More complex functions will have notes alongside.
--README END
 
function getReady() -- tells basic information for the user what is needed for the turtle to function
        shell.run("clear")
        print "First tunnel goes right. Place me right in front of a chest."
        print ""
        print "Slots:"
        print "1: cobblestone, 2, 3: things to dump"
        print "Something shiny: 4"
        print "Fuel 5"
        print "16: torches (optional)"
        print "Add these before start or I may mess up! Press enter when ready."
        io.read()
end
 
function noFuel() -- makes sure you add enough fuel for it to function properly
        print "Add fuel to slot 5 to continue..."
        turtle.select(5)
        while turtle.getFuelLevel() == 0 do
                turtle.refuel(3)
                sleep(1)
        end
        print "Thanks, minion!"
end
 
function loadFuel() -- refuels itself with anything usable in the inventory
        if turtle.getFuelLevel() < 200 then
                for i = 1, 16 do
                        turtle.select(i)
                        turtle.refuel(3)
                end
        end
        if turtle.getFuelLevel() == 0 then
                noFuel()
        end
end
 
function unload() -- throws away trash
        items = turtle.getItemCount(1)
        if items >= 48 then
                turtle.select(1)
                turtle.drop(items - 48)
        end    
        items = turtle.getItemCount(2)
        if items >= 16 then
                turtle.select(2)
                turtle.drop(items - 1)
        end    
        items = turtle.getItemCount(3)
        if items >= 16 then
                turtle.select(3)
                turtle.drop(items - 1)
        end
        items = nil
end
 
function placeTorch() -- guess what this one does LOL
        bck()
        turtle.select(16)
        turtle.placeUp()
        turtle.select(1)
        fwd()
end
 
function stoneCheck() -- makes sure the turtle has enough stones to function like it should
        if turtle.getItemCount(1) > 1 then
                turtle.select(1)
        else
                print "Add cobblestone to slot 1 to continue..."
                while turtle.getItemCount(1) == 1 do
                        sleep(0.5)
                end
                print "Thanks, minion!"
        end
end
 
function block() -- block() functions are for placing block if needed, to prevent lava/water flow into tunnels
        if not turtle.detect() then
                stoneCheck()
                turtle.place()
        end
end
 
function blockUp()
        if not turtle.detectUp() then
                stoneCheck()
                turtle.placeUp()
        end
end
 
function blockDown()
        if not turtle.detectDown() then
                stoneCheck()
                turtle.placeDown()
        end
end
 
function verticalBlocks(y, b) -- used multiple times in bigger functions for placing vertical blocks
        if b == 1 then
                blockDown()
        end
        if b == y then
                blockUp()
        end
end
 
function digLoop() -- digLoops make sure no gravel, sand or anti-gravity matter gets in the way
        while turtle.detect() do
                turtle.dig()
                sleep(0.6)
        end
end
 
function digUpLoop()
        while turtle.detectUp() do
                turtle.digUp()
                sleep(0.6)
        end
end
 
function digDownLoop()
        while turtle.detectDown() do
                turtle.digDown()
                sleep(0.6)
        end
end
 
function fwd() -- basic movement functions. these are responsible for the fixed point orientation, which means less flexibility, but much more reliability
        while not turtle.forward() do
                print "GTFO"
                digLoop()
                sleep(2)
        end
end
 
function up()
        while not turtle.up() do
                print "GTFO"
                digUpLoop()
                sleep(2)
        end
end
 
function dwn()
        while not turtle.down() do
                print "GTFO"
                digDownLoop()
                sleep(2)
        end
end
 
function bck()
        while not turtle.back() do
                print "GTFO"
                turtle.turnRight()
                turtle.turnRight()
                digLoop()
                turtle.turnRight()
                turtle.turnRight()
                sleep(2)
        end
end
 
-- COMPLEX FUNCTIONS:
-- these are functions directly responsible for the digging of the tunnels. xAxisL/R dig blocks and fill the surrounding with cobblestone against lava and water. yAxisL/R make sure xAxis is carried out on the right vertical level, and zAxis does the same, but with depth
 
function xAxisRight(x, y, b)
        for a = 1, x do
                block()
                if a == 1 then
                        turtle.turnRight()
                        block()
                        turtle.turnLeft()
                end
                verticalBlocks(y, b)
                if a <= x-1 then
                        turtle.turnLeft()
                        digLoop()
                        fwd()
                        if a == x-1 then
                                block()
                        end
                        turtle.turnRight()
                end
        end
end    
 
function xAxisLeft(x, y, b)
        for a = 1, x do
                block()
                if a == 1 then
                        turtle.turnLeft()
                        block()
                        turtle.turnRight()
                end
                verticalBlocks(y, b)
                if a <= x-1 then
                        turtle.turnRight()
                        digLoop()
                        fwd()
                        if a == x-1 then
                                block()
                        end
                        turtle.turnLeft()
                end
        end
end
 
function yAxisRight(x, y)
        for b = 1, y do
                if b%2 == 0 then
                        xAxisLeft(x, y, b)
                else
                        xAxisRight(x, y, b)
                end
                if b ~= y then
                        digUpLoop()
                        up()
                end
                unload()
                loadFuel()
        end
end
 
function yAxisLeft(x, y)
        for b = 1, y do
                if b%2 == 0 then
                        xAxisRight(x, y, b)
                else
                        xAxisLeft(x, y, b)
                end
                if b ~= y then
                        digUpLoop()
                        up()
                end
                unload()
                loadFuel()
        end
end
 
function zAxisRight(x, y, z)
        for c = 1, z do
                digLoop()
                fwd()
                yAxisRight(x, y)
                if y%2 ~= 0 then
                        turtle.turnRight()
                        for a = 1, x-1 do
                                fwd()
                        end
                        turtle.turnLeft()
                end
                for b = 1, y-1 do
                        dwn()
                end
                if torch == "y" then
                        if (c-2)%10 == 0 or c == 2 then
                                placeTorch()
                        end
                end
        end
end
 
function zAxisLeft(x, y, z)
        for c = 1, z do
                digLoop()
                fwd()
                yAxisLeft(x, y)
                if y%2 ~= 0 then
                        turtle.turnLeft()
                        for a = 1, x-1 do
                                fwd()
                        end
                        turtle.turnRight()
                end
                for b = 1, y-1 do
                        dwn()
                end
                if torch == "y" then
                        if (c-2)%10 == 0 or c == 2 then
                                placeTorch()
                        end
                end
        end
end
 
-- tunnel(.....) functions fuse the digging itself, inventory emptying and transitions together. depenging on which 'orient' you chose, tunnelRight [r], tunnelLeft [l] or tunnelBoth[b] is done
 
function tunnelRight(x, y, z, tunnels, orient, off)
        for done = 1, tunnels do
                if walls == "y" then
                        leftWall(x, y)
                end
                turtle.turnRight()
                zAxisRight(x, y, z)
                for c = 1, z do
                        bck()
                end
                turtle.turnLeft()
                dump(x, orient, tunnels, off, done)
                if done ~= tunnels then
                        nextTunnel(x)
                end
        end
end
 
function tunnelLeft(x, y, z, tunnels, orient, off)
        for done = 1, tunnels do
                if walls == "y" then
                        rightWall(x, y)
                end
                turtle.turnLeft()
                zAxisLeft(x, y, z)
                for c = 1, z do
                        bck()
                end
                turtle.turnRight()
                dump(x, orient, tunnels, off, done)
                if done ~= tunnels then
                        nextTunnel(x)
                end
        end
end
 
function tunnelBoth(x, y, z, tunnels, orient, off)
        for done = 1, tunnels do
                if done%2 ~= 0 then
                        if walls == "y" then
                                leftWall(x, y)
                        end
                        turtle.turnRight()
                        zAxisRight(x, y, z)
                        for c = 1, z do
                                bck()
                        end
                        turtle.turnLeft()
                        dump(x, orient, tunnels, off, done)
                else
                        turtle.turnLeft()
                        zAxisLeft(x, y, z)
                        for c = 1, z do
                                bck()
                        end
                        turtle.turnRight()
                        dump(x, orient, tunnels, off, done)
                        if done ~= tunnels then
                                nextTunnel(x)
                        end
                end
        end
end
 
function nextTunnel(x) -- transition to the next tunnel if needed
        for i = 1, x+2 do -- tunnel spread: 2
                if i >= x-1 then
                        digLoop()
                        if i > x then
                                digUpLoop()
                                turtle.turnLeft()
                                block()
                                up()
                                block()
                                blockUp()
                                turtle.turnRight()
                                turtle.turnRight()
                                block()
                                dwn()
                                block()
                                turtle.turnLeft()
                        end
                end
                fwd()
        end
end    
 
-- these functions make sure the opposite of a tunnel is also filled with cobblestone not to get some liquids or enemies flowing in
 
function leftRow(x, y, b, wallSide)
        for a = 1, x do
                block()
                verticalBlocks(y, b)
                if a == 1 and wallSide == "l" then
                        turtle.turnRight()
                        block()
                        turtle.turnLeft()
                end
                if a == x and wallSide == "r" then
                        turtle.turnLeft()
                        block()
                        turtle.turnRight()
                end
                if a <= x-1 then
                        turtle.turnLeft()
                        digLoop()
                        fwd() -- note1
                        turtle.turnRight()
                end
        end
end
 
function rightRow(x, y, b, wallSide)
        for a = 1, x do
                block()
                verticalBlocks(y, b)
                if a == 1 and wallSide == "r" then
                        turtle.turnLeft()
                        block()
                        turtle.turnRight()
                end
                if a == x and wallSide == "l" then
                        turtle.turnRight()
                        block()
                        turtle.turnLeft()
                end
                if a <= x-1 then
                        turtle.turnRight()
                        digLoop()
                        fwd() -- note2
                        turtle.turnLeft()
                end
        end
end
 
function leftWall(x, y) -- wall on the left, tunnel on the right. rightWall is the opposite.
        turtle.turnLeft()
        for b = 1, y do
                if b%2 == 0 then
                        leftRow(x, y, b, "l")
                else
                        rightRow(x, y, b, "l")
                end
                if b ~= y then
                        digUpLoop()
                        up()
                end
                loadFuel()
                unload()
        end
        if y%2 ~= 0 then
                turtle.turnLeft()
                for i = 1, x-1 do
                        fwd()
                end
                turtle.turnRight()     
        end
        for i = 1, y-1 do
                dwn()
        end
        turtle.turnRight()
end
 
function rightWall(x, y)
        turtle.turnRight()
        for b = 1, y do
                if b%2 == 0 then
                        rightRow(x, y, b, "r")
                else
                        leftRow(x, y, b, "r")
                end
                if b ~= y then
                        digUpLoop()
                        up()
                end
                loadFuel()
                unload()
        end
        if y%2 ~= 0 then
                turtle.turnRight()
                for i = 1, x-1 do
                        fwd()
                end
                turtle.turnLeft()      
        end
        for i = 1, y-1 do
                dwn()
        end
        turtle.turnLeft()
end
 
-- the next two are responsible for returning of the turtles to the base chest (SP)
 
function toChest(back)
        for i = 1, back do
                bck()
        end
        turtle.turnRight()
        turtle.turnRight()
        for i = 6, 15 do
                turtle.select(i)
                turtle.drop(64)
        end
        turtle.turnRight()
        turtle.turnRight()
end
 
function dump(x, orient, tunnels, off, done)
        if orient == "b" then
                if done%2 == 0 then
                        back = x*(done-2)/2 + done-2 + off
                        toChest(back)
                else
                        back = x*(done-1)/2 + done-1 + off
                        toChest(back)
                end
        else
                back = x*(done-1) + done*2-2 + off
                toChest(back)
        end
        if done ~= tunnels then
                for i = 1, back do
                        fwd()
                end
        end
        back = nil
end
       
-- and here, needed information is gathered, put together and required functions are called
-- MAIN:
getReady()
loadFuel()
io.write "Width? "
local x = io.read()
x = tonumber(x)
while tonumber(x) == nil or x < 1 do
        io.write "Invalid number. Try again: "
        x = io.read()
        x = tonumber(x)
end
io.write "Height? "
local y = io.read()
y = tonumber(y)
while tonumber(y) == nil or y < 1  do
        io.write "Invalid number. Try again: "
        y = io.read()
        y = tonumber(y)
end
io.write "Depth? "
local z = io.read()
z = tonumber(z)
while tonumber(z) == nil or z < 1 do
        io.write "Invalid number. Try again: "
        z = io.read()
        z = tonumber(z)
end
 
io.write "How many tunnels? "
local tunnels = io.read()
tunnels = tonumber(tunnels)
while tonumber(tunnels) == nil or tunnels < 1 do
        io.write "Invalid number. Try again: "
        tunnels = io.read()
end
 
io.write "Tunnels to the right, left or both? [r/l/b] "
local orient = io.read()
while orient ~= "r" and orient ~= "l" and orient ~= "b" do
        io.write "Enter one of the choices: "
        orient = io.read()
end
 
io.write "Do you want walls? [y/n] "
walls = io.read()
while walls ~= "y" and walls ~= "n" do
        io.write "Enter one of the choices: "
        walls = io.read()
end
 
io.write "Do you want a torch? [y/n] "
torch = io.read()
while torch ~= "y" and torch ~= "n" do
        io.write "Enter one of the choices: "
        torch = io.read()
end
 
print "Outta my way, I'm a diggin'!"
 
local off = 0
while not turtle.detect() do
        turtle.forward()
        off = off + 1
end
 
if orient == "r" then
        tunnelRight(x, y, z, tunnels, orient, off)
elseif orient == "l" then
        tunnelLeft(x, y, z, tunnels, orient, off)
else
        tunnelBoth(x, y, z, tunnels, orient, off)
end
print "DONE!"
