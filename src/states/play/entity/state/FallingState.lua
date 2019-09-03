require 'lib/state/State'

FallingState = Class{__includes = State}

function FallingState:init(entity)
    self.entity = entity
end

function FallingState:update(dt)
    self.entity.dy = self.entity.dy + GRAVITY

    self.entity.collider:downwardMovement()

    if self.entity.dy == 0 then
        if self.entity.dx ~= 0 then
            self.entity:changeState('moving')
        else
            self.entity:changeState('idle')
        end
    else
        self:input()
        self.entity.collider:horizontalMovement()
    end
end