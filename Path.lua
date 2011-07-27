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

function Path:draw(img,x,y)
    local obj = self:findHighest()
    if obj == self then
        love.graphics.draw(img,x,y)
    else
        obj.draw(img,x,y)
    end
end

function Path:addObject(object)
    table.insert(self.contains, object)
end

--[[--
    Iterate through Path object and find which object contained within has
    highest priority.
    @return object with highest priority.
--]]--
function Path:findHighest()
    local highest = self
    for i,v in ipairs(self.contains) do
        if v:getPriority() > highest:getPriority() then
            highest = v
        end
    end
    
    return highest
end

function Path:canEnemyTraverse()
    return self.enem_traverse
end

function Path:canCharTraverse()
    return self.char_traverse
end