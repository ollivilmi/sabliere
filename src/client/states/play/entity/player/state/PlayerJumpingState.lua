require 'src/network/state/entity/state/JumpingState'

PlayerJumpingState = Class{__includes = JumpingState}

function PlayerJumpingState:input()
    if love.keyboard.isDown(gKeymap.move.left) then
        self.entity.dx = -self.entity.speed
    elseif love.keyboard.isDown(gKeymap.move.right) then
        self.entity.dx = self.entity.speed
    else
        self.entity.dx = 0
    end
end