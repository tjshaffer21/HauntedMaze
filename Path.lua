Path = {}
Path.__index = Path

--[[--
    Create Path object
    @parameter contains   - Object contained in path, nil if nothing
    @parameter chTraverse - bool, can character traverse this path?
    @parameter enTraverse - bool, can enemy traverse this path?
    @return table
--]]--
function Path.create(contains, chTraverse, enTraverse)
    local obj = {}
    setmetatable(obj, Path)
    
    obj.is_a          = "Path"
    obj.contains      = {}
    obj.char_traverse = chTraverse
    obj.enem_traverse = enTraverse
    obj.priority      = 0
    
    if contains ~= nil then table.insert(obj.contains, contains) end
    
    return obj
end

function Path:getType()
    return self.is_a
end

function Path:getPriority()
    return self.priority
end

function Path:draw(x,y)
    love.graphics.draw(pathimg,x,y)
    
    local objects = self:findHighest()
    if objects ~= nil then
        objects:draw(x,y)
    end
end

function Path:addObject(object)
    table.insert(self.contains, object)
end

function Path:findObjectType(typ)
    for i,v in ipairs(self.contains) do
        if v:getType() == typ then
            return v
        end
    end
    
    return nil
end

--[[--
    Check the path for the object.
    @parameter e
    @return bool
--]]--
function Path:findObject(e)
    for i,v in ipairs(self.contains) do
        if v == e then return true end
    end
    
    return false
end

function Path:removeObject(object)
    for i,v in ipairs(self.contains) do
        if object == v then
            table.remove(self.contains,i)
        end
    end
end

function Path:canEnemyTraverse()
    return self.enem_traverse
end

function Path:canCharTraverse()
    return self.char_traverse
end

--Private
--[[--
    Iterate through Path object and find which object contained within has
    highest priority.
    @return object with highest priority.
--]]--
function Path:findHighest()
    local highest = nil
    for i,v in ipairs(self.contains) do
        if highest == nil then 
            highest = v
        else
            if v:getPriority() > highest:getPriority() then
                highest = v
            end
        end
    end
    
    return highest
end
