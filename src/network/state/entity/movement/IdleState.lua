require 'lib/game/State'

IdleState = Class{__includes = State}

function IdleState:init(entity)
    self.entity = entity
end

function IdleState:update(dt)
    if self.entity.dx ~= 0 then
        self.entity:changeState('moving')
    end

    self.entity:checkGround()
end

function IdleState:collisions(collisions)

end