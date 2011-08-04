Character = {}
Character.__index = Character

function Character.create(x,y)
    local obj = {}
    setmetatable(obj, Character)
    
    obj.is_a        = "Character"       -- Type
    obj.priority    = 2                 -- Drawing priority
    obj.lives       = 3                 -- Lives
    obj.speed       = 200               -- Movement speed
    obj.dxy         = {x*25, y*25}      -- Drawing coordinates
    obj.xy          = {x,y}             -- Map coordinates
    obj.spawn       = {x,y}             -- Spawn point
    
    return obj
end

function Character:draw(x,y)
    love.graphics.draw(characterimg,x,y)
end


--[[--
    Move character to position given in parameter.
    @parameter x
    @parameter y
    @return if move successful return true, else false
--]]--
function Character:moveChar(x,y)
    if (y >= 25 and y <= mapObj.xy[2]) and (x >= 25 and x <= mapObj.xy[1]+25) then
        local mod_x = math.floor(x/offset)
        local mod_y = math.floor(y/offset)
        if map[mod_y][mod_x].is_a == "Path" and map[mod_y][mod_x]:char_traverse then
            if map[mod_y][mod_x]:findObjectType("Door") == nil then
                self.dxy[1] = x
                self.dxy[2] = y

                map[self.xy[2]][self.xy[1]]:removeObject(character)
                self:setXY(mod_x,mod_y)
                map[mod_y][mod_x]:addObject(character)
            else
                return false
            end
            
            return true
        end
    end
    
    return false
end

function Character:setXY(x,y)
    self.xy[1]  = x
    self.xy[2]  = y
end

function Character:addLife()
    self.lives = self.lives + 1
end

function Character:rmLife()
    self.lives = self.lives - 1
end

function Character:respawn()
    map[self.xy[2]][self.xy[1]]:removeObject(self)
    
    self.xy[1] = self.spawn[1]
    self.xy[2] = self.spawn[2]
    
    self.dxy[1] = self.spawn[1]*offset
    self.dxy[2] = self.spawn[2]*offset
    
    map[self.xy[2]][self.xy[1]]:addObject(self)
end