Wall = {}
Wall.__index = Wall

function Wall.create(removable)
    local obj = {}
    setmetatable(obj,Wall)
    
    obj.is_a      = "Wall"
    obj.removable = removable

    return obj
end

function Wall:getType()
    return self.is_a
end

function Wall:draw(x,y)
    love.graphics.draw(wallimg,x,y)
end

function Wall:isRemovable()
    return self.removable
end

function Wall:setRemovable(bool)
    self.removable = bool
end