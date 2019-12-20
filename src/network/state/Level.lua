require 'src/network/state/tilemap/Tilemap'
require 'src/network/state/entity/projectile/Bullet'
require 'src/network/state/entity/Projectiles'

Level = Class{}

function Level:init(playState)
    self.tilemap = Tilemap(100, 100, 10)
    
    self.players = {}
    self.projectiles = Projectiles()
end

function Level:addPlayer(id, player)
    self.players[id] = player
end

function Level:playerCollision(collider)
    for k,player in pairs(self.players) do
        if collider:collides(player.collider) then
            return player
        end
    end
end

function Level:update(dt)
    self.projectiles:update(dt)

    for k, player in pairs(self.players) do
        player:update(dt)
    end
end

function Level:render()
    self.tilemap:render()
    self.projectiles:render()

    for k, player in pairs(self.players) do
        player:render()
    end
end