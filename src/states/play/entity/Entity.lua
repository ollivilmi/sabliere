require 'lib/physics/TileCollider'

Entity = Class{}

-- Entities are rectangular objects which implement gravity and
-- optionally different states of movement:
-- * falling
-- * moving
-- * idling
-- * jumping
function Entity:init(self, def)
    local scale = def.colliderScale or 1.0
    -- adjust offset of x,y when collider is larger or smaller than entity
    local cx = def.x - ((scale - 1.0) * def.width / 2)
    local cy = def.y - ((scale - 1.0) * def.height / 2)
    self.collider = TileCollider(cx, cy, def.width, def.height, scale)
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

function Entity:updateMovement(dt)
    local vx = self.dx * dt
    local vy = self.dy * dt

    for k,component in ipairs(self.components) do
        component.x = component.x + vx
        component.y = component.y + vy
    end
end

function Entity:update(self, dt)
    self:updateMovement(dt)
    self:input()
    self.movementState:update(dt)
end

function Entity:input()
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

function Entity:collidesTile()
    local tile = nil

    if self.dy > 0 then
        tile = self.collider:bottomTile()
    elseif self.dy < 0 then
        tile = self.collider:topTile()
    end

    if tile ~= nil then return true end

    if self.dx > 0 then
        tile = self.collider:rightTile()
    elseif self.dx < 0 then
        tile = self.collider:leftTile()
    end

    return tile ~= nil
end

function Entity:render(self)
    if DEBUG_MODE then
        self.collider:render()
    end
end