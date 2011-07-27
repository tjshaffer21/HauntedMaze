Wall = {}
Wall.__index = Wall

--[[--
    Create a Wall object
    @parameter true if wall can be removed, false elsewise.
    @return table
--]]--
function Wall.create(removable)
    local obj = {}
    setmetatable(obj,Wall)
    
    obj.is_a      = "Wall"
    obj.removable = removable

    return obj
end

--[[--
    Return the type of object.
    @Returns string
--]]--
function Wall:getType()
    return self.is_a
end

function Wall:draw()
    io.write("- ")
end

--[[--
    Return if wall is removable
    @return bool
--]]--
function Wall:isRemovable()
    return self.removable
end

--[[--
    Set if wall is removable
    @parameter bool
--]]--
function Wall:setRemovable(bool)
    self.removable = bool
end