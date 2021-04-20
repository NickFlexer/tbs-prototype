---
-- main.lua


package.path = package.path .. ";lib/?/init.lua;lib/?.lua;src/?.lua"


local lovetoys = require "lovetoys"

local World = require "world.world"


lovetoys.initialize({
    globals = true,
    debug = true
})


local world


function love.load()
    engine = Engine()

    world = World()
end


function love.update(dt)
    engine:update(dt, world)
end


function love.draw()
    engine:draw()
end
