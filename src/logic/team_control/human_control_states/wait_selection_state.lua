---
-- wait_selection_state.lua


local class = require "middleclass"

local BaseState = require "logic.team_control.human_control_states.base_state"

local PositionPressedEvent = require "event_manager.events.position_pressed_event"
local PlayerUnitSelectedEvent = require "event_manager.events.player_unit_selected_event"


local WaitSelectionState = class("WaitSelectionState", BaseState)

function WaitSelectionState:initialize(data)
    BaseState.initialize(self)
    self:check_abstract_methods(WaitSelectionState)

    if not data.logger then
        error("HumanTeamControl:initialize(): no data.logger argument!")
    end

    self.logger = data.logger

    self.check = nil
    self.ent = false
end

function WaitSelectionState:enter(owner)
    self.ent = true
end

function WaitSelectionState:execute(owner, data)
    if self.ent then
        self.ent = false

        data.game_data:get_map():remove_move_area()
    end

    if self.check then
        local map = data.game_data:get_map()
        local cell = map:get_cell(self.check.x, self.check.y)

        if not cell:get_unit() then
            self.logger:debug("WaitSelectionState: no unit on [".. tostring(self.check.x) .. "," .. tostring(self.check.y) .. "]")
            self.check = nil
        else
            if cell:get_unit():get_team() == data.team then
                self.logger:debug("WaitSelectionState: unit of your team!")
                self.check = nil

                data.event_manager:post(PlayerUnitSelectedEvent(cell:get_unit()))
            else
                self.logger:debug("WaitSelectionState: unit of not your team!")
                self.check = nil
            end
        end
    end
end

function WaitSelectionState:exit(owner)
    -- body
end

function WaitSelectionState:notify(event)
    if event:isInstanceOf(PositionPressedEvent) then
        local x, y = event:get_position()
        self.check = {x = x, y = y}
    end
end

return WaitSelectionState