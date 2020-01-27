Bullet = Class{}

local BULLET_WIDTH = 10
local BULLET_HEIGHT = 10
local BULLET_SPEED = 800

function Bullet:init(pos, cursor)
    local x, y = math.rectangleCenter(pos)
    -- direction from shooter to cursor
    local direction = Coordinates(math.unitVector(x, y, cursor.x, cursor.y))

    -- spawn bullet away from the entity's collider
    
    self.isProjectile = true
    self.x = x + direction.x * (pos.w / 2 + BULLET_WIDTH * 2)
    self.y = y + direction.y * (pos.h / 2 + BULLET_HEIGHT * 2)
    self.w = BULLET_WIDTH
    self.h = BULLET_HEIGHT
    self.dx = direction.x * BULLET_SPEED
    self.dy = direction.y * BULLET_SPEED
end