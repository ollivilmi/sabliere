require 'lib/game/State'
require 'src/client/scenes/play/rendering/Rendering'
require 'src/client/scenes/play/player/Controls'

PlayScene = Class{__includes = State}

function PlayScene:init()
    self:loadInterface()
    self:loadControls()
    self:playerConnectionSettings()
end

function PlayScene:loadInterface()
    self.rendering = Rendering()
end

function PlayScene:loadControls()
    local hotkeys = require 'src/client/scenes/menu/settings/Hotkeys'
    self.controls = Controls(hotkeys:load(), self.rendering.interface)
end

function PlayScene:playerConnectionSettings()
    -- Tell the server we want an entity to control
    --
    -- if we are spectating, we may want to make this optional
    --
    -- (todo: press button to spectate or join as player)
    Game.client:addListener('CONNECTED', function()
        Game.client.updates:pushDuplex(Data{request = 'connectPlayer'})
    end)

    Game.client:addListener('CONNECTION TIMED OUT', function()
        Game.scene:changeState('loading', Game.client:connect())
    end)
end

function PlayScene:enter()
    Gui = self.rendering.interface.gui
end

function PlayScene:update(dt)
    self.controls:update(dt)
    self.rendering:update(dt)

    if love.keyboard.wasPressed('escape') then
        Game.client:setDisconnected()
        Game.scene:changeState('menu')
    end
end

function PlayScene:render()
    self.rendering:render()
end