require 'src/network/state/tilemap/Tilemap'
require 'src/network/state/entity/projectile/Bullet'
require 'src/network/state/entity/Projectiles'

Level = Class{}

function Level:init()
    self.tilemap = Tilemap(100, 100, 10)
    
    self.players = {}
    -- self.projectiles = Projectiles()
end

function Level:loadAssets()
    self.tilemap:loadTextures()
end

function Level:playerCollision(collider)
    for k,player in pairs(self.players) do
        if collider:collides(player.collider) then
            return player
        end
    end
end

function Level:update(dt)
    -- self.projectiles:update(dt)

    for k, player in pairs(self.players) do
        player:update(dt)
    end
end

function Level:render()
    self.tilemap:render()
    -- self.projectiles:render()

    for k, player in pairs(self.players) do
        player:render()
    end
end

function Level:getSnapshot(entity)
    local players = {}

    for id, player in pairs(self.players) do
        players[id] = player:getState()
    end

    local chunk = self.tilemap:getChunk()

    return {
        players = players,
        chunk = chunk
    }
end

function Level:setSnapshot(snapshot)
    local players = {}

    for id, player in pairs(snapshot.players) do
        self.players[id] = Entity(player, self)
    end

    local chunk = self.tilemap:setChunk(snapshot.chunk)
end