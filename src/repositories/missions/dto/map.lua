---
-- map.lua


local class = require "middleclass"


local Map = class("Map")

function Map:initialize(data)
    self.size_x = data.x
    self.size_y = data.y

    self.cells = {}
end

function Map:get_size()
    return self.size_x, self.size_y
end

function Map:add_cell(cell)
    table.insert(self.cells, cell)
end

function Map:get_cells()
    return self.cells
end

return Map
