---
-- viewer.lua


local class = require "middleclass"

local UpdateMapViewEvent = require "event_manager.events.update_map_view_event"


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

    self.event_manager = data.event_manager
    self.model = data.model
    self.drawer = data.drawer
    self.tile_size = data.tile_size

    self.event_manager:register(self)

    self.map_canvas = nil

    self.draw_map = false
end

function Viewer:notify(event)
    if event:isInstanceOf(UpdateMapViewEvent) then
        if not self.map_canvas then
            local size_x, size_y = self.model:get_map():get_size()
            self.map_canvas = love.graphics.newCanvas(size_x * self.tile_size, size_y * self.tile_size)
        end

        self.map_canvas:renderTo(
            function ()
                self:_render_map()
            end
        )

        self.draw_map = true
    end
end

function Viewer:render_all()
    love.graphics.setColor(1, 1, 1)

    if self.draw_map then
        love.graphics.draw(self.map_canvas)
    end
end

function Viewer:_render_map()
    local all_cells = self.model:get_map():get_all_cells()

    for _, cell_data in ipairs(all_cells) do
        local x = cell_data[1]
        local y = cell_data[2]
        local cell = cell_data[3]


        self.drawer:draw_at(cell:get_terrain(), (x - 1) * self.tile_size, (y - 1) * self.tile_size)
    end
end

return Viewer
