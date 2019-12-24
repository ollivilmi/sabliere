require 'lib/game/State'
require 'src/client/states/play/entity/player/PlayerEntity'

PlayState = Class{__includes = State}

function PlayState:enter(client)
    self.gameState = client.state

    self.gameState.level:loadAssets()

    self.id = client.id

    client:connect()
    -- gInterface = Interface(self)
end

function PlayState:update(dt)
    self.gameState:update(dt)
    -- gInterface:update(dt)
end

function PlayState:render()
    self.gameState.level:render()
    -- gInterface:render()
end