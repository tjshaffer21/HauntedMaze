Character = {}
Character.__index = Character

function Character.create(x,y)
    local obj = {}
    setmetatable(obj, Character)
    
    obj.is_a        = "Character"
    obj.priority    = 2
    obj.lives       = 3
    obj.x           = x
    obj.y           = y
    
    return obj
end

function Character:getType()
    return self.is_a
end

function Character:getPriority()
    return self.priority
end

function Character:draw(x,y)
    love.graphics.draw(characterimg,x,y)
end

function Character:getLives()
    return self.lives
end

function Character:addLife()
    self.lives = self.lives + 1
end

function Character:rmLife()
    self.lives = self.lives - 1
end