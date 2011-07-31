Character = {}
Character.__index = Character

function Character.create(x,y)
    local obj = {}
    setmetatable(obj, Character)
    
    obj.is_a        = "Character"
    obj.priority    = 2
    obj.lives       = 3
    obj.xy          = {x,y}
    obj.spawn       = {x,y}
    
    return obj
end

function Character:draw(x,y)
    love.graphics.draw(characterimg,x,y)
end

function Character:setXY(x,y)
    self.xy[1] = x
    self.xy[2] = y
end

function Character:addLife()
    self.lives = self.lives + 1
end

function Character:rmLife()
    self.lives = self.lives - 1
end