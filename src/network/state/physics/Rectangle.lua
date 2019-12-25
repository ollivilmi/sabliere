Rectangle = Class{}

function Rectangle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function Rectangle:render()
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end