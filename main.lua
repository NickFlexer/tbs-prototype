---
-- main.lua


package.path = package.path .. ";lib/?/init.lua;lib/?.lua;src/?.lua"


local Game = require "game.game"


local game


function love.load()
    game = Game()
    game:on_launched()
end


function love.update(dt)
    local frame = game:get_current_frame()
    frame:update(dt)
end


function love.draw()
    local frame = game:get_current_frame()
    frame:draw()
end

function love.mousepressed(x, y, button, istouch)
    local frame = game:get_current_frame()
    frame:mouse_pressed(x, y, button, istouch)
end
