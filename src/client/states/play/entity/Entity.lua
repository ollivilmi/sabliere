require 'src/client/states/play/entity/EntityPhysics'

Entity = Class{__includes = EntityPhysics}

-- Entities are rectangular objects which implement gravity and
-- optionally different states of movement:
-- * falling
-- * moving
-- * idling
-- * jumping
function Entity:init(self, def)
    EntityPhysics:init(self, def)

    -- could be a class
    self.sounds = def.sounds

    -- stats (max, min is 0)
    self.health = def.health or 100
    self.resources = def.resources or 100

    -- jumping - falling - moving - idle
    self.movementState = def.movementState
end

function Entity:changeState(state)
    self.movementState:change(state)
end

function Entity:update(self, dt)
    EntityPhysics:update(self, dt)
    self:input()
    self.movementState:update(dt)
end

function Entity:input()
    -- empty, can be implemented in child to controls
end

function Entity:render(self)
    if DEBUG_MODE then
        self.collider:render()
    end
end