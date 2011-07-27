Map = {}
Map.__index = Map

--[[--
    Create Map object.
    @parameter x - width of map
    @parameter y - height of map
    @return table
--]]--
function Map.create(filename, x, y)
    local obj = {}
    setmetatable(obj, Map)
    
    obj.filename = filename
    obj.x        = x
    obj.y        = y
    obj.map      = {}
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
    
    local line = io.read()
    while line ~= nil do
        local mp = {}

        for s in line:gmatch('%d+') do
            local newObject = nil
            if s == "0" then
               newObject = Wall.create(false)
            else
                if s == "-1" then
                    newObject = Path.create(nil, false, true)
                elseif s == "1" then
                    --pellet    = Pellet.create()
                    newObject = Path.create(pellet, true, true)
                elseif s == "2" then
                    --super     = SuperPellet.create()
                    newObject = Path.create(super, true, true)
                elseif s == "3" then
                    newObject = Path.create(nil,true,true)
                elseif s == "4" then
                    --enemy     = Enemy.create()
                    newObject = Path.create(enemy, false, true)
                elseif s == "5" then
                    --char      = Character.create()
                    newObject = Path.create(char, true, true)
                end
            end
            
            table.insert(mp, newObject)
        end
        
        table.insert(self.map, mp)
        line = io.read()
    end
end