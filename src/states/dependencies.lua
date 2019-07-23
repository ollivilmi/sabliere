require 'src/states/BaseState'
require 'src/states/StateMachine'

-- Libraries
require 'src/states/play/lib/settings/Keymap'
require 'src/states/play/player/cursor/objects/Cursors'
require 'src/states/play/player/interface/objects/Tools'

-- order of the dependencies matters. it's a bit of a pasta situation..
require 'src/states/play/PlayState'

gStateMachine = {}

function initStateMachine()
    gStateMachine = StateMachine {
        play = function() return PlayState() end
    }
    gStateMachine:change('play')
end