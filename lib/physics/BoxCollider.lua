require 'lib/physics/Hitbox'
require 'lib/physics/Rectangle'

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

function BoxCollider:hasPoint(x,y)
    return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
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
function BoxCollider:initHitboxes(target)
    local HITBOX_SIZE = 6

    self.hitBoxes = {
        right = Hitbox(
            self.x + self.width - HITBOX_SIZE, 
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

function BoxCollider:updateHitboxes(x, y)
    for k, hitbox in pairs(self.hitBoxes) do
        hitbox.x = hitbox.x + x
        hitbox.y = hitbox.y + y
    end
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

function BoxCollider:getCenter()
    local x = self.x - (VIRTUAL_WIDTH / 2) + (self.width / 2)
    local y = self.y - (VIRTUAL_HEIGHT / 2) + (self.height / 2)
    return x,y
end

function BoxCollider:renderHitboxes()
    for k,hitbox in pairs(self.hitBoxes) do
        hitbox:render()
    end
end