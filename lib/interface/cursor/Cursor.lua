-- Superclass for cursors
require 'lib/interface/Component'

Cursor = Class{}

function Cursor:getPosition() end
function Cursor:update(dt) end

function Cursor:init(self, def)
    self.ui = { x = 0, y = 0 }
    self.world = { x = 0, y = 0 }
    self.snap = def.snap or false
    self.action = def.action or function() end
    self.cursor = def.cursor    
end

function Cursor:update(self)
    self.world.x, self.world.y = self:worldCoordinates(self.snap)
    self:uiCoordinates()

    if self.hoveringComponent ~= nil and love.mouse.wasPressed(1) then
        self.hoveringComponent.onClick()
    end
end

function Cursor:uiCoordinates()
    -- used when tile snapping is needed
    self.ui.x = self.world.x - gCamera.x
    self.ui.y = self.world.y - gCamera.y
end

function Cursor:worldCoordinates(snap)
    local x = love.mouse.getX() * RESOLUTION_SCALE
    local y = love.mouse.getY() * RESOLUTION_SCALE
    
    x, y = gCamera:worldCoordinates(x,y)

    if snap then
        x, y = tilemath.snap(x, y)
    end

    return x,y
end

function Cursor:coordinates()
    return love.mouse.getX() * RESOLUTION_SCALE, love.mouse.getY() * RESOLUTION_SCALE
end

-- Checks whether cursor is hovering over a UI component.
-- if UI component has subcomponents, recursively checks them for the final result
function Cursor:hoversComponent(component)
    self.hoveringComponent = nil

    for k,c in pairs(component) do
        if not love.mouse.isDown(1) and c.area:hasPoint(self:coordinates()) then
            if c.components ~= nil and table.getn(c.components) > 0 then
                self:hoversComponent(c.components)
            else
                self.hoveringComponent = c
            end
        end
    end
end

function Cursor:isHovering()
    return self.hoveringComponent ~= nil and not love.mouse.isDown(1)
end

function Cursor:render(self, cursor)
    love.graphics.setColor(0,0,0)
    if self:isHovering() then
        self.hoveringComponent:renderEdges(0,0,0)
        -- todo render hovering cursor
    else
        cursor()
    end
end