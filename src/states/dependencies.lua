require 'src/states/PlayState'
require 'src/states/StateMachine'

gStateMachine = {}

function initStateMachine()
    gStateMachine = StateMachine {
        play = function() return PlayState() end
    }
    gStateMachine:change('play')
end