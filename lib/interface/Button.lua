require 'lib/interface/Component'
-- Superclass

Button = Class{__includes = Component}

-- def
--
-- quad
-- cooldown
-- gcd
function Button:init(self, def)
    Component:init(self, def)
    self.quad = def.quad
    self.action = def.action
end

function Button:onClick()
    self:action()
end

function Button:render()
    love.graphics.draw(gTextures.ui.tools, self.quad, self.area.x, self.area.y, 
    0, BUTTON_SCALE, BUTTON_SCALE)
end