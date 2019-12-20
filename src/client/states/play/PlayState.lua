require 'lib/game/State'

PlayState = Class{__includes = State}

function PlayState:enter(params)
    self.gameState = params.state
    self.id = params.id

    self.player = Entity{x = 100, y = 100, width = 50, height = 100}
    params:connect(self.player)

    -- gInterface = Interface(self)
end

function PlayState:update(dt)
    -- gInterface:update(dt)
end

function PlayState:render()
    self.gameState.level:render()
    -- gInterface:render()
end