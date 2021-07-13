---
-- game_engine.lua


local class = require "middleclass"
local FSM = require "fsm"

local GameplayState = require "model.states.gameplay_state"
local LoadDataState = require "model.states.load_data_state"

local GameLoadedEvent = require "event_manager.events.game_loaded_event"

local Map = require "world.map"


local GameEngine = class("GameEngine")

function GameEngine:initialize(data)
    if not data.event_manager then
        error("GameEngine:initialize(): no data.event_manager argument!")
    end

    self.event_manager = data.event_manager
    self.fsm = FSM(self)

    self.states = {
        load_data = LoadDataState(),
        gameplay = GameplayState()
    }

    self.event_manager:register(self)
    self.running = false

    self.map = Map()
end

function GameEngine:notify(event)
    if event:isInstanceOf(GameLoadedEvent) then
        self.fsm:change_state(self.states.gameplay)
    end

    if self.fsm:has_state() then
        self.fsm:get_current_state():notify(self, event)
    end
end

function GameEngine:init()
    self.running = true
    self.fsm:set_current_state(self.states.load_data)
end

function GameEngine:is_running()
    return self.running
end

function GameEngine:update(dt)
    self.fsm:update(dt)
end

function GameEngine:get_fsm()
    return self.fsm
end

function GameEngine:get_states()
    return self.states
end

function GameEngine:get_event_manager()
    return self.event_manager
end

function GameEngine:get_map()
    return self.map
end

return GameEngine
