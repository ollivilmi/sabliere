Camera = Class{__includes = Kinematic}

function Camera:init(speed, objectToFollow, offset)
    self.speed = speed
    self.objectToFollow = objectToFollow
    self.offset = offset
    self.x, self.y = objectToFollow:getCenter()
end

function Camera:update(dt)
    self.x, self.y = self.objectToFollow:getCenter()
    self.x = math.floor(self.x)
    self.y = math.floor(self.y)
end

function Camera:render()
    love.graphics.translate(-self.x, -self.y)
end