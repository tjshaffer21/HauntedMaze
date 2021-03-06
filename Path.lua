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
    
    obj.is_a          = "Path"          -- Type
    obj.contains      = {}              -- Objects in this path
    obj.char_traverse = chTraverse      -- Character traversal
    obj.enemy_traverse = enTraverse     -- Enemy traversal
    obj.priority      = 0               -- Drawing priority
    
    if contains ~= nil then table.insert(obj.contains, contains) end
    
    return obj
end

function Path:draw(x,y)
    love.graphics.draw(pathimg,x,y)
    
    local objects = self:findHighest()
    if objects ~= nil then
        if objects.priority > self.priority then
            objects:draw(x,y)
        else
            love.graphics.draw(pathimg,x,y)
        end
    end
end

function Path:addObject(object)
    table.insert(self.contains, object)
end

--[[--
    Check the path for the object.
    @parameter e
    @return bool
--]]--
function Path:findObjectType(typ)
    for i,v in ipairs(self.contains) do
        if v.is_a == typ then
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
            if v.priority > highest.priority then
                highest = v
            end
        end
    end
    
    return highest
end
