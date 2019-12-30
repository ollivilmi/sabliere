require 'lib/game/StateMachine'
require 'src/client/settings/Settings'
require 'src/client/states/play/PlayState'
require 'src/client/states/loading/LoadingState'

Game = Class{}

function Game:init(client)
    self.client = client

    self.settings = Settings()

    self.state = StateMachine {
        play = PlayState(self),
        loading = LoadingState(self)
    }
    -- todo settings..
end

function Game:update(dt)
    self.client:update(dt)
    self.state:update(dt)

    self.settings.input.clear()
end

function Game:render()
    self.settings.graphics.render(self.state)
end
