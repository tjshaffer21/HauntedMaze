dofile('Object.lua')

-- Globals
map = {} -- -1/-2: wall, 0 path

function love.load()
    path        = love.graphics.newImage("images/path.png")
    wall        = love.graphics.newImage("images/wall.png")
    pellet      = love.graphics.newImage("images/pellet.png")
    spellet     = love.graphics.newImage("images/spellet.png")
    enemy       = love.graphics.newImage("images/enemy.png")
    character   = love.graphics.newImage("images/character.png")
    
    love.graphics.setBackgroundColor(0,0,0)
    
    local mapObj = Map.create("level1.dat",28,4)
    mapObj:generate_map(mapObj:getX(), mapObj:getY())
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
                j:draw(path,x,y)
            elseif j:getType() == "Wall" then
                j:draw(wall,x,y)
            elseif j:getType() == "Pellet" then   
                j:draw(pellet,x,y)
            elseif j:getType() == "SuperPellet" then
                j:draw(spellet,x,y)
            elseif j:getType() == "Enemy" then
                j:draw(enemy,x,y)
            elseif j:getType() == "Character" then
                j:draw(character,x,y)
            end
            
            x = x + 25
        end
        y = y + 25
        x = 50
    end
end

--[[--
function love.run()
    load()
    draw()
end--]]--