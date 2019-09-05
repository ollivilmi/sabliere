require 'src/states/play/entity/AnimationState'
require 'src/states/play/entity/AnimatedEntity'


TargetDummy = Class{__includes = AnimatedEntity}

function TargetDummy:init(x, y)
    AnimatedEntity:init(self,
    { 
        x = MAP_WIDTH / 2,
        y = MAP_HEIGHT - 500,
        width = 50,
        height = 100,
        speed = 200,
        movementState = StateMachine {
            idle = IdleState(self),
            moving = MovingState(self),
            jumping = JumpingState(self),
            falling = FallingState(self)
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
    })
end