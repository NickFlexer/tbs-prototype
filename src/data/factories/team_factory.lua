---
-- team_factory.lua


local class = require "middleclass"

local Team = require "world.team"


local TeamFactory = class("TeamFactory")

function TeamFactory:initialize()
    -- body
end

function TeamFactory:new_team(team_data)
    local team = Team({
        name = team_data.name,
        owner = team_data.owner,
        enimy = team_data.enimy
    })

    return team
end

return TeamFactory
