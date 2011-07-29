Door = {}
Door.__index = Door

--[[--
    Create a Door object.
    @parameter x
    @parameter y
    @parameter lock (Time, Key)
    @parameter key
        if key <= 0, then door is ready to be unlocked
    @return table
--]]--
function Door.create(x,y,lock,key)
    local obj = {}
    setmetatable(obj, Door)
    
    obj.is_a      = "Door"
    obj.x         = x
    obj.y         = y
    obj.lock      = lock
    obj.key       = key
    obj.is_locked = true
    
    return obj
end

function Door:getType() 
    return self.is_a
end

function Door:draw(x,y)
    love.graphics.draw(doorimg,x,y)
end

function Door:getX()
    return self.x
end

function Door:getY()
    return self.y
end

function Door:getLock()
    return self.lock
end

function Door:key()
    return self.key
end

function Door:setKey(val)
    self.key = val
end

--[[--
    Decrement key value by 1.
    @return true if door becomes unlocked, else false
--]]--
function Door:updateKey(dt)
    self.key = self.key - (dt*100)
    
    if self.key <= 0.001 then 
        self:unlock()
        return true
    end
    
    return false
end

function Door:isLocked()
    return self.is_locked
end

function Door:unlock()
    self.is_locked = false
end