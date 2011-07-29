Enemy = {}
Enemy.__index = Enemy

function Enemy.create(x,y)
    local obj = {}
    setmetatable(obj, Enemy)
    
    obj.is_a       = "Enemy"
    obj.priority   = 2
    obj.value      = 1000
    obj.vulnrable  = false
    obj.vultimer   = 500
    obj.x          = x
    obj.y          = y
    
    return obj
end

function Enemy:getType()
    return self.is_a
end

function Enemy:getPriority()
    return self.priority
end

function Enemy:draw(x,y)
    if self:isVulnerable() then
        love.graphics.draw(vulenemyimg, x, y)
    else
        love.graphics.draw(enemyimg,x,y)
    end
end

function Enemy:getX()
    return self.x
end

function Enemy:getY()
    return self.y
end

function Enemy:setX(x)
    self.x = x
end

function Enemy:setY(y)
    self.y = y
end

function Enemy:setXY(x,y)
    self.x = x
    self.y = y
end

function Enemy:getValue()
    return self.value
end

function Enemy:isVulnerable()
    return self.vulnrable
end

function Enemy:invulnerable()
    self.vulnrable = false
    self.vultimer   = 500
end

function Enemy:vulnerable()
    if self.vulnrable == true then
        self.vultimer = self.vultimer + 100
    else
        self.vulnrable = true
    end
end

--[[--
    Decrement the vulnerability timer.
    @return true if timer reaches zero, else false
--]]--
function Enemy:updateTimer(dt)
    self.vultimer = self.vultimer - (dt*100)

    if self.vultimer <= 0.001 then
        self:invulnerable()
        return true
    end
    
    return false
end