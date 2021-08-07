---
-- handle_move_state.lua


local class = require "middleclass"

local BaseState = require "logic.team_control.human_control_states.base_state"

local UpdateMoveAreaEvent = require "event_manager.events.update_move_area_event"


local HandleMoveState = class("HandleMoveState", BaseState)

function HandleMoveState:initialize(data)
    BaseState.initialize(self)
    self:check_abstract_methods(HandleMoveState)

    if not data.logger then
        error("HumanTeamControl:initialize(): no data.logger argument!")
    end

    self.logger = data.logger

    self.compute_move_area = false
end

function HandleMoveState:enter(owner)
    self.compute_move_area = true
end

function HandleMoveState:execute(owner, data)
    if self.compute_move_area then
        self.compute_move_area = false

        local unit = data.team:get_selected_unit()
        local map = data.game_data:get_map()

        local x, y = unit:get_position()

        map:solve_move_area(x, y, unit:get_move())

        data.event_manager:post(UpdateMoveAreaEvent())
    end
end

function HandleMoveState:exit(owner)
    -- body
end

function HandleMoveState:notify(event)
end

return HandleMoveState