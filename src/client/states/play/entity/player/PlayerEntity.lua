require 'src/client/states/play/entity/AnimatedEntity'

require 'src/client/states/play/entity/player/input/EntityControls'

-- Basically a wrapper to control Entity and follow it with camera
PlayerEntity = Class{}

function PlayerEntity:init(animatedEntity, keymap)
    self.entity = animatedEntity.entity
    self.animatedEntity = animatedEntity
    
    self.movementControls = EntityControls(keymap.move, animatedEntity.entity)
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
    self.animatedEntity:update(dt)
    self:input()
end

function PlayerEntity:render()
    self.animatedEntity:render()
end