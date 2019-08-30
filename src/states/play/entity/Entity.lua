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
    -- table is used as other components may be added which also need x,y to be updated
    self.components = { 
        self, 
        self.collider, 
    }
    
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

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

function Entity:addX(x)
    for k,component in ipairs(self.components) do
        component.x = component.x + x
    end
end

function Entity:addY(y)
    for k,component in ipairs(self.components) do
        component.y = component.y + y
    end
end

function Entity:update(self, dt)
    local vx = self.dx * dt
    local vy = self.dy * dt

    for k,component in ipairs(self.components) do
        component.x = component.x + vx
        component.y = component.y + vy
    end

    self.movementState:update(dt)
end

function Entity:topCollision()
    local tile = self.collider:topTile()

    if tile ~= nil then
        self.dy = 0
        local y = tilemath.diffTop(tile, self.collider) + 1
        self:addY(y)
    end
end

function Entity:bottomCollision()
    local tile = self.collider:bottomTile()

    if tile ~= nil then
        self.dy = 0
        local y = tilemath.diffBottom(tile, self.collider) - 1
        self:addY(y)
    end
end

function Entity:horizontalCollision()
    local tile = nil

    if self.dx > 0 then
        self.direction = 'right'

            tile = self.collider:rightTile()
            if tile ~= nil then
                self.dx = 0
    
                local x = tilemath.diffRight(tile, self.collider) - 1
                self:addX(x)
            end
    else
        self.direction = 'left'

        tile = self.collider:leftTile()
        if tile ~= nil then
            self.dx = 0

            local x = tilemath.diffLeft(tile, self.collider) + 1
            self:addX(x)
        end
    end
end

function Entity:render(self)
    self.collider:render()
end