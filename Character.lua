Character = {}
Character.__index = Character

function Character.create(x,y)
    local obj = {}
    setmetatable(obj, Character)
    
    obj.is_a        = "Character"
    obj.priority    = 2
    obj.lives       = 3
    obj.speed       = 100
    obj.xy          = {x,y}
    obj.spawn       = {x,y}
    
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
    if y > 0 and y <= mapObj.xy[2] and x > 0 and x <= mapObj.xy[1] then
        if map[y][x].is_a == "Path" and map[y][x]:canCharTraverse() then
            if map[y][x]:findObjectType("Door") == nil then
                map[self.xy[2]][self.xy[1]]:removeObject(character)
                self:setXY(x,y)
                map[y][x]:addObject(character)
            else
                return false
            end
            
            return true
        end
    end
    
    return false
end

function Character:setXY(x,y)
    self.xy[1] = x
    self.xy[2] = y
end

function Character:addLife()
    self.lives = self.lives + 1
end

function Character:rmLife()
    self.lives = self.lives - 1
end