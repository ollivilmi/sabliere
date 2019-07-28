require 'lib/physics/Rectangle'
require 'lib/interface/Component'

-- Superclass

Bar = Class{__includes = Component}

-- Assumes that bar consists of components of same type (most importantly size)
function Bar:init(self, def)
    Component:init(self, def)
    self.columns = def.columns
    self.rows = def.rows
    self.area = BoxCollider(
        def.x,
        def.y,
        BAR_SIZE * self.columns,
        BAR_SIZE * self.rows
    )
end

function Bar:render(self)
    love.graphics.setColor(1,1,1)
    
    local y = self.area.y

    for i = 1, self.rows do
        local x = self.area.x

        for j = 1, self.columns do
            love.graphics.draw(gTextures.ui.bar, x, y, 0, self.scale, self.scale)
            x = x + BAR_SIZE
        end
        y = y + BAR_SIZE
    end

    for k,component in pairs(self.components) do
        component:render()
    end

    love.graphics.setColor(0,0,0)
end

