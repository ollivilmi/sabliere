require 'lib/state/StateMachine'

-- Libraries
require 'src/states/play/interface/cursor/objects/Cursors'
require 'src/states/play/interface/toolbar/objects/Tools'

-- order of the dependencies matters. it's a bit of a pasta situation..
require 'src/states/play/PlayState'

gStateMachine = {}

function initStateMachine()
    gStateMachine = StateMachine {
        play = PlayState()
    }
    gStateMachine:change('play')
end