---
-- get_new_action_state.lua


local class = require "middleclass"

local BaseState = require "logic.gameplay.states.base_state"

local OwnerTypes = require "repositories.teams.enums.owner_types"


local GetNewActionState = class("GetNewActionState", BaseState)

function GetNewActionState:initialize(data)
    BaseState.initialize(self)
    self:check_abstract_methods(GetNewActionState)

    if not data.scenario_repository then
        error("GameplayLogic:initialize(): no data.scenario_repository argument!")
    end

    if not data.teams_repository then
        error("GameplayLogic:initialize(): no data.scenario_repository argument!")
    end

    self.scenario_repository = data.scenario_repository
    self.teams_repository = data.teams_repository
end

function GetNewActionState:enter(owner)
    --
end

function GetNewActionState:execute(owner, dt)
    local team_name = self.scenario_repository:get_current_phase()
    local team = self.teams_repository:get_team(team_name)

    if team:get_owner() == OwnerTypes.human then
        --
    end
end

function GetNewActionState:exit(owner)
    -- body
end

return GetNewActionState
