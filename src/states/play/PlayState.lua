require 'lib/state/State'

require 'src/states/play/level/Level'
require 'src/states/play/level/Camera'
require 'src/states/play/interface/Interface'

PlayState = Class{__includes = State}

function PlayState:enter(params)
    self.level = Level(self)
    self.interface = Interface(self)
end

function PlayState:update(dt)
    self.level:update(dt)
    self.interface:update(dt)
end

function PlayState:render()
    self.level:render()
    self.interface:render()
end