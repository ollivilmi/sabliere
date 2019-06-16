require 'src/states/play/lib/physics/Hitbox'

Collision = Class{}

function Collision:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    return true
end

-- Hitboxes are used to check which side is currently colliding with target
-- when AABB collision is not enough
--
-- HITBOX_SIZE is an offset to make left+right hitboxes not collide horizontally
-- top+bottom hitboxes not collide vertically
--
-- Basically creates the hitboxes for a rectangular object like this:
--                __
--               |  |
--                ‾‾
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
            self.x + HITBOX_SIZE,
            self.y,
            self.width - HITBOX_SIZE*2,
            HITBOX_SIZE
        ),
        bottom = Hitbox(
            self.x + HITBOX_SIZE,
            self.y + self.height - HITBOX_SIZE,
            self.width - HITBOX_SIZE*2,
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