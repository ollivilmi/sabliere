require 'src/states/play/Collision'

Kinematic = Class{__includes = Collision}

function Kinematic:applyDeltas(dt)
    if not self.grounded then
        self.dy = self.dy + GRAVITY * dt
        self.y = self.y + self.dy
    end

    if self.y > VIRTUAL_HEIGHT - self.height then
        self.grounded = true
    end

    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Kinematic:jump()
    if self.grounded then
        self.dy = -GRAVITY/4
        self.grounded = false
    end
end