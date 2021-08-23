---
-- map_repository.lua


local class = require "middleclass"
local Grid = require "grid"


local MapRepository = class("MapRepository")

function MapRepository:initialize(data)
    self.map = nil
end

function MapRepository:set_size(x, y)
    self.map = Grid(x, y)
end

function MapRepository:get_size()
    return self.map:get_size()
end

function MapRepository:set_cell(x, y, cell)
    self.map:set_cell(x, y, cell)
end

function MapRepository:get_all_cells()
    local cells = {}

    for _, _, cell in self.map:iterate() do
        table.insert(cells, cell)
    end

    return cells
end

function MapRepository:get_cell(x, y)
    if not self.map:is_valid(x, y) then
        return nil
    end

    return self.map:get_cell(x, y)
end

return MapRepository
