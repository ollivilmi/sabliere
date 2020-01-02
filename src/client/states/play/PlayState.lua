require 'lib/game/State'
require 'src/client/states/play/rendering/Rendering'
require 'src/client/states/play/entity/player/PlayerController'

PlayState = Class{__includes = State}

function PlayState:init(game)
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
            local keymap = require 'src/client/states/play/entity/player/settings/Keymap'

            self.controls.player = PlayerController(playerEntity, keymap)
            
            -- To periodically send updates to server
            self.client.updates:pushEntity(self.client.status.id, playerEntity)
            self.rendering.camera:follow(playerEntity)
        end
    end)
end

function PlayState:enter()
end

function PlayState:update(dt)
    self.rendering:update(dt)

    for _, control in pairs(self.controls) do
        control:update(dt)
    end
end

function PlayState:render()
    self.rendering:render()
end