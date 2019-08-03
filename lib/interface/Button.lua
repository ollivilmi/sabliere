require 'lib/interface/Component'
-- Superclass

Button = Class{__includes = Component}

function Button:init(self, def)
    Component:init(self, def)
    self.quad = def.quad
    self.action = def.action
    self.onClick = def.onClick
    self.onHover = function() self:renderEdges(0,0,0) end
end

function Button:onClick()
    self:onClick()
end

function Button:render()
    love.graphics.draw(gTextures.ui.tools, self.quad, self.area.x, self.area.y, 
    0, BUTTON_SCALE, BUTTON_SCALE)
end