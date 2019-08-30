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

-- bandaid solution to change collision to reuse a method
function BoxCollider:mapCollider()
    return BoxCollider(self.x+1, self.y+1, self.width-2, self.height-2)
end