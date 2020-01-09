require 'src/client/scenes/play/rendering/level/BackgroundRendering'
require 'src/client/scenes/play/rendering/level/PlayerRendering'
require 'src/client/scenes/play/rendering/level/TilemapRendering'

require 'src/client/scenes/play/rendering/Camera'
require 'src/client/scenes/play/rendering/interface/Interface'
require 'src/client/scenes/play/rendering/interface/AbilityRendering'

-- Wraps GameState level for animations and stuff
Rendering = Class{}

function Rendering:init()
    self.level = Game.state.level

    Camera = Camera(1)

    Game.client:addListener('PLAYER CONNECTED', function(player)
        Camera:follow(player)
    end)

    self.background = BackgroundRendering()
    self.tilemap = TilemapRendering(self.level.tilemap)
    self.players = PlayerRendering(self.level.players)

    self.interface = Interface()

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
    Camera:update(dt)
    self.players:update(dt)
end

function Rendering:render()
    Camera:set()

    for depth, layer in pairs(self.renderingLayers) do
        for k, renderable in pairs(layer) do
            renderable:render()
        end
    end

    Camera:unset()
    self.interface:render()
end