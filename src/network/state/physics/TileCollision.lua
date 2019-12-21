TileCollision = {}

function TileCollision:rightTile(entity, tilemap)
    -- + 1 and - 1 to not stack with top / bottom tiles
    for y = entity.y + 1, entity.y + entity.height - 1, 10 do
        local tile = tilemap:pointToTile(entity.x + entity.width - 1, y)
        if tile then
            return tile
        end
    end

    return nil
end

function TileCollision:leftTile(entity, tilemap)
    -- + 1 and - 1 to not stack with top / bottom tiles
    for y = entity.y + 1, entity.y + entity.height - 1, 10 do
        local tile = tilemap:pointToTile(entity.x - 1, y)
        if tile then
            return tile
        end
    end

    return nil
end

function TileCollision:bottomTile(entity, tilemap)
    -- + 5 and - 5 to not stack with right / left tiles
    for x = entity.x + 5, entity.x + entity.width - 5, 10 do
        local tile = tilemap:pointToTile(x, entity.y + entity.height)
        if tile then
            return tile
        end
    end

    return nil
end

function TileCollision:topTile(entity, tilemap)
    -- + 5 and - 5 to not stack with right / left tiles
    for x = entity.x + 5, entity.x + entity.width - 5, 10 do
        local tile = tilemap:pointToTile(x, entity.y)
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