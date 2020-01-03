Camera = Class{}

function Camera:init(speed)
    self.entity = {x = 0, y = 0}
    self.speed = speed
    self.x = 0
    self.y = 0
    self.dx = 0
    self.dy = 0
    self.zoom = 1.25

    self.center = {
        x = love.graphics.getWidth() / 2 * self.zoom,
        y = love.graphics.getHeight() / 2 * self.zoom
    }
end

function Camera:follow(entity)
    self.entity = entity
    self.x, self.y = self:getEntityCenter(entity)
end

function Camera:getEntityCenter(entity)
    local x = (entity.x - self.center.x)
    local y = (entity.y - self.center.y)

    return x, y
end

function Camera:update(dt)
    local x, y = self:getEntityCenter(self.entity)

    self:move(self.speed, x, y)
end

function Camera:move(speed, dx, dy)
    local dx = math.max(0, dx)
    local dy = math.max(0, dy)

    Timer.tween(speed, {
        [self] = {
            x = dx,
            y = dy
        }
    })
end

function Camera:set()
    love.graphics.push()
    love.graphics.scale(1 / self.zoom, 1 / self.zoom)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:unset()
    love.graphics.pop()
end

function Camera:coordinates()
    return Coordinates(self.x, self.y)
end

function Camera:worldCoordinates(cursorX, cursorY)
    return cursorX * self.zoom + self.x, cursorY * self.zoom + self.y
end