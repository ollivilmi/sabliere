require 'lib/state/State'

FallingState = Class{__includes = State}

function FallingState:init(entity)
    self.entity = entity
end

function FallingState:update(dt)
    self.entity.dy = self.entity.dy + GRAVITY

    local tile = self.entity.collider:bottomTile()

    if tile ~= nil then
        self.entity.dy = 0
        self.entity.collider.y = tile.y - 1 - self.entity.collider.height

        if self.entity.dx ~= 0 then
            self.entity:changeState('moving')
        else
            self.entity:changeState('idle')
        end
    else
        self:input()

        if self.entity.dx > 0 then
            self.entity.collider:collidesRight()
        else
            self.entity.collider:collidesLeft()
        end
    end
end