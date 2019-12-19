require 'src/network/state/entity/state/IdleState'

PlayerIdleState = Class{__includes = IdleState}

function PlayerIdleState:input()
    if love.keyboard.isDown(gKeymap.move.left) or love.keyboard.isDown(gKeymap.move.right) then
        self.entity:changeState('moving')
    elseif love.keyboard.isDown(gKeymap.move.jump) then
        self.entity:changeState('jumping')
    end
end