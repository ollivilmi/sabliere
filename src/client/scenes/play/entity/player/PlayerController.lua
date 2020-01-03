require 'src/client/scenes/play/entity/AnimatedEntity'

require 'src/client/scenes/play/entity/player/input/EntityControls'

-- Basically a wrapper to control Entity and follow it with camera
PlayerController = Class{}

function PlayerController:init(entity, keymap)
    self.movementControls = EntityControls(keymap.move, entity)
    -- self.interface = interface
    self.canShoot = true
end

function PlayerController:input()
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

function PlayerController:update(dt)
    self:input()
end