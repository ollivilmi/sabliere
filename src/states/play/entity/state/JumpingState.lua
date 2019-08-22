JumpingState = Class{__includes = State}

function JumpingState:init(entity)
    self.entity = entity
end

function JumpingState:enter(params)
    self.entity.sounds.jump:play()
    self.entity.dy = -GRAVITY * 75
end

function JumpingState:update(dt)
    self.entity.dy = self.entity.dy + GRAVITY

    if self.entity.dy >= 0 or self.entity.collider:collidesTop() then
        self.entity.dy = 0
        self.entity:changeState('falling')
    else
        self:input()

        if self.entity.dx > 0 then
            self.entity.collider:collidesRight()
        else
            self.entity.collider:collidesLeft()
        end
    end
end