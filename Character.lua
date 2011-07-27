Character = {}
Character.__index = Character

function Character.create()
    local obj = {}
    setmetatable(obj, Character)
    
    obj.is_a        = "Character"
    obj.priority    = 2
    obj.lives       = 3
    
    return obj
end

function Character:getType()
    return self.is_a
end

function Character:getPriority()
    return self.priority
end

function Character:draw(img,x,y)
    love.graphics.draw(img,x,y)
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