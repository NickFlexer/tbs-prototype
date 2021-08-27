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

function TeamsRepository:get_team(team_name)
    for _, team in ipairs(self.teams) do
        if team:get_name() == team_name then
            return team
        end
    end
end

return TeamsRepository
