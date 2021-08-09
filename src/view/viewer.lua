---
-- viewer.lua


local class = require "middleclass"
local Timer = require "hump.timer"

local Terrain = require "data.enums.terrains"
local TeamOwner = require "data.enums.team_owner"

local UpdateMapViewEvent = require "event_manager.events.update_map_view_event"
local NewCursorPositionEvent = require "event_manager.events.new_cursor_position_event"
local UpdateUnitsViewEvent = require "event_manager.events.update_units_view_event"
local UpdateMoveAreaEvent = require "event_manager.events.update_move_area_event"
local UnselectUnitEvent = require "event_manager.events.unselect_unit_event"
local NewPathEvent = require "event_manager.events.new_path_event"
local RemovePathEvent = require "event_manager.events.remove_path_event"


local function ternary(cond , T , F)
    if cond then return T else return F end
end


local Viewer = class("Viewer")

function Viewer:initialize(data)
    if not data.event_manager then
        error("Viewer:initialize(): no data.event_manager argument!")
    end

    if not data.model then
        error("Viewer:initialize(): no data.model argument!")
    end

    if not data.drawer then
        error("Viewer:initialize(): no data.drawer argument!")
    end

    if not data.tile_size then
        error("Viewer:initialize(): no data.tile_size argument!")
    end

    if not data.shift then
        error("Viewer:initialize(): no data.shift argument!")
    end

    self.event_manager = data.event_manager
    self.model = data.model
    self.drawer = data.drawer
    self.tile_size = data.tile_size
    self.shift = data.shift

    self.event_manager:register(self)

    self.map_canvas = nil
    self.unit_canvas = nil
    self.cursor_canvas = nil
    self.move_area_canvas = nil
    self.path_canvas = nil

    self.draw_map = false
    self.draw_units = false
    self.draw_cursor = false
    self.draw_move_area = false
    self.draw_path = false

    self.timer = Timer.new()
    self.max_tick = 2
end

function Viewer:update(dt)
    self.timer:update(dt)
end

function Viewer:notify(event)
    if event:isInstanceOf(UpdateMapViewEvent) then
        if not self.map_canvas then
            local size_x, size_y = self.model:get_data():get_map():get_size()
            self.map_canvas = love.graphics.newCanvas(size_x * self.tile_size, size_y * self.tile_size)
        end

        self.map_canvas:renderTo(
            function ()
                self:_render_map()
            end
        )

        self.draw_map = true
    end

    if event:isInstanceOf(UpdateUnitsViewEvent) then
        if not self.unit_canvas then
            local size_x, size_y = self.model:get_data():get_map():get_size()
            self.unit_canvas = love.graphics.newCanvas(size_x * self.tile_size, size_y * self.tile_size)
        end

        self.tick = 1

        self.timer:every(0.5, function ()
            self.unit_canvas:renderTo(
                function ()
                    love.graphics.clear()
                    self:_render_units(self.tick)
                end
            )

            self.tick = self.tick + 1

            if self.tick > self.max_tick then
                self.tick = 1
            end
        end)

        self.draw_units = true
    end

    if event:isInstanceOf(NewCursorPositionEvent) then
        if not self.cursor_canvas then
            local size_x, size_y = self.model:get_data():get_map():get_size()
            self.cursor_canvas = love.graphics.newCanvas(size_x * self.tile_size, size_y * self.tile_size)
        end

        local x, y = event:get_position()

        self.cursor_canvas:renderTo(
            function ()
                love.graphics.clear()
                self:_render_cursor(x, y)
            end
        )

        self.draw_cursor = true
    end

    if event:isInstanceOf(UpdateMoveAreaEvent) then
        if not self.move_area_canvas then
            local size_x, size_y = self.model:get_data():get_map():get_size()
            self.move_area_canvas = love.graphics.newCanvas(size_x * self.tile_size, size_y * self.tile_size)
        end

        self.move_area_canvas:renderTo(
            function ()
                love.graphics.clear()
                self:_render_move_area()
            end
        )

        self.draw_move_area = true
    end

    if event:isInstanceOf(UnselectUnitEvent) then
        self.move_area_canvas:renderTo(
            function ()
                love.graphics.clear()
            end
        )
    end

    if event:isInstanceOf(NewPathEvent) then
        if not self.path_canvas then
            local size_x, size_y = self.model:get_data():get_map():get_size()
            self.path_canvas = love.graphics.newCanvas(size_x * self.tile_size, size_y * self.tile_size)
        end

        self.path_canvas:renderTo(
            function ()
                love.graphics.clear()
                self:_render_path(event:get_path())
            end
        )

        self.draw_path = true
    end

    if event:isInstanceOf(RemovePathEvent) then
        self.draw_path = false
    end
end

function Viewer:render_all()
    love.graphics.setColor(1, 1, 1)

    if self.draw_map then
        love.graphics.draw(self.map_canvas, self.shift.x, self.shift.y)
    end

    if self.draw_move_area then
        love.graphics.draw(self.move_area_canvas, self.shift.x, self.shift.y)
    end

    if self.draw_path then
        love.graphics.draw(self.path_canvas, self.shift.x, self.shift.y)
    end

    if self.draw_units then
        love.graphics.draw(self.unit_canvas, self.shift.x, self.shift.y)
    end

    if self.draw_cursor then
        love.graphics.draw(self.cursor_canvas, self.shift.x, self.shift.y)
    end
end

function Viewer:_render_map()
    local all_cells = self.model:get_data():get_map():get_all_cells()

    for _, cell_data in ipairs(all_cells) do
        local x = cell_data[1]
        local y = cell_data[2]
        local cell = cell_data[3]

        local tile = nil

        if cell:get_terrain() == Terrain.water then
            local T = self:_terrain_at(Terrain.ground, x, y - 1)
            local L = self:_terrain_at(Terrain.ground, x - 1, y)
            local R = self:_terrain_at(Terrain.ground, x + 1, y)
            local B = self:_terrain_at(Terrain.ground, x, y + 1)

            local TL = ternary((T ~= 0 or L ~= 0), 0, self:_terrain_at(Terrain.ground, x - 1, y - 1))
            local TR = ternary((T ~= 0 or R ~= 0), 0, self:_terrain_at(Terrain.ground, x + 1, y - 1))
            local BL = ternary((B ~= 0 or L ~= 0), 0, self:_terrain_at(Terrain.ground, x - 1, y + 1))
            local BR = ternary((B ~= 0 or R ~= 0), 0, self:_terrain_at(Terrain.ground, x + 1, y + 1))

            local neigh_data = TL * 1 + T * 2 + TR * 4 + L * 8 + R * 16 + BL * 32 + B * 64 + BR * 128

            tile = cell:get_terrain() .. "_" .. tostring(neigh_data)
        else
            tile = cell:get_terrain()
        end

        self.drawer:draw_at(tile, (x - 1) * self.tile_size, (y - 1) * self.tile_size)
    end
end

function Viewer:_terrain_at(terrain, x, y)
    if not self.model:get_data():get_map():get_cell(x, y) then
        return 0
    end

    if self.model:get_data():get_map():get_cell(x, y):get_terrain() == terrain then
        return 1
    else
        return 0
    end
end

function Viewer:_render_cursor(x, y)
    self.drawer:draw_at("cursor", (x - 1) * self.tile_size, (y - 1) * self.tile_size)
end

function Viewer:_render_units(tick)
    local all_units = self.model:get_data():get_all_units()

    for _, unit in ipairs(all_units) do
        local x, y = unit:get_position()
        local long_name = unit:get_team():get_name() .. "_" .. unit:get_name() .. "_" .. tick

        if unit:get_team():get_owner() == TeamOwner.human and unit:is_action_left() then
            self.drawer:draw_at("ready_to_go", (x - 1) * self.tile_size, (y - 1) * self.tile_size)
        end

        self.drawer:draw_at(long_name, (x - 1) * self.tile_size, (y - 1) * self.tile_size)
    end
end

function Viewer:_render_move_area()
    local all_cells = self.model:get_data():get_map():get_all_cells()

    for _, cell_data in ipairs(all_cells) do
        local x = cell_data[1]
        local y = cell_data[2]
        local cell = cell_data[3]

        if cell:is_move_potention() then
            self.drawer:draw_at("can_move_marker", (x - 1) * self.tile_size, (y - 1) * self.tile_size)
        end
    end
end

function Viewer:_render_path(path)
    for i, point in ipairs(path) do
        local T = self:_path_at(path, point.x, point.y - 1)
        local L = self:_path_at(path, point.x - 1, point.y)
        local R = self:_path_at(path, point.x + 1, point.y)
        local B = self:_path_at(path, point.x, point.y + 1)

        local neigh_data = T * 1 + L * 2 + R * 4 + B * 8

        if i ~= 1 then
            self.drawer:draw_at("path_" .. tostring(neigh_data), (point.x - 1) * self.tile_size, (point.y - 1) * self.tile_size)
        end
    end
end

function Viewer:_path_at(path, x, y)
    for _, point in ipairs(path) do
        if point.x == x and point.y == y then
            return 1
        end
    end

    return 0
end

return Viewer
