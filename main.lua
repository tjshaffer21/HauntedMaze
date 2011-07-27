dofile('Object.lua')

-- Globals
map = {} -- -1/-2: wall, 0 path

function load()
    --path = love.graphics.newImage("images/path.png")
    --wall = love.graphics.newImage("images/wall.png")
    
    --love.graphics.setBackgroundColor(255,255,255)
    local mapObj = Map.create("level1.dat",28,4)
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
            j:draw()
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