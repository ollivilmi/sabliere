-- Interface for cursors

Cursor = Class{}

function Cursor:getPosition() end
function Cursor:render() end
function Cursor:update(dt) end
function Cursor:updateCoordinates()
    self.x = (love.mouse.getX()*RESOLUTION_SCALE) + gCamera.x
    self.y = (love.mouse.getY()*RESOLUTION_SCALE) + gCamera.y
end