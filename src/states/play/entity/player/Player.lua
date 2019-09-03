require 'src/states/play/entity/AnimationState'

require 'src/states/play/entity/AnimatedEntity'
require 'src/states/play/entity/player/state/PlayerFallingState'
require 'src/states/play/entity/player/state/PlayerIdleState'
require 'src/states/play/entity/player/state/PlayerJumpingState'
require 'src/states/play/entity/player/state/PlayerMovingState'

Player = Class{__includes = AnimatedEntity}

function Player:init(x, y)
    AnimatedEntity:init(self,
    { 
        x = x,
        y = y,
        width = 50,
        height = 100,
        speed = 200,
        movementState = StateMachine {
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
    })
    local x, y = math.rectangleCenter(self.collider)
    self.toolRange = Circle(x, y, 0)
    table.insert(self.components, self.toolRange)

    self.canShoot = true
end

-- rest of input is state based
function Player:input()
    if love.keyboard.isDown(gKeymap.ability.shoot) then
        if self.canShoot then
            self.canShoot = false
            gLevel:spawnBullet(self)
            Timer.after(0.2, function() self.canShoot = true end)
        end
    end
end