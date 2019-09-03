require 'src/states/play/level/tilemap/Tilemap'
require 'src/states/play/entity/player/Player'
require 'src/states/play/entity/enemy/TargetDummy'
require 'src/states/play/entity/projectile/Bullet'

Level = Class{}

function Level:init(playState)
    gTilemap = Tilemap()
    gPlayer = Player(MAP_WIDTH / 2, MAP_HEIGHT - 300)
    local targetDummy = TargetDummy(MAP_WIDTH / 4, MAP_HEIGHT - 300)
    
    self.enemies = { targetDummy }
    self.entities = { gPlayer, targetDummy }
    self.bullets = {}
    -- speed multiplier, offset
    gCamera = Camera(1, gPlayer.collider, 150)

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

function Level:addEntity(entity)
    table.insert(self.entities, entity)
end

function Level:spawnBullet(entity, coordinates)
    -- todo: bullet owner

    local x, y = math.rectangleCenter(entity.collider)

    -- direction from shooter to x,y (eg. where cursor was clicked)
    local direction = Coordinates(math.unitVector(x, y, coordinates.x, coordinates.y))

    -- spawn bullet away from the entity's collider
    local spawnX = x + direction.x * (entity.collider.width / 2 + BULLET_WIDTH * 2)
    local spawnY = y + direction.y * (entity.collider.height / 2 + BULLET_HEIGHT * 2)

    table.insert(self.bullets, Bullet(spawnX, spawnY, direction, self.enemies))
end

function Level:update(dt)
    gCamera:update(dt)

    bulletsToDestroy = {}

    for k, bullet in pairs(self.bullets) do
        if bullet ~= nil then
            if not bullet.toDestroy then
                bullet:update(dt)
            end
        end
    end

    for k, entity in ipairs(self.entities) do
        entity:update(dt)
        -- entity:collides()
    end
end

function Level:render()
    -- using world coordinates from camera
    gCamera:translate()
    love.graphics.setColor(0.6,0.6,0.6)
    love.graphics.clear(0.5, 0.4, 0.3, 255)
    love.graphics.draw(gTextures.background, 0, 0)
    gTilemap:render()

    for k, bullet in ipairs(self.bullets) do
        if not bullet.toDestroy then
            bullet:render()
        end
    end

    for k, entity in pairs(self.entities) do
        entity:render()
    end

    if DEBUG_MODE then
        gPlayer.toolRange:render()
    end
end