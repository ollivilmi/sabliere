require 'lib/game/State'
require 'src/client/states/play/entity/player/PlayerEntity'

PlayState = Class{__includes = State}

function PlayState:enter(params)
    self.gameState = params.state

    self.gameState.level:loadAssets()

    self.id = params.id

    self.player = PlayerEntity{
        x = 100,
        y = 100,
        level = self.gameState.level,
        -- keymap could be loaded from server, that's why it's a constructor parameter
        keymap = require 'src/client/states/play/entity/player/settings/Keymap'
    }
    
    self.gameState.level.players[self.id] = self.player

    params:connect(self.player.entity:getPrimitives())
    -- gInterface = Interface(self)
end

function PlayState:update(dt)
    self.gameState.level:update(dt)
    -- gInterface:update(dt)
end

function PlayState:render()
    self.gameState.level:render()
    -- gInterface:render()
end