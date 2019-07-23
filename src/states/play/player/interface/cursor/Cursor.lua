-- Interface for cursors

Cursor = Class{}

function Cursor:getPosition() end
function Cursor:render() end
function Cursor:update(dt) end
function Cursor:updateCoordinates()
    self.x, self.y = self:currentCoordinates()
end
function Cursor:currentCoordinates()
    local x = (love.mouse.getX()*RESOLUTION_SCALE) + gCamera.x
    local y = (love.mouse.getY()*RESOLUTION_SCALE) + gCamera.y

    return x,y
end

-- on hovering ui, change cursor to clicking cursor