---
-- controller.lua


local class = require "middleclass"
local Input = require "input"

local QuitEvent = require "event_manager.events.quit_event"


local Controller = class("Controller")

function Controller:initialize(data)
    if not data.event_manager then
        error("Controller:initialize(): no data.event_manager argument!")
    end

    self.event_manager = data.event_manager

    self.event_manager:register(self)

    self.input = Input()

    self.key_table = {
        {"escape", function () return self.event_manager:post(QuitEvent()) end}
    }

    self:_set_key_table()
end

function Controller:notify(event)
    -- body
end

function Controller:_set_key_table()
    for _, val in ipairs(self.key_table) do
        self.input:bind(val[1], val[2])
    end
end

return Controller
