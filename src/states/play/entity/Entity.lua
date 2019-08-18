require 'lib/physics/TileCollider'

Entity = Class{__includes = TileCollider}

-- Entities are rectangular objects which implement gravity and
-- optionally different states of movement:
-- * falling
-- * moving
-- * idling
-- * jumping
function Entity:init(self, def)
    self.x = def.x
    self.y = def.y
    self.dy = 0
    self.dx = 0
    -- affects dx
    self.speed = def.speed
    self.sounds = def.sounds

    self.width = def.width
    self.height = def.height

    -- map is needed for collision logic
    self.tilemap = def.level.tilemap

    -- jumping - falling - moving - idle
    self.stateMachine = def.stateMachine
end

function Entity:changeState(state)
    self.stateMachine:change(state)
end

function Entity:update(self, dt)
    self.x = self.x + self.dx * dt
    self.stateMachine:update(dt)
end

function Entity:gravity(dt)
    self.dy = self.dy + GRAVITY
    self.y = self.y + (self.dy * dt)
end

function Entity:render(self)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end