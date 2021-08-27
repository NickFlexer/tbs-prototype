---
-- LoadMissionFrame.lua


local class = require "middleclass"

local BaseFrame = require "frames.base_frame"


local LoadMissionFrame = class("LoadMissionFrame", BaseFrame)

function LoadMissionFrame:initialize(data)
    BaseFrame.initialize(self)
    self:check_abstract_methods(LoadMissionFrame)

    if not data.logic then
        error("LoadMissionFrame:initialize(): no data.logic argument!")
    end

    self.logic = data.logic
end

function LoadMissionFrame:update(dt)
    self.logic:load_mission()
end

function LoadMissionFrame:draw()
    love.graphics.print("Loading ....", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

function LoadMissionFrame:when_done(action)
    -- body
end

function LoadMissionFrame:mouse_pressed(x, y, button, istouch)
    --
end

return LoadMissionFrame
