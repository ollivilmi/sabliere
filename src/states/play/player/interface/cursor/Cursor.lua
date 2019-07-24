-- Superclass for cursors
require 'src/states/play/player/interface/Component'

Cursor = Class{}

function Cursor:getPosition() end
function Cursor:render() end
function Cursor:update(dt) end

function Cursor:updateCoordinates()
    self.x, self.y = self:currentCoordinates()
end

function Cursor:currentCoordinates()
    local x = (love.mouse.getX() * RESOLUTION_SCALE) + gCamera.x
    local y = (love.mouse.getY() * RESOLUTION_SCALE) + gCamera.y

    return x,y
end

function Cursor:componentCoordinates()
    return love.mouse.getX() * RESOLUTION_SCALE, love.mouse.getY() * RESOLUTION_SCALE
end

function Cursor:hoversComponent(component)
    self.hoveringComponent = nil

    for k,c in pairs(component) do
        if not love.mouse.isDown(1) and c.area:hasPoint(self:componentCoordinates()) then
            if c.components ~= nil and table.getn(c.components) > 0 then
                self:hoversComponent(c.components)
            else
                self.hoveringComponent = c
            end
        end
    end
end