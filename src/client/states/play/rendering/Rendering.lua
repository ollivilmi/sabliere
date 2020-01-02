require 'src/client/states/play/rendering/level/PlayerRendering'
require 'src/client/states/play/rendering/level/TilemapRendering'

require 'src/client/states/play/rendering/Camera'
require 'src/client/states/play/rendering/interface/Interface'

-- Wraps GameState level for animations and stuff
Rendering = Class{}

function Rendering:init(gameState)
    self.level = gameState.level

    self.camera = Camera(1, 120)

    self.tilemap = TilemapRendering(self.level.tilemap)
    self.players = PlayerRendering(self.level.players)

    self.interface = Interface(gameState)

    self.renderingLayers = {
        {}, -- to add: background, background tiles?
        { self.tilemap },
        { self.players }
    }
end

function Rendering:addRenderable(layer, renderable)
    if not self.renderingLayers[layer] then
        self.renderingLayers[layer] = {}
    end

    table.insert(self.renderingLayers[layer], renderable)
end

function Rendering:update(dt)
    self.interface:update(dt)
    self.camera:update(dt)
    self.players:update(dt)
end

function Rendering:render()
    self.interface:render()

    self.camera:translate()

    for depth, layer in pairs(self.renderingLayers) do
        for k, renderable in pairs(layer) do
            renderable:render()
        end
    end
end