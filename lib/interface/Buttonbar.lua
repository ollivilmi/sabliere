require 'lib/physics/Rectangle'
require 'lib/interface/Component'

-- Superclass

Buttonbar = Class{__includes = Component}

function Buttonbar:init(self, def)
    Component:init(self, def)
    self.area = BoxCollider(
        def.x,
        def.y,
        self.count * BUTTONBAR_SIZE,
        BUTTONBAR_SIZE
    )
end

function Buttonbar:render(self)
    local x = self.area.x
    local y = self.area.y

    love.graphics.setColor(1,1,1)
    for i = 1, self.count do
        love.graphics.draw(gTextures.ui.toolbar, x, y, 0, BUTTON_SCALE, BUTTON_SCALE)
        x = x + BUTTONBAR_SIZE
    end

    for k,component in pairs(self.components) do
        component:render()
    end

    love.graphics.setColor(0,0,0)
end

