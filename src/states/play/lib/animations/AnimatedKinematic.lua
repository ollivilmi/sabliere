require 'src/states/play/lib/physics/Kinematic'
require 'src/states/play/lib/animations/Animation'

AnimatedKinematic = Class{__includes = Kinematic}

function AnimatedKinematic:loadSheet(sheet)
    self.sheet = sheet
    self.quads = GenerateQuads(self.sheet, 50, 100)
    self.animations = {
        idle = Animation {
            frames = {1},
            interval = 1
        },
        moving = Animation {
            frames = {2, 3},
            interval = 0.2
        },
        jump = Animation {
            frames = {4},
            interval = 1
        },
        fall = Animation {
            frames = {5},
            interval = 1
        }
    }
    self.animation = self.animations.idle
    self.direction = 'right'
end

function AnimatedKinematic:updateAnimation(dt)
    if self.dx ~= 0 and self.grounded then
        self.animation = self.animations.moving
        if self.dx > 0 then
            self.direction = 'right'
        else
            self.direction = 'left'
        end

    elseif not self.grounded then
        if self.dy < 0 then
            self.animation = self.animations.jump
        else
            self.animation = self.animations.fall
        end

    else
        self.animation = self.animations.idle
    end
    
    self.animation:update(dt)
end

function AnimatedKinematic:animate()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.sheet, self.quads[self.animation:get()], 

    -- X and Y we draw at need to be shifted by half our width and height because we're setting the origin
    -- to that amount for proper scaling, which reverse-shifts rendering
    math.floor(self.x) + self.width / 2, math.floor(self.y) + self.height / 2, 

    -- 0 rotation, then the X and Y scales
    0, self.direction == 'left' and -1 or 1, 1,

    -- lastly, the origin offsets relative to 0,0 on the sprite (set here to the sprite's center)
    self.width / 2, self.height / 2)
end