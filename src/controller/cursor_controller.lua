---
-- cursor_controller.lua


local class = require "middleclass"

local NewCursorPositionEvent = require "event_manager.events.new_cursor_position_event"
local GameLoadedEvent = require "event_manager.events.game_loaded_event"


local CursorController = class("CursorController")

function CursorController:initialize(data)
    if not data.event_manager then
        error("CursorController:initialize(): no data.event_manager argument!")
    end

    if not data.tile_size then
        error("CursorController:initialize(): no data.tile_size argument!")
    end

    self.event_manager = data.event_manager
    self.tile_size = data.tile_size

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

function CursorController:update()
    if self.work then
        local cur_pos_x, cur_pos_y = love.mouse.getPosition()
        local cur_x = math.floor(cur_pos_x / self.tile_size + 1)
        local cur_y = math.floor(cur_pos_y / self.tile_size + 1)

        if cur_x ~= self.prev_x or cur_y ~= self.prev_y then
            self.prev_x = cur_x
            self.prev_y = cur_y

            self.event_manager:post(NewCursorPositionEvent(cur_x, cur_y))
        end
    end
end

return CursorController