Pellet = {}
Pellet.__index = Pellet

function Pellet.create()
    local obj = {}
    setmetatable(obj, Pellet)
    
    obj.is_a     = "Pellet"
    obj.priority = 1
    obj.value    = 100
    
    return obj
end

function Pellet:getType()
    return self.is_a
end

function Pellet:getPriority()
    return self.priority
end

function Pellet:draw(img,x,y)
    love.graphics.draw(img,x,y)
end

function Pellet:getValue()
    return self.value
end

SuperPellet = {}
SuperPellet.__index = SuperPellet

function SuperPellet.create()
    local obj = {}
    setmetatable(obj, SuperPellet)
    
    obj.is_a        = "SuperPellet"
    obj.priority    = 1
    obj.value       = 500
    
    return obj
end

function SuperPellet:getType()
    return self.is_a
end

function SuperPellet:getPriority()
    return self.priority
end

function SuperPellet.draw(img,x,y)
    love.graphics.draw(img,x,y)
end

function SuperPellet.getValue()
    return self.value
end