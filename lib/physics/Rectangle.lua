Rectangle = Class{}

function Rectangle:init(x, y, width, height, collidable)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.map = {
        x = self.x / TILE_SIZE + 1, -- addition because tables are 1 indexed
        y = self.y / TILE_SIZE + 1,
    }
end

function Rectangle:render()
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end