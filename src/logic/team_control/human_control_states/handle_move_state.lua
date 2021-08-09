---
-- handle_move_state.lua


local class = require "middleclass"

local BaseState = require "logic.team_control.human_control_states.base_state"

local UpdateMoveAreaEvent = require "event_manager.events.update_move_area_event"
local PositionPressedEvent = require "event_manager.events.position_pressed_event"
local PlayerUnitSelectedEvent = require "event_manager.events.player_unit_selected_event"
local UnselectUnitEvent = require "event_manager.events.unselect_unit_event"
local NewCursorPositionEvent = require "event_manager.events.new_cursor_position_event"


local HandleMoveState = class("HandleMoveState", BaseState)

function HandleMoveState:initialize(data)
    BaseState.initialize(self)
    self:check_abstract_methods(HandleMoveState)

    if not data.logger then
        error("HumanTeamControl:initialize(): no data.logger argument!")
    end

    self.logger = data.logger

    self.compute_move_area = false
    self.chech_new_position = nil
    self.solve_path = nil
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

    if self.chech_new_position then
        local map = data.game_data:get_map()
        local cell = map:get_cell(self.chech_new_position.x, self.chech_new_position.y)

        if cell:get_unit() and cell:get_unit():is_selected() then
            data.event_manager:post(UnselectUnitEvent())
        elseif cell:get_unit() and cell:get_unit():get_team() == data.team  then
            data.event_manager:post(PlayerUnitSelectedEvent(cell:get_unit()))
        elseif not cell:is_move_potention() then
            data.event_manager:post(UnselectUnitEvent())
        end

        self.chech_new_position = nil
    end

    if self.solve_path then
        self.solve_path = nil
    end
end

function HandleMoveState:exit(owner)
    -- body
end

function HandleMoveState:notify(event)
    if event:isInstanceOf(PositionPressedEvent) then
        local x, y = event:get_position()
        self.chech_new_position = {x = x, y = y}
    end

    if event:isInstanceOf(NewCursorPositionEvent) then
        local x, y = event:get_position()
        self.solve_path = {x = x, y = y}
    end
end

return HandleMoveState