Wall = {}
Wall.__index = Wall

function Wall.create()
    local obj = {}
    setmetatable(obj,Wall)
    
    obj.is_a      = "Wall"

    return obj
end

function Wall:draw(x,y)
    love.graphics.draw(wallimg,x,y)
end