---
-- map_data.lua


local class = require "middleclass"
local json = require "json.json"


local MapData = class("MapData")

function MapData:initialize(data)
    self.file_path = data.file_path

    local file = assert(io.open(self.file_path, "rb"))
    local content = file:read("*all")
    file:close()

    self.scene_data = json.decode(content)
end

function MapData:get_map_string()
    local map = ""

    for _, line in ipairs(self.scene_data.world.map) do
        map = map .. line .. "\n"
    end

    return map
end

function MapData:get_size()
    return #self.scene_data.world.map[1], #self.scene_data.world.map
end

function MapData:get_teams()
    return self.scene_data.teams
end

return MapData
