require 'src/client/scenes/play/rendering/level/BackgroundRendering'
require 'src/client/scenes/play/rendering/level/PlayerRendering'
require 'src/client/scenes/play/rendering/level/TilemapRendering'

require 'src/client/scenes/play/rendering/Camera'
require 'src/client/scenes/play/rendering/interface/Interface'

-- Wraps GameState level for animations and stuff
Rendering = Class{}

function Rendering:init(level)
    self.level = level

    self.camera = Camera(1)

    self.background = BackgroundRendering()
    self.tilemap = TilemapRendering(self.level.tilemap)
    self.players = PlayerRendering(self.level.players)

    self.interface = Interface(game)

    self.renderingLayers = {
        { self.background }, -- to add: background, background tiles?
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
    self.camera:update(dt)
    self.players:update(dt)
end

function Rendering:render()
    self.camera:set()

    for depth, layer in pairs(self.renderingLayers) do
        for k, renderable in pairs(layer) do
            renderable:render()
        end
    end

    self.camera:unset()
    self.interface:render()
end