---
-- dummy_frame.lua


local class = require "middleclass"

local BaseFrame = require "frames.base_frame"


local DummyFrame = class("DummyFrame", BaseFrame)

function DummyFrame:initialize(data)
    BaseFrame.initialize(self)
    self:check_abstract_methods(DummyFrame)
end

function DummyFrame:update(dt)
    --
end

function DummyFrame:draw()
    love.graphics.print("Dummy", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

function DummyFrame:mouse_pressed(x, y, button, istouch)
    --
end

return DummyFrame
