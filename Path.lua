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
    obj.contains      = nil
    obj.char_traverse = chTraverse
    obj.enem_traverse = enTraverse
    
    return obj
end

--[[--
    Return object type
    @return string
--]]--
function Path:getType()
    return self.is_a
end

--[[--
    @return nil if no object, else object.isType
--]]--
function Path:contains()
    if self.contains == nil then
        return nil
    else
        self.contains.getType()
    end
end

--[[--
    Set traverse by enemy
    @parameter bool - true/false
--]]--
function Path:traverseByEnemy(bool)
    self.enem_traverse = bool
end

--[[--
    Set traverse by character
    @parameter self
    @parameter bool - true/false
--]]--
function Path:traverseByCharacter(bool)
    self.char_traverse = bool
end

--[[--
    Return if traversable by enemy
    @retrun true/false
--]]--
function Path:traversableEnem()
    return self.enem_traverse
end

--[[--
    Return if traversable by character.
    @return true/false
--]]--
function Path:traversableChar()
    return self.char_traverse
end