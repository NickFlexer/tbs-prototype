---
-- base_command.lua


local class = require "middleclass"
local ABC = require "abc"


local BaseCommand = class("BaseCommand", ABC)

function BaseCommand:initialize(data)
    ABC.initialize(self)
    self:set_abstract_methods(BaseCommand)
end

function BaseCommand:execute()
    return self.abstractmethod
end

return BaseCommand
