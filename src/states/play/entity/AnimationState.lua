require 'lib/game/state/State'

AnimationState = Class{__includes = State}

function AnimationState:init(frames, interval, entity)
    self.frames = frames
    self.interval = interval
    self.timer = 0
    self.currentFrame = 1
    self.entity = entity
end

function AnimationState:update(dt)
    -- no need to update if AnimationState is only one frame
    if #self.frames > 1 then
        self.timer = self.timer + dt

        if self.timer > self.interval then
            self.timer = self.timer % self.interval

            self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))
        end
    end
end

function AnimationState:render()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.entity.sheet, self.entity.quads[self.frames[self.currentFrame]], 

    -- X and Y we draw at need to be shifted by half our width and height because we're setting the origin
    -- to that amount for proper scaling, which reverse-shifts rendering
    math.floor(self.entity.x) + self.entity.width / 2, math.floor(self.entity.y) + self.entity.height / 2, 

    -- 0 rotation, then the X and Y scales
    0, self.entity.direction == 'left' and -1 or 1, 1,

    -- lastly, the origin offsets relative to 0,0 on the sprite (set here to the sprite's center)
    self.entity.width / 2, self.entity.height / 2)
end