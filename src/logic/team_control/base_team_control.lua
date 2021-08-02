---
-- base_team_control.lua


local class = require "middleclass"
local ABC = require "abc"


local BaseTeamControl = class("BaseTeamControl", ABC)

function BaseTeamControl:initialize()
    ABC.initialize(self)
    self:set_abstract_methods(BaseTeamControl)
end

function BaseTeamControl:update()
    return self.abstractmethod
end

return BaseTeamControl
