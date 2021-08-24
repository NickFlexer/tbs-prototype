---
-- mission.lua


local class = require "middleclass"


local Mission = class("Mission")

function Mission:initialize()
    self.map = nil
    self.teams = {}
    self.units = {}
end

function Mission:set_map(map)
    self.map = map
end

function Mission:get_map()
    return self.map
end

function Mission:add_team(team)
    table.insert(self.teams, team)
end

function Mission:get_teams()
    return self.teams
end

function Mission:add_unit(unit)
    table.insert(self.units, unit)
end

function Mission:get_units()
    return self.units
end

return Mission
