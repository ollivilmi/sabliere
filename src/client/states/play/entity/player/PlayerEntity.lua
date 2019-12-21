require 'lib/game/StateMachine'

require 'src/client/states/play/entity/AnimationState'
require 'src/client/states/play/entity/AnimatedEntity'

require 'src/client/states/play/entity/player/input/EntityMovement'

PlayerEntity = Class{}

function PlayerEntity:init(def)
    self.entity = Entity(
        { 
            x = def.x,
            y = def.y,
            width = 50,
            height = 100,
            speed = 200,
        },
        def.level
    )

    local sheet = 'src/client/assets/textures/dude.png'

    self.animation = AnimatedEntity(self.entity, {
        animationState = StateMachine {
            idle = AnimationState({1}, 1, self.entity, sheet),
            moving = AnimationState({2, 3}, 0.2, self.entity, sheet),
            jumping = AnimationState({4}, 1, self.entity, sheet),
            falling = AnimationState({5}, 1, self.entity, sheet)
        }
    })
    
    self.movementControls = EntityMovement(def.keymap.move, self.entity)
    -- self.interface = interface
    self.canShoot = true
end

function PlayerEntity:input()
    self.movementControls:update()

    -- if love.keyboard.isDown(self.keymap.ability.shoot) then
    --     if self.canShoot then
    --         self.canShoot = false
    --         self.level.projectiles:spawnBullet(
    --             self, 
    --             self.interface.cursor:worldCoordinates()
    --         )
    --         Timer.after(0.2, function() self.canShoot = true end)
    --     end
    -- end
end

function PlayerEntity:update(dt)
    self.entity:update(dt)
    self.animation:update(dt)
    self:input()
end

function PlayerEntity:render()
    self.animation:render()
end