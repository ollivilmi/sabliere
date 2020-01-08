require 'lib/game/State'

MovingState = Class{__includes = State}

function MovingState:init(entity)
    self.entity = entity
end

function MovingState:update(dt)
    if self.entity.dx > 0 then
        self.entity.direction = 'right'
    else
        self.entity.direction = 'left'
    end

    self.entity:checkGround()
end

function MovingState:collisions(collisions)
    for __, col in pairs(collisions) do
        if col.other.isTile then
            -- prevent sticking to walls
            if col.normal.x ~= 0 then
                self.entity.x = self.entity.x + col.normal.x
            end
        end
    end
end