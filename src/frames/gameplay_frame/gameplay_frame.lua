---
-- gameplay_frame.lua


local class = require "middleclass"
local Camera = require "Camera"

local BaseFrame = require "frames.base_frame"

local TileDrawer = require "frames.gameplay_frame.tile_drawer"


local GameplayFrame = class("GameplayFrame", BaseFrame)

function GameplayFrame:initialize(data)
    BaseFrame.initialize(self)
    self:check_abstract_methods(GameplayFrame)

    if not data.view_context then
        error("GameplayFrame:initialize(): no data.view_context argument!")
    end

    if not data.logic then
        error("GameplayFrame:initialize(): no data.logic argument!")
    end

    self.logic = data.logic
    self.view_context = data.view_context

    self.map_canvas = nil
    self.unit_canvas = nil
    self.cursor_canvas = nil

    self.drawer = TileDrawer({
        file_path = "res/img/tileset01.png",
        tile_size = self.view_context:get_tile_size()
    })

    self.shift_x = 0
    self.shift_y = 0

    self.map_width = 1024
    self.map_height = 768

    self.cursor_prev_x = nil
    self.cursor_prev_y = nil

    self.tile_size = self.view_context:get_tile_size()

    self.camera = Camera()
    self.camera.scale = 1
end

function GameplayFrame:update(dt)
    self.camera:update(dt)
    self.logic:update()

    if self.view_context:is_map_update() then
        self:_update_map_canvas()
    end

    if self.view_context:is_units_update() then
        self:_update_unit_canvas()
    end

    local new_cursor_pos_x, new_cursor_pos_y = self.camera:toWorldCoords(love.mouse.getPosition())
    local cur_x = math.floor((new_cursor_pos_x) / self.tile_size + 1)
    local cur_y = math.floor((new_cursor_pos_y) / self.tile_size + 1)

    if cur_x ~= self.cursor_prev_x or cur_y ~= self.cursor_prev_y and cur_x > 0 and cur_y > 0 then
        self.cursor_prev_x = cur_x
        self.cursor_prev_y = cur_y

        self:_update_cursor_canvas(self.cursor_prev_x, self.cursor_prev_y)
    end
end

function GameplayFrame:draw()
    self.camera:attach()

    love.graphics.setColor(1, 1, 1)

    if self.map_canvas then
        love.graphics.draw(self.map_canvas, self.shift_x, self.shift_y)
    end

    if self.unit_canvas then
        love.graphics.draw(self.unit_canvas, self.shift_x, self.shift_y)
    end

    if self.cursor_canvas then
        love.graphics.draw(self.cursor_canvas, self.shift_x, self.shift_y)
    end

    self.camera:detach()
    self.camera:draw()
end

function GameplayFrame:when_done(action)
    self.logic:execute_command(action)
end

function GameplayFrame:mouse_pressed(x, y, button, istouch)
    if self.shift_x <= x and x <= self.map_width + self.shift_x and self.shift_y <= y and y <= self.map_height + self.shift_y then

    end
end

function GameplayFrame:_update_map_canvas()
    if not self.map_canvas then
        local sixe_x, size_y = self.logic:get_full_map_size()
        self.map_canvas = love.graphics.newCanvas(sixe_x, size_y)

        self.camera:setBounds(0, 0, sixe_x, size_y)
    end

    self.map_canvas:renderTo(
        function ()
            love.graphics.clear()

            local cells = self.view_context:get_all_map_tiles()

            for _, cell in ipairs(cells) do
                local tiles = cell:get_tiles()
                local pos_x, pos_y = cell:get_position():get()

                for _, tile in ipairs(tiles) do
                    self.drawer:draw_at(tile, pos_x, pos_y)
                end
            end
        end
    )
end

function GameplayFrame:_update_unit_canvas()
    if not self.unit_canvas then
        local sixe_x, size_y = self.logic:get_full_map_size()
        self.unit_canvas = love.graphics.newCanvas(sixe_x, size_y)
    end

    self.unit_canvas:renderTo(
        function ()
            love.graphics.clear()

            local cells = self.view_context:get_all_unit_tiles()

            for _, cell in ipairs(cells) do
                local tiles = cell:get_tiles()
                local pos_x, pos_y = cell:get_position():get()

                for _, tile in ipairs(tiles) do
                    self.drawer:draw_at(tile, pos_x, pos_y)
                end
            end
        end
    )
end

function GameplayFrame:_update_cursor_canvas(new_x, new_y)
    if not self.cursor_canvas then
        local sixe_x, size_y = self.logic:get_full_map_size()
        self.cursor_canvas = love.graphics.newCanvas(sixe_x, size_y)
    end

    self.cursor_canvas:renderTo(
        function ()
            love.graphics.clear()

            local x = (new_x - 1) * self.tile_size
            local y = (new_y - 1) * self.tile_size

            self.drawer:draw_at("cursor", x, y)
        end
    )
end

return GameplayFrame
