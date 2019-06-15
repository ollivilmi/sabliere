require 'src/states/play/lib/physics/Collision'

Kinematic = Class{__includes = Collision}

function Kinematic:applyDeltas(dt)
    if not self.grounded then
        self.dy = self.dy + GRAVITY * dt
        self.y = self.y + self.dy
    end

    if self.dx ~= 0 then
        self.x = self.x + self.dx * dt
    end

    self:initHitboxes()
end

function Kinematic:jump()
    if self.grounded then
        self.dy = -GRAVITY/4
        self.y = self.y - 5
        self.grounded = false
        return true
    end
    return false
end

function Kinematic:applyCollision(target)
    self.cRight = false
    self.cLeft = false
    self.cBot = false
    self.cTop = false

    if self:collidesRight(target) then
        self.dx = math.min(0, self.dx)
        self.x = target.x - self.width
        self.cRight = true
    elseif self:collidesLeft(target) then
        self.dx = math.max(0, self.dx)
        self.x = target.x + target.width
        self.cLeft = true
    end

    if self:collidesBottom(target) then
        self.dy = math.min(0, self.dy)
        self.grounded = true
        self.cBot = true
    elseif self:collidesTop(target) then
        self.dy = math.max(0, self.dy)
        self.cTop = true
    end
end