require 'lib/game/physics/TileCollider'

-- Entity can have multiple separate colliders attached for different purposes
-- this class is a parent of Entity
EntityPhysics = Class{}

function EntityPhysics:init(self, def)
    -- for rendering
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    self.dy = 0
    self.dx = 0
    
    -- affects dx
    self.speed = def.speed or 100
    -- affects rendering
    self.direction = 'right'
    -- affects knockbacks
    self.weight = def.weight or 100

    local scale = def.scale or 1.0
    -- adjust offset of x,y when collider is larger or smaller than entity
    local cx = def.x - ((scale - 1.0) * def.width / 2)
    local cy = def.y - ((scale - 1.0) * def.height / 2)
    self.collider = TileCollider(cx, cy, def.width, def.height, scale)

    -- table is used as other colliders may be added which also need x,y to be updated
    self.components = { 
        self, 
        self.collider,
    }
end

function EntityPhysics:addX(x)
    for k,component in ipairs(self.components) do
        component.x = component.x + x
    end
end

function EntityPhysics:addY(y)
    for k,component in ipairs(self.components) do
        component.y = component.y + y
    end
end

function EntityPhysics:update(self, dt)
    local velocityX = self.dx * dt
    local velocityY = self.dy * dt

    for k,component in ipairs(self.components) do
        component.x = component.x + velocityX
        component.y = component.y + velocityY
    end
end


-- function Entity:knockback(x, y) m
-- end

-- The functions below are handled in this class because they alter
-- Entity + collider state, and we do not want to do this kind of logic in collider

function EntityPhysics:upwardMovement()
    local tile = self.collider:topTile()

    if tile then
        self.dy = 0
        local y = tilemath.diffTop(tile, self.collider) + 1
        self:addY(y)
    end
end

function EntityPhysics:downwardMovement()
    local tile = self.collider:bottomTile()

    if tile then
        self.dy = 0
        local y = tilemath.diffBottom(tile, self.collider) - 1
        self:addY(y)
    end
end

function EntityPhysics:horizontalMovement()
    local tile = nil

    if self.dx > 0 then
        self.direction = 'right'

            tile = self.collider:rightTile()
            if tile then
                self.dx = 0
    
                local x = tilemath.diffRight(tile, self.collider) - 1
                self:addX(x)
            end
    else
        self.direction = 'left'

        tile = self.collider:leftTile()
        if tile then
            self.dx = 0

            local x = tilemath.diffLeft(tile, self.collider) + 1
            self:addX(x)
        end
    end
end

function EntityPhysics:collidesTile()
    local tile = nil

    if self.dy > 0 then
        tile = self.collider:bottomTile()
    elseif self.dy < 0 then
        tile = self.collider:topTile()
    end

    if tile then return tile end

    if self.dx > 0 then
        tile = self.collider:rightTile()
    elseif self.dx < 0 then
        tile = self.collider:leftTile()
    end

    return tile
end