Icon = Class{}

function Icon:init(texture, quad, scale)
    self.scale = scale or BUTTON_SCALE
    self.texture = texture
    self.quad = quad
end

function Icon:render(x, y)
    love.graphics.draw(self.texture, self.quad, x, y, 0, self.scale, self.scale)
end