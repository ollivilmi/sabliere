local tilemath = {}

tilemath.snap = function(size, ...)
    newValues = {...}

    for i, value in ipairs(newValues) do
        newValues[i] = value - math.fmod(value, size)
    end
    return unpack(newValues)
end

tilemath.diffTop = function(tile, entity)
    return (tile.y + tile.height) - (entity.y)
end

tilemath.diffBottom = function(tile, entity)
    return (tile.y) - (entity.y + entity.height)
end

tilemath.diffLeft = function(tile, entity)
    return (tile.x + tile.width) - (entity.x)
end

tilemath.diffRight = function(tile, entity)
    return (tile.x) - (entity.x + entity.width)
end

return tilemath