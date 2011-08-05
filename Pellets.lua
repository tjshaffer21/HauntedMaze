--[[--------------------------------Pellet------------------------------------
--                                                                          --
-- A normal type of pellet. All pellets, including SuperPellets must be     --
-- be gathered to advance to the next level.                                --
-- Value:   100
--------------------------------------------------------------------------]]--
Pellet = {}
Pellet.__index = Pellet

function Pellet.create()
    local obj = {}
    setmetatable(obj, Pellet)
    
    obj.is_a     = "Pellet"             -- Type
    obj.priority = 1                    -- Drawing priority
    obj.value    = 100                  -- Point value
    
    return obj
end

function Pellet:draw(x,y)
    love.graphics.draw(pelletimg,x,y)
end

--[[----------------------------SuperPellet-----------------------------------
--                                                                          --
-- SuperPellets are rarer than normal Pellets. As a side-effect they provide--
-- temporary vulnerability to the enemies.                                  --
-- Value:   500                                                             --
--------------------------------------------------------------------------]]--

SuperPellet = {}
SuperPellet.__index = SuperPellet

function SuperPellet.create()
    local obj = {}
    setmetatable(obj, SuperPellet)
    
    obj.is_a        = "SuperPellet"     -- Type
    obj.priority    = 1                 -- Drawing priority
    obj.value       = 500               -- Point value
    
    return obj
end

function SuperPellet:draw(x,y)
    love.graphics.draw(spelletimg,x,y)
end