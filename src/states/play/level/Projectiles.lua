require 'src/states/play/entity/projectile/Bullet'

Projectiles = Class{}

function Projectiles:init(playState)
    self.projectiles = {}

    Timer.every(10, function() 
        local projectiles = {}

        for k,projectile in pairs(self.projectiles) do
            if not projectile.toDestroy then
                table.insert(projectiles, projectile)
            end
            self.projectiles = projectiles
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

    table.insert(self.projectiles, Bullet(spawnX, spawnY, direction, enemies))
end

function Projectiles:update(dt)
    for k, projectile in pairs(self.projectiles) do
        if projectile ~= nil then
            if not projectile.toDestroy then
                projectile:update(dt)
            end
        end
    end
end

function Projectiles:render()
    for k, projectile in ipairs(self.projectiles) do
        if not projectile.toDestroy then
            projectile:render()
        end
    end
end