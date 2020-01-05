require 'lib/game/StateMachine'
require 'src/client/scenes/play/entity/models/Model'

-- has to be a function to construct a new Model.
-- (Cannot animate entities sharing the same sheet + animationState)
local playerModels = {
    dude = function()
        return Model{
        sheet = 'src/client/assets/textures/entity/dude.png',
        width = 50,
        height = 100,
        animationStates = {
            idle = { frames = {1}, interval = 1},
            moving = { frames = {2, 3}, interval = 0.2 },
            jumping = { frames = {4}, interval = 1},
            falling = { frames = {5}, interval = 1}
        }
    }
    end
}

return playerModels