require 'src/network/state/entity/Entity'

AnimatedEntity = Class{__includes = Entity}

function AnimatedEntity:init(self, def)
    Entity:init(self, def)
    self.sheet = def.sheet
    self.quads = GenerateQuads(self.sheet, def.width, def.height)
    self.animationState = def.animationState
    self:changeState('falling')
end

function AnimatedEntity:update(dt)
    Entity:update(self, dt)
    self.animationState:update(dt)
end

function AnimatedEntity:changeState(state)
    self.movementState:change(state)
    self.animationState:change(state)
end

function AnimatedEntity:render()
    if DEBUG_MODE then
        Entity:render(self)
    end
    self.animationState:render()
end