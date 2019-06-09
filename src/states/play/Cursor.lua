Cursor = Class{__includes = Collision}

function Cursor:init(radius)
    self.radius = radius
    self.minRadius = radius
    self.x = 0
    self.y = 0
end

function Cursor:update(dt)
    if love.mouse.wheelmoved ~= 0 then
        self.radius = math.max(self.minRadius, love.mouse.wheelmoved > 0 and self.radius + 2 or self.radius - 2)
    end

    self.x, self.y = push:toGame(love.mouse.getX(), love.mouse.getY())
end

-- TODO: switch mode between destroy to build
function Cursor:switchMode()
end

function Cursor:render()
    love.graphics.circle('line', self.x, self.y, self.radius)
end