---
-- team_factory.lua


local class = require "middleclass"

local Team = require "repositories.teams.dto.team"


local TeamFactory = class("TeamFactory")

function TeamFactory:initialize()
    -- body
end

function TeamFactory:get_new_team(team_data)
    return Team({
        name = team_data:get_name()
    })
end

return TeamFactory
