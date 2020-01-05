require 'lib/game/StateMachine'
require 'src/client/settings/Settings'

require 'src/client/scenes/menu/MenuScene'
require 'src/client/scenes/loading/LoadingScene'
require 'src/client/scenes/play/PlayScene'

Game = Class{}

function Game:init(client)
    self.client = client
    self.settings = Settings()

    self.scene = StateMachine {
        menu = MenuScene(self),
        loading = LoadingScene(self),
        play = PlayScene(self),
    }

    self.client:addListener('CONNECTION TIMED OUT', function()
        self.scene:changeState('loading', self.client:connect())
    end)
end

function Game:update(dt)
    self.client:update(dt)
    self.scene:update(dt)
    self.settings.input.clear()
end

function Game:render()
    self.settings.graphics.render(self.scene)
end
