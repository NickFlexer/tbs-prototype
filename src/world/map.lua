---
-- map.lua


local class = require "middleclass"
local Grid = require "grid"


local Map = class("Map")

function Map:initialize(data)
    self.map = nil
end

function Map:new_map(size_x, size_y)
    self.map = Grid(size_x, size_y)
end

function Map:set_cell(x, y, new_cell)
    self.map:set_cell(x, y, new_cell)
end

function Map:get_size()
    return self.map:get_size()
end

function Map:get_all_cells()
    return self.map:get_contents()
end

function Map:get_cell(x, y)
    if not self.map:is_valid(x, y) then
        return false
    end

    return self.map:get_cell(x, y)
end

function Map:solve_move_area(start_pos_x, start_pos_y, move)
    -- prepare
    for x, y, cell in self.map:iterate() do
        if x == start_pos_x and y == start_pos_y then
            cell.cur_move = move
            cell.iter = 1
        else
            cell.active = false
            cell.iterate = 0
        end

        cell:clear_move_potention()
    end

    local x_shift = {1, 0, -1, 0}
    local y_shift = {0, -1, 0, 1}

    local cur_iterate = 1
    local rep = true

    -- solve
    while rep do
        rep = false

        for x, y, cell in self.map:iterate() do
            if cell.iter == cur_iterate then
                for i = 1, 4 do
                    if self:_can_go(x, y, x + x_shift[i], y + y_shift[i]) then
                        self.map:get_cell(x + x_shift[i], y + y_shift[i]).iter = cur_iterate + 1
                        self.map:get_cell(x + x_shift[i], y + y_shift[i]).cur_move = cell.cur_move - self.map:get_cell(x + x_shift[i], y + y_shift[i]):get_move_cost()

                        rep = true
                    end
                end
            end
        end

        cur_iterate = cur_iterate + 1
    end

    -- result
    for x, y, cell in self.map:iterate() do
        if cell.iter and cell.iter ~= 1 then
            cell:set_move_potention()
        end
    end
end

function Map:_can_go(x, y, dx, dy)
    if self.map:get_cell(dx, dy) then
        if self.map:get_cell(dx, dy).cur_move then
            return false
        end

        if self.map:get_cell(dx, dy):get_unit() then
            return false
        end

        if self.map:get_cell(x, y).cur_move - self.map:get_cell(dx, dy):get_move_cost() > 0 then
            return true
        else
            return false
        end
    else
        return false
    end
end

return Map
