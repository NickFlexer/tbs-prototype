---
-- ui_viewer.lua


local class = require "middleclass"
local suit = require "suit"

local TurnNumberEvent = require "event_manager.events.turn_number_event"
local CurrentPhaseEvent = require "event_manager.events.current_phase_event"
local NewCursorPositionEvent = require "event_manager.events.new_cursor_position_event"
local PlayerUnitSelectedEvent = require "event_manager.events.player_unit_selected_event"
local UnselectUnitEvent = require "event_manager.events.unselect_unit_event"

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

    self.player_unit_tile = nil
    self.player_unit_move = nil
    self.player_unit_name = nil
    self.player_unit_range = nil

    self.draw_terrain_preview = false
    self.draw_unit_preview = false
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

    if event:isInstanceOf(PlayerUnitSelectedEvent) then
        local unit = event:get_unit()

        self.player_unit_tile = self:_get_unit_tile(unit)
        self.player_unit_name = unit:get_name()
        self.player_unit_move = unit:get_move()
        self.player_unit_range = unit:get_range()

        self.draw_unit_preview = true
    end

    if event:isInstanceOf(UnselectUnitEvent) then
        self.draw_unit_preview = false
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

    if self.draw_unit_preview then
        self.ui:Label(
            self.player_unit_name,
            {font = self.font, align = "left"},
            self.window_size.x, self.size * 14,
            self.size * 4, self.size
        )

        self.ui:Label(
            "Mv: " .. tostring(self.player_unit_move),
            {font = self.font, align = "left"},
            self.window_size.x, self.size * 15,
            self.size * 4, self.size
        )

        self.ui:Label(
            "Range: " .. tostring(self.player_unit_range),
            {font = self.font, align = "left"},
            self.window_size.x, self.size * 16,
            self.size * 4, self.size
        )
    end
end

function UIViewer:render_all()
    if self.draw_terrain_preview then
        self.drawer:draw_at(
            self.terrain_tile,
            self.window_size.x + self.size * 3,
            self.size * 6
        )
    end

    if self.draw_unit_preview then
        self.drawer:draw_at(
            Terrain.ground,
            self.window_size.x ,
            self.size * 12
        )

        self.drawer:draw_at(
            self.player_unit_tile,
            self.window_size.x ,
            self.size * 12
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

function UIViewer:_get_unit_tile(unit)
    return unit:get_team():get_name() .. "_" .. unit:get_name()
end

return UIViewer
