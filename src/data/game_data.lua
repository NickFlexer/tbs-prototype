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

    self.logger:debug("GameData: insert new team [" .. team:get_name() .. "]")
end

function GameData:add_new_unit(unit, team)
    local x, y = unit:get_position()

    team:add_unit(unit)
    self.map:get_cell(x, y):set_unit(unit)

    self.logger:debug("GameData: insert new unit [" .. unit:get_name() .. "] to team [" .. team:get_name() .. "]")
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

return GameData
