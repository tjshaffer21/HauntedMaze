Map = {}
Map.__index = Map

--[[--
    Create Map object.
    @filename
    @return table
--]]--
function Map.create(filename)
    local obj = {}
    setmetatable(obj, Map)
    
    obj.filename    = filename
    obj.map         = {}
    obj.x           = nil
    obj.y           = nil
    return obj
end

function Map:getX()
    return self.x
end

function Map:getY()
    return self.y
end

function Map:getMap()
    return self.map
end

--[[--
    Read and parse the file.
    Data:
        -4 - Locked door, traversable path
        -3 - Timed door, not traversable path
        -2 - Timed door, traversable path
        -1 - Path not traversable by character.
         0 - Wall
         1 - Traversable path, with pellet
         2 - Traversable path, with supper pellet
         3 - Traversable path, with no pellet
         4 - Enemy
         5 - Character
--]]--
function Map:generate_map() 
    io.input(self.filename)
    
    local line  = io.read("*number")    -- width
    self.x      = line
    line        = io.read("*number")    -- height
    self.y      = line
    
    local i = 1             -- y-coordinate
    line = io.read()
    while line ~= nil do
        local mp = {}
        local j  = 1        -- x-coordinate
        
        for s in line:gmatch('(-?%d+)') do
            local newObject = nil
            if s == "0" then
               newObject = Wall.create()
            else
                if s == "-4" then
                    local door  = Door.create(j,i, "Key", 1)
                    newObject   = Path.create(door, true, false)
                    
                    table.insert(door_list, door)
                elseif s == "-3" then
                    local door  = Door.create(j,i,"Timed",30)
                    newObject   = Path.create(door, false, true)
                    
                    table.insert(door_list, door)
                elseif s == "-2" then
                    local door  = Door.create(j,i,"Timed", 30)
                    newObject   = Path.create(door, true, true)
                    
                    table.insert(door_list, door)
                elseif s == "-1" then
                    newObject = Path.create(nil, false, true)
                elseif s == "1" then
                    local pellet    = Pellet.create()
                    newObject       = Path.create(pellet, true, true)
                    numPellets      = numPellets + 1
                elseif s == "2" then
                    local super = SuperPellet.create()
                    newObject   = Path.create(super, true, true)
                    numPellets  = numPellets + 1
                elseif s == "3" then
                    newObject = Path.create(nil,true,true)
                elseif s == "4" then
                    enemy     = Enemy.create()
                    newObject = Path.create(enemy, false, true)
                elseif s == "5" then
                    character   = Character.create(j,i)
                    newObject   = Path.create(character, true, true)
                end
            end
            
            table.insert(mp, newObject)
            j = j+1
        end
        
        table.insert(self.map, mp)
        line = io.read()
        i = i + 1
    end
end