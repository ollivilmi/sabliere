require 'src/client/states/play/rendering/PlayerRendering'
require 'src/client/states/play/rendering/TilemapRendering'

require 'src/client/states/play/entity/player/Camera'

-- Wraps GameState level for animations and stuff
LevelRendering = Class{}

function LevelRendering:init(level)
    self.level = level

    self.camera = Camera(1, 120)

    self.tilemap = TilemapRendering(self.level.tilemap)
    self.players = PlayerRendering(self.level.players)

    self.renderingLayers = {
        {}, -- to add: background, background tiles?
        { self.tilemap },
        { self.players }
    }
end

function LevelRendering:addRenderable(layer, renderable)
    local layer = self.renderingLayers[layer]

    if not layer then
        layer = {}
    end

    table.insert(layer, renderable)
end

function LevelRendering:update(dt)
    self.camera:update(dt)
    self.players:update(dt)
end

function LevelRendering:render()
    -- interface:render()
    self.camera:translate()

    for depth, layer in pairs(self.renderingLayers) do
        for k, renderable in pairs(layer) do
            renderable:render()
        end
    end
end