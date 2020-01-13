require 'lib/game/StateMachine'
require 'src/network/state/entity/movement/FallingState'
require 'src/network/state/entity/movement/IdleState'
require 'src/network/state/entity/movement/JumpingState'
require 'src/network/state/entity/movement/MovingState'

local Timer = require 'lib/game/love-utils/knife/timer'

Entity = Class{}

-- Entities are rectangular objects which implement physics
-- (gravity and collision)
function Entity:init(parameters, world)
    self.movementState = StateMachine {
        idle = IdleState(self),
        moving = MovingState(self),
        jumping = JumpingState(self),
        falling = FallingState(self)
    }

    self:setState(parameters)
    self.isEntity = true

    self.world = world
end

function Entity:changeState(state)
    self.movementState:changeState(state)
    self.state = state
end

local function entityCollision(player, other)
    if other.isResource then return 'cross'
    else
        return 'slide'
    end
end

function Entity:update(dt)
    self.movementState:update(dt)
    self.x, self.y, cols, cols_len = self.world:move(
        self, self.x + self.dx * dt, self.y + self.dy * dt,
        entityCollision
    )
    self.movementState.current:collisions(cols)
end

function Entity:checkGround()
    local items, len = self.world:queryRect(self.x, self.y + self.h + 1, self.w, 1, function(item)
        return item.isTile or item.isEntity
    end)
    if len == 0 then
        self:changeState('falling')
    end
end

function Entity:getLocation()
    return {x = self.x, y = self.y}
end

--  to pass all state between client and server
function Entity:getState()
    return {
        x = self.x,
        y = self.y,
        w = self.w,
        h = self.h,
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

-- When we only care about passing entity position (eg. ability fired)
function Entity:getPos()
    return {
        x = self.x,
        y = self.y,
        w = self.w,
        h = self.h
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
    self.w = state.w
    self.h = state.h
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