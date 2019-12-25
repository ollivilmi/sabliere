AnimatedEntity = Class{}

function AnimatedEntity:init(entity, model)
    self.entity = entity
    self.model = model
    self.model:changeState(self.entity.state)

    self.entity.movementState:addListener(self, function(newState)
        self.model:changeState(newState)
    end)
    self.animated = true
end

function AnimatedEntity:update(dt)
    self.entity:update(dt)
    self.model:update(dt)
end

function AnimatedEntity:render()
    self.model:render(self.entity)
end