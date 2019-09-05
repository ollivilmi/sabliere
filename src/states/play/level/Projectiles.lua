require 'src/states/play/entity/projectile/Bullet'

Projectiles = Class{}

function Projectiles:init(playState)
    self.bullets = {}

    Timer.every(10, function() 
        local bullets = {}

        for k,b in pairs(self.bullets) do
            if not b.toDestroy then
                table.insert(bullets, b)
            end
            self.bullets = bullets
        end
    end)
end

function Projectiles:spawnBullet(entity, coordinates, enemies)
    -- todo: bullet owner

    local x, y = math.rectangleCenter(entity.collider)

    -- direction from shooter to x,y (eg. where cursor was clicked)
    local direction = Coordinates(math.unitVector(x, y, coordinates.x, coordinates.y))

    -- spawn bullet away from the entity's collider
    local spawnX = x + direction.x * (entity.collider.width / 2 + BULLET_WIDTH * 2)
    local spawnY = y + direction.y * (entity.collider.height / 2 + BULLET_HEIGHT * 2)

    table.insert(self.bullets, Bullet(spawnX, spawnY, direction, enemies))
end

function Projectiles:update(dt)
    bulletsToDestroy = {}

    for k, bullet in pairs(self.bullets) do
        if bullet ~= nil then
            if not bullet.toDestroy then
                bullet:update(dt)
            end
        end
    end
end

function Projectiles:render()
    for k, bullet in ipairs(self.bullets) do
        if not bullet.toDestroy then
            bullet:render()
        end
    end
end