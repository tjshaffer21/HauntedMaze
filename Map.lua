dofile('Object.lua')
dofile('Path.lua')
dofile('Wall.lua')

Map = {}
Map.__index = Map

--[[--
    Create Map object.
    @parameter x - width of map
    @parameter y - height of map
    @return table
--]]--
function Map.create(x,y)
    local obj = {}
    setmetatable(obj, Map)
    
    obj.x = x
    obj.y = y
    
    obj.map = {}
    for i=1,x do
        obj.map[i] = {}
        for j = 1, y do
            obj.map[i][j] = Object.create(nil,nil)
        end
    end
    
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

function Map:generate_map(x,y)
    local xi         = (x / 2)
    local yi         = (y / 2)
    local start_path_x, start_path_y = self:generate_cell(xi, yi)
    
    for i=1,x do
        if i == 1 or i == x then
            for j=1,(y-1) do
                local newWall = Wall.create(false)
                self.map[i][j]:setType(newWall:getType())
                self.map[i][j]:setObject(newWall)
            end
        end
                
        newWall = Wall.create(false)
        self.map[i][1]:setType(newWall:getType())
        self.map[i][1]:setObject(newWall)
        
        newWall = Wall.create(false)
        self.map[i][y]:setType(newWall:getType())
        self.map[i][y]:setObject(newWall)
    end
end

function Map:generate_cell(x,y)
    local xi = x
    local yi = y
     
    for i=-2,2 do
        for j=-2,2 do
            if i == -2 or j == -2 or i == 2 or j == 2 then
                newWall = Wall.create(false)
                self.map[xi-i][yi-j]:setType(newWall:getType())
                self.map[xi-i][yi-j]:setObject(newWall)
            else
                newPath = Path.create(nil, false, true)
                self.map[xi-i][yi-j]:setType(newPath:getType())
                self.map[xi-i][yi-j]:setObject(newPath)
            end
        end
    end
    
    local door = 1 -- Needs to be replaced by random(1,4)
    local rx = 0
    local ry = 0
    dPath = Path.create(nil,false, true)
    
    if door == 1 then
        self.map[xi-2][yi] = dPath

        rx = xi - 3
        ry = yi
    elseif door == 2 then
        self.map[xi][yi+2] = dPath
        
        rx = xi
        ry = yi + 3
    elseif door == 3 then
        self.map[xi+2][yi] = dPath
        
        rx = xi + 3
        ry = yi
    else
        self.map[xi][yi-2] = dPath
        
        rx = xi + 3
        ry = yi
    end
    
    self.map[rx][ry] = Path.create(nil,true,true)
    return rx,ry
end