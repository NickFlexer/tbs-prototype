---
-- mission.lua


local class = require "middleclass"


local Mission = class("Mission")

function Mission:initialize()
    self.map = nil
    self.teams = {}
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

return Mission
