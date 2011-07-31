Enemy = {}
Enemy.__index = Enemy

function Enemy.create(x,y)
    local obj = {}
    setmetatable(obj, Enemy)
    
    obj.is_a        = "Enemy"
    obj.priority    = 2
    obj.value       = 1000
    obj.speed       = 10
    
    obj.is_vulerable    = false
    obj.vultimer        = 500
    
    obj.xy  = {x,y}      -- Current  {x,y}
    obj.pxy = {-1,-1}      -- Previous {x,y}
    obj.dir = -1         -- -1 : None, 1: Up, 2: Right, 3: Down, 4: Left
    
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
    return self.xy[1]
end

function Enemy:getY()
    return self.xy[2]
end

function Enemy:setX(x)
    self.xy[1] = x
end

function Enemy:setY(y)
    self.xy[2] = y
end

function Enemy:setXY(x,y)
    self.xy[1] = x
    self.xy[2] = y
end

function Enemy:getValue()
    return self.value
end

function Enemy:isVulnerable()
    return self.is_vulerable
end

function Enemy:invulnerable()
    self.is_vulerable = false
    self.vultimer   = 500
end

function Enemy:vulnerable()
    if self.is_vulerable == true then
        self.vultimer = self.vultimer + 100
    else
        self.is_vulerable = true
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
        local target = self:lineOfSight()
        
        if #target > 0 then
            for i,v in ipairs(target) do
                io.write("target:\t")
                for j,e in ipairs(v) do
                    io.write(e, " ")
                end
                io.write("\n")
            end
        else
            local movement = self:getMovement()
            local pickdir = math.random(1,#movement)
            
            while #movement > 0 do
                local getdir = movement[pickdir]

                if self:moveEnemy(getdir[1],getdir[2]) then
                    self.dir = getdir[3]
                    break
                end

                table.remove(movement,pickdir)
                pickdir = (pickdir + 1) % #movement
                if pickdir == 0 then pickdir = 1 end
            end
        end
        self.speed = 10
    end
end

--[[--
    Move to given x,y.
    @parameter x
    @parameter y
    @return bool
--]]--
function Enemy:moveEnemy(x,y)
    if y > 0 and y <= mapObj:getY() and x > 0 and x <= mapObj:getX() then
        if map[y][x]:getType() == "Path" and map[y][x]:canEnemyTraverse() then
            if map[y][x]:findObjectType("Door") == nil then
                self.pxy[1] = self.xy[1]
                self.pxy[2] = self.xy[2]
                map[self:getY()][self:getX()]:removeObject(self)
                
                self:setXY(x,y)
                map[y][x]:addObject(self)
                
                return true
            else
                return false
            end
        end
    end

    return false
end

---- Private
--[[--
    Scan the enemies line of sight
    @return target, if target is found within los then return {x,y}.
--]]--
function Enemy:lineOfSight()
    local distance  = 3
    local target    = {}

    local i = -distance
    while i <= distance do
        local y = self.xy[2]+i
        local j = -1

        if y > 0 and y <= mapObj:getY() then

            while j >= -distance do
                local x = self.xy[1]+j

                if x > 0 and x <= mapObj:getX() then
                    if map[y][x] ~= nil and map[y][x]:getType() == "Path" then
                        -- Ignore path if another Enemy is there
                        if map[y][x]:findObjectType("Enemy") == nil then
                            if map[y][x]:findObject("Character") ~= nil then
                                table.insert(target, {self.xy[2]+i,self.xy[1]+j})
                            end
                        end
                    end
                end
            
                j = j - 1
            end
            
            j = 0
            while j <= distance do
                local x = self.xy[1]+j
                
                if x >= 1 and x <= mapObj:getX() then
                    if map[y][x] ~= nil and map[y][x]:getType() == "Path" then
                        -- Ignore path if another Enemy is there
                        if map[y][x]:findObjectType("Enemy") == nil then
                            if map[y][x]:findObjectType("Character") ~= nil then
                                table.insert(target, {self.xy[2]+i,self.xy[1]+j})
                            end
                        end
                    end
                end
                j = j + 1
            end
        end
        i = i + 1
    end

    return target
end

--[[--
    Get the available movement locations.
    @return {{x,y,dir}...}
--]]--
function Enemy:getMovement()
    local movement = {}
    local x = self.xy[1]-1
    local y = self.xy[2]
    
    if not (x == self.pxy[1] and y == self.pxy[2]) then
        if map[y][x]:getType() == "Path" then
            if map[y][x]:findObjectType("Enemy") == nil then
                table.insert(movement, {x, y, 4})
            end
        end
    end
    
    x = self.xy[1]+1
    y = self.xy[2]
    
    if not (x == self.pxy[1] and y == self.pxy[2]) then
        if map[y][x]:getType() == "Path" then
            if map[y][x]:findObjectType("Enemy") == nil then
                table.insert(movement, {x, y, 2})
            end
        end
    end
    
    
    x = self.xy[1]
    y = self.xy[2] - 1
    
    if not (x == self.pxy[1] and y == self.pxy[2]) then
        if map[y][x]:getType() == "Path" then
            if map[y][x]:findObjectType("Enemy") == nil then
                table.insert(movement, {x, y, 1})
            end
        end
    end
    
    x = self.xy[1]
    y = self.xy[2] + 1

    if not (x == self.pxy[1] and y == self.pxy[2]) then
        if map[y][x]:getType() == "Path" then
            if map[y][x]:findObjectType("Enemy") == nil then
                table.insert(movement, {x, y, 3})
            end
        end
    end
    
    return movement
end
