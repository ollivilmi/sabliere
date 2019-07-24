require 'src/states/play/player/interface/cursor/Cursor'
require 'src/states/play/lib/physics/Collision'

RectangleCursor = Class{__includes = Cursor, Rectangle}

function RectangleCursor:init(action)
    self:reset()
    self.action = action
end

function RectangleCursor:reset()
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
end

-- for square cursor, we will snap to nearest block divisible by MINIMUM_TILE_SIZE
-- needs to be updated for other directions
function RectangleCursor:getPosition()
    local x = self.width < 0 and self.x + self.width or self.x
    local y = self.height < 0 and self.y + self.height or self.y
    return Collision(x, y, math.abs(self.width), math.abs(self.height))
end

function RectangleCursor:update(dt)
    if love.mouse.wasPressed(1) then
        self:updateCoordinates()
        self.x, self.y = tilemath.snap(self.x, self.y)
    end

    if love.mouse.wasReleased(1) then
        self.action(self:getPosition())
    end

    if love.mouse.isDown(1) then
        local x, y = self:currentCoordinates()
        x, y = tilemath.snap(x, y)

        self.width = math.floor(x - self.x)
        self.height = math.floor(y - self.y)
    else
        self:updateCoordinates()
        self.x, self.y = tilemath.snap(self.x, self.y)
        self.width = 2
        self.height = 2
    end
end

function RectangleCursor:render()
    love.graphics.setColor(0,0,0)
    if self.hoveringComponent ~= nil then
        self.hoveringComponent:renderEdges(0,0,0)
    else
        love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    end
end