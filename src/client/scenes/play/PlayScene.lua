require 'lib/game/State'
require 'src/client/scenes/play/rendering/Rendering'
require 'src/client/scenes/play/player/Controls'

PlayScene = Class{__includes = State}

function PlayScene:init(game)
    self.client = game.client
    self.gameState = game.client.state

    self.rendering = Rendering(self.gameState)

    local keymap = require 'src/client/scenes/play/settings/Keymap'
    self.controls = Controls(keymap, self.rendering)

    self.client:addListener('CONNECTED', function()
        self.client.updates:pushDuplex(Data{request = 'connectPlayer'})
    end)

    self.client:addListener('SNAPSHOT', function()
        local playerEntity = self.gameState.level.players:getEntity(self.client.status.id)

        if playerEntity then
            self.controls:controlEntity(playerEntity)
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
    self.controls:update(dt)
    self.rendering:update(dt)
end

function PlayScene:render()
    self.rendering:render()
end