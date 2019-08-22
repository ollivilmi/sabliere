MovingState = Class{__includes = State}

function MovingState:init(entity)
    self.entity = entity
end

function MovingState:update(dt)
    if not self.entity.collider:grounded() then
        self.entity:changeState('falling')
    end

    self:input()

    if self.entity.dx > 0 then
        self.entity.direction = 'right'
        self.entity.collider:collidesRight()
    else
        self.entity.direction = 'left'
        self.entity.collider:collidesLeft()
    end


end