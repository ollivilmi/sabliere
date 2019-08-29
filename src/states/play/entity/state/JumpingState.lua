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

    self.entity:topCollision()

    if self.entity.dy > 0 then
        self.entity:changeState('falling')
    else
        self:input()
        self.entity:horizontalCollision()
    end
end