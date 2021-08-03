---
-- terrain_data.lua


local class = require "middleclass"
local json = require "json.json"


local TerrainData = class("TerrainData")

function TerrainData:initialize(data)
    self.file_path = data.file_path

    local file = assert(io.open(self.file_path, "rb"))
    local content = file:read("*all")
    file:close()

    self.terrains = json.decode(content)
end

function TerrainData:get(name)
    return self.terrains[name]
end

return TerrainData
