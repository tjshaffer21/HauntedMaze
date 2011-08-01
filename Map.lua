Map = {}
Map.__index = Map

function Map.create()
    local obj = {}
    setmetatable(obj, Map)
    
    obj.filelist    = {"maps\\level1.dat", "maps\\level2.dat"}
    obj.fileindex   = 1
    obj.xy          = {nil,nil}
    return obj
end

function Map:loadNextLevel()
    self.fileindex = self.fileindex + 1
    if self.fileindex > #self.filelist then
        return false
    end
    
    self:generate_map()
    return true
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
         4 - Ghost
         5 - Character
         6 - Zombie
--]]--
function Map:generate_map() 
    io.input(self.filelist[self.fileindex])
    
    local line  = io.read("*number")    -- width
    self.xy[1]  = line
    line        = io.read("*number")    -- height
    self.xy[2]  = line
    
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
                    local door  = Door.create(j,i,"Timed",300)
                    newObject   = Path.create(door, false, true)
                    
                    table.insert(door_list, door)
                elseif s == "-2" then
                    local door  = Door.create(j,i,"Timed", 300)
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
                    local enemy = Ghost.create(j,i)
                    newObject   = Path.create(enemy, false, true)
                    
                    table.insert(enemy_list, enemy)
                elseif s == "5" then
                    character   = Character.create(j,i)
                    newObject   = Path.create(character, true, true)
                elseif s == "6" then
                    local enemy = Zombie.create(j,i)
                    newObject   = Path.create(enemy, false, true)
                    
                    table.insert(enemy_list, enemy)
                elseif s == "9" then
                    local ext   = ExitPoint.create()
                    newObject   = Path.create(ext, true, false)
                end
            end
            
            table.insert(mp, newObject)
            j = j+1
        end
        
        table.insert(map, mp)
        line = io.read()
        i = i + 1
    end
end