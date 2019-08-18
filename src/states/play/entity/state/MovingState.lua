MovingState = Class{__includes = State}

function MovingState:init(entity)
    self.entity = entity
end

function MovingState:update(dt)
    if not self.entity:grounded() then
        self.entity:changeState('falling')
    end

    self:input()

    if self.entity.dx > 0 then
        self.entity.direction = 'right'
        self.entity:collidesRight()
    else
        self.entity.direction = 'left'
        self.entity:collidesLeft()
    end


end