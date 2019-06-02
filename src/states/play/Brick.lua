Brick = Class{__includes = Collision}

function Brick:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.health = 1
    self.broken = false
end

function Brick:update(dt)
end

function Brick:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Brick:destroy()
    if self.width <= 10 or self.height <= 10 then
        return
    end

    self.broken = true
end