require 'lib/game/State'

JumpingState = Class{__includes = State}

function JumpingState:init(entity)
    self.entity = entity
end

function JumpingState:enter(params)
    self.entity.dy = -self.entity.weight * 0.3
end

function JumpingState:update(dt)
    self.entity.dy = self.entity.dy + self.entity.weight * dt

    if self.entity.dy > 0 then
        self.entity:changeState('falling')
    end
end

function JumpingState:collisions(collisions)
    for __, col in pairs(collisions) do
        if col.other.isTile then
            -- top collision
            if col.normal.y == 1 then
                self.entity.dy = 0
            end

            -- prevent sticking to walls
            if col.normal.x ~= 0 then
                self.entity.x = self.entity.x + col.normal.x
            end
        end
    end
end