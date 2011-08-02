--[[--------------------------------------------------------------------------
--                              Enemy                                       --
--                      Basic classes found in all Enemy types.             --
--------------------------------------------------------------------------]]--
--[[--
    Move to given x,y.
    @parameter x
    @parameter y
    @return bool
--]]--
function moveEnemy(self,x,y)
    if y > 0 and y <= mapObj.xy[2] and x > 0 and x <= mapObj.xy[1] then
        if map[y][x].is_a == "Path" and map[y][x]:canEnemyTraverse() then
            if map[y][x]:findObjectType("Door") == nil then
                self.pxy[1] = self.xy[1]
                self.pxy[2] = self.xy[2]
                map[self.xy[2]][self.xy[1]]:removeObject(self)
                
                setXY(self,x,y)
                map[y][x]:addObject(self)
                
                return true
            else
                return false
            end
        end
    end

    return false
end

--[[--
    Decrement the vulnerability timer.
    @return true if timer reaches zero, else false
--]]--
function updateTimer(self,dt)
    self.vultimer = self.vultimer - (dt*100)
    
    if self.vultimer <= 0.001 then
        invulnerable(self)
        return true
    end
    
    return false
end

function setXY(self,x,y)
    self.xy[1] = x
    self.xy[2] = y
end

function invulnerable(self)
    self.is_vulnerable  = false
    self.vultimer       = 500
end

function vulnerable(self)
    if self.is_vulnerable == true then
        self.vultimer = self.vultimer + 500
    else
        self.is_vulnerable = true
    end
end

--[[--------------------------------------------------------------------------
--                                  Zombie                                  --
--  Type:  Stupid                                                           --
--  Value: 250                                                              --
--  AI:                                                                     --
--      Speed    -  40  (Slow)                                                    --
--      LoS      -  
--      Movement -  If no target then continue straight until no longer     --
--                  able then pick a new direction.                         --
--                  If target then chase                                    --
--------------------------------------------------------------------------]]--
Zombie = {}
Zombie.__index = Zombie

function Zombie.create(x,y)
    local obj = {}
    setmetatable(obj, Zombie)
    
    obj.is_a        = "Enemy"
    obj.kind        = "Zombie"
    obj.priority    = 2
    obj.value       = 250
    obj.speed       = 40
    
    obj.dir         = -1
    obj.path        = {}
    
    obj.is_vulnerable   = false
    obj.vultimer        = 500
    
    obj.xy  = {x,y} -- Current {x,y}
    obj.pxy = {-1,-1}
    
    obj.spawn   = {x,y}
    
    return obj
end

function Zombie:draw(x,y)
    if self.is_vulnerable then
        love.graphics.draw(zombieimg, x, y)
    else
        love.graphics.draw(zombieimg, x, y)
    end
end

function Zombie:move()
    self.speed = self.speed - 1
    
    if self.speed <= 0 then
        if #self.path ~= 0 then
            local xy = self.path[1]
            
            if moveEnemy(self,xy[1],xy[2]) then
                table.remove(self.path,1)
            end
        else
            local paths = self:getPaths()
            local pick  = math.random(1,#paths)

            self.path   = paths[pick]
            local xy = self.path[1]
            if moveEnemy(self,xy[1],xy[2]) then
                table.remove(self.path,1)
            end
        end 
        self.speed = 40
    end
end

function Zombie:respawn()
    moveEnemy(self, self.spawn[1], self.spawn[2])
    self.path = {}
end

-- Private
function Zombie:getPaths()
    local paths = {}
    
    local x    = self.xy[1] - 1
    local y    = self.xy[2]
    if not (x == self.pxy[1]) and not (y == self.pxy[2]) then
        local path = {}
        while x > 0 and (map[y][x].is_a == "Path") do
            table.insert(path, {x,y})
            x = x - 1
        end

        if #path > 0 then
            table.insert(paths,path)
        end
    end
    
    x    = self.xy[1] + 1
    y    = self.xy[2]
    if not (x == self.pxy[1]) and not (y == self.pxy[2]) then
        local path = {}
        while x <= mapObj.xy[1] and (map[y][x].is_a == "Path") do
            table.insert(path, {x,y})
            x = x + 1
        end

        if #path > 0 then
            table.insert(paths,path)
        end
    end
    
    x    = self.xy[1]
    y    = self.xy[2] - 1
    if not (x == self.pxy[1]) and not (y == self.pxy[2]) then
        local path = {}
        while y > 0 and (map[y][x].is_a == "Path") do
            table.insert(path, {x,y})
            y = y - 1
        end

        if #path > 0 then
            table.insert(paths,path)
        end
    end
    
    
    x    = self.xy[1]
    y    = self.xy[2] + 1
    if not (x == self.pxy[1]) and not (y == self.pxy[2]) then
        local path = {}
        while y <= mapObj.xy[2] and (map[y][x].is_a == "Path") do
            table.insert(path, {x,y})
            y = y + 1
        end

        if #path > 0 then
            table.insert(paths, path)
        end
    end
    
    return paths
end

--[[--------------------------------------------------------------------------
--                                  Ghost                                   --
--  Value: 500                                                              --
--  AI:                                                                     --
--      LoS - 3 cells                                                       --
--      Movement - If no target, random 1-space at a time (no look ahead)   --
--                 If target and invulnerable, then chase                   --
--                 If target and vulnerable, then flee                      --
--------------------------------------------------------------------------]]--
Ghost = {}
Ghost.__index = Ghost

function Ghost.create(x,y)
    local obj = {}
    setmetatable(obj, Ghost)
    
    obj.is_a        = "Enemy"
    obj.kind        = "Ghost"
    obj.priority    = 2
    obj.value       = 500
    obj.speed       = 10
    
    obj.is_vulnerable   = false
    obj.vultimer        = 500
    
    obj.xy  = {x,y}      -- Current  {x,y}
    obj.pxy = {-1,-1}    -- Previous {x,y}
    
    obj.spawn = {x,y}
    
    return obj
end

function Ghost:draw(x,y)
    if self.is_vulnerable then
        love.graphics.draw(vulenemyimg, x, y)
    else
        love.graphics.draw(enemyimg,x,y)
    end
end

function Ghost:move()
    self.speed = self.speed - 1
    
    if self.speed <= 0 then
        local target = self:lineOfSight()       -- Search for target
        local movement = self:getMovement()
        
        if #target > 0 then
            table.insert(movement, {self.pxy[1],self.pxy[2]})
            local cx = character.xy[1]
            local cy = character.xy[2]
            
            local distance = math.sqrt(
                math.pow(cx-self.xy[1],2) + math.pow(cy-self.xy[2],2))
            local nx       = self.xy[1]
            local ny       = self.xy[2]
            
            if self.is_vulnerable then         -- Flee    
                for i,v in ipairs(movement) do
                    local newDistance = math.sqrt(
                        math.pow(cx-v[1],2) + math.pow(cy-v[2],2))
                    
                    if newDistance > distance then
                        distance = newDistance
                        nx       = v[1]
                        ny       = v[2]
                    end
                end
            else                                -- Chase
                for i,v in ipairs(movement) do
                    local newDistance = math.sqrt(
                        math.pow(cx-v[1],2) + math.pow(cy-v[2],2))
                    
                    if newDistance < distance then
                        distance = newDistance
                        nx       = v[1]
                        ny       = v[2]
                    end
                end
            end
        else                                    -- Only worry about next move

            if #movement == 0 then
                moveEnemy(self,self.pxy[1], self.pxy[2])
            else
                local pickdir = math.random(1,#movement)
                while #movement > 0 do
                    local getdir = movement[pickdir]

                    if moveEnemy(self,getdir[1],getdir[2]) then
                        break
                    end

                    table.remove(movement,pickdir)
                    pickdir = (pickdir + 1) % #movement
                    if pickdir == 0 then pickdir = 1 end
                end
            end
        end
        self.speed = 10
    end
end

function Ghost:respawn()
    moveEnemy(self, self.spawn[1], self.spawn[2])
end

---- Private
--[[--
    Scan the enemies line of sight
    @return target, if target is found within los then return {x,y}.
--]]--
function Ghost:lineOfSight()
    local distance  = 3
    local target    = {}

    local i = -distance
    while i <= distance do
        local y = self.xy[2]+i
        local j = -1

        if y > 0 and y <= mapObj.xy[2] then
            while j >= -distance do
                local x = self.xy[1]+j

                if x > 0 and x <= mapObj.xy[1] then
                    if map[y][x] ~= nil and map[y][x].is_a == "Path" then
                        -- Ignore path if another Enemy is there
                        if map[y][x]:findObjectType("Enemy") == nil then
                            if map[y][x]:findObjectType("Character") ~= nil then
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
                
                if x >= 1 and x <= mapObj.xy[1] then
                    if map[y][x] ~= nil and map[y][x].is_a == "Path" then
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
function Ghost:getMovement()
    local movement = {}
    local x = self.xy[1]-1
    local y = self.xy[2]
    
    if y > 0 and y <= mapObj.xy[2] and x > 0 and x <= mapObj.xy[1] then
        if not (x == self.pxy[1] and y == self.pxy[2]) then
            if map[y][x].is_a == "Path" then
                if map[y][x]:findObjectType("Enemy") == nil then
                    table.insert(movement, {x, y})
                end
            end
        end
    end
        
    x = self.xy[1]+1
    y = self.xy[2]

    if y > 0 and y <= mapObj.xy[2] and x > 0 and x <= mapObj.xy[1] then
        if not (x == self.pxy[1] and y == self.pxy[2]) then
            if map[y][x].is_a == "Path" then
                if map[y][x]:findObjectType("Enemy") == nil then
                    table.insert(movement, {x, y})
                end
            end
        end
    end
        
    x = self.xy[1]
    y = self.xy[2] - 1

    if y > 0 and y <= mapObj.xy[2] and x > 0 and x <= mapObj.xy[1] then    
        if not (x == self.pxy[1] and y == self.pxy[2]) then
            if map[y][x].is_a == "Path" then
                if map[y][x]:findObjectType("Enemy") == nil then
                    table.insert(movement, {x, y})
                end
            end
        end
    end
        
    x = self.xy[1]
    y = self.xy[2] + 1

    if y > 0 and y <= mapObj.xy[2] and x > 0 and x <= mapObj.xy[1] then
        if not (x == self.pxy[1] and y == self.pxy[2]) then
            if map[y][x].is_a == "Path" then
                if map[y][x]:findObjectType("Enemy") == nil then
                    table.insert(movement, {x, y})
                end
            end
        end
    end
    
    return movement
end
