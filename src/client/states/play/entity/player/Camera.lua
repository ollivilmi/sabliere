Camera = Class{}

function Camera:init(speed, offset)
    self.speed = speed
    self.entity = {x = 0, y = 0}
    self.offset = offset
    self.x = 0
    self.y = 0
    self.dx = 0
    self.dy = 0
    self.maxWidth = 20000
    self.maxHeight = 10000
end

function Camera:follow(entity)
    self.entity = entity
    self.x = entity.x - love.graphics.getWidth() / 2
    self.y = entity.y - love.graphics.getHeight() / 2
end

function Camera:update(dt)
    if not love then return end
    -- bound between 0 - maxWidth
    self.x = math.min(self.maxWidth, math.max(0, self.x + self.dx * dt))
    -- bound between 0 - maxHeight
    self.y = math.min(self.maxHeight, math.max(0, self.y + self.dy * dt))

    local x = self.entity.x - love.graphics.getWidth() / 2
    local y = self.entity.y - love.graphics.getHeight() / 2

    local distance = math.floor(math.distance(x, y, self.x, self.y))

    if distance > self.offset then
        -- vector of camera (x,y) -> target (x,y) adjusted by speed
        self.dx, self.dy = math.vector(self.x, self.y, x, y)
        self.dx = self.dx * self.speed
        self.dy = self.dy * self.speed
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
    return Coordinates(self.x, self.y)
end

function Camera:worldCoordinates(x,y)
    return x + self.x, y + self.y
end