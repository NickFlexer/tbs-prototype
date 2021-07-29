---
-- game_logic.lua


local class = require "middleclass"


local GameLogic = class("GameLogic")

function GameLogic:initialize(data)
    if not data.logger then
        error("GameData:initialize(): no data.logger argument!")
    end

    self.logger = data.logger

    self.turn = 1
    self.cur_team_num = 1

    self.teams = {}
end

function GameLogic:add_new_team(team)
    table.insert(self.teams, team)
end

function GameLogic:get_current_team()
    return self.teams[self.cur_team_num]
end

function GameLogic:get_new_action()
    return false
end

function GameLogic:get_turn()
    return self.turn
end

return GameLogic
