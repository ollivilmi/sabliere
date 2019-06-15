require 'src/states/BaseState'

require 'src/states/play/PlayState'
require 'src/states/StateMachine'

gStateMachine = {}

function initStateMachine()
    gStateMachine = StateMachine {
        play = function() return PlayState() end
    }
    gStateMachine:change('play')
end