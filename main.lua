dofile('Object.lua')

-- Globals
mapObject   = nil
map         = {}
character   = nil
enemy_list  = {}

function love.load()
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
end

function draw_map()
    local y = 50
    local x = 50
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
        x = 50
    end
end

function love.keypressed( key )
    local x = character:getX()
    local y = character:getY()

    if key == "w" then
        y = y-1
    elseif key == "a" then
        x = x-1
    elseif key == "s" then
        y = y+1
    elseif key == "d" then
        x = x+1
    end
    
    if y > 0 and y <= mapObj:getY() and x > 0 and x <= mapObj:getX() then
        if map[y][x]:getType() == "Path" and map[y][x]:canCharTraverse() then
            map[character:getY()][character:getX()]:removeObject(character)
            character:setXY(x,y)
            map[y][x]:addObject(character)
        end
    end
end