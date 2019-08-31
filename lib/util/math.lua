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

-- AABB collision
function math.rectangleCollidesRectangle(rectangleA, rectangleB)
    if rectangleA.x > rectangleB.x + rectangleB.width or rectangleB.x > rectangleA.x + rectangleA.width then
        return false
    end

    if rectangleA.y > rectangleB.y + rectangleB.height or rectangleB.y > rectangleA.y + rectangleA.height then
        return false
    end

    return true
end

function math.rectangleCenter(rectangle)
    local x = math.floor(rectangle.x + (rectangle.width / 2))
    local y = math.floor(rectangle.y + (rectangle.height / 2))
    return x,y
end

function math.circleCollidesRectangle(circle, rectangle)
    -- closest x and y to circle
    closestX = math.clamp(circle.x, rectangle.x, rectangle.x + rectangle.width)
    closestY = math.clamp(circle.y, rectangle.y, rectangle.y + rectangle.height)

    distanceX = circle.x - closestX
    distanceY = circle.y - closestY

    -- If the distance is less than the circle's radius, an intersection occurs
    distanceSquared = (distanceX * distanceX) + (distanceY * distanceY);
    return distanceSquared < (circle.radius * circle.radius);
end

function math.circleContainsRectangle(circle, rectangle)
    for x = rectangle.x, rectangle.x + rectangle.width, rectangle.width do
        for y = rectangle.y, rectangle.y + rectangle.height, rectangle.height do
            if not circle:hasPoint(x, y) then
                return false
            end
        end
    end
    return true
end