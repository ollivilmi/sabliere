Collision = Class{}
require 'src/states/play/Hitbox'

function Collision:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    return true
end

function math.clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

function Collision:collidesCircle(target)
    -- closest x and y to circle
    closestX = math.clamp(self.x, target.x, target.x + target.width)
    closestY = math.clamp(self.y, target.y, target.y + target.height)

    distanceX = self.x - closestX
    distanceY = self.y - closestY

    -- If the distance is less than the circle's radius, an intersection occurs
    distanceSquared = (distanceX * distanceX) + (distanceY * distanceY);
    return distanceSquared < (self.radius * self.radius);
end

function Collision:collidesPoint(target)
    return self.x <= target.x and self.x + self.width >= target.x and self.y <= target.y and self.y + self.height >= target.y
end

function Collision:initHitboxes(target)
    local HITBOX_SIZE = 3

    self.hitBoxes = {
        right = Hitbox(
            self.x + self.width, 
            self.y + HITBOX_SIZE, 
            HITBOX_SIZE, 
            self.height - HITBOX_SIZE*2
        ),
        left = Hitbox(
            self.x,
            self.y + HITBOX_SIZE,
            HITBOX_SIZE,
            self.height - HITBOX_SIZE*2
        ),
        top = Hitbox(
            self.x,
            self.y,
            self.width,
            HITBOX_SIZE
        ),
        bottom = Hitbox(
            self.x,
            self.y + self.height - HITBOX_SIZE,
            self.width,
            HITBOX_SIZE
        )
    }
end

function Collision:updateHitboxes(x, y)
    for k, hitbox in pairs(self.hitBoxes) do
        hitbox.x = hitbox.x + x
        hitbox.y = hitbox.y + y
    end
end

function Collision:collidesRight(target)
    return self.hitBoxes.right:collides(target)
end

function Collision:collidesLeft(target)
    return self.hitBoxes.left:collides(target)
end

function Collision:collidesBottom(target)
    return self.hitBoxes.bottom:collides(target)
end

function Collision:collidesTop(target)
    return self.hitBoxes.top:collides(target)
end