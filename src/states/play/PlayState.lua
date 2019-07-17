require 'src/states/play/lib/settings/Keymap'
require 'src/states/play/player/Player'
require 'src/states/play/level/Level'
require 'src/states/play/level/Camera'
require 'src/states/play/player/interface/Toolbar'

PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.toolbar = Toolbar(self)
    self.player = Player(self)
    self.level = Level(self)
    gCamera = Camera(0.01, self.player, 150)
end

function PlayState:update(dt)
    self.player:update(dt)
    gCamera:update(dt)
    self.level:update(dt)
    self.toolbar:update(dt)    
end

function PlayState:render()
    gCamera:render()

    self.level:render()
    self.player:render()
    self.toolbar:render()

    love.graphics.setFont(gFonts['small'])
    love.graphics.print('grounded: ' .. (self.player.grounded and 1 or 0), VIRTUAL_WIDTH - 60, 5)
    love.graphics.print('grounded: ' .. (self.player.grounded and 1 or 0), VIRTUAL_WIDTH - 60, 5)
end