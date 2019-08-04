require 'lib/physics/AABB'

BoxCollider = Class{__includes = AABB}

-- Hitboxes are used to check which side is currently colliding with target
-- when AABB collision is not enough
--
-- self.size is an offset to make left+right hitboxes not collide horizontally
-- top+bottom hitboxes not collide vertically
--
-- Basically creates the hitboxes for a rectangular object like this:
--                __
--               |  |
--                ‾‾
function BoxCollider:initHitboxes(target)
    self.size = 8

    self.hitBoxes = {
        right = AABB(
            self.x + self.width - self.size, 
            self.y + self.size, 
            self.size, 
            self.height - self.size * 2
        ),
        left = AABB(
            self.x,
            self.y + self.size,
            self.size,
            self.height - self.size * 2
        ),
        top = AABB(
            self.x + self.size,
            self.y,
            self.width - self.size * 2,
            self.size
        ),
        bottom = AABB(
            self.x + self.size,
            self.y + self.height - self.size,
            self.width - self.size * 2,
            self.size
        )
    }
end

function BoxCollider:updateHitboxes(x, y)
        self.hitBoxes.right.x = x + self.width - self.size
        self.hitBoxes.right.y = y + self.size

        self.hitBoxes.left.x = x
        self.hitBoxes.left.y = y + self.size

        self.hitBoxes.top.x = x + self.size
        self.hitBoxes.top.y = y

        self.hitBoxes.bottom.x = x + self.size
        self.hitBoxes.bottom.y = y + self.height - self.size
end

-- bandaid solution to change collision to reuse a method
function BoxCollider:mapCollider()
    return BoxCollider(self.x+1, self.y+1, self.width-2, self.height-2)
end

function BoxCollider:collidesRight(target)
    return self.hitBoxes.right:collides(target)
end

function BoxCollider:collidesLeft(target)
    return self.hitBoxes.left:collides(target)
end

function BoxCollider:collidesBottom(target)
    return self.hitBoxes.bottom:collides(target)
end

function BoxCollider:collidesTop(target)
    return self.hitBoxes.top:collides(target)
end

function BoxCollider:renderHitboxes()
    for k,hitbox in pairs(self.hitBoxes) do
        hitbox:render()
    end
end