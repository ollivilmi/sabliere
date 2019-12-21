local tilemath = require 'lib/game/math/tilemath'

TileCollision = require 'src/network/state/physics/TileCollision'

EntityPhysics = Class{}

function EntityPhysics:grounded()
    return TileCollision:grounded(self, self.tilemap)
end

function EntityPhysics:upwardMovement()
    local tile = TileCollision:topTile(self, self.tilemap)

    if tile then
        self.dy = 0
        local y = tilemath.diffTop(tile, self) + 1
        self.y = self.y + y
    end
end

function EntityPhysics:downwardMovement()
    local tile = TileCollision:bottomTile(self, self.tilemap)

    if tile then
        self.dy = 0
        local y = tilemath.diffBottom(tile, self) - 1
        self.y = self.y + y
    end
end

function EntityPhysics:horizontalMovement()
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