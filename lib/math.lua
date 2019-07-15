function math.clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
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