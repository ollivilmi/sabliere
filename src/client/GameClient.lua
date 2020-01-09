require 'lib/game/StateMachine'
require 'src/client/settings/Settings'

require 'src/client/scenes/menu/MenuScene'
require 'src/client/scenes/loading/LoadingScene'
require 'src/client/scenes/play/PlayScene'

GameClient = Class{}

function GameClient:init(client)
    self.client = client
    self.state = client.state
    self.settings = Settings()

    self.metrics = {
        fps = 0,
        connection = self.client.status
    }
end

function GameClient:load()
    self.scene = StateMachine {
        menu = MenuScene(),
        loading = LoadingScene(),
        play = PlayScene(),
    }

    self.scene:changeState('menu')
end

function GameClient:update(dt)
    self.client:update(dt)
    self.scene:update(dt)
    self.settings.input.clear()

    self.metrics.fps = love.timer.getFPS()
end

function GameClient:render()
    self.scene:render()
end
