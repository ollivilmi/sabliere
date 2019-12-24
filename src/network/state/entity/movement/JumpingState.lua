require 'lib/game/State'

JumpingState = Class{__includes = State}

function JumpingState:init(entity)
    self.entity = entity
end

function JumpingState:enter(params)
    self.entity.dy = -self.entity.weight * 0.3
end

function JumpingState:update(dt)
    self.entity.dy = self.entity.dy + (self.entity.weight * dt)

    self.entity:upwardMovement()

    if self.entity.dy > 0 then
        self.entity:changeState('falling')
    else
        self.entity:horizontalMovement()
    end
end