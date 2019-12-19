require 'src/network/state/tilemap/Tilemap'
require 'src/network/state/entity/projectile/Bullet'
require 'src/network/state/entity/Projectiles'

Level = Class{}

function Level:init(playState)
    self.tilemap = Tilemap(100, 100, 10)
    
    self.entities = {}
    self.projectiles = Projectiles()
end

function Level:addEntity(id, entity)
    self.entities[id] = entity
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
    self.tilemap:render()
    self.projectiles:render()

    for k, entity in pairs(self.entities) do
        entity:render()
    end
end