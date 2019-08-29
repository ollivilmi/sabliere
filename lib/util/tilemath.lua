tilemath = {}
tilemath.snap = function(...)
    newValues = {...}

    for i, value in ipairs(newValues) do
        newValues[i] = value - math.fmod(value, SNAP)
    end
    return unpack(newValues)
end

-- Debugging
tilemath.testnap = function(oldValues, newValues)
    if DEBUG_MODE then
        changed = false
        for i,v in ipairs(oldValues) do
            if oldValues[i] ~= newValues[i] then
                changed = true
            end
        end
        if changed then
            print("Snapped from " .. table.concat(oldValues,", ") .. " -> " .. table.concat(newValues,", "))
        end
    end
end

-- the idea of this function is to get the nearest possible tile
-- eg. 50 pixels -> 40 pixels, 100 pixels -> 80 pixels
tilemath.nearestTile = function(value)
    local previous = TILE_SIZE
    local next = TILE_SIZE

    while value >= next do
        previous = next
        next = previous * 2
    end

    return previous
end

tilemath.isTile = function(value)
    return tilemath.nearestTile(value) == value
end

tilemath.diffTop = function(tile, collider)
    return (tile.y + tile.height) - (collider.y)
end

tilemath.diffBottom = function(tile, collider)
    return (tile.y) - (collider.y + collider.height)
end

tilemath.diffLeft = function(tile, collider)
    return (tile.x + tile.width) - (collider.x)
end

tilemath.diffRight = function(tile, collider)
    return (tile.x) - (collider.x + collider.width)
end