---
-- game.lua


local class = require "middleclass"

local FrameTypes = require "frames.frame_types"

local DummyFrame = require "frames.dummy_frame.dummy_frame"


local Game = class("Game")

function Game:initialize(data)
    self.current_frame = nil
end

function Game:on_launched()
    self:navigate_to(FrameTypes.dummy)
end

function Game:navigate_to(frame_type)
    local frame = self:_create_frame(frame_type)
    self.current_frame = frame
end

function Game:get_current_frame()
    return self.current_frame
end

function Game:_create_frame(frame_type)
    if frame_type == FrameTypes.dummy then
        local frame = DummyFrame()

        return frame
    end
end

return Game
