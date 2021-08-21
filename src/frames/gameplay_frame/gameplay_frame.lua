---
-- gameplay_frame.lua


local class = require "middleclass"

local BaseFrame = require "frames.base_frame"

local TileDrawer = require "frames.gameplay_frame.tile_drawer"


local GameplayFrame = class("GameplayFrame", BaseFrame)

function GameplayFrame:initialize(data)
    BaseFrame.initialize(self)
    self:check_abstract_methods(GameplayFrame)

    if not data.logic then
        error("GameplayFrame:initialize(): no data.logic argument!")
    end

    self.logic = data.logic

    self.map_canvas = nil

    self.drawer = TileDrawer({
        file_path = "res/img/tileset01.png",
        tile_size = self.logic:get_tile_size()
    })

    self.shift_x = 0
    self.shift_y = 0
end

function GameplayFrame:update(dt)
    if self.logic:is_map_update() then
        if not self.map_canvas then
            local sixe_x, size_y = self.logic:get_full_map_size()
            self.map_canvas = love.graphics.newCanvas(sixe_x, size_y)
        end

        self.map_canvas:renderTo(
            function ()
                love.graphics.clear()

                local cells = self.logic:get_all_map_tiles()
                print(#cells)

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
end

function GameplayFrame:draw()
    love.graphics.setColor(1, 1, 1)

    if self.map_canvas then
        love.graphics.draw(self.map_canvas, self.shift_x, self.shift_y)
    end
end

function GameplayFrame:mouse_pressed(x, y, button, istouch)
    --
end

return GameplayFrame
