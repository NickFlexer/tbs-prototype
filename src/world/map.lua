---
-- map.lua


local class = require "middleclass"
local Grid = require "grid"
local luastar = require "lua-star"


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

function Map:get_unit_position(unit)
    for x, y, cell in self.map:iterate() do
        if cell:get_unit() and cell:get_unit() == unit then
            return x, y
        end
    end
end

function Map:remove_unit(unit)
    local x, y = self:get_unit_position(unit)
    self.map:get_cell(x, y):remove_unit()
end

function Map:set_unit(unit, x, y)
    self.map:get_cell(x, y):set_unit(unit)
end

function Map:remove_move_area()
    for _, _, cell in self.map:iterate() do
        cell:clear_move_potention()
    end
end

function Map:solve_move_area(start_pos_x, start_pos_y, move)
    -- prepare
    self:remove_move_area()

    for x, y, cell in self.map:iterate() do
        cell.cur_move = nil
        cell.iter = nil
        cell.active = nil

        if x == start_pos_x and y == start_pos_y then
            cell.cur_move = move
            cell.iter = 1
        else
            cell.active = false
        end
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


function Map:get_path(x0, y0, x1, y1)
    local start = {x = x0, y = y0}
    local goal = {x = x1, y = y1}
    local width, height = self.map:get_size()

    local path = luastar:find(width, height, start, goal, self._position_is_open, false, true)

    return path
end

function Map:solve_atack_area(start_pos_x, start_pos_y, range)
    for x, y, cell in self.map:iterate() do
        if x == start_pos_x and y == start_pos_y then
            cell.atack_mark = 0
        else
            cell.atack_mark = nil
        end
    end

    local x_shift = {1, 0, -1, 0}
    local y_shift = {0, -1, 0, 1}

    local cur_iter = 0
    local rep = true

    local res_data = {}

    while rep do
        for x, y, cell in self.map:iterate() do
            if cell.atack_mark == cur_iter then
                for i = 1, 4 do
                    if self.map:is_valid(x + x_shift[i], y + y_shift[i]) and not self.map:get_cell(x + x_shift[i], y + y_shift[i]).atack_mark then
                        if cur_iter + 1 <= range then
                            self.map:get_cell(x + x_shift[i], y + y_shift[i]).atack_mark = cur_iter + 1
                            table.insert(res_data, self.map:get_cell(x + x_shift[i], y + y_shift[i]))
                        end
                    end
                end
            end
        end

        cur_iter = cur_iter + 1

        if cur_iter > range then
            rep = false
        end
    end

    return res_data
end

function Map:_position_is_open(x, y)
    return true
end

function Map:_can_go(x, y, dx, dy)
    if self.map:is_valid(dx, dy) and self.map:get_cell(dx, dy) then
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
