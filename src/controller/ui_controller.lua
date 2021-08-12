---
-- ui_controller.lua


local class = require "middleclass"
local suit = require "suit"

local TurnEndEvent = require "event_manager.events.turn_end_event"


local UiController = class("UiController")

function UiController:initialize(data)
    if not data.event_manager then
        error("UiController:initialize(): no data.event_manager argument!")
    end

    self.event_manager = data.event_manager

    self.event_manager:register(self)
    self.ui = suit.new()

    self.font = love.graphics.newFont("res/fonts/keyrusMedium.ttf", 18)
    self.size = 32
end

function UiController:update(dt)
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if self.ui:Button("END TURN", {font = self.font},w - self.size * 8, h - self.size, self.size * 8, self.size).hit then
        self.event_manager:post(TurnEndEvent())
    end
end

function UiController:render_all()
    self.ui:draw()
end

function UiController:notify(event)
    -- body
end

return UiController
