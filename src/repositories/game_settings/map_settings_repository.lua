---
-- map_settings_repository.lua


local class = require "middleclass"


local MapSettingsRepository = class("MapSettingsRepository")

function MapSettingsRepository:initialize(data)
    self.tile_size = 64
end

function MapSettingsRepository:get_tile_size()
    return self.tile_size
end

return MapSettingsRepository
