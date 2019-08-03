-- Superclass for cursors
require 'lib/interface/Component'

Cursor = Class{}

function Cursor:getPosition() end
function Cursor:update(dt) end

function Cursor:init(self, def)
    self.ui = Coordinates()
    self.world = Coordinates()
    self.snap = def.snap or false
    self.action = def.action or function() end
    self.ignoringUi = def.ignoringUi or false
end

function Cursor:update(self)
    self:updateCoordinates(self)

    if self:uiActive() then
        self:uiInput()
    else
        self:input()
    end
end

function Cursor:updateCoordinates(child)
    child.world = child:worldCoordinates(child.snap)
    child.ui = child:worldToUi()
end

function Cursor:uiInput()
    if love.mouse.wasPressed(1) then
        self.uiComponent.onClick()
    end
end

-- must be implemented in child
function Cursor:input() end

function Cursor:worldCoordinates(snap)
    local x = love.mouse.getX() * RESOLUTION_SCALE
    local y = love.mouse.getY() * RESOLUTION_SCALE
    
    x, y = gCamera:worldCoordinates(x,y)

    if snap then
        x, y = tilemath.snap(x, y)
    end

    return Coordinates(x,y)
end

-- When a cursor implements snapping, we cannot rely on real coordinates
function Cursor:worldToUi()
    local x = self.world.x - gCamera.x
    local y = self.world.y - gCamera.y

    return Coordinates(x,y)
end

function Cursor:coordinates()
    return Coordinates(love.mouse.getX() * RESOLUTION_SCALE, love.mouse.getY() * RESOLUTION_SCALE)
end

-- Checks whether cursor is hovering over a UI component.
-- if UI component has subcomponents, recursively checks them for the final result
function Cursor:mouseover(component)
    self.uiComponent = nil

    for k,c in pairs(component) do
        if not self.ignoringUi and c.area:hasPoint(self:coordinates()) then
            -- check if hovers child components
            if c.components ~= nil and table.getn(c.components) > 0 then
                self:mouseover(c.components)

            -- no more children left, return
            else
                self.uiComponent = c
                return
            end

            -- cursor does not hover child components, return
            if self.uiComponent == nil then
                self.uiComponent = c
                return
            end
        end
    end
end

function Cursor:uiActive()
    return not self.ignoringUi and self.uiComponent ~= nil
end

function Cursor:render(self, cursor)
    love.graphics.setColor(0,0,0)
    if self:uiActive() then
        self.uiComponent.onHover()
        -- todo render hovering cursor
    else
        cursor()
    end
end