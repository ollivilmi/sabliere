require 'src/client/states/play/entity/projectile/Projectile'

Bullet = Class{__includes = Projectile}

function Bullet:init(x, y, direction, collidables)
    Projectile:init(self, { 
        x = x,
        y = y,
        width = BULLET_WIDTH,
        height = BULLET_HEIGHT,
        speed = BULLET_SPEED,
        collidables = collidables,
        direction = direction
    })

    self.damage = BULLET_DAMAGE
end

function Bullet:tileCollision(tile)
    self.toDestroy = true
    gTilemap:removeTiles(self.collider)
end

function Bullet:entityCollision(entity)
    entity.health = entity.health - self.damage
    self.toDestroy = true
    -- todo knockback
end

function Bullet:render()
    if DEBUG_MODE then
        Entity:render(self)
    end

    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end