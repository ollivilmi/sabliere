require 'lib/game/tilemap/Tilemap'
require 'src/client/states/play/entity/player/Player'
require 'src/client/states/play/entity/enemy/TargetDummy'
require 'src/client/states/play/entity/projectile/Bullet'
require 'src/client/states/play/level/Projectiles'

Level = Class{}

function Level:init(playState)
    gTilemap = Tilemap()

    gPlayer = Player(MAP_WIDTH / 2, MAP_HEIGHT - 300)
    local targetDummy = TargetDummy(MAP_WIDTH / 4, MAP_HEIGHT - 300)
    
    self.enemies = { targetDummy }
    self.entities = { gPlayer, targetDummy }
    -- speed multiplier, offset
    gCamera = Camera(1, gPlayer, 150)

    self.projectiles = Projectiles()
end

function Level:addEntity(entity)
    table.insert(self.entities, entity)
end

function Level:entityCollision(collider)
    for k,entity in ipairs(self.entities) do
        if collider:collides(entity.collider) then
            return entity
        end
    end
end

function Level:update(dt)
    gCamera:update(dt)

    self.projectiles:update(dt)

    for k, entity in ipairs(self.entities) do
        entity:update(dt)
    end
end

function Level:render()
    -- using world coordinates from camera
    gCamera:translate()
    love.graphics.setColor(0.6,0.6,0.6)
    love.graphics.clear(0.5, 0.4, 0.3, 255)
    love.graphics.draw(gTextures.background, 0, 0)
    gTilemap:render()

    self.projectiles:render()

    for k, entity in pairs(self.entities) do
        entity:render()
    end

    if DEBUG_MODE then
        gPlayer.toolRange:render()
    end
end