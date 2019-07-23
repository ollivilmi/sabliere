Tool = Class{}

-- def
--
-- image
-- cursor type
-- cooldown
-- gcd
-- range
function Tool:init(def)
    self.quad = def.image
    self.cursor = def.cursor
    self.action = def.action
end

function Tool:update(dt)

end

function Tool:render(x,y)
    love.graphics.draw(gTextures.ui.tools, self.quad, x, y)
end