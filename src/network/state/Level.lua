require 'src/network/state/tilemap/Tilemap'
require 'src/network/state/entity/Players'

require 'src/network/state/entity/projectile/Bullet'
require 'src/network/state/entity/Projectiles'

require 'src/client/states/play/entity/player/Camera'

Level = Class{}

function Level:init()
    self.tilemap = Tilemap(100, 100, 10)
    self.players = Players(self)

    self.camera = Camera(1, 120)

    self.renderingLayers = {
        {}, -- to add: background, background tiles?
        { self.tilemap },
        { self.players }
    }
    -- self.projectiles = Projectiles()
end

function Level:addRenderable(layer, renderable)
    local layer = self.renderingLayers[layer]

    if not layer then
        layer = {}
    end

    table.insert(layer, renderable)
end

function Level:loadAssets()
    if not love then return end
    self.tilemap:loadTextures()
end

function Level:update(dt)
    self.camera:update(dt)
    self.players:update(dt)
end

function Level:render()
    -- interface:render()
    self.camera:translate()

    for depth, layer in pairs(self.renderingLayers) do
        for k, renderable in pairs(layer) do
            renderable:render()
        end
    end
end

function Level:getSnapshot(entity)
    return {
        players = self.players:getSnapshot(),
        chunk =  self.tilemap:getChunk()
    }
end

function Level:setSnapshot(snapshot)
    self.players:setSnapshot(snapshot.players)
    self.tilemap:setChunk(snapshot.chunk)
end