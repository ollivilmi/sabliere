require 'src/network/state/physics/Rectangle'

BoxCollider = Class{__includes = Rectangle}

function BoxCollider:collides(target)
    return math.rectangleCollidesRectangle(self, target)
end

function BoxCollider:hasPoint(c)
    return c.x >= self.x and c.x <= self.x + self.width and c.y >= self.y and c.y <= self.y + self.height
end

function BoxCollider:getCenter()
    return math.rectangleCenter(self)
end
