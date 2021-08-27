---
-- scenario_repository.lua


local class = require "middleclass"


local ScenarioRepository = class("ScenarioRepository")

function ScenarioRepository:initialize(data)
    self.turn = nil
    self.phases = {}
    self.phase = nil

    self.phase_index = nil
end

function ScenarioRepository:set_cur_turn(turn)
    self.turn = turn
end

function ScenarioRepository:get_cur_turn()
    return self.turn
end

function ScenarioRepository:add_phase(phase_name)
    table.insert(self.phases, phase_name)
end

function ScenarioRepository:move_to_new_phase()
    self.phase = nil
    self.phase_index, self.phase = next(self.phases, self.phase_index)

    return self.phase
end

function ScenarioRepository:get_current_phase()
    return self.phase
end

return ScenarioRepository
