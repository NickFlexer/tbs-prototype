---
-- unit_data.lua


local class = require "middleclass"
local json = require "json.json"


local UnitData = class("UnitData")

function UnitData:initialize(data)
    self.file_path = data.file_path

    local file = assert(io.open(self.file_path, "rb"))
    local content = file:read("*all")
    file:close()

    self.units = json.decode(content)
end

function UnitData:get(name)
    return self.units[name]
end

return UnitData
