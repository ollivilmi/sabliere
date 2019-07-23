Tool = Class{}

-- def
--
-- image
-- cursor type
-- cooldown
-- gcd
-- range
function Tool:init(def)
    self.quad = def.quad
    self.cursor = def.cursor
    self.action = def.action
end

function Tool:update(dt)

end

function Tool:render(x,y)
    love.graphics.draw(gTextures.ui.tools, self.quad, x, y, 0, TOOLBAR_SCALE, TOOLBAR_SCALE, TOOL_SIZE/2, TOOL_SIZE/2)
end