Object = {}
Object.__index = Object

--[[--
    Create Object container.
    @parameter typ - Type of object
    @parameter object - Object
    @return table
--]]--
function Object.create(typ,object)
    local obj = {}
    setmetatable(obj,Object)
    
    obj.is_a   = typ
    obj.object = object
    
    return obj
end

   
--[[--
    Set the type of Object
    @parameter tpe - String declaring type
--]]--
function Object:setType(tpe)
    self.is_a = tpe
end

--[[--
    Return type of object
    @return string
--]]--
function Object:getType()
    return self.is_a
end

--[[--
    Set the object
    @parameter object
--]]--
function Object:setObject(obj)
    self.object = obj
end

--[[--
    Get the object
    @return object
--]]--
function Object:getObject()
    return self.object
end