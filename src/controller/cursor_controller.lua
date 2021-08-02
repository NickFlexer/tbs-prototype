---
-- cursor_controller.lua


local class = require "middleclass"

local NewCursorPositionEvent = require "event_manager.events.new_cursor_position_event"
local GameLoadedEvent = require "event_manager.events.game_loaded_event"
local PositionPressedEvent = require "event_manager.events.position_pressed_event"


local CursorController = class("CursorController")

function CursorController:initialize(data)
    if not data.event_manager then
        error("CursorController:initialize(): no data.event_manager argument!")
    end

    if not data.tile_size then
        error("CursorController:initialize(): no data.tile_size argument!")
    end

    if not data.shift then
        error("CursorController:initialize(): no data.shift argument!")
    end

    self.event_manager = data.event_manager
    self.tile_size = data.tile_size
    self.shift = data.shift

    self.event_manager:register(self)

    self.prev_x = nil
    self.prev_y = nil

    self.work = false
end

function CursorController:notify(event)
    if event:isInstanceOf(GameLoadedEvent) then
        self.work = true
    end
end

function CursorController:update(dt)
    if self.work then
        local cur_pos_x, cur_pos_y = love.mouse.getPosition()
        local cur_x = math.floor((cur_pos_x - self.shift.x) / self.tile_size + 1)
        local cur_y = math.floor((cur_pos_y - self.shift.y) / self.tile_size + 1)

        if cur_x ~= self.prev_x or cur_y ~= self.prev_y and cur_x > 0 and cur_y > 0 then
            self.prev_x = cur_x
            self.prev_y = cur_y

            self.event_manager:post(NewCursorPositionEvent(cur_x, cur_y))
        end
    end
end

function CursorController:mouse_pressed()
    self.event_manager:post(PositionPressedEvent(self.prev_x, self.prev_y))
end

return CursorController
