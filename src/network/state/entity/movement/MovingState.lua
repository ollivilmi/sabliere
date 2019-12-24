require 'lib/game/State'

MovingState = Class{__includes = State}

function MovingState:init(entity)
    self.entity = entity
end

function MovingState:update(dt)
    if not self.entity:grounded() then
        self.entity:changeState('falling')
    end

    self.entity:horizontalCollision()
end