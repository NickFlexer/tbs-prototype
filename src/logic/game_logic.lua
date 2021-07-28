---
-- game_logic.lua


local class = require "middleclass"


local GameLogic = class("GameLogic")

function GameLogic:initialize(data)
    if not data.logger then
        error("GameData:initialize(): no data.logger argument!")
    end

    self.logger = data.logger

    self.turn = 1
end

function GameLogic:get_new_action()
    return false
end

function GameLogic:get_turn()
    return self.turn
end

return GameLogic
