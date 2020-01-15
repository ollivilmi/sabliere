require 'src/client/scenes/play/rendering/level/BackgroundRendering'
require 'src/client/scenes/play/rendering/level/PlayerRendering'
require 'src/client/scenes/play/rendering/level/LevelRendering'

require 'src/client/scenes/play/rendering/Camera'
require 'src/client/scenes/play/rendering/interface/Interface'
require 'src/client/scenes/play/rendering/interface/AbilityRendering'

-- Wraps GameState for animations and stuff
Rendering = Class{}

function Rendering:init()
    Camera = Camera(1)

    self.background = BackgroundRendering()
    self.level = LevelRendering(Game.state.level)
    self.players = PlayerRendering(Game.state.players)

    self.interface = Interface()

    self.renderingLayers = {
        { self.background },
        { self.level },
        { self.players }
    }

    Game.client:addListener('PLAYER CONNECTED', function(player)
        Camera:follow(player)
        self.interface.healthbar:load(player)
    end)
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

    for z, layer in pairs(self.renderingLayers) do
        for k, renderable in pairs(layer) do
            renderable:render()
        end
    end

    Camera:unset()
    self.interface:render()
end