---
-- game_engine.lua


local class = require "middleclass"
local FSM = require "fsm"

local GameplayState = require "model.states.gameplay_state"
local LoadDataState = require "model.states.load_data_state"
local AnimationState = require "model.states.animation_state"

local GameLoadedEvent = require "event_manager.events.game_loaded_event"
local StartAnimationEvent = require "event_manager.events.start_animain_event"


local GameEngine = class("GameEngine")

function GameEngine:initialize(data)
    if not data.event_manager then
        error("GameEngine:initialize(): no data.event_manager argument!")
    end

    if not data.game_data then
        error("GameEngine:initialize(): no data.game_data argument!")
    end

    if not data.game_logic then
        error("GameEngine:initialize(): no data.game_logic argument!")
    end

    self.game_data = data.game_data
    self.event_manager = data.event_manager
    self.game_logic = data.game_logic

    self.fsm = FSM(self)

    self.states = {
        load_data = LoadDataState(),
        gameplay = GameplayState(),
        animation = AnimationState()
    }

    self.event_manager:register(self)
    self.running = false
end

function GameEngine:notify(event)
    if event:isInstanceOf(GameLoadedEvent) then
        self.fsm:change_state(self.states.gameplay)
    end

    if event:isInstanceOf(StartAnimationEvent) then
        self.fsm:change_state(self.states.animation)
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
    self.fsm:update(dt, self.game_data)
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

function GameEngine:get_data()
    return self.game_data
end

function GameEngine:get_logic()
    return self.game_logic
end

return GameEngine
