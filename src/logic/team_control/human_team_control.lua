---
-- human_team_control.lua


local class = require "middleclass"
local FSM = require "fsm"

local BaseTeamControl = require "logic.team_control.base_team_control"

local WaitSelectionState = require "logic.team_control.human_control_states.wait_selection_state"
local HandleMoveState = require "logic.team_control.human_control_states.handle_move_state"

local PlayerUnitSelectedEvent = require "event_manager.events.player_unit_selected_event"


local HumanTeamControl = class("HumanTeamControl", BaseTeamControl)

function HumanTeamControl:initialize(data)
    BaseTeamControl.initialize(self)
    self:check_abstract_methods(HumanTeamControl)

    if not data.logger then
        error("HumanTeamControl:initialize(): no data.logger argument!")
    end

    self.logger = data.logger
    self.controlled_team = nil

    self.fsm = FSM(self)

    self.states = {
        wait = WaitSelectionState({logger = self.logger}),
        handle_move = HandleMoveState({logger = self.logger})
    }

    self.fsm:set_current_state(self.states.wait)
end

function HumanTeamControl:update(data)
    self.fsm:update(data)
end

function HumanTeamControl:notify(event)
    if event:isInstanceOf(PlayerUnitSelectedEvent) then
        self.controlled_team:unselect_all()
        event:get_unit():select()

        self.fsm:change_state(self.states.handle_move)
    end

    if self.fsm:has_state() then
        self.fsm:get_current_state():notify(event)
    end
end

function HumanTeamControl:set_team(team)
    self.controlled_team = team
end

return HumanTeamControl
