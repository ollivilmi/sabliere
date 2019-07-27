Camera = Class{__includes = Kinematic}

function Camera:init(speed, objectToFollow, offset)
    self.speed = speed
    self.objectToFollow = objectToFollow
    self.offset = offset
    self.x, self.y = objectToFollow:getCenter()
    self.dx = 0
    self.dy = 0
    self.maxWidth = MAP_WIDTH - VIRTUAL_WIDTH
    self.maxHeight = MAP_HEIGHT - VIRTUAL_HEIGHT
end

function Camera:update(dt)
    self.x = math.min(self.maxWidth, math.max(0, self.x + self.dx))
    self.y = math.min(self.maxHeight, math.max(0,self.y + self.dy))

    local x, y = self.objectToFollow:getCenter()
    
    x = math.floor(x)
    y = math.floor(y)

    -- basically we take the vector of camera (x,y) -> target (x,y)
    -- and then adjust speed
    if math.floor(math.distance(x,y,self.x,self.y)) > self.offset then
        self.dx, self.dy = self:vector(x, y, self.speed)
    else
        self.dx = 0
        self.dy = 0
    end
end

function Camera:translate()
    love.graphics.translate(-self.x, -self.y)
end

function Camera:reverse()
    love.graphics.translate(self.x, self.y)
end

function Camera:coordinates()
    return self.x, self.y
end

function Camera:worldCoordinates(x,y)
    return x + self.x, y + self.y
end

function Camera:vector(x, y, speed)
    local speed = speed or 1

    -- if equal, return a zero vector
    if x == self.x and y == self.y then
        return 0,0
    end

    local x = math.floor((x - self.x) * speed)
    local y = math.floor((y - self.y) * speed)

    return x, y
end