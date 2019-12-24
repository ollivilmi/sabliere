TileCollision = {}

function TileCollision:rightTile(entity, tilemap)
    -- + 1 and - 1 to not stack with top / bottom tiles
    for y = entity.y + 1, entity.y + entity.height - 1, tilemap.tileSize do
        local x = entity.x + entity.width - 1
        local tile = tilemap:pointToTile(x, y)
        
        if tile then
            return tile
        end
    end

    return nil
end

function TileCollision:leftTile(entity, tilemap)
    -- + 1 and - 1 to not stack with top / bottom tiles
    for y = entity.y + 1, entity.y + entity.height - 1, tilemap.tileSize do
        local x = entity.x - 1
        local tile = tilemap:pointToTile(x, y)
        
        if tile then
            return tile
        end
    end

    return nil
end

function TileCollision:bottomTile(entity, tilemap)
    -- + 5 and - 5 to not stack with right / left tiles
    for x = entity.x + 5, entity.x + entity.width - 5, tilemap.tileSize do
        local y = entity.y + entity.height
        local tile = tilemap:pointToTile(x, y)
        
        if tile then
            return tile
        end
    end

    return nil
end

function TileCollision:topTile(entity, tilemap)
    -- + 5 and - 5 to not stack with right / left tiles
    for x = entity.x + 5, entity.x + entity.width - 5, tilemap.tileSize do
        local y = entity.y
        local tile = tilemap:pointToTile(x, y)
        
        if tile then
            return tile
        end
    end
    
    return nil
end

function TileCollision:grounded(entity, tilemap)
    entity.y = entity.y + 1
    local ground = TileCollision:bottomTile(entity, tilemap)
    entity.y = entity.y - 1

    return ground ~= nil
end

return TileCollision