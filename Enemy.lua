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
        local mod_x = math.floor(x/25)
        local mod_y = math.floor(y/25)
        if map[mod_y][mod_x].is_a == "Path" and map[mod_y][mod_x]:canEnemyTraverse() then
            if map[mod_y][mod_x]:findObjectType("Door") == nil then
                self.dxy[1] = x
                self.dxy[2] = y
               
                map[self.xy[2]][self.xy[1]]:removeObject(self)
                
                setXY(self,mod_x,mod_y)
                map[mod_y][mod_x]:addObject(self)
                
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
    self.pxy[1] = self.xy[1]
    self.pxy[2] = self.xy[2]
    
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

--[[--
    Calculate the drawing {x,y} based on new array location.
    @parameter self
    @parameter comp_dx  - Comparison x-value
    @parameter comp_dy  - Comparison y-value
    @parameter dt       - Time offset
    @return {dx,dy}
--]]--
function calculateDxDy(self,comp_dx,comp_dy,dt)
        local dx = self.dxy[1]
        local dy = self.dxy[2]
        if self.xy[1] > comp_dx then
            dx = dx - (self.speed*dt)
        elseif self.xy[1] < comp_dx then
            dx = dx + (self.speed*dt)
        end
        
        if self.xy[2] > comp_dy then
            dy = dy - (self.speed*dt)
        elseif self.xy[2] < comp_dy then
            dy = dy + (self.speed*dt)
        end
      
    return {dx,dy}
end

--[[--------------------------------------------------------------------------
--                                  Zombie                                  --
--  Type:  Stupid                                                           --
--  Value: 250                                                              --
--  AI:                                                                     --
--      Speed    -  50  (Slow)                                              --
--      LoS      -  TODO
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
    obj.speed       = 50
    
    obj.dir         = -1
    obj.path        = {}
    
    obj.is_vulnerable   = false
    obj.vultimer        = 500
    
    obj.dxy = {x*25,y*25}   -- Drawing {x,y}
    obj.xy  = {x,y}         -- Current {x,y}
    obj.pxy = {-1,-1}       -- Previous {x,y}
    
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

function Zombie:move(dt)
    if #self.path == 0 then
        local paths = self:getPaths()

        if #paths > 0 then
            local pick  = math.random(1,#paths)

            self.path   = paths[pick]
        end
    else
        local nx = self.path[1][1]
        local ny = self.path[1][2]

        local dxy = calculateDxDy(self,nx,ny,dt)
        
        if moveEnemy(self,dxy[1],dxy[2]) then
            if self.xy[1] == nx and self.xy[2] == ny then
                table.remove(self.path,1)
            end
        end
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
        while x <= math.floor(mapObj.xy[1]/25) and (map[y][x].is_a == "Path") do
            table.insert(path, {x,y})
            x = x + 1
        end

        if #path > 0 then
            table.insert(paths,path)
        end
    end
    
    x    = self.xy[1]
    y    = self.xy[2] - 1

    if x ~= self.pxy[1] and y ~= self.pxy[2] then
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
        while y <= math.floor(mapObj.xy[2]/25) and (map[y][x].is_a == "Path") do
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
--      Speed    - 200 (Normal)                                             --
--      LoS      - 3 cells                                                  --
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
    obj.speed       = 200
    
    obj.is_vulnerable   = false
    obj.vultimer        = 500
    
    obj.dxy     = {x*offset,y*offset}   -- Drawing {x,y}
    obj.xy      = {x,y}                 -- Current {x,y}
    obj.pxy     = {-1,-1}               -- Previous {x,y}
    obj.nxy     = {-1,-1}               -- Next {x,y}
    obj.spawn   = {x,y}                 -- Spawn {x,y}
    
    return obj
end

function Ghost:draw(x,y)
    if self.is_vulnerable then
        love.graphics.draw(vulenemyimg, x, y)
    else
        love.graphics.draw(enemyimg,x,y)
    end
end

function Ghost:move(dt)
    local target   = self:lineOfSight()       -- Search for target
    local movement = self:getMovement()
    --if #target > 0
    
    if self.nxy[1] > -1 and self.nxy[2] > - 1 then
        local dxy = calculateDxDy(self, self.nxy[1], self.nxy[2],dt)
        
        if moveEnemy(self,dxy[1], dxy[2]) then
            if self.nxy[1] == self.xy[1] and self.nxy[2] == self.xy[2] then
                self.nxy[1] = -1
                self.nxy[2] = -1
            end        
        end
    else
        if #movement ~= 0 then
            local pickdir = math.random(1,#movement)
            local getdir = movement[pickdir]

            self.nxy[1] = getdir[1]
            self.nxy[2] = getdir[2]
            
            local dxy = calculateDxDy(self, getdir[1], getdir[2], dt)
            
            if moveEnemy(self,dxy[1],dxy[2]) then
                if self.nxy[1] == self.xy[1] and self.nxy[2] == self.xy[2] then
                    self.nxy[1] = -1
                    self.nxy[2] = -1
                end
            end
        end

    end
end

function Ghost:respawn()
    self.dxy[1] = self.spawn[1] * offset
    self.dxy[2] = self.spawn[2] * offset
   
    map[self.xy[2]][self.xy[1]]:removeObject(self)
    
    setXY(self,self.spawn[1],self.spawn[2])
    map[self.spawn[2]][self.spawn[1]]:addObject(self)
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

        if y > 0 and y <= math.floor(mapObj.xy[2] / offset) then
            while j >= -distance do
                local x = self.xy[1]+j

                if x > 0 and x <= math.floor(mapObj.xy[1] / offset) then
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
    @return {{x,y}...}
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
