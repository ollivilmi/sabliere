Camera = Class{}

function Camera:init(speed)
    self.entity = {x = 0, y = 0}
    self.speed = speed
    self.x = 0
    self.y = 0
    self.dx = 0
    self.dy = 0
    self.zoom = 1.2

    self.center = {
        x = love.graphics.getWidth() / 2 * self.zoom,
        y = love.graphics.getHeight() / 2 * self.zoom
    }
end

function Camera:setZoom(zoom)
    self.zoom = zoom

    self.center = {
        x = love.graphics.getWidth() / 2 * self.zoom,
        y = love.graphics.getHeight() / 2 * self.zoom
    }
end

function Camera:follow(entity)
    self.entity = entity
    local x, y = math.rectangleCenter(entity)

    self.x = math.max(0, x - self.center.x)
    self.y = math.max(0, y - self.center.y)
end

function Camera:update(dt)
    local x, y = math.rectangleCenter(self.entity)

    self:move(self.speed, x - self.center.x, y - self.center.y)
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

function Camera:worldCoordinates(x, y)
    return x * self.zoom + self.x, y * self.zoom + self.y
end

function Camera:worldToUi(x, y)
    return (x - self.x) / self.zoom , (y - self.y) / self.zoom 
end