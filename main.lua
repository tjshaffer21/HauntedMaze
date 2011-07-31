dofile('Object.lua')

-- Globals
mapObject   = nil
map         = {}
enemy_list  = {}
door_list   = {}
character   = nil
numPellets  = 0
highscore   = 0
score       = 0

function draw_map()
    local y = 0
    local x = 0
    for ik,i in pairs(map) do
        for jk,j in pairs(map[ik]) do
            if j.is_a == "Path" then
                j:draw(x,y)
            elseif j.is_a == "Wall" then
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
    if y > 0 and y <= mapObj.xy[2] and x > 0 and x <= mapObj.xy[1] then
        if map[y][x].is_a == "Path" and map[y][x]:canCharTraverse() then
            if map[y][x]:findObjectType("Door") == nil then
                map[character.xy[2]][character.xy[1]]:removeObject(character)
                character:setXY(x,y)
                map[y][x]:addObject(character)
            else
                return false
            end
            
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
        score   = score + pel.value
        map[y][x]:removeObject(pel)
        numPellets = numPellets - 1
    end
    
    if spel ~= nil then
        score   = score + spel.value
        map[y][x]:removeObject(spel)
        numPellets = numPellets - 1
        
        -- Set enemies to vulnerable
        for i,v in ipairs(enemy_list) do
            v:vulnerable()
        end
    end
end

function enemyCharCollision(e)
    local x = character.xy[1]
    local y = character.xy[2]
    
    if map[y][x]:findObject(e) and map[y][x]:findObject(character) then
        if e.is_vulnerable then
            for i,v in ipairs(enemy_list) do
                if v == e then 
                    score = score + e.value
                    map[e.xy[2]][e.xy[1]]:removeObject(e)
                    table.remove(enemy_list,i)
                end
            end
        else
            character:rmLife()
            
            if character.lives == 0 then
                gameOver()
            else
                reset()
            end
        end
    end
end

function update_doors(dt)
    for i,v in ipairs(door_list) do
        if v.lock == "Timed" then
            if v:updateKey(dt) then
                map[v.xy[2]][v.xy[1]]:removeObject(v)
                table.remove(door_list,i)
            end
        elseif v.lock == "Key" then
            if numPellets <= 0 then
                map[v.xy[2]][v.xy[1]]:removeObject(v)
                table.remove(door_list,i)
            end
        end
    end
end

function update_enemy(dt)
    for i,v in ipairs(enemy_list) do
        if v.is_vulnerable then
            v:updateTimer(dt)
        end
        
        v:move()
        enemyCharCollision(v)
    end
end

function gameOver()
    print("The game is met.")
end

function reset()
    for i,v in ipairs(enemy_list) do
        v:moveEnemy(v.spawn[1],v.spawn[2])
    end
    
    moveChar(character.spawn[1], character.spawn[2])
end

-- Override love functions.
function love.load()
    love.keyboard.setKeyRepeat(1,50)
    
    pathimg        = love.graphics.newImage("images/path.png")
    wallimg        = love.graphics.newImage("images/wall.png")
    doorimg        = love.graphics.newImage("images/door.png")
    pelletimg      = love.graphics.newImage("images/pellet.png")
    spelletimg     = love.graphics.newImage("images/spellet.png")
    enemyimg       = love.graphics.newImage("images/enemy.png")
    vulenemyimg    = love.graphics.newImage("images/vulenemy.png")
    characterimg   = love.graphics.newImage("images/character.png")
    
    love.graphics.setBackgroundColor(0,0,0)
    
    mapObj = Map.create("level1.dat")
    mapObj:generate_map()
    map = mapObj:getMap()
end

function love.update(dt)
    update_doors(dt)
    update_enemy(dt)
end

function love.draw()
    draw_map()
    
    local x = 50
    local y = 1
    love.graphics.print(string.format("Highscore: %d", highscore), x, y, 0, 1, 2)
    
    x = (love.graphics.getWidth() / 2) - 50
 
    for i=1,character.lives do
        love.graphics.draw(characterimg, x, y)
        x = x + characterimg:getWidth()
    end
    
    love.graphics.print(string.format("Score: %d", score), x+50, y, 0, 1, 2)
end

function love.keypressed( key )
    local x = character.xy[1]
    local y = character.xy[2]

    if key == "w" then y = y-1 end
    if key == "a" then x = x-1 end
    if key == "s" then y = y+1 end
    if key == "d" then x = x+1 end
    
    if moveChar(x,y) == true then

        collectPellet(x,y)
    end
end
