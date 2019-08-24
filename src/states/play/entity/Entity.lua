require 'lib/physics/TileCollider'

Entity = Class{}

-- Entities are rectangular objects which implement gravity and
-- optionally different states of movement:
-- * falling
-- * moving
-- * idling
-- * jumping
function Entity:init(self, def)
    self.collider = TileCollider(def.x, def.y, def.width, def.height, def.scale)
    
    self.dy = 0
    self.dx = 0
    -- affects dx
    self.speed = def.speed
    -- could be a class
    self.sounds = def.sounds

    -- jumping - falling - moving - idle
    self.movementState = def.movementState
    self.direction = 'right'
end

function Entity:changeState(state)
    self.movementState:change(state)
end

function Entity:update(self, dt)
    self.collider.x = self.collider.x + self.dx * dt
    self.collider.y = self.collider.y + self.dy * dt

    self.movementState:update(dt)
end

function Entity:render(self)
    self.collider:render()
end