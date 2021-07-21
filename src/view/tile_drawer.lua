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
        {"?", 16, 16},
        {"ground", 8, 16},
        {"water", 1, 11},
        {"water_0", 1, 11},
        {"water_1", 2, 11},
        {"water_4", 3, 11},
        {"water_5", 4, 11},
        {"water_32", 5, 11},
        {"water_33", 6, 11},
        {"water_36", 7, 11},
        {"water_37", 8, 11},
        {"water_128", 1, 12},
        {"water_129", 2, 12},
        {"water_132", 3, 12},
        {"water_133", 4, 12},
        {"water_160", 5, 12},
        {"water_161", 6, 12},
        {"water_164", 7, 12},
        {"water_165", 8, 12},
        {"water_2", 1, 13},
        {"water_34", 2, 13},
        {"water_130", 3, 13},
        {"water_162", 4, 13},
        {"water_8", 5, 13},
        {"water_12", 6, 13},
        {"water_136", 7, 13},
        {"water_140", 8, 13},
        {"water_16", 1, 14},
        {"water_17", 2, 14},
        {"water_48", 3, 14},
        {"water_49", 4, 14},
        {"water_64", 5, 14},
        {"water_65", 6, 14},
        {"water_68", 7, 14},
        {"water_69", 8, 14},
        {"water_66", 1, 15},
        {"water_24", 2, 15},
        {"water_10", 3, 15},
        {"water_138", 4, 15},
        {"water_18", 5, 15},
        {"water_50", 6, 15},
        {"water_80", 7, 15},
        {"water_81", 8, 15},
        {"water_72", 1, 16},
        {"water_76", 2, 16},
        {"water_26", 3, 16},
        {"water_74", 4, 16},
        {"water_88", 5, 16},
        {"water_82", 6, 16},
        {"water_90", 7, 16},

        {"cursor", 1, 10},

        {"red_trooper_1", 1, 1},
        {"red_trooper_2", 2, 1},

        {"blue_trooper_1", 1, 2},
        {"blue_trooper_2", 2, 2}
    })

    self.tile_cutter:set_error_handler(
        function (_, x, y, ...)
            self.tile_cutter:draw("?", x, y, ...)
        end
    )
end

function TileDrawer:draw_at(name, x, y)
    self.tile_cutter:draw(name, x, y)
end

return TileDrawer
