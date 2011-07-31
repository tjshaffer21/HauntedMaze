ExitPoint = {}
ExitPoint.__index = ExitPoint

function ExitPoint.create()
    local obj = {}
    setmetatable(obj, ExitPoint)
    
    obj.is_a        = "Exit"
    obj.priority    = -1
    
    return obj
end