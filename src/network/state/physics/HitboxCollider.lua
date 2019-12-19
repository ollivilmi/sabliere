require 'src/network/state/physics/BoxCollider'

HitboxCollider = Class{__includes = BoxCollider}

-- Hitboxes are used to check which side is currently colliding with target
-- when BoxCollider collision is not enough
--
-- self.size is an offset to make left+right hitboxes not collide horizontally
-- top+bottom hitboxes not collide vertically
--
-- Basically creates the hitboxes for a rectangular object like this:
--                __
--               |  |
--                ‾‾
function HitboxCollider:initHitboxes(target)
    self.size = 8

    self.hitBoxes = {
        right = BoxCollider(
            self.x + self.width - self.size, 
            self.y + self.size, 
            self.size, 
            self.height - self.size * 2
        ),
        left = BoxCollider(
            self.x,
            self.y + self.size,
            self.size,
            self.height - self.size * 2
        ),
        top = BoxCollider(
            self.x + self.size,
            self.y,
            self.width - self.size * 2,
            self.size
        ),
        bottom = BoxCollider(
            self.x + self.size,
            self.y + self.height - self.size,
            self.width - self.size * 2,
            self.size
        )
    }
end

function HitboxCollider:updateHitboxes(x, y)
        self.hitBoxes.right.x = x + self.width - self.size
        self.hitBoxes.right.y = y + self.size

        self.hitBoxes.left.x = x
        self.hitBoxes.left.y = y + self.size

        self.hitBoxes.top.x = x + self.size
        self.hitBoxes.top.y = y

        self.hitBoxes.bottom.x = x + self.size
        self.hitBoxes.bottom.y = y + self.height - self.size
end

function HitboxCollider:collidesRight(target)
    return self.hitBoxes.right:collides(target)
end

function HitboxCollider:collidesLeft(target)
    return self.hitBoxes.left:collides(target)
end

function HitboxCollider:collidesBottom(target)
    return self.hitBoxes.bottom:collides(target)
end

function HitboxCollider:collidesTop(target)
    return self.hitBoxes.top:collides(target)
end

function HitboxCollider:renderHitboxes()
    for k,hitbox in pairs(self.hitBoxes) do
        hitbox:render()
    end
end