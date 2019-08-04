require 'lib/physics/BoxCollider'

Kinematic = Class{__includes = BoxCollider}

function Kinematic:applyDeltas(dt)
    local y = self.dy + GRAVITY * dt
    local x = self.dx * dt

    if not self.grounded then
        self.dy = y
        self.y = self.y + self.dy
    else
        y = 0
    end

    if self.dx ~= 0 then
        self.x = self.x + x
    end

    self:updateHitboxes(self.x, self.y)
end

function Kinematic:jump()
    if self.grounded then
        self.dy = -GRAVITY/2
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
        self.y = math.floor(self.y)
        self.grounded = true
        self.cBot = true
    elseif self:collidesTop(target) then
        self.dy = math.max(0, self.dy)
        self.cTop = true
    end
end