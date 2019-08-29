MovingState = Class{__includes = State}

function MovingState:init(entity)
    self.entity = entity
end

function MovingState:update(dt)
    if not self.entity.collider:grounded() then
        self.entity:changeState('falling')
    end

    self:input()
    self.entity:horizontalCollision()
end