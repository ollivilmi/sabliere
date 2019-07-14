function math.clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

function math.snap(...)
    newValues = {...}

    for i, value in ipairs(newValues) do
        newValues[i] = value - math.fmod(value, SNAP)
    end
    return unpack(newValues)
end

-- Debugging
function math.testSnap(oldValues, newValues)
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
function math.nearestTile(value)
    local previous = TILE_SIZE
    local next = TILE_SIZE

    while value >= next do
        previous = next
        next = previous * 2
    end

    return previous
end

function math.isTile(value)
    return math.nearestTile(value) == value
end

-- Basically just pythagoras theorem
function math.distance(ax, ay, bx, by)
    return math.sqrt((ax - bx)^2 + (ay - by)^2)
end

-- https://math.stackexchange.com/questions/796243/how-to-determine-the-direction-of-one-point-from-another-given-their-coordinate
-- https://en.wikipedia.org/wiki/Atan2
-- basically returns the angle in radians
function math.direction(ax, ay, bx, by)
    return math.atan2(by-ay,bx-ax)
end