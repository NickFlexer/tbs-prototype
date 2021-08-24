---
-- units_repository.lua


local class = require "middleclass"


local UnitsRepository = class("UnitsRepository")

function UnitsRepository:initialize()
    self.units = {}
end

function UnitsRepository:add(unit)
    table.insert(self.units, unit)
end

function UnitsRepository:get_all()
    return self.units
end

return UnitsRepository
