---
-- cell.lua


local class = require "middleclass"


local Cell = class("Cell")

function Cell:initialize(data)
    if not data.terrain then
        error("Cell:initialize(): no data.terrain argument!")
    end

    self.terrain = data.terrain
    self.unit = nil
end

function Cell:get_terrain()
    return self.terrain
end

function Cell:set_unit(unit)
    if not self.unit then
        self.unit = unit
    else
        error("Cell:set_unit() there is unit on cell!")
    end
end

return Cell
