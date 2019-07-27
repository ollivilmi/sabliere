require 'src/states/play/player/Player'
require 'src/states/play/level/Level'
require 'src/states/play/level/Camera'
require 'src/states/play/player/interface/Interface'

PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.player = Player(self)
    self.level = Level(self)
    self.interface = Interface(self)

    gCamera = Camera(0.01, self.player, 150)
end

function PlayState:update(dt)
    gCamera:update(dt)
    self.player:update(dt)
    self.level:update(dt)
    self.interface:update(dt)
end

function PlayState:render()
    -- should be wrapped in World class
    gCamera:translate()
    self.level:render()
    self.player:render()

    -- should be wrapped in Interface class
    gCamera:reverse()
    self.interface:render()
end