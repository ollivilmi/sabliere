require 'src/network/state/physics/BoxCollider'

local tilemath = require 'lib/game/math/tilemath'

TileCollision = require 'src/network/state/physics/TileCollision'

EntityPhysics = Class{__includes = BoxCollider}

function EntityPhysics:grounded()
    return TileCollision:grounded(self, self.tilemap)
end

function EntityPhysics:topCollision()
    local tile = TileCollision:topTile(self, self.tilemap)

    if tile then
        self.dy = 0
        local y = tilemath.diffTop(tile, self) + 1
        self.y = self.y + y
    end

    return tile and true or false
end

function EntityPhysics:bottomCollision()
    local tile = TileCollision:bottomTile(self, self.tilemap)

    if tile then
        self.dy = 0
        local y = tilemath.diffBottom(tile, self) - 1
        self.y = self.y + y
    end

    return tile and true or false
end

function EntityPhysics:horizontalCollision()
    local tile = nil

    if self.dx > 0 then
        self.direction = 'right'

            tile = TileCollision:rightTile(self, self.tilemap)
            if tile then
                self.dx = 0
    
                local x = tilemath.diffRight(tile, self) - 1
                self.x = self.x + x
            end
    else
        self.direction = 'left'

        tile = TileCollision:leftTile(self, self.tilemap)
        if tile then
            self.dx = 0

            local x = tilemath.diffLeft(tile, self) + 1
            self.x = self.x + x
        end
    end

    return tile and true or false
end

function EntityPhysics:tileCollision()
    local collided = false

    if self.dy > 0 then
        collided = self:bottomCollision() and true
    elseif self.dy < 0 then
        collided = self:topCollision() and true
    end

    if tile then return tile end

    if self.dx ~= 0 then
        collided = self:horizontalCollision() and true
    end

    return collided
end

function EntityPhysics:collidesTile()
    local tile = nil

    if self.dy > 0 then
        tile = TileCollision:bottomTile(self, self.tilemap)
    elseif self.dy < 0 then
        tile = TileCollision:topTile(self, self.tilemap)
    end

    if tile then return tile end

    if self.dx > 0 then
        tile = TileCollision:rightTile(self, self.tilemap)
    elseif self.dx < 0 then
        tile = TileCollision:leftTile(self, self.tilemap)
    end

    return tile
end

function EntityPhysics:move(dx, dy)
    local tileSize = self.tilemap.tileSize
    -- if entity has moved more than tileSize at once, we need to check
    -- for tile collisions incrementally
    if math.abs(dx) > tileSize or math.abs(dy) > tileSize then
        local ix = dx / tileSize
        local iy = dy / tileSize

        for i = 1, tileSize do
            self.x = self.x + ix
            self.y = self.y + iy

            if self:tileCollision() then
                break
            end
        end
    -- entity moved less than tileSize, no need for anything fancy
    else
        self.x = self.x + dx
        self.y = self.y + dy
    end
end