dofile('Object.lua')

-- Globals
map         = {} -- -1/-2: wall, 0 path
character   = nil

function love.load()
    pathimg        = love.graphics.newImage("images/path.png")
    wallimg        = love.graphics.newImage("images/wall.png")
    pelletimg      = love.graphics.newImage("images/pellet.png")
    spelletimg    = love.graphics.newImage("images/spellet.png")
    --enemy       = love.graphics.newImage("images/enemy.png")
    characterimg   = love.graphics.newImage("images/character.png")
    
    love.graphics.setBackgroundColor(0,0,0)
    
    local mapObj = Map.create("level1.dat")
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
    print(character)
    if key == "w" or "up" then
        
    elseif key == "a" or "left" then
    
    elseif key == "s" or "down" then
    
    elseif key == "d" or "right" then
    
    end
end