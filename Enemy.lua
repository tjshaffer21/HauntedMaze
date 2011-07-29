Enemy = {}
Enemy.__index = Enemy

function Enemy.create()
    local obj = {}
    setmetatable(obj, Enemy)
    
    obj.is_a       = "Enemy"
    obj.priority   = 2
    obj.value      = 1000
    obj.vulnerable = false
    
    return obj
end

function Enemy:getType()
    return self.is_a
end

function Enemy:getPriority()
    return self.priority
end

function Enemy:draw(x,y)
    love.graphics.draw(enemyimg,x,y)
end

function Enemy:getValue()
    return self.value
end