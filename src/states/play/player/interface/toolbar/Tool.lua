Tool = Class{__includes = Component}

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
    self.area = def.area

    self.visible = true
end

function Tool:render()
    love.graphics.draw(gTextures.ui.tools, self.quad, self.area.x + gCamera.x, self.area.y
     + gCamera.y, 0, TOOLBAR_SCALE, TOOLBAR_SCALE)
end