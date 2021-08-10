---
-- game_logic.lua


local class = require "middleclass"

local TeamOwner = require "data.enums.team_owner"


local GameLogic = class("GameLogic")

function GameLogic:initialize(data)
    if not data.logger then
        error("GameLogic:initialize(): no data.logger argument!")
    end

    if not data.event_manager then
        error("GameLogic:initialize(): no data.event_manager argument!")
    end

    if not data.human_control then
        error("GameLogic:initialize(): no data.human_control argument!")
    end

    self.logger = data.logger
    self.event_manager = data.event_manager
    self.human_control = data.human_control

    self.event_manager:register(self)

    self.turn = 1
    self.cur_team_num = 1

    self.teams = {}
    self.actins = {}
end

function GameLogic:add_new_team(team)
    table.insert(self.teams, team)
end

function GameLogic:get_current_team()
    return self.teams[self.cur_team_num]
end

function GameLogic:update(game_data)
    if self:get_current_team():get_owner() == TeamOwner.human then
        self.human_control:set_team(self:get_current_team())

        self.human_control:update({
            game_data = game_data,
            logic = self,
            team = self:get_current_team(),
            event_manager = self.event_manager
        })
    end

    return next(self.actins)
end

function GameLogic:get_turn()
    return self.turn
end

function GameLogic:notify(event)
    if self:get_current_team() and self:get_current_team():get_owner() == TeamOwner.human then
        self.human_control:notify(event)
    end
end

function GameLogic:add_action(action)
    self.logger:debug("GameLogic: add action " .. tostring(action))

    table.insert(self.actins, action)
end

function GameLogic:get_next_action()
    return table.remove(self.actins, 1)
end

return GameLogic
