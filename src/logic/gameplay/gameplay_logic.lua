---
-- gameplay_logic.lua


local class = require "middleclass"
local FSM = require "fsm"

local GetNewActionState = require "logic.gameplay.states.get_new_action_state"


local GameplayLogic = class("GameplayLogic")

function GameplayLogic:initialize(data)
    if not data.navigator then
        error("GameplayLogic:initialize(): no data.navigator argument!")
    end

    if not data.map_repository then
        error("GameplayLogic:initialize(): no data.map_repository argument!")
    end

    if not data.map_settings_repository then
        error("GameplayLogic:initialize(): no data.map_settings_repository argument!")
    end

    if not data.units_repository then
        error("GameplayLogic:initialize(): no data.units_repository argument!")
    end

    if not data.view_context then
        error("GameplayLogic:initialize(): no data.view_context argument!")
    end

    self.navigator = data.navigator
    self.map_repository = data.map_repository
    self.map_settings_repository = data.map_settings_repository
    self.units_repository = data.units_repository
    self.view_context = data.view_context

    self.fsm = FSM(self)
    self.states = {
        get_new_action = GetNewActionState()
    }

    self.fsm:set_current_state(self.states.get_new_action)

    self.view_context:update_map()
    self.view_context:update_units()
end

function GameplayLogic:get_full_map_size()
    local map_x, map_y = self.map_repository:get_size()
    local tile_size = self.map_settings_repository:get_tile_size()

    return map_x * tile_size, map_y * tile_size
end

function GameplayLogic:update()
    self.fsm:update()
end

function GameplayLogic:get_fsm()
    return self.fsm
end

function GameplayLogic:get_states()
    return self.states
end

return GameplayLogic
