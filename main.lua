dofile('Object.lua')

-- Globals
mapObject   = nil
map         = {}
character   = nil
enemy_list  = {}
numPellets  = 0
highscore   = 0
score       = 0


function draw_map()
    local y = 0
    local x = 0
    for ik,i in pairs(map) do
        for jk,j in pairs(map[ik]) do
            if j:getType() == "Path" then
                j:draw(x,y)
            elseif j:getType() == "Wall" then
                j:draw(x,y)
            end
            
            x = x + 25
        end
        y = y + 25
        x = 0
    end
end

--[[--
    Move character to position given in parameter.
    @parameter x
    @parameter y
    @return if move successful return true, else false
--]]--
function moveChar(x,y)
    if y > 0 and y <= mapObj:getY() and x > 0 and x <= mapObj:getX() then
        if map[y][x]:getType() == "Path" and map[y][x]:canCharTraverse() then
            map[character:getY()][character:getX()]:removeObject(character)
            character:setXY(x,y)
            map[y][x]:addObject(character)
            
            return true
        end
    end
    
    return false
end

--[[--
    Check if path contains a pellet and collect it true.
    If a pellet is found, then score is automatically incremented.
    @parameter x
    @parameter y
--]]--
function collectPellet(x,y)
    local pel   = map[y][x]:findObjectType("Pellet")
    local spel  = map[y][x]:findObjectType("SuperPellet")
    
    if pel ~= nil then
        score   = score + pel:getValue()
        map[y][x]:removeObject(pel)
    end
    
    if spel ~= nil then
        score   = score + spel:getValue()
        map[y][x]:removeObject(spel)
    end
end

-- Override love functions.
function love.load()
    love.keyboard.setKeyRepeat(1,50)
    pathimg        = love.graphics.newImage("images/path.png")
    wallimg        = love.graphics.newImage("images/wall.png")
    pelletimg      = love.graphics.newImage("images/pellet.png")
    spelletimg    = love.graphics.newImage("images/spellet.png")
    --enemy       = love.graphics.newImage("images/enemy.png")
    characterimg   = love.graphics.newImage("images/character.png")
    
    love.graphics.setBackgroundColor(0,0,0)
    
    mapObj = Map.create("level1.dat")
    mapObj:generate_map()
    map = mapObj:getMap()
end

function love.draw()
    draw_map()
    
    local x = 50
    local y = 1
    love.graphics.print(string.format("Highscore: %d", highscore), x, y, 0, 1, 2)
    
    x = (love.graphics.getWidth() / 2) - 50
 
    for i=1,character:getLives() do
        love.graphics.draw(characterimg, x, y)
        x = x + characterimg:getWidth()
    end
    
    love.graphics.print(string.format("Score: %d", score), x+50, y, 0, 1, 2)
end


function love.keypressed( key )
    local x = character:getX()
    local y = character:getY()

    if key == "w" then y = y-1 end
    if key == "a" then x = x-1 end
    if key == "s" then y = y+1 end
    if key == "d" then x = x+1 end
    
    if moveChar(x,y) == true then
        collectPellet(x,y)
    end
end
