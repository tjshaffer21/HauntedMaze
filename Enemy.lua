--[[----------------------------Enemy-----------------------------------------
--                                                                          --
--                      Basic functions found in all Enemy types.           --
--------------------------------------------------------------------------]]--
--[[--
    Move to given x,y.
    @parameter x - drawing x-coordinate
    @parameter y - drawing y-coordinate
    @return 1 if successful, -1 if boundary issue, else 0 if path issue (wall,door,etc)
--]]--
function moveEnemy(self,x,y)
    if y > 0 and y <= mapObj.xy[2] and x > 0 and x <= mapObj.xy[1] then
        -- Convert to map coordinates
        local mod_x = math.floor(x / offset)
        local mod_y = math.floor(y / offset)
    
        if map[mod_y][mod_x].is_a == "Path" and map[mod_y][mod_x].enemy_traverse then
            if map[mod_y][mod_x]:findObjectType("Door") == nil then
                self.dxy[1] = x
                self.dxy[2] = y
                
                map[self.xy[2]][self.xy[1]]:removeObject(self)
                setXY(self,mod_x,mod_y)
                map[mod_y][mod_x]:addObject(self)
                
                return 1
            else
                self.path = {}
                return 0
            end
        end
        return 0
    end

    return -1
end

--[[--
    Decrement the vulnerability timer.
    Calls invulnerable if reaches zero.
    @parameter self
    @parameter dt
    @return true if timer reaches zero, else false
--]]--
function updateVulnerability(self,dt)
    self.vulnerability  = self.vulnerability - (self.vulnerability_spd * dt)
    
    if self.vulnerability <= 0.001 then
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
    self.vulnerability  = 500
end

--[[--
    Enemy becomes vulnerable or adds to previous vulnerability.
    @parameter self
--]]--
function vulnerable(self)
    if self.is_vulnerable == true then
        self.vulnerability = self.vulnerability + 500
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

--[[--
    Check if a path is at the coordinates.
    @parameter x
    @parameter y
    @return bool
--]]--
function isPath(x,y)
    if y > 0 and y <= math.floor(mapObj.xy[2] / offset) and 
      x > 0 and x <= math.floor(mapObj.xy[1] / offset) then
        if map[y][x].is_a == "Path" then return true end
    end
    
    return false
end

--[[--
    Finds available paths.
    @parameter self
    @parameter distance - Distance to search in each direction
    @return table of paths.
--]]--
function getPaths(self,distance)
    local paths = {}
    
    local i    = 1
    local x    = self.xy[1] - 1
    local y    = self.xy[2]
    if not (x == self.pxy[1] and y == self.pxy[2]) or (map[y][x]:findObject("Door") == nil) then
        local path = {}
        while (x > 0 and (map[y][x].is_a == "Path")) and i <= distance do
            table.insert(path, {x,y})
            x = x - 1
            i = i + 1
        end

        if #path > 0 then
            table.insert(paths,path)
        end
    end

    i   = 1
    x   = self.xy[1] + 1
    y   = self.xy[2]
    if not (x == self.pxy[1] and y == self.pxy[2]) or (map[y][x]:findObject("Door") == nil) then
        local path = {}
        while (x <= math.floor(mapObj.xy[1]/25) and (map[y][x].is_a == "Path"))
          and i <= distance do
            table.insert(path, {x,y})
            x = x + 1
            i = i + 1
        end

        if #path > 0 then
            table.insert(paths,path)
        end
    end

    i   = 1
    x   = self.xy[1]
    y   = self.xy[2] - 1
    if not (x == self.pxy[1] and y == self.pxy[2]) or (map[y][x]:findObject("Door") == nil) then
        local path = {}
        while (y > 0 and (map[y][x].is_a == "Path")) and i <= distance do
            table.insert(path, {x,y})
            y = y - 1
            i = i + 1
        end

        if #path > 0 then
            table.insert(paths,path)
        end
    end

    i   = 1
    x   = self.xy[1]
    y   = self.xy[2] + 1
    if not (x == self.pxy[1] and y == self.pxy[2]) or (map[y][x]:findObject("Door") == nil) then
        local path = {}
        while (y <= math.floor(mapObj.xy[2]/25) and (map[y][x].is_a == "Path"))
          and i <= distance do
            table.insert(path, {x,y})
            y = y + 1
            i = i + 1
        end

        if #path > 0 then
            table.insert(paths, path)
        end
    end

    return paths
end


--[[--
    Get the adjacent paths of the given {x,y} value.
    @parameter x
    @parameter y
    @parameter counter
    @return list - table of adjacent paths.
--]]--
function getAdjacentPaths(x,y,counter)
    local list = {}

    local nx = x + 1
    local ny = y
    
    if isPath(nx,ny) then
        table.insert(list, {nx,ny,counter})
    end
    
    nx = x - 1
    ny = y
    
    if isPath(nx,ny) then
        table.insert(list, {nx,ny,counter})
    end
    
    nx = x
    ny = y + 1
    
    if isPath(nx,ny) then
        table.insert(list, {nx,ny,counter})
    end
    
    nx = x
    ny = y - 1
    
    if isPath(nx,ny) then
        table.insert(list, {nx,ny,counter})
    end

    return list
end

--[[--
    Recursively finds the path from {cx,cy} to {dx,dy}
    Algorithm:
        1. Create a list of the four adjacent cells with a counter variable
           {x,y,c}
        2. Check each cell:
            a. If the cell is a wall then remove from the list 
               (getAdjacentPaths only includes Path cells).
            b. If the {x,y} element is already in the queue with a <= counter
               then remove it from the list.
        3. If distance between the next cell and the destination cell is less
           than the distance between current cell and the destination cell then
           add to the queue.
        4. Repeat until {cx,cy} == {dx,dy}
    @parameter cx       - current x
    @parameter cy       - current y
    @parameter dx       - destination x
    @parameter dy       - destination y
    @parameter queue    - main call: nil.
    @parameter counter  - main call: 0.
    @return queue       - table of {dx,dy,counter}
--]]--
function pathFinding(cx,cy,dx,dy,queue,counter)
    if cx == dx and cy == dy then
        return queue
    end
    
    local c = counter + 1  
    local q = {}
    local distance = math.sqrt(
        math.pow(dx-cx,2) + math.pow(dy-cy,2))

    if queue == nil then
        table.insert(q,{cx,cy,0})
    else
        q = queue
    end

    local list  = getAdjacentPaths(cx,cy, c)

    local j = 1
    while j > 0 and #list > 0 and j <= #list do
        local curr = j              -- Take removals into account.
        for k,v in ipairs(q) do
            if v[1] == list[j][1] and v[2] == list[j][2] and v[3] <= list[j][3] then
                table.remove(list,j)
                j = j - 1
                
                if j <= 0 then break end
            end
        end
        
        j = j + 1
    end
    
    for k,v in ipairs(list) do     
        local newDistance = math.sqrt(
            math.pow(dx-v[1],2) + math.pow(dy-v[2],2))        

        if newDistance < distance then
            table.insert(q,v)
            
            pathFinding(v[1],v[2],dx,dy,q,c)   
        end
    end
    
    return q
end

--[[--------------------------------Zombie------------------------------------
--                                                                          --
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
    
    obj.is_a        = "Enemy"           -- Type
    obj.kind        = "Zombie"          -- Kind
    obj.priority    = 2                 -- Drawing priority
    obj.value       = 250               -- Points value
    obj.speed       = 50                -- Movement speed

    obj.path        = {}                -- Current movement path
    
    obj.is_vulnerable       = false     -- Vulnerability
    obj.vulnerability       = 500       -- Vulnerability length
    obj.vulnerability_spd   = 100       -- Speed at which vulnerability decreases
    
    obj.dxy     = {x*offset,y*offset}   -- Drawing {x,y}
    obj.xy      = {x,y}                 -- Current {x,y}
    obj.pxy     = {-1,-1}               -- Previous {x,y}
    obj.spawn   = {x,y}                 -- Spawn {x,y}
    
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
        local paths = getPaths(self,100)

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
    map[self.xy[2]][self.xy[1]]:removeObject(self)
    
    self.xy[1] = self.spawn[1]
    self.xy[2] = self.spawn[2]
    
    self.dxy[1] = self.xy[1] * offset
    self.dxy[2] = self.xy[2] * offset
    
    map[self.xy[2]][self.xy[1]]:addObject(self)
    
    self.path = {}
end


--[[--------------------------------Ghost-------------------------------------
--                                                                          --
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
    
    obj.is_a        = "Enemy"           -- Type
    obj.kind        = "Ghost"           -- Kind
    obj.priority    = 2                 -- Drawing priority
    obj.value       = 500               -- Points value
    
    obj.speed       = 200               -- Movement speed
    obj.path        = {}                -- Current movement path
    
    
    obj.is_vulnerable       = false     -- Vulnerability
    obj.vulnerability       = 500       -- Vulnerability length
    obj.vulnerability_spd   = 100       -- Speed at which vulnerability decreases
    
    obj.dxy     = {x*offset,y*offset}   -- Drawing {x,y}
    obj.xy      = {x,y}                 -- Current {x,y}
    obj.pxy     = {-1,-1}               -- Previous {x,y}
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
    local target = self:lineOfSight()
    
    -- Target found
    if not (target == nil) then
        if self.is_vulnerable then  -- Flee
            self.path       = {}
            local fleePath  = getPaths(self,1)

            local distance  = math.sqrt(
                math.pow(target[1]-self.xy[1],2) + math.pow(
                target[2]-self.xy[2],2))
                
            for i,v in ipairs(fleePath) do
                local newDistance = math.sqrt(
                    math.pow(target[1]-v[1][1],2) + math.pow(target[2]-v[1][2],2))
                    
                if newDistance > distance then
                    table.insert(self.path,v[1])
                    break
                end
            end
        else                        -- Chase
            local path = pathFinding(self.xy[1], self.xy[2], target[1], 
              target[2],nil,0)
            table.remove(path,1) -- Already at first element

            if #path > 0 then
                self.path = {}
                for i,v in ipairs(path) do
                    table.insert(self.path,v)
                end
            end
        end
    end

    -- Find next move
    if #self.path == 0 then
        local paths  = getPaths(self,1)
        if #paths >= 1 then
            local pick  = math.random(1,#paths)
            self.path   = paths[pick]
        elseif #paths == 0 then -- If no path found, allow backtrack.
            self.pxy[1] = -1
            self.pxy[2] = -1
            self.path   = {}
        end
    else
        local nx = self.path[1][1]
        local ny = self.path[1][2]
        
        local dxy = calculateDxDy(self,nx,ny,dt)
        if moveEnemy(self,dxy[1],dxy[2]) then
            if self.xy[1] == nx and self.xy[2] == ny then
                table.remove(self.path,1)
            end
        else
            self.path = {}
        end
    end
end

function Ghost:respawn()
    map[self.xy[2]][self.xy[1]]:removeObject(self)
    
    self.xy[1] = self.spawn[1]
    self.xy[2] = self.spawn[2]
    
    self.dxy[1] = self.xy[1] * offset
    self.dxy[2] = self.xy[2] * offset
    
    map[self.xy[2]][self.xy[1]]:addObject(self)
    
    self.path = {}
end

---- Private
--[[--
    Scan the enemies line of sight
    @return target, if target is found within los then return {x,y}.
--]]--
function Ghost:lineOfSight()
    local distance  = 3

    local i = -distance
    while i <= distance do
        local y = self.xy[2]+i
        local j = -1

        if y > 0 and y <= math.floor(mapObj.xy[2] / offset) then
            -- [-distance, 0)
            while j >= -distance do
                local x = self.xy[1]+j

                if x > 0 and x <= math.floor(mapObj.xy[1] / offset) then
                    if map[y][x] ~= nil and map[y][x].is_a == "Path" then
                        -- Ignore path if another Enemy is there
                        if map[y][x]:findObjectType("Enemy") == nil then
                            if map[y][x]:findObjectType("Character") ~= nil then
                                return {self.xy[1]+j,self.xy[2]+i}
                            end
                        end
                    end
                end
            
                j = j - 1
            end
            
            -- [0,distance]
            j = 0
            while j <= distance do
                local x = self.xy[1]+j
                
                if x >= 1 and x <= mapObj.xy[1] then
                    if map[y][x] ~= nil and map[y][x].is_a == "Path" then
                        -- Ignore path if another Enemy is there
                        if map[y][x]:findObjectType("Enemy") == nil then
                            if map[y][x]:findObjectType("Character") ~= nil then
                                return {self.xy[1]+j,self.xy[2]+i}
                            end
                        end
                    end
                end
                j = j + 1
            end
        end
        i = i + 1
    end

    return nil
end
