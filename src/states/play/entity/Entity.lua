require 'src/states/play/entity/EntityCollider'

Entity = Class{}

-- Entities are rectangular objects which implement gravity and
-- optionally different states of movement:
-- * falling
-- * moving
-- * idling
-- * jumping
function Entity:init(self, def)
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    self.collider = EntityCollider(self, 1.0)

    self.dy = 0
    self.dx = 0
    
    -- affects dx
    self.speed = def.speed
    -- could be a class
    self.sounds = def.sounds

    self.health = def.health or 100

    -- jumping - falling - moving - idle
    self.movementState = def.movementState
    self.direction = 'right'
end

function Entity:changeState(state)
    self.movementState:change(state)
end

function Entity:update(self, dt)
    self.collider:updatePosition(self.dx * dt, self.dy * dt)
    self:input()
    self.movementState:update(dt)
end

function Entity:input()
    -- empty, can be implemented in child to controls
end

function Entity:render(self)
    if DEBUG_MODE then
        self.collider.tileCollider:render()
    end
end