Camera = Class{__includes = Kinematic}

function Camera:init(speed, entity, offset)
    self.speed = speed
    self.entity = entity.collider.tileCollider
    self.offset = offset
    self.x, self.y = math.rectangleCenter(self.entity)

    self.dx = 0
    self.dy = 0
    self.maxWidth = MAP_WIDTH - VIRTUAL_WIDTH
    self.maxHeight = MAP_HEIGHT - VIRTUAL_HEIGHT
end

function Camera:update(dt)
    -- bound between 0 - maxWidth
    self.x = math.min(self.maxWidth, math.max(0, self.x + self.dx * dt))
    -- bound between 0 - maxHeight
    self.y = math.min(self.maxHeight, math.max(0, self.y + self.dy * dt))

    local x, y = self.entity:getCenter()
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