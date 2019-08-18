BoxCollider = Class{__includes = Rectangle}

function BoxCollider:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    return true
end

function BoxCollider:hasPoint(c)
    return c.x >= self.x and c.x <= self.x + self.width and c.y >= self.y and c.y <= self.y + self.height
end

function BoxCollider:getCenter()
    local x = self.x - (VIRTUAL_WIDTH / 2) + (self.width / 2)
    local y = self.y - (VIRTUAL_HEIGHT / 2) + (self.height / 2)
    return x,y
end

-- bandaid solution to change collision to reuse a method
function BoxCollider:mapCollider()
    return BoxCollider(self.x+1, self.y+1, self.width-2, self.height-2)
end