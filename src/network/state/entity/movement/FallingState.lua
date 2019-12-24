require 'lib/game/State'

FallingState = Class{__includes = State}

function FallingState:init(entity)
    self.entity = entity
end

function FallingState:update(dt)
    self.entity.dy = math.max(100, self.entity.dy + (self.entity.weight * dt))

    self.entity:downwardMovement()

    if self.entity.dy == 0 then
        if self.entity.dx ~= 0 then
            self.entity:changeState('moving')
        else
            self.entity:changeState('idle')
        end
    else
        self.entity:horizontalMovement()
    end
end