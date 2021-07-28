---
-- ui_viewer.lua


local class = require "middleclass"
local suit = require "suit"

local TurnNumberEvent = require "event_manager.events.turn_number_event"


local UIViewer = class("UIViewer")

function UIViewer:initialize(data)
    if not data.event_manager then
        error("UIViewer:initialize(): no data.event_manager argument!")
    end

    self.event_manager = data.event_manager

    self.event_manager:register(self)

    self.ui = suit.new()
    self.font = love.graphics.newFont("res/fonts/keyrusMedium.ttf", 18)
    self.size = 32

    self.turn_number = nil
end

function UIViewer:notify(event)
    if event:isInstanceOf(TurnNumberEvent) then
        self.turn_number = event:get_number()
    end
end

function UIViewer:update(dt)
    self.ui:Label(
        "TURN: " .. tostring(self.turn_number),
        {font = self.font},
        0, 0,
        self.size * 3, self.size
    )

    self.ui:Label(
        "phase: red team",
        {font = self.font},
        self.size * 3, 0,
        self.size * 8, self.size
    )
end

function UIViewer:render_all()
    self.ui:draw()
end

return UIViewer
