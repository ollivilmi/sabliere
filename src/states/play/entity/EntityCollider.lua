require 'lib/physics/TileCollider'

-- Entity can have multiple separate colliders attached
-- this class is a component of Entity
EntityCollider = Class{}

function EntityCollider:init(entity, scale)
    local scale = scale or 1.0
    -- adjust offset of x,y when collider is larger or smaller than entity
    local cx = entity.x - ((scale - 1.0) * entity.width / 2)
    local cy = entity.y - ((scale - 1.0) * entity.height / 2)
    self.tileCollider = TileCollider(cx, cy, entity.width, entity.height, scale)

    -- table is used as other colliders may be added which also need x,y to be updated
    self.components = { 
        entity, 
        self.tileCollider,
    }

    self.entity = entity
end

function EntityCollider:addX(x)
    for k,component in ipairs(self.components) do
        component.x = component.x + x
    end
end

function EntityCollider:addY(y)
    for k,component in ipairs(self.components) do
        component.y = component.y + y
    end
end

function EntityCollider:updatePosition(velocityX, velocityY)
    for k,component in ipairs(self.components) do
        component.x = component.x + velocityX
        component.y = component.y + velocityY
    end
end


-- function Entity:knockback(x, y) m
-- end

-- The functions below are handled in this class because they alter
-- Entity + collider state, and we do not want to do this kind of logic in collider

function EntityCollider:upwardMovement()
    local tile = self.tileCollider:topTile()

    if tile ~= nil then
        self.entity.dy = 0
        local y = tilemath.diffTop(tile, self.tileCollider) + 1
        self:addY(y)
    end
end

function EntityCollider:downwardMovement()
    local tile = self.tileCollider:bottomTile()

    if tile ~= nil then
        self.entity.dy = 0
        local y = tilemath.diffBottom(tile, self.tileCollider) - 1
        self:addY(y)
    end
end

function EntityCollider:horizontalMovement()
    local tile = nil

    if self.entity.dx > 0 then
        self.entity.direction = 'right'

            tile = self.tileCollider:rightTile()
            if tile ~= nil then
                self.entity.dx = 0
    
                local x = tilemath.diffRight(tile, self.tileCollider) - 1
                self:addX(x)
            end
    else
        self.entity.direction = 'left'

        tile = self.tileCollider:leftTile()
        if tile ~= nil then
            self.entity.dx = 0

            local x = tilemath.diffLeft(tile, self.tileCollider) + 1
            self:addX(x)
        end
    end
end

function EntityCollider:collidesTile()
    local tile = nil

    if self.entity.dy > 0 then
        tile = self.tileCollider:bottomTile()
    elseif self.entity.dy < 0 then
        tile = self.tileCollider:topTile()
    end

    if tile ~= nil then return true end

    if self.entity.dx > 0 then
        tile = self.tileCollider:rightTile()
    elseif self.entity.dx < 0 then
        tile = self.tileCollider:leftTile()
    end

    return tile ~= nil
end