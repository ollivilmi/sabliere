require 'lib/game/StateMachine'

require 'src/client/states/play/PlayState'

Game = StateMachine {
    play = PlayState()
}

return Game