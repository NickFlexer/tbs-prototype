---
-- tile_drawer.lua


local class = require "middleclass"
local TileCutter = require "tile_cutter"


local TileDrawer = class("TileDrawer")

function TileDrawer:initialize(data)
    if not data.file_path then
        error("TileDrawer:initialize(): no data.file_path argument!")
    end

    if not data.tile_size then
        error("TileDrawer:initialize(): no data.tile_size argument!")
    end

    self.tile_cutter = TileCutter(data.file_path, data.tile_size)

    self.tile_cutter:config_tileset({
        {"water", 1, 11},
        {"ground", 8, 16}
    })
end

function TileDrawer:draw_at(name, x, y)
    self.tile_cutter:draw(name, x, y)
end

return TileDrawer
