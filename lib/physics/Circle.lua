require 'lib/physics/Rectangle'

Circle = Class{}

function Circle:init(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius or 0
end

function Circle:collides(rectangle)
    return math.circleCollidesRectangle(self, rectangle)
end

function Circle:hasPoint(x,y)
    return math.distance(self.x, self.y, x, y) <= self.radius
end

function Circle:toRectangle()
    return Rectangle(self.x - self.radius, self.y - self.radius, self.radius*2, self.radius*2)
end

function Circle:render()
    love.graphics.circle('line', self.x, self.y, self.radius)
end