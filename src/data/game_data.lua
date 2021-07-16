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

return GameData
