require 'lib/state/State'

FallingState = Class{__includes = State}

function FallingState:init(entity)
    self.entity = entity
end

function FallingState:update(dt)
    self.entity:gravity(dt)

    local tile = self.entity:bottomTile()

    if tile ~= nil then
        self.entity.dy = 0
        self.entity.y = tile.y - 1 - self.entity.height

        if self.entity.dx ~= 0 then
            self.entity:changeState('moving')
        else
            self.entity:changeState('idle')
        end
    else
        self:input()

        if self.entity.dx > 0 then
            self.entity:collidesRight()
        else
            self.entity:collidesLeft()
        end
    end
end