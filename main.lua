dofile('Object.lua')
dofile('Path.lua')
dofile('Wall.lua')
dofile('Map.lua')

-- Globals
map = {} -- -1/-2: wall, 0 path

function load()
    --path = love.graphics.newImage("images/path.png")
    --wall = love.graphics.newImage("images/wall.png")
    
    --love.graphics.setBackgroundColor(255,255,255)
    local mapObj = Map.create(26,26)
    mapObj:generate_map(mapObj:getX(), mapObj:getY())
    map = mapObj:getMap()
end

function draw()
    draw_map()
end

function draw_map()
    --local iscreen = 0
    --local jscreen = 0
    for ik,i in pairs(map) do
        for jk,j in pairs(map[ik]) do
            if j:getType() == "Wall" then
                io.write("-1 ")
            elseif j:getType(j) == "Path" then
                io.write(" 0 ")
            elseif j:getType(j) == nil then
                io.write(" x ")
            else
                io.write(Object.getType(j))
            end
        end
        --iscreen = iscreen + 25
        --jscreen = 0
        io.write("\n")
    end
end

function run()
    load()
    draw()
end

run()