-- Superclass for cursors
require 'src/client/scenes/play/interface/hud/Component'

Cursor = Class{}

function Cursor:getPosition() end
function Cursor:update(dt) end

function Cursor:init(self, def)
    -- coordinates
    self.ui = Coordinates()
    self.world = Coordinates()

    -- snap to tilemap
    self.snap = def.snap or false
    self.action = def.action or function() end
    
    -- we do not want to trigger mouseover ui
    self.ignoringUi = def.ignoringUi or false

    -- we do not want to update coordinates in edge cases such as
    -- drawing rectangles
    self.updatingCoordinates = def.updatingCoordinates or true
    
    -- set to false if we want to prevent input
    self.inRange = def.inRange or true
end

function Cursor:update(self)
    if self.updatingCoordinates then
        self:updateCoordinates(self)
    end

    if self:uiActive() then
        self:uiInput()
    else
        self.inRange = self:inRangeOfPlayer()
        self:input()
    end
end

function Cursor:inRangeOfPlayer()
    return gPlayer.toolRange:hasPoint(self.world.x, self.world.y)
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
            if c.components and table.getn(c.components) > 0 then
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
    if self.inRange then
        love.graphics.setColor(0,0,0,0.6)
    else
        love.graphics.setColor(0,0,0,0.1)
    end
    if self:uiActive() then
        self.uiComponent.onHover()
        -- todo render hovering cursor
    else
        cursor()
    end
end