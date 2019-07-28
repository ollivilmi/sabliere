require 'lib/physics/Rectangle'

Circle = Class{}

function Circle:init(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
end

function Circle:collides(target)
    -- closest x and y to circle
    closestX = math.clamp(self.x, target.x, target.x + target.width)
    closestY = math.clamp(self.y, target.y, target.y + target.height)

    distanceX = self.x - closestX
    distanceY = self.y - closestY

    -- If the distance is less than the circle's radius, an intersection occurs
    distanceSquared = (distanceX * distanceX) + (distanceY * distanceY);
    return distanceSquared < (self.radius * self.radius);
end

function Circle:toRectangle()
    return Rectangle(self.x - self.radius, self.y - self.radius, self.radius*2, self.radius*2)
end