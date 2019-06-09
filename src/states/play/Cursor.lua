Cursor = Class{__includes = Collision}

function Cursor:init(radius)
    self.radius = radius
    self.minRadius = radius
end

function Cursor:update(dt)
    if love.mouse.wheelmoved ~= 0 then
        self.radius = math.max(self.minRadius, love.mouse.wheelmoved > 0 and self.radius + 2 or self.radius - 2)
    end
end

-- TODO: switch mode between destroy to build
function Cursor:switchMode()
end

function Cursor:render()
    local x, y = push:toGame(love.mouse.getX(), love.mouse.getY())
    love.graphics.circle('line', x, y, self.radius)
end