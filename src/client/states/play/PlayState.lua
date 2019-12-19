require 'lib/game/State'

PlayState = Class{__includes = State}

function PlayState:enter(params)
    self.gameState = params.state
    -- gInterface = Interface(self)
end

function PlayState:update(dt)
    -- gInterface:update(dt)
end

function PlayState:render()
    self.gameState.level:render()
    -- gInterface:render()
end