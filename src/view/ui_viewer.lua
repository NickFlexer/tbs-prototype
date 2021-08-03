---
-- ui_viewer.lua


local class = require "middleclass"
local suit = require "suit"

local TurnNumberEvent = require "event_manager.events.turn_number_event"
local CurrentPhaseEvent = require "event_manager.events.current_phase_event"
local NewCursorPositionEvent = require "event_manager.events.new_cursor_position_event"

local Terrain = require "data.enums.terrains"


local UIViewer = class("UIViewer")

function UIViewer:initialize(data)
    if not data.event_manager then
        error("UIViewer:initialize(): no data.event_manager argument!")
    end

    if not data.model then
        error("UIViewer:initialize(): no data.model argument!")
    end

    if not data.window_size then
        error("UIViewer:initialize(): no data.window_size argument!")
    end

    if not data.drawer then
        error("UIViewer:initialize(): no data.drawer argument!")
    end

    self.event_manager = data.event_manager
    self.model = data.model
    self.window_size = data.window_size
    self.drawer = data.drawer

    self.event_manager:register(self)

    self.ui = suit.new()
    self.font = love.graphics.newFont("res/fonts/keyrusMedium.ttf", 18)
    self.size = 32

    self.turn_number = nil
    self.phase_name = nil

    self.terrain_tile = nil
    self.terrain_name = "-"
    self.terrain_mv_cost = "-"

    self.draw_terrain_preview = false
end

function UIViewer:notify(event)
    if event:isInstanceOf(TurnNumberEvent) then
        self.turn_number = event:get_number()
    end

    if event:isInstanceOf(CurrentPhaseEvent) then
        self.phase_name = event:get_name()
    end

    if event:isInstanceOf(NewCursorPositionEvent) then
        local data = self.model:get_data()
        local x, y = event:get_position()

        if data:get_map():get_cell(x, y) then
            self.terrain_tile = self:_get_terrain_tile(data:get_map():get_cell(x, y):get_terrain())
            self.terrain_name = data:get_map():get_cell(x, y):get_terrain()
            self.terrain_mv_cost = tostring(data:get_map():get_cell(x, y):get_move_cost())

            self.draw_terrain_preview = true
        else
            self.terrain_name = "-"
            self.terrain_mv_cost = "-"
            self.draw_terrain_preview = false
        end
    end
end

function UIViewer:update(dt)
    -- top pannel
    self.ui:Label(
        "TURN: " .. tostring(self.turn_number),
        {font = self.font},
        0, 0,
        self.size * 3, self.size
    )

    self.ui:Label(
        "phase: " .. tostring(self.phase_name) .. " team",
        {font = self.font},
        self.size * 3, 0,
        self.size * 8, self.size
    )

    -- right pannel
    self.ui:Label(
        "Terrain: " .. self.terrain_name,
        {font = self.font},
        self.window_size.x, self.size * 8,
        self.size * 8, self.size
    )

    self.ui:Label(
        "Mv cost: " .. self.terrain_mv_cost,
        {font = self.font},
        self.window_size.x, self.size * 9,
        self.size * 8, self.size
    )
end

function UIViewer:render_all()
    if self.draw_terrain_preview then
        self.drawer:draw_at(
            self.terrain_tile,
            self.window_size.x + self.size * 3,
            self.size * 6
        )
    end

    self.ui:draw()
end

function UIViewer:_get_terrain_tile(terrain)
    if terrain == Terrain.water then
        return terrain .. "_0"
    end

    return terrain
end

return UIViewer
