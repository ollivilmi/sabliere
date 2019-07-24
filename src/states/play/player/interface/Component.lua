Component = Class{}

function Component:init(def)
    self.area = def.area
    self.components = def.components
end

function Component:toggleVisibility()
    self.visible = not self.visible
end

function Component:renderEdges(r,g,b)
    love.graphics.setColor(r,g,b)
    love.graphics.rectangle('line', self.area.x + gCamera.x, self.area.y + gCamera.y, self.area.width, self.area.height)
    love.graphics.setColor(1,1,1)
end

function Component:renderMask(alpha)
    love.graphics.setColor(0,0,0,alpha)
    love.graphics.rectangle('fill', self.area.x + gCamera.x, self.area.y + gCamera.y, self.area.width, self.area.height)
    love.graphics.setColor(1,1,1)
end

-- Component render border()