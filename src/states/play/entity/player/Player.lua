require 'src/states/play/entity/AnimationState'

require 'src/states/play/entity/AnimatedEntity'
require 'src/states/play/entity/player/state/PlayerFallingState'
require 'src/states/play/entity/player/state/PlayerIdleState'
require 'src/states/play/entity/player/state/PlayerJumpingState'
require 'src/states/play/entity/player/state/PlayerMovingState'

Player = Class{__includes = AnimatedEntity}

function Player:init(level)
    AnimatedEntity:init(self,
    { 
        x = MAP_WIDTH / 2,
        y = MAP_HEIGHT - 300,
        width = 50,
        height = 100,
        speed = 200,
        level = level,
        stateMachine = StateMachine {
            idle = PlayerIdleState(self),
            moving = PlayerMovingState(self),
            jumping = PlayerJumpingState(self),
            falling = PlayerFallingState(self)
        },
        animationState = StateMachine {
            idle = AnimationState({1}, 1, self),
            moving = AnimationState({2, 3}, 0.2, self),
            jumping = AnimationState({4}, 1, self),
            falling = AnimationState({5}, 1, self)
        },
        sheet = gTextures.player,
        sounds = {
            jump = gSounds.player.jump
        }
    }
)
end