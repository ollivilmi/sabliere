require 'lib/game/State'

FallingState = Class{__includes = State}

function FallingState:init(entity)
    self.entity = entity
end

function FallingState:update(dt)
    self.entity.dy = self.entity.dy + (self.entity.weight * dt)
end

function FallingState:collisions(collisions)
    for __, col in pairs(collisions) do
        if col.type == 'slide' then
            -- ground collision
            if col.normal.y == -1 then
                self.entity.dy = 0

                if self.entity.dx ~= 0 then
                    self.entity:changeState('moving')
                else
                    self.entity:changeState('idle')
                end
            end

            -- prevent sticking to walls
            if col.normal.x ~= 0 then
                self.entity.x = self.entity.x + col.normal.x
            end
        end
    end
end