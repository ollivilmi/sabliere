EmptyIcon = Class{}

function EmptyIcon:init(r, g, b, size)
    self.r = r or 1
    self.g = g or 1
    self.b = b or 1
    self.size = scale or BUTTON_SIZE
end

function EmptyIcon:render(x, y)
    love.graphics.setColor(self.r, self.g, self.b)
    love.graphics.rectangle('fill', x, y, self.size, self.size)
end