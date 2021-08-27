---
-- initialize_scenarion_command.lua


local class = require "middleclass"

local BaseCommand = require "logic.gameplay.command.base_command"


local InitializeScenarionCommand = class("InitializeScenarionCommand", BaseCommand)

function InitializeScenarionCommand:initialize(data)
    BaseCommand.initialize(self)
    self:check_abstract_methods(InitializeScenarionCommand)

    if not data.scenario_repository then
        error("InitializeScenarionCommand:initialize(): no data.scenario_repository argument!")
    end

    self.scenario_repository = data.scenario_repository
end

function InitializeScenarionCommand:execute()
    self.scenario_repository:set_cur_turn(1)
    self.scenario_repository:move_to_new_phase()
end

return InitializeScenarionCommand
