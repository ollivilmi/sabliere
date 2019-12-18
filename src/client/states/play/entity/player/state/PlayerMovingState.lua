require 'src/client/states/play/entity/state/MovingState'

PlayerMovingState = Class{__includes = MovingState}

function PlayerMovingState:input()
    if love.keyboard.isDown(gKeymap.move.jump) then
        self.entity:changeState('jumping')
    
    elseif love.keyboard.isDown(gKeymap.move.left) then
        self.entity.dx = -self.entity.speed
    
    elseif love.keyboard.isDown(gKeymap.move.right) then
        self.entity.dx = self.entity.speed
    
    else
        self.entity.dx = 0
        self.entity:changeState('idle')
    end

end