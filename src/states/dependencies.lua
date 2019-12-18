require 'lib/game/state/StateMachine'

-- order of the dependencies matters. it's a bit of a pasta situation..
require 'src/states/play/PlayState'

gStateMachine = {}

function initStateMachine()
    gStateMachine = StateMachine {
        play = PlayState()
    }
    gStateMachine:change('play')
end