require 'lib/physics/BoxCollider'

TileCollider = Class{__includes = BoxCollider}

function TileCollider:rightTile()
    -- + 1 and - 1 to not stack with top / bottom tiles
    for y = self.y + 1, self.y + self.height - 1, TILE_SIZE do
        local tile = self.tilemap:pointToTile(self.x + self.width - 1, y)
        if tile.x ~= nil then
            return tile
        end
    end

    return nil
end

function TileCollider:leftTile()
    -- + 1 and - 1 to not stack with top / bottom tiles
    for y = self.y + 1, self.y + self.height - 1, TILE_SIZE do
        local tile = self.tilemap:pointToTile(self.x - 1, y)
        if tile.x ~= nil then
            return tile
        end
    end

    return nil
end

function TileCollider:bottomTile()
    -- + 5 and - 5 to not stack with right / left tiles
    for x = self.x + 5, self.x + self.width - 5, TILE_SIZE do
        local tile = self.tilemap:pointToTile(x, self.y + self.height)
        if tile.y ~= nil then
            return tile
        end
    end

    return nil
end

function TileCollider:topTile()
    -- + 5 and - 5 to not stack with right / left tiles
    for x = self.x + 5, self.x + self.width - 5, TILE_SIZE do
        local tile = self.tilemap:pointToTile(x, self.y)
        if tile.y ~= nil then
            return tile
        end
    end
    
    return nil
end

function TileCollider:collidesRight()
    local tile = self:rightTile()
    if tile ~= nil then
        self.x = tile.x - 1 - self.width
        self.dx = 0
        return true
    end
    return false
end

function TileCollider:collidesLeft()
    local tile = self:leftTile()
    if tile ~= nil then
        self.x = tile.x + 1 + tile.width
        self.dx = 0
        return true
    end
    return false
end

function TileCollider:collidesTop()
    local tile = self:topTile()
    if tile ~= nil then
        self.y = tile.y + tile.height + 1
        return true
    end
    return false
end

function TileCollider:grounded()
    self.y = self.y + 1
    local ground = self:bottomTile()
    self.y = self.y - 1

    return ground ~= nil
end