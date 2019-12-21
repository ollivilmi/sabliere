AnimatedEntity = Class{}

function AnimatedEntity:init(entity, def)
    self.entity = entity
    self.entity.movementState:addListener(self)
    
    self.animationState = def.animationState
    self.animationState:changeState(self.entity.state)
end

function AnimatedEntity:onStateChange(stateName)
    self.animationState:changeState(stateName)
end

function AnimatedEntity:update(dt)
    self.animationState:update(dt)
end

function AnimatedEntity:render()
    self.animationState:render()
end