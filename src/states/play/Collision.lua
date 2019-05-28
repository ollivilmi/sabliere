Collision = Class{}

function Collision:collides(target)
    return self:collidesX(target) and self:collidesY(target)
end

function Collision:collidesX(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    return true
end

function Collision:collidesY(target)
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    return true
end