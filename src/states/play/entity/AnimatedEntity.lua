require 'src/states/play/entity/Entity'

AnimatedEntity = Class{__includes = Entity}

function AnimatedEntity:init(self, def)
    Entity:init(self, def)
    self.sheet = def.sheet
    self.quads = GenerateQuads(self.sheet, 50, 100)
    self.animationState = def.animationState
    self.direction = 'right'
    self:changeState('falling')
end

function AnimatedEntity:update(dt)
    Entity:update(self, dt)
    self.animationState:update(dt)
end

function AnimatedEntity:changeState(state)
    self.stateMachine:change(state)
    self.animationState:change(state)
end

function AnimatedEntity:render()
    if DEBUG_MODE then
        Entity:render(self)
    end
    self.animationState:render()
end