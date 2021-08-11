---
-- cell.lua


local class = require "middleclass"


local Cell = class("Cell")

function Cell:initialize(data)
    if not data.terrain then
        error("Cell:initialize(): no data.terrain argument!")
    end

    if not data.move_cost then
        error("Cell:initialize(): no data.move_cost argument!")
    end

    self.terrain = data.terrain
    self.move_cost = data.move_cost
    self.unit = nil
    self.move_potention = false
end

function Cell:get_terrain()
    return self.terrain
end

function Cell:get_move_cost()
    return self.move_cost
end

function Cell:set_unit(unit)
    if not self.unit then
        self.unit = unit
    else
        error("Cell:set_unit() there is unit on cell!")
    end
end

function Cell:get_unit()
    return self.unit
end

function Cell:remove_unit()
    self.unit = nil
end

function Cell:set_move_potention()
    self.move_potention = true
end

function Cell:clear_move_potention()
    self.move_potention = false
end

function Cell:is_move_potention()
    return self.move_potention
end

return Cell
