---
-- teams_repository.lua


local class = require "middleclass"


local TeamsRepository = class("TeamsRepository")

function TeamsRepository:initialize()
    self.teams = {}
end

function TeamsRepository:add_team(team)
    table.insert(self.teams, team)
end

return TeamsRepository
