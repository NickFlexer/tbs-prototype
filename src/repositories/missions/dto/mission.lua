---
-- mission.lua


local class = require "middleclass"


local Mission = class("Mission")

function Mission:initialize()
    self.map = nil
end

function Mission:set_map(map)
    self.map = map
end

function Mission:get_map()
    return self.map
end

return Mission
