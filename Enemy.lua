Enemy = {}
Enemy.__index = Enemy

function Enemy.create(x,y)
    local obj = {}
    setmetatable(obj, Enemy)
    
    obj.is_a       = "Enemy"
    obj.priority   = 2
    obj.speed      = 10
    obj.value      = 1000
    obj.vulnrable  = false
    obj.vultimer   = 500
    obj.x          = x
    obj.y          = y
    obj.prevX      = -1
    obj.prevY      = -1
    
    return obj
end

function Enemy:getType()
    return self.is_a
end

function Enemy:getPriority()
    return self.priority
end

function Enemy:draw(x,y)
    if self:isVulnerable() then
        love.graphics.draw(vulenemyimg, x, y)
    else
        love.graphics.draw(enemyimg,x,y)
    end
end

function Enemy:getX()
    return self.x
end

function Enemy:getY()
    return self.y
end

function Enemy:setX(x)
    self.x = x
end

function Enemy:setY(y)
    self.y = y
end

function Enemy:setXY(x,y)
    self.x = x
    self.y = y
end

function Enemy:getValue()
    return self.value
end

function Enemy:isVulnerable()
    return self.vulnrable
end

function Enemy:invulnerable()
    self.vulnrable = false
    self.vultimer   = 500
end

function Enemy:vulnerable()
    if self.vulnrable == true then
        self.vultimer = self.vultimer + 100
    else
        self.vulnrable = true
    end
end

--[[--
    Decrement the vulnerability timer.
    @return true if timer reaches zero, else false
--]]--
function Enemy:updateTimer(dt)
    self.vultimer = self.vultimer - (dt*100)

    if self.vultimer <= 0.001 then
        self:invulnerable()
        return true
    end
    
    return false
end

function Enemy:move()
    self.speed = self.speed - 1
    
    if self.speed <= 0 then
        local surroundings,target = self:getSurroundings()
        
        if #target == 2 then        -- Character found within enemy's LoS
            local cx = target[1]    -- Get character's x position
            local cy = target[2]    -- Get character's y position
            
            local distance = math.sqrt(math.pow((cx - self.y),2) + math.pow(cy - self.y,2))
            local movement = self:moveLocations()

            for i,v in ipairs(movement) do
                local nx = v[1]
                local ny = v[2]
                
                local newDistance = math.sqrt(math.pow((cx - nx),2) + math.pow((cy - ny),2))
                if newDistance < distance then
                    self:moveEnemy(nx,ny)
                end
            end
        else
            
        end
        
        self.speed = 10
    end
end

--[[--
    Check the adjancent squares to see where enemy can move.
    @return table of tables {{x,y}...}
--]]--
function Enemy:moveLocations()
    local movement = {}
    if map[self.y-1][self.x]:getType() == "Path" and map[self.y-1][self.x]:canEnemyTraverse() then
        table.insert(movement, {self.x, self.y-1})
    end
    
    if map[self.y+1][self.x]:getType() == "Path" and map[self.y+1][self.x]:canEnemyTraverse() then
        table.insert(movement, {self.x, self.y+1})
    end
    
    if map[self.y][self.x-1]:getType() == "Path" and map[self.y][self.x-1]:canEnemyTraverse() then
        table.insert(movement, {self.x-1, self.y})
    end
    
    if map[self.y][self.x+1]:getType() == "Path" and map[self.y][self.x+1]:canEnemyTraverse() then
        table.insert(movement, {self.x+1, self.y-1})
    end
    
    return movement
end

function Enemy:moveEnemy(x,y)
    if y > 0 and y <= mapObj:getY() and x > 0 and x <= mapObj:getX() then
        if map[y][x]:getType() == "Path" and map[y][x]:canEnemyTraverse() then
            if map[y][x]:findObjectType("Door") == nil then
                map[self:getY()][self:getX()]:removeObject(self)
                
                self.prevX = self.x
                self.prevY = self.y
                
                self:setXY(x,y)
                map[y][x]:addObject(self)
            else
               return false
            end
                
            return true
        end
    end

    return false
end

--[[--
    Get the surrounding cells.
    Ignores cells that contain or are beyond walls and cells that contain enemies.
    @return table
--]]--
function Enemy:getSurroundings()
    local surroundings = {}
    local target       = {}
    local maxDepth     = 3
    
    local i = -(maxDepth)
    while i <= maxDepth do
        local row       = {}
        local j         = -1
        
        -- Check left side
        while j >= -(maxDepth) do
            local x = self.x+j
            local y = self.y+i
            
            if map[y][x]:getType() == "Wall" then break end -- Don't look past a wall.
            if map[y][x]:getType() == "Path" then
                if map[y][x]:findObjectType("Enemy") == nil then
                    table.insert(row, map[y][x])
                end
                
                if map[y][x]:findObjectType("Character") ~= nil then
                    target[1] = x
                    target[2] = y
                end
            end
            
            j = j - 1
        end
        
        -- Check right side
        j = 0
        while j <= maxDepth do
            local x = self.x+j
            local y = self.y+i
            
            if map[y][x]:getType() == "Wall" then break end -- Don't look past a wall.
            if map[y][x]:getType() == "Path" and map[y][x]:findObjectType("Enemy") == nil then
                table.insert(row, map[y][x])
            end
            
            if map[y][x]:findObjectType("Character") ~= nil then
                target[1] = x
                target[2] = y
            end
            
            j = j + 1
        end

        table.insert(surroundings, row)
        i = i + 1
    end
    
    return surroundings, target
end