require 'src/states/play/entity/state/FallingState'

PlayerFallingState = Class{__includes = FallingState}

function PlayerFallingState:input()
    if love.keyboard.isDown(gKeymap.move.left) then
        self.entity.dx = -self.entity.speed
    elseif love.keyboard.isDown(gKeymap.move.right) then
        self.entity.dx = self.entity.speed
    else
        self.entity.dx = 0
    end
end