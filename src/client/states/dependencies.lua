require 'src/client/states/StateMachine'

-- order of the dependencies matters. it's a bit of a pasta situation..
require 'src/client/states/play/PlayState'

gStateMachine = {}

function initStateMachine()
    gStateMachine = StateMachine {
        play = PlayState()
    }
    gStateMachine:change('play')
end