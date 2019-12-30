require 'lib/game/State'
require 'src/client/states/play/rendering/LevelRendering'
require 'src/client/states/play/entity/player/PlayerController'

PlayState = Class{__includes = State}

function PlayState:init(game)
    self.game = game
    self.client = game.client
    self.gameState = self.client.state

    self.levelRendering = LevelRendering(self.gameState.level)

    -- Move player, open menu, etc..
    self.controls = {}

    self.client:addListener('SNAPSHOT', function()
        local playerEntity = self.gameState.level.players:getEntity(self.client.id)

        if playerEntity then
            -- keymap could be loaded from server, that's why it's a constructor parameter
            local keymap = require 'src/client/states/play/entity/player/settings/Keymap'

            self.controls.player = PlayerController(playerEntity, keymap)
            
            -- To periodically send updates to server
            self.client.updates:pushEntity(self.client.id, playerEntity)
            self.levelRendering.camera:follow(playerEntity)
        end
    end)
end

function PlayState:enter()
    -- gInterface = Interface(self)
end

function PlayState:update(dt)
    self.levelRendering:update(dt)
    -- gInterface:update(dt)
    for _, control in pairs(self.controls) do
        control:update(dt)
    end
end

function PlayState:render()
    self.levelRendering:render()
    -- gInterface:render()
end