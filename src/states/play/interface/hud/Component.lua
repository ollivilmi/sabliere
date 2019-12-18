-- Superclass

Component = Class{}

function Component:init(self, def)
    self.visible = true
    self.area = def.area
    self.components = def.components
    self.count = def.components ~= nil and table.getn(self.components) or 0
    self.scale = def.scale or 1
    self.onHover = def.onHover or function() end
    self.onClick = def.onClick or function() end
end

function Component:toggleVisibility()
    self.visible = not self.visible
end

function Component:renderEdges(r,g,b)
    love.graphics.setColor(r,g,b)
    love.graphics.rectangle('line', self.area.x, self.area.y, self.area.width, self.area.height)
    love.graphics.setColor(1,1,1)
end

function Component:renderMask(alpha)
    love.graphics.setColor(0,0,0,alpha)
    love.graphics.rectangle('fill', self.area.x, self.area.y, self.area.width, self.area.height)
    love.graphics.setColor(1,1,1)
end

-- Component render border()