---
-- human_team_control.lua


local class = require "middleclass"
local FSM = require "fsm"

local BaseTeamControl = require "logic.team_control.base_team_control"


local HumanTeamControl = class("HumanTeamControl", BaseTeamControl)

function HumanTeamControl:initialize(data)
    BaseTeamControl.initialize(self)
    self:check_abstract_methods(HumanTeamControl)

    self.fsm = FSM(self)

    self.states = {}
end

function HumanTeamControl:update(data)
    self.fsm:update(data)
end

function HumanTeamControl:notify(event)
    -- body
end

return HumanTeamControl
