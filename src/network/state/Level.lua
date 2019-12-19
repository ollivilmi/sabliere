require 'src/network/state/tilemap/Tilemap'
require 'src/network/state/entity/projectile/Bullet'
require 'src/network/state/entity/Projectiles'

Level = Class{}

function Level:init(playState)
    self.tilemap = Tilemap(100, 100, 10)
    
    self.entities = {}
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
    self.projectiles:update(dt)

    for k, entity in ipairs(self.entities) do
        entity:update(dt)
    end
end

function Level:render()
    love.graphics.setColor(0.6,0.6,0.6)
    love.graphics.clear(0.5, 0.4, 0.3, 255)
    love.graphics.draw(gTextures.background, 0, 0)
    self.tilemap:render()

    self.projectiles:render()

    for k, entity in pairs(self.entities) do
        entity:render()
    end

    if DEBUG_MODE then
        gPlayer.toolRange:render()
    end
end