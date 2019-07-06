Camera = Class{__includes = Kinematic}

function Camera:init(speed, objectToFollow, offset)
    self.speed = speed
    self.objectToFollow = objectToFollow
    self.offset = offset
    self.x, self.y = objectToFollow:getCenter()
    self.dx = 0
    self.dy = 0
end

function Camera:update(dt)
    self.x = self.x + self.dx
    self.y = self.y + self.dy

    local x, y = self.objectToFollow:getCenter()
    
    x = math.floor(x)
    y = math.floor(y)

    -- basically we take the vector of camera (x,y) -> target (x,y)
    -- and then adjust speed
    if math.floor(math.distance(x,y,self.x,self.y)) > self.offset then
        self.dx = math.floor((x - self.x)*self.speed)
        self.dy = math.floor((y - self.y)*self.speed)
    else
        self.dx = 0
        self.dy = 0
    end
end

function Camera:render()
    love.graphics.translate(-self.x, -self.y)
end