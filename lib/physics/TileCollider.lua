require 'lib/physics/BoxCollider'

TileCollider = Class{__includes = BoxCollider}

function TileCollider:rightTile()
    -- + 1 and - 1 to not stack with top / bottom tiles
    for y = self.y + 1, self.y + self.height - 1, TILE_SIZE do
        local tile = gTilemap:pointToTile(self.x + self.width - 1, y)
        if tile ~= nil then
            return tile
        end
    end

    return nil
end

function TileCollider:leftTile()
    -- + 1 and - 1 to not stack with top / bottom tiles
    for y = self.y + 1, self.y + self.height - 1, TILE_SIZE do
        local tile = gTilemap:pointToTile(self.x - 1, y)
        if tile ~= nil then
            return tile
        end
    end

    return nil
end

function TileCollider:bottomTile()
    -- + 5 and - 5 to not stack with right / left tiles
    for x = self.x + 5, self.x + self.width - 5, TILE_SIZE do
        local tile = gTilemap:pointToTile(x, self.y + self.height)
        if tile ~= nil then
            return tile
        end
    end

    return nil
end

function TileCollider:topTile()
    -- + 5 and - 5 to not stack with right / left tiles
    for x = self.x + 5, self.x + self.width - 5, TILE_SIZE do
        local tile = gTilemap:pointToTile(x, self.y)
        if tile ~= nil then
            return tile
        end
    end
    
    return nil
end

function TileCollider:grounded()
    self.y = self.y + 1
    local ground = self:bottomTile()
    self.y = self.y - 1

    return ground ~= nil
end