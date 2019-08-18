IdleState = Class{__includes = State}

function IdleState:init(entity)
    self.entity = entity
end

function IdleState:update(dt)
    self:input()
    if self.entity.dx ~= 0 then
        self.entity:changeState('moving')
    end
end