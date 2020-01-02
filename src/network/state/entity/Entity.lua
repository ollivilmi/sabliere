require 'lib/game/StateMachine'
require 'src/network/state/entity/movement/FallingState'
require 'src/network/state/entity/movement/IdleState'
require 'src/network/state/entity/movement/JumpingState'
require 'src/network/state/entity/movement/MovingState'

require 'src/network/state/entity/EntityPhysics'

local Timer = require 'lib/game/love-utils/knife/timer'

Entity = Class{__includes = EntityPhysics}

-- Entities are rectangular objects which implement physics
-- (gravity and collision)
function Entity:init(parameters, level)
    self.movementState = StateMachine {
        idle = IdleState(self),
        moving = MovingState(self),
        jumping = JumpingState(self),
        falling = FallingState(self)
    }

    self:setState(parameters)

    self.level = level
    self.tilemap = level.tilemap
end

function Entity:changeState(state)
    self.movementState:changeState(state)
    self.state = state
end

function Entity:update(dt)
    self.movementState:update(dt)
    self:move(self.dx * dt, self.dy * dt)
end

function Entity:updateLocation(coords)
    self.x = coords.x
    self.y = coords.y
end

function Entity:getLocation()
    return {x = self.x, y = self.y}
end

--  to pass all state between client and server
function Entity:getState()
    return {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height,
        dy = self.dy,
        dx = self.dx,
        speed = self.speed,
        direction = self.direction,
        weight = self.weight,
        health = self.health,
        resources = self.resources,
        state = self.state,
        model = self.model
    }
end

-- to pass parameters that change rapidly
function Entity:getUpdates()
    return {
        x = self.x,
        y = self.y,
        dy = self.dy,
        dx = self.dx,
        health = self.health,
        resources = self.resources,
        state = self.state
    }
end

function Entity:updateState(state)
    for k,v in pairs(state) do
        self[k] = v
    end

    self:changeState(self.state)
end

function Entity:tween(time, state)
    Timer.tween(time, {
        [self] = { x = state.x, y = state.y}
    })
end

function Entity:setState(state)
    self.x = state.x
    self.y = state.y
    self.width = state.width
    self.height = state.height
    self.dy = state.dy or 0
    self.dx = state.dx or 0
    self.speed = state.speed or 200
    self.direction = state.direction or 'right'
    self.weight = state.weight or 2000
    self.health = state.health or 100
    self.resources = state.resources or 100
    self.state = state.state or 'falling'
    self.model = state.model or 'dude'

    self:changeState(self.state)
end