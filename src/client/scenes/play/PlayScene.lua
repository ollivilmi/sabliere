require 'lib/game/State'
require 'src/client/scenes/play/rendering/Rendering'
require 'src/client/scenes/play/entity/player/PlayerController'
require 'src/client/scenes/play/rendering/interface/InterfaceController'

PlayScene = Class{__includes = State}

function PlayScene:init(game)
    self.client = game.client
    self.gameState = game.client.state

    self.rendering = Rendering(self.gameState)

    -- Move player, open menu, etc..
    self.controls = {}

    self.client:addListener('CONNECTED', function()
        self.client.updates:pushDuplex(Data{request = 'connectPlayer'})
    end)

    self.client:addListener('SNAPSHOT', function()
        local playerEntity = self.gameState.level.players:getEntity(self.client.status.id)

        if playerEntity then
            -- keymap could be loaded from server, that's why it's a constructor parameter
            local keymap = require 'src/client/scenes/play/entity/player/settings/Keymap'

            self.controls.player = PlayerController(playerEntity, keymap)
            self.controls.interface = InterfaceController(self.rendering, keymap)

            -- To periodically send updates to server
            self.client.updates:pushEntity(self.client.status.id, playerEntity)
            self.rendering.camera:follow(playerEntity)
        end
    end)
end

function PlayScene:enter()
    Gui = self.rendering.interface.gui
end

function PlayScene:update(dt)
    self.rendering:update(dt)

    for _, control in pairs(self.controls) do
        control:update(dt)
    end
end

function PlayScene:render()
    self.rendering:render()
end