Door = {}
Door.__index = Door

--[[--
    Create a Door object.
    @parameter x        Int
    @parameter y        Int
    @parameter lock     String:(Time, Key)
    @parameter key      Int
        if key <= 0, then door is ready to be unlocked
    @return table
--]]--
function Door.create(x,y,lock,key)
    local obj = {}
    setmetatable(obj, Door)
    
    obj.is_a      = "Door"
    obj.xy        = {x,y}
    obj.lock      = lock
    obj.key       = key
    obj.is_locked = true
    
    return obj
end

function Door:draw(x,y)
    love.graphics.draw(doorimg,x,y)
end

--[[--
    Decrement key value by 1.
    @return true if door becomes unlocked, else false
--]]--
function Door:updateKey(dt)
    self.key = self.key - (dt*100)
    
    if self.key <= 0.001 then 
        self.is_locked = false
        return true
    end
    
    return false
end