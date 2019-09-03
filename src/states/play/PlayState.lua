require 'lib/state/State'

require 'src/states/play/level/Level'
require 'src/states/play/level/Camera'
require 'src/states/play/interface/Interface'
Timer = require 'lib/util/knife/timer'

PlayState = Class{__includes = State}

function PlayState:enter(params)
    gLevel = Level(self)
    self.interface = Interface(self)
end

function PlayState:update(dt)
    Timer.update(dt)
    gLevel:update(dt)
    self.interface:update(dt)
end

function PlayState:render()
    gLevel:render()
    self.interface:render()
end