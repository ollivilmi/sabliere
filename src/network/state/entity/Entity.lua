require 'lib/game/StateMachine'
require 'src/network/state/entity/movement/FallingState'
require 'src/network/state/entity/movement/IdleState'
require 'src/network/state/entity/movement/JumpingState'
require 'src/network/state/entity/movement/MovingState'

require 'src/network/state/entity/EntityPhysics'

Entity = Class{__includes = EntityPhysics}

-- Entities are rectangular objects which implement gravity and
-- optionally different states of movement:
-- * falling
-- * moving
-- * idling
-- * jumping
function Entity:init(def, level)
    -- for rendering
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    self.dy = 0
    self.dx = 0

    self.level = level
    self.tilemap = level.tilemap
    
    -- affects dx
    self.speed = def.speed or 100
    -- affects rendering
    self.direction = 'right'
    -- affects knockbacks
    self.weight = def.weight or 100

    -- stats (max, min is 0)
    self.health = def.health or 100
    self.resources = def.resources or 100

    self.movementState = StateMachine {
        idle = IdleState(self),
        moving = MovingState(self),
        jumping = JumpingState(self),
        falling = FallingState(self)
    }

    self.state = 'falling'
    self:changeState(self.state)
end

function Entity:changeState(state)
    self.movementState:changeState(state)
    self.state = state
end

function Entity:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    self.movementState:update(dt)
end

function Entity:updateLocation(coords)
    self.x = coords.x
    self.y = coords.y
end

function Entity:render()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

--  to pass state between client and server
function Entity:getPrimitives()
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
        resources = self.resources
    }
end