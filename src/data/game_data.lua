---
-- game_data.lua


local class = require "middleclass"

local Map = require "world.map"


local GameData = class("GameData")

function GameData:initialize(data)
    if not data.logger then
        error("GameData:initialize(): no data.logger argument!")
    end

    self.logger = data.logger

    self.map = Map()

    self.teams = {}
end

function GameData:get_map()
    return self.map
end

function GameData:add_new_team(team)
    table.insert(self.teams, team)

    self.logger:debug("GameData: insert new team [" .. team:get_name() .. "] controlled by [" .. tostring(team:get_owner()) .. "]")
end

function GameData:add_new_unit(unit, team, x, y)
    team:add_unit(unit)
    self.map:get_cell(x, y):set_unit(unit)

    self.logger:debug("GameData: insert new unit [" .. unit:get_name() .. "] to team [" .. team:get_name() .. "]")
end

function GameData:set_unit_position(unit, new_x, new_y)
    self.map:remove_unit(unit)
    self.map:set_unit(unit, new_x, new_y)
end

function GameData:get_team(name)
    for _, team in ipairs(self.teams) do
        if team:get_name() == name then
            return team
        end
    end

    error("GameData:get_team() there is no team with name " .. tostring(name))
end

function GameData:get_all_units()
    local all_units = {}

    for _, team in ipairs(self.teams) do
        for _, unit in ipairs(team:get_units()) do
            table.insert(all_units, unit)
        end
    end

    return all_units
end

function GameData:solve_unit_targets(unit)
    local range = unit:get_range()
    local x, y = self.map:get_unit_position(unit)

    local result_cells = self.map:solve_atack_area(x, y, range)

    for _, cell in ipairs(result_cells) do
        local unit_on_cell = cell:get_unit()

        if unit_on_cell and unit_on_cell:get_team():get_name() == unit:get_team():get_enimy() then
            unit:add_target(cell)
        end
    end
end

return GameData
