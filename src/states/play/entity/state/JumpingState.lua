JumpingState = Class{__includes = State}

function JumpingState:init(entity)
    self.entity = entity
end

function JumpingState:enter(params)
    self.entity.sounds.jump:play()
    self.entity.dy = -GRAVITY * 75
end

function JumpingState:update(dt)
    self.entity:gravity(dt)

    if self.entity.dy >= 0 or self.entity:collidesTop() then
        self.entity.dy = 0
        self.entity:changeState('falling')
    else
        self:input()

        if self.entity.dx > 0 then
            self.entity:collidesRight()
        else
            self.entity:collidesLeft()
        end
    end
end