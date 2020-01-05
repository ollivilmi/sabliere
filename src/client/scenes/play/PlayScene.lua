require 'lib/game/State'
require 'src/client/scenes/play/rendering/Rendering'
require 'src/client/scenes/play/player/Controls'

PlayScene = Class{__includes = State}

function PlayScene:init(game)
    self.game = game
    self.client = game.client
    self.gameState = game.client.state
    
    self:loadInterface()
    self:loadControls()
    self:playerConnectionSettings()
end

function PlayScene:loadInterface()
    self.rendering = Rendering(self.gameState.level)
    self.rendering.interface.stats:add('ping', self.game.metrics.connection)
    self.rendering.interface.stats:add('fps', self.game.metrics)
end

function PlayScene:loadControls()
    local keymap = require 'src/client/scenes/play/settings/Keymap'
    self.controls = Controls(keymap, self.rendering)
end

function PlayScene:playerConnectionSettings()
    -- Tell the server we want an entity to control
    --
    -- if we are spectating, we may not want this
    --
    self.client:addListener('CONNECTED', function()
        self.client.updates:pushDuplex(Data{request = 'connectPlayer'})
    end)

    -- Server sends a snapshot of gamestate upon connection,
    -- and upon some intervals to ensure game state is correct
    --
    self.client:addListener('SNAPSHOT', function()
        local playerEntity = self.gameState.level.players:getEntity(self.client.status.id)

        if playerEntity then
            -- Take control of player entity
            self.controls:controlEntity(playerEntity)
            -- Periodically send updates to server
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

    if love.keyboard.wasPressed('escape') then
        self.client:setDisconnected()
        self.game.scene:changeState('menu')
    end
end

function PlayScene:render()
    self.rendering:render()
end