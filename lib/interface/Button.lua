require 'lib/interface/Component'
require 'lib/interface/Icon'
require 'lib/interface/EmptyIcon'

-- Superclass

Button = Class{__includes = Component}

function Button:init(self, def)
    Component:init(self, def)
    self.icon = def.icon or EmptyIcon(0.5, 0.5, 0.5)
    self.action = def.action 
    self.onClick = def.onClick or function() end
    self.onHover = function() self:renderEdges(0,0,0) end
end

function Button:onClick()
    self:onClick()
end

function Button:render()
    self.icon:render(self.area.x, self.area.y)
end